@isTest
private class ECO_BudgetQuestionnaireControllerTest {

    static testMethod void testEverything () {
        PageReference pageRef = Page.ECO_BudgetQuestionnaire;
        Test.setCurrentPageReference(pageRef);
		
		Account testAccount = new Account();
		testAccount.Name = 'test account';
		insert testAccount;
		
		Contact testContact = new Contact();
		testContact.AccountId = testAccount.Id;
		testContact.RecordTypeId = ECO_Utils_Meta.getRecordTypeId(Contact.sObjectType, ECO_Constants.Contact_PSAResourceRecordTypeName);
		testContact.LastName = 'test last';
		testContact.pse__Is_Resource_Active__c = true;
		testContact.pse__Is_Resource__c = true;
		insert testContact;
		
		pse__Proj__c testProject = new pse__Proj__c();
		testProject.pse__Account__c = testAccount.Id;
		insert testProject;
		
		pse__Project_Task__c projTask = new pse__Project_Task__c();
		projTask.pse__Project__c = testProject.Id;
		insert projTask;
		
		User testUser = ECO_Utils_Testing.createTestUser('Standard User');
		insert testUser;
    }
}