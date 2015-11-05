global class INC_FindDTWAdminForNewIncentiveProjects implements Database.Batchable<sObject> {
	
	String query;
	
	global INC_FindDTWAdminForNewIncentiveProjects() {
		query = getQuery();
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		System.Debug(logginglevel.error,'Starting execute of batch process');
		INC_Service_Matching Inc_Match = new INC_Service_Matching();
		list<IncentiveProject__c> lNew = Inc_Match.FindDTWAdmin(scope);
		lNew = INC_Service_EnrollmentPlan.assignIneligibleQueue(lNew);

		update lNew;
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
	private String getQuery(){
		INC_Service_Matching serviceMatch = new INC_Service_Matching();
		list<Schema.FieldSetMember> DTWAdmin = serviceMatch.getFieldSet(true);
		String sReturn = 'Select ID, RoutingMemberRule__c,FPPOverallEligibility__c,TMPlanOverallEligibility__c';
		for(Schema.FieldSetMember FSM: DTWAdmin){
			sReturn += ',' + (String) FSM.getFieldPath();
		}
		sReturn += ' From IncentiveProject__c where DTWAdminAttempted__c = false';
		return sReturn;
	}
}