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
    
    public static void DeleteSharingForTeamMembers(list<ProjectTeamMember__c> deletedTeamMembers) {
        
        system.debug( 'deletedTeamMembers size ' + deletedTeamMembers.size() + ' deletedTeamMembers ' + deletedTeamMembers );
        
        Set<Id> listCon = new Set<Id>();
        Set<Id> listprojectId = new Set<Id>();
        
        for (ProjectTeamMember__c projectTeamMember : deletedTeamMembers) {
            
            if( projectTeamMember.contact__c != null )
            {                
            	listCon.add( projectTeamMember.contact__c );
                listprojectId.add( projectTeamMember.project__c );                
            }                
        }
        
        List<Contact> listContacts = new List<Contact>([SELECT Id, pse__Salesforce_User__c FROM Contact where id in :listCon]);
        
        Set<Id> listOfSalesforceUserId = new Set<Id>();

        for( Contact c : listContacts )
        {
			listOfSalesforceUserId.add(c.pse__Salesforce_User__c);                        
        }			
        
        system.debug( ' listOfSalesforceUserId ' + listOfSalesforceUserId + ' listprojectId ' + listprojectId );
        
        List<pse__Proj__Share> listProjectShare = [ Select Id From pse__Proj__Share Where UserOrGroupId In :listOfSalesforceUserId and ParentId In :listprojectId ];
        
        system.debug( 'listProjectShare ' + listProjectShare.size() + ' listProjectShare ' + listProjectShare );
        
        delete listProjectShare;
    }
    
    public static void CreateSharingForTeamMembers(list<ProjectTeamMember__c> updatedTeamMembers) {
                        
			system.debug( 'CreateSharingForTeamMembers called ' + updatedTeamMembers );
        
        	list<ProjectTeamMember__c> activeKM = [ select id, project__c, ProjectRole__r.Type__c, contact__c From ProjectTeamMember__c Where Project__c = : updatedTeamMembers[0].project__c and Active__c = true And ProjectRole__r.Type__c = 'Key Member' ];
        
        	system.debug( 'activeKM ' + activeKM );
        
            List<pse__Proj__Share> projectShare = new List<pse__Proj__Share>();
        
        	Map<ID, ProjectRole__c> mapOfProjectRoles = new Map<ID, ProjectRole__c> ( [SELECT Active__c, Type__c, Id, Name FROM ProjectRole__c Where Active__c = true] );
        
        	Set<Id> contactIds = new Set<Id>();
        
        	Set<Id> KeyMembers = new Set<Id> ();

			for( ProjectTeamMember__c stored_key_member : activeKM )
            {
				KeyMembers.add( stored_key_member.contact__c ) ;                               
            }
        
			for(ProjectTeamMember__c ptm : updatedTeamMembers){ 
                
	        	ProjectRole__c pr = mapOfProjectRoles.get( ptm.projectrole__c );
                
                if ( pr.Type__c == 'Key Member' ) 
                {                    
                	contactIds.add( ptm.contact__c );	
                    KeyMembers.add( ptm.contact__c );
                    system.debug( 'KM has been added ' + ptm.contact__c );
                }                
                
                if ( pr.Type__c == 'Team Member' ) 
                {     
                    system.debug( 'TM has been added ' + ptm.contact__c );
                	contactIds.add(ptm.contact__c);		
                }                
          	}
        
        	Map<ID, Contact> mapOfContacts = new Map<ID, Contact>([SELECT Id, pse__Salesforce_User__c, pse__Salesforce_User__r.isactive FROM Contact where id in :contactIds]);
 
            for (ProjectTeamMember__c projectTeamMember : updatedTeamMembers) {
                
                Contact c = mapOfContacts.get(projectTeamMember.contact__c);

				if(c != null)
				{
	            	system.debug( 'projectTeamMember.contact__c ' + c + ' SF User =>' + c.pse__Salesforce_User__c );				
                	string access;
                    
                	if( ( c.pse__Salesforce_User__c != null ) && ( c.pse__Salesforce_User__r.IsActive == true ) )
                	{     
                        ProjectRole__c pr = mapOfProjectRoles.get( projectTeamMember.projectrole__c );
                        
                        access = 'Read';
                        
                        if ( pr.Type__c == 'Key Member' )
                        {                    
        					access = 'Edit';        
                        }                
                        
                        if ( pr.Type__c == 'Team Member' )
                        {                              
                            system.debug( 'Project Role Name ' + pr.Name + ' KeyMembers ' + KeyMembers + ' projectTeamMember.contact__c ' + projectTeamMember.contact__c );
                            
                            if( ( pr.Name == 'Project Management Specialist' ) || ( pr.Name == 'Task Manager' ) 
                               || ( pr.Name == 'Capture Manager' ) || ( pr.Name == 'Technical Lead' ) || ( pr.Name == 'TQR Participant' ) 
                               || ( pr.Name == 'Reviewer' ) || ( pr.Name == 'Lead Verifier' ) || ( pr.Name == 'Resilience Director' ) || ( pr.Name == 'Independent Reviewer' ) || ( pr.Name == 'Deliverable Owner' ) 
                              )
                            {
	        					access = 'Edit';        
                            } 
                            
                            if( KeyMembers.contains(projectTeamMember.contact__c) )
                            {
                                system.debug( 'Found Team Member In KM ' + projectTeamMember.contact__c );
                              	access = 'Edit';                                  
                            }                                
                        }                          
                        
                    	system.debug( 'Inside projectTeamMember.contact__c ' + projectTeamMember.contact__c + ' ' +  projectTeamMember.project__c + ' ' + projectTeamMember.User__c );				
							//projectTeamMember.AccessLevel__c ;
                        
                        /*if( ( projectTeamMember.AccessLevel__c == '' ) || ( projectTeamMember.AccessLevel__c == null ) )
                        {
                            // If no access level defined at the user level default to Edit share. (Give User Read write access to Project).
                            access = 'Edit';
                        }*/	
                        
                        pse__Proj__Share ps = new pse__Proj__Share();
                        ps.AccessLevel = access;
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