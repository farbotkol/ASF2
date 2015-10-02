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
	
	public void checkForBaselineChanges(map<id,IncentiveProject__c>mapNew, map<id,IncentiveProject__c> mapOld){
		System.debug(logginglevel.error,'checking for baseline: ');
			
		set<id> setEnrollmentPlans = new set<id>();
		for(IncentiveProject__c ip: mapNew.Values()){
			System.debug(logginglevel.error,'approved old: ' + mapOld.get(ip.id).ApprovedGrossMarginBudget__c);
			System.debug(logginglevel.error,'approved new: ' + ip.ApprovedGrossMarginBudget__c);
			
			if((ip.ApprovedGrossMarginBudget__c != mapOld.get(ip.id).ApprovedGrossMarginBudget__c) ||
			   (ip.ApprovedNetMarginBudget__c != mapOld.get(ip.id).ApprovedNetMarginBudget__c)){
			   	if(ip.EnrollmentPlan__c != null){
					setEnrollmentPlans.add(ip.EnrollmentPlan__c);
				}
			}
		}
		System.Debug(logginglevel.error,'setEnrollmentplans: ' + setEnrollmentplans);
		INC_Service_EnrollmentPlan.updateBaselineChangedFlagforParticipants(setEnrollmentplans);
	}

}