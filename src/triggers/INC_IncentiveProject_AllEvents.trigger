trigger INC_IncentiveProject_AllEvents on IncentiveProject__c (before insert,before Update,after insert, after update) {

    INC_IncentiveProject_Triggers handler = new INC_IncentiveProject_Triggers();
    boolean isTriggerEnabled = ECO_TriggerSettings.getIsTriggerEnabled('INC_IncentiveProject_AllEvents');
    boolean bisRunning = false;
    
    System.Debug(logginglevel.error,'Trigger Running for IncentiveProject before: ' + Trigger.isBefore + ' Insert: ' + Trigger.isInsert);
    
    if(!bisRunning && isTriggerEnabled){
        bisRunning=true;
        if (Trigger.isBefore) {
            
            if(Trigger.isUpdate){
                handler.checkForKeyMetricChanges(Trigger.newMap, Trigger.oldMap);
            }
            
        }else{//end is before
            if(Trigger.isInsert){
                //  System.Debug(logginglevel.error,'After Insert IncentiveProject');
                // handler.AssignDTWAdmin(Trigger.newMap.KeySet());
            }
        }
        
        if (Trigger.isAfter && Trigger.isUpdate) {
            system.debug('Re-evaluate Enrollment Plans');
            
            set<Id> lIncentiveProjectIds = new set<Id>();
            
            for(IncentiveProject__c oIncentiveProject : trigger.new){
                lIncentiveProjectIds.add(oIncentiveProject.Id);
            }
            
            list<EnrollmentPlan__c> lEnrollmentPlans = new list<EnrollmentPlan__c>([SELECT 
                                                                                     Id
                                                                                   FROM
                                                                                     EnrollmentPlan__c
                                                                                   WHERE
                                                                                     IncentiveProject__c in :lIncentiveProjectIds]);
            
            system.debug(lEnrollmentPlans);
            
            update lEnrollmentPlans;
        }
    }
}