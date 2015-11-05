@isTest
private class ECO_Service_Delegation_Test
{
	Static List<User> users;
	Static List<Contact> contacts;

	@isTest
	static void testvacationadmin(){

		Test.startTest();
		ECO_Utils_Testing.createTestDataForProjectSync(3, 3);
		Test.stopTest();

		setupTestData();
		
		AECOM_Delegation__c ad = new AECOM_Delegation__c();
		ad.name = 'EcoPurchase Order';
		ad.Escalation__c = 'PNL';
		ad.Field_API_Name__c = 'ProjectManager__c';
		ad.Object_Name__c = 'POHeader__c';
		ad.Process__c = 'EcoPurchase Order';
		ad.Role__c = 'Project Manager';

		insert ad;

		Id recordTypeId = ECO_Utils_sObject.getRecordTypeId(Delegate__c.sObjectType, 'Vacation');
		Id recordTypeId2 = ECO_Utils_sObject.getRecordTypeId(Delegate__c.sObjectType, 'Key Roles');
		
		Delegate__c delegate = new Delegate__c();
		delegate.Delegate__c = contacts[1].Id;
		delegate.RecordTypeId = recordTypeId;
		delegate.Delegator__c = contacts[2].Id;
		delegate.Start_Date__c = Date.today();

		Delegate__c delegate2 = new Delegate__c(
												Key_Member_Role__c = 'Project Manager', 
												age_Change_in_Forecast_Net_Margin_lt__c = 1, 
												age_Change_in_Forecast_Net_Margin__c = 5,
												Agreement_Amount_estimated__c = 5000,
												Backlog_Value_lt__c = 1000,
												Backlog_Value__c = 5000,
												Project_Net_Margin_age_of_NSR_lt__c = 1,
												Project_Net_Margin_age_of_NSR__c = 5,
												Project_Net_Margin_Value_lt__c = 1000,
												Project_Net_Margin_Value__c = 5000,
												Project_Revenue_Budget_lt__c = 1000,
												Project_Revenue_Budget__c = 5000,
												Value_change_in_Forecast_Net_Margin_lt__c = 1000,
												Value_change_in_Forecast_Net_Margin__c = 5000,
												Project_Review_Category_C_4_Bypass__c = true,
												Project_Review_Category_C_4__c = false
												);
		delegate2.Delegate__c = contacts[0].Id;
		delegate2.RecordTypeId = recordTypeId2;
		delegate2.Delegator__c = contacts[2].Id;



		list<Delegate__c> lstdelToInsert = new list<Delegate__c> ();
		lstdelToInsert.add(delegate);
		lstdelToInsert.add(delegate2);

		insert lstdelToInsert;



		pse__Proj__c testProject = [SELECT Id, Name FROM pse__Proj__c LIMIT 1];
		testProject.ProjectLongName__c = null;
		testProject.PnLManager__c = contacts[2].id;
		testProject.clAECOMProjectReviewCategory__c = 'C-4';
		update testProject;

		POHeader__c po = new POHeader__c();
		po.Project__c = testProject.id;
		po.ProjectManager__c = users[0].id;

		insert po;

		po = [select id, ProjectManager__c from POHeader__c];
		list<delegation__c> lstDelegations = [select id from delegation__c];

		system.assertEquals(po.ProjectManager__c, contacts[1].pse__Salesforce_User__c);
		system.assertEquals(lstDelegations.size(), 3);

		po.ProjectManager__c = users[0].id;
		ad.Escalation__c = 'FA';



		update ad;
		update po;
	}

