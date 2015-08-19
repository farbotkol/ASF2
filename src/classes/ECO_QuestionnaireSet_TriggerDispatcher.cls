public with sharing class ECO_QuestionnaireSet_TriggerDispatcher 
{
	public static Set<String> executedMethods = new Set<String>();
	
	public static void Main(List<QuestionnaireSet__c> newList, Map<Id, QuestionnaireSet__c> newMap, List<QuestionnaireSet__c> oldList, Map<Id, QuestionnaireSet__c> oldMap, Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isExecuting)
	{
		Boolean UpdateProjectReviewCategory_Enabled = ECO_TriggerSettings.getIsTriggerEnabled('UpdateProjectReviewCategory');
		Boolean UpdateProjectCategory_Enabled = ECO_TriggerSettings.getIsTriggerEnabled('UpdateProjectCategory');
		
		if(isAfter)
		{
			if(isUpdate)
			{
				if(UpdateProjectReviewCategory_Enabled && !executedMethods.contains('UpdateProjectReviewCategory'))
				{
					List<QuestionnaireSet__c> approvedQs = new List<QuestionnaireSet__c>();
					for(QuestionnaireSet__c oQS : newList)
					{
						if(oQS.ApprovalStatus__c == 'Approved' && oQS.RequestedProjectCategory__c != null)
						{
							approvedQs.add(oQS);
						}
					}
					if(!approvedQs.isEmpty())
						ECO_QuestionnaireSet_Main.UpdateProjectReviewCategory(approvedQs);
				}

				/*if(UpdateProjectCategory_Enabled && !executedMethods.contains('UpdateProjectCategory'))
				{
					List<QuestionnaireSet__c> approvedQs = new List<QuestionnaireSet__c>();
					for(QuestionnaireSet__c oQS : newList)
					{
						if(oQS.ApprovalStatus__c == 'Approved' && oQS.RequestedProjectCategory__c != null)
						{
							approvedQs.add(oQS);
						}
					}
					if(!approvedQs.isEmpty())
						ECO_QuestionnaireSet_Main.UpdateProjectCategory(approvedQs);
				}*/

			}
		}
	}
}