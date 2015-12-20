@isTest
private class ECO_Service_ProjectSnapshotTest {

   /*static testMethod void testSingleProject() {
       
        Account testAccount = new Account();
        testAccount.Name = 'test account';
        insert testAccount;
        
        pse__Proj__c testProject = new pse__Proj__c();
        testProject.pse__Account__c = testAccount.Id;
        testProject.EscalationApplies__c = true;
        testProject.EscalationDate__c = Date.today();
        testProject.EscalationDescription__c = 'Test Desc';
        insert testProject;
        
        BudgetHeader__c testHeader = new BudgetHeader__c();
        testHeader.Project__c = testProject.Id;
        testHeader.Status__c = 'Approved';
        insert testHeader;
        
        BudgetResource__c testResource = new BudgetResource__c();
        testResource.BudgetHeader__c = testHeader.Id;
        testResource.ResourceName__c = 'test resource';
        insert testResource;
        
        BudgetTask__c testTask = new BudgetTask__c();
        testTask.BudgetHeader__c = testHeader.Id;
        testTask.TaskName__c = 'test task';
        insert testTask;
        
        BudgetAssignment__c testAssignment = new BudgetAssignment__c();
        testAssignment.BudgetTask__c = testTask.Id;
        testAssignment.BudgetResource__c = testResource.Id;
        testAssignment.Quantity__c = 1;
        testAssignment.OverrideRawCost__c = 1;
        testAssignment.OverrideBillRate__c = 1;
        insert testAssignment;
        
        list<Revenue__c> revenues = new list<Revenue__c>();
        Revenue__c revenue = new Revenue__c();
        revenue.ProjectNumber__c = testProject.Id;
        revenue.Amount__c = 2000;
        revenue.GLDate__c = Date.today();
        revenues.add(revenue);
        
        Revenue__c revenue2 = new Revenue__c();
        revenue2.ProjectNumber__c = testProject.Id;
        revenue2.Amount__c = 2000;
        revenue2.GLDate__c = Date.today().addDays(-91);
        revenues.add(revenue2);
        
        insert revenues;

        List<OrganizationString__c> lOrgStrings = new List<OrganizationString__c>();
        OrganizationString__c Org1 = INC_Utils_Testing.createTestOrg();
        lOrgStrings.add(Org1);
        OrganizationString__c Org2 = INC_Utils_Testing.createTestOrg();
        
        
        Org2.OrganizationName__c = 'Water Organization';
        Org2.Name = 'Water Organization';
        Org2.BusinessLineName__c = 'Water';
        Org2.Department__c = 'Water Department';
        Org2.District__c = 'Water District';
        Org2.Description__c = 'Water org string';
        Org2.GeographyName__c = 'Water Geo';
        Org2.Region__c = 'Water Region';
        Org2.OrgID__c = '227';
        Org2.OUID__c = '999';
        org2.InactiveDate__c = null;

        lOrgStrings.add(Org2);
        insert lOrgStrings;     
        
        list<ProjectOrganization__c> projectOrgs = new list<ProjectOrganization__c>();
        ProjectOrganization__c projectOrg1 = new ProjectOrganization__c();
        projectOrg1.Project__c = testProject.Id;
        projectOrg1.OrganizationString__c = lOrgStrings[0].Id;
        projectOrg1.Type__c = 'Primary';
        projectOrg1.ContributionPercent__c = 75;
        projectOrgs.add(projectOrg1);
        
        ProjectOrganization__c projectOrg2 = new ProjectOrganization__c();
        projectOrg2.Project__c = testProject.Id;
        projectOrg2.OrganizationString__c = lOrgStrings[1].Id;
        projectOrg2.Type__c = 'Secondary';
        projectOrg2.ContributionPercent__c = 25;
        projectOrgs.add(projectOrg2);
        insert projectOrgs;
        
        Id changeOrderRecordTypeId = ECO_Utils_Meta.getRecordTypeId(BudgetHeader__c.sObjectType, 'Change Order');
        BudgetHeader__c bheader = new BudgetHeader__c();
        bheader.BudgetName__c = 'Change Order 1';
        bheader.ChangeManagerApprovedForSynch__c = true;
        bheader.Project__c = testProject.Id;
        bheader.RecordTypeId = changeOrderRecordTypeId;
        insert bheader;

        BudgetHeader__c bheader2 = new BudgetHeader__c();
        bheader2.BudgetName__c = 'Change Order 2';
        bheader2.ChangeManagerApprovedForSynch__c = true;
        bheader2.Project__c = testProject.Id;
        bheader2.RecordTypeId = changeOrderRecordTypeId;
        insert bheader2;        
                
        ECO_Service_ProjectSnapshots projectService = new ECO_Service_ProjectSnapshots(testProject.Id);     
        ProjectSnapshot__c projectSnapshot = projectService.getProjectSnapshot();
        System.AssertEquals(1, projectSnapshot.GrossRevenueBudget__c);
        System.AssertEquals(4000, projectSnapshot.GrossRevenueYearToDate__c);
        System.AssertEquals(2000, projectSnapshot.GrossRevenueMonthToDate__c);
        System.AssertEquals(4000, projectSnapshot.GrossRevenueITD__c);
        
        System.AssertEquals('Change Order 1;;0.00;;0.00::Change Order 2;;0.00;;0.00', projectSnapshot.ChangeOrdersPending__c);
    }
    
    static testMethod void testMultipleProjects() {
       
        Account testAccount = new Account();
        testAccount.Name = 'test account';
        insert testAccount;
        
        list<pse__Proj__c> projects = new list<pse__Proj__c>();
        pse__Proj__c testProject = new pse__Proj__c();
        testProject.pse__Account__c = testAccount.Id;
        testProject.EscalationApplies__c = true;
        testProject.EscalationDate__c = Date.today();
        testProject.EscalationDescription__c = 'Test Desc';
        projects.add(testProject);
        
        pse__Proj__c testProject2 = new pse__Proj__c();
        testProject2.pse__Account__c = testAccount.Id;
        testProject2.EscalationApplies__c = true;
        testProject2.EscalationDate__c = Date.today();
        testProject2.EscalationDescription__c = 'Test Desc 2';
        projects.add(testProject2);
        insert projects;        
        
        list<BudgetHeader__c> headers = new list<BudgetHeader__c>();    
        BudgetHeader__c testHeader = new BudgetHeader__c();
        testHeader.Project__c = testProject.Id;
        testHeader.Status__c = 'Approved';
        headers.add(testHeader);
        
        BudgetHeader__c testHeader2 = new BudgetHeader__c();
        testHeader2.Project__c = testProject2.Id;
        testHeader2.Status__c = 'Approved';
        headers.add(testHeader2);
        insert headers;     
            
        list<BudgetResource__c> resources = new list<BudgetResource__c>();
        BudgetResource__c testResource = new BudgetResource__c();
        testResource.BudgetHeader__c = testHeader.Id;
        testResource.ResourceName__c = 'test resource';
        resources.add(testResource);
        
        BudgetResource__c testResource2 = new BudgetResource__c();
        testResource2.BudgetHeader__c = testHeader.Id;
        testResource2.ResourceName__c = 'test resource';
        resources.add(testResource2);
        insert resources;       
        
        list<BudgetTask__c> tasks = new list<BudgetTask__c>();
        BudgetTask__c testTask = new BudgetTask__c();
        testTask.BudgetHeader__c = testHeader.Id;
        testTask.TaskName__c = 'test task';
        tasks.add(testTask);
        
        BudgetTask__c testTask2 = new BudgetTask__c();
        testTask2.BudgetHeader__c = testHeader2.Id;
        testTask2.TaskName__c = 'test task 2';
        tasks.add(testTask2);
        insert tasks;       
        
        BudgetAssignment__c testAssignment = new BudgetAssignment__c();
        testAssignment.BudgetTask__c = testTask.Id;
        testAssignment.BudgetResource__c = testResource.Id;
        testAssignment.Quantity__c = 1;
        testAssignment.OverrideRawCost__c = 1;
        testAssignment.OverrideBillRate__c = 1;
        insert testAssignment;
        
        BudgetAssignment__c testAssignment2 = new BudgetAssignment__c();
        testAssignment2.BudgetTask__c = testTask2.Id;
        testAssignment2.BudgetResource__c = testResource2.Id;
        testAssignment2.Quantity__c = 1;
        testAssignment2.OverrideRawCost__c = 1;
        testAssignment2.OverrideBillRate__c = 1;
        insert testAssignment2;     
        
        list<Revenue__c> revenues = new list<Revenue__c>();
        Revenue__c revenue = new Revenue__c();
        revenue.ProjectNumber__c = testProject.Id;
        revenue.Amount__c = 2000;
        revenue.GLDate__c = Date.today();
        revenues.add(revenue);
        
        Revenue__c revenue2 = new Revenue__c();
        revenue2.ProjectNumber__c = testProject.Id;
        revenue2.Amount__c = 2000;
        revenue2.GLDate__c = Date.today().addDays(-91);
        revenues.add(revenue2);

        Revenue__c revenue3 = new Revenue__c();
        revenue3.ProjectNumber__c = testProject2.Id;
        revenue3.Amount__c = 2000;
        revenue3.GLDate__c = Date.today();
        revenues.add(revenue3);
        
        Revenue__c revenue4 = new Revenue__c();
        revenue4.ProjectNumber__c = testProject2.Id;
        revenue4.Amount__c = 2000;
        revenue4.GLDate__c = Date.today().addDays(-91);
        revenues.add(revenue4);     
        insert revenues;

        List<OrganizationString__c> lOrgStrings = new List<OrganizationString__c>();
        OrganizationString__c Org1 = INC_Utils_Testing.createTestOrg();
        lOrgStrings.add(Org1);
        OrganizationString__c Org2 = INC_Utils_Testing.createTestOrg();
        
        
        Org2.OrganizationName__c = 'Water Organization';
        Org2.Name = 'Water Organization';
        Org2.BusinessLineName__c = 'Water';
        Org2.Department__c = 'Water Department';
        Org2.District__c = 'Water District';
        Org2.Description__c = 'Water org string';
        Org2.GeographyName__c = 'Water Geo';
        Org2.Region__c = 'Water Region';
        Org2.OrgID__c = '227';
        Org2.OUID__c = '999';
        org2.InactiveDate__c = null;

        lOrgStrings.add(Org2);
        insert lOrgStrings;     
        
        list<ProjectOrganization__c> projectOrgs = new list<ProjectOrganization__c>();
        ProjectOrganization__c projectOrg1 = new ProjectOrganization__c();
        projectOrg1.Project__c = testProject.Id;
        projectOrg1.OrganizationString__c = lOrgStrings[0].Id;
        projectOrg1.Type__c = 'Primary';
        projectOrg1.ContributionPercent__c = 75;
        projectOrgs.add(projectOrg1);
        
        ProjectOrganization__c projectOrg2 = new ProjectOrganization__c();
        projectOrg2.Project__c = testProject.Id;
        projectOrg2.OrganizationString__c = lOrgStrings[1].Id;
        projectOrg2.Type__c = 'Secondary';
        projectOrg2.ContributionPercent__c = 25;
        projectOrgs.add(projectOrg2);
        
        ProjectOrganization__c projectOrg3 = new ProjectOrganization__c();
        projectOrg3.Project__c = testProject2.Id;
        projectOrg3.OrganizationString__c = lOrgStrings[1].Id;
        projectOrg3.Type__c = 'Primary';
        projectOrg3.ContributionPercent__c = 100;
        projectOrgs.add(projectOrg3);
                
        insert projectOrgs;
        
        list<BudgetHeader__c> bheaders = new list<BudgetHeader__c>();
        Id changeOrderRecordTypeId = ECO_Utils_Meta.getRecordTypeId(BudgetHeader__c.sObjectType, 'Change Order');
        BudgetHeader__c bheader = new BudgetHeader__c();
        bheader.BudgetName__c = 'Change Order 1';
        bheader.ChangeManagerApprovedForSynch__c = true;
        bheader.Project__c = testProject.Id;
        bheader.RecordTypeId = changeOrderRecordTypeId;
        bheaders.add(bheader);

        BudgetHeader__c bheader2 = new BudgetHeader__c();
        bheader2.BudgetName__c = 'Change Order 2';
        bheader2.ChangeManagerApprovedForSynch__c = true;
        bheader2.Project__c = testProject.Id;
        bheader2.RecordTypeId = changeOrderRecordTypeId;
        bheaders.add(bheader2);
        insert bheaders;        
        
        list<Id> projectIds = new list<Id>();
        projectIds.add(testProject.Id);
        projectIds.add(testProject2.Id);
        Test.startTest();       
        
        ECO_Service_ProjectSnapshots projectService = new ECO_Service_ProjectSnapshots(projectIds);     
        ProjectSnapshot__c projectSnapshot = projectService.getProjectSnapshot();
        Test.stopTest();
        System.AssertEquals(2, projectSnapshot.GrossRevenueBudget__c);
        System.AssertEquals(8000, projectSnapshot.GrossRevenueYearToDate__c);
        System.AssertEquals(4000, projectSnapshot.GrossRevenueMonthToDate__c);
        System.AssertEquals(8000, projectSnapshot.GrossRevenueITD__c);
        
        System.AssertEquals(null, projectSnapshot.ChangeOrdersPending__c);
    }*/



/******* By Arman ****************/

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
            expTypeList.add(new ExpenditureType__c(Name='et'+i,  
            PLReportCategory__c='PLReportCategory'+i, ResourceType__c='rt'+i));    
        }
        insert expTypeList;
        System.debug('___ AFTER expTypeList: Number of Queries used in this apex code so far: ' + Limits.getQueries());

        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        recordTypeId = ECO_Utils_sObject.getRecordTypeId(Contact.sObjectType, 'PSA Resource');

        testAccount = new Account();
        testAccount.Name = 'test account';
        insert testAccount;
        System.debug(System.LoggingLevel.WARN, '___AFTER testAccount: Number of Queries used in this apex code so far: ' + Limits.getQueries());

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
        System.debug('___AFTER testSite: Number of Queries used in this apex code so far: ' + Limits.getQueries());

        testContact = new Contact();
        testContact.Email = testUser.Email;
        testContact.FirstName = testUser.FirstName;
        testContact.LastName =  testUser.LastName;
        testContact.Phone = '55555555555';
        testContact.pse__Salesforce_User__c = testUser.Id;
        testContact.RecordTypeId = recordTypeId;
        testContact.User__c = testUser.Id;
        testContact.OwnerId = testUser.Id;
        //testContact.Site__c = testSite.Id;
        testContact.AccountId = testAccount.Id;
        testContact.pse__Is_Resource_Active__c = true;
        testContact.pse__Is_Resource__c = true;
        insert testContact;

        OrganizationString__c organizationString = new OrganizationString__c(Name = 'Test Organization', ProjectAccountant2__c = testContact.Id, PLManagerContact__c = testContact.Id);
        insert organizationString;
        System.debug(System.LoggingLevel.WARN, '___AFTER organizationString: Number of Queries used in this apex code so far: ' + Limits.getQueries());

        projectRoles = new List<ProjectRole__c>();
        projectRoles.add(new ProjectRole__c(Name = 'Project Manager', Type__c = 'Key Member', Active__c = true));
        projectRoles.add(new ProjectRole__c(Name = 'Project Approver 2', Type__c = 'Key Member', Active__c = true));
        projectRoles.add(new ProjectRole__c(Name = 'Project Approver', Type__c = 'Key Member', Active__c = true));
        projectRoles.add(new ProjectRole__c(Name = 'Resilience Director', Type__c = 'Key Member', Active__c = true));
        projectRoles.add(new ProjectRole__c(Name = 'Project Worker', Active__c = true));
        insert projectRoles;
        System.debug(System.LoggingLevel.WARN, '___AFTER projectRoles: Number of Queries used in this apex code so far: ' + Limits.getQueries());

        List<pse__Proj__c> projectList = new List<pse__Proj__c>();
        for (Integer i=0; i < 10; i++) {
            project = new pse__Proj__c(CarryingOutOrganization__c = organizationString.Id, 
                pse__Account__c = testAccount.Id, pse__Start_Date__c = Date.today().addDays(i+30), 
                pse__End_Date__c = Date.today().addDays(i+60));

            projectList.add(project);
        }
        insert projectList;
        System.debug(System.LoggingLevel.WARN, '___AFTER projectList: Number of Queries used in this apex code so far: ' + Limits.getQueries());

        Project_Site__c testProjectSite = new Project_Site__c();
        
        testProjectSite.BillingContactID__c = '1234';
        testProjectSite.OracleProjectSiteId__c = '1111';
        testProjectSite.Project__c = project.Id;
        testProjectSite.Site__c = testSite.Id;
        testProjectSite.Contribution__c = 100;
        insert testProjectSite;
        System.debug(System.LoggingLevel.WARN, '___AFTER testProjectSite: Number of Queries used in this apex code so far: ' + Limits.getQueries());

        projectMembers = new List<ProjectTeamMember__c>();
        projectMembers.add(new ProjectTeamMember__c(Project__c = project.Id, CurrencyIsoCode = 'USD', 
            ProjectRole__c = projectRoles[0].Id, Contact__c = testContact.Id, 
            StartDate__c = Date.today(), EndDate__c = Date.today().addDays(1)));
        insert projectMembers;

        System.debug(System.LoggingLevel.WARN, '___AFTER projectMembers: Number of Queries used in this apex code so far: ' + Limits.getQueries());
        
        projTask = new pse__Project_Task__c(Name='pTask', pse__Project__c=project.Id,
            pse__Start_Date_Time__c = DateTime.now(), pse__End_Date_Time__c = DateTime.now().addDays(1));
        insert projTask;
        System.debug(System.LoggingLevel.WARN, '___AFTER projTask: Number of Queries used in this apex code so far: ' + Limits.getQueries());

        List<ProjectSnapshot__c> projSnapshotList = new List<ProjectSnapshot__c>();
        for (Integer i=0; i<3; i++) {
            projSnapshotList.add(new ProjectSnapshot__c(Name='ps'+i, Project__c=project.Id, GrossRevenueForecast__c=i, 
                CostsODCEXPSForecast__c=i, CostsODCSUBSForecast__c=i, ContingencyForecast__c=i,
                LaborForecast__c=i, FringeForecast__c=i, OverheadForecast__c=i, 
                HoursForecast__c=i, SnapshotType__c = 'Auto', SnapshotFiscalMonth__c=''+i,
                SnapshotPreviousFiscalMonth__c=''+(i-1) ));
        }
        insert projSnapshotList;
        System.debug(System.LoggingLevel.WARN, '___AFTER projSnapshotList: Number of Queries used in this apex code so far: ' + Limits.getQueries());
        
        pse__Time_Period__c timePeriod = new pse__Time_Period__c();
        timePeriod.pse__Start_Date__c = Date.Today();
        timePeriod.pse__End_Date__c = Date.Today().addDays(25);
        timePeriod.TimePeriodCode__c = 'FY2015-02';
        timePeriod.pse__Type__c = 'Month';
        insert timePeriod;
        
        timePeriod = new pse__Time_Period__c();
        timePeriod.pse__Start_Date__c = Date.Today().AddDays(-8);
        timePeriod.pse__End_Date__c = Date.Today().addDays(-1);
        timePeriod.TimePeriodCode__c = 'FY2015-01';
        timePeriod.pse__Type__c = 'Month';
        insert timePeriod;

        List<CostDistLine__c> cdlList = new List<CostDistLine__c>();

        ExpendItem__c expItem = new ExpendItem__c(ProjectTask__c=projTask.id, PLReportCategory__c='ODC - Exps',
                                ExpenditureItemDate__c=Date.Today());
        insert expItem;

        for (Integer i=0; i<5; i++) {
            cdlList.add(new CostDistLine__c(ProjectFunctionalBurdenedCost__c=10, ExpenditureItem__c=expItem.id,
            	PADate__c=Date.today()));
        }
        insert cdlList;

        List<BudgetHeader__c> budgetHeaderList = new List<BudgetHeader__c>();
        for (Integer i=0; i < 2; i++) {
            BudgetHeader__c bh = new BudgetHeader__c();
            bh.OriginalBudget__c = true;
            bh.Project__c = projectList[i].Id;
            budgetHeaderList.add(bh);
        }
        insert budgetHeaderList;

        List<BudgetResource__c> budgetResourceList = new List<BudgetResource__c>();
        for (Integer i=0; i < 2; i++) {
            BudgetResource__c br = new BudgetResource__c();
            br.BudgetHeader__c = budgetHeaderList[i].Id;
            budgetResourceList.add(br);
        }
        insert budgetResourceList;

		BudgetTask__c budTask = new BudgetTask__c();
        budTask.BudgetHeader__c = budgetHeaderList[0].Id;
        budTask.TaskName__c = 'Test Budget Task';
        insert budTask;
        
        List<BudgetAssignment__c> budgetAssignmentList = new List<BudgetAssignment__c>();
        for (Integer i=0; i < 2; i++) {
            BudgetAssignment__c ba = new BudgetAssignment__c();
            ba.BudgetTask__c = budTask.Id;
            //ba.fullyBurdenedCostRate__c = OverrideRawCost__c *  OverrideFringeMultiplier__c *  OverrideOverheadMultiplier__c
            ba.OverrideRawCost__c = 1;
            ba.OverrideFringeMultiplier__c = 1;
            ba.OverrideOverheadMultiplier__c = 1;
            ba.Quantity__c = 1;
            ba.BudgetResource__c = budgetResourceList[i].Id;
            budgetAssignmentList.add(ba);
        }
        insert budgetAssignmentList;
    }
    
    static testMethod void testGetFiscalMonth() {
        pse__Proj__c project1 = [SELECT Id FROM pse__Proj__c LIMIT 1];
        
        test.startTest();
        ECO_Service_ProjectSnapshots psService = new ECO_Service_ProjectSnapshots(project1.Id);
        ProjectSnapshot__c ps = psService.getProjectSnapShot(DateTime.now());
        System.debug(System.LoggingLevel.WARN, '___ProjectSnapshot__c='+ps);
        test.stopTest();
        
        System.Debug(System.LoggingLevel.WARN, '___SnapshotFiscalMonth__c=' + ps.SnapshotFiscalMonth__c);
        System.Debug(System.LoggingLevel.WARN, '___SnapshotPreviousFiscalMonth__c=' + ps.SnapshotPreviousFiscalMonth__c); 
        
        System.AssertEquals('FY2015-01', ps.SnapshotFiscalMonth__c); 
        System.AssertEquals('FY2015-01', ps.SnapshotPreviousFiscalMonth__c);
    }

    
