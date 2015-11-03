/*
	Purpose: - Test Class ECO_DelegateManager Class

	Created By: Aaron Pettitt (NTT Data)

	Revision Log: 
		v1.0 - (AP 10/09/2015) -- created 
*/
@isTest
private class ECO_DelegateManagerControllerTest {
	Static User testUser;
	Static Contact testContact;
	Static Id recordTypeId;
	Static pse__Proj__c project;
	Static Site__c testSite;
	Static List<ProjectRole__c> projectRoles;
	Static List<ProjectTeamMember__c> projectMembers;

	@isTest static void testConstructor() {
		setupTestData();
		PageReference pg = Page.ECO_DelegateManager;
		pg.getParameters().put('retURL', '/' + testContact.Id);
		Test.setCurrentPage(pg);
		System.runAs(testUser){
			ECO_DelegateManagerController controller = new ECO_DelegateManagerController();
			system.assertEquals('Key Roles', controller.currentRecordType);
			system.assertEquals(4, controller.delegateRecordTypeMap.size());
			system.assertEquals(true, controller.canEdit);
			system.assertEquals(true, controller.canCreateAlternate);
		}
		pg = Page.ECO_DelegateManager;
		pg.getParameters().put('contactId', testContact.Id);
		pg.getParameters().put('retURL', '/' + testContact.Id);
		Test.setCurrentPage(pg);
		ECO_DelegateManagerController controller = new ECO_DelegateManagerController();
		system.assertEquals(false, controller.isError);
		system.assertEquals(true, controller.canEdit);
		system.assertEquals(false, controller.canCreateAlternate);
		system.assertEquals(UserInfo.getDefaultCurrency(), controller.currentCurrency);
		system.assertEquals(2, controller.yesNoOptions.size());

	}
	
	@isTest static void testChangeTabFields() {
		setupTestData();
		PageReference pg = Page.ECO_DelegateManager;
		pg.getParameters().put('contactId', testContact.Id);
		pg.getParameters().put('retURL', '/' + testContact.Id);
		Test.setCurrentPage(pg);
		System.runAs(testUser){
			ECO_DelegateManagerController controller = new ECO_DelegateManagerController();
			system.assertEquals('Key Roles', controller.currentRecordType);
			pg.getParameters().put('recordTypeId', controller.delegateRecordTypeMap.get('Vacation'));
			controller.changeTabFields();
			system.assertEquals('Vacation', controller.currentRecordType);
		}
	}

	@isTest static void testAddNewDelegate() {
		setupTestData();
		User testUser2 = ECO_Utils_Testing.createTestUser('Standard User');
		insert testUser2;

		Contact testContact2 = new Contact();
		testContact2.Email = testUser2.Email;
		testContact2.FirstName = testUser2.FirstName;
		testContact2.LastName =  testUser2.LastName;
		testContact2.Phone = '55555555555';
		testContact2.pse__Salesforce_User__c = testUser2.Id;
		testContact2.RecordTypeId = recordTypeId;
		testContact2.User__c = testUser2.Id;
		testContact2.OwnerId = testUser2.Id;
		testContact2.Status__c = 'Active';
		testContact2.pse__Is_Resource__c = true;
		insert testContact2;

		PageReference pg = Page.ECO_DelegateManager;
		pg.getParameters().put('contactId', testContact.Id);
		pg.getParameters().put('retURL', '/' + testContact.Id);
		Test.setCurrentPage(pg);

		System.runAs(testUser){
			ECO_DelegateManagerController controller = new ECO_DelegateManagerController();
			controller.delegate.CurrencyIsoCode = 'USD';
			controller.delegate.Delegate__c = testContact2.Id;
			controller.delegate.Key_Member_Role__c = 'Project Manager';
			controller.delegate.Start_Date__c = Date.today().addDays(5);
			controller.owningOrganizations[0].checked = true;
			controller.agreementAmountBypass = 'Yes';
			controller.projectRevenueBudgetBypass = 'Yes';
			controller.backlogValueBypass = 'Yes';
			controller.projectNetMarginValueBypass = 'Yes';
			controller.projectNetMarginNSRBypass = 'Yes';
			controller.percentageChangeInForecastBypass = 'Yes';
			controller.valueChangeInForecastNetMarginBypass = 'Yes';
			controller.projectRevenueBudgetBypassLT = 'Yes';
			controller.backlogValueBypassLT = 'Yes';
			controller.projectNetMarginValueBypassLT = 'Yes';
			controller.projectNetMarginNSRBypassLT = 'Yes';
			controller.percentageChangeInForecastBypassLT = 'Yes';
			controller.valueChangeInForecastNetMarginBypassLT = 'Yes';
			controller.c0Bypass = 'Yes';
			controller.c1Bypass = 'Yes';
			controller.c2Bypass = 'Yes';
			controller.c3Bypass = 'Yes';
			controller.c4Bypass = 'Yes';
			controller.addNewDelegate();
			system.assertEquals(0, controller.contact.Delegates1__r.size());
			controller = new ECO_DelegateManagerController();
			controller.agreementAmountBypass = 'No';
			controller.projectRevenueBudgetBypass = 'No';
			controller.backlogValueBypass = 'No';
			controller.projectNetMarginValueBypass = 'No';
			controller.projectNetMarginNSRBypass = 'No';
			controller.percentageChangeInForecastBypass = 'No';
			controller.valueChangeInForecastNetMarginBypass = 'No';
			controller.projectRevenueBudgetBypassLT = 'No';
			controller.backlogValueBypassLT = 'No';
			controller.projectNetMarginValueBypassLT = 'No';
			controller.projectNetMarginNSRBypassLT = 'No';
			controller.percentageChangeInForecastBypassLT = 'No';
			controller.valueChangeInForecastNetMarginBypassLT = 'No';
			controller.c0Bypass = 'No';
			controller.c1Bypass = 'No';
			controller.c2Bypass = 'No';
			controller.c3Bypass = 'No';
			controller.c4Bypass = 'No';
			controller.delegate.age_Change_in_Forecast_Net_Margin__c = 6;
			controller.delegate.Project_Net_Margin_age_of_NSR__c = 6;
			controller.delegate.Delegate__c = testContact2.Id;
			controller.delegate.Key_Member_Role__c = 'Project Manager';
			controller.delegate.Start_Date__c = Date.today().addDays(20);
			ECO_Delegate_Limits__c delegateLimitSettings = ECO_Delegate_Limits__c.getOrgDefaults();
			controller.owningOrganizations[0].checked = true;
			controller.addNewDelegate();
			//system.assertEquals(2, controller.contact.Delegates1__r.size());
			testContact2.Status__c = 'Inactive';
			update testContact2;
			controller.delegate.Delegate__c = testContact2.Id;
			controller.delegate.Key_Member_Role__c = 'Project Approver';
			controller.delegate.Start_Date__c = Date.today().addDays(25);
			controller.addNewDelegate();
		}
	}


