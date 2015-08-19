@isTest
private class ECO_ProjectFundingControllerTest {

    static testMethod void controllerUnitTest() {
    	
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
		insert testProject;
		
		Agreement__c agreement = new Agreement__c();
		agreement.Account__c = testAccount.Id;
		agreement.Description__c = 'Test Agreement';
		agreement.CurrencyIsoCode = 'USD';
		agreement.Amount__c = 1000000;
		insert agreement;
		
		pse__Project_Task__c task = new pse__Project_Task__c();
		task.Name = 'top task';
		task.pse__Project__c = testProject.Id;
		task.pse__Start_Date_Time__c = DateTime.now();
		task.pse__End_Date_Time__c = DateTime.now().addDays(1);
		task.pse__Status__c = 'Draft';
		task.FinancialTask__c = false;
		insert task;	
		
		Funding__c funding = new Funding__c();
		funding.AllocatedAmount__c = 10000;
		funding.Agreement__c = agreement.Id;
		funding.Project__c = testproject.Id;
		funding.DateAllocatedDate__c = Date.today();
		funding.ProjectTask__c = task.Id;
		insert funding;	
		
		ApexPages.currentPage().getParameters().put('ProjectId',testProject.Id);
		ApexPages.currentPage().getParameters().put('AgreementId',agreement.Id);
		
		ECO_ProjectFundingController controller = new ECO_ProjectFundingController(); 
		controller.createFunding();
		controller.newFunding.AllocatedAmount__c = 1000;
		controller.newFunding.ProjectTask__c = task.Id;
		controller.saveNewFunding();
		system.assertequals(2, [select Id from funding__c].size());
		system.assertnotequals(null, controller.returnToAgreement());
    }
    
    static testMethod void controllerUnitTest2() {
    	
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
		testProject.ProjectCurrencyCode__c = 'USD';
		testProject.pse__Is_Active__c = true;
		insert testProject;
		
		Agreement__c agreement = new Agreement__c();
		agreement.Account__c = testAccount.Id;
		agreement.Description__c = 'Test Agreement';
		agreement.CurrencyIsoCode = 'EUR';
		agreement.Amount__c = 1000000;
		agreement.FundingCurrencyCode__c = 'EUR';
		insert agreement;
		
		pse__Project_Task__c task = new pse__Project_Task__c();
		task.Name = 'top task';
		task.pse__Project__c = testProject.Id;
		task.pse__Start_Date_Time__c = DateTime.now();
		task.pse__End_Date_Time__c = DateTime.now().addDays(1);
		task.pse__Status__c = 'Draft';
		task.FinancialTask__c = false;
		insert task;	
		
		Funding__c funding = new Funding__c();
		funding.AllocatedAmount__c = 10000;
		funding.Agreement__c = agreement.Id;
		funding.Project__c = testproject.Id;
		funding.DateAllocatedDate__c = Date.today();
		funding.ProjectTask__c = task.Id;
		insert funding;	
		
		ApexPages.currentPage().getParameters().put('ProjectId',testProject.Id);
		ApexPages.currentPage().getParameters().put('AgreementId',agreement.Id);
		
		ECO_ProjectFundingController controller = new ECO_ProjectFundingController(); 
		controller.createFunding();
		controller.newFunding.AllocatedAmount__c = 1000;
		controller.newFunding.ProjectTask__c = task.Id;
		controller.saveNewFunding();
		system.assertequals(2, [select Id from funding__c].size());
		system.assertnotequals(null, controller.returnToProject());		
    }    
    
	static testMethod void controllerUnitTest3() {
    	
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
		testProject.ProjectCurrencyCode__c = 'USD';
		testProject.pse__Is_Active__c = true;
		insert testProject;
		
		Agreement__c agreement = new Agreement__c();
		agreement.Account__c = testAccount.Id;
		//agreement.Description__c = 'Test Agreement';
		agreement.CurrencyIsoCode = 'EUR';
		agreement.Amount__c = 1000000;
		agreement.FundingCurrencyCode__c = 'EUR';
		insert agreement;
		
		pse__Project_Task__c task = new pse__Project_Task__c();
		task.Name = 'top task';
		task.pse__Project__c = testProject.Id;
		task.pse__Start_Date_Time__c = DateTime.now();
		task.pse__End_Date_Time__c = DateTime.now().addDays(1);
		task.pse__Status__c = 'Draft';
		task.FinancialTask__c = false;
		insert task;	
		
		Funding__c funding = new Funding__c();
		funding.AllocatedAmount__c = 10000;
		funding.Agreement__c = agreement.Id;
		funding.Project__c = testproject.Id;
		funding.DateAllocatedDate__c = Date.today();
		funding.ProjectTask__c = task.Id;
		insert funding;	
		
		ApexPages.currentPage().getParameters().put('ProjectId',testProject.Id);
		ApexPages.currentPage().getParameters().put('AgreementId',agreement.Id);
		
		ECO_ProjectFundingController controller = new ECO_ProjectFundingController(); 
		controller.createFunding();
		controller.newFunding.AllocatedAmount__c = 1000;
		controller.newFunding.ProjectTask__c = task.Id;
		controller.cancelNewFunding();
		system.assertEquals(null, controller.newFunding);
    }    
}