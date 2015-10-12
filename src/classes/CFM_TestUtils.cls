public class CFM_TestUtils {
	public static void createTestSurveyBatch() {
		createTestSurveyBatch(1, true);
	}

	public static void createTestSurveyBatch(Integer numberOfProjects, Boolean createBatchProjects) {
		CFM_Survey_Batch__c surveyBatch = new CFM_Survey_Batch__c();
		surveyBatch.Survey_Name__c = 'Test Survey Name';
		surveyBatch.Survey_Close_Date__c = Date.today();
		surveyBatch.Target_Survey_Date__c = Date.today();
		surveyBatch.Status__c = CFM_SurveyBatch.STATUS_NEW;

		insert surveyBatch;

		List<Project__c> projects = createTestProjects(numberOfProjects);


		if (createBatchProjects) {
			List<CFM_Survey_Batch_Project__c> batchProjects = new List<CFM_Survey_Batch_Project__c>();

			for (Project__c project : projects) {
				CFM_Survey_Batch_Project__c batchProject = new CFM_Survey_Batch_Project__c();
				batchProject.Survey_Batch__c = surveyBatch.Id;
				batchProject.Project__c = project.Id;
				batchProject.Status__c = CFM_SurveyBatchProject.STATUS_NEW;
				batchProject.Add_Method__c = 'Manual Selection';
				batchProjects.add(batchProject);
			}
			
			insert batchProjects;
		}
		
	}


	public static User createTestUser(String email, String alias) {
		return createTestUser(email, alias, true);
	}

	private static Profile standardProfile;

	public static User createTestUser(String email, String alias, Boolean shouldInsert) {
		if (standardProfile == null) standardProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = alias, CommunityNickname=alias, Email=email, 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = standardProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName=email,
            Geography_Allocation__c='Corporate');

        if (shouldInsert) insert u;

        return u;
	}


	public static Contact createTestContact(String firstName, String lastName, String email) {
		return createTestContact(firstName, lastName, email, true);
	}

	public static Contact createTestContact(String firstName, String lastName, String email, Boolean shouldInsert) {
		Contact c = new Contact(FirstName=firstName, LastName=lastName, Email=email);
		if (shouldInsert) insert c;
		return c;
	}


	public static void createTestHierarchies() {
		User u1 = createTestUser('aecomhierarchy1test@aecom.com', 'aechier1');
		User u2 = createTestUser('aecomhierarchy2test@aecom.com', 'aechier2');

		CFM_Survey_Case_Hierarchy__c def = new CFM_Survey_Case_Hierarchy__c();
		def.Is_Default_Rule__c = true;
		def.Step_1_Days__c = 1;
		def.Step_2_Days__c = 1;
		def.Step_1_Email__c = 'Level_1_4_Initial_Alert_E_mail_to_FUO';
		def.Step_2_Email__c = 'Escalation_1_E_mail_to_EO';
		def.Step_3_Email__c = 'Escalation_2_E_mail_to_Client_Care';
		def.Step_1_Assign_To__c = u1.Id;
		def.Step_2_Assign_To__c = u1.Id;
		def.Step_3_Assign_To__c = u1.Id;
		insert def;

		CFM_Survey_Case_Hierarchy__c h = new CFM_Survey_Case_Hierarchy__c();
		h.Is_Default_Rule__c = false;
		h.Step_1_Days__c = 1;
		h.Step_2_Days__c = 1;
		h.Step_1_Email__c = 'Level_1_4_Initial_Alert_E_mail_to_FUO';
		h.Step_2_Email__c = 'Escalation_1_E_mail_to_EO';
		h.Step_3_Email__c = 'Escalation_2_E_mail_to_Client_Care';
		h.Operating_Group__c = 'DCS AME';
		h.Lead_District__c = 'Midwest';
		h.Step_1_Assign_To__c = u2.Id;
		h.Step_2_Assign_To__c = u2.Id;
		h.Step_3_Assign_To__c = u2.Id;
		insert h;

	}


	public static List<Project__c> createTestProjects(Integer numberOfProjects) {
		Country__c c = new Country__c();
		c.Name = 'America';
		c.Country_Code__c = 'US';
		c.Region__c = 'Test Region';
		insert c;

		Account a = new Account();
		a.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account Record Type - Global').getRecordTypeId();
		a.Name = 'Test Account';
		a.Client_Group__c = 'Test';
		a.Client_Subgroup__c = 'Test 2';
		a.Type__c = 'Client/Prospect';
		a.City__c = 'Test City';
		a.CountryLookup__c = c.Id;
		insert a;

		AECOM_Primary_Department__c department = new AECOM_Primary_Department__c();
		department.Name = 'Test Department';
		department.Group_Division__c = 'Construction Services';
		department.Operating_Group__c = 'DCS AME';
		department.Lead_District__c = 'Midwest';
		insert department;

		List<User> userList = new List<User>();
		for (Integer i = 0; i < numberOfProjects; i++) {
			userList.add(createTestUser('projectmanagertest' + i + '@aecom.com', 'pmtest' + i, false));
		}

		insert userList;

		List<Contact> contactList = new List<Contact>();
		for (Integer i = 0; i < numberOfProjects; i++) {
			contactList.add(createTestContact('Test' + i, 'SurveyContact' + i, 'test@test.com' + i, false));
		}

		insert contactList;

		List<Project__c> newProjects = new List<Project__c>();

		for (Integer i = 0; i < numberOfProjects; i++) {
			Project__c newProject = new Project__c();
			newProject.RecordTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Project').getRecordTypeId();
			newProject.Name = 'Test Project ' + i;
			// Not using lookup field for now newProject.CFM_Department__c = department.Id;
			newProject.OracleDepartment__c = department.Name;
			newProject.CFM_Survey_Contact__c = contactList[i].Id;
			newProject.Project_Description__c = 'Test ' + i;
			newProject.Owner__c = a.Id;
			newProject.Oracle_Project_Manager_lookup__c = userList[i].Id;
			newProject.OraclePercentComplete__c = 80;
			newProjects.add(newProject);
		}

		insert newProjects;
		

		return newProjects;
	}
}