@isTest
private class ECO_BIllRateManagementTest {

    static testMethod void controllerTest1() {
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
		
		ApexPages.currentPage().getParameters().put('AgreementId',agreement.Id);
		ECO_BillRateManagement controller = new ECO_BillRateManagement();
		System.AssertEquals(0, controller.getLaborCategories().size());
		System.AssertEquals(0, controller.getPeriods().size());
		System.AssertNotEquals(null, controller.returnToAgreement());
		controller.createNewBillRatePeriod();
		controller.newBillRatePeriod.BillRateStart__c = Date.today();
		controller.newBillRatePeriod.BillRateEnd__c = Date.today().addDays(1);
		controller.saveNewBillRatePeriod();
		System.AssertEquals(1, [select Id from BillRatePeriod__c].size());
		controller.createNewBillRate();
		controller.newBillRate.LaborCategory__c = 'Test Category';
		controller.saveNewBillRate();
		System.AssertEquals(1, [select Id from BillRate__c].size());
		//System.AssertEquals(1, controller.getLaborCategories().size());
		controller.createNewBillRatePeriod();
		controller.newBillRatePeriod.BillRateStart__c = Date.today().addDays(5);
		controller.newBillRatePeriod.BillRateEnd__c = Date.today().addDays(10);
		controller.saveNewBillRatePeriod();
		System.AssertEquals(2, controller.getPeriods().size());
							
    }

    static testMethod void controllerTest2() {
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
		
		BillRatePeriod__c billRatePeriod = new BillRatePeriod__c();
		billRatePeriod.BillRateStart__c = Date.today().addDays(-100);
		billRatePeriod.BillRateEnd__c = Date.today().addDays(-95);
		billRatePeriod.Agreement__c = agreement.Id;
		insert billRatePeriod;
		
		BillRate__c billRate = new BillRate__c();
		billRate.Agreement__c = agreement.Id;
		billRate.BillRatePeriod__c = billRatePeriod.Id;
		billRate.LaborCategory__c = 'Test 1';
		insert billRate;
		
		ApexPages.currentPage().getParameters().put('AgreementId',agreement.Id);
		ECO_BillRateManagement controller = new ECO_BillRateManagement();
		System.AssertEquals(1, controller.getLaborCategories().size());
		controller.createNewBillRatePeriod();
		controller.newBillRatePeriod.BillRateStart__c = Date.today();
		controller.newBillRatePeriod.BillRateEnd__c = Date.today().addDays(1);
		controller.saveNewBillRatePeriod();
		System.AssertEquals(2, [select Id from BillRatePeriod__c].size());
		controller.createNewBillRate();
		controller.newBillRate.LaborCategory__c = 'Test Category';
		controller.saveNewBillRate();
		System.AssertEquals(4, [select Id from BillRate__c].size());
		//System.AssertEquals(1, controller.getLaborCategories().size());
		controller.createNewBillRatePeriod();
		controller.newBillRatePeriod.BillRateStart__c = Date.today().addDays(5);
		controller.newBillRatePeriod.BillRateEnd__c = Date.today().addDays(10);
		controller.saveNewBillRatePeriod();
							
    }    
    
}