@isTest
private class ECO_Service_ProjectSnapshotTest {

   static testMethod void testSingleProject() {
       
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
    }    
}