	@isTest
	static void testChangeManagement(){

		Test.startTest();
		ECO_Utils_Testing.createTestDataForProjectSync(3, 3);
		Test.stopTest();

		setupTestData();
		
		AECOM_Delegation__c ad = new AECOM_Delegation__c();
		ad.name = 'EcoPurchase Order';
		ad.Escalation__c = 'PNL';
		ad.Field_API_Name__c = 'ProjectApprover__c';
		ad.Object_Name__c = 'ChangeManager__c';
		ad.Process__c = 'EcoPurchase Order';
		ad.Role__c = 'Project Manager';

		insert ad;

		Id recordTypeId = ECO_Utils_sObject.getRecordTypeId(Delegate__c.sObjectType, 'Vacation');
		Id recordTypeId2 = ECO_Utils_sObject.getRecordTypeId(Delegate__c.sObjectType, 'Key Roles');
		
		Delegate__c delegate = new Delegate__c();
		delegate.Delegate__c = contacts[1].Id;
		delegate.RecordTypeId = recordTypeId;
		delegate.Delegator__c = contacts[2].Id;
		delegate.Start_Date__c = Date.today();

		Delegate__c delegate2 = new Delegate__c(
												Key_Member_Role__c = 'Project Manager', 
												age_Change_in_Forecast_Net_Margin_lt__c = 1, 
												age_Change_in_Forecast_Net_Margin__c = 5,
												Agreement_Amount_estimated__c = 5000,
												Backlog_Value_lt__c = 1000,
												Backlog_Value__c = 5000,
												Project_Net_Margin_age_of_NSR_lt__c = 1,
												Project_Net_Margin_age_of_NSR__c = 5,
												Project_Net_Margin_Value_lt__c = 1000,
												Project_Net_Margin_Value__c = 5000,
												Project_Revenue_Budget_lt__c = 1000,
												Project_Revenue_Budget__c = 5000,
												Value_change_in_Forecast_Net_Margin_lt__c = 1000,
												Value_change_in_Forecast_Net_Margin__c = 5000,
												Project_Review_Category_C_4_Bypass__c = true,
												Project_Review_Category_C_4__c = false
												);
		delegate2.Delegate__c = contacts[0].Id;
		delegate2.RecordTypeId = recordTypeId2;
		delegate2.Delegator__c = contacts[2].Id;



		list<Delegate__c> lstdelToInsert = new list<Delegate__c> ();
		lstdelToInsert.add(delegate);
		lstdelToInsert.add(delegate2);

		insert lstdelToInsert;



		pse__Proj__c testProject = [SELECT Id, Name FROM pse__Proj__c LIMIT 1];
		testProject.ProjectLongName__c = null;
		testProject.PnLManager__c = contacts[2].id;
		testProject.clAECOMProjectReviewCategory__c = 'C-4';
		update testProject;

		Id agreementRecordTypeId = ECO_Utils_Meta.getRecordTypeId(Agreement__c.sObjectType, 'Prime');
		Agreement__c agreement = new Agreement__c(RecordTypeId = agreementRecordTypeId, Project__c = testProject.Id, ChangeManagerIsChanged__c = true);
		insert agreement;		

		Id changeManagerRecordTypeId = ECO_Utils_Meta.getRecordTypeId(ChangeManager__c.sObjectType, 'Internal Change');
		ChangeManager__c changeManager = new ChangeManager__c(Project__c = testProject.Id, RecordTypeId = changeManagerRecordTypeId, ProjectApprover__c = contacts[0].pse__Salesforce_User__c);
		insert changeManager;


	}

	static void setupTestData(){

		Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
		Id recordTypeId = ECO_Utils_sObject.getRecordTypeId(Contact.sObjectType, 'PSA Resource');

		Account testAccount = [select id from Account];

		users = new List<User>();
		users.add(ECO_Utils_Testing.createTestUser('Standard User'));
		users.add(ECO_Utils_Testing.createTestUser('Standard User'));
		users.add(ECO_Utils_Testing.createTestUser('Standard User'));
		insert users;

		contacts = new List<Contact>();
		contacts.add(new Contact(pse__Is_Resource__c = true, Status__c = 'Active', Email = users[0].Email, FirstName = users[0].FirstName, LastName = users[0].LastName, pse__Salesforce_User__c = users[0].Id, recordTypeId = recordTypeId, User__c = users[0].Id, OwnerId = users[0].Id));
		contacts.add(new Contact(pse__Is_Resource__c = true, Status__c = 'Active', Email = users[1].Email, FirstName = users[1].FirstName, LastName = users[1].LastName, pse__Salesforce_User__c = users[1].Id, recordTypeId = recordTypeId, User__c = users[1].Id, OwnerId = users[1].Id));
		contacts.add(new Contact(pse__Is_Resource__c = true, Status__c = 'Active', Email = users[2].Email, FirstName = users[2].FirstName, LastName = users[2].LastName, pse__Salesforce_User__c = users[2].Id, recordTypeId = recordTypeId, User__c = users[2].Id, OwnerId = users[2].Id));
		insert contacts;
	}
}