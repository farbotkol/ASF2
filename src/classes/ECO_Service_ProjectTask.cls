public class ECO_Service_ProjectTask{
	
	private list<Id> projectTaskIds;
	
	public ECO_Service_ProjectTask(list<Id> snapshotProjectTaskIds)
	{
		projectTaskIds = snapshotProjectTaskIds;	
	}
	
	public ECO_Service_ProjectTask(Id snapshotProjectTaskId)
	{
		projectTaskIds = new list<Id>();
		projectTaskIds.add(snapshotProjectTaskId);
	}
		
	public List<pse__Project_Task__c> getProjectTasks()
	{
		
		List<pse__Project_Task__c> tasks = null;

		try {
			
			Map<String,AggregateResult> originalBudget = getOriginalBudgetInformation();
			Map<String,AggregateResult> currentBudget = getCurrentBudgetInformation();
			Map<String,AggregateResult> forecastBudget = getForecastBudgetInformation();
			
			tasks = [select Id,
							RevenueBudgetOriginal__c,  // ok
							RevenueBudgetCurrent__c,  // select TotalRevenue__c from BudgetTask where and BudgetHeader__r.status=approved	
							CostBudgetOriginal__c, 	 // ok
							CostPrevMTD__c,			// ok 
							CostMTD__c,				//ok
							TotalForecastCostPrevME__c,			//Select TotalForecastCost__c from BudgetTask where BudgetHeader.Status=forecast and BudgetHeader.date is in previous fiscal month or earlier
							EarnedValue__c,						// ???
							CPI__c,								// ???
							CostITD1FiscalMonthEndAgo__c,
							CostITD2FiscalMonthEndsAgo__c,
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
				pt.RevenueBudgetOriginal__c = (Decimal) originalBudget.get(pt.Id).get('totalRevenue');
				pt.RevenueBudgetCurrent__c = (Decimal) currentBudget.get(pt.Id).get('totalRevenue');
				pt.CostBudgetOriginal__c = (Decimal) originalBudget.get(pt.Id).get('totalCost');
				pt.CostPrevMTD__c = (Decimal) costMTD.get(pt.Id + pt.EndDatePreviousFiscalMonth__c).get('totalCost');
				pt.CostMTD__c = (Decimal) costMTD.get(pt.Id + pt.EndDateFiscalMonth__c).get('totalCost');
				pt.TotalForecastCostPrevME__c = (Decimal) forecastBudget.get(pt.Id).get('totalCost');
				pt.EarnedValue__c = null;
				pt.CPI__c = null;
				pt.CostITD1FiscalMonthEndAgo__c = null;
				pt.CostITD2FiscalMonthEndsAgo__c = null;
				pt.CostITD3FiscalMonthEndsAgo__c = null;
				
			} 
			
		} catch (Exception e) {
			System.debug(e.getStackTraceString());
		}
		return tasks;
	}
	
	private Map<String, AggregateResult> getOriginalBudgetInformation() {
	
        try {
        	List<AggregateResult> results = [SELECT 	ProjectTask__c, 
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
           
        }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }   
        return null;
    }
    
    private Map<String,AggregateResult> getCurrentBudgetInformation() {
 		try {
        	List<AggregateResult> results = [SELECT 	ProjectTask__c, 
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
           
        }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }   
        return null;
    }
    
    private Map<String, AggregateResult> getCostMTDInformation(List<String> months) {
    	
        try {
        	
        	List<AggregateResult> results = [SELECT 	ProjectTask__c,
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
           
        }
        catch(Exception e) {
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
                
                    list<AggregateResult> earnedValueTasks = [SELECT	ProjectTask__c,
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
        	
        	List<AggregateResult> results = [SELECT 	ProjectTask__c,
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
           
        }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }   
        return null;
    }
    
     private Map<String, AggregateResult> getForecastBudgetInformation() {
	
        try {
			List<pse__Time_Period__c> timePeriods = [select Id, pse__Start_Date__c, pse__End_Date__c, TimePeriodCode__c 
                                                        from pse__Time_Period__c 
                                                        where pse__Type__c = 'Month'
                                                        order by pse__End_Date__c asc];
            Date now = Date.Today();
            Date previousFMEndDate = null;                                         
                                                 
            for (Integer i = 0; i < timePeriods.size(); i++){
            	if (now <= timePeriods[i].pse__End_Date__c  &&
                    now >= timePeriods[i].pse__Start_Date__c){
                    if (i > 0){
                        previousFMEndDate = timePeriods[i-1].pse__End_Date__c;
                    } 
                } 
            }
                                               
             
			List<AggregateResult> results = [SELECT 	ProjectTask__c, 
											        	SUM(TotalForecastCost__c)totalCost 
											   			FROM BudgetTask__c 
											            WHERE ProjectTask__c IN :projectTaskIds
											            AND BudgetHeader__r.Status__c = 'Forecast'
											            //AND BudgetHeader__r.StatusOfDate <=: previousFMEndDate
											            GROUP BY ProjectTask__c]; 
           
           	Map<String, AggregateResult> out = new Map<String, AggregateResult>();
           	for (AggregateResult ar : results){
           		out.put((String)ar.get('ProjectTask__c'), ar);
           	}
           	return out;
           
        }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }   
        return null;
    }
	
}