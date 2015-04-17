@isTest
private class sshUpdateUserContactTest {
	
	@isTest static void testUserContactUpdate() {
		Test.startTest();
		Account acct = new Account(Name = 'AECOM Internal Account');
		insert acct;

		Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];

		User u = new User(Alias = 'tboone', Email='SFDCTestCase@aecom.com', 
                        EmailEncodingKey='UTF-8', FirstName = 'Tony', LastName='Boone', LanguageLocaleKey='en_US', 
                        LocaleSidKey='en_US', ProfileId = p.Id, Department = 'Fake Department',
                        TimeZoneSidKey='America/Los_Angeles', UserName= 'tboone@ssh.com.test', Shared_Services_Is_Executive__c = true);

		insert u;

		ssh_User_Contact_Settings__c custSetting = new ssh_User_Contact_Settings__c();
		custSetting.Name = 'Default';
		custSetting.External_Vendor_Uncategorized_Account__c = 'Uncategorized Vendor';
		custSetting.External_Vendor_Record_Type__c = 'Vendor';
		custSetting.Employee_Record_Type__c = 'AECOM Employee';
		custSetting.Internal_User_Account__c = 'AECOM Internal Account';
		insert custSetting;

		//insert a Contact record
		Contact ct = new Contact(FirstName = 'Tony', LastName = 'Boone', Email = 'SFDCTestCase@aecom.com', Department = 'Fake Department',
			Shared_Services_Is_Executive__c = true, User__c = u.Id, Phone = '602-123-4567');

		insert ct;

		u.Phone = '602-867-5309';
		u.Department = 'Super Science';
		u.Shared_Services_Is_Executive__c = false;

		update u;		

		Test.stopTest();

		//requery OUTSIDE of the Test() block as the method called on User update is @future

		u = [select Phone, Department, Shared_Services_Is_Executive__c from User where Id = :u.Id];

		Contact ct2 = [select Phone, Department, Shared_Services_Is_Executive__c from Contact where Email = 'SFDCTestCase@aecom.com'];

		System.assertEquals(ct2.Phone, u.Phone);
		System.assertEquals(ct2.Department, u.Department);
		System.assertEquals(ct2.Shared_Services_Is_Executive__c, u.Shared_Services_Is_Executive__c);
	}
	
}