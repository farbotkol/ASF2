public with sharing class ECO_PMD_KPIPanel_Controller {

    public ECO_PMD_KPIPanel_Controller() {
    }

    @remoteaction
    public static list<String> getAlerts(String projectId)
    {
        list<ECO_HealthCheckEvaluator.Response> healthResponses = new List<ECO_HealthCheckEvaluator.Response>();
        list<PortalMessage__c> alerts = new list<PortalMessage__c>();
        list<String> messages = new list<String>();

        //Id alertRecordTypeId = [select Id from RecordType where sObjectType = 'PortalMessage__c' and name = 'Alert' limit 1].Id;
        // TAL - There is a utility method to do this that doesn't burn a query, and is cached.
        // hard coded strings should be in the constants class as to not create a maintenance nightmare
        Id alertRecordTypeId = ECO_Utils_Meta.getRecordTypeId(PortalMessage__c.sObjectType, ECO_Constants.PortalMessage_AlertRecordTypeName);

        healthResponses = ECO_HealthCheckEvaluator.EvaluateProject(projectId);
        for(ECO_HealthCheckEvaluator.Response response:healthResponses)
            {
                if(response.evalResult)
                {
                    // TAL - To Author:  Please use the leading comma pattern (like I did below)... it hurts way less to manipulate in the future
                    messages.add(response.message);  
                }                                               
            }
        return messages;
    }   
}