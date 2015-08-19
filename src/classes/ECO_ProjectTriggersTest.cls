@isTest
private class ECO_ProjectTriggersTest {

    static testMethod void testSettingOfEscalationDateInsert () {
        Account testAccount = new Account();
		testAccount.Name = 'test account';
		insert testAccount;
		
		pse__Proj__c testProject = new pse__Proj__c();
		testProject.pse__Account__c = testAccount.Id;
		testProject.EscalationApplies__c = true;
		testProject.EscalationDate__c = Date.today();
		testProject.EscalationDescription__c = 'Test Desc';
		
		User testUser = ECO_Utils_Testing.createTestUser('System Administrator');
		
		insert testUser;
		
		Test.startTest();
		System.runAs(testUser) {
			insert testProject;
		}
		Test.stopTest();
		
		system.assertEquals(2, [SELECT Id FROM PortalMessage__c WHERE IsEscalationAlert__c = true].size());
    }
    
    static testMethod void testProjectRestart(){
    	  	
        Account testAccount = new Account();
		testAccount.Name = 'test account';
		insert testAccount;
		
		Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
		
		User testManager = new User();
		testManager.Alias = 'manager';
		testManager.Email ='testmanager@example.com';
		testManager.EmailEncodingKey ='UTF-8';
		testManager.FirstName = 'test';
		testManager.LastName ='manager';
		testManager.LanguageLocaleKey ='en_US';
		testManager.LocaleSidKey ='en_US';
		testManager.ProfileId = p.Id;
        testManager.TimeZoneSidKey ='America/Los_Angeles';
        testManager.UserName ='testmanager@example.com';
        insert testManager;		
		
    	Contact testContact = new Contact();
		testContact.LastName = 'Test Last Name';
		testContact.FirstName = 'Test First Name';
		testContact.pse__Salesforce_User__c = testManager.Id;
		insert testContact;
		
		pse__Proj__c testProject = new pse__Proj__c();
		testProject.pse__Account__c = testAccount.Id;
		testProject.pse__Project_Type__c = 'Customer Project';
		testProject.pse__Billing_Type__c = 'Fixed Price';
		testProject.CurrencyIsoCode = 'USD';
		testProject.pse__Is_Active__c = true;
		testProject.pse__End_Date__c = Date.today().addDays(355);
		insert testProject;		
		
		testProject.pse__Stage__c = 'On Hold';
		update testProject;
		
		testProject.pse__Stage__c = 'Planning';
		update testProject;
		
		list<PortalMessage__c> messages = [select Id, Subject__c from PortalMessage__c];
		System.AssertEquals(1, messages.size());
		
    }
    
    static testMethod void testSettingOfEscalationDateUpdate () {
        Account testAccount = new Account();
		testAccount.Name = 'test account';
		insert testAccount;
		
		pse__Proj__c testProject = new pse__Proj__c();
		testProject.pse__Account__c = testAccount.Id;
		testProject.EscalationApplies__c = true;
		testProject.EscalationDate__c = Date.today();
		testProject.EscalationDescription__c = 'Test Desc';
		insert testProject;
		
		Map<Id, PortalMessage__c> oldMessages = new Map<Id, PortalMessage__c>([SELECT Id FROM PortalMessage__c WHERE IsEscalationAlert__c = true]);
		system.assertEquals(2, oldMessages.size());
		
		User testUser = ECO_Utils_Testing.createTestUser('System Administrator');
		
		insert testUser;
		
		testProject.EscalationDate__c = Date.today().addMonths(1);
		
		Test.startTest();
		System.runAs(testUser) {
			update testProject;
		}
		Test.stopTest();
		
		
		
		Map<Id, PortalMessage__c> newMessages = new Map<Id, PortalMessage__c>([SELECT Id FROM PortalMessage__c WHERE IsEscalationAlert__c = true]);
		system.assertEquals(2, newMessages.size());
		for (PortalMessage__c pm : newMessages.values()) {
			system.assertEquals(false, oldMessages.keySet().contains(pm.Id), 'Old Portal Message Alert Found after Updating Escalation Date');
		}	
    }
}