/****
Sum Revenue.Amount where GLDate >= beginning of this fiscal year and 
GLDate <= parameter snapshot date and Revenue.ProjectNumber=parameter project ID
*****/


    /*static testMethod void testGetPreviousFMForecastInformation() {
        List<ProjectSnapshot__c> psList = [SELECT SnapshotPreviousFiscalMonth__c, GrossRevenueForecastPrevME__c, 
                CostsODCEXPSForecast__c, CostsODCSUBSForecast__c, ContingencyForecast__c,
                LaborForecast__c, FringeForecast__c, OverheadForecast__c, HoursForecast__c  
                FROM ProjectSnapshot__c];

        pse__Proj__c project1 = [SELECT Id FROM pse__Proj__c LIMIT 1];

        test.startTest();
            ECO_Service_ProjectSnapshots psService = new ECO_Service_ProjectSnapshots(project1.Id);
            ProjectSnapshot__c ps0 = psService.getPreviousFMForecastInformation(psList[0]);
            ProjectSnapshot__c ps1 = psService.getPreviousFMForecastInformation(psList[1]);
            ProjectSnapshot__c ps2 = psService.getPreviousFMForecastInformation(psList[2]);
        test.stopTest();

        System.assertEquals(null, ps0.GrossRevenueForecastPrevME__c);
        System.assertEquals(0, ps1.GrossRevenueForecastPrevME__c);  
        System.assertEquals(1, ps2.GrossRevenueForecastPrevME__c);  
        System.assertEquals(1, ps2.CostsODCEXPSForecastPrevME__c);
        System.assertEquals(1, ps2.CostsODCSUBSForecastPrevME__c);
        System.assertEquals(1, ps2.ContingencyForecastPrevME__c);
        System.assertEquals(1, ps2.LaborForecastPrevME__c);
        System.assertEquals(1, ps2.FringeForecastPrevME__c);
        System.assertEquals(1, ps2.OverheadForecastPrevME__c);
        System.assertEquals(1, ps2.HoursForecastPrevME__c);
    }*/

    

    /*static testMethod void testGetOriginalBudgetHeaderMap() {
        System.debug(System.LoggingLevel.WARN, '___START testGetOriginalBudgetHeaderMap: Number of Queries used in this apex code so far: ' + Limits.getQueries());
        List<pse__Proj__c> projects = [SELECT Id FROM pse__Proj__c];
        System.debug(System.LoggingLevel.WARN, '___AFTER projects: Number of Queries used in this apex code so far: ' + Limits.getQueries());

        List<Id> projectIds = new List<Id>();
        for (pse__Proj__c proj : projects) {
            projectIds.add(proj.Id);
        }
        test.startTest();
            System.debug(System.LoggingLevel.WARN, '___BEGIN startTest: Number of Queries used in this apex code so far: ' + Limits.getQueries());
            ECO_Service_ProjectSnapshots psService = new ECO_Service_ProjectSnapshots(projectIds);
            Map<Id, ECO_Service_ProjectSnapshots.FinancialMetrics> bhMap = 
                psService.getOriginalBudgetHeaderMap(projectIds, false);
            System.debug(System.LoggingLevel.WARN, '___END at stopTest: Number of Queries used in this apex code so far: ' + Limits.getQueries());
        test.stopTest();

        System.debug(System.LoggingLevel.WARN, '___AFTER stopTest: Number of Queries used in this apex code so far: ' + Limits.getQueries());
        ECO_Service_ProjectSnapshots.FinancialMetrics fm0 = bhMap.get(projectIds[0]);
        //System.assertEquals(0, fm0.TotalRevenue);
        //System.assertEquals(0, fm0.TotalCost);   
    }*/

    //getOriginalBudgetHeaderMapInformation

}