	static void setupTestData(){

		Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
		recordTypeId = ECO_Utils_sObject.getRecordTypeId(Contact.sObjectType, 'PSA Resource');

		Account testAccount = new Account();
		testAccount.Name = 'test account';
		insert testAccount;

		testUser = ECO_Utils_Testing.createTestUser('Standard User');
		testUser.CurrencyISOCode = 'USD';
		insert testUser;

		testContact = new Contact();
		testContact.Email = testUser.Email;
		testContact.FirstName = testUser.FirstName;
		testContact.LastName =  testUser.LastName;
		testContact.Phone = '55555555555';
		testContact.pse__Salesforce_User__c = testUser.Id;
		testContact.RecordTypeId = recordTypeId;
		testContact.User__c = testUser.Id;
		testContact.OwnerId = testUser.Id;
		insert testContact;

		projectRoles = new List<ProjectRole__c>();
		projectRoles.add(new ProjectRole__c(Name = 'Project Manager', Type__c = 'Key Member', Active__c = true));
		projectRoles.add(new ProjectRole__c(Name = 'Project Approver 2', Type__c = 'Key Member', Active__c = true));
		projectRoles.add(new ProjectRole__c(Name = 'Project Approver', Type__c = 'Key Member', Active__c = true));
		projectRoles.add(new ProjectRole__c(Name = 'Resilience Director', Type__c = 'Key Member', Active__c = true));
		projectRoles.add(new ProjectRole__c(Name = 'Project Worker', Active__c = true));
		insert projectRoles;

		OrganizationString__c organizationString = new OrganizationString__c(Name = 'Test Organization', ProjectAccountant2__c = testContact.Id, PLManagerContact__c = testContact.Id);
		insert organizationString;

		project = new pse__Proj__c(CarryingOutOrganization__c = organizationString.Id, pse__Account__c = testAccount.Id, pse__Start_Date__c = Date.today().addDays(30), pse__End_Date__c = Date.today().addDays(60));
	    insert project;

	    //project sites
		testSite = new Site__c();
		testSite.Account__c = testAccount.Id;
		testSite.CurrencyIsoCode = 'USD';
		testSite.City__c = 'Winnipeg';		
		testSite.VendorSiteID__c = '654321';
		testSite.CustomerAccountSiteID__c = '666666';

		insert testSite;

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
		projectMembers.add(new ProjectTeamMember__c(Project__c = project.Id, CurrencyIsoCode = 'USD', ProjectRole__c = projectRoles[1].Id, Contact__c = testContact.Id, StartDate__c = Date.today().addDays(5), EndDate__c = Date.today().addDays(6)));
		insert projectMembers;

		
		ECO_Delegate_Limits__c delegateLimitSettings = ECO_Delegate_Limits__c.getOrgDefaults();
		delegateLimitSettings.age_Change_in_Forecast_Net_Margin__c = 5;
		delegateLimitSettings.Agreement_Amount__c = 1000;
		delegateLimitSettings.Backlog_Value__c = 1000;
		delegateLimitSettings.Project_Net_Margin_age_of_NSR__c = 5;
		delegateLimitSettings.Project_Net_Margin_Value__c	 = 1000;
		delegateLimitSettings.Project_Revenue_Budget__c = 1000;
		delegateLimitSettings.Value_Change_In_Forecast_Net_Margin__c = 1000;
		upsert delegateLimitSettings;

	}
	
}