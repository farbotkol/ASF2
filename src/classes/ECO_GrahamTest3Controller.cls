global with sharing class ECO_GrahamTest3Controller {
	public ECO_GrahamTest3Controller() {
		
	}

	@RemoteAction
	global static List<pse__Proj__c> getProjects() {
		return [select id, name from pse__Proj__c order by name limit 50];
	}
}