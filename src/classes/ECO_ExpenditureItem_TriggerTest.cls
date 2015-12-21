@isTest
private class ECO_ExpenditureItem_TriggerTest {
    static User testUser;
    static Contact testContact;
    static Id recordTypeId;
    static pse__Proj__c project;
    static pse__Project_Task__c projTask;
    static Site__c testSite;
    static Account testAccount;
    static List<ProjectTeamMember__c> projectMembers;
    static List<ProjectRole__c> projectRoles;
    static List<ExpenditureType__c> expTypeList;

    @testSetup static void setupTestData() {
        expTypeList = new List<ExpenditureType__c>();
        for (Integer i=0; i<2; i++) {
            expTypeList.add(new ExpenditureType__c(Name='et'+i, ExpenditureCategory__c='ExpenditureCategory'+i, 
                PLReportCategory__c='PLReportCategory'+i, ResourceType__c='rt'+i));    
        }
        insert expTypeList;
        
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        recordTypeId = ECO_Utils_sObject.getRecordTypeId(Contact.sObjectType, 'PSA Resource');

        testAccount = new Account();
        testAccount.Name = 'test account';
        insert testAccount;

        testUser = ECO_Utils_Testing.createTestUser('Standard User');
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
        insert projectRoles;

        project = new pse__Proj__c(CarryingOutOrganization__c = organizationString.Id, 
            pse__Account__c = testAccount.Id, pse__Start_Date__c = Date.today().addDays(30), 
            pse__End_Date__c = Date.today().addDays(60));
        insert project;

        Project_Site__c testProjectSite = new Project_Site__c();
        
        testProjectSite.BillingContactID__c = '1234';
        testProjectSite.OracleProjectSiteId__c = '1111';
        testProjectSite.Project__c = project.Id;
        testProjectSite.Site__c = testSite.Id;
        testProjectSite.Contribution__c = 100;

        insert testProjectSite;

        projectMembers = new List<ProjectTeamMember__c>();
        projectMembers.add(new ProjectTeamMember__c(Project__c = project.Id, CurrencyIsoCode = 'USD', 
            ProjectRole__c = projectRoles[0].Id, Contact__c = testContact.Id, 
            StartDate__c = Date.today(), EndDate__c = Date.today().addDays(1)));
        insert projectMembers;

        projTask = new pse__Project_Task__c(Name='pTask', pse__Project__c=project.Id,
            pse__Start_Date_Time__c = DateTime.now(), pse__End_Date_Time__c = DateTime.now().addDays(1));
        insert projTask;
        
        pse__Time_Period__c timePeriod = new pse__Time_Period__c();
		timePeriod.pse__Start_Date__c = Date.Today();
		timePeriod.pse__End_Date__c = Date.Today().addDays(7);
		timePeriod.TimePeriodCode__c = 'FY2015-02';
		timePeriod.pse__Type__c = 'Month';
		insert timePeriod;
		
		
		timePeriod = new pse__Time_Period__c();
		timePeriod.pse__Start_Date__c = Date.Today().AddDays(-8);
		timePeriod.pse__End_Date__c = Date.Today().addDays(-1);
		timePeriod.TimePeriodCode__c = 'FY2015-01';
		timePeriod.pse__Type__c = 'Month';
		insert timePeriod;
    }

    private static testMethod void testInsertExpItem() {
        String expTypeName = 'et1';
        ExpenditureType__c expType = [SELECT Name, PLReportCategory__c, ExpenditureCategory__c, ResourceType__c 
                     FROM ExpenditureType__c WHERE Name =: expTypeName LIMIT 1];
        System.debug('___expType='+expType);

        pse__Proj__c project1 = [SELECT Id FROM pse__Proj__c LIMIT 1];

        pse__Project_Task__c projTask1 = [SELECT Id FROM pse__Project_Task__c LIMIT 1];

        ExpendItem__c expItem = new ExpendItem__c(ExpenditureType__c = expTypeName,
            ProjectTask__c=projTask1.Id,
            ExpenditureItemDate__c = Date.Today());

        test.startTest();
        insert expItem;
        System.debug('___INSERTED expItem='+expItem);
        test.stopTest();

        ExpendItem__c expItemSaved = [SELECT PLReportCategory__c, ExpenditureTypeCategory__c, 
            ExpenditureResourceType__c, ExpenditureDateFiscalMonth__c, ExpenditureDatePreviousFiscalMonth__c FROM ExpendItem__c WHERE ExpenditureType__c =: expTypeName LIMIT 1];
        System.debug('___expItemSaved='+expItemSaved);
        System.assertNotEquals(null, expItemSaved);
        System.assertEquals('PLReportCategory1', expItemSaved.PLReportCategory__c);
        System.assertEquals('ExpenditureCategory1', expItemSaved.ExpenditureTypeCategory__c);
        System.assertEquals('rt1', expItemSaved.ExpenditureResourceType__c);
        System.AssertEquals(expItemSaved.ExpenditureDateFiscalMonth__c, 'FY2015-02');
        //System.AssertEquals(expItemSaved.ExpenditureDatePreviousFiscalMonth__c, 'FY2015-01');
    }

    private static testMethod void testUpdateExpItem() {
        pse__Proj__c project1 = [SELECT Id FROM pse__Proj__c LIMIT 1];

        pse__Project_Task__c projTask1 = [SELECT Id FROM pse__Project_Task__c LIMIT 1];

        //ERROR: ExpendItem__c expItem = new ExpendItem__c(ExpenditureType__c = expTypeList[0].Name,
            //ProjectTask__c=projTask1.Id);

        List<ExpenditureType__c> expTypes = [SELECT Name FROM ExpenditureType__c];
        ExpendItem__c expItem = new ExpendItem__c(ExpenditureType__c = expTypes[0].Name,
            ProjectTask__c=projTask1.Id);

        test.startTest();
        insert expItem;
        System.debug('___INSERTED expItem='+expItem);
        ExpendItem__c expItemInserted = [SELECT PLReportCategory__c, ExpenditureTypeCategory__c, 
            ExpenditureResourceType__c FROM ExpendItem__c WHERE ExpenditureType__c =: expTypes[0].Name LIMIT 1];
        
        System.assertNotEquals(null, expItemInserted);
        System.assertEquals('PLReportCategory0', expItemInserted.PLReportCategory__c);
        System.assertEquals('ExpenditureCategory0', expItemInserted.ExpenditureTypeCategory__c);
        System.assertEquals('rt0', expItemInserted.ExpenditureResourceType__c);

        expItem.ExpenditureType__c = expTypes[1].Name;
        update expItem;
        test.stopTest();

        ExpendItem__c expItemUpdated = [SELECT PLReportCategory__c, ExpenditureTypeCategory__c, 
            ExpenditureResourceType__c FROM ExpendItem__c WHERE ExpenditureType__c =: expTypes[1].Name LIMIT 1];
        System.debug('___expItemUpdated='+expItemUpdated);
        System.assertNotEquals(null, expItemUpdated);
        System.assertEquals('PLReportCategory1', expItemUpdated.PLReportCategory__c);
        System.assertEquals('ExpenditureCategory1', expItemUpdated.ExpenditureTypeCategory__c);
        System.assertEquals('rt1', expItemUpdated.ExpenditureResourceType__c);
    }
}