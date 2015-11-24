global class ECO_PMD_TrendAnalysisChart_Controller {

     public ECO_PMD_TrendAnalysisChart_Controller(){}

    
    @RemoteAction
    global static TrendAnalysisDetails ProjectSnapshot(String projectNum)
    {
        
        Id projectId = projectNum;
        
        TrendAnalysisDetails trendAnalysisDetails = new TrendAnalysisDetails();

        List<ProjectSnapshot__c> trendAnalysisData=  [SELECT      
        			id, 			        
			        Project__c, ProjectNumber__c, CostMonthToDate__c, CostYearToDate__c, 
        			SnapshotDate__c, DSO__c, CostBudget__c, GrossRevenueITD__c, GMNSRITD__c,
        			GrossRevenueBudget__c, NetMarginBudget__c, NetMarginITD__c, CostITD__c
	            FROM            
	            	ProjectSnapshot__c
	            where 
	            	Project__c = :projectId  AND SnapshotDate__c = LAST_N_MONTHS:6
	            	order by SnapshotDate__c asc];

	Integer listsize = trendAnalysisData.size();
        if (listsize > 0)
        {
            trendAnalysisDetails.trendAnalysisData = trendAnalysisData;
            trendAnalysisDetails.currencyCode = trendAnalysisData[listsize-1].CurrencyIsoCode; 
        }          
        return trendAnalysisDetails;
    }

    global class TrendAnalysisDetails
    {
        public TrendAnalysisDetails()
        {
            error='';
            trendAnalysisData = null;
            currencyCode='';
        }
        public String error;
        public Boolean nodata;
        public Decimal GMMSR;
        public Decimal DTWAccrual;
        public Decimal DSO;
        public String currencyCode;
        public List<ProjectSnapshot__c> trendAnalysisData;
    }
    

}