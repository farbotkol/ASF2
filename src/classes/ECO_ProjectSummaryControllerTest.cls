@isTest
private class ECO_ProjectSummaryControllerTest {

	private static final Integer numTestProjectTasks = 21;	
	private static final Integer numTeamMembers = 1;

	private static testMethod void testProjectNumberRequest(){ 
		ECO_Utils_Testing.createTestDataForProjectNumberRequest();


		pse__Proj__c testProject = [SELECT Id, Name FROM pse__Proj__c LIMIT 1];
		testProject.ProjectLongName__c = null;
		update testProject;

		PageReference pageRef = new PageReference('/apex/ECO_ProjectSummary');
		pageRef.getParameters().put('projectId', testProject.Id);
		pageRef.getParameters().put('isProjectNumber', '1');
		test.setCurrentPage(pageRef);

		test.startTest();

		ECO_ProjectSummaryController con = new ECO_ProjectSummaryController();

		system.assertNotEquals(null, con.projectId);
		system.assertEquals(true, con.isProjectNumber);

		//verify lastSync date flag
		system.assertEquals(false, con.allowRequestSubmit);

		//test validation for complete data		
		con.project.ProjectLongName__c = 'long name here';
		PageReference saveUrl = con.updateProject();

		test.setCurrentPage(saveUrl);
		ECO_ProjectSummaryController con2 = new ECO_ProjectSummaryController();
		system.assertNotEquals(null, con2.projectId);
		system.assertEquals(true, con2.isProjectNumber);
		system.assertEquals(true, con2.allowRequestSubmit);

		//test sync - actual http request not sent
		con2.initiateOracleProjectSyncRequest();

		

		List<IntegrationMessageQueue__c> msgQueues = [SELECT Id, RecordId__c, Status__c, JobName__c
														FROM IntegrationMessageQueue__c
														WHERE RecordId__c = : testProject.Id];
		system.assertEquals(1, msgQueues.size());
		IntegrationMessageQueue__c msgQueue = msgQueues.get(0);
		
		system.assertEquals('Project Number', msgQueue.JobName__c);
		system.assertEquals('Initiated', msgQueue.Status__c);


		con2.syncRequest_Step1_start();
		con2.syncRequest_Step1_complete();
		con2.sendProjectNumberRequest_start();
		con2.sendProjectNumberRequest_complete();
		con2.sendProjectNumberRequest_Finish();


		//test get sync history of successfully processed request
		msgQueue.Status__c = ECO_Service_ProjectSync.STATUS_SUCCESS;
		msgQueue.SuccessMessage__c = '60340403|1039554';
		update msgQueue;

		con2.generateSyncHistory();

		system.assertEquals(1, con2.numSuccessfulSyncs);

		con2.checkIfSyncHasBeenProcessed();

		//verfiy that you can't send the request again once the project has been assigned an oracle project number
		test.setCurrentPage(pageRef);
		ECO_ProjectSummaryController con3 = new ECO_ProjectSummaryController();
		system.assertEquals(false, con3.allowRequestSubmit);

		test.stopTest();

	}

