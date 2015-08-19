@isTest
private class ECO_ProjectAgreementControllerTest {

    static testMethod void testProjectAgreementController() {
    	
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
        
        ProjectAgreement__c projectAgreement = new ProjectAgreement__c();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(projectAgreement);
        
        ECO_ProjectAgreementController controller = new ECO_ProjectAgreementController(sc); 
        // TO DO: implement unit test
    }
}