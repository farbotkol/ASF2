global class ECO_PMD_DeliverToWinChart_Controller {

     public ECO_PMD_DeliverToWinChart_Controller(){}

    
    @RemoteAction
    global static List<ProjectSnapshot__c> ProjectSnapshot(String projectNum)
    {
        
        Id projectId = projectNum;
        
        return [SELECT 
                    AR__c, UnbilledTotal__c, ProjectStartDate__c, ProjectEndDate__c, SnapshotDate__c 
                FROM 
                    ProjectSnapshot__c 
                WHERE
                    Project__c = :projectId  AND SnapshotDate__c = LAST_N_MONTHS:12
                order by SnapshotDate__c asc];
    }
}