	private static testMethod void testProjectSync(){

		ECO_Utils_Testing.createTestDataForProjectSync(numTestProjectTasks, numTeamMembers);

		//update the data so it will fail validation
		pse__Proj__c testProject = [SELECT Id, Name FROM pse__Proj__c LIMIT 1];
		testProject.ProjectLongName__c = null;
		testProject.OracleProjectId__c = '123456';
		testProject.OracleProjectnumber__c = '654321';
		update testProject;

		List<pse__Project_Task__c> tasks = [SELECT Id, Name, pse__Description__c FROM pse__Project_Task__c WHERE pse__Project__c = :testProject.Id];
		for(pse__Project_Task__c task : tasks){
			task.pse__Description__c = null;
		}
		update tasks;

		List<ProjectTeamMember__c> teamMembers = [SELECT Id, StartDate__c FROM ProjectTeamMember__c WHERE Project__c = :testProject.Id];
		for(ProjectTeamMember__c teamMember : teamMembers){
			teamMember.StartDate__c = null;
		}
		update teamMembers;

		List<Project_Site__c> sites = [SELECT Id, BillingContactID__c FROM Project_Site__c WHERE Project__c = :testProject.Id];
		for(Project_Site__c site : sites){
			site.BillingContactID__c = null;
		}
		update sites;

		PageReference pageRef = new PageReference('/apex/ECO_ProjectSummary');
		pageRef.getParameters().put('projectId', testProject.Id);
		pageRef.getParameters().put('isProjectNumber', '0');
		test.setCurrentPage(pageRef);

		test.startTest();

		ECO_ProjectSummaryController con = new ECO_ProjectSummaryController();

		system.assertNotEquals(null, con.projectId);
		system.assertEquals(false, con.isProjectNumber);

		//verify lastSync date flag
		DateTime expectedDateFilter = DateTime.newInstance(1900, 1, 1);
		system.assertEquals(expectedDateFilter, con.lastSync);

		system.assertEquals(false, con.allowRequestSubmit);

		system.debug('projectMsg=' + con.projectMsg);	
		system.assertNotEquals(true, String.isEmpty(con.projectMsg));

		system.debug('keyMemberMsg=' + con.keyMemberMsg);		
		system.assertNotEquals(true, String.isEmpty(con.keyMemberMsg));

		system.debug('customersMsg=' + con.customersMsg);
		system.assertNotEquals(true, String.isEmpty(con.customersMsg));

		system.debug('taskMsg=' + con.taskMsg);
		system.assertNotEquals(true, String.isEmpty(con.taskMsg));

		for(pse__Project_Task__c task : tasks){
			task.pse__Description__c = task.Name + 'longname';
		}
		update tasks;
		
		for(ProjectTeamMember__c teamMember : teamMembers){
			teamMember.StartDate__c = Date.today();
		}
		update teamMembers;

		for(Project_Site__c site : sites){
			site.BillingContactID__c = '123456';
		}
		update sites;

		//test validation for complete data		
		con.project.ProjectLongName__c = 'long name here';

		//create pm		
		Contact pm = new Contact();
		pm.Email = 'pm2@test2.ca';
		pm.FirstName = 'test';
		pm.LastName =  'pm2';
		pm.Phone = '55555555555';
		//pm.RecordTypeId = recordTypeId;
		insert pm;	

		con.project.pse__Project_Manager__c = pm.Id;

		//con.project.OracleProjectnumber__c = '333333';
		PageReference saveUrl = con.updateProject();

		test.setCurrentPage(saveUrl);


		ECO_ProjectSummaryController con2 = new ECO_ProjectSummaryController();

		system.debug('projectMsg=' + con2.projectMsg);
		system.assertEquals(true, String.isEmpty(con2.projectMsg));

		system.debug('keyMemberMsg=' + con2.keyMemberMsg);
		system.assertEquals(true, String.isEmpty(con2.keyMemberMsg));

		system.debug('customersMsg=' + con2.customersMsg);
		system.assertEquals(true, String.isEmpty(con2.customersMsg));

		system.debug('taskMsg=' + con2.taskMsg);
		system.assertEquals(true, String.isEmpty(con2.taskMsg));

		system.assertNotEquals(null, con2.projectId);
		system.assertEquals(false, con2.isProjectNumber);
		system.assertEquals(true, con2.allowRequestSubmit);

		con2.syncRequest_Step1_start();
		con2.syncRequest_Step1_complete();
		con2.syncRequest_Step2_start();
		con2.syncRequest_Step2_complete();
		con2.syncRequest_Step3_start();
		con2.syncRequest_Step3_complete();
		con2.syncRequest_Step4_start();
		con2.syncRequest_Step4_complete();
		con2.syncRequest_Step5_start();
		con2.syncRequest_Step5_complete();
		con2.syncRequest_Step6_start();
		con2.syncRequest_Step6_complete();
        con2.syncRequest_Step7_start();
        con2.syncRequest_Step7_complete();
        con2.syncRequest_Step8_start();
        con2.syncRequest_Step8_complete();
        system.assertEquals(false, con2.syncErrorOccurred);

        system.assertEquals(17, con2.stepMsgs.size());
		

		List<IntegrationMessageQueue__c> msgQueues = [SELECT Id, RecordId__c, Status__c, JobName__c
														FROM IntegrationMessageQueue__c
														WHERE RecordId__c = : testProject.Id];
		system.assertEquals(1, msgQueues.size());
		IntegrationMessageQueue__c msgQueue = msgQueues.get(0);
		
		system.assertEquals('Project Sync', msgQueue.JobName__c);
		system.assertEquals('Initiated', msgQueue.Status__c);

		//test successful project sync - sync status should get sent to 'S' on project and related items
		msgQueue.Status__c = ECO_Service_ProjectSync.STATUS_SUCCESS;
		update msgQueue;

		con2.generateSyncHistory();

		system.assertEquals(1, con2.numSuccessfulSyncs);
		system.assertEquals(0, con2.numFailedAttemptedSyncs);

		testProject = [SELECT Id, OracleSyncStatus__c FROM pse__Proj__c WHERE Id = :testProject.Id];
		system.assertEquals('S', testProject.OracleSyncStatus__c);

		teamMembers = [SELECT Id, OracleSyncStatus__c FROM ProjectTeamMember__c WHERE Project__c = :testProject.Id];
		for(ProjectTeamMember__c teamMember : teamMembers){
			system.assertEquals('S', teamMember.OracleSyncStatus__c);		
		}

		sites = [SELECT Id, OracleSyncStatus__c FROM Project_Site__c WHERE Project__c = :testProject.Id];
		for(Project_Site__c site : sites){
			system.assertEquals('S', site.OracleSyncStatus__c);	
		}

		tasks = [SELECT Id, OracleSyncStatus__c FROM pse__Project_Task__c WHERE pse__Project__c = :testProject.Id];
		for(pse__Project_Task__c task :  tasks){
			system.assertEquals('S', task.OracleSyncStatus__c);			
		}

		


		test.stopTest();
		
	}
	
	private static testMethod void testProjectSyncWithErrors(){

		ECO_Utils_Testing.createTestDataForProjectSync(numTestProjectTasks, numTeamMembers);

		//update the data so it will fail validation
		pse__Proj__c testProject = [SELECT Id, Name FROM pse__Proj__c LIMIT 1];

		PageReference pageRef = new PageReference('/apex/ECO_ProjectSummary');
		pageRef.getParameters().put('projectId', testProject.Id);
		pageRef.getParameters().put('isProjectNumber', '0');
		test.setCurrentPage(pageRef);


		test.startTest();

		ECO_ProjectSummaryController con = new ECO_ProjectSummaryController();

		delete testProject;

		con.syncRequest_Step1_start();
		con.syncRequest_Step1_complete();
		con.syncRequest_Step2_start();
		con.syncRequest_Step2_complete();
		con.syncRequest_Step3_start();
		con.syncRequest_Step3_complete();
		con.syncRequest_Step4_start();
		con.syncRequest_Step4_complete();
		con.syncRequest_Step5_start();
		con.syncRequest_Step5_complete();
		con.syncRequest_Step6_start();
		con.syncRequest_Step6_complete();
        con.syncRequest_Step7_start();
        con.syncRequest_Step7_complete();
        con.syncRequest_Step8_start();
        con.syncRequest_Step8_complete();
        system.assertEquals(true, con.syncErrorOccurred);
	}


}