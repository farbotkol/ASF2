public with sharing class rsWorkController extends rsSectionController {
	public List<SelectOption> countryList {get; set;}
	public rsWorkController() {
		super();
		mRecordType = rsProfilePart.RT_WORK_HISTORY;
		sObject sObj = Schema.getGlobalDescribe().get('rs_Profile_Part__c').newSObject() ;
    	countryList = rsDataUtils.getPicklistValues(sObj, 'Country__c');
	}
}