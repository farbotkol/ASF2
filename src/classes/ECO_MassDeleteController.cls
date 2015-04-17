public with sharing class ECO_MassDeleteController {
	
	public List<sObject> sObjsToDelete				{ get; set; }
	private String retURL;
	
	public ECO_MassDeleteController(ApexPages.StandardSetController con) {
		con.setPageSize(1);
		String sObjectName = con.getRecords().getSObjectType().getDescribe().getName();
		
		ECO_DeleteSObjectSettings__c setting = ECO_DeleteSObjectSettings__c.getAll().get(sObjectName);
		
		if (setting == null) {
			ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR, 'There seems to be a missing setting for '+sObjectName+'.');
            ApexPages.addMessage(msg);
			return;
		}
		
		String projectRelationshipName = setting.ProjectRelationshipName__c;
		
		String projectId = ApexPages.currentPage().getParameters().get('id');
		
		String queryString = 'SELECT Id, Name FROM '+sObjectName+' WHERE '+projectRelationshipName+' = \''+projectId+'\'';
		
		sObjsToDelete = Database.query(queryString);
		
		retURL = '/'+projectId;
	}
	
	public PageReference deleteStuff () {
		if (sObjsToDelete == null) {
			return new PageReference(retURL);
		}
		
		try {
			delete sObjsToDelete;
		} catch (Exception e) {
			ApexPages.addMessages(e);
			return null;
		}
		
		return new PageReference(retURL);
	}
}