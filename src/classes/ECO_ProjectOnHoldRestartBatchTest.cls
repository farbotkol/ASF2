@isTest
private class ECO_ProjectOnHoldRestartBatchTest {

    static testMethod void testProjectOnHoldRestartBatch() {

		Account testAccount = new Account();
		testAccount.Name = 'test Account';
		insert testAccount;

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
		insert testProject;
				 		
		Test.StartTest();                
        ECO_ProjectOnHoldRestartBatch projectOnHoldRestartBatch = new ECO_ProjectOnHoldRestartBatch();
        Id batchprocessid = Database.executeBatch(projectOnHoldRestartBatch);    
        Test.StopTest(); 
       
        list<PortalMessage__c> portalMessage = [select Id from PortalMessage__c];        
        System.AssertEquals(1, portalMessage.size());
    }
    
    static testMethod void testProjectOnHoldRestartBatch2() {

		Account testAccount = new Account();
		testAccount.Name = 'test Account';
		insert testAccount;

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
		testProject.ScheduledRestartDate__c = Date.today().addDays(+1);
		insert testProject;
				 		
		Test.StartTest();                
        ECO_ProjectOnHoldRestartBatch projectOnHoldRestartBatch = new ECO_ProjectOnHoldRestartBatch();
        Id batchprocessid = Database.executeBatch(projectOnHoldRestartBatch);    
        Test.StopTest(); 
       
        list<PortalMessage__c> portalMessage = [select Id from PortalMessage__c];        
        System.AssertEquals(0, portalMessage.size());
    }
}