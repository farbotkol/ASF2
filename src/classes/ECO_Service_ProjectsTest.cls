@isTest
private class ECO_Service_ProjectsTest {

	private static final Integer numTestProjectTasks = 10;	
	private static final Integer numTeamMembers = 1;

	private static testMethod void testProjectNumberMessageWrapperCreation(){
		//create test data
		ECO_Utils_Testing.createTestDataForProjectNumberRequest();
		pse__Proj__c testProject = [SELECT Id, Name FROM pse__Proj__c LIMIT 1];

		ECO_Service_ProjectSync.ProjectMessageWrapper  wrapper = ECO_Service_ProjectSync.createProjectMessageWrapper(testProject.Id, true);

		system.assertEquals(testProject.Name, wrapper.PROJECT_HEADER.PROJECT_NAME);			

	}


	private static testMethod void testProjectSyncMessageWrapperCreation(){		

		//create test data
		ECO_Utils_Testing.createTestDataForProjectSync(numTestProjectTasks, numTeamMembers);
		Id testProjectId = [SELECT Id FROM pse__Proj__c LIMIT 1].Id;

		test.StartTest();

		ECO_Service_ProjectSync.ProjectMessageWrapper  wrapper = ECO_Service_ProjectSync.createProjectMessageWrapper(testProjectId, false);

		system.assertEquals(numTeamMembers, wrapper.KEYMEMBERS_COLLECTION.size());
		system.assertEquals(false, wrapper.CLASSIFICATION_COLLECTION.isEmpty());	//note all checkbox datatype classification fields get sent to service as they can never be null
		system.assertEquals(1, wrapper.CUSTOMERS_COLLECTION.size());
		system.assertEquals(numTestProjectTasks, wrapper.WBS_COLLECTION.size());
		
		test.StopTest();
	}

/*
	private static testMethod void testProjectSyncMessageWrapperCreationWithValidation(){		

		//create test data
		createTestDataForProjectSync();
		Id testProjectId = [SELECT Id FROM pse__Proj__c LIMIT 1].Id;

		test.StartTest();
		
		String errMsg = '';
		try{
			ECO_Service_ProjectSync.ProjectMessageWrapper  wrapper = ECO_Service_ProjectSync.createProjectMessageWrapper(testProjectId, false, true);
		}catch(ECO_Service_ProjectSync.EcoServiceException e){
			errMsg = e.getMessage();
		}
	
		test.StopTest();

		system.assertEquals(false, String.isEmpty(errMsg));
	}
*/

	private static testMethod void testProjectSyncMessageWrapperCreationWithError(){
		//create test data
		ECO_Utils_Testing.createTestDataForProjectSync(numTestProjectTasks, numTeamMembers);
		pse__Proj__c testProject = [SELECT Id FROM pse__Proj__c LIMIT 1];

		test.StartTest();
		Id messageQueueId = ECO_Service_ProjectSync.createMessageQueueForRequest(testProject.Id, 'Project Sync');

		//delete project, should generate error when attempting to retrieve project fields
		Id testProjectId = testProject.Id;
		delete testProject;
		String expectedErrMsg = 'Project Not Found';
		try{
			String response = ECO_Service_ProjectSync.SendProjectData(testProjectId, messageQueueId);
		}catch(Exception e){
			
			system.assertEquals(expectedErrMsg, e.getMessage());
		}
		
		

		List<IntegrationMessageQueue__c> msgQueues = [SELECT Id, Status__c, ErrorMessage__c 
														FROM IntegrationMessageQueue__c
														WHERE Id = :messageQueueId];

		system.assertEquals('Initiated', msgQueues.get(0).Status__c);

	}

	private static testMethod void testProjectSyncCallout(){
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		//mock.setStaticResource('ECO_ProjectEnrichMockResponseJSON');
		mock.setStaticResource('ECO_ProjectEnrichMockResponseXML');

		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, mock);

		String url = 'https:test.com';
		String jsonRequest = '{"JOB_ID":"12345678"}';

