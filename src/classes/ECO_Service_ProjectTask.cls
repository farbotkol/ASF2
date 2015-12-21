public class ECO_Service_ProjectTask{
    
    private list<Id> projectTaskIds;
    public map<string,EarnedValueSnapshot__c> earnedvaluemap{get;set;}
    public map<string,EarnedValueTask__c> earnedvaluetaskmap{get;set;}
    public ECO_Service_ProjectTask(list<Id> snapshotProjectTaskIds)
    {
        projectTaskIds = snapshotProjectTaskIds;    
        earnedvaluemap = new map<string,EarnedValueSnapshot__c>();
        earnedvaluetaskmap = new map<string,EarnedValueTask__c>();
        for(EarnedValueTask__c e: [select id,TaskTotalApprovedCostSnapshot__C,EarnedValue__c,ProjectTask__c from EarnedValueTask__c where ProjectTask__c IN :projectTaskIds and  SnapshotDate__c <= today order by SnapshotDate__c,createddate desc] ){
            if(earnedvaluetaskmap.containskey(e.ProjectTask__c))
            earnedvaluetaskmap.put(e.ProjectTask__c,e);
        }
        for(EarnedValueSnapshot__c e:[select id,ThisWeekAmount__c,ProjectTask__c,ProjectTask__r.EarnedValue__c,ProjectTask__r.TotalApprovedCost__c,WeekStartDate__c from EarnedValueSnapshot__c where   ProjectTask__c IN :projectTaskIds and WeekStartDate__c <=today order by WeekStartDate__c,createddate desc ]){
            if(earnedvaluemap.containskey(e.ProjectTask__c))
                earnedvaluemap.put(e.ProjectTask__c,e);
        }
    }
    
    public ECO_Service_ProjectTask(Id snapshotProjectTaskId)
    {
        projectTaskIds = new list<Id>();
        projectTaskIds.add(snapshotProjectTaskId);
        earnedvaluemap = new    map<string,EarnedValueSnapshot__c>();
         earnedvaluetaskmap = new map<string,EarnedValueTask__c>();
        for(EarnedValueTask__c e: [select id,TaskTotalApprovedCostSnapshot__C,ProjectTask__c,EarnedValue__c from EarnedValueTask__c where ProjectTask__c = :snapshotProjectTaskId and  SnapshotDate__c <= today order by SnapshotDate__c,createddate desc] ){
            if(earnedvaluetaskmap.containskey(e.ProjectTask__c))
            earnedvaluetaskmap.put(e.ProjectTask__c,e);
        }
        for(EarnedValueSnapshot__c e:[select id,ThisWeekAmount__c,ProjectTask__c,ProjectTask__r.EarnedValue__c,ProjectTask__r.TotalApprovedCost__c,WeekStartDate__c from EarnedValueSnapshot__c where   ProjectTask__c = :snapshotProjectTaskId and WeekStartDate__c <=today order by WeekStartDate__c,createddate desc ]){
            if(earnedvaluemap.containskey(e.ProjectTask__c))
                earnedvaluemap.put(e.ProjectTask__c,e);
        }
    }
        
    public List<pse__Project_Task__c> getProjectTasks()
    {
        
        List<pse__Project_Task__c> tasks = null;

        try {
            
            List<pse__Time_Period__c> timePeriods = ECO_ProjectTaskService.calcTimePeriods;
            
            Map<String,AggregateResult> originalBudget = getOriginalBudgetInformation();
            Map<String,AggregateResult> currentBudget = getCurrentBudgetInformation();
            Map<String,AggregateResult> forecastBudget = getForecastBudgetInformation(timePeriods);
            
            Date threeMonthsAgoFiscalEndDate = getMonthEndDate3FiscalMonthsAgo(timePeriods);
            Map<String,AggregateResult> ITD3Months = getITD3Months(threeMonthsAgoFiscalEndDate);
            
            tasks = [select Id,MetricsDate__c,
                            RevenueBudgetOriginal__c,  // ok
                            RevenueBudgetCurrent__c,  // select TotalRevenue__c from BudgetTask where and BudgetHeader__r.status=approved   
                            CostBudgetOriginal__c,   // ok
                            CostPrevMTD__c,         // ok 
                            CostMTD__c,             //ok
                            TotalForecastCostPrevME__c,         //Select TotalForecastCost__c from BudgetTask where BudgetHeader.Status=forecast and BudgetHeader.date is in previous fiscal month or earlier
                            EarnedValue__c,                     // ???
   							CPI__c,
                            MonthEndDate3FiscalMonthsAgo__c,
                            CostITD3FiscalMonthEndsAgo__c,
                            EndDateFiscalMonth__c,
                            EndDatePreviousFiscalMonth__c
                        from pse__Project_Task__c 
                        where Id = : projectTaskIds];
                        
            List<String> months = new List<String>();
            for (pse__Project_Task__c pt : tasks){
                if (!String.isBlank(pt.EndDateFiscalMonth__c)){
                    months.add(pt.EndDateFiscalMonth__c);
                }
                if (!String.isBlank(pt.EndDatePreviousFiscalMonth__c)){
                    months.add(pt.EndDatePreviousFiscalMonth__c);
                }
            } 
                
            Map<String, AggregateResult> costMTD = getCostMTDInformation(months);
           
            for (pse__Project_Task__c pt : tasks){
                if(originalBudget.containskey(pt.Id))
                pt.RevenueBudgetOriginal__c = (Decimal) originalBudget.get(pt.Id).get('totalRevenue');
                if(currentBudget.containskey(pt.Id))
                pt.RevenueBudgetCurrent__c = (Decimal) currentBudget.get(pt.Id).get('totalRevenue');
                if(originalBudget.containskey(pt.Id))
                pt.CostBudgetOriginal__c = (Decimal) originalBudget.get(pt.Id).get('totalCost');
                if(costMTD.containskey(pt.Id + pt.EndDatePreviousFiscalMonth__c))
                {
                    pt.CostPrevMTD__c = (Decimal) costMTD.get(pt.Id + pt.EndDatePreviousFiscalMonth__c).get('totalCost');                
                    pt.CostMTD__c = (Decimal) costMTD.get(pt.Id + pt.EndDateFiscalMonth__c).get('totalCost');
                }
                if(forecastBudget.containskey(pt.Id))
                pt.TotalForecastCostPrevME__c = (Decimal) forecastBudget.get(pt.Id).get('totalCost');
                pt.EarnedValue__c = null;
                pt.MonthEndDate3FiscalMonthsAgo__c = threeMonthsAgoFiscalEndDate;
                 if(ITD3Months.containskey(pt.Id))
                pt.CostITD3FiscalMonthEndsAgo__c =  (Decimal) ITD3Months.get(pt.Id).get('totalCost');
                if(earnedvaluemap.containskey(pt.id))
                    pt.PlannedCost__c = earnedvaluetaskmap.get(pt.id).TaskTotalApprovedCostSnapshot__C;
                if(earnedvaluemap.containskey(pt.id))
                    pt.PlannedValue__c = earnedvaluemap.get(pt.id).ThisWeekAmount__c;
                if(earnedvaluemap.containskey(pt.id))
                   pt.EarnedValue__c = earnedvaluetaskmap.get(pt.id).EarnedValue__c;
                pt.MetricsDate__c = date.today();
                 
            } 
            
        } catch (Exception e) {
            system.debug('e---------'+e);
            System.debug(e.getStackTraceString());
        }
        return tasks;
    }
    
    private Map<String, AggregateResult> getOriginalBudgetInformation() {
    
        try {
            List<AggregateResult> results = [SELECT     ProjectTask__c, 
                                                        SUM(TotalRevenue__c)totalRevenue, 
                                                        SUM(TotalCost__c)totalCost 
                                                        FROM BudgetTask__c 
                                                        WHERE BudgetHeader__r.OriginalBudget__c = true 
                                                        AND ProjectTask__c IN :projectTaskIds
                                                        GROUP BY ProjectTask__c]; 
           
            Map<String, AggregateResult> out = new Map<String, AggregateResult>();
            for (AggregateResult ar : results){
                out.put((String)ar.get('ProjectTask__c'), ar);
            }
            return out;
           
        } catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }   
        return null;
    }
    
    private Map<String,AggregateResult> getCurrentBudgetInformation() {
        try {
            List<AggregateResult> results = [SELECT     ProjectTask__c, 
                                                        SUM(TotalRevenue__c)totalRevenue
                                                        FROM BudgetTask__c 
                                                        WHERE BudgetHeader__r.Status__c = 'Approved' 
                                                        AND ProjectTask__c IN :projectTaskIds
                                                        GROUP BY ProjectTask__c]; 
           
            Map<String, AggregateResult> out = new Map<String, AggregateResult>();
            for (AggregateResult ar : results){
                out.put((String)ar.get('ProjectTask__c'), ar);
            }
            return out;
           
        } catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }   
        return null;
    }
    
    private Map<String, AggregateResult> getCostMTDInformation(List<String> months) {
        
        try {
            
            List<AggregateResult> results = [SELECT     ProjectTask__c,
                                                        WeeklyRollupEntry__r.FiscalMonth__c,
                                                        SUM(AcctBurdenedCost__c)totalCost
                                                        FROM EarnedValueSnapshot__c
                                                        WHERE ProjectTask__c IN :projectTaskIds
                                                        AND WeeklyRollupEntry__r.FiscalMonth__c IN :months
                                                        GROUP BY ProjectTask__c, WeeklyRollupEntry__r.FiscalMonth__c]; 
           
            Map<String, AggregateResult> out = new Map<String, AggregateResult>();
            for (AggregateResult ar : results){
                out.put((String)ar.get('ProjectTask__c')  + (String)ar.get('FiscalMonth__c'), ar);
            }
            return out;
           
        } catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }   
        return null;
    }
    
    private Map<String, AggregateResult> getEarnedValueInformation(List<String> months) {
        
        try {
            /*
            if(evHeaders.size() > 0){
                
                if(snapshots.size() > 0)
                {
                    //earnedValueController = new ECO_EarnedValueReportController(evHeaders[0].Id);
                
                    list<AggregateResult> earnedValueTasks = [SELECT    ProjectTask__c,
                                                                        MAX(SnapshotDate__c)snapshotDate
                                                                 FROM EarnedValueTask__c
                                                                 WHERE ProjectTask__c = : projectTaskIds
                                                                 GROUP BY ProjectTask__c];
                    //list<EarnedValueSnapshot__c> snapshots = [SELECT Id, WeekStartDate__c FROM EarnedValueSnapshot__c WHERE WeekStartDate__c <= TODAY AND ProjectTask__r.pse__Project__c = :snapshotProjectId order by WeekStartDate__c desc];
                    if(earnedValueTasks.size() > 0)
                    {
                        EarnedValueSnapshotDate = earnedValueTasks[0].SnapshotDate__c;
                        EarnedValueLastModifiedDate = earnedValueTasks[0].LastModifiedDate;
                    }
                }
            }*/
            
            List<AggregateResult> results = [SELECT     ProjectTask__c,
                                                        WeeklyRollupEntry__r.FiscalMonth__c,
                                                        SUM(AcctBurdenedCost__c)totalCost
                                                        FROM EarnedValueSnapshot__c
                                                        WHERE ProjectTask__c IN :projectTaskIds
                                                        AND WeeklyRollupEntry__r.FiscalMonth__c IN :months
                                                        GROUP BY ProjectTask__c, WeeklyRollupEntry__r.FiscalMonth__c]; 
           
            Map<String, AggregateResult> out = new Map<String, AggregateResult>();
            for (AggregateResult ar : results){
                out.put((String)ar.get('ProjectTask__c')  + (String)ar.get('FiscalMonth__c'), ar);
            }
            return out;
           
        } catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }   
        return null;
    }
    
    private Map<String, AggregateResult> getForecastBudgetInformation(List<pse__Time_Period__c> timePeriods) {
    
        try {
            Date now = Date.Today();
            Date previousFMEndDate = null;
            
            pse__Time_Period__c previousFM = ECO_Utils_Date.getFiscalPeriod(now, 1, timePeriods); 
            if (previousFM != null){
                previousFMEndDate = previousFM.pse__End_Date__c;  
            }
                                                    
            List<AggregateResult> results = [SELECT     ProjectTask__c, 
                                                        SUM(TotalForecastCost__c)totalCost 
                                                        FROM BudgetTask__c 
                                                        WHERE ProjectTask__c IN :projectTaskIds
                                                        AND BudgetHeader__r.Status__c = 'Forecast'
                                                        AND BudgetHeader__r.StatusAsOfDate__c <=: previousFMEndDate
                                                        GROUP BY ProjectTask__c]; 
           
            Map<String, AggregateResult> out = new Map<String, AggregateResult>();
            for (AggregateResult ar : results){
                out.put((String)ar.get('ProjectTask__c'), ar);
            }
            return out;
           
        } catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }   
        return null;
    }
    
    private Date getMonthEndDate3FiscalMonthsAgo(List<pse__Time_Period__c> timePeriods) {
    
        try {
            Date now = Date.Today();
            Date returnDate = null;
            
            pse__Time_Period__c threeMonthsAgoFM = ECO_Utils_Date.getFiscalPeriod(now, 3, timePeriods); 
            if (threeMonthsAgoFM != null){
                returnDate = threeMonthsAgoFM.pse__End_Date__c;
            }
            
            return returnDate;
       } catch(Exception e) {
            System.Debug(e.getStackTraceString());
       }   
       return null;
    }
    
     
     private Map<String, AggregateResult> getITD3Months(Date threeMonthsAgoFiscalEndDate) {
    
        try {
                                                    
            List<AggregateResult> results = [SELECT     ProjectTask__c, 
                                                        SUM(ProjectFunctionalBurdenedCost__c)totalCost 
                                                        FROM ExpendItem__c 
                                                        WHERE ProjectTask__c IN :projectTaskIds
                                                        AND ExpenditureItemDate__c <= : threeMonthsAgoFiscalEndDate
                                                        GROUP BY ProjectTask__c]; 
           
            Map<String, AggregateResult> out = new Map<String, AggregateResult>();
            for (AggregateResult ar : results){
                out.put((String)ar.get('ProjectTask__c'), ar);
            }
            return out;
           
        } catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }   
        return null;
    }
    
}