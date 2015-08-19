@isTest
private class ECO_AgreementControllerTest {

    static testMethod void testAgreementController() {
        final Integer numTestRisks = 50;

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
        agreement.Project__c = testProject.Id;
        //agreement.Description__c = 'Test Agreement';
        
        insert agreement;
        
        String myString = 'StringToBlob';
        Blob myBlob = Blob.valueof(myString);

        ApexPages.StandardController sc = new ApexPages.StandardController(agreement);
        
        ECO_AgreementController ecoAgreementController = new ECO_AgreementController(sc);

        ecoAgreementController.init();
        //Contract
        
        system.AssertEquals('View',ecoAgreementController.getPageBlockMode());
        ecoAgreementController.contractAttach.Name = 'test1';
        ecoAgreementController.contractAttach.Body = myBlob;
        ecoAgreementController.contractAttach.ContentType = 'test1';
        ecoAgreementController.saveContractAttachment();
        System.AssertEquals(1, [select Id, Name from Attachment where Name = 'test1'].size());
        ecoAgreementController.contractAttach.Name = 'test1';
        ecoAgreementController.contractAttach.Body = myBlob;
        ecoAgreementController.contractAttach.ContentType = 'test1';
        ecoAgreementController.overrideContractAttachmentName = 'overrideTest1';
        ecoAgreementController.saveContractAttachment();
        System.AssertEquals(2, ecoAgreementController.getAttachedContractFiles().size());
        
        //Program Plan
        ecoAgreementController.programPlanAttach.Name = 'test2';
        ecoAgreementController.programPlanAttach.Body = myBlob;
        ecoAgreementController.programPlanAttach.ContentType = 'test2';
        ecoAgreementController.saveProgramPlanAttachment();
        System.AssertEquals(1, [select Id, Name from Attachment where Name = 'test2'].size());  
        ecoAgreementController.programPlanAttach.Name = 'test2';
        ecoAgreementController.programPlanAttach.Body = myBlob;
        ecoAgreementController.programPlanAttach.ContentType = 'test2';
        ecoAgreementController.overrideProgramPlanAttachmentName = 'overrideTest2';
        ecoAgreementController.saveProgramPlanAttachment();         
        System.AssertEquals(2, ecoAgreementController.getAttachedProgramPlanFiles().size());  

        //Guidance
        ecoAgreementController.guidanceAttach.Name = 'test3';
        ecoAgreementController.guidanceAttach.Body = myBlob;
        ecoAgreementController.guidanceAttach.ContentType = 'test3';
        ecoAgreementController.saveGuidanceAttachment();
        System.AssertEquals(1, [select Id, Name from Attachment where Name = 'test3'].size());
        ecoAgreementController.guidanceAttach.Name = 'test3';
        ecoAgreementController.guidanceAttach.Body = myBlob;
        ecoAgreementController.guidanceAttach.ContentType = 'test3';
        ecoAgreementController.overrideGuidanceAttachmentName = 'overridetest4';
        ecoAgreementController.saveGuidanceAttachment();        
        System.AssertEquals(2, ecoAgreementController.getAttachedGuidanceFiles().size());
        
        //Business Development
        ecoAgreementController.businessDevelopmentAttach.Name = 'test4';
        ecoAgreementController.businessDevelopmentAttach.Body = myBlob;
        ecoAgreementController.businessDevelopmentAttach.ContentType = 'test4';
        ecoAgreementController.saveBusinessDevelopmentAttachment();
        System.AssertEquals(1, [select Id, Name from Attachment where Name = 'test4'].size());
        ecoAgreementController.businessDevelopmentAttach.Name = 'test4';
        ecoAgreementController.businessDevelopmentAttach.Body = myBlob;
        ecoAgreementController.businessDevelopmentAttach.ContentType = 'test4';
        ecoAgreementController.overrideBusinessDevelopmentAttachmentName = 'overridetest4';
        ecoAgreementController.saveBusinessDevelopmentAttachment();
        System.AssertEquals(2, ecoAgreementController.getAttachedBusinessDevelopmentFiles().size());

        //Meeting Minutes
        ecoAgreementController.meetingMinutesAttach.Name = 'test5';
        ecoAgreementController.meetingMinutesAttach.Body = myBlob;
        ecoAgreementController.meetingMinutesAttach.ContentType = 'test5';
        ecoAgreementController.saveMeetingMinutesAttachment();
        System.AssertEquals(1, [select Id, Name from Attachment where Name = 'test5'].size());
        ecoAgreementController.meetingMinutesAttach.Name = 'test5';
        ecoAgreementController.meetingMinutesAttach.Body = myBlob;
        ecoAgreementController.meetingMinutesAttach.ContentType = 'test5';
        ecoAgreementController.overrideMeetingMinutesAttachmentName = 'overrideTest5';
        ecoAgreementController.saveMeetingMinutesAttachment();
        System.AssertEquals(2, ecoAgreementController.getAttachedMeetingMinutesFiles().size());
   
        //ecoAgreementController.save();
        ecoAgreementController.editBillingRates();
        ecoAgreementController.getData();
        //ecoAgreementController.getRemoteData();
        //ecoAgreementController.createNewAgreement();
        System.AssertNotEquals(null, ecoAgreementController.createNewNote());
        System.AssertNotEquals(null, ecoAgreementController.returnToAgreement());
    }
    
    static testMethod void testAgreementController2()
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
    }
}