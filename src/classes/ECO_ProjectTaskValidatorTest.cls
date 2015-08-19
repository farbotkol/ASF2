@isTest
private class ECO_ProjectTaskValidatorTest {

	
	private static testMethod void testTaskValidation_TopLevelMustBeFinancial(){		

		pse__Project_Task__c task = new pse__Project_Task__c();
		task.Name = 'top task';
		task.pse__Project__c = createTestProject();
		task.pse__Start_Date_Time__c = DateTime.now();
		task.pse__End_Date_Time__c = DateTime.now().addDays(1);
		task.pse__Status__c = 'Draft';
		task.FinancialTask__c = false;

		enableProjecTaskTrigger();

		String expectedErrMsg = String.valueOf(System.Label.ECO_OracleTaskError_TopLevelFinancial).replace('##TASKNAME##', task.Name); 
      	String actualErrMsg = '';
      	insert task;

      	//confirm the task with no parent gets defaulted to financial
      	task = [SELECT Id, FinancialTask__c FROM pse__Project_Task__c WHERE Id = :task.Id];      	
      	system.assertEquals(true, task.FinancialTask__c);

		try{
			task.FinancialTask__c = false;
			update task;
		}catch(Exception e){
			actualErrMsg = e.getMessage();
		}
		system.assertEquals(true, actualErrMsg.contains(expectedErrMsg));
	}

	private static testMethod void testTaskValidation_IfChildrenAreFinancialMustBeFinancial(){		

		pse__Project_Task__c parenttask = new pse__Project_Task__c();
		parenttask.Name = 'top task';
		parenttask.pse__Project__c = createTestProject();
		parenttask.pse__Start_Date_Time__c = DateTime.now();
		parenttask.pse__End_Date_Time__c = DateTime.now().addDays(1);
		parenttask.pse__Status__c = 'Draft';
		parenttask.FinancialTask__c = true;
		insert parenttask;

		pse__Project_Task__c childTask1 = new pse__Project_Task__c();
		childTask1.Name = 'child1';
		childTask1.pse__Parent_Task__c = parenttask.Id;
		childTask1.pse__Start_Date_Time__c = DateTime.now();
		childTask1.pse__End_Date_Time__c = DateTime.now().addDays(1);
		childTask1.pse__Status__c = 'Draft';
		childTask1.FinancialTask__c = true;
		insert childTask1;

		pse__Project_Task__c childTask2 = new pse__Project_Task__c();
		childTask2.Name = 'child2';
		childTask2.pse__Parent_Task__c = childTask1.Id;
		childTask2.pse__Start_Date_Time__c = DateTime.now();
		childTask2.pse__End_Date_Time__c = DateTime.now().addDays(1);
		childTask2.pse__Status__c = 'Draft';
		childTask2.FinancialTask__c = true;
		insert childTask2;

		enableProjecTaskTrigger();

		String expectedErrMsg = String.valueOf(System.Label.ECO_OracleTaskError_NotFinancialWithChildren).replace('##TASKNAME##', childTask1.Name); 
      	String actualErrMsg = '';

		try{
			childTask1.FinancialTask__c = false;
			update childTask1;
		}catch(Exception e){
			actualErrMsg = e.getMessage();
		}
		system.assertEquals(true, actualErrMsg.contains(expectedErrMsg));
	}

