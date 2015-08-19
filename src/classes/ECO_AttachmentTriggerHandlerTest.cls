@isTest
private class ECO_AttachmentTriggerHandlerTest {

    static testMethod void testDeleteAgreementAttachment() {
    	
    	Agreement__c agreement = new Agreement__c();
    	insert agreement;
    	
    	Blob attachmentBody = Blob.valueOf('This is a test');
    	Attachment attachment = new Attachment();
    	attachment.Body = attachmentBody;
    	attachment.ParentId = agreement.Id;
    	attachment.Name = 'Test Attachment';
    	insert attachment;
    	
    	try
    	{
    		delete attachment;
    	}
    	catch(Exception e)
		{
			Boolean expectedExceptionThrown =  e.getMessage().contains('Users are not allowed to delete Agreement Attachments') ? true : false;
			System.AssertEquals(expectedExceptionThrown, true);
		} 
    
        // TO DO: implement unit test
    }
    
    static testMethod void testDeleteBudgetAttachment() {
    	
    	pse__Proj__c project = new pse__Proj__c();
    	insert project;
    	
    	BudgetHeader__c budgetHeader = new BudgetHeader__c(Project__c = project.Id);
    	insert budgetHeader;
    	
    	Blob attachmentBody = Blob.valueOf('This is a test');
    	Attachment attachment = new Attachment();
    	attachment.Body = attachmentBody;
    	attachment.ParentId = budgetHeader.Id;
    	attachment.Name = 'Test Attachment';
    	insert attachment;
    	
    	try
    	{
    		delete attachment;
    	}
    	catch(Exception e)
		{
			Boolean expectedExceptionThrown =  e.getMessage().contains('Users are not allowed to delete Budget Attachments') ? true : false;
			System.AssertEquals(expectedExceptionThrown, true);
		} 
    
        // TO DO: implement unit test
    }    
}