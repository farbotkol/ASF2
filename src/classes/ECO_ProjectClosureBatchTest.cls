@isTest
private class ECO_ProjectClosureBatchTest {

    static testMethod void testProjectClosureBatch() {

		Account testAccount = new Account();
		testAccount.Name = 'test Account';
		insert testAccount;
		
		Contact testContact = new Contact();
		testContact.LastName = 'Test Last Name';
		testContact.FirstName = 'Test First Name';
		insert testContact;

		//create create source project 
		pse__Proj__c testProject = new pse__Proj__c();
		testProject.Name = 'test project 1';
		testProject.pse__Account__c = testAccount.Id;
		testProject.pse__Project_Type__c = 'Customer Project';
		testProject.pse__Billing_Type__c = 'Fixed Price';
		testProject.CurrencyIsoCode = 'USD';
		testProject.pse__Is_Active__c = true;
		testProject.pse__End_Date__c = Date.today().addDays(5);
		testProject.pse__Stage__c = 'On Hold';
		testProject.ScheduledRestartDate__c = Date.today().addDays(-1);
		testProject.CMProjectClosureIsApproved__c = true;
		testProject.pse__Project_Manager__c = testContact.Id;
		testProject.ClosureDate__c = Date.today().addDays(-1);
		insert testProject;
				 		
		Test.StartTest();                
        ECO_ProjectClosureBatch projectClosureBatch = new ECO_ProjectClosureBatch();
        Id batchprocessid = Database.executeBatch(projectClosureBatch);    
        Test.StopTest(); 
    }
}