	private static testMethod void testTaskValidation_ChargeableOnlyAtLowestLevel(){		

		pse__Project_Task__c parenttask = new pse__Project_Task__c();
		parenttask.Name = 'top task';
		parenttask.pse__Project__c = createTestProject();
		parenttask.pse__Start_Date_Time__c = DateTime.now();
		parenttask.pse__End_Date_Time__c = DateTime.now().addDays(1);
		parenttask.pse__Status__c = 'Draft';
		parenttask.FinancialTask__c = true;
		insert parenttask;

		pse__Project_Task__c childTask1 = new pse__Project_Task__c();
		childTask1.Name = 'child1';
		childTask1.pse__Parent_Task__c = parenttask.Id;
		childTask1.pse__Start_Date_Time__c = DateTime.now();
		childTask1.pse__End_Date_Time__c = DateTime.now().addDays(1);
		childTask1.pse__Status__c = 'Draft';
		childTask1.FinancialTask__c = true;
		insert childTask1;

		pse__Project_Task__c childTask2 = new pse__Project_Task__c();
		childTask2.Name = 'child2';
		childTask2.pse__Parent_Task__c = childTask1.Id;
		childTask2.pse__Start_Date_Time__c = DateTime.now();
		childTask2.pse__End_Date_Time__c = DateTime.now().addDays(1);
		childTask2.pse__Status__c = 'Draft';
		childTask2.FinancialTask__c = true;
		insert childTask2;

		enableProjecTaskTrigger();

		String expectedErrMsg = String.valueOf(System.Label.ECO_OracleTaskError_ChargeableAtLowestLevel).replace('##TASKNAME##', childTask1.Name); 
      	String actualErrMsg = '';
      	
		try{
			childTask1.IsChargeable__c = true;
			update childTask1;
		}catch(Exception e){
			actualErrMsg = e.getMessage();
		}
		system.assertEquals(true, actualErrMsg.contains(expectedErrMsg));
	}

	private static testMethod void testTaskValidation_PeersMustHaveSameFinancialSetting(){		

		pse__Project_Task__c parenttask = new pse__Project_Task__c();
		parenttask.Name = 'top task';
		parenttask.pse__Project__c = createTestProject();
		parenttask.pse__Start_Date_Time__c = DateTime.now();
		parenttask.pse__End_Date_Time__c = DateTime.now().addDays(1);
		parenttask.pse__Status__c = 'Draft';
		parenttask.FinancialTask__c = true;
		insert parenttask;

		pse__Project_Task__c childTask1 = new pse__Project_Task__c();
		childTask1.Name = 'child1';
		childTask1.pse__Parent_Task__c = parenttask.Id;
		childTask1.pse__Start_Date_Time__c = DateTime.now();
		childTask1.pse__End_Date_Time__c = DateTime.now().addDays(1);
		childTask1.pse__Status__c = 'Draft';
		childTask1.FinancialTask__c = true;
		insert childTask1;

		pse__Project_Task__c childTask2 = new pse__Project_Task__c();
		childTask2.Name = 'child2';
		childTask2.pse__Parent_Task__c = parenttask.Id;
		childTask2.pse__Start_Date_Time__c = DateTime.now();
		childTask2.pse__End_Date_Time__c = DateTime.now().addDays(1);
		childTask2.pse__Status__c = 'Draft';
		childTask2.FinancialTask__c = true;
		insert childTask2;

		enableProjecTaskTrigger();

		String expectedErrMsg = String.valueOf(System.Label.ECO_OracleTaskError_PeerFinancial).replace('##TASKNAME##', childTask1.Name); 
      	String actualErrMsg = '';
      	
		try{
			childTask1.FinancialTask__c = false;
			update childTask1;
		}catch(Exception e){
			actualErrMsg = e.getMessage();
		}
		system.assertEquals(true, actualErrMsg.contains(expectedErrMsg));
	}

