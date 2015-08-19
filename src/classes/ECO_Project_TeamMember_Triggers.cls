public class ECO_Project_TeamMember_Triggers {
	
	public static void handleBeforeInsert(list<ProjectTeamMember__c> newTeamMembers)
	{
		/*map<Id, Id> projectTeamContactMap = new map<Id, Id>();
		
		for(ProjectTeamMember__c ptm: newTeamMembers)
			projectTeamContactMap.put(ptm.id, ptm.Contact__c);
		
		map<Id, Contact> contactsMap = new map<Id, Contact>([select Id, FirstName, LastName from Contact where Id in :projectTeamContactMap.values()]);
		
		for(ProjectTeamMember__c ptm: newTeamMembers)
		{
			ptm.Name = contactsMap.get(projectTeamContactMap.get(ptm.Id)).FirstName + ' ' + contactsMap.get(projectTeamContactMap.get(ptm.Id)).LastName;
		}*/

        //map<Id, Id> projectTeamContactMap = new map<Id, Id>();
        set<id> sContacts = new set<id>();
        
        for(ProjectTeamMember__c ptm: newTeamMembers){
           // projectTeamContactMap.put(ptm.id, ptm.Contact__c);
            sContacts.add(ptm.Contact__c);
        }
        
        map<Id, Contact> contactsMap = new map<Id, Contact>([select Id, FirstName, LastName from Contact where Id in :sContacts]);
        
        for(ProjectTeamMember__c ptm: newTeamMembers)
        {
            ptm.Name = contactsMap.get(ptm.Contact__c).FirstName + ' ' + contactsMap.get(ptm.Contact__c).LastName;
        }

	}

    public static void CreateSharingForTeamMembers(list<ProjectTeamMember__c> updatedTeamMembers){
                        
			system.debug( 'CreateSharingForTeamMembers called ' + updatedTeamMembers );
        
            List<pse__Proj__Share> projectShare = new List<pse__Proj__Share>();
        
        	Map<ID, ProjectRole__c> mapOfProjectRoles = new Map<ID, ProjectRole__c> ( [SELECT Active__c, Type__c, Id, Name FROM ProjectRole__c Where Active__c = true] );
        
        	Set<Id> contactIds = new Set<Id>();
        	    
			for(ProjectTeamMember__c ptm : updatedTeamMembers){ 
                
	        	ProjectRole__c pr = mapOfProjectRoles.get( ptm.projectrole__c );
                
                if ( pr.Type__c == 'Key Member' )
                {                    
                	contactIds.add(ptm.contact__c);		
                }
          	}
        
        	Map<ID, Contact> mapOfContacts = new Map<ID, Contact>([SELECT Id, pse__Salesforce_User__c FROM Contact where id in :contactIds]);
 
            for (ProjectTeamMember__c projectTeamMember : updatedTeamMembers) {
                
                Contact c = mapOfContacts.get(projectTeamMember.contact__c);

				if(c != null)
				{
	            	system.debug( 'projectTeamMember.contact__c ' + c + ' SF User =>' + c.pse__Salesforce_User__c );				
                
                	if( c.pse__Salesforce_User__c != null )
                	{                    
                    	system.debug( 'Inside projectTeamMember.contact__c ' + projectTeamMember.contact__c + ' ' +  projectTeamMember.project__c + ' ' + projectTeamMember.User__c );				

                    	pse__Proj__Share ps = new pse__Proj__Share();
                    	ps.AccessLevel = 'Edit';
                    	ps.ParentId = projectTeamMember.project__c;
                    	ps.UserOrGroupId =  c.pse__Salesforce_User__c;	
                    	ps.RowCause = Schema.pse__Proj__Share.RowCause.KeyMember__c;                    
                    	projectShare.add(ps);                   
                	}      
            	}
            }
        
    		if (!projectShare.isEmpty())
            {                      			
                upsert projectShare;
                
                system.debug( 'projectShare => ' + projectShare );
            }                
        }
}