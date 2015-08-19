public without sharing class ECO_Utils_Testing {
	
	public static User createTestUser (String profileName) {

		Id profileId = ECO_Utils_Meta.getProfileId(profileName);
		
		Integer randomNumber = Integer.valueOf(Math.random()*1000);
		
		User u = new User();
		u.FirstName = randomNumber + 'tuser';
		u.LastName = randomNumber + 'tuser';
	    u.Email = randomNumber + 'tuser' + '.' +randomNumber + 'tuser' + '@testuser.net';
	    u.Username =  randomNumber + 'tuser' + '.' +randomNumber + 'tuser' + '@testuser.net' + '.test';
	    u.CommunityNickname = randomNumber + 'tuser';
	    u.Alias = randomNumber + 'tuser';
	    u.TimeZoneSidKey = 'America/Los_Angeles';
	    u.LocaleSidKey = 'en_US';
	    u.EmailEncodingKey = 'ISO-8859-1';
	    u.ProfileId = profileId;
	    u.LanguageLocaleKey = 'en_US';
	    u.ECO_BusinessLine__c = 'Construction';
	    u.ECO_Geography__c = 'United States';
	    u.ECO_Region__c = '3';
    	
    	return u;
    }


    public static void createTestDataForProjectSync(Integer numTestProjectTasks, Integer numTeamMembers){

    	Id recordTypeId = ECO_Utils_sObject.getRecordTypeId(Contact.sObjectType, 'PSA Resource');

		Account testAccount = new Account();
		testAccount.Name = 'test Account';
		testAccount.OracleCustomerID__c = '123456';
		testAccount.OracleCustomerNumber__c = '999999';

		insert testAccount;

		OrganizationString__c testOrg = createTestOrg();
		insert testOrg;

		//create pm		
		Contact pm = new Contact();
		pm.Email = 'pm@test.ca';
		pm.FirstName = 'test';
		pm.LastName =  'pm';
		pm.Phone = '55555555555';
		//pm.RecordTypeId = recordTypeId;
		insert pm;	
	

		//create create source project 		
		pse__Proj__c testProject = createTestProject('test project 1');
		//testProject.PrimaryOrganization__c = testOrg.Id;
		testProject.CarryingOutOrganization__c = testOrg.Id;
		testProject.pse__Account__c = testAccount.Id;
		//set some oracle classification fields
		testProject.clACLOfficeLocation__c = 'CAN - Burnaby';
		testProject.clBillableWorkersComp__c = 'Yes';
		testProject.pse__Project_Manager__c = pm.Id;
		insert testProject;

		//tasks
		List<pse__Project_Task__c> testProjectTasks = new List<pse__Project_Task__c>();
		for(Integer i =0; i<numTestProjectTasks; i++){
			pse__Project_Task__c task = new pse__Project_Task__c();
			task.Name = 'task' + i;
			//task.FinancialTask__c = true;
			task.pse__Project__c = testProject.Id;
			task.pse__Start_Date_Time__c = DateTime.now().addDays(i);
			task.pse__End_Date_Time__c = DateTime.now().addDays(i+1);
			task.pse__Status__c = 'Draft';
			task.ProjectTaskNumber__c = 'tasknumber' + i;
			task.pse__Description__c = 'task' + i + 'longname';
			task.WorkTypeName__c = 'Home Office';
			task.CostIndRateSCHID__c = '6748';

			testProjectTasks.add(task);
		}
			
		insert testProjectTasks;

		
		//team members
		ProjectRole__c projectRole = new ProjectRole__c();
		projectRole.Name = 'Project Manager';
		projectRole.Type__c = 'Key Member';
		projectRole.Active__c = true;
		insert projectRole;

		Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 

		User testManager = new User();
		testManager.Alias = 'manager';
		testManager.Email ='testmanager@example.com';
		testManager.EmailEncodingKey ='UTF-8';
		testManager.FirstName = 'test';
		testManager.LastName ='manager';
		testManager.LanguageLocaleKey ='en_US';
		testManager.LocaleSidKey ='en_US';
		testManager.ProfileId = p.Id;
        testManager.TimeZoneSidKey ='America/Los_Angeles';
        testManager.UserName ='testmanager@example.com';
        insert testManager;

		List<User> testUsers = new List<User>();
		for(Integer i=0; i<numTeamMembers; i++){
			User testUser = new User();
			testUser.Alias = 'myuser' + i;
			testUser.Email ='mytestuser' + i + '@example.com';
			testUser.EmailEncodingKey ='UTF-8';

			testUser.FirstName = 'test' + i;
			testUser.LastName ='Testing' + i;
			testUser.LanguageLocaleKey ='en_US';
			testUser.LocaleSidKey ='en_US';
			testUser.ProfileId = p.Id;
            testUSer.TimeZoneSidKey ='America/Los_Angeles';
            testUser.UserName ='mytestuser' + i + '@example.com';
            testUser.EmployeeNumber = String.valueOf(i);
            testUser.PersonId__c = String.valueOf(i);
            testUser.ManagerId = testManager.Id;
            testUsers.add(testUser);
		}
		insert testUsers;

		

		List<Contact> contacts = new List<Contact>();
		for(User testUser : testUsers){
			Contact testContact = new Contact();
			testContact.Email = testUser.Email;
			testContact.FirstName = testUser.FirstName;
			testContact.LastName =  testUser.LastName;
			testContact.Phone = '55555555555';
			testContact.pse__Salesforce_User__c = testUser.Id;
			testContact.RecordTypeId = recordTypeId;
			testContact.User__c = testUser.Id;
			
			contacts.add(testContact);
		}
		insert contacts;

		List<ProjectTeamMember__c> testProjectTeamMembers = new List<ProjectTeamMember__c>();
		
		for(Contact testContact : contacts){		
			testContact.User__c = testContact.pse__Salesforce_User__c;
			ProjectTeamMember__c member = new ProjectTeamMember__c();			
			member.Project__c = testProject.Id;			
			member.CurrencyIsoCode = 'USD';	
			//member.Role__c = 'Project Manager';
			member.ProjectRole__c = projectRole.Id;
			member.Contact__c = testContact.Id;
			member.StartDate__c = Date.today();
			member.EndDate__c = Date.today().addDays(1);
			testProjectTeamMembers.add(member);			
		}
		insert testProjectTeamMembers;



		//project sites
		Site__c testSite = new Site__c();
		testSite.Account__c = testAccount.Id;
		testSite.CurrencyIsoCode = 'USD';
		testSite.City__c = 'Winnipeg';		
		testSite.VendorSiteID__c = '654321';
		testSite.CustomerAccountSiteID__c = '666666';

		insert testSite;

		Project_Site__c testProjectSite = new Project_Site__c();
		
		testProjectSite.BillingContactID__c	= '1234';
		//testProjectSite.OracleProjectSiteId__c = '1111';
		testProjectSite.Project__c = testProject.Id;
		testProjectSite.Site__c = testSite.Id;
		testProjectSite.Contribution__c = 100;

		insert testProjectSite;
	}

	public static void createTestDataForProjectNumberRequest(){

		//create test data
		Account testAccount = new Account();
		testAccount.Name = 'test Account';
		insert testAccount;

		OrganizationString__c testOrg = createTestOrg();
		insert testOrg;

		//create create source project 		
		pse__Proj__c testProject = createTestProject('test project1');
		//testProject.PrimaryOrganization__c = testOrg.Id;
		testProject.CarryingOutOrganization__c = testOrg.Id;
		testProject.pse__Account__c = testAccount.Id;
		insert testProject;
	
	}

	public static pse__Proj__c createTestProject(String projName){
		pse__Proj__c testProject = new pse__Proj__c();
		testProject.Name = projName;	
		testProject.pse__Project_Type__c = 'Customer Project';
		testProject.pse__Billing_Type__c = 'Fixed Price';
		testProject.CurrencyIsoCode = 'USD';
		testProject.pse__Is_Active__c = true;
		testProject.ProjectLongName__c = projName + ' long name';
		testProject.ContractTypes__c = 'Fixed Priece - Hard Bid';
		testProject.DistributionRule__c = 'COST/WORK';
		testProject.ProjectFunctionalCurrencyCode__c = 'AUD';
		testProject.ProjectCurrencyCode__c = 'AUD';
		testProject.COSTINDRATESCHID__c = '6748';
		testProject.pse__Start_Date__c = Date.today();
		return testProject;
	}

	public static OrganizationString__c createTestOrg(){
		OrganizationString__c org = new OrganizationString__c();
		org.BusinessLineName__c = 'test business';
		org.Department__c = 'test dept';
		org.Description__c = 'test org string';
		org.District__c = 'test district';
		org.OrganizationName__c = '123456789';
		org.OrgID__c = '117';
		org.OUID__c = '147';
		org.TemplateIdCostWork__c = '1152536|T_ECO_CW_AUS';
		return org;
	}


}