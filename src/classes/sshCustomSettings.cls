/*************************************************************************
* COMPONENT: Shared Services Helpdesk
* CLASS: sshCustomSettings
* PURPOSE: 
* CREATED: 07/10/15 Ethos Solutions - www.ethos.com
* AUTHOR: Joe DePetro
***************************************************************************/
public with sharing class sshCustomSettings 
{
	public sshCustomSettings() {}

	/**
    * @Description This method will get all the needed Custom Settings for the Case trigger functionality and
    *                 build a CaseTriggerSettings object that holds all the needed settings
    * @return CaseTriggerSettings - the CaseTriggerSettings object will have all the settings needed for the Case trigger
    */    
	public static CaseTriggerSettings getCaseTriggerSettings()
	{
		CaseTriggerSettings settings = new CaseTriggerSettings();

		if(ssh_User_Contact_Settings__c.getInstance('Default') != null)
		{
			String settingName = ssh_User_Contact_Settings__c.getInstance('Default').Internal_User_Account__c;
			if(settingName != null)
				settings.internalUserAccount = [select Id, Name from Account where Name = :settingName];	
			else
				System.debug('Custom Settings Error - Internal_User_Account__c not set');

			settingName = ssh_User_Contact_Settings__c.getInstance('Default').External_Vendor_Uncategorized_Account__c;
			if(settingName != null)
				settings.externalVendorAccount = [select Id, Name from Account where Name = :settingName];
			else
				System.debug('Custom Settings Error - External_Vendor_Uncategorized_Account__c not set');

			settingName = ssh_User_Contact_Settings__c.getInstance('Default').Employee_Record_Type__c;
			if(settingName != null)
				settings.internalUserContactRecordTypeId = sshUserContactUtils.getRecordTypeIdByName(settingName);
			else
				System.debug('Custom Settings Error - Employee_Record_Type__c not set');

			settingName	= ssh_User_Contact_Settings__c.getInstance('Default').External_Vendor_Record_Type__c;
			if(settingName != null)
				settings.vendorContactRecordTypeId = sshUserContactUtils.getRecordTypeIdByName(settingName);
			else
				System.debug('Custom Settings Error - External_Vendor_Record_Type__c not set');
		}
		else
		{
			System.debug('Custom Settings Error - SSH User Contact Settings needs to have a "Default" record.');
		}

		return settings;
	}

	/**
    * @Description Holder object for holding all the settings needed for the Case trigger
    */
	public class CaseTriggerSettings
	{
		public Account internalUserAccount { get; set; }
		public Account externalVendorAccount { get; set; }
		public String internalUserContactRecordTypeId { get; set; }
		public String vendorContactRecordTypeId { get; set; }

		/**
	    * @Description Helper method to make sure all the Custom Settings fields have values.
	    * @return Boolean - true if all the fields have values.
	    */ 
		public Boolean validationOk()
		{
			return internalUserAccount != null && externalVendorAccount != null && String.isNotBlank(internalUserContactRecordTypeId) && String.isNotBlank(vendorContactRecordTypeId);
		}
	}
}