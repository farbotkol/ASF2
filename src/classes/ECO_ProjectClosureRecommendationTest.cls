@isTest
public class ECO_ProjectClosureRecommendationTest {
	
	static testMethod void testBatchOne()
	{ 	
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
		testProject.pse__End_Date__c = Date.today().addDays(-1);
		insert testProject;
		
		Billing__c billing = new Billing__c();
		billing.ProjectNumber__c = testProject.Id;
		billing.InvoiceAmount__c = 10000;
		billing.InvoiceDate__c = Date.today();
		insert billing;
		
		Test.StartTest();                
        ECO_ProjectClosureRecommendationBatch recommendationBatch = new ECO_ProjectClosureRecommendationBatch();
        Id batchprocessid = Database.executeBatch(recommendationBatch);    
        Test.StopTest(); 
        
        list<PortalMessage__c> messages = [select Id from PortalMessage__c];
        System.AssertEquals(0, messages.size());
	}

	static testMethod void testBatchTwo()
	{ 	
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
		testProject.pse__End_Date__c = Date.today().addDays(-1);
		insert testProject;
		
		Billing__c billing = new Billing__c();
		billing.ProjectNumber__c = testProject.Id;
		billing.InvoiceAmount__c = 10000;
		billing.InvoiceDate__c = Date.today().addDays(-100);
		insert billing;
		
		Agreement__c agreement = new Agreement__c();
		agreement.Amount__c = 10000;
		insert agreement;
		
		ProjectAgreement__c projectAgreement = new ProjectAgreement__c(Agreement__c = agreement.Id,
																	   Project__c = testProject.Id);
		insert projectAgreement;
																	  		
		Test.StartTest();                
        ECO_ProjectClosureRecommendationBatch recommendationBatch = new ECO_ProjectClosureRecommendationBatch();
        Id batchprocessid = Database.executeBatch(recommendationBatch);    
        Test.StopTest(); 
        
        list<PortalMessage__c> messages = [select Id from PortalMessage__c];
        System.AssertEquals(1, messages.size());
	}

}