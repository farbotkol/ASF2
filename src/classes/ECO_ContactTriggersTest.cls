@isTest
private class ECO_ContactTriggersTest
{
	static void initializeSites(){

		OrganizationString__c testOrg =  ECO_Utils_Testing.createTestOrg();
		insert testOrg;

		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 

		User testUser = new User();
		testUser.Alias = 'myuser';
		testUser.Email ='mytestuser@example.com';
		testUser.EmailEncodingKey ='UTF-8';

		testUser.FirstName = 'test';
		testUser.LastName ='Testing';
		testUser.LanguageLocaleKey ='en_US';
		testUser.LocaleSidKey ='en_US';
		testUser.ProfileId = p.Id;
        testUSer.TimeZoneSidKey ='America/Los_Angeles';
        testUser.UserName ='mytestuser@example.com';
        testUser.EmployeeNumber = '123';
        testUser.PersonId__c = '123';
        testUser.ECO_OrganizationName__c = testOrg.name;
        insert testUser;


		list<account> testAccounts = new list<account>();

		// Insert Test Account
		Account testAccount = new Account();
		testAccount.Name = 'test account';
		testAccount.OracleCustomerID__c = '1111';
		testAccounts.add(testAccount);

		Account testAccount2 = new Account();
		testAccount2.Name = 'another account';
		testAccount2.OracleCustomerID__c = '2222';
		testAccounts.add(testAccount2);

		insert testAccounts;		

		Opportunity testOpp = new Opportunity();
		testOpp.accountid = testAccount.id;
        testOpp.name = 'test opp';
        testOpp.closeDate = date.today();
        testOpp.Stagename = '1 Lead';
        testOpp.probability = 100;
        testOpp.TO_Procurement_Method__c = 'Competitive Task Orders';		

		Opportunity testOpp2 = new Opportunity();
		testOpp2.accountid = testAccount2.id;
        testOpp2.name = 'test opp2';
        testOpp2.closeDate = date.today();
        testOpp2.Stagename = '1 Lead';
        testOpp2.probability = 100;
        testOpp2.TO_Procurement_Method__c = 'Competitive Task Orders';	

        list<Opportunity> lstOpp = new list<Opportunity>();
        lstOpp.add(testOpp);
        lstOpp.add(testOpp2);

        insert lstOpp;

		// Insert Test Site Data
		list<site__c> testSites = new list<site__c>();

		Site__c s1 = new Site__c();
		s1.Account__c = testAccount.id;
		s1.City__c = 'Toronto';
		s1.Country__c = 'Canada';
		s1.State__c = 'Ontario';
		s1.CustomerSiteUseCode__c = 'BILL_TO';
		s1.OUID__c = testOrg.OUID__c;

		testSites.add(s1);

		Site__c s2 = new Site__c();
		s2.Account__c = testAccount.id;
		s2.City__c = 'Toronto2';
		s2.Country__c = 'Canada2';
		s2.State__c = 'Ontario2';
		s2.CustomerSiteUseCode__c = 'SHIP_TO';
		s1.OUID__c = testOrg.OUID__c;

		testSites.add(s2);

		Site__c s3 = new Site__c();
		s3.Account__c = testAccount.id;
		s3.City__c = 'Toronto3';
		s3.Country__c = 'Canada3';
		s3.State__c = 'Ontario3';
		s3.CustomerSiteUseCode__c = 'SHIP_TO';
		s1.OUID__c = testOrg.OUID__c;

		testSites.add(s3);		

		Site__c s4 = new Site__c();
		s4.Account__c = testAccount2.id;
		s4.City__c = 'Vanc';
		s4.Country__c = 'Canada';
		s4.State__c = 'BC';
		s4.CustomerSiteUseCode__c = 'BILL_TO';
		s1.OUID__c = testOrg.OUID__c;

		testSites.add(s4);	


		insert testSites;


		list<contact> conList = new list<contact>();
		Contact con1 = new Contact();
		con1.FirstName = 'test';
		con1.LastName = 'test';
		con1.site__c = s1.id;
		con1.Accountid = testAccount.id;
		con1.OracleContactID__c = 'EMPLOYEE-474518U';
		con1.pse__Is_Resource_Active__c = true;
		conList.add(con1);

		Contact con2 = new Contact();
		con2.FirstName = 'test';
		con2.LastName = 'test';
		con2.site__c = s2.id;
		con2.Accountid= testAccount.id;
		con2.OracleContactID__c = 'EMPLOYEE-474518U1';
		con1.pse__Is_Resource_Active__c = true;
		conList.add(con2);

		Contact con3 = new Contact();
		con3.FirstName = 'test';
		con3.LastName = 'test';
		con3.site__c = s3.id;
		con3.Accountid= testAccount.id;
		con3.OracleContactID__c = 'EMPLOYEE-474518U2';
		con1.pse__Is_Resource_Active__c = true;
		conList.add(con3);

		Contact con4 = new Contact();
		con4.FirstName = 'test';
		con4.LastName = 'test';
		con4.site__c = s4.id;
		con4.Accountid = testAccount2.id;
		con4.OracleContactID__c = 'EMPLOYEE-474518U3';
		con1.pse__Is_Resource_Active__c = true;
		conList.add(con4);

		insert conList;

		List<OrganizationString__c> lOrgStrings = new List<OrganizationString__c>();
		OrganizationString__c Org1 = ECO_Utils_Testing.createTestOrg();
		Org1.OrganizationName__c = 'Test Organization';
		Org1.Name = 'Test Organization';
		Org1.BusinessLineName__c = 'test';
		Org1.Department__c = 'test Department';
		Org1.District__c = 'tet District';
		Org1.Description__c = 'test org string';
		Org1.GeographyName__c = 'test Geo';
		Org1.Region__c = 'test Region';
		Org1.OrgID__c = '111';
		Org1.OUID__c = '111';
		Org1.InactiveDate__c = null;
		Org1.ProjectOwning__c = true;

		lOrgStrings.add(Org1);


		OrganizationString__c Org2 = ECO_Utils_Testing.createTestOrg();

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
		org2.ProjectOwning__c = true;

		lOrgStrings.add(Org2);
		insert lOrgStrings;		

		//team members
		ProjectRole__c projectRole = new ProjectRole__c();
		projectRole.Name = 'Project Manager';
		projectRole.Type__c = 'Key Member';
		projectRole.Active__c = true;

		ProjectRole__c projectRole1 = new ProjectRole__c();
		projectRole1.Name = 'Resilience Director';
		projectRole1.Type__c = 'Key Member';
		projectRole1.Active__c = true;

		list<ProjectRole__c> lstpr = new list<ProjectRole__c>();
		lstpr.add(projectRole);
		lstpr.add(projectRole1);
		insert lstpr;
	}

