@isTest
private class ECO_BatchUpdateKeyMembersStartDateTest {
	static ProjectTeamMember__c projectTeamMember;
	static pse__Proj__c project;

	@isTest static void testBatch() {
		setupTestData();
		test.startTest();
		Database.executeBatch(new ECO_BatchUpdateKeyMembersStartDate());
		test.stopTest();

		projectTeamMember = [Select Id, StartDate__c from ProjectTeamMember__c where Id =: projectTeamMember.Id];
		system.assertEquals(project.pse__Start_Date__c, projectTeamMember.StartDate__c);
	}
	
	static void setupTestData(){

		Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
		Id recordTypeId = ECO_Utils_sObject.getRecordTypeId(Contact.sObjectType, 'PSA Resource');

		Account testAccount = new Account();
		testAccount.Name = 'test account';
		insert testAccount;

		User user = ECO_Utils_Testing.createTestUser('Standard User');
		insert user;

		Contact projContact = new Contact(pse__Is_Resource__c = true, Status__c = 'Active', Email = user.Email, FirstName = user.FirstName, LastName = user.LastName, pse__Salesforce_User__c = user.Id, recordTypeId = recordTypeId, User__c = user.Id, OwnerId = user.Id);
		insert projContact;

		List<ProjectRole__c> projectRoles = new List<ProjectRole__c>();
		projectRoles.add(new ProjectRole__c(Name = 'Project Manager', Type__c = 'Key Member', Active__c = true));
		projectRoles.add(new ProjectRole__c(Name = 'Resilience Director', Type__c = 'Key Member', Active__c = true));
		insert projectRoles;

		OrganizationString__c organizationString = new OrganizationString__c(Name = 'Test Organization', ProjectAccountant2__c = projContact.Id, PLManagerContact__c = projContact.Id);
		insert organizationString;

		project = new pse__Proj__c(OwnerId = user.Id, CarryingOutOrganization__c = organizationString.Id, pse__Account__c = testAccount.Id, pse__Start_Date__c = Date.today().addDays(30), pse__End_Date__c = Date.today().addDays(60), pse__Stage__c = 'Planning');
	    insert project;
		
		projectTeamMember = new ProjectTeamMember__c(Project__c = project.Id, CurrencyIsoCode = 'USD', ProjectRole__c = projectRoles[0].Id, Contact__c = projContact.Id, StartDate__c = Date.today(), Status__c = 'Pending');
		insert projectTeamMember;
	}
	
}