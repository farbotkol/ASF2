@isTest
private class ECO_BudgetGridController2Test {

    static testMethod void testPageLoadNewBudgetAndCopyData () {
        PageReference pageRef = Page.ECO_BudgetGrid2;
        Test.setCurrentPageReference(pageRef);
		
		Account testAccount = new Account();
		testAccount.Name = 'test account';
		insert testAccount;
		
		Contact testContact = new Contact();
		testContact.AccountId = testAccount.Id;
		testContact.RecordTypeId = ECO_Utils_Meta.getRecordTypeId(Contact.sObjectType, ECO_Constants.Contact_PSAResourceRecordTypeName);
		testContact.LastName = 'test last';
		testContact.pse__Is_Resource_Active__c = true;
		testContact.pse__Is_Resource__c = true;
		insert testContact;
		
		pse__Proj__c testProject = new pse__Proj__c();
		testProject.pse__Account__c = testAccount.Id;
		testProject.DateLastCompletedBudgetQuestionnaire__c = Date.today().addDays(-1);
		insert testProject;
		
		pse__Project_Task__c projTask = new pse__Project_Task__c();
		projTask.pse__Project__c = testProject.Id;
		insert projTask;
		
		User testUser = ECO_Utils_Testing.createTestUser('Standard User');
		insert testUser;
		
		pse__Project_Task_Assignment__c testPTA = new pse__Project_Task_Assignment__c();
		testPTA.pse__Resource__c = testContact.Id;
		testPTA.pse__Project_Task__c = projTask.Id;
		insert testPTA;
		
		Risk__c testRisk = new Risk__c();
		testRisk.Project__c = testProject.Id;
		testRisk.ContingencyPercent__c = 100;
		testRisk.LaborCost__c = 100;
		testRisk.Name = 'test risk';
		testRisk.RiskDescription__c = 'test risk';
		insert testRisk;
		
		List<ExpenditureItem__c> testExpendList = new List<ExpenditureItem__c>();
		List<CostDistributionLine__c> testCDRList = new List<CostDistributionLine__c>();
		
		ExpenditureItem__c testExpend1 = new ExpenditureItem__c();
		testExpend1.ExpenditureType__c = 'LABOR';
		testExpendList.add(testExpend1);
		
		CostDistributionLine__c testCDR1 = new CostDistributionLine__c();
		testCDR1.ExpenditureItemID__r = testExpend1;
		testCDR1.ProjectNumber__c = testProject.Id;
		testCDR1.AcctRawCost__c = 100;
		testCDRList.add(testCDR1);
		
		ExpenditureItem__c testExpend2 = new ExpenditureItem__c();
		testExpend2.ExpenditureType__c = 'SUBCONTRACTOR';
		testExpendList.add(testExpend2);
		
		CostDistributionLine__c testCDR2 = new CostDistributionLine__c();
		testCDR2.ExpenditureItemID__r = testExpend2;
		testCDR2.ProjectNumber__c = testProject.Id;
		testCDR2.AcctRawCost__c = 100;
		testCDRList.add(testCDR2);
		
		ExpenditureItem__c testExpend3 = new ExpenditureItem__c();
		testExpend3.ExpenditureType__c = 'FEE';
		testExpendList.add(testExpend3);
		
		CostDistributionLine__c testCDR3 = new CostDistributionLine__c();
		testCDR3.ExpenditureItemID__r = testExpend3;
		testCDR3.ProjectNumber__c = testProject.Id;
		testCDR3.AcctRawCost__c = 100;
		testCDRList.add(testCDR3);
		
		ExpenditureItem__c testExpend4 = new ExpenditureItem__c();
		testExpend4.ExpenditureType__c = 'CONTINGENCY';
		testExpendList.add(testExpend4);
		
		CostDistributionLine__c testCDR4 = new CostDistributionLine__c();
		testCDR4.ExpenditureItemID__r = testExpend4;
		testCDR4.ProjectNumber__c = testProject.Id;
		testCDR4.AcctRawCost__c = 100;
		testCDRList.add(testCDR4);
		
		insert testExpendList;
		for (CostDistributionLine__c cdr : testCDRList) {
			cdr.ExpenditureItemID__c = cdr.ExpenditureItemID__r.Id;
		}
		insert testCDRList;
		
		Test.startTest();
		
		// Disabling lots of triggers here since I am not testing them, and it let's me test a bunch of page functionality in a single test
		ECO_ProjectTriggers.run = false;
		ECO_BudgetHeaderTriggers.run = false;
		
		System.runAs(testUser) {
			
			
			ECO_BudgetGridController2 controller = new ECO_BudgetGridController2(new ApexPages.StandardController(testProject));
			controller.onLoad();
			
			controller.copyContingencyFromRiskRegister();
			controller.copyTasksAndAssignments();
			
			List<BudgetHeader__c> newHeader = [SELECT Id FROM BudgetHeader__c WHERE Project__c = :testProject.Id];
			system.assertEquals(false, newHeader.isEmpty(), 'No new budget headers were created on a first time visit.');
			
			controller.showAddTask();
			controller.newBudgetTask.TaskName__c = 'test task 2';
			controller.saveNewTask();
			
			controller.showCreateChangeOrder();
			controller.newBudgetHeader.BudgetName__c = 'change order 1';
			controller.createChangeOrder();
			
			controller.selectedVersionId = newHeader[0].Id;
			
			controller.showAddLaborPerson();
			controller.showAddSub();
			controller.showAddFee();
			controller.showAddContingency();
			controller.newBudgetColumn.ResourceName__c = 'new contingency';
			controller.saveNewResource();
			controller.cancelModal();
			
			List<BudgetResource__c> existingBudgetResources = [SELECT Id FROM BudgetResource__c WHERE BudgetHeader__c = :controller.selectedVersionId];
			system.assertEquals(2, existingBudgetResources.size());
			
			List<BudgetTask__c> existingBudgetTask = [SELECT Id FROM BudgetTask__c WHERE BudgetHeader__c = :controller.selectedVersionId AND IsHidden__c = false];
			system.assertEquals(2, existingBudgetTask.size());
			
			controller.selectedColumnId = existingBudgetResources[0].Id;
			controller.selectedtaskId = existingBudgetTask[0].Id;
			controller.assignThisResourceToExistingTask();
			
			controller.cloneResource();
			
			controller.removeEntireRow();
			controller.removeEntireColumn();
			
			controller.quickSave();
			controller.save();
			
			controller.cancel();
		}
		Test.stopTest();
		
		
		
		// 2 tasks
    }
}