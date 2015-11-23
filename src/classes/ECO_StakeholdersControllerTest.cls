/*
	Purpose: - Test class for the ECO_StakeholdersController Controller

	Created By: Aaron Pettitt (NTT Data)

	Revision Log: 
		v1.0 - (AP 10/12/2015) -- created 
*/
@isTest
private class ECO_StakeholdersControllerTest {
	Static User testUser;
	Static Contact testContact;
	Static Id recordTypeId;
	Static pse__Proj__c project;
	Static Site__c testSite;
	Static Account testAccount;
	Static List<ProjectTeamMember__c> projectMembers;
	Static List<ProjectRole__c> projectRoles;
	
	@isTest static void testConstructor() {
		setupTestData();
		PageReference pg = Page.ECO_Stakeholders;
		pg.getParameters().put('Id', project.id);
		Test.setCurrentPage(pg);
		ApexPages.StandardController standardController = new ApexPages.StandardController(project);
		ECO_StakeholdersController stakeHolderController = new ECO_StakeholdersController(standardController);
		system.assertEquals('/apex/eco_stakeholders?Id=' + project.Id, stakeHolderController.returnURL);
		system.assertEquals(5, stakeHolderController.lActiveMembersKey.size());
		testContact.pse__Is_Resource_Active__c = false;
		update testContact;
		stakeHolderController.initStakeHolders(project);
		system.assertEquals(1, stakeHolderController.lInactiveMembersTeam.size());
		system.assertEquals(new PageReference('/' + project.Id).getUrl(), stakeHolderController.ReturnToProject().getUrl());
	}
	
	@isTest static void testAddSaveData() {
		setupTestData();
		PageReference pg = Page.ECO_Stakeholders;
		pg.getParameters().put('Id', project.id);
		Test.setCurrentPage(pg);
		ApexPages.StandardController standardController = new ApexPages.StandardController(project);
		ECO_StakeholdersController stakeHolderController = new ECO_StakeholdersController(standardController);
		stakeHolderController.recordObjectType = 'MembersTeam';
		stakeHolderController.addRecord();
		system.assertEquals(5, stakeHolderController.lActiveMembersKey.size());
		stakeHolderController.recordObjectType = 'Stakeholder__c';
		stakeHolderController.addRecord();
		system.assertEquals(2, stakeHolderController.lStakeholders.size());
		stakeHolderController.recordObjectType = 'CommunicationPlan__c';
		stakeHolderController.addRecord();
		system.assertEquals(1, stakeHolderController.lCommPlans.size());
		stakeHolderController.recordObjectType = 'SurveySchedule__c';
		system.assertEquals(1, stakeHolderController.lSurveySchedules.size());
		stakeHolderController.addRecord();
		//stakeHolderController.lInactiveMembersKey.add(new ECO_StakeholdersController.TeamMember(project, projectRoles));
		//stakeHolderController.lInactiveMembersKey[0].oPTM = projectMembers[0];
		stakeHolderController.SaveAll();
		system.assertEquals(5, stakeHolderController.lActiveMembersKey.size());
		system.assertEquals(1, stakeHolderController.lStakeholders.size());
		system.assertEquals(0, stakeHolderController.lCommPlans.size());
		system.assertEquals(1, stakeHolderController.lSurveySchedules.size());
		stakeHolderController.resetQueryTable();
	}

	@isTest static void testSearchForKeyMembers() {
		setupTestData();
		PageReference pg = Page.ECO_Stakeholders;
		Test.setCurrentPage(pg);
		pg.getParameters().put('Id', project.id);
		pg.getParameters().put('contactName', testUser.FirstName + ' ' + testUser.LastName);
		pg.getParameters().put('selectedRole', 'Project Manager');
		pg.getParameters().put('startDate', Date.today().format());
		ApexPages.StandardController standardController = new ApexPages.StandardController(project);
		ECO_StakeholdersController stakeHolderController = new ECO_StakeholdersController(standardController);
		stakeHolderController.searchForKeyMembers();
		system.assertEquals(1, stakeHolderController.queryDelegates.size());

		/*
		User testUser2 = ECO_Utils_Testing.createTestUser('Standard User');
		Contact testContact2 = new Contact();
		testContact2.Email = testUser2.Email;
		testContact2.FirstName = testUser2.FirstName;
		testContact2.LastName =  testUser2.LastName;
		testContact2.Phone = '55555555555';
		testContact2.pse__Salesforce_User__c = testUser2.Id;
		testContact2.RecordTypeId = recordTypeId;
		testContact2.User__c = testUser2.Id;
		testContact2.OwnerId = testUser.Id;
		testContact2.Site__c = testSite.Id;
		testContact2.AccountId = testAccount.Id;
		testContact2.pse__Is_Resource_Active__c = true;
		testContact2.pse__Is_Resource__c = true;
		insert testContact2;
		system.runAs(testUser){
			Delegate__c delegate = new Delegate__c(Delegate__c = testContact2.Id, Delegator__c = testContact.Id, End_Date__c = Date.today().addDays(30), Key_Member_Role__c = 'Project Manager', Start_Date__c = Date.today());
			insert delegate;
		}*/

		
		pg.getParameters().put('queryType', 'Delegate');
		stakeHolderController.searchForKeyMembers();
		system.assertEquals(0, stakeHolderController.queryDelegates.size());

	}