	@isTest
	static void itShould()
	{
		initializeSites();
		user u = [select id from user where Alias = 'myuser'];

		// Create standard controller for a new project and pass to the ext. Start the real test.
		ApexPages.StandardController sc = new ApexPages.StandardController(new pse__Proj__c());
		ECO_ProjectSetupController ext = new ECO_ProjectSetupController(sc);
		ext.bSearchOutsideUserOrg = true;

		ext.oSite.Account__r.name = 'another';
		ext.SearchSites();
		ext.toggleSiteShow();
		ext.toggleSiteShow();
		system.assertEquals(ext.lstSitesSearchResults.size(), 2); 

		// Select Target Site
		ext.idSiteID = ext.lstSitesSearchResults[0].id;
		ext.SelectSite();

		system.assertEquals(ext.lstSites.size(), 1); 
		system.assertEquals(ext.lstSites[0].booIsPrimaryEnd, true); 
		system.assertEquals(ext.lstSites[0].booIsBilling, true); 
		system.assertEquals(ext.lstSites[0].booIsEnd, true); 		
		system.assertEquals(ext.lstSites[0].booIsDefaultTopTask, true);


		for(ECO_ProjectSetupController.SiteWrapper sw: ext.lstSites){
			sw.billingContact = sw.contacts[0].getValue();
		}

		ext.Step2();

		system.assertEquals(ext.lstSearchOpportunities.size(), 1); 

		ext.idSelectedOppRecType = ext.opportunityRecType[1].getvalue();

		ext.SkipOpportunity();

		ext.oProject.name = 'test project5555555';
		ext.oProject.EstimatedContractValue__c = 1;
		ext.oProject.ownerid = u.id;
		ext.oproject.EstimatedStartDate__c = date.today();

		//
		ext.ProjectDetailNext();

		ext.sOrganizationName = 'Water Organization';
		ext.SearchOrganizations();
		ext.toggleOrgShow();
		ext.toggleOrgShow();

		ext.sSelectedOrganizationId = ext.lOrganizations[0].id;
		ext.SelectPrimary();


		system.assertEquals(ext.isValid(), true);

		ext.CreateProject();
		
		system.assertNotEquals(ext.oProject.id, null);	

		pse__Proj__c oProject = [select id, pse__Opportunity__c from pse__Proj__c];

		system.assertNotEquals(oProject.pse__Opportunity__c, null);		

		opportunity checkOpp = [select id, name from opportunity where id =: oProject.pse__Opportunity__c];

		system.assertEquals(checkOpp.name, ext.oProject.name);	

		contact con1 = [select id from contact where OracleContactID__c = 'EMPLOYEE-474518U1'];
		ProjectRole__c projectRole1 = [select id from ProjectRole__c where Name = 'Project Manager'];

		ProjectTeamMember__c ptm1 = new ProjectTeamMember__c(Contact__c = con1.id, Project__c = ext.oProject.id, ProjectRole__c = projectRole1.id);
		insert ptm1;


		test.StartTest();

		contact con = [select id from contact where OracleContactID__c = 'EMPLOYEE-474518U'];
		ProjectRole__c projectRole = [select id from ProjectRole__c where Name = 'Resilience Director'];

		ProjectTeamMember__c ptm = new ProjectTeamMember__c(Contact__c = con.id, Project__c = ext.oProject.id, ProjectRole__c = projectRole.id);
		insert ptm;

		con.pse__Is_Resource_Active__c = false;
		update con;

		con1.pse__Is_Resource_Active__c = false;
		update con1;

		test.StopTest();

	}
}