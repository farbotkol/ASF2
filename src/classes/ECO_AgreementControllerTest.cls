@isTest
private class ECO_AgreementControllerTest {

    Static User testUser;
    Static Contact testContact;
    Static Id recordTypeId;
    Static pse__Proj__c project;
    Static Site__c testSite;
    Static Account testAccount;
    Static List<ProjectTeamMember__c> projectMembers;
    Static List<ProjectRole__c> projectRoles;

    static testMethod void testAgreementController() {
        final Integer numTestRisks = 50;

        setupTestData();

        Id primeRecordTypeId = [select Id from RecordType where Name = 'Prime' limit 1].Id;
        Agreement__c agreement = new Agreement__c(RecordTypeId = primeRecordTypeId);
        agreement.Account__c = testAccount.Id;
        agreement.Project__c = project.Id;
        agreement.FundingCurrencyCode__c = 'USD';
        agreement.Amount__c = 1000;
        insert agreement;

        ApexPages.StandardController sc = new ApexPages.StandardController(agreement);        
        ECO_AgreementController ecoAgreementController = new ECO_AgreementController(sc);
        ecoAgreementController.init();
        System.assertEquals('View', ecoAgreementController.getPageBlockMode());
        System.assertNotEquals(null, ecoAgreementController.editBillingRates());
        System.assertNotEquals(null, ecoAgreementController.initiateContractReview());
        System.assertEquals(null, ecoAgreementController.launchSegmentationQuestionnaire());
        System.assertNotEquals(null, ecoAgreementController.printPdf());
        System.assertEquals('Not Submitted', ecoAgreementController.getContractReviewStatus());
        System.assertEquals(8, ecoAgreementController.getContractDocumentTypes().size());
        System.assertEquals(2, ecoAgreementController.getBillingAccounts().size());
        System.assertNotEquals(null, ecoAgreementController.save());

        String myString = 'StringToBlob';
        Blob myBlob = Blob.valueof(myString);
        //ecoAgreementController.getProgramPlanAttach();
        ecoAgreementController.programPlanAttach.Name = 'test1';
        ecoAgreementController.programPlanAttach.Body = myBlob;
        ecoAgreementController.programPlanAttach.ContentType = 'test1';
        ecoAgreementController.saveProgramPlanAttachment();

        System.AssertEquals(1, [select Id, Name from Attachment where Name = 'test1'].size());
        ecoAgreementController.programPlanAttach.Name = 'test1';
        ecoAgreementController.programPlanAttach.Body = myBlob;
        ecoAgreementController.programPlanAttach.ContentType = 'test1';
        ecoAgreementController.saveProgramPlanAttachment();
        System.AssertEquals(2, ecoAgreementController.getAttachedProgramPlanFiles().size());       
    }

    static testMethod void testAgreementController2() {
        final Integer numTestRisks = 50;

        setupTestData();

        Id primeRecordTypeId = [select Id from RecordType where Name = 'Prime' limit 1].Id;
        Agreement__c agreement = new Agreement__c(RecordTypeId = primeRecordTypeId);
        agreement.Account__c = testAccount.Id;
        agreement.Project__c = project.Id;
        agreement.FundingCurrencyCode__c = 'USD';
        agreement.Amount__c = 1000;
        insert agreement;

        ApexPages.StandardController sc = new ApexPages.StandardController(agreement);        
        ECO_AgreementController ecoAgreementController = new ECO_AgreementController(sc);
        ecoAgreementController.init();

        String myString = 'StringToBlob';
        Blob myBlob = Blob.valueof(myString);

        ecoAgreementController.contractAttach.Name = 'test2';
        ecoAgreementController.contractAttach.Body = myBlob;
        ecoAgreementController.contractAttach.ContentType = 'test2';
        ecoAgreementController.saveContractAttachment();

        System.AssertEquals(1, [select Id, Name from Attachment where Name = 'test2'].size());
        ecoAgreementController.contractAttach.Name = 'test2';
        ecoAgreementController.contractAttach.Body = myBlob;
        ecoAgreementController.contractAttach.ContentType = 'test2';
        ecoAgreementController.saveContractAttachment();
        System.AssertEquals(2, ecoAgreementController.getAttachedContractFiles().size());        
    }    

