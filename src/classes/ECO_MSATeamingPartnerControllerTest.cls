@isTest
public class ECO_MSATeamingPartnerControllerTest {

	static testMethod void testController()
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
        insert testProject;
        
        Agreement__c agreement = new Agreement__c();
        agreement.Account__c = testAccount.Id;
        
        insert agreement;
        
        MSATeamingPartner__c teamingPartner = new MSATeamingPartner__c();
        ApexPages.StandardController standardController = new ApexPages.StandardController(teamingPartner);
        ApexPages.currentPage().getParameters().put('Agreement__c',agreement.Id);
        ECO_MSATeamingPartnerController controller = new ECO_MSATeamingPartnerController(standardController);
        controller.init();
        controller.save();
        
        teamingPartner = [select Id, Agreement__c from MSATeamingPartner__c limit 1];
        system.AssertEquals(agreement.Id, teamingPartner.Agreement__c);       
	}
}