/*******************************************************************************
*
* PURPOSE: Test controller for the Education section in Skills & Qualifications 
*
* CREATED: 2014 Ethos Solutions - www.ethos.com
* AUTHOR: Kyle Johnson
********************************************************************************/
@isTest
private class rsEducationControllerTest {
	
	@isTest static void testSavePart() {
		User u = [Select Id, Date_Time_Sent_for_Review__c from User where Id =: UserInfo.getUserId()];
		rsProfile profile = new rsProfile(u);
		rsEducationController cont = new rsEducationController();
		cont.profile = profile;
		cont.newPart();
		cont.CurrentPart.setInstitution('Test Institution');
		cont.CurrentPart.setDegree('Degree');
		cont.CurrentPart.setDegreeSpecialty('Test Specialty');
		cont.CurrentPart.setInstitutionCountry('United States');
		cont.CurrentPart.setYearObtained(1992);

		Test.startTest();
		PageReference pf = cont.savePart();
		Test.stopTest();

		rs_Profile_Part__c pp = [Select Institution__c, Degree__c, Degree_Specialty__c, Institution_Country__c, Year_Obtained__c from rs_Profile_Part__c];

		System.assertEquals( null, pf);
		System.assertEquals( pp.Institution__c, cont.CurrentPart.getInstitution());
		System.assertEquals( pp.Degree__c, cont.CurrentPart.getDegree());
		System.assertEquals( pp.Degree_Specialty__c, cont.CurrentPart.getDegreeSpecialty());
		System.assertEquals( pp.Institution_Country__c, cont.CurrentPart.getInstitutionCountry());
		System.assertEquals( pp.Year_Obtained__c, cont.CurrentPart.getYearObtained());
	}

	@isTest static void testCancelPart() {
		User u = [Select Id, Date_Time_Sent_for_Review__c from User where Id =: UserInfo.getUserId()];
		rsProfile profile = new rsProfile(u);
		rsEducationController cont = new rsEducationController();
		cont.profile = profile;
		cont.newPart();
		cont.CurrentPart.setInstitution('Test Institution');		
		cont.CurrentPart.setDegree('Degree');
		cont.CurrentPart.setDegreeSpecialty('Test Specialty');
		cont.CurrentPart.setInstitutionCountry('United States');
		cont.CurrentPart.setYearObtained(1992);
		cont.savePart();
		rs_Profile_Part__c pp = [Select Institution__c, Degree__c, Degree_Specialty__c, Institution_Country__c, Year_Obtained__c
									from rs_Profile_Part__c];
		ApexPages.currentPage().getParameters().put('partId', pp.Id);
		cont.editPart();

		cont.CurrentPart.setInstitution('Another Institution');
		cont.CurrentPart.setDegree('Different Degree');
		cont.CurrentPart.setDegreeSpecialty('Fake Specialty');		
		cont.CurrentPart.setInstitutionCountry('Canada');
		cont.CurrentPart.setYearObtained(2008);

		Test.startTest();
		PageReference pf = cont.cancelPart();
		cont.editPart();
		Test.stopTest();

		System.assertEquals( null, pf);
		System.assertEquals( cont.CurrentPart.getInstitution(), 'Test Institution');
		System.assertEquals( cont.CurrentPart.getDegree(), 'Degree');
		System.assertEquals( cont.CurrentPart.getDegreeSpecialty(), 'Test Specialty');
		System.assertEquals( cont.CurrentPart.getInstitutionCountry(), 'United States');
		System.assertEquals( cont.CurrentPart.getYearObtained(), 1992);		
	}
	
}