    static testMethod void testAgreementController3() {
        final Integer numTestRisks = 50;

        setupTestData();

        Id primeRecordTypeId = [select Id from RecordType where Name = 'Prime' limit 1].Id;
        Agreement__c agreement = new Agreement__c(RecordTypeId = primeRecordTypeId);
        agreement.Account__c = testAccount.Id;
        agreement.Project__c = project.Id;
        agreement.FundingCurrencyCode__c = 'USD';
        agreement.Amount__c = 1000;
        insert agreement;

        ApexPages.StandardController sc = new ApexPages.StandardController(agreement);        
        ECO_AgreementController ecoAgreementController = new ECO_AgreementController(sc);
        ecoAgreementController.init();

        String myString = 'StringToBlob';
        Blob myBlob = Blob.valueof(myString);

        ecoAgreementController.guidanceAttach.Name = 'test3';
        ecoAgreementController.guidanceAttach.Body = myBlob;
        ecoAgreementController.guidanceAttach.ContentType = 'test3';
        ecoAgreementController.saveGuidanceAttachment();

        System.AssertEquals(1, [select Id, Name from Attachment where Name = 'test3'].size());
        ecoAgreementController.guidanceAttach.Name = 'test3';
        ecoAgreementController.guidanceAttach.Body = myBlob;
        ecoAgreementController.guidanceAttach.ContentType = 'test3';
        ecoAgreementController.saveGuidanceAttachment();
        System.AssertEquals(2, ecoAgreementController.getAttachedGuidanceFiles().size());        
    }     
    
    static testMethod void testAgreementController4() {
        final Integer numTestRisks = 50;

        setupTestData();

        Id primeRecordTypeId = [select Id from RecordType where Name = 'Prime' limit 1].Id;
        Agreement__c agreement = new Agreement__c(RecordTypeId = primeRecordTypeId);
        agreement.Account__c = testAccount.Id;
        agreement.Project__c = project.Id;
        agreement.FundingCurrencyCode__c = 'USD';
        agreement.Amount__c = 1000;
        insert agreement;

        ApexPages.StandardController sc = new ApexPages.StandardController(agreement);        
        ECO_AgreementController ecoAgreementController = new ECO_AgreementController(sc);
        ecoAgreementController.init();

        String myString = 'StringToBlob';
        Blob myBlob = Blob.valueof(myString);

        ecoAgreementController.businessDevelopmentAttach.Name = 'test4';
        ecoAgreementController.businessDevelopmentAttach.Body = myBlob;
        ecoAgreementController.businessDevelopmentAttach.ContentType = 'test4';
        ecoAgreementController.saveBusinessDevelopmentAttachment();

        System.AssertEquals(1, [select Id, Name from Attachment where Name = 'test4'].size());
        ecoAgreementController.businessDevelopmentAttach.Name = 'test4';
        ecoAgreementController.businessDevelopmentAttach.Body = myBlob;
        ecoAgreementController.businessDevelopmentAttach.ContentType = 'test4';
        ecoAgreementController.saveBusinessDevelopmentAttachment();
        System.AssertEquals(2, ecoAgreementController.getAttachedBusinessDevelopmentFiles().size());        
    }  

