global class ECO_PMD_xmpl_DashPanel_Controller {

     public string locale { get {return UserInfo.getLocale().replace('_', '-');} }

     public ECO_PMD_xmpl_DashPanel_Controller(){}

    
    @RemoteAction
    global static List<ProjectSnapshot__c> ProjectSnapshot(String projectNum)
    {
        Id projectId = projectNum;
        
        return [SELECT id
		        , SnapshotDate__c
		        , Project__c
		        , ProjectNumber__c
		        , CostITD__c
		        , CostMonthToDate__c
		        , CostYearToDate__c
		        , NMNSRITD__c
            FROM ProjectSnapshot__c
            where Project__c = :projectId  AND SnapshotDate__c = LAST_N_MONTHS:6];
    }
}