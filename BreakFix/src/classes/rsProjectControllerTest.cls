/*************************************************************************
*
* PURPOSE: Test Class for Controller for Projects component
*
* CREATED: 2014 Ethos Solutions - www.ethos.com
* AUTHOR: Alex Molina
***************************************************************************/
@isTest
private class rsProjectControllerTest {
	private static testmethod void testNewCancel() {
		Test.startTest();
		rsProjectController cont = new rsProjectController();
		cont.profile = rsProfile.find.byUserId(UserInfo.getUserId());
		PageReference newResult = cont.newPart();
		Test.stopTest();

		System.assertEquals(newResult, null);
		System.assert(cont.getisEditMode() );
		PageReference cancelResult = cont.cancelPart();
		System.assertEquals(cancelResult, null);
		System.assertEquals(cont.getOldProject(), null);
		System.assertEquals(cont.CurrentProject, null);
		System.assert(cont.getIsListMode() );
	}

	private static testmethod void testSaveDelete() {
		//Create a new work history record that we'll reference when we create a non aecom project
		rsTestUtil.createTestProfilePartForUserId(UserInfo.getUserId(), rsProfilePart.RT_WORK_HISTORY, 1);
		rsProfilePart workHistoryRecord =  rsProfilePart.find.byIdAsSelfOrProxyOrCM(UserInfo.getUserId()).get(0) ;

		Test.startTest();
		rsProjectController cont = new rsProjectController();
		cont.profile = rsProfile.find.byUserId(UserInfo.getUserId());
		cont.newPart();
		//Test create new AECOM Project
		cont.newAECOMProjectView();
		cont.CurrentProject.setProjectNameEditable('Test Project Name');
		cont.CurrentProject.setProjectNumberEditable('123456789');
		cont.CurrentProject.setProjectGroup('Test Project Group');
		cont.CurrentProject.setLocationCountryEditable('United States');
		cont.CurrentProject.setProjectRole('Architect');
		cont.CurrentProject.setLocationStateProvinceEditable('Arizona');
		cont.CurrentProject.setClientNameEditable('Test Client Name');
		cont.CurrentProject.setLocationCityEditable('Test City');
		cont.CurrentProject.setDateInvolvementStarted('10/11/12');
		cont.CurrentProject.setDateInvolvementEnded('01/02/13');
		cont.CurrentProject.setOutputonResume(true);
		cont.CurrentProject.setRoleDescription('Here is a role description');
		cont.savePart();

		cont.newPart();
		//Test create new Non-AECOM Project
		cont.nonAECOMProjectView();
		cont.setisNonAECOMProject(true);
		cont.nonAECOMCheckRT();
		cont.CurrentProject.setProjectNameEditable('Test Project Name');
		cont.CurrentProject.getObj().put('Work_History__c', workHistoryRecord.getId() );
		cont.CurrentProject.setProjectGroup('Test Project Group');
		cont.CurrentProject.setLocationCountryEditable('United States');
		cont.CurrentProject.setProjectRole('Architect');
		cont.CurrentProject.setLocationStateProvinceEditable('Arizona');
		cont.CurrentProject.setClientNameEditable('Test Client Name');
		cont.CurrentProject.setLocationCityEditable('Test City');
		cont.CurrentProject.setDateInvolvementStarted('10/11/12');
		cont.CurrentProject.setDateInvolvementEnded('01/02/13');
		cont.CurrentProject.setOutputonResume(true);
		cont.CurrentProject.setRoleDescription('Here is a role description');
		cont.savePart();


		Test.stopTest();

		List<rsPRTeamEmployee> onlyAECOM = cont.getAECOMProfileProjectParts();
		System.assertEquals(onlyAECOM.size(), 1);
		List<rsPRTeamEmployee> onlyNonAECOM = cont.getNonAECOMProfileProjectParts();
		System.assertEquals(onlyNonAECOM.size(), 1);

		System.assertEquals(cont.getIsExistingAECOMProject(), true);
		System.assertEquals(cont.getIsNewAECOMProject(), false);
		System.assertEquals(cont.getIsNonAECOMProject(), false);

		ApexPages.currentPage().getParameters().put('projectId', cont.CurrentProject.getId());
		cont.deletePart();

		List<rsPRTeamEmployee> profileProjectsRequery = rsPRTeamEmployee.find.byIdAsSelfOrProxyOrCM(cont.profile.getId());
		System.assertEquals(profileProjectsRequery.size(), 1);
	}

	private static testmethod void testEditView() {
		Test.startTest();
		rsProjectController cont = new rsProjectController();
		cont.profile = rsProfile.find.byUserId(UserInfo.getUserId());
		PageReference newResult = cont.newPart();
		cont.newAECOMProjectView();
		cont.CurrentProject.setDateInvolvementStarted('10/11/12');
		cont.CurrentProject.setDateInvolvementEnded('01/02/13');
		cont.CurrentProject.setProjectRole('Here is a test project role');
		cont.CurrentProject.setRoleDescription('Here is a role description');
		cont.savePart();

		ApexPages.currentPage().getParameters().put('projectId', cont.CurrentProject.getId());

		cont = new rsProjectController();
		cont.profile = rsProfile.find.byUserId(UserInfo.getUserId());
		System.assertEquals(cont.profile.getProfileProjects().size(), 1);
		cont.editPart();
		System.assert(cont.CurrentProject != null);
		System.assert(cont.getIsEditMode() );
		cont.savePart();
		System.assert(cont.getIsListMode() );
		cont.viewPart();
		System.assert(cont.getIsViewMode() );
		System.assert(cont.CurrentProject != null);

		Test.stopTest();
	}

