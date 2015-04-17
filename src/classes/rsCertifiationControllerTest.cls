/*************************************************************************
*
* PURPOSE: Test Class for Controller for Certification Section
*
* CREATED: 2014 Ethos Solutions - www.ethos.com
* AUTHOR: Brian Lau
***************************************************************************/
@isTest
private class rsCertifiationControllerTest {
	
	@isTest static void testSavePart() {
		User u = [Select Id from User where Id =: UserInfo.getUserId()];
		rsProfile profile = new rsProfile(u);
		rsCertificationController cont = new rsCertificationController();
		cont.profile = profile;
		cont.newPart();
		cont.CurrentPart.setCertificationTitle('Cert Title');
		cont.CurrentPart.setCertificationDescription('Cert Description');
		cont.CurrentPart.setDateCertified('12/30/2013');

		Test.startTest();
		PageReference pf = cont.savePart();
		Test.stopTest();

		rs_Profile_Part__c pp = [Select Certification_Title__c,Certification_Description__c,Date_Certified__c from rs_Profile_Part__c];
		System.assertEquals( null, pf );
		System.assertEquals( pp.Certification_Title__c, 'Cert Title');
		System.assertEquals( pp.Certification_Description__c, 'Cert Description');
		System.assertEquals( true, pp.Date_Certified__c.isSameDay(Date.parse('12/30/2013')));
	}

	@isTest static void testCancelPart() {
		User u = [Select Id from User where Id =: UserInfo.getUserId()];
		rsProfile profile = new rsProfile(u);
		rsCertificationController cont = new rsCertificationController();
		cont.profile = profile;
		cont.newPart();
		cont.CurrentPart.setCertificationTitle('Cert Title');
		cont.CurrentPart.setCertificationDescription('Cert Description');
		cont.CurrentPart.setDateCertified('12/30/2013');
		cont.savePart();
		rs_Profile_Part__c pp = [Select Certification_Title__c,Certification_Description__c,Date_Certified__c from rs_Profile_Part__c];
		ApexPages.currentPage().getParameters().put('partId', pp.Id);
		cont.editPart();
		
		cont.CurrentPart.setCertificationTitle('Cert Titlezzzzzz');
		cont.CurrentPart.setCertificationDescription('Cert Descriptionzzzzzz');
		cont.CurrentPart.setDateCertified('1/5/2013');		

		Test.startTest();
		PageReference pf = cont.cancelPart();
		cont.editPart();
		Test.stopTest();

		System.assertEquals( null, pf );
		System.assertEquals( cont.CurrentPart.getCertificationTitle(), 'Cert Title');
		System.assertEquals( cont.CurrentPart.getCertificationDescription(), 'Cert Description');
		System.assertEquals( cont.CurrentPart.getDateCertified(), '12/30/2013');

	}
	
}