@isTest
private class ECO_ProjectSetupControllerTest
{

	static void initializeSites(){

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

        insert testOpp;

		// Insert Test Site Data
		list<site__c> testSites = new list<site__c>();

		Site__c s1 = new Site__c();
		s1.Account__c = testAccount.id;
		s1.City__c = 'Toronto';
		s1.Country__c = 'Canada';
		s1.State__c = 'Ontario';
		s1.CustomerSiteUseCode__c = 'BILL_TO';

		testSites.add(s1);

		Site__c s2 = new Site__c();
		s2.Account__c = testAccount.id;
		s2.City__c = 'Toronto2';
		s2.Country__c = 'Canada2';
		s2.State__c = 'Ontario2';
		s2.CustomerSiteUseCode__c = 'SHIP_TO';

		testSites.add(s2);

		Site__c s3 = new Site__c();
		s3.Account__c = testAccount.id;
		s3.City__c = 'Toronto3';
		s3.Country__c = 'Canada3';
		s3.State__c = 'Ontario3';
		s3.CustomerSiteUseCode__c = 'SHIP_TO';

		testSites.add(s3);		

		Site__c s4 = new Site__c();
		s4.Account__c = testAccount2.id;
		s4.City__c = 'Vanc';
		s4.Country__c = 'Canada';
		s4.State__c = 'BC';
		s4.CustomerSiteUseCode__c = 'BILL_TO';

		testSites.add(s4);	


		insert testSites;

		/*
		List<OrganizationString__c> lOrgStrings = new List<OrganizationString__c>();
		OrganizationString__c Org1 = INC_Utils_Testing.createTestOrg();
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
		*/
	}


	// Test duplicate filtering functionality of site searching
	@isTest
	static void DupeTest()
	{

		initializeSites();


		// Create standard controller for a new project and pass to the ext. Start the real test.
		ApexPages.StandardController sc = new ApexPages.StandardController(new pse__Proj__c());
		ECO_ProjectSetupController ext = new ECO_ProjectSetupController(sc);

		ext.SearchSites();
		system.assertEquals(ext.lstSitesSearchResults.size(), 2); 
	}

	// Test No Results for Sites
	@isTest
	static void NoSiteResult()
	{

		initializeSites();


		// Create standard controller for a new project and pass to the ext. Start the real test.
		ApexPages.StandardController sc = new ApexPages.StandardController(new pse__Proj__c());
		ECO_ProjectSetupController ext = new ECO_ProjectSetupController(sc);

		ext.oSite.Account__r.name = 'BLAHBLAHBLAH';
		ext.SearchSites();
		system.assertEquals(ext.lstSitesSearchResults.size(), 0); 
	}

	// Test No Results for Sites with Successful Search
	@isTest
	static void WithSiteFilterResult()
	{

		initializeSites();

		// Create standard controller for a new project and pass to the ext. Start the real test.
		ApexPages.StandardController sc = new ApexPages.StandardController(new pse__Proj__c());
		ECO_ProjectSetupController ext = new ECO_ProjectSetupController(sc);

		ext.oSite.Account__r.name = 'test';
		ext.oSite.City__c = 'Toronto2';
		ext.oSite.Country__c = 'Canada';
		ext.oSite.State__c = 'Ontario';
		ext.SearchSites();
		system.assertEquals(ext.lstSitesSearchResults.size(), 1); 
		system.assertEquals(ext.lstSitesSearchResults[0].City__c, 'Toronto2'); 
		system.assertEquals(ext.lstSitesSearchResults[0].Country__c, 'Canada2'); 
		system.assertEquals(ext.lstSitesSearchResults[0].State__c, 'Ontario2'); 
	}