    static testMethod void testAgreementController5() {
        final Integer numTestRisks = 50;

        setupTestData();

        Id primeRecordTypeId = [select Id from RecordType where Name = 'Prime' limit 1].Id;
        Agreement__c agreement = new Agreement__c(RecordTypeId = primeRecordTypeId);
        agreement.Account__c = testAccount.Id;
        agreement.Project__c = project.Id;
        agreement.FundingCurrencyCode__c = 'USD';
        agreement.Amount__c = 1000;
        insert agreement;

        ApexPages.CurrentPage().getParameters().put('RecordTypeId', primeRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(agreement);        
        ECO_AgreementController ecoAgreementController = new ECO_AgreementController(sc);
        ecoAgreementController.init();

        String myString = 'StringToBlob';
        Blob myBlob = Blob.valueof(myString);

        ecoAgreementController.meetingMinutesAttach.Name = 'test5';
        ecoAgreementController.meetingMinutesAttach.Body = myBlob;
        ecoAgreementController.meetingMinutesAttach.ContentType = 'test5';
        ecoAgreementController.saveMeetingMinutesAttachment();

        System.AssertEquals(1, [select Id, Name from Attachment where Name = 'test5'].size());
        ecoAgreementController.meetingMinutesAttach.Name = 'test5';
        ecoAgreementController.meetingMinutesAttach.Body = myBlob;
        ecoAgreementController.meetingMinutesAttach.ContentType = 'test5';
        ecoAgreementController.saveMeetingMinutesAttachment();
        System.AssertEquals(2, ecoAgreementController.getAttachedMeetingMinutesFiles().size());    

        ecoAgreementController.save();

        System.assertNotEquals(null, ecoAgreementController.returnToProjectAgreements());    
    }  

    static testMethod void testAgreementController6()
    {
        setupTestData();

        Id primeRecordTypeId = [select Id from RecordType where Name = 'Prime' limit 1].Id;
        Agreement__c agreement = new Agreement__c(RecordTypeId = primeRecordTypeId);
        agreement.Account__c = testAccount.Id;
        agreement.Project__c = project.Id;
        agreement.FundingCurrencyCode__c = 'USD';
        agreement.Amount__c = 1000;
        //insert agreement;

        ApexPages.CurrentPage().getParameters().put('RecordType', primeRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(agreement);        
        ECO_AgreementController ecoAgreementController = new ECO_AgreementController(sc);
        ecoAgreementController.init();

        ecoAgreementController.save();

        System.assertNotEquals(null, ecoAgreementController.returnToProjectAgreements()); 

        /*Account testAccount = new Account();
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
        
        Id msaRecordType = ECO_Utils_Meta.getRecordTypeId(Agreement__c.sObjectType, 'Prime (MSA)');
        Agreement__c msaAgreement = new Agreement__c();
        msaAgreement.Account__c = testAccount.Id;
        msaAgreement.RecordTypeId = msaRecordType;
        msaAgreement.AgreementNumber__c = '123456';
        insert msaAgreement;            
        
        list<DOAConditions__c> conditions = new list <DOAConditions__c>();
        conditions.add(new DOAConditions__c(Agreement__c = msaAgreement.Id));
        conditions.add(new DOAConditions__c(Agreement__c = msaAgreement.Id));
        insert conditions;
        
        Id primeTaskOrderRecordType = ECO_Utils_Meta.getRecordTypeId(Agreement__c.sObjectType, 'Prime Task Order');
        Agreement__c agreement = new Agreement__c();
        agreement.Account__c = testAccount.Id;
        agreement.Project__c = testProject.Id;
        agreement.RecordTypeId = primeTaskOrderRecordType;      
        insert agreement;    
        
        ProjectAgreement__c projectAgreement = new ProjectAgreement__c();
        projectAgreement.Project__c = testProject.Id;
        projectAgreement.Agreement__c = agreement.Id;
        insert projectAgreement;
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(agreement);
        
        ApexPages.currentPage().getParameters().put('Mode', 'New');
        ApexPages.currentPage().getParameters().put('ProjectId', testProject.Id);
        ApexPages.currentPage().getParameters().put('saveURL', '/' + agreement.Id + '?ProjectId='+ testProject.Id);
        ApexPages.currentPage().getParameters().put('Agreement__c',agreement.Id);
        ApexPages.currentPage().getParameters().put('retURL', '/apex/ECO_ProjectAgreementpage?ProjectId=' + testProject.Id + '&RecordToDelete='+ agreement.Id);
               
        ECO_AgreementController controller = new ECO_AgreementController(standardController);
        controller.init();
        controller.MSAChanged = true;
        controller.agreement.MSAReference__c = msaAgreement.Id; 
        controller.save();
		//PageReference newAgreementRef = new PageReference('/' + newAgreement.Id);
		//newAgreementRef.getParameters().put('Mode', 'New');
		//newAgreementRef.getParameters().put('ProjectId', projectId);
		//newAgreementRef.getParameters().put('saveURL', '/' + newAgreement.Id + '?ProjectId='+ projectInfo.Id);
    	//newAgreementRef.getParameters().put('retURL', '/apex/ECO_ProjectAgreementpage?ProjectId=' + projectInfo.Id + '&RecordToDelete='+ newAgreement.Id);       	
    }*/
    }

    static testMethod void testAgreementController7()
    {
        setupTestData();

        Id primeRecordTypeId = [select Id from RecordType where Name = 'Prime' limit 1].Id;
        Agreement__c agreement = new Agreement__c(RecordTypeId = primeRecordTypeId);
        agreement.Account__c = testAccount.Id;
        agreement.Project__c = project.Id;
        agreement.FundingCurrencyCode__c = 'USD';
        agreement.Amount__c = 1000;
        insert agreement;

        ApexPages.CurrentPage().getParameters().put('RecordType', primeRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(agreement);        
        ECO_AgreementController ecoAgreementController = new ECO_AgreementController(sc);
        ecoAgreementController.init();
        ecoAgreementController.manageFunding();
        System.assertNotEquals(null, ecoAgreementController.returnToProjectAgreements()); 
    }

    static testMethod void testAgreementController8()
    {
        setupTestData();

        Id primeRecordTypeId = [select Id from RecordType where Name = 'Prime' limit 1].Id;
        Agreement__c agreement = new Agreement__c(RecordTypeId = primeRecordTypeId);
        agreement.Account__c = testAccount.Id;
        agreement.Project__c = project.Id;
        agreement.FundingCurrencyCode__c = 'USD';
        agreement.Amount__c = 1000;
        insert agreement;

        ApexPages.StandardController sc = new ApexPages.StandardController(agreement);        
        ECO_AgreementController ecoAgreementController = new ECO_AgreementController(sc);
        ecoAgreementController.init();
        System.AssertNotEquals(null, ecoAgreementController.manageFundingByProject());
        System.AssertNotEquals(null,ecoAgreementController.initAgreementScopeChanged());
    }

    static testMethod void testAgreementController9()
    {
        setupTestData();

        Id primeMSARecordTypeId = [select Id from RecordType where Name = 'Prime (MSA)' limit 1].Id;
        Agreement__c agreement = new Agreement__c(RecordTypeId = primeMSARecordTypeId);
        agreement.Account__c = testAccount.Id;
        agreement.Project__c = project.Id;
        agreement.FundingCurrencyCode__c = 'USD';
        agreement.Amount__c = 1000;
        insert agreement;

        ApexPages.StandardController sc = new ApexPages.StandardController(agreement);        
        ECO_AgreementController ecoAgreementController = new ECO_AgreementController(sc);
        ecoAgreementController.init();
        System.AssertEquals(null, ecoAgreementController.launchSegmentationQuestionnaire());
        System.AssertNotEquals(null, ecoAgreementController.msaProjectSnapshot());
        System.AssertNotEquals(null, ecoAgreementController.newManagementTeamMember());
    }

    static testMethod void testAgreementController10()
    {
        setupTestData();

        Id primeTaskOrderRecordTypeId = [select Id from RecordType where Name = 'Prime Task Order' limit 1].Id;
        Id primeMSARecordTypeId = [select Id from RecordType where Name = 'Prime (MSA)' limit 1].Id;

        Agreement__c msaAgreement = new Agreement__c(RecordTypeId = primeMSARecordTypeId);
        msaAgreement.Account__c = testAccount.Id;
        msaAgreement.FundingCurrencyCode__c = 'USD';
        msaAgreement.Amount__c = 1000;
        insert msaAgreement;

        Agreement__c agreement = new Agreement__c(RecordTypeId = primeTaskOrderRecordTypeId);
        agreement.Account__c = testAccount.Id;
        agreement.Project__c = project.Id;
        agreement.FundingCurrencyCode__c = 'USD';
        agreement.Amount__c = 1000;
        agreement.MSAReference__c = msaAgreement.Id;
        insert agreement;

        ApexPages.StandardController sc = new ApexPages.StandardController(msaAgreement);        
        ECO_AgreementController ecoAgreementController = new ECO_AgreementController(sc);
        ecoAgreementController.init();
        System.AssertNotEquals(null, ecoAgreementController.launchSegmentationQuestionnaire());
    }

    static testMethod void testAgreementController11()
    {
        setupTestData();

        Id primeTaskOrderRecordTypeId = [select Id from RecordType where Name = 'Prime Task Order' limit 1].Id;
        Id primeMSARecordTypeId = [select Id from RecordType where Name = 'Prime (MSA)' limit 1].Id;

        Agreement__c msaAgreement = new Agreement__c(RecordTypeId = primeMSARecordTypeId);
        msaAgreement.Account__c = testAccount.Id;
        msaAgreement.FundingCurrencyCode__c = 'USD';
        msaAgreement.Amount__c = 1000;
        insert msaAgreement;

        Agreement__c agreement = new Agreement__c(RecordTypeId = primeTaskOrderRecordTypeId);
        agreement.Account__c = testAccount.Id;
        agreement.Project__c = project.Id;
        agreement.FundingCurrencyCode__c = 'USD';
        agreement.Amount__c = 1000;
        agreement.MSAReference__c = msaAgreement.Id;
        insert agreement;

        ApexPages.StandardController sc = new ApexPages.StandardController(agreement);        
        ECO_AgreementController ecoAgreementController = new ECO_AgreementController(sc);
        ecoAgreementController.init();
        System.AssertNotEquals(null, ecoAgreementController.viewMSA());
        System.AssertNotEquals(null, ecoAgreementController.deleteAgreement());
    }

    static void setupTestData(){

        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        recordTypeId = ECO_Utils_sObject.getRecordTypeId(Contact.sObjectType, 'PSA Resource');

        testAccount = new Account();
        testAccount.Name = 'test account';
        insert testAccount;

        testUser = ECO_Utils_Testing.createTestUser('Standard User');
        testUser.TrackingID__c = 'test';
        insert testUser;

        //project sites
        testSite = new Site__c();
        testSite.Account__c = testAccount.Id;
        testSite.CurrencyIsoCode = 'USD';
        testSite.City__c = 'Winnipeg';      
        testSite.VendorSiteID__c = '654321';
        testSite.CustomerAccountSiteID__c = '666666';

        insert testSite;

        testContact = new Contact();
        testContact.Email = testUser.Email;
        testContact.FirstName = testUser.FirstName;
        testContact.LastName =  testUser.LastName;
        testContact.Phone = '55555555555';
        testContact.pse__Salesforce_User__c = testUser.Id;
        testContact.RecordTypeId = recordTypeId;
        testContact.User__c = testUser.Id;
        testContact.OwnerId = testUser.Id;
        testContact.Site__c = testSite.Id;
        testContact.AccountId = testAccount.Id;
        testContact.pse__Is_Resource_Active__c = true;
        testContact.pse__Is_Resource__c = true;
        insert testContact;

        OrganizationString__c organizationString = new OrganizationString__c(Name = 'Test Organization', ProjectAccountant2__c = testContact.Id, PLManagerContact__c = testContact.Id);
        insert organizationString;

        projectRoles = new List<ProjectRole__c>();
        projectRoles.add(new ProjectRole__c(Name = 'Project Manager', Type__c = 'Key Member', Active__c = true));
        projectRoles.add(new ProjectRole__c(Name = 'Project Approver 2', Type__c = 'Key Member', Active__c = true));
        projectRoles.add(new ProjectRole__c(Name = 'Project Approver', Type__c = 'Key Member', Active__c = true));
        projectRoles.add(new ProjectRole__c(Name = 'Resilience Director', Type__c = 'Key Member', Active__c = true));
        projectRoles.add(new ProjectRole__c(Name = 'Project Worker', Active__c = true));
        projectRoles.add(new ProjectRole__c(Name = 'Finance Lead', Type__c = 'Key Member', Active__c = true));
        insert projectRoles;

        List<pse__Proj__c> projects = new List<pse__Proj__c>();
        projects.add(new pse__Proj__c(CarryingOutOrganization__c = organizationString.Id, pse__Account__c = testAccount.Id, pse__Start_Date__c = Date.today().addDays(30), pse__End_Date__c = Date.today().addDays(60)));
        projects.add(new pse__Proj__c(CarryingOutOrganization__c = organizationString.Id, pse__Account__c = testAccount.Id, pse__Start_Date__c = Date.today().addDays(-30), pse__End_Date__c = Date.today().addDays(-1)));
        insert projects;
        project = projects[0];

        Project_Site__c testProjectSite = new Project_Site__c();
        
        testProjectSite.BillingContactID__c = '1234';
        //testProjectSite.OracleProjectSiteId__c = '1111';
        testProjectSite.Project__c = project.Id;
        testProjectSite.Site__c = testSite.Id;
        testProjectSite.Contribution__c = 100;

        insert testProjectSite;


        projectMembers = new List<ProjectTeamMember__c>();
        projectMembers.add(new ProjectTeamMember__c(Project__c = project.Id, CurrencyIsoCode = 'USD', ProjectRole__c = projectRoles[0].Id, Contact__c = testContact.Id, StartDate__c = Date.today(), EndDate__c = Date.today().addDays(1)));
        projectMembers.add(new ProjectTeamMember__c(Project__c = project.Id, CurrencyIsoCode = 'USD', ProjectRole__c = projectRoles[1].Id, Contact__c = testContact.Id, StartDate__c = Date.today().addDays(2), EndDate__c = Date.today().addDays(3)));
        projectMembers.add(new ProjectTeamMember__c(Project__c = project.Id, CurrencyIsoCode = 'USD', ProjectRole__c = projectRoles[3].Id, Contact__c = testContact.Id, StartDate__c = Date.today().addDays(4), EndDate__c = Date.today().addDays(5)));
        projectMembers.add(new ProjectTeamMember__c(Project__c = project.Id, CurrencyIsoCode = 'USD', ProjectRole__c = projectRoles[5].Id, Contact__c = testContact.Id, StartDate__c = Date.today().addDays(5), EndDate__c = Date.today().addDays(6)));
        projectMembers.add(new ProjectTeamMember__c(Project__c = project.Id, CurrencyIsoCode = 'USD', ProjectRole__c = projectRoles[4].Id, Contact__c = testContact.Id, StartDate__c = Date.today(), Is_Active__c = true));
        projectMembers.add(new ProjectTeamMember__c(Project__c = projects[1].Id, CurrencyIsoCode = 'USD', ProjectRole__c = projectRoles[1].Id, Contact__c = testContact.Id, StartDate__c = Date.today().addDays(-30)));
        insert projectMembers;

        SurveySchedule__c surveySchedule = new SurveySchedule__c(Account__c = testAccount.Id, Client__c = testSite.Id, Contact__c = testContact.Id, Project__c = project.Id, ScheduledDate__c = Date.today().addDays(10));
        insert surveySchedule;

    }
}