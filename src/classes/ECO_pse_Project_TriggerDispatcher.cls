public with sharing class ECO_pse_Project_TriggerDispatcher 
{
    public static Set<String> executedMethods = new Set<String>();
    
    public static void Main(List<pse__Proj__c> newList, Map<Id, pse__Proj__c> newMap, List<pse__Proj__c> oldList, Map<Id, pse__Proj__c> oldMap, Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isExecuting)
    {
        Boolean EvaluateHealthyStart_Enabled = ECO_TriggerSettings.getIsTriggerEnabled('EvaluateHealthyStart');
        
        if(isAfter)
        {
            if(isInsert || isUpdate)
            {
                if(EvaluateHealthyStart_Enabled && !executedMethods.contains('EvaluateHealthyStart'))
                {
                    ECO_pse_Project_Main.EvaluateHealthyStart(newList);
                }
            }
        }
    }
}