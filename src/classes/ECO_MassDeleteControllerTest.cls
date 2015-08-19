@isTest
private class ECO_MassDeleteControllerTest {

    static testMethod void testPageLoad () {
        PageReference pageRef = Page.ECO_MassDeleteRisks;
        Test.setCurrentPageReference(pageRef);
        
        ECO_DeleteSObjectSettings__c testSetting = new ECO_DeleteSObjectSettings__c();
        testSetting.Name = 'Risk__c';
        testSetting.ProjectRelationshipName__c = 'Project__c';
        insert testSetting;
        
        Account testAccount = new Account();
		testAccount.Name = 'test account';
		insert testAccount;
        
        pse__Proj__c testProject = new pse__Proj__c();
		testProject.pse__Account__c = testAccount.Id;
		insert testProject;
		
		ApexPages.currentPage().getParameters().put('id', testProject.Id);
		
		Risk__c testRisk = new Risk__c();
		testRisk.Project__c = testProject.Id;
		testRisk.Name = 'test risk';
		testRisk.RiskDescription__c = 'test risk';
		insert testRisk;
		
		User testUser = ECO_Utils_Testing.createTestUser('Standard User');
		insert testUser;
		
		Test.startTest();
		System.runAs(testUser) {
			// We have to re-query here since a workflow rule modifies the risk after we insert it, this is only way to get a clean standarsetcontroller
			ECO_MassDeleteController controller = new ECO_MassDeleteController(new ApexPages.StandardSetController([SELECT Id FROM Risk__c WHERE Id = :testRisk.Id]));
			controller.deleteStuff();
		}
		Test.stopTest();
		
		system.assertEquals(true, [SELECT Id FROM Risk__c].isEmpty());
    }
    
    static testMethod void testPageLoadNoSetting () {
        PageReference pageRef = Page.ECO_MassDeleteRisks;
        Test.setCurrentPageReference(pageRef);
        
        ECO_DeleteSObjectSettings__c testSetting = new ECO_DeleteSObjectSettings__c();
        testSetting.Name = 'Risk__c';
        testSetting.ProjectRelationshipName__c = 'Project__c';
        //insert testSetting;
        
        Account testAccount = new Account();
		testAccount.Name = 'test account';
		insert testAccount;
        
        pse__Proj__c testProject = new pse__Proj__c();
		testProject.pse__Account__c = testAccount.Id;
		insert testProject;
		
		ApexPages.currentPage().getParameters().put('id', testProject.Id);
		
		Risk__c testRisk = new Risk__c();
		testRisk.Project__c = testProject.Id;
		testRisk.Name = 'test risk';
		testRisk.RiskDescription__c = 'test risk';
		insert testRisk;
		
		User testUser = ECO_Utils_Testing.createTestUser('Standard User');
		insert testUser;
		
		Test.startTest();
		System.runAs(testUser) {
			// We have to re-query here since a workflow rule modifies the risk after we insert it, this is only way to get a clean standarsetcontroller
			ECO_MassDeleteController controller = new ECO_MassDeleteController(new ApexPages.StandardSetController([SELECT Id FROM Risk__c WHERE Id = :testRisk.Id]));
			controller.deleteStuff();
		}
		Test.stopTest();
		
		system.assertEquals(false, [SELECT Id FROM Risk__c].isEmpty());
    }
}