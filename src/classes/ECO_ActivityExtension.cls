/*
	Purpose: - Redirect page to the proper record type

	Created By: Aaron Pettitt

	Revision Log:  
	 	v1.0 - (AP 12/04/2015) -- created
*/
public with sharing class ECO_ActivityExtension {

	//constructor
	public ECO_ActivityExtension() {

	}

	//retrieves the sobject and record type by name and redirects to the proper page
	public PageReference Redirect(){
		try{
			Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe();
			SObjectType sObj = sObjectMap.get(ApexPages.currentPage().getParameters().get('sObject'));
			PageReference page = new PageReference('/' + sObj.getDescribe().getKeyPrefix() + '/e');
			Map<String, String> pageParameterMap = page.getParameters();
			pageParameterMap.putAll(ApexPages.currentPage().getParameters());
			pageParameterMap.put('RecordType', ECO_Utils_Meta.getRecordTypeId(sObj, ApexPages.currentPage().getParameters().get('recordType')));
			pageParameterMap.put('nooverride', '1');
			return page;
		}
		catch(Exception ex){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error redirecting page: ' + ex.getMessage()));
		}
		return null;
	}
}