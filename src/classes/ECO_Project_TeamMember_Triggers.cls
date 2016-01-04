public class ECO_Project_TeamMember_Triggers {
	
    public static Boolean run = true;

    public static void setProjectFields(list<ProjectTeamMember__c> newTeamMembers){


        if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('setProjectFields')) {
            return;
        }

        map<id, pse__Proj__c> mapProj;
        map<id, pse__Proj__c> mapProjToUpdate = new map<id, pse__Proj__c>();
        list<ProjectTeamMember__c> lstPTMtoUpdate = new list<ProjectTeamMember__c>();
        set<id> sProj = new set<id>();
        Map<ID, ProjectRole__c> mapOfProjectRoles = new Map<ID, ProjectRole__c> ( [SELECT Active__c, Type__c, Id, Name FROM ProjectRole__c Where Active__c = true] ); 

        for(ProjectTeamMember__c obj: newTeamMembers){
            sProj.add(obj.Project__c);
        }

        mapProj = new map<id, pse__Proj__c>([select id, ProjectApprover__c, pse__Project_Manager__c, PnLManager__c from pse__Proj__c where id IN: sProj]);

        for(ProjectTeamMember__c oPTM: newTeamMembers){


            if(oPTM.Status__c == 'Approved' && 
                oPTM.StartDate__c <= date.today() && 
                (oPTM.EndDate__c == null || oPTM.EndDate__c >= date.today()) && 
                oPTM.ProjectUpdated__c == false && 
                (mapOfProjectRoles.get(oPTM.ProjectRole__c).name == 'Project Approver' || mapOfProjectRoles.get(oPTM.ProjectRole__c).name == 'Project Manager' || mapOfProjectRoles.get(oPTM.ProjectRole__c).name == 'Project Approver 2')){

                system.debug('DEBUG***: PASSED CONDITION');

                if(mapOfProjectRoles.get(oPTM.ProjectRole__c).name == 'Project Approver'){
                    if(mapProj.get(oPTM.Project__c).ProjectApprover__c != oPTM.Contact__c){
                        mapProj.get(oPTM.Project__c).ProjectApprover__c = oPTM.Contact__c;  
                        mapProjToUpdate.put(mapProj.get(oPTM.Project__c).id, mapProj.get(oPTM.Project__c));             
                    }


                } else if(mapOfProjectRoles.get(oPTM.ProjectRole__c).name == 'Project Manager'){
                    if(mapProj.get(oPTM.Project__c).pse__Project_Manager__c != oPTM.Contact__c){
                        mapProj.get(oPTM.Project__c).pse__Project_Manager__c = oPTM.Contact__c; 
                        mapProjToUpdate.put(mapProj.get(oPTM.Project__c).id, mapProj.get(oPTM.Project__c));             
                    }


                } else if(mapOfProjectRoles.get(oPTM.ProjectRole__c).name == 'Project Approver 2'){

                    if(mapProj.get(oPTM.Project__c).PnLManager__c != oPTM.Contact__c){
                        mapProj.get(oPTM.Project__c).PnLManager__c = oPTM.Contact__c;   
                        mapProjToUpdate.put(mapProj.get(oPTM.Project__c).id, mapProj.get(oPTM.Project__c));         
                    }

                }
            }
        }

        if(mapProjToUpdate.size() >0){
            update mapProjToUpdate.values();
        }        
    }


    public static void permissionGanttView(list<ProjectTeamMember__c> newTeamMembers){

        if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('permissionGanttView')) {
            return;
        }

        set<id> sContacts = new set<id>();

        for(ProjectTeamMember__c ptm: newTeamMembers)
        {
            sContacts.add(ptm.Contact__c);
        }

        map<Id, Contact> contactsMap = new map<Id, Contact>([select Id, FirstName, LastName, pse__Salesforce_User__c from Contact where Id in :sContacts]);
        Map<ID, ProjectRole__c> mapOfProjectRoles = new Map<ID, ProjectRole__c> ( [SELECT Active__c, Type__c, Id, Name FROM ProjectRole__c Where Active__c = true] );    
        List<pse__Permission_Control__c> newPermissions = new List<pse__Permission_Control__c>();


        for(ProjectTeamMember__c ptm: newTeamMembers)
        {
            if(contactsMap.get(ptm.contact__c).pse__Salesforce_User__c != null &&
                (mapOfProjectRoles.get(ptm.ProjectRole__c).name == 'Technical Lead' ||
                mapOfProjectRoles.get(ptm.ProjectRole__c).name == 'Finance Lead 2' ||
                mapOfProjectRoles.get(ptm.ProjectRole__c).name == 'Finance Lead' ||
                mapOfProjectRoles.get(ptm.ProjectRole__c).name == 'Project Accountant 2' ||
                mapOfProjectRoles.get(ptm.ProjectRole__c).name == 'Project Accountant' ||
                mapOfProjectRoles.get(ptm.ProjectRole__c).name == 'Project Management Specialist' ||
                mapOfProjectRoles.get(ptm.ProjectRole__c).name == 'CFO or Delegate' ||
                mapOfProjectRoles.get(ptm.ProjectRole__c).name == 'Project Approver' ||
                mapOfProjectRoles.get(ptm.ProjectRole__c).name == 'Project Approver 2' ||
                mapOfProjectRoles.get(ptm.ProjectRole__c).name == 'Task Manager' ||
                mapOfProjectRoles.get(ptm.ProjectRole__c).name == 'Project Manager')
                ){
                    pse__Permission_Control__c permission = new pse__Permission_Control__c();

                    permission.ProjectTeamMember__c = ptm.id;
                    permission.pse__End_Date__c = ptm.enddate__c;
                    permission.pse__Project__c = ptm.project__c;
                    permission.pse__Start_Date__c = ptm.startdate__c;
                    permission.pse__User__c = contactsMap.get(ptm.contact__c).pse__Salesforce_User__c;
                    permission.pse__View_Task_Manager__c = true;
                    newPermissions.add(permission);
            }

            if(contactsMap.get(ptm.contact__c).pse__Salesforce_User__c != null &&
                mapOfProjectRoles.get(ptm.ProjectRole__c).name == 'Deputy Project Manager'){

                    pse__Permission_Control__c permission = new pse__Permission_Control__c();

                    permission.ProjectTeamMember__c = ptm.id;
                    permission.pse__End_Date__c = ptm.enddate__c;
                    permission.pse__Project__c = ptm.project__c;
                    permission.pse__Start_Date__c = ptm.startdate__c;
                    permission.pse__User__c = contactsMap.get(ptm.contact__c).pse__Salesforce_User__c;
                    permission.pse__Edit_Task_Manager__c = true;
                    permission.pse__View_Task_Manager__c = true;
                    newPermissions.add(permission);
            }

        }

        if(newPermissions.size() > 0){
            insert newPermissions;
        }

    }

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
    
    public static void DeleteSharingForTeamMembers(list<ProjectTeamMember__c> deletedTeamMembers, Map<Id, ProjectTeamMember__c> oldProjectsTMMap, Map<Id, ProjectTeamMember__c> newProjectsTMMap) {
        
        system.debug( 'deletedTeamMembers size ' + deletedTeamMembers.size() + ' deletedTeamMembers ' + deletedTeamMembers );
        
        Set<Id> listCon = new Set<Id>();
        Set<Id> listprojectId = new Set<Id>();
        
        for (ProjectTeamMember__c projectTeamMember : deletedTeamMembers) {
            
            if( ( projectTeamMember.Is_Active__c != oldProjectsTMMap.get(projectTeamMember.Id).Is_Active__c ) && ( projectTeamMember.Is_Active__c == false ) )
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
        
        List<pse__Proj__Share> listProjectShare = [ Select Id From pse__Proj__Share Where RowCause = 'Manual' AND UserOrGroupId In :listOfSalesforceUserId and ParentId In :listprojectId ];
        
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