	private static testmethod void testApprovePart() {
		rsTestUtil.createTestProjectPartForUserId(UserInfo.getUserId(), rsPRTeamEmployee.RT_AECOMPROJECT, 1);
		
		Test.startTest();
		rsProjectController cont = new rsProjectController();
		cont.profile = rsProfile.find.byUserId(UserInfo.getUserId());
		rsPRTeamEmployee partToBeApproved = cont.profile.getProfileProjects().get(0);
		ApexPages.currentPage().getParameters().put('partId', partToBeApproved.getId() );
		cont.approvePart();
		Test.stopTest();

		rsPRTeamEmployee partToBeApprovedRequery = new rsPRTeamEmployee((PR_Team_Employee__c)rsPRTeamEmployee.find.byId(partToBeApproved.getId()).getObj());
		System.assert(partToBeApprovedRequery.getStatus() == rsPRTeamEmployee.S_APPROVED);
	}

	private static testmethod void testViewParts() {
		rsTestUtil.createTestProjectPartForUserId(UserInfo.getUserId(), rsPRTeamEmployee.RT_AECOMPROJECT, 1);
		rsTestUtil.createTestProjectPartForUserId(UserInfo.getUserId(), rsPRTeamEmployee.RT_NONAECOMPROJECT, 1);

		Test.startTest();
		rsProjectController cont = new rsProjectController();
		cont.profile = rsProfile.find.byUserId(UserInfo.getUserId());
		cont.getAECOMProjectViewParts();
		cont.getNonAECOMProjectViewParts();
		Test.stopTest();

		//TO-DO 
		//Assert things about this. Probably will leave for Brian since he understands the grouping and view parts 
	}

	private static testmethod void testmoveGroupAECOMProjects() {
		//Initial group, we will not be moving this one
		rsTestUtil.createTestProjectPartForUserId(UserInfo.getUserId(), rsPRTeamEmployee.RT_AECOMPROJECT, 2);
		List<PR_Team_Employee__c> testParts2 = [Select Id, RecordTypeId, Project_Group_Editable__c from PR_Team_Employee__c];
		Set<Id> usedIds = new Set<Id>();
		for(PR_Team_Employee__c part : testParts2) {
			part.Project_Group_Editable__c = 'test2';
			part.Group_Sequence__c = 0;
			usedIds.add(part.Id);
		}
		//We'll add the group that we'll move
		rsTestUtil.createTestProjectPartForUserId(UserInfo.getUserId(), rsPRTeamEmployee.RT_AECOMPROJECT, 2);
		List<PR_Team_Employee__c> testParts = [Select Id, RecordTypeId, Project_Group_Editable__c from PR_Team_Employee__c where Id NOT IN: usedIds];
		for(PR_Team_Employee__c part : testParts) {
			part.Group_Sequence__c = 1;
		}
		update testParts2;
		update testParts;

		rsProjectController cont = new rsProjectController();
		cont.profile = rsProfile.find.byUserId(UserInfo.getUserId());
		ApexPages.currentPage().getParameters().put('projectGroup','');
		ApexPages.currentPage().getParameters().put('recordType',testParts.get(0).RecordTypeId);

		Test.startTest();
		cont.moveGroupUp();
		cont.moveGroupDown();
		cont.moveGroupUp();
		Test.stopTest();

		PR_Team_Employee__c requery = [Select Id, Group_Sequence__c from PR_Team_Employee__c where Id =: testParts.get(0).Id];
		PR_Team_Employee__c requery2 = [Select Id, Group_Sequence__c from PR_Team_Employee__c where Id =: testParts2.get(0).Id];
		System.assertEquals(0,requery.Group_Sequence__c);
		System.assertEquals(1,requery2.Group_Sequence__c);
	}

