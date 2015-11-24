global class ECO_PMD_FinancialSummaryChart_Controller {

     public ECO_PMD_FinancialSummaryChart_Controller(){}

    
    @RemoteAction
    global static FinancialSummaryDetails ProjectSnapshot(String projectNum)
    {
        
        Id projectId = projectNum;
        
        FinancialSummaryDetails financialSummaryDetails = new FinancialSummaryDetails();

        List<ProjectSnapshot__c> financialSummaryData =  [
                SELECT      
                    id,                     
                    Project__c, ProjectNumber__c, CostMonthToDate__c, CostYearToDate__c, 
                    SnapshotDate__c, DSO__c, CostBudget__c, GrossRevenueITD__c, GMNSRITD__c,
                    GrossRevenueBudget__c, NetMarginBudget__c, NetMarginITD__c, CostITD__c
                FROM            
                    ProjectSnapshot__c
                where 
                    Project__c = :projectId and SnapshotDate__c <= TODAY 
                    order by SnapshotDate__c asc];

         List<WeeklyRollupEntry__c> financialSummaryPlanData = [
                SELECT 
                    Project__c, ApprovedCost__c, ProjectFunctionalBurdenedCost__c,
                    OverrideApprovedCost__c, PeriodStartDate__c, Period_Name__c
                FROM 
                    WeeklyRollupEntry__c 
                where 
                    Project__c= :projectId and PeriodStartDate__c <= TODAY
                order by 
                    PeriodStartDate__c asc];           


        Integer listsize = financialSummaryData.size();

        if (listsize > 0)
        {
            financialSummaryDetails.financialSummaryData = financialSummaryData;
            financialSummaryDetails.financialSummaryPlanData = financialSummaryPlanData;
            financialSummaryDetails.GMNSR = 0;//financialSummaryData[listsize-1].GMNSRITD__c; 
            financialSummaryDetails.DTWAccrual = 0; 
            financialSummaryDetails.DSO = 0;
            financialSummaryDetails.currencyCode = financialSummaryData[listsize-1].CurrencyIsoCode; 
            //financialSummaryDetails.chartType = "cost";
            //financialSummaryDetails.dateRange = 6;
        }                                
 
        

        return financialSummaryDetails;
    }


    global class FinancialSummaryDetails
    {
        public FinancialSummaryDetails()
        {
            error='';
            GMNSR = 0;
            DTWAccrual = 0;
            DSO = 0;
            chartType='cost';
            dateRange=6;

            financialSummaryData = null;
            financialSummaryPlanData = null;
        }

        public String error;
        public Boolean nodata;
        public Decimal GMNSR;
        public Decimal DTWAccrual;
        public Integer DSO;
        public String currencyCode;
        public String chartType;
        public Integer dateRange;
        public List<ProjectSnapshot__c> financialSummaryData;
        public List<WeeklyRollupEntry__c> financialSummaryPlanData;
    }
    

}