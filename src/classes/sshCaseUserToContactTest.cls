@isTest
private class sshCaseUserToContactTest {

	@isTest static void testUserToContact() {

		Account acct = new Account(Name = 'AECOM Internal Account');
		insert acct;

		Account acct2 = new Account(Name = 'Uncategorized Vendor');
		insert acct2;

		Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];

		User u = new User(Alias = 'tboone', Email = 'sfdctestcase@aecom.com',
		                  EmailEncodingKey = 'UTF-8', FirstName = 'Tony', LastName = 'Boone', LanguageLocaleKey = 'en_US',
		                  LocaleSidKey = 'en_US', ProfileId = p.Id, Department = 'Fake Department',
		                  TimeZoneSidKey = 'America/Los_Angeles', UserName = 'tboone@ssh.com.test', Shared_Services_Is_Executive__c = true);

		insert u;

		ssh_User_Contact_Settings__c custSetting = new ssh_User_Contact_Settings__c();
		custSetting.Name = 'Default';
		custSetting.External_Vendor_Uncategorized_Account__c = 'Uncategorized Vendor';
		custSetting.External_Vendor_Record_Type__c = 'Vendor';
		custSetting.Employee_Record_Type__c = 'AECOM Employee';
		custSetting.Internal_User_Account__c = 'AECOM Internal Account';
		insert custSetting;

		Case c1 = new Case(SuppliedName = 'Tony Boone', SuppliedEmail = 'sfdctestcase@aecom.com');
		insert c1;

		Contact ct = [select Name, Email, AccountId, Shared_Services_Is_Executive__c, User__c from Contact where Email = :c1.SuppliedEmail];

		System.assertEquals(ct.Name, c1.SuppliedName);
		System.assertEquals(ct.Email, c1.SuppliedEmail);
		System.assertEquals(ct.AccountId, acct.Id);
		System.assertEquals(ct.User__c, u.Id);
		System.assertEquals(ct.Shared_Services_Is_Executive__c, u.Shared_Services_Is_Executive__c);
	}

}