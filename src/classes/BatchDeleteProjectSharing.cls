global without sharing class BatchDeleteProjectSharing implements Database.Batchable<SObject>, Database.Stateful {

    private System.LoggingLevel debugLevel = LoggingLevel.INFO;
    private Date billingDate;
    
    Map<Id, Account> mapServiceAccountsMissingAccountIdentifierType; 
    
    global String query;

    global BatchDeleteProjectSharing (){
		this.query = 'SELECT Active__c, StartDate__c, EndDate__c, Contact__c, Id, Project__c, contact__r.name, contact__r.pse__Salesforce_User__c FROM ProjectTeamMember__c where Active__c = false and EndDate__c <= TODAY order by EndDate__c desc Limit 1000' ;    	
        system.debug( 'BatchDeleteProjectSharing Constructor' );
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug(debugLevel, 'Beginning BatchPreBillingValidation Execution.');
       
        return Database.getQueryLocator(query);
    }
    
    global void execute( Database.BatchableContext BC, List<SObject> projectTeamMemberItemsToProcess ) {
            
        Set<Id> projectIds = new Set<Id> (); 
        Set<String> listOfKeysToDelete = new Set<String> ();
        
        system.debug( 'projectTeamMemberItemsToProcess size ' + projectTeamMemberItemsToProcess.size() );
        
        string keyToDel;
        for(ProjectTeamMember__c thisProjectTeamMember : (List<ProjectTeamMember__c>) projectTeamMemberItemsToProcess){
        	 projectIds.add( thisProjectTeamMember.Project__c );
             keyToDel = String.Valueof(thisProjectTeamMember.contact__r.pse__Salesforce_User__c) + String.ValueOf(thisProjectTeamMember.Project__c);
             listOfKeysToDelete.add( keyToDel );
        }     
        
        system.debug( 'listOfKeysToDelete ' + listOfKeysToDelete + ' projectIds ' + projectIds );
        
      	List<pse__Proj__Share> listProjShare = [SELECT id, ParentId, UserOrGroupId, RowCause, AccessLevel from pse__Proj__Share where RowCause = 'KeyMember__c'  and ParentId in : projectIds ];
        
		Map <String,  pse__Proj__Share> mapSearchIdProjectShare = new Map <String,  pse__Proj__Share>();
        
        for(pse__Proj__Share thisProjectShare : (List<pse__Proj__Share>) listProjShare){
            string key = String.Valueof(thisProjectShare.UserOrGroupId) + String.ValueOf(thisProjectShare.ParentId);
            system.debug( 'mapSearchIdProjectShare ' + key );
        	mapSearchIdProjectShare.put( key, thisProjectShare );         
        }  

		List<pse__Proj__Share> projectSharesToDelete = new List<pse__Proj__Share>();
        
		for(string idToDelete: listOfKeysToDelete){
    		if( mapSearchIdProjectShare.get(idToDelete) != null )	
            {
				projectSharesToDelete.add(mapSearchIdProjectShare.get(idToDelete));                              
            }                
   		}  
        
        system.debug( 'projectSharesToDelete ' + projectSharesToDelete + ' projectSharesToDelete size ' + projectSharesToDelete.size() );
        
        delete projectSharesToDelete;
    }  
    
    global void finish(Database.BatchableContext BC) {
        
    }    
        
}