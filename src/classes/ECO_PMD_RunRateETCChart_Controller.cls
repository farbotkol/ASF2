global class ECO_PMD_RunRateETCChart_Controller {
 
     public ECO_PMD_RunRateETCChart_Controller(){}
 
   
    @RemoteAction
    global static RunRateDetails ProjectSnapshot(String projectNum)
    {
       
        Id projectId = projectNum;
 
        RunRateDetails runRateDetails = new RunRateDetails();

        List<ProjectSnapshot__c> runRateData = [SELECT
                                            RunRateAverageCost__c, 
                                            CostETC__c, 
                                            CostITD__c, 
                                            CostForecast__c, 
                                            SnapshotDate__c, 
                                            SnapshotType__c,
                                            ProjectEndDate__c,
                                            CurrencyIsoCode
                                        FROM
                                            ProjectSnapshot__c
                                        WHERE
                                            Project__c = :projectId  AND SnapshotDate__c = LAST_N_MONTHS:12
                                        order by SnapshotDate__c asc];

        Integer listsize = runRateData.size();

        if (listsize > 0)
        {
            runRateDetails.runRateData = runRateData;
            runRateDetails.AvgCost = ECO_PMD_Helpers.validDecimal(runRateData[listsize-1].RunRateAverageCost__c);
            runRateDetails.CostEstETC = ECO_PMD_Helpers.validDecimal(runRateData[listsize-1].CostITD__c); 
            runRateDetails.CostETC = ECO_PMD_Helpers.validDecimal(runRateData[listsize-1].CostETC__c);
            runRateDetails.Var = ECO_PMD_Helpers.validDecimal(runRateData[listsize-1].CostForecast__c) - ECO_PMD_Helpers.validDecimal(runRateData[listsize-1].CostITD__c);
            runRateDetails.ProjectEndDate = runRateData[listsize-1].ProjectEndDate__c;
            runRateDetails.currencyCode = runRateData[listsize-1].CurrencyIsoCode; 
        }                                
        return runRateDetails;
    }

    global class RunRateDetails
    {
        public RunRateDetails()
        {
            error='';
            AvgCost = 0;
            CostETC = 0;
            CostEstETC = 0;
            Var=0;
            runRateData = null;
        }

        public String error;
        public Boolean nodata;
        public Decimal AvgCost;
        public Decimal CostETC;
        public Decimal CostEstETC;
        public Decimal Var;
        public Decimal other;
        public String currencyCode;
        public Date ProjectEndDate;
        public List<ProjectSnapshot__c> runRateData;
    }
    

}