public with sharing class INC_IncentiveProject_Triggers {

	public INC_IncentiveProject_Triggers() {
		
	}

	public void checkForKeyMetricChanges(map<id,IncentiveProject__c>mapNew, map<id,IncentiveProject__c> mapOld){
		System.Debug(logginglevel.error,'check for changes');
		set<id> setIncentivesChanges = INC_Service_EnrollmentPlan.checkMetricChanges(mapNew,mapOld);
		List<EnrollmentPlan__c> listChangedEnroll = new list<EnrollmentPlan__c>();
		System.debug(logginglevel.error,'setIncentivesChanges: ' + setIncentivesChanges);
		if(setIncentivesChanges != null && setIncentivesChanges.size() > 0){
			for(EnrollmentPlan__c Enroll: [Select id
														   , MetricWarningActive__c
												  From EnrollmentPlan__c
												  Where IncentiveProject__c =: setIncentivesChanges]){
				Enroll.MetricWarningActive__c = 'Yes';
				listChangedEnroll.add(Enroll);
			}

			if(listChangedEnroll != null && listChangedEnroll.size() > 0){
				INC_Service_EnrollmentPlan.updateEnrollmentApplications(listChangedEnroll);
			}
		}
	}
	
}