	// Test the selection of a searched Site with no opp + creation of project
	@isTest
	static void NoOppSelect()
	{

		initializeSites();


		// Create standard controller for a new project and pass to the ext. Start the real test.
		ApexPages.StandardController sc = new ApexPages.StandardController(new pse__Proj__c());
		ECO_ProjectSetupController ext = new ECO_ProjectSetupController(sc);

		ext.oSite.Account__r.name = 'another';
		ext.SearchSites();
		system.assertEquals(ext.lstSitesSearchResults.size(), 1); 

		// Select Target Site
		ext.idSiteID = ext.lstSitesSearchResults[0].id;
		ext.SelectSite();

		system.assertEquals(ext.lstSites.size(), 1); 
		system.assertEquals(ext.lstSites[0].booIsPrimaryEnd, true); 
		system.assertEquals(ext.lstSites[0].booIsBilling, true); 
		system.assertEquals(ext.lstSites[0].booIsEnd, true); 		
		system.assertEquals(ext.lstSites[0].booIsDefaultTopTask, true);
		system.assertEquals(ext.lstSites[0].oSite.City__c, 'Vanc');
		system.assertEquals(ext.lstSites[0].oSite.Country__c, 'Canada');
		system.assertEquals(ext.lstSites[0].oSite.State__c, 'BC');


		system.assertEquals(ext.lstSearchOpportunities.size(), 0); 

		ext.oProject.name = 'test project';
		ext.oProject.EstimatedContractValue__c = 1;
		ext.oProject.ownerid = UserInfo.getUserId();
		ext.oproject.EstimatedStartDate__c = date.today();

		ext.ProjectDetailNext();

		ext.sOrganizationName = 'Water Organization';
		ext.SearchOrganizations();
		ext.sSelectedOrganizationId = ext.lOrganizations[0].id;
		ext.SelectPrimary();

		ext.CreateProject();

		pse__Proj__c oProject = [select id, pse__Opportunity__c from pse__Proj__c];

		system.assertNotEquals(oProject.pse__Opportunity__c, null);		

		opportunity checkOpp = [select id, name from opportunity];

		system.assertEquals(checkOpp.name, ext.oProject.name);	

	}	

	// Test the selection of a searched Site with Opp + creation of project
	@isTest
	static void OppSelect()
	{

		initializeSites();


		// Create standard controller for a new project and pass to the ext. Start the real test.
		ApexPages.StandardController sc = new ApexPages.StandardController(new pse__Proj__c());
		ECO_ProjectSetupController ext = new ECO_ProjectSetupController(sc);

		ext.oSite.Account__r.name = 'test';
		ext.SearchSites();
		system.assertEquals(ext.lstSitesSearchResults.size(), 1); 

		// Select Target Site
		ext.idSiteID = ext.lstSitesSearchResults[0].id;
		ext.SelectSite();

		system.assertEquals(ext.lstSites.size(), 1); 
		system.assertEquals(ext.lstSites[0].booIsPrimaryEnd, true); 
		system.assertEquals(ext.lstSites[0].booIsBilling, true); 
		system.assertEquals(ext.lstSites[0].booIsEnd, true); 		
		system.assertEquals(ext.lstSites[0].booIsDefaultTopTask, true);
		system.assertEquals(ext.lstSites[0].oSite.City__c, 'Toronto');
		system.assertEquals(ext.lstSites[0].oSite.Country__c, 'Canada');
		system.assertEquals(ext.lstSites[0].oSite.State__c, 'Ontario');

		system.assertEquals(ext.lstSearchOpportunities.size(), 1); 

		// Select available opportunity
		ext.sSelectedOpportunityId = ext.lstSearchOpportunities[0].id;

		// Check to see if the project is populated with the opportunity id
		ext.SelectOpportunity();
		system.assertEquals(ext.oProject.pse__Opportunity__c, ext.lstSearchOpportunities[0].id);

		ext.oProject.name = 'test project';
		ext.oProject.EstimatedContractValue__c = 1;
		ext.oProject.ownerid = UserInfo.getUserId();
		ext.oproject.EstimatedStartDate__c = date.today();

		ext.ProjectDetailNext();

		ext.sOrganizationName = 'Water Organization';
		ext.SearchOrganizations();
		ext.sSelectedOrganizationId = ext.lOrganizations[0].id;
		ext.SelectPrimary();

		ext.CreateProject();

		pse__Proj__c oProject = [select id, pse__Opportunity__c from pse__Proj__c];

		system.assertEquals(oProject.pse__Opportunity__c, ext.lstSearchOpportunities[0].id);

	}	


}