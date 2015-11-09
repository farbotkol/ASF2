/*
	Purpose: - Test class for the ECO_Delegate Trigger

	Created By: Aaron Pettitt (NTT Data)

	Revision Log: 
		v1.0 - (AP 10/30/2015) -- created 
*/
@isTest
private class ECO_DelegateTriggerTest {
	Static List<User> users;
	Static List<Contact> contacts;

	@isTest static void testTrigger() {
		setupTestData();
		Id recordTypeId = ECO_Utils_sObject.getRecordTypeId(Delegate__c.sObjectType, 'Vacation');
		Delegate__c delegate = new Delegate__c();
		delegate.Delegate__c = contacts[1].Id;
		delegate.RecordTypeId = recordTypeId;
		delegate.Delegator__c = contacts[0].Id;
		insert delegate;
		delegate = [Select Id, Delegator_User__c from Delegate__c where Id =: delegate.Id];
		system.assertEquals(users[0].Id, delegate.Delegator_User__c);
	}

	static void setupTestData(){

		Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
		Id recordTypeId = ECO_Utils_sObject.getRecordTypeId(Contact.sObjectType, 'PSA Resource');

		Account testAccount = new Account();
		testAccount.Name = 'test account';
		insert testAccount;

		users = new List<User>();
		users.add(ECO_Utils_Testing.createTestUser('Standard User'));
		users.add(ECO_Utils_Testing.createTestUser('Standard User'));
		insert users;

		contacts = new List<Contact>();
		contacts.add(new Contact(pse__Is_Resource__c = true, Status__c = 'Active', Email = users[0].Email, FirstName = users[0].FirstName, LastName = users[0].LastName, pse__Salesforce_User__c = users[0].Id, recordTypeId = recordTypeId, User__c = users[0].Id, OwnerId = users[0].Id));
		contacts.add(new Contact(pse__Is_Resource__c = true, Status__c = 'Active', Email = users[1].Email, FirstName = users[1].FirstName, LastName = users[1].LastName, pse__Salesforce_User__c = users[1].Id, recordTypeId = recordTypeId, User__c = users[1].Id, OwnerId = users[1].Id));
		insert contacts;
	}
	
	
}