		Test.startTest();
		String serviceResponse = ECO_Service_ProjectSync.sendRequest(url, jsonRequest);

		Test.stopTest();

		system.debug('test response = ' + serviceResponse);
		system.assertEquals(true, serviceResponse.containsIgnoreCase('The request has successfully been submitted'));

	}

	private static testMethod void testProjectNumberJsonCreation(){
		//create test data		
		ECO_Utils_Testing.createTestDataForProjectNumberRequest();
		pse__Proj__c testProject = [SELECT Id, Name FROM pse__Proj__c LIMIT 1];

		test.StartTest();

		//test message queue insert and fetch
		Id messageQueueId = ECO_Service_ProjectSync.createMessageQueueForRequest(testProject.Id, 'Project Sync');

		system.assertNotEquals(null, messageQueueId);

		IntegrationMessageQueue__c msgQueue = ECO_Service_ProjectSync.getMessageQueue(messageQueueId);
		system.assertNotEquals(null, msgQueue);
		system.assertEquals(messageQueueId, msgQueue.Id);

		String emptyJSON = ECO_Service_ProjectSync.SendProjectNumberData();
		ECO_Service_ProjectSync.ProjectMessageWrapper emptyWrapper = (ECO_Service_ProjectSync.ProjectMessageWrapper)JSON.deserialize(emptyJSON, ECO_Service_ProjectSync.ProjectMessageWrapper.class);
		system.assertNotEquals(testProject.Name, emptyWrapper.PROJECT_HEADER.PROJECT_NAME);

		String requestJSON = ECO_Service_ProjectSync.SendProjectNumberData(testProject.Id, messageQueueId);

		test.StopTest();

		//deserialize json to validate
		ECO_Service_ProjectSync.ProjectMessageWrapper wrapper = (ECO_Service_ProjectSync.ProjectMessageWrapper)JSON.deserialize(requestJSON, ECO_Service_ProjectSync.ProjectMessageWrapper.class);

		system.assertEquals(false, String.isEmpty(requestJSON));
		system.assertEquals(wrapper.PROJECT_HEADER.PROJECT_NAME, testProject.Name);

	}

	private static testMethod void testProjectSyncJsonCreation(){
		//create test data		
		ECO_Utils_Testing.createTestDataForProjectSync(numTestProjectTasks, numTeamMembers);
		pse__Proj__c testProject = [SELECT Id, Name FROM pse__Proj__c LIMIT 1];

		test.StartTest();
		Id messageQueueId = ECO_Service_ProjectSync.createMessageQueueForRequest(testProject.Id, 'Project Sync');

		String emptyJSON = ECO_Service_ProjectSync.SendProjectData();
		ECO_Service_ProjectSync.ProjectMessageWrapper emptyWrapper = (ECO_Service_ProjectSync.ProjectMessageWrapper)JSON.deserialize(emptyJSON, ECO_Service_ProjectSync.ProjectMessageWrapper.class);
		system.assertNotEquals(testProject.Name, emptyWrapper.PROJECT_HEADER.PROJECT_NAME);


		String requestJSON = ECO_Service_ProjectSync.SendProjectData(testProject.Id, messageQueueId);

		test.StopTest();

		//deserialize json to validate
		ECO_Service_ProjectSync.ProjectMessageWrapper wrapper = (ECO_Service_ProjectSync.ProjectMessageWrapper)JSON.deserialize(requestJSON, ECO_Service_ProjectSync.ProjectMessageWrapper.class);

		system.assertEquals(false, String.isEmpty(requestJSON));
		system.assertEquals(wrapper.PROJECT_HEADER.PROJECT_NAME, testProject.Name);
		system.assertEquals(numTeamMembers, wrapper.KEYMEMBERS_COLLECTION.size());
		system.assertEquals(false, wrapper.CLASSIFICATION_COLLECTION.isEmpty());	//note all checkbox datatype classification fields get sent to service as they can never be null
		system.assertEquals(1, wrapper.CUSTOMERS_COLLECTION.size());
		system.assertEquals(numTestProjectTasks, wrapper.WBS_COLLECTION.size());

	}




}