@isTest
public class ECO_AgreementTriggerHandlerTest {

    static testMethod void testAgreementTriggerHandler() {
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
        
        Agreement__c agreement = new Agreement__c(Project__c = testProject.Id, ProjectAgreementRecordCount__c = 1);
        insert agreement;
        
        agreement.ChangeManagerApprovedForSynch__c = true;
        
        try
    	{
    		update agreement;
    	}
    	catch(Exception e)
		{
			Boolean expectedExceptionThrown =  e.getMessage().contains('This agreement is associated to Project that does not have an Oracle Project Number.  Please get an Oracle Project Number before proceeding with Synch') ? true : false;
			System.AssertEquals(expectedExceptionThrown, true);
		} 
    }
    
	static testMethod void testAgreementTriggerHandlerUpdateAgreementNumber() {
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
        testProject.OracleProjectNumber__c = '12345';
        insert testProject;
        

        Id msaRecordType = ECO_Utils_Meta.getRecordTypeId(Agreement__c.sObjectType, 'Prime (MSA)');
        Agreement__c msaAgreement = new Agreement__c(ProjectAgreementRecordCount__c = 1, RecordTypeId = msaRecordType);
        insert msaAgreement;

        Agreement__c agreement = new Agreement__c(Project__c = testProject.Id, ProjectAgreementRecordCount__c = 1, MSAReference__c = msaAgreement.Id);
        insert agreement;
   
        agreement.ChangeManagerApprovedForSynch__c = true;
        update agreement;
        
		list<Agreement__c> agreements = [select Id, AgreementNumber__c from Agreement__c order by id desc];
		System.AssertEquals('12345-1', agreements[0].AgreementNumber__c);
    }

    static testMethod void testAgreementTriggerHandlerSegmentation() {
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
        testProject.OracleProjectNumber__c = '12345';
        insert testProject;

        Id msaRecordType = ECO_Utils_Meta.getRecordTypeId(Agreement__c.sObjectType, 'Prime (MSA)');
        Agreement__c msaAgreement = new Agreement__c(ProjectAgreementRecordCount__c = 1, RecordTypeId = msaRecordType);
        insert msaAgreement;        
        
        Agreement__c agreement = new Agreement__c(Project__c = testProject.Id, ProjectAgreementRecordCount__c = 1, MSAReference__c = msaAgreement.Id);
        insert agreement;
        
        ProjectAgreement__c projectAgreement = new ProjectAgreement__c(Project__c = testProject.Id, Agreement__c = agreement.Id);
        insert projectAgreement;


        msaAgreement.SegApprovalStatus__c = 'Approved';
        update msaAgreement;
        //agreement.ChangeManagerApprovedForSynch__c = true;
        //update agreement;
        
        list<Agreement__c> agreements = [select Id, AgreementNumber__c from Agreement__c order by id desc];
        System.AssertEquals('12345-1', agreements[0].AgreementNumber__c);
    }    
    
}