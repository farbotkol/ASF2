@isTest
private class sshCalculateResolveByTest {
	
	//--Test the "after insert" functionality
	@isTest static void testCalculateResolveByAfterInsert() {

		//--Insert custom settings so that the other triggers don't freak out
		ssh_User_Contact_Settings__c custSetting = new ssh_User_Contact_Settings__c();
		custSetting.Name = 'Default';
		custSetting.External_Vendor_Uncategorized_Account__c = 'Uncategorized Vendor';
		custSetting.External_Vendor_Record_Type__c = 'Vendor';
		custSetting.Employee_Record_Type__c = 'AECOM Employee';
		custSetting.Internal_User_Account__c = 'AECOM Internal Account';
		insert custSetting;


		Case cs = new Case(RecordTypeId = sshUserContactUtils.getRecordTypeIdByName('Shared Services AP'), SS_Is_Backup_Request__c = true);
		insert cs;

		List<BusinessHours> bhs = [select Id from BusinessHours where Name = 'Shared Services North America'];

		cs = [select CreatedDate, SS_SLA_Target__c, SS_Resolve_By__c from Case where Id = :cs.Id];

		System.assertEquals(bhs.size(), 1);

		System.assertEquals(cs.SS_SLA_Target__c, 24);

		System.assertEquals(cs.SS_Resolve_By__c, BusinessHours.add(bhs[0].Id, cs.CreatedDate, (Long)(cs.SS_SLA_Target__c * 3600000) ));

	}

	//--Test the "before update" functionality
	@isTest static void testCalculateResolveByBeforeUpdate() {
		//--Insert custom settings so that the other triggers don't freak out
		ssh_User_Contact_Settings__c custSetting = new ssh_User_Contact_Settings__c();
		custSetting.Name = 'Default';
		custSetting.External_Vendor_Uncategorized_Account__c = 'Uncategorized Vendor';
		custSetting.External_Vendor_Record_Type__c = 'Vendor';
		custSetting.Employee_Record_Type__c = 'AECOM Employee';
		custSetting.Internal_User_Account__c = 'AECOM Internal Account';
		insert custSetting;

		Case cs = new Case(RecordTypeId = sshUserContactUtils.getRecordTypeIdByName('Shared Services AP'), SS_Is_Backup_Request__c = true);
		insert cs;

		List<BusinessHours> bhs = [select Id from BusinessHours where Name = 'Shared Services North America'];

		cs.SS_Is_Backup_Request__c = false;
		cs.SS_Is_Invoice_Request__c = true;

		update cs;

		cs = [select CreatedDate, SS_SLA_Target__c, SS_Resolve_By__c from Case where Id = :cs.Id];
		
		System.assertEquals(bhs.size(), 1);

		System.assertEquals(cs.SS_SLA_Target__c, 48); //--Change to 48 hours to make sure Before Update component works too

		System.assertEquals(cs.SS_Resolve_By__c, BusinessHours.add(bhs[0].Id, cs.CreatedDate, (Long)(cs.SS_SLA_Target__c * 3600000) ));
	}
	
}