	@isTest static void testSelectReplaceKeyMember() {
		setupTestData();
		PageReference pg = Page.ECO_Stakeholders;
		Test.setCurrentPage(pg);
		pg.getParameters().put('Id', project.id);
		pg.getParameters().put('selectedContactId', testContact.Id);
		pg.getParameters().put('selectedRole', 'Project Manager');
		pg.getParameters().put('queryType', 'Unfiltered');
		ApexPages.StandardController standardController = new ApexPages.StandardController(project);
		ECO_StakeholdersController stakeHolderController = new ECO_StakeholdersController(standardController);
		stakeHolderController.selectReplaceKeyMember();
		pg.getParameters().put('startDate', Date.today().addDays(1).format());
		stakeHolderController.selectReplaceKeyMember();
		pg.getParameters().put('startDate', Date.today().addDays(3).format());
		stakeHolderController.selectReplaceKeyMember();
		pg.getParameters().put('startDate', Date.today().addDays(12).format());
		stakeHolderController.selectReplaceKeyMember();
		system.assertEquals(5, stakeHolderController.lActiveMembersKey.size());
	}

	@isTest static void testMisc() {
		setupTestData();
		PageReference pg = Page.ECO_Stakeholders;
		Test.setCurrentPage(pg);
		pg.getParameters().put('Id', project.id);
		ApexPages.StandardController standardController = new ApexPages.StandardController(project);
		ECO_StakeholdersController stakeHolderController = new ECO_StakeholdersController(standardController);
		stakeHolderController.queryDelegates = new List<Contact>();
		stakeHolderController.queryDelegates.add(testContact);
		stakeHolderController.sendApprovalProcess(projectMembers[0], 'Project Manager');
		stakeHolderController.defaultDates();
		system.assertEquals('2015-09-05', stakeHolderController.convertStringSOQLString('9/5/2015'));
	}

	@isTest static void testSetOptions() {
		setupTestData();
		PageReference pg = Page.ECO_Stakeholders;
		Test.setCurrentPage(pg);
		pg.getParameters().put('Id', project.id);
		ApexPages.StandardController standardController = new ApexPages.StandardController(project);
		ECO_StakeholdersController stakeHolderController = new ECO_StakeholdersController(standardController);
		stakeHolderController.recordObjectType = 'SurveySchedule__c';
		system.assertEquals(1, stakeHolderController.lSurveySchedules.size());
		stakeHolderController.addRecord();
		stakeHolderController.lstSSW[0].ss.Client__c = testSite.Id;
		pg.getParameters().put('surveyToRefresh', '0');
		stakeHolderController.setOptions();
		system.assertEquals(2, stakeHolderController.lstSSW[0].cOptions.size());
	}

	@isTest static void testRemoveData() {
		setupTestData();
		PageReference pg = Page.ECO_Stakeholders;
		pg.getParameters().put('Id', project.id);
		Test.setCurrentPage(pg);
		ApexPages.StandardController standardController = new ApexPages.StandardController(project);
		ECO_StakeholdersController stakeHolderController = new ECO_StakeholdersController(standardController);
		stakeHolderController.recordObjectType = 'MembersTeam';
		stakeHolderController.addRecord();
		pg.getParameters().put('teamMemberToRemove', '0');
		stakeHolderController.removeRecord();
		system.assertEquals(5, stakeHolderController.lActiveMembersKey.size());
		stakeHolderController.recordObjectType = 'Stakeholder__c';
		stakeHolderController.addRecord();
		pg.getParameters().put('otherToRemove', '0');
		stakeHolderController.removeRecord();
		system.assertEquals(1, stakeHolderController.lStakeholders.size());
		stakeHolderController.recordObjectType = 'CommunicationPlan__c';
		stakeHolderController.addRecord();
		pg.getParameters().put('planToRemove', '0');
		stakeHolderController.removeRecord();
		system.assertEquals(0, stakeHolderController.lCommPlans.size());
		stakeHolderController.recordObjectType = 'SurveySchedule__c';
		stakeHolderController.addRecord();
		pg.getParameters().put('surveyToRemove', '0');
		stakeHolderController.removeRecord();
		system.assertEquals(1, stakeHolderController.lSurveySchedules.size());
	}

	static void setupTestData(){

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
		projectRoles.add(new ProjectRole__c(Name = 'Finance Lead', Type__c = 'Key Member', Active__c = true));
		insert projectRoles;

		List<pse__Proj__c> projects = new List<pse__Proj__c>();
		projects.add(new pse__Proj__c(CarryingOutOrganization__c = organizationString.Id, pse__Account__c = testAccount.Id, pse__Start_Date__c = Date.today().addDays(30), pse__End_Date__c = Date.today().addDays(60)));
		projects.add(new pse__Proj__c(CarryingOutOrganization__c = organizationString.Id, pse__Account__c = testAccount.Id, pse__Start_Date__c = Date.today().addDays(-30), pse__End_Date__c = Date.today().addDays(-1)));
		insert projects;
		project = projects[0];

		Project_Site__c testProjectSite = new Project_Site__c();
		
		testProjectSite.BillingContactID__c	= '1234';
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