	private static testmethod void testmoveGroupNonAECOMProjects() {
		//Initial group, we will not be moving this one
		rsTestUtil.createTestProjectPartForUserId(UserInfo.getUserId(), rsPRTeamEmployee.RT_NONAECOMPROJECT, 2);
		List<PR_Team_Employee__c> testParts2 = [Select Id, RecordTypeId, Project_Group_Editable__c from PR_Team_Employee__c];
		Set<Id> usedIds = new Set<Id>();
		for(PR_Team_Employee__c part : testParts2) {
			part.Project_Group_Editable__c = 'test2';
			part.Group_Sequence__c = 0;
			usedIds.add(part.Id);
		}
		//We'll add the group that we'll move
		rsTestUtil.createTestProjectPartForUserId(UserInfo.getUserId(), rsPRTeamEmployee.RT_NONAECOMPROJECT, 2);
		List<PR_Team_Employee__c> testParts = [Select Id, RecordTypeId, Project_Group_Editable__c from PR_Team_Employee__c where Id NOT IN: usedIds];
		for(PR_Team_Employee__c part : testParts) {
			part.Group_Sequence__c = 1;
		}
		update testParts2;
		update testParts;

		rsProjectController cont = new rsProjectController();
		cont.profile = rsProfile.find.byUserId(UserInfo.getUserId());
		ApexPages.currentPage().getParameters().put('projectGroup','');
		ApexPages.currentPage().getParameters().put('recordType',testParts.get(0).RecordTypeId);

		Test.startTest();
		cont.moveGroupUp();
		cont.moveGroupDown();
		cont.moveGroupUp();
		Test.stopTest();

		PR_Team_Employee__c requery = [Select Id, Group_Sequence__c from PR_Team_Employee__c where Id =: testParts.get(0).Id];
		PR_Team_Employee__c requery2 = [Select Id, Group_Sequence__c from PR_Team_Employee__c where Id =: testParts2.get(0).Id];
		System.assertEquals(0,requery.Group_Sequence__c);
		System.assertEquals(1,requery2.Group_Sequence__c);
	}

	private static testmethod void testMoveProjectAECOMProjects() {
		//Initial group, we will not be moving this one
		rsTestUtil.createTestProjectPartForUserId(UserInfo.getUserId(), rsPRTeamEmployee.RT_AECOMPROJECT, 2);
		List<PR_Team_Employee__c> testParts = [Select Id, RecordTypeId, Project_Group_Editable__c from PR_Team_Employee__c];
 		Id projectId;
 		Integer i = 0;
		for(PR_Team_Employee__c part : testParts) {
			part.Project_Group_Editable__c = '';
			part.Group_Sequence__c = 0;
			part.Project_Sequence__c = i;
			if(i > 0) projectId = part.Id;
			i++;
		}
		update testParts;

		rsProjectController cont = new rsProjectController();
		cont.profile = rsProfile.find.byUserId(UserInfo.getUserId());
		ApexPages.currentPage().getParameters().put('projectGroup','');
		ApexPages.currentPage().getParameters().put('recordType',testParts.get(0).RecordTypeId);
		ApexPages.currentPage().getParameters().put('projectId',projectId);

		Test.startTest();
		cont.moveProjectUp();
		cont.moveProjectDown();
		cont.moveProjectUp();
		Test.stopTest();

		PR_Team_Employee__c requery = [Select Id, Project_Sequence__c from PR_Team_Employee__c where Id =: testParts.get(0).Id];
		PR_Team_Employee__c requery2 = [Select Id, Project_Sequence__c from PR_Team_Employee__c where Id =: testParts.get(1).Id];
		System.assertEquals(1,requery.Project_Sequence__c);
		System.assertEquals(0,requery2.Project_Sequence__c);
	}

	private static testmethod void testMoveProjectNonAECOMProjects() {
		//Initial group, we will not be moving this one
		rsTestUtil.createTestProjectPartForUserId(UserInfo.getUserId(), rsPRTeamEmployee.RT_NONAECOMPROJECT, 2);
		List<PR_Team_Employee__c> testParts = [Select Id, RecordTypeId, Project_Group_Editable__c from PR_Team_Employee__c];
 		Id projectId;
 		Integer i = 0;
		for(PR_Team_Employee__c part : testParts) {
			part.Project_Group_Editable__c = '';
			part.Group_Sequence__c = 0;
			part.Project_Sequence__c = i;
			if(i > 0) projectId = part.Id;
			i++;
		}
		update testParts;

		rsProjectController cont = new rsProjectController();
		cont.profile = rsProfile.find.byUserId(UserInfo.getUserId());
		ApexPages.currentPage().getParameters().put('projectGroup','');
		ApexPages.currentPage().getParameters().put('recordType',testParts.get(0).RecordTypeId);
		ApexPages.currentPage().getParameters().put('projectId',projectId);

		Test.startTest();
		cont.moveProjectUp();
		cont.moveProjectDown();
		cont.moveProjectUp();
		Test.stopTest();

		PR_Team_Employee__c requery = [Select Id, Project_Sequence__c from PR_Team_Employee__c where Id =: testParts.get(0).Id];
		PR_Team_Employee__c requery2 = [Select Id, Project_Sequence__c from PR_Team_Employee__c where Id =: testParts.get(1).Id];
		System.assertEquals(1,requery.Project_Sequence__c);
		System.assertEquals(0,requery2.Project_Sequence__c);
	}

	private static testmethod void testNewNonAECOMPart() {
		rsProjectController cont = new rsProjectController();
		cont.profile = rsProfile.find.byUserId(UserInfo.getUserId());

		Test.startTest();
		cont.newNonAECOMPart();
		Test.stopTest();

		System.assertEquals(true, cont.getIsNonAECOMProject());
		System.assertEquals(false, cont.getIsNewAECOMProject());
		System.assertEquals(false, cont.getIsExistingAECOMProject());

	}

}