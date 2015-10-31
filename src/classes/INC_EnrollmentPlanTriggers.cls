public with sharing class INC_EnrollmentPlanTriggers {

    Private Static Boolean beforeRun = true;
    Public Static Boolean afterRun = true;
    
    Public Static Boolean beforeRunOnce() {
        if(beforeRun) {
            beforeRun = false;
            return true;
        }else {
            return beforeRun;
        }    
    }
    
    Public Static Boolean afterRunOnce() {
        if(afterRun) {
            afterRun = false;
            System.Debug(logginglevel.error,'afterRunOnce true');
            return true;
        }else {
        	System.Debug(logginglevel.error,'afterRunOnce false');
            return afterRun;
        }    
    }
    
	public INC_EnrollmentPlanTriggers() {
		
	}

	public void setIDOnStatusChange(map<id,EnrollmentPlan__c>mapNew, map<id,EnrollmentPlan__c>mapOld){
		set<id> setEP = new set<id>();
		for(EnrollmentPlan__c ep: mapNew.Values()){
			if(ep.EnrollmentStatus__c != mapOld.get(ep.id).EnrollmentStatus__c &&
				(ep.EnrollmentStatus__c == 'Rejected' || ep.EnrollmentStatus__c == 'Rejected for Correction')){
				setEP.add(ep.id);
			}
		}

		if(setEP != null && setEP.size() > 0){


			for(ProcessInstance pi: [Select id,LastActorId, TargetObjectId, (SELECT Id, ActorID, CreatedDate, StepStatus, Comments FROM Steps order by CreatedDate desc)
											  ,(SELECT Id, ActorId, ProcessInstanceId FROM Workitems)
											  ,(Select Id, ActorId, IsPending, StepStatus from StepsandWorkItems)
 				from ProcessInstance where TargetObjectId =: setEP]){
 								System.debug(logginglevel.error, 'pi: ' + pi.LastActorId);

 				
 				mapNew.get(pi.TargetObjectId).CurrentApprovalOwner__c = pi.Steps[0].ActorID;
 				
			}
		}

	}

	public void createEnrollmentCommentsFromExceptionandMA(list<EnrollmentPlan__c> listEnrollmentPlans){
		INC_Service_EnrollmentPlan.createEnrollmentcomment(listEnrollmentplans);
		for(EnrollmentPlan__c ep: listEnrollmentplans){
			ep.ExceptionComments__c = null;
			ep.MA_Comments__c = null;
		}
	}

	public void createApprovalComments(map<id,EnrollmentPlan__c> mapNew, map<id,EnrollmentPlan__c> mapOld){
	
		set<id> setChangedEnrollmentPlans = new set<id>();
		set<String> setStatuses = new set<String>{'Pending PM Action'	
												  	,'Pending Approver 1 Action'
												  	,'Pending Approver 2 Action'	
													,'Pending Approver 3 Action'
													,'Pending DTW Admin'
													,'Enrolled'
													,'Rejected'
													,'Rejected for Correction'
												};
		for(EnrollmentPlan__c ep: mapNew.Values()){
			System.debug(logginglevel.error,'ep.EnrollmentStatus__c ' + ep.EnrollmentStatus__c + ' old: ' + mapOld.get(ep.id).EnrollmentStatus__c);
			if(ep.EnrollmentStatus__c != mapOld.get(ep.id).EnrollmentStatus__c){
				if(setStatuses.Contains(ep.EnrollmentStatus__c)){
					System.Debug(logginglevel.error,'Adding app to set to create comments');
					setChangedEnrollmentPlans.add(ep.id);
				}
			}
		}

		if(setChangedEnrollmentPlans != null && setChangedEnrollmentPlans.size() > 0){
			System.Debug(logginglevel.error,'Calling create comments code');
			INC_Service_EnrollmentPlan.createEnrollmentCommentsFromApproval(setChangedEnrollmentPlans);
		}
	} 


	public void updateParticipants(map<id,EnrollmentPlan__c> mapNew, map<id,EnrollmentPlan__c> mapOld){
		set<id> enrollmentPlans = new set<id>();
		set<id> closedPlans = new set<id>();
		set<id> baselineGrossPlans = new set<id>();

		set<id> allPlans = new set<id>();
		for(EnrollmentPlan__c EnrollPlan: mapNew.Values()){
			if(EnrollPlan.EnrollmentStatus__c == 'Enrolled' && 
				(EnrollPlan.EnrollmentStatus__c != mapOld.get(EnrollPlan.ID).EnrollmentStatus__c)){
				enrollmentPlans.add(EnrollPlan.ID);
				allPlans.add(EnrollPlan.ID);
			}
			if(EnrollPlan.EnrollmentStatus__c == 'Closed - No Award' &&
				(EnrollPlan.EnrollmentStatus__c != mapOld.get(EnrollPlan.ID).EnrollmentStatus__c)){
				closedPlans.add(EnrollPlan.id);
				allPlans.add(EnrollPlan.ID);
			}

			if((EnrollPlan.GrossMarginAmountScopeChange__c != mapOld.get(EnrollPlan.ID).GrossMarginAmountScopeChange__c)||
				(EnrollPlan.GrossMarginAmountAdjustment__c != mapOld.get(EnrollPlan.ID).GrossMarginAmountAdjustment__c)){
				baselineGrossPlans.add(EnrollPlan.ID);
				allPlans.add(EnrollPlan.ID);
			}


		}
		System.Debug(logginglevel.error,'Plans to fix participants ' + enrollmentPlans);
		if(allPlans != null && allPlans.size() > 0){
			list<EnrollmentParticipant__c> listUpdates = new list<EnrollmentParticipant__c>();
			Id readOnlyTypeId = ECO_Utils_sObject.getRecordTypeId(EnrollmentParticipant__c.sObjectType,'Read Only Participant');
			System.Debug(logginglevel.error,'Readonly ID ' + readOnlyTypeId);

			for(EnrollmentParticipant__c EP: [Select id
													   ,RecordTypeId
													   ,EnrollmentPlan__c
													   ,Closed_No_Award__c
													   ,Baseline_Margin_Change__c
				       						  From EnrollmentParticipant__c
				       						  Where EnrollmentPlan__c =: allPlans]){
				System.Debug(logginglevel.error,'Found participants: ' + EP);
				boolean bUpdated = false;
				if(enrollmentPlans.Contains(ep.EnrollmentPlan__c)){
					EP.RecordTypeId = readOnlyTypeId;
					bUpdated = true;
				}

				if(closedPlans.Contains(EP.EnrollmentPlan__c)){
					EP.Closed_No_Award__c = true;
					System.Debug(logginglevel.error,'Setting closed award to true. ' + ep);
					bUpdated = true;
				}

				if(baselineGrossPlans.Contains(EP.EnrollmentPlan__c)){
					EP.Baseline_Margin_Change__c = true;
					bUpdated = true;
				}

				if(bUpdated){
					listUpdates.add(EP);
				}
			}

			if(listUpdates != null && listUpdates.size() > 0){
				System.Debug(logginglevel.error,'Saving participants' + listUpdates.size());
				System.savePoint sp = Database.setSavePoint();
		        try{
		            Update listUpdates;
		        }catch(Exception e){
		            system.debug('Handling Exception:  '+e.getMessage() + ' ' + e.getStackTraceString());
		            system.debug(logginglevel.error, 'enrollmentPlan creation error: ' + e);
		            Database.rollBack(sp);
		        }
			}
		}

	}

	public void finishenrollmentOfChangeRequest(map<id,EnrollmentPlan__c>mapNew, map<id,EnrollmentPlan__c>mapOld){
		map<id,id> mapIncentiveByEnrollment = new map<id,id>();
		set<id> enrollmentAppsToUpdate = new set<id>();
		set<id> rejectedPlans = new set<id>();
		for(EnrollmentPlan__c enr: mapNew.Values()){
			if(enr.ApplicationType__c == 'CCR'){
				System.Debug('statuses: '+enr.NAME + ' ' + enr.EnrollmentStatus__c + ' ' + mapOld.get(enr.ID).EnrollmentStatus__c);
				if(enr.EnrollmentStatus__c == 'Enrolled' && mapOld.get(enr.ID).EnrollmentStatus__c != 'Enrolled'){
					if(mapNew.containsKey(enr.ParentApplication__c)){
						mapNew.get(enr.ParentApplication__c).EnrollmentStatus__c = 'Archived';
					}else{
						enrollmentAppsToUpdate.add(enr.ParentApplication__c);
					}
					mapIncentiveByEnrollment.put(enr.IncentiveProject__c,enr.Id);
				}else{
					if(enr.EnrollmentStatus__c == 'Rejected' && 
				  	(mapOld.get(enr.ID).EnrollmentStatus__c != 'Rejected')){
						rejectedPlans.add(enr.ID);
						mapIncentiveByEnrollment.put(enr.IncentiveProject__c,enr.Id);
					}
				}
			}
		}

		System.Debug('enrollmentAppsToUpdate ' + enrollmentAppsToUpdate);

		if(enrollmentAppsToUpdate != null && enrollmentAppsToUpdate.size()> 0){
			list<EnrollmentPlan__c> listEnrollments = new list<EnrollmentPlan__c>();
			for(EnrollmentPlan__c EP: [Select ID
												, EnrollmentStatus__c
									   From EnrollmentPlan__c
									   Where id =: enrollmentAppsToUpdate]){
				EP.EnrollmentStatus__c = 'Archived';
				listEnrollments.add(EP);
			}
			System.SavePoint sp = Database.setSavePoint();
			if(listEnrollments != null && listEnrollments.size() > 0){
				try{
					update listEnrollments;
				}catch(Exception E){
					System.Debug(logginglevel.error,'Problem updateing enrollmentPlans ' + e.getMessage());
				}
			}
		}

		if(mapIncentiveByEnrollment != null && mapIncentiveByEnrollment.size() > 0){
			list<IncentiveProject__c> listIncentive = new list<IncentiveProject__c>();
			for(IncentiveProject__c INC: [Select ID
												   , ChangeRequest__c
												   , EnrollmentPlan__c
										  From IncentiveProject__c
										  where ID =: mapIncentiveByEnrollment.KeySet()]){
				if(!rejectedPlans.Contains(mapIncentiveByEnrollment.get(INC.ID))){
					INC.EnrollmentPlan__c = mapIncentiveByEnrollment.get(INC.ID);
				}
				INC.ChangeRequest__c = null;
				listIncentive.add(INC);
			}
			System.SavePoint sp = Database.setSavePoint();
			if(listIncentive != null && listIncentive.size() > 0){
				try{
					update listIncentive;
				}catch(Exception E){
					System.Debug(logginglevel.error,'Problem updateing listIncentive ' + e.getMessage());
				}
			}
		}


	}
    
    /**
     * This method is responsible for creating Participant Acknowledgement records
     * Work Item: WI-003593
     * Built By: Sanchivan Sivadasan 
     */
    public void createParticipantAcknowledgement(Map<Id, EnrollmentPlan__c> newMap, Map<Id, EnrollmentPlan__c> oldMap ) {
        System.Debug(logginglevel.error,'creating acknowledgements' + newMap);
        Set<Id> ePlanIdsEnrolled = new Set<Id>();
        // Collect all Enrollments that are enrolled
        for(EnrollmentPlan__c ePlan : newMap.values()) {
            System.debug('Looping through Enrollment Plan');
            System.debug('ePlan.EnrollmentStatus__c:' + ePlan.EnrollmentStatus__c);
            System.debug('oldMap.get(ePlan.Id).EnrollmentStatus__c:' + oldMap.get(ePlan.Id).EnrollmentStatus__c);
            if(ePlan.EnrollmentStatus__c == 'Enrolled' && oldMap.get(ePlan.Id).EnrollmentStatus__c != 'Enrolled') {
                ePlanIdsEnrolled.add(ePlan.Id);
            }
        }
        System.Debug(logginglevel.error,'ePlanIdsEnrolled ' + ePlanIdsEnrolled);

        List<ParticipantAcknowledgement__c> participantAcknowledgementsToCreate = new List<ParticipantAcknowledgement__c>();
        
        // Retrieve all Enrollment Participants for the Enrolled Enrollments which has a Status of Active and Target Allocation > 0
        // Then prepare Participant Acknowledgement records that needs to be inserted
        for(EnrollmentParticipant__c ePar : [SELECT Id
        											, EmployeeName__r.Email
        											, EmployeeName__r.pse__Salesforce_User__c 
        											, EmployeeName__r.pse__Salesforce_User__r.ManagerId
        											, EmployeeStatus__c
        											, TargetIncentivePoolAllocated__c
        											, EnrollmentPlan__c 
        											, CurrencyISOCode
                                             FROM EnrollmentParticipant__c 
                                             WHERE EnrollmentPlan__c in : ePlanIdsEnrolled AND EmployeeStatus__c = 'Active' AND TargetIncentivePoolAllocated__c > 0]) {
        	System.Debug(logginglevel.error,'Found participant ' + ePar.EmployeeName__r.pse__Salesforce_User__r.ManagerId);
            ParticipantAcknowledgement__c pA = new ParticipantAcknowledgement__c();
			pA.RecordTypeId = Schema.SObjectType.ParticipantAcknowledgement__c.getRecordTypeInfosByName().get('Sent').getRecordTypeId();
			pA.OwnerId = ePar.EmployeeName__r.pse__Salesforce_User__c;
			pA.Manager__c = ePar.EmployeeName__r.pse__Salesforce_User__r.ManagerId;
			pA.ParticipantID__c = ePar.Id;
			pA.CurrencyISOCode = ePar.CurrencyISOCode;
                                                 
			participantAcknowledgementsToCreate.add(pA);
        }
        
        // Create the Participant Acknowledgements
        System.debug(logginglevel.error,'participantAcknowledgementsToCreate ' + participantAcknowledgementsToCreate.size());
        if(participantAcknowledgementsToCreate != null && participantAcknowledgementsToCreate.size() > 0){
            System.Debug(logginglevel.error,'Creating participant acknowledgements' + participantAcknowledgementsToCreate.size());
            System.savePoint sp = Database.setSavePoint();
            
            try{
                Insert participantAcknowledgementsToCreate;

 				set<string> sPAid = new set<string>();

 				for(ParticipantAcknowledgement__c p: participantAcknowledgementsToCreate){
 					if(p.id != null){
 						sPAid.add(p.id);
 					}
            	}

            	if(sPAid.size() >0){
            		INC_EnrollmentLetterAttach.attachEnrollmentLetter(sPAid);
            	}

            }catch(Exception e){
                system.debug('Handling Exception:  ' + e.getMessage() + ' ' + e.getStackTraceString());
                system.debug(logginglevel.error, 'participant acknowledgement creation error: ' + e);
                Database.rollBack(sp);
            }
        }
    }	

    public void setSnapShotValues(Map<Id, EnrollmentPlan__c> mapNew, Map<Id, EnrollmentPlan__c> mapOld){
    	set<id> setReQueryPlans = new set<id>();
    	System.Debug(logginglevel.error,'mapNew: ' + mapNew);
    	System.Debug(logginglevel.error,'mapOld: ' + mapold);
    	for(EnrollmentPlan__c EP: mapNew.Values()){
    		if((EP.EnrollmentStatus__c == 'Enrolled' && mapOld.get(EP.ID).EnrollmentStatus__c != 'Enrolled')){
    			if(EP.ApplicationType__c=='ENR' || (EP.ApplicationType__c == 'CCR' && EP.IncentivePlanContractType__c == 'Fixed Price')){
    				setReQueryPlans.add(EP.ID);
    			}
    		}
    	}

    	//requery plans to get cross object values for snapshots
    	if(setReQueryPlans != null && setReQueryPlans.size() > 0){
    		for(EnrollmentPlan__c EP: [Select ID
    										, GrossMarginAmountScopeChange__c
    										, GrossMarginAmountAdjustment__c
    										, GrossMarginAdjustment__c
    										, NSRAdjustment__c
    										, DTWComplete__c
    										, ApprovedSubsODC__c
    										, BaselineGrossMargin__c
    										, BaselineGrossRevenue__c
    										, BaselineGMofNSR__c
    										, BaselineGrossRevenueSnapshot__c
    										, BaselineMarginofNSRatSnapshot__c
    										, BaselineNSRatSnapshot__c
    										, BaselineDPEatSnapshot__c
    										, ITDCostCompleteatSnapshot__c
    										, DTWCompleteSnapshot__c
    										, BaselineNSR__c
    										, BaselineDPE__c
    										, IncentiveProject__r.ApprovedNetMarginBudget__c 
    										, IncentiveProject__r.ApprovedGrossMarginBudget__c
    										, IncentiveProject__r.ApprovedNSRBudget__c
    										, IncentivePlan__r.ContractSubType__c
    										, IncentiveProject__r.ApprovedGrossRevenueBudget__c
    										, IncentiveProject__r.ApprovedODCBudget__c
    										, IncentiveProject__r.ApprovedSubsBudget__c
    										, IncentiveProject__r.ApprovedContingencyBudget__c
    										, IncentiveProject__r.ApprovedDPEBudget__c
    										, IncentiveProject__r.ApprovedGrossMarginofNSR__c
    										, IncentiveProject__r.ApprovedNMofNSR__c
    										, IncentiveProject__r.ActualPercentProjectCompleteITD__c
    										From EnrollmentPlan__c where id =: setReQueryPlans]){

				mapNew.get(EP.ID).ApprovedRevenueBudgetatSnapshot__c = EP.IncentiveProject__r.ApprovedGrossRevenueBudget__c;
    			mapNew.get(EP.ID).ApprovedSubsBudgetatSnapshot__c = EP.ApprovedSubsODC__c;
    			mapNew.get(EP.ID).ApprovedContingencyBudgetatsnapshot__c = EP.IncentiveProject__r.ApprovedContingencyBudget__c;
				mapNew.get(EP.ID).ApprovedNSRBudgetatSnapshot__c = EP.IncentiveProject__r.ApprovedNSRBudget__c;
    			mapNew.get(EP.ID).ApprovedDPEBudgetatSnapshot__c = EP.IncentiveProject__r.ApprovedDPEBudget__c;
    			mapNew.get(EP.ID).ApprovedGrossMarginBudgetatSnapshot__c = EP.IncentiveProject__r.ApprovedGrossMarginBudget__c;
    			mapNew.get(EP.ID).ApprovedGrossMarginofNSRatSnapshot__c = EP.IncentiveProject__r.ApprovedGrossMarginofNSR__c;
    			mapNew.get(EP.ID).ApprovedNetMarginBudgetatSnapshot__c = EP.IncentiveProject__r.ApprovedNetMarginBudget__c;
    			mapNew.get(EP.ID).ApprovedNetMarginofNSRatSnapShot__c = EP.IncentiveProject__r.ApprovedNMofNSR__c;
    			mapNew.get(EP.ID).DTWCompleteSnapshot__c = EP.DTWComplete__c;
    			
    			if(EP.IncentivePlan__r.ContractSubType__c == 'Gross Margin'){
    				mapNew.get(EP.ID).BaselineGrossMarginatSnapshot__c = EP.BaselineGrossMargin__c;
    			}else{
					mapNew.get(EP.ID).BaselineNetMarginatSnapshot__c = EP.BaselineGrossMargin__c;
				}

				mapNew.get(EP.ID).BaselineGrossRevenueSnapshot__c = EP.BaselineGrossRevenue__c;
				mapNew.get(EP.ID).BaselineMarginofNSRatSnapshot__c = EP.BaselineGMofNSR__c;
    			mapNew.get(EP.ID).BaselineNSRatSnapshot__c = EP.BaselineNSR__c;
    			mapNew.get(EP.ID).BaselineDPEatSnapshot__c = EP.BaselineDPE__c;
    			mapNew.get(EP.ID).ITDCostCompleteatSnapshot__c = EP.IncentiveProject__r.ActualPercentProjectCompleteITD__c;
    		}
    	}
    }









































}