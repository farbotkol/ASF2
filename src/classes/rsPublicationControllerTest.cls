@isTest
private class rsPublicationControllerTest {
	
	@isTest static void test_method_one() {
		User u = [Select Id, Is_Profile_Locked__c, Date_Time_Sent_for_Review__c from User where Id =: UserInfo.getUserId()];
		rsProfile profile = new rsProfile(u);
		rsPublicationController cont = new rsPublicationController();
		cont.profile = profile;
		cont.newPart();
		cont.CurrentPart.setPublicationTitle('Test Title');
		cont.CurrentPart.setPublication('test Pub');
		cont.CurrentPart.setPublicationDate('12/12/2013');
		cont.CurrentPart.setPublicationAuthor('Test Author');

		Test.startTest();
		PageReference pf = cont.savePart();
		Test.stopTest();

		rs_Profile_Part__c pp = [Select Publication_Title__c, Publication__c, Publication_Date__c, Publication_Author__c
							from rs_Profile_Part__c];

		System.assertEquals( null, pf);
		System.assertEquals( pp.Publication_Title__c, cont.CurrentPart.getPublicationTitle());
		System.assertEquals( pp.Publication__c, cont.CurrentPart.getPublication());
		System.assertEquals( true, pp.Publication_Date__c.isSameDay(Date.parse(cont.CurrentPart.getPublicationDate())));
		System.assertEquals( pp.Publication_Author__c, cont.CurrentPart.getPublicationAuthor());

	}
	
}