/*************************************************************************
*
* PURPOSE: Test controller for the personal tab in chatter 
*
* CREATED: 2014 Ethos Solutions - www.ethos.com
* AUTHOR: Alex Molina
***************************************************************************/
@isTest
private class rsProfileControllerTest {

	@isTest static void tesCannotSeeGMFields() {
		User u = rsTestUtil.createTestUsers(false).get(0);
		Profile userProfile = [Select Id, Name from Profile where Name = 'Standard User'];
		u.ProfileId = userProfile.Id;
		update u;
		rsProfileController cont = new rsProfileController();
		ApexPages.currentPage().getParameters().put('sfdc.userId',u.Id);

		System.runas(u) {
			Test.startTest();
		 	Boolean canSeeGMFields = cont.getCanSeeGlobalMobility();
			Test.stopTest();
			System.assertEquals(false, canSeeGMFields);
		}
	}

	@isTest static void tesCanSeeGMFields() {
		User u = rsTestUtil.createTestUsers(true).get(0);
		rsProfileController cont = new rsProfileController();
		ApexPages.currentPage().getParameters().put('sfdc.userId',u.Id);

		Test.startTest();
	 	Boolean canSeeGMFields = cont.getCanSeeGlobalMobility();
		Test.stopTest();

		System.assertEquals(true, canSeeGMFields);
	}

}