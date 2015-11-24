global class ECO_PMD_MultiAxis_Controller {

     public ECO_PMD_MultiAxis_Controller(){}

    
    @RemoteAction
    global static List<ProjectSnapshot__c> ProjectSnapshot(String projectNum)
    {
        
        Id projectId = projectNum;
        
        return [SELECT      id, SnapshotDate__c,Project__c, ProjectNumber__c, CostITD__c, CostMonthToDate__c, CostYearToDate__c, NMNSRITD__c
            FROM            ProjectSnapshot__c
            where Project__c = :projectId  AND SnapshotDate__c = LAST_N_MONTHS:6];
    }
}