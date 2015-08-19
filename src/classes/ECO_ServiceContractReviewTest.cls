@isTest
private class ECO_ServiceContractReviewTest {

    static testMethod void myUnitTest() {
        ECO_Utils_Testing.createTestDataForProjectSync(1, 2);
        
       	pse__Proj__c testProject = [SELECT Id, Name FROM pse__Proj__c LIMIT 1];
       	
       	Id recordTypeId = ECO_Utils_sObject.getRecordTypeId(Agreement__c.sObjectType, 'Prime Task Order');
       	Agreement__c testAgreement = new Agreement__c();
       	testAgreement.FundingCurrencyCode__c = 'USD';
       	testAgreement.ScopeOfServices__c = 'Test Services';
       	testAgreement.RecordTypeId = recordTypeId;
       	testAgreement.ProfIndemnityLiabilityAmt__c = 1000;
       	testAgreement.PublicGeneralLiabilityAmt__c = 1000;
       	testAgreement.AgreementType__c = 'Test Agreement Type';
       	insert testAgreement;
       	
       	ProjectAgreement__c projectAgreement = new ProjectAgreement__c(Agreement__c = testAgreement.Id, Project__c = testProject.Id);
       	insert projectAgreement;
       	
       	list<ECO_ContractReviewDTO> contractReviewDTOs = ECO_Service_ContractReview.getContractReivewDTOs(testAgreement.Id);
       	System.AssertEquals(1, contractReviewDTOs.size());
        
    }
    
    static testMethod void myUnitTest2() {
        ECO_Utils_Testing.createTestDataForProjectSync(1, 2);
        //ECO_Utils_Testing.createTestDataForProjectSync(1, 2);
        
       	pse__Proj__c testProject = [SELECT Id, Name FROM pse__Proj__c];
       	
       	Id recordTypeId = ECO_Utils_sObject.getRecordTypeId(Agreement__c.sObjectType, 'Prime Task Order');
       	Agreement__c testAgreement = new Agreement__c();
       	testAgreement.FundingCurrencyCode__c = 'USD';
       	testAgreement.ScopeOfServices__c = 'Test Services';
       	testAgreement.RecordTypeId = recordTypeId;
       	testAgreement.ProfIndemnityLiabilityAmt__c = 1000;
       	testAgreement.PublicGeneralLiabilityAmt__c = 1000;
       	testAgreement.AgreementType__c = 'Test Agreement Type';
       	insert testAgreement;
       	
       	Account testAccount = new Account();
		testAccount.Name = 'test Account';
		insert testAccount;
		
		//create create source project 
		pse__Proj__c testProject2 = new pse__Proj__c();
		testProject2.Name = 'test project 2';
		testProject2.pse__Account__c = testAccount.Id;
		testProject2.pse__Project_Type__c = 'Customer Project';
		testProject2.pse__Billing_Type__c = 'Fixed Price';
		testProject2.CurrencyIsoCode = 'USD';
		testProject2.pse__Is_Active__c = true;
		testProject2.pse__End_Date__c = Date.today().addDays(5);
		insert testProject2;		
       	
       	ProjectAgreement__c projectAgreement1 = new ProjectAgreement__c(Agreement__c = testAgreement.Id, Project__c = testProject.Id);
       	ProjectAgreement__c projectAgreement2 = new ProjectAgreement__c(Agreement__c = testAgreement.Id, Project__c = testProject2.Id);
       	insert projectAgreement1;
       	insert projectAgreement2;
       	   	
       	list<ECO_ContractReviewDTO> contractReviewDTOs = ECO_Service_ContractReview.getContractReivewDTOs(testAgreement.Id);
       	System.AssertEquals(2, contractReviewDTOs.size());
        
    }    
    
}