	private static testMethod void testTaskValidation_ChargeableMustBeFinancial(){		

		pse__Project_Task__c parenttask = new pse__Project_Task__c();
		parenttask.Name = 'top task';
		parenttask.pse__Project__c = createTestProject();
		parenttask.pse__Start_Date_Time__c = DateTime.now();
		parenttask.pse__End_Date_Time__c = DateTime.now().addDays(1);
		parenttask.pse__Status__c = 'Draft';
		parenttask.FinancialTask__c = true;
		insert parenttask;

		pse__Project_Task__c childTask1 = new pse__Project_Task__c();
		childTask1.Name = 'child1';
		childTask1.pse__Parent_Task__c = parenttask.Id;
		childTask1.pse__Start_Date_Time__c = DateTime.now();
		childTask1.pse__End_Date_Time__c = DateTime.now().addDays(1);
		childTask1.pse__Status__c = 'Draft';
		childTask1.FinancialTask__c = false;
		insert childTask1;

		enableProjecTaskTrigger();

		String expectedErrMsg = String.valueOf(System.Label.ECO_OracleTaskError_FinancialNonChargeable).replace('##TASKNAME##', childTask1.Name); 
      	String actualErrMsg = '';

		try{
			childTask1.IsChargeable__c = true;
			update childTask1;
		}catch(Exception e){
			actualErrMsg = e.getMessage();
		}
		system.assertEquals(true, actualErrMsg.contains(expectedErrMsg));
	}

	private static testMethod void testTaskValidation_NoDeleteOfSynced(){		

		pse__Project_Task__c task = new pse__Project_Task__c();
		task.Name = 'top task';
		task.pse__Project__c = createTestProject();
		task.pse__Start_Date_Time__c = DateTime.now();
		task.pse__End_Date_Time__c = DateTime.now().addDays(1);
		task.pse__Status__c = 'Draft';
		task.FinancialTask__c = true;
		task.OracleSyncStatus__c = 'S';
		insert task;

		enableProjecTaskTrigger();

		String expectedErrMsg = String.valueOf(System.Label.ECO_OracleTaskError_Synced).replace('##TASKNAME##', task.Name); 
      	String actualErrMsg = '';

		try{
			delete task;
		}catch(Exception e){
			actualErrMsg = e.getMessage();
		}
		system.assertEquals(true, actualErrMsg.contains(expectedErrMsg));
	}

	private static Id createTestProject(){
		Account testAccount = new Account();
		testAccount.Name = 'test Account';
		insert testAccount;

		//create create source project 
		pse__Proj__c testProject = new pse__Proj__c();
		testProject.Name = 'test project 1';
		testProject.pse__Account__c = testAccount.Id;
		testProject.pse__Project_Type__c = 'Customer Project';
		testProject.pse__Billing_Type__c = 'Fixed Price';
		testProject.CurrencyIsoCode = 'USD';
		testProject.pse__Is_Active__c = true;	
		insert testProject;

		return testProject.Id;
	}

	private static void enableProjecTaskTrigger(){
		ECO_TriggerSettings__c triggerSetting = new ECO_TriggerSettings__c();
		triggerSetting.Name = 'ECO_ProjectTask_AllEvents';
		triggerSetting.IsEnabled__c = true;
        insert triggerSetting;
	}

	private static testMethod void testTaskSync(){		

		pse__Project_Task__c parenttask = new pse__Project_Task__c();
		parenttask.Name = 'top task';
		parenttask.pse__Project__c = createTestProject();
		parenttask.pse__Start_Date_Time__c = DateTime.now();
		parenttask.pse__End_Date_Time__c = DateTime.now().addDays(1);
		parenttask.pse__Status__c = 'Draft';
		parenttask.FinancialTask__c = true;
		insert parenttask;

		pse__Project_Task__c childTask1 = new pse__Project_Task__c();
		childTask1.Name = 'child1';
		childTask1.pse__Parent_Task__c = parenttask.Id;
		childTask1.pse__Start_Date_Time__c = DateTime.now();
		childTask1.pse__End_Date_Time__c = DateTime.now().addDays(1);
		childTask1.pse__Status__c = 'Draft';
		childTask1.FinancialTask__c = true;
		childTask1.IsChargeable__c = true;
		insert childTask1;

		childTask1.OracleSyncStatus__c = 'S';
		update childTask1;

		pse__Project_Task__c childTask2 = new pse__Project_Task__c();
		childTask2.Name = 'child2';
		childTask2.pse__Parent_Task__c = parenttask.Id;
		childTask2.pse__Start_Date_Time__c = DateTime.now();
		childTask2.pse__End_Date_Time__c = DateTime.now().addDays(1);
		childTask2.pse__Status__c = 'Draft';
		childTask2.FinancialTask__c = true;
		childTask2.IsChargeable__c = false;
		insert childTask2;

		childTask2.OracleSyncStatus__c = 'S';
		update childTask2;

		enableProjecTaskTrigger();

		test.StartTest();

		childTask1.IsChargeable__c = false;
		update childTask1;

		childTask2.IsChargeable__c = true;
		update childTask2;

		test.StopTest();

		IntegrationMessageQueue__c task1MsgQueue = [SELECT Id, JobName__c FROM IntegrationMessageQueue__c WHERE RecordId__c = :childTask1.Id];
		IntegrationMessageQueue__c task2MsgQueue = [SELECT Id, JobName__c FROM IntegrationMessageQueue__c WHERE RecordId__c = :childTask2.Id];


		system.assertEquals(ECO_Service_ProjectSync.JOBNAME_TASK_SYNC_LATER, task1MsgQueue.JobName__c);
		system.assertEquals(ECO_Service_ProjectSync.JOBNAME_TASK_SYNC_NOW, task2MsgQueue.JobName__c);
	}


