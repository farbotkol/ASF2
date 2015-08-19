public class ECO_RiskMarketAssessmentTriggerHandler {

	public static void handleRiskMarketAssessmentAfterUpdate(map<Id, QuestionnaireSet__c> oldQuestionnaireSetMap, map<Id, QuestionnaireSet__c> newQuestionnaireSetMap)
	{
		list<Id> projectIdsToUpdate = new list<Id>();
		map<Id, String> projectRMAssessmentStatus = new map<Id, String>();
		map<Id, QuestionnaireSet__c> projectRMAMap = new Map<Id, QuestionnaireSet__c>();
		
		for(QuestionnaireSet__c newQuestionaireSet: newQuestionnaireSetMap.values())
		{			
			projectRMAMap.put(newQuestionaireSet.Project__c, newQuestionaireSet);
			if(newQuestionaireSet.ApprovalStatus__c == 'Approved' && oldQuestionnaireSetMap.get(newQuestionaireSet.Id).ApprovalStatus__c != 'Approved')
			{
				projectIdsToUpdate.add(newQuestionaireSet.Project__c);	
				projectRMAssessmentStatus.put(newQuestionaireSet.Project__c,'Approved');	
			}			
			if(newQuestionaireSet.ApprovalStatus__c == 'Pending Approval' && oldQuestionnaireSetMap.get(newQuestionaireSet.Id).ApprovalStatus__c != 'Pending Approval')
			{
				projectIdsToUpdate.add(newQuestionaireSet.Project__c);	
				projectRMAssessmentStatus.put(newQuestionaireSet.Project__c,'Pending');	
			}			
			if(newQuestionaireSet.ApprovalStatus__c == 'Rejected' && oldQuestionnaireSetMap.get(newQuestionaireSet.Id).ApprovalStatus__c != 'Rejected')
			{
				projectIdsToUpdate.add(newQuestionaireSet.Project__c);	
				projectRMAssessmentStatus.put(newQuestionaireSet.Project__c,'Rejected');	
			}
		}
			
		if(projectRMAssessmentStatus.keyset().size() > 0)
		{
			Id recordTypeId = [select Id from RecordType where Name = 'Customer Project (Planning)' limit 1].Id;
			list<pse__Proj__c> projectsToUpdate = new list<pse__Proj__c>();			
			list<pse__proj__c> projects = [select Id, Name, pse__Project_Status__c, RecordTypeId, ProgBarGoNoGoApproval__c, ProjectReviewCategory__c from pse__Proj__c where Id in :projectRMAssessmentStatus.keyset()];
			list<Task> tasks = new list<Task>();
			for(pse__proj__c project:projects)
			{
				if(projectRMAssessmentStatus.get(project.Id) == 'Approved' && projectRMAMap.get(project.Id).GoNoGoRecommendation__c == 'Go'){
					project.pse__Stage__c = 'Planning';
					project.RecordTypeId = recordTypeId;
					if(projectRMAMap.get(project.Id).RequestedProjectCategory__c != null || projectRMAMap.get(project.Id).RequestedProjectCategory__c != '' )
						project.clAECOMProjectReviewCategory__c = projectRMAMap.get(project.Id).RequestedProjectCategory__c; 
					else
						project.clAECOMProjectReviewCategory__c = project.ProjectReviewCategory__c; 	
				}
				else if(projectRMAssessmentStatus.get(project.Id) == 'Approved' && projectRMAMap.get(project.Id).GoNoGoRecommendation__c == 'No Go'){
					Task newTask = new Task(Description = 'Project Closure Required',
                                    		Priority = 'Normal', 
                                    		Subject = 'Project Closure Required', 
                                    		IsReminderSet = true, 
                                    		ReminderDateTime = System.now()+7, 
                                    		WhatId = project.Id);             
             		tasks.add(newTask);				
				}
					
				project.ProgBarGoNoGoApproval__c = projectRMAssessmentStatus.get(project.Id);
				projectsToUpdate.add(project);
			}
			
			if(tasks.size() > 0)
				insert tasks;
			
			if(projectsToUpdate.size() > 0)
				update projectsToUpdate;			
		}

	}
}