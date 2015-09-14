@isTest
private class ECO_IntegrationMessageQueueTriggersTest {

    static testMethod void simpleTriggerTest () {
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
		
		User testUser = ECO_Utils_Testing.createTestUser('Standard User');
		insert testUser;
		
		Test.startTest();
		System.runAs(testUser) {
			IntegrationMessageQueue__c testIMQ = new IntegrationMessageQueue__c();
			testIMQ.JobName__c = 'Project Number';
			testIMQ.Status__c = 'Success';
			insert testIMQ;
		}
		Test.stopTest();
    }
}