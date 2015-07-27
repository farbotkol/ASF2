@isTest
private class ECO_PortalControllerTest {

    static testMethod void testPageLoadAndNavigation () {
        PageReference pageRef = Page.ECO_Portal;
		
		Account testAccount = new Account();
		testAccount.Name = 'test account';
		insert testAccount;
		
		pse__Proj__c testProject = new pse__Proj__c();
		testProject.pse__Account__c = testAccount.Id;
		insert testProject;
		
		Test.startTest();

		ECO_PortalController controller = new ECO_PortalController();
		controller.refreshProjects();
		controller.changeProjectOutputType();
		/*
		controller.goToApplicationConfiguration();
		controller.goToApplicationConfigurationv2();
		controller.goToReportBuilder();
		controller.goToReportBuilderv2();
		controller.goToNewProject();
		controller.goToNewOpportunity();
		*/
		controller.goToHome();
		
		Test.stopTest();
    }
}