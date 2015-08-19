public with sharing class ECO_AttachmentsTriggerHandler {
	
	public static void handleBeforAttachmentDelete(list<Attachment> attachments)
	{
		map<Id, Attachment> whatIdAttachmentMap = new map<Id, Attachment>();
		for(Attachment attachment:attachments)	
		{
			whatIdAttachmentMap.put(attachment.ParentId, attachment);		
		}
		
		list<BudgetHeader__c> budgetHeaders = [select Id from BudgetHeader__c where Id in :whatIdAttachmentMap.keyset()];
		list<Agreement__c> agreements = [select Id from Agreement__c where Id in :whatIdAttachmentMap.keyset()];
		
		Attachment attachmentForErrorMessage;
		for(BudgetHeader__c budgetHeader:budgetHeaders){
			attachmentForErrorMessage = whatIdAttachmentMap.get(budgetHeader.Id);	
			attachmentForErrorMessage.addError('Users are not allowed to delete Budget Attachments');	
		}
		
		for(Agreement__c agreement:agreements)
		{
			attachmentForErrorMessage = whatIdAttachmentMap.get(agreement.Id);
			attachmentForErrorMessage.addError('Users are not allowed to delete Agreement Attachments');	
		}				
	}
}