	private static testMethod void TestTaskSyncSchedulable() {

	   // CRON expression: midnight on March 15.
	   // Because this is a test, job executes
	   // immediately after Test.stopTest().
	   	String CRON_EXP = '0 0 0 15 3 ? 2022';

		enableProjecTaskTrigger();
		
  		pse__Project_Task__c parenttask = new pse__Project_Task__c();
		parenttask.Name = 'top task';
		parenttask.pse__Project__c = createTestProject();
		parenttask.pse__Start_Date_Time__c = DateTime.now();
		parenttask.pse__End_Date_Time__c = DateTime.now().addDays(1);
		parenttask.pse__Status__c = 'Draft';
		parenttask.FinancialTask__c = true;
		insert parenttask;

		pse__Project_Task__c childTask1 = new pse__Project_Task__c();
		childTask1.Name = 'child1';
		childTask1.pse__Parent_Task__c = parenttask.Id;
		childTask1.pse__Start_Date_Time__c = DateTime.now();
		childTask1.pse__End_Date_Time__c = DateTime.now().addDays(1);
		childTask1.pse__Status__c = 'Draft';
		childTask1.FinancialTask__c = true;
		childTask1.IsChargeable__c = true;

		insert childTask1;


		childTask1.OracleSyncStatus__c = 'S';
		update childTask1;

		

      	Test.startTest();


      	childTask1.IsChargeable__c = false;
		update childTask1;

      	// Schedule the test job
      	String jobId = System.schedule('ECO_TaskSyncSchedulable',
      	                     			CRON_EXP, 
                        				new ECO_TaskSyncSchedulable());
         
      	// Get the information from the CronTrigger API object
      	CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

      	// Verify the expressions are the same
      	System.assertEquals(CRON_EXP, ct.CronExpression);

      	// Verify the job has not run
     	System.assertEquals(0, ct.TimesTriggered);

	    // Verify the next time the job will run
	    System.assertEquals('2022-03-15 00:00:00', String.valueOf(ct.NextFireTime));

	    // Verify the scheduled job hasn't run yet.
	    IntegrationMessageQueue__c task1MsgQueue = [SELECT Id, JobName__c, Status__c FROM IntegrationMessageQueue__c WHERE RecordId__c = :childTask1.Id];
		
	  	system.assertEquals(ECO_Service_ProjectSync.STATUS_INITIATED, task1MsgQueue.Status__c);
	
	    Test.stopTest();

	    /*
	    // Now that the scheduled job has executed after Test.stopTest(),
	    task1MsgQueue = [SELECT Id, JobName__c, Status__c FROM IntegrationMessageQueue__c WHERE RecordId__c = :childTask1.Id];
		
	  	system.assertNotEquals(ECO_Service_ProjectSync.STATUS_INITIATED, task1MsgQueue.Status__c);
		*/
   }

}