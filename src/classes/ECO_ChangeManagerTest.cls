@isTest
public with sharing class ECO_ChangeManagerTest {

	static testMethod void testChangeManagerForMultipleChanges()
	{
		ECO_Utils_Testing.createTestDataForProjectSync(3, 3);
		
		pse__Proj__c project = [select Id from pse__Proj__c limit 1];

		Id agreementRecordTypeId = ECO_Utils_Meta.getRecordTypeId(Agreement__c.sObjectType, 'Prime');
		Agreement__c agreement = new Agreement__c(RecordTypeId = agreementRecordTypeId, Project__c = project.Id, ChangeManagerIsChanged__c = true);
		insert agreement;		

		Id changeManagerRecordTypeId = ECO_Utils_Meta.getRecordTypeId(ChangeManager__c.sObjectType, 'Internal Change');
		ChangeManager__c changeManager = new ChangeManager__c(Project__c = project.Id, RecordTypeId = changeManagerRecordTypeId);
		insert changeManager;
		
		Test.startTest();
		changeManager.IntExtContractManagement__c = true;
		changeManager.ApprovalStatus__c = 'Submitted';
		update changeManager;
		Test.stopTest();
		
		changeManager = [select Id, ApprovalStatus__c, SubmittedIdsForApproval__c from ChangeManager__c limit 1];
		system.AssertEquals(agreement.Id, changeManager.SubmittedIdsForApproval__c);
		
		Agreement__c agreement2 = new Agreement__c(RecordTypeId = agreementRecordTypeId, Project__c = project.Id, ChangeManagerIsChanged__c = true);
		insert agreement2;	
		
		Funding__c funding = new Funding__c(Project__c = project.Id, Agreement__c = agreement2.Id);
		insert funding;			
				
		ECO_ChangeManager_Service.getChangeManagerSubmittedIds(project.Id);
		system.AssertEquals(1, ECO_ChangeManager_Service.getChangedAgreements(project.Id, ECO_ChangeManager_Service.getChangeManagerSubmittedIds(project.Id), false).size());	
		system.AssertEquals(agreement2.Id, ECO_ChangeManager_Service.getChangedAgreements(project.Id, ECO_ChangeManager_Service.getChangeManagerSubmittedIds(project.Id), false)[0].Id);	
		system.AssertEquals(true, ECO_ChangeManager_Service.isChangedAgreements(project.Id, ECO_ChangeManager_Service.getChangeManagerSubmittedIds(project.Id)));//, ECO_ChangeManager_Service.getChangedContractManagement(project, ECO_ChangeManager_Service.getChangeManagerSubmittedIds(project))[0].Id);	

		Project_Site__c site = [select Id, Name, Account_Name__c, ChangeManagerApprovedForSynch__c, ChangeManagerIsChanged__c from Project_Site__c limit 1];
		system.AssertEquals(true, site.ChangeManagerIsChanged__c);
		system.AssertEquals(true, ECO_ChangeManager_Service.isChangedCustomers(project.Id, ECO_ChangeManager_Service.getChangeManagerSubmittedIds(project.Id)));
		system.AssertEquals(1, ECO_ChangeManager_Service.getChangedCustomers(project.Id, ECO_ChangeManager_Service.getChangeManagerSubmittedIds(project.Id), false).size());

		system.AssertEquals(true, ECO_ChangeManager_Service.isChangedKeyMembers(project.Id, ECO_ChangeManager_Service.getChangeManagerSubmittedIds(project.Id)));
		system.AssertEquals(3, ECO_ChangeManager_Service.getChangedKeyMembers(project.Id, ECO_ChangeManager_Service.getChangeManagerSubmittedIds(project.Id), false).size());

		system.AssertEquals(true, ECO_ChangeManager_Service.isChangedTasks(project.Id, ECO_ChangeManager_Service.getChangeManagerSubmittedIds(project.Id)));
		system.AssertEquals(3, ECO_ChangeManager_Service.getChangedTasks(project.Id, ECO_ChangeManager_Service.getChangeManagerSubmittedIds(project.Id), false).size());

		ChangeManager__c changeManager2 = new ChangeManager__c(Project__c = project.Id, RecordTypeId = changeManagerRecordTypeId);
		insert changeManager2;
		
		changeManager2.IntExtContractManagement__c = true;
		changeManager2.IntExtSchedule__c = true;
		changeManager2.IntExtKeyMembers__c = true;
		changeManager2.IntExtCustomers__c = true;
		changeManager2.ApprovalStatus__c = 'Submitted';
		update changeManager2;

		changeManager2 = [select Id, ApprovalStatus__c, SubmittedIdsForApproval__c from ChangeManager__c where Id = :changeManager2.Id order by id desc limit 1];
		system.AssertEquals(false, changeManager2.SubmittedIdsForApproval__c.contains(agreement.Id));
		system.AssertEquals(true, changeManager2.SubmittedIdsForApproval__c.contains(agreement2.Id));
		system.AssertEquals(true, changeManager2.SubmittedIdsForApproval__c.contains(site.Id));
	}

	static testMethod void testChangeManagerForDeliverableAndScope()
	{
		ECO_Utils_Testing.createTestDataForProjectSync(3, 3);
		
		Test.startTest();
		
		pse__Proj__c project = [select Id from pse__Proj__c limit 1];
		
		Deliverable__c deliverable = new Deliverable__c(Project__c = project.Id);
		insert deliverable;

		system.assertEquals(false, ECO_ChangeManager_Service.isChangedClassifications(project.Id));	
		system.assertEquals(false, ECO_ChangeManager_Service.isChangedSafetyHealthEnv(project.Id));	
		system.assertEquals(false, ECO_ChangeManager_Service.isChangedResilence(project.Id));	
		system.assertEquals(false, ECO_ChangeManager_Service.isChangedProjectClosure(project.Id));	
		system.assertEquals(false, ECO_ChangeManager_Service.isChangedProjectOnHold(project.Id));
		system.assertEquals(false, ECO_ChangeManager_Service.isChangedDocumentManagement(project.Id));
		system.assertEquals(false, ECO_ChangeManager_Service.isChangedStakeholders(project.Id, ECO_ChangeManager_Service.getChangeManagerSubmittedIds(project.Id)));
		system.assertEquals(true, ECO_ChangeManager_Service.isChangedDeliverables(project.Id, ECO_ChangeManager_Service.getChangeManagerSubmittedIds(project.Id)));
		system.assertEquals(false, ECO_ChangeManager_Service.isChangedResources(project.Id, ECO_ChangeManager_Service.getChangeManagerSubmittedIds(project.Id)));
		system.assertEquals(true, ECO_ChangeManager_Service.isChangedScope(project.Id, ECO_ChangeManager_Service.getChangeManagerSubmittedIds(project.Id)));
		system.assertEquals(false, ECO_ChangeManager_Service.isChangedFunding(project.Id, ECO_ChangeManager_Service.getChangeManagerSubmittedIds(project.Id)));
									
		Test.stopTest();				
	}
	
	static testMethod void testChangeManageSubmittedAndApproved()
	{
		ECO_Utils_Testing.createTestDataForProjectSync(3, 3);
		pse__Proj__c project = [select Id from pse__Proj__c limit 1];
		project.OracleProjectNumber__c = '123456';
		update project;
		
		Id agreementRecordTypeId = ECO_Utils_Meta.getRecordTypeId(Agreement__c.sObjectType, 'Prime');
		Agreement__c agreement = new Agreement__c(RecordTypeId = agreementRecordTypeId, Project__c = project.Id, ChangeManagerIsChanged__c = true);
		insert agreement;			

		Id changeManagerRecordTypeId = ECO_Utils_Meta.getRecordTypeId(ChangeManager__c.sObjectType, 'Internal Change');
		ChangeManager__c changeManager = new ChangeManager__c(Project__c = project.Id, RecordTypeId = changeManagerRecordTypeId);
		insert changeManager;
			
		Test.startTest();
		system.AssertEquals(true, ECO_ChangeManager_Service.isChangedAgreements(project.Id, ECO_ChangeManager_Service.getChangeManagerSubmittedIds(project.Id)));	
		changeManager.IntExtContractManagement__c = true;
		update changeManager;					
		system.AssertEquals(true, ECO_ChangeManager_Service.isChangedAgreements(project.Id, ECO_ChangeManager_Service.getChangeManagerSubmittedIds(project.Id)));	
		changeManager.ApprovalStatus__c = 'Submitted';
		update changeManager;					
		system.AssertEquals(false, ECO_ChangeManager_Service.isChangedAgreements(project.Id, ECO_ChangeManager_Service.getChangeManagerSubmittedIds(project.Id)));	
		changeManager.ApprovalStatus__c = 'Approved';
		update changeManager;		
		Test.stopTest();			
		system.AssertEquals(false, ECO_ChangeManager_Service.isChangedAgreements(project.Id, ECO_ChangeManager_Service.getChangeManagerSubmittedIds(project.Id)));	
		system.AssertEquals('', ECO_ChangeManager_Service.getChangeManagerSubmittedIds(project.Id)[0]);
		agreement = [select Id, ChangeManagerApprovedForSynch__c, ChangeManagerIsChanged__c from Agreement__c where id = :agreement.Id];
		system.AssertEquals(true, agreement.ChangeManagerApprovedForSynch__c);
		system.assertequals(false, agreement.ChangeManagerIsChanged__c);																
	}	
	
	/*static testmethod void testChangeManager()
	{
		Account testAccount = new Account();
		testAccount.Name = 'test Account';
		insert testAccount;
		
		Contact testContact = new Contact();
		testContact.LastName = 'Test Last Name';
		testContact.FirstName = 'Test First Name';
		insert testContact;

		//create create source project 
		pse__Proj__c testProject = new pse__Proj__c();
		testProject.Name = 'test project 1';
		testProject.pse__Account__c = testAccount.Id;
		testProject.pse__Project_Type__c = 'Customer Project';
		testProject.pse__Billing_Type__c = 'Fixed Price';
		testProject.CurrencyIsoCode = 'USD';
		testProject.pse__Is_Active__c = true;
		testProject.pse__End_Date__c = Date.today().addDays(5);
		testProject.pse__Stage__c = 'Execution';
		insert testProject;	
		
		Id agreementRecordTypeId = ECO_Utils_Meta.getRecordTypeId(Agreement__c.sObjectType, 'Prime');
		Agreement__c agreement = new Agreement__c(RecordTypeId = agreementRecordTypeId, Project__c = testProject.Id, ChangeManagerIsChanged__c = true);
		insert agreement;
		
		ProjectTeamMember__c teammember = new ProjectTeamMember__c(Project__c = testProject.Id);
		insert teammember;
		
		Id changeManagerRecordTypeId = ECO_Utils_Meta.getRecordTypeId(ChangeManager__c.sObjectType, 'Internal Change');
		ChangeManager__c changeManager = new ChangeManager__c(Project__c = testProject.Id, RecordTypeId = changeManagerRecordTypeId);
		insert changeManager;
		
		system.assertEquals(true, agreement.ChangeManagerIsChanged__c);
	}*/
}