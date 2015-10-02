trigger INC_EnrollmentPlan_AllEvents on EnrollmentPlan__c (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {
		INC_EnrollmentPlanTriggers handler = new INC_EnrollmentPlanTriggers();
		boolean isTriggerEnabled = ECO_TriggerSettings.getIsTriggerEnabled('INC_EnrollmentPlan_AllEvents');
    	//boolean bisRunning = false;
   		System.Debug(logginglevel.error,'Trigger Running for Enrollment Plan');
   		if(isTriggerEnabled){
   			//bisRunning=true;
   			if (Trigger.isBefore) {
	    		if(Trigger.isUpdate && INC_EnrollmentPlanTriggers.beforeRunOnce()){
	    			System.debug(logginglevel.error,'creating createApprovalComments');
	    			handler.createEnrollmentCommentsFromExceptionandMA(trigger.new);
	    			handler.finishenrollmentOfChangeRequest(trigger.newMap,trigger.oldMap);
                    
                    
                    //Check Approval process
                    //Harold to add.
                    //
                    System.debug(logginglevel.error,'CurrentForm owner');
                    handler.setIDOnStatusChange(trigger.newMap, trigger.OldMap);
                    
	    		}

	 		}else{//end is before
	 			if(Trigger.isUpdate && INC_EnrollmentPlanTriggers.afterRunOnce()){
	 				System.debug(logginglevel.error,'After update trigger EnrollmentPlan__c.');
	 				handler.updateParticipants(Trigger.newMap, Trigger.oldMap);
              		
                    handler.createParticipantAcknowledgement(Trigger.NewMap, Trigger.OldMap);
                    
                    //Move Into Handler ~ML
                    list<EnrollmentParticipant__c> lEnrollmentParticipantToUpdate = new list<EnrollmentParticipant__c>();
                    
                    for(EnrollmentParticipant__c oEnrollmentParticipant : [Select id
				       						  From EnrollmentParticipant__c
				       						  Where EnrollmentPlan__c =: Trigger.NewMap.keySet()]){
                                                  
                        oEnrollmentParticipant.PaymentAmount__c = 0;
                                                  
                    	lEnrollmentParticipantToUpdate.add(oEnrollmentParticipant);
                    }
                    
                    update lEnrollmentParticipantToUpdate;
	 			}
	 		}
		}
}