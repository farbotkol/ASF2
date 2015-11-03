public class ECO_Service_RecordAccess {
        
    public static Boolean getRecordAccess (Id currentProjectId, String objectName) {

        List<ProjectTeamMember__c> listPTM = [ SELECT Id, Name, User__c, Active__c, projectRole__r.Name FROM ProjectTeamMember__c where Project__c = :currentProjectId and contact__r.pse__Salesforce_User__c = :userinfo.getuserId() ] ;
        
        system.debug( 'listPTM ' + listPTM + ' currentProjectId ' + currentProjectId + ' userinfo.getuserId() ' + userinfo.getuserId() );
        
    	if ( listPTM.IsEmpty() )
        	return false;
        
        String roleName = listPTM[0].projectRole__r.Name;
        
        system.debug( 'Role matched ' + roleName );
        
        List<ECO_SecurityObjectAccess__c> sac = [ select Id from ECO_SecurityObjectAccess__c Where ObjectName__c = :objectName and RoleName__c = :roleName and ReadWriteAccess__c = true ];
        
    	if ( sac.IsEmpty() )
        	return false;
		else
        	return true;
    }
    
    public static Boolean getProjectRecordAccessForApprovalProcess (String nameOfObject, Id projectId ) {
          return true;    
        
        List<SObject> listObjects;
		string uName = UserInfo.getUserName();
        Id id1 = UserInfo.getProfileId();
        Id userId = UserInfo.getUserId();
                        
        List<ECO_SecurityObjectAccessUserExclusions__c> listSOAExcl = [ select Id, User_Name__c from ECO_SecurityObjectAccessUserExclusions__c ];
		system.debug( 'listSOAExcl ' + listSOAExcl );
        
        // If the user is from the list of excuded users (integration and so forth) just return
        for( ECO_SecurityObjectAccessUserExclusions__c soae : listSOAExcl )
        {            
            if( soae.User_Name__c == uName )
            {
				system.debug( ' returning ' );                
                return true;            
            }                
        }
        
        System.debug('******************Profile ID' +id1);
		List<Profile> listProfile = [Select Name from Profile where Id = :id1 Limit 1]; 
            
		if( listProfile.isEmpty() )
            return false;
            
		//system.debug( 'Object name ' + listObjects[0].getSObjectType().getDescribe().getName() + ' listProfile ' + listProfile[0] + 'listObjects size ' + listObjects.size() );

       	system.debug( 'UName ' + uName ); 
        
        if( listProfile[0].Name == 'System Administrator')
        {
            if( uName != 'bobby.hoque@aecom.com.ecosysdev' )
            	return true;          
            
            //if( uName != 'bjacobi@ae.com.ecosysdev' )
            //	return true;
            //	
            
       	}


        system.debug('Running User Id Id: ' + userId);
            
		List <ID> projectIDs = new List <ID> ();
        Map<ID, ID> mapTQTIdToProject = new Map<ID, ID> ();
        
        String TriggerObjectName;
        
        TriggerObjectName = nameOfObject;			
        
        projectIDs.add( projectId );
        
        system.debug( 'TriggerObjectName ' + TriggerObjectName );
   		
        Map<Id, String> mapProjectIDUserRole = new Map<Id, String>();
        
        Map<String, Boolean> mapSOA = new Map<String, Boolean>();
        
        Map<String, ECO_SecurityObjectAccess__c> mapSObA = new Map<String, ECO_SecurityObjectAccess__c>();
        
        List<ProjectTeamMember__c> listPTM = [ SELECT Id, Name, User__c, Project__c, Active__c, ProjectRole__r.Type__c, projectRole__r.Name FROM ProjectTeamMember__c where Project__c IN :projectIDs and contact__r.pse__Salesforce_User__c = :userinfo.getuserId() ] ;

        system.debug( ' listPTM size ' + listPTM.size() + ' ' + listPTM );

        for( ProjectTeamMember__c ptm : listPTM )
        {            
            if( ptm.projectRole__r.Type__c == 'Team member' )
            {
            	// user is a Team member not a key member, so do the default role processing  
            	System.debug( 'Team member processing' )  ;
                
                mapProjectIDUserRole.put( ptm.Project__c, 'Default' );
            }      
            else
            {                
                mapProjectIDUserRole.put( ptm.Project__c, ptm.projectRole__r.Name );
                system.debug( 'listPTM ==>' + ptm.Name + ' Project ' + ptm.Project__c );
            }                
        }
        
        system.debug( ' mapProjectIDUserRole ' + mapProjectIDUserRole );

        List<ECO_SecurityObjectAccess__c> listSOA = [ select Id, ObjectName__c, RoleName__c, ReadWriteAccess__c, SubmitApprovalProcess__c, Error_Description__c from ECO_SecurityObjectAccess__c Where ObjectName__c = :TriggerObjectName ];
        
        for( ECO_SecurityObjectAccess__c soa : listSOA )
        {
            mapSOA.put( soa.RoleName__c, soa.ReadWriteAccess__c );
            mapSObA.put( soa.RoleName__c, soa );
        }	
        
        system.debug( 'TriggerObjectName ' + TriggerObjectName );

        String roleName;
        
        if( mapProjectIDUserRole.ContainsKey( projectId) )
        	roleName = mapProjectIDUserRole.get(projectId); 
        else
            return true;
        
        system.debug( 'roleName 131 ' + roleName );
        
        ECO_SecurityObjectAccess__c soa = mapSObA.get( roleName );
        
        system.debug( 'Soa => ' + soa.SubmitApprovalProcess__c );

        if( soa != null )
        {            
        	return soa.SubmitApprovalProcess__c;
        }
        else
        	return true;              
    }     
    
    public static List<ECO_SecurityObjectAccessUserExclusions__c> listSOAExcl {
        get {
            if (listSOAExcl == null) {
                listSOAExcl = [ select Id, User_Name__c from ECO_SecurityObjectAccessUserExclusions__c ];
            } 

            return listSOAExcl;
        }

        set;
    }
    
    public static List<Profile> listProfile {
        get {
            if (listProfile == null) {
                Id id1 = UserInfo.getProfileId();
                System.debug('******************Profile ID' +id1);
               listProfile = [Select Name from Profile where Id = :id1 Limit 1]; 
            } 

            return listProfile;
        }

        set;
    }
    
    public static void getProjectRecordAccess (List<SObject> listObjects) {
            
        system.debug('***listObjects ' + listObjects);

		string uName = UserInfo.getUserName();
        // Id id1 = UserInfo.getProfileId();
        Id userId = UserInfo.getUserId();
        
        system.debug( 'uName ' + uName );
        
        if( uName != 'john.john@aecom.com' )
            return;        
        
        //if ( uName != 'bobby.hoque@aecom.com.ecosysdev' )
        //    return;

        List<ECO_SecurityObjectAccessUserExclusions__c> listSecurityUserExclusion = [ select Id, User_Name__c from ECO_SecurityObjectAccessUserExclusions__c ];
		system.debug( 'listSecurityUserExclusion ' + listSecurityUserExclusion );

        
        // If the user is from the list of excuded users (integration and so forth) just return
        for( ECO_SecurityObjectAccessUserExclusions__c soae : listSOAExcl )
        {            
            if( soae.User_Name__c == uName )
            {
				system.debug( ' returning ' );                
                return;            
            }                
        }
            
		if( listProfile.isEmpty() )
            return;
            
		system.debug( 'Object name ' + listObjects[0].getSObjectType().getDescribe().getName() + ' listProfile ' + listProfile[0] + 'listObjects size ' + listObjects.size() );

       	system.debug( 'UName ' + uName ); 
        
        if( listProfile[0].Name == 'System Administrator')
        {
            if( uName != 'bobby.hoque@aecom.com.ecosysdev' )
            	return;          
            
            //if( uName != 'bjacobi@ae.com.ecosysdev' )
            //	return;
       	}

        system.debug('Object Created by Id: ' + listObjects[0].get('CreatedById'));
        system.debug('Running User Id Id: ' + userId);
                 
            
		List <ID> projectIDs = new List <ID> ();
        Map<ID, ID> mapTQTIdToProject = new Map<ID, ID> ();
        
        String TriggerObjectName = listObjects[0].getSObjectType().getDescribe().getName();
        
        system.debug( 'TriggerObjectName ' + TriggerObjectName );
   			
        if( TriggerObjectName == 'pse__Proj__c' )
        {            
            for (SObject nextProject : listObjects) {
        		projectIDs.add(nextProject.ID);
            }                
    	}
   		else	
   		if(( TriggerObjectName == 'QuestionnaireSet__c' ) || (  TriggerObjectName == 'BudgetSetupQuestionnaire__c' ) || ( TriggerObjectName == 'Risk__c' ) 
               	|| ( TriggerObjectName == 'ProjectActivities__c' ) || ( TriggerObjectName == 'ProjectAgreement__c') ||  ( TriggerObjectName == 'BudgetHeader__c') 
              	|| ( TriggerObjectName == 'Induction__c' ) || ( TriggerObjectName == 'Deliverable__c' ) || ( TriggerObjectName == 'ProjectCity__c' ) 
           		|| ( TriggerObjectName == 'Funding__c' )  || ( TriggerObjectName == 'ProjectReview__c' )  || ( TriggerObjectName == 'ChangeManager__c' ) 
               	|| ( TriggerObjectName == 'POHeader__c' ) || ( TriggerObjectName == 'ProjectTeamMember__c' ) || ( TriggerObjectName == 'Project_Site__c' ) 
          		|| ( TriggerObjectName == 'Stakeholder__c' ) || ( TriggerObjectName == 'CommunicationPlan__c' ) || ( TriggerObjectName == 'DOARegister__c' )  
                || ( TriggerObjectName == 'DOAApprovalRequest__c' ) || ( TriggerObjectName == 'DOAConditions__c' ) || ( TriggerObjectName == 'VendorSub__c' ) 
                || (TriggerObjectName == 'VendorSite__c' ) || (TriggerObjectName == 'SurveySchedule__c' ) || (TriggerObjectName == 'EarnedValueHeader__c' )  )
        {
            for (SObject nextProject : listObjects) {
        		projectIDs.add(String.valueof(nextProject.get('Project__c')));
            }    

            //Map<Id, dateTime> mapProjectCreateDateTime = new Map<Id, dateTime> ();
            //List<Project_Site__c> listProjectSites = [ Select Id from Project_Site__c Limit 10 ];
        

            system.debug( 'projectIDs QuestionnaireSet__c ' + projectIDs );           
    	}        
   		else	
        if( TriggerObjectName == 'Packages__c' )
        {
            for (SObject nextProject : listObjects) {
        		projectIDs.add(String.valueof(nextProject.get('Scope__c')));
            }    

			system.debug( 'projectIDs Packages__c ' + projectIDs );           
    	}  
   		else	
        if( TriggerObjectName == 'pse__Project_Task__c' )
        {
            for (SObject nextProject : listObjects) {
        		projectIDs.add(String.valueof(nextProject.get('pse__Project__c')));
            }    

			system.debug( 'projectIDs Packages__c ' + projectIDs );           
    	}  
   		else	
        if( ( TriggerObjectName == 'TechnicalQualityTeam__c' ) || ( TriggerObjectName == 'TechnicalQualityReview__c' ) || ( TriggerObjectName == 'DeliverableRevision__c' ) )
        {
            List<TechnicalQualityTeam__c> listTQT  = [ SELECT id, deliverable__r.project__c FROM TechnicalQualityTeam__c WHERE ID IN :listObjects ];
            
            system.debug( '106 listTQT ' + listTQT + ' projectIDs ' + projectIDs );
            
            for (TechnicalQualityTeam__c nextTQT : listTQT) {
        		mapTQTIdToProject.put(nextTQT.id, nextTQT.deliverable__r.project__c);
                projectIDs.add(nextTQT.deliverable__r.project__c);
            } 
    	}  
        
        Map<Id, String> mapProjectIDUserRole = new Map<Id, String>();
        
        Map<String, Boolean> mapSOA = new Map<String, Boolean>();
        
        Map<String, ECO_SecurityObjectAccess__c> mapSObA = new Map<String, ECO_SecurityObjectAccess__c>();
        
        List<ProjectTeamMember__c> listPTM = [ SELECT Id, Name, User__c, Project__c, Active__c, ProjectRole__r.Type__c, projectRole__r.Name FROM ProjectTeamMember__c where Project__c IN :projectIDs and contact__r.pse__Salesforce_User__c = :userinfo.getuserId() ] ;


        system.debug( ' listPTM size ' + listPTM.size() );

        for( ProjectTeamMember__c ptm : listPTM )
        {
            
            if( ptm.projectRole__r.Type__c == 'Team member' )
            {
            	// user is a Team member not a key member, so do the default role processing  
            	System.debug( 'Team member processing' )  ;
                
                mapProjectIDUserRole.put( ptm.Project__c, 'Default' );
            }      
            else
            {                
                mapProjectIDUserRole.put( ptm.Project__c, ptm.projectRole__r.Name );
                system.debug( 'listPTM ==>' + ptm.Name + ' Project ' + ptm.Project__c );
            }                
        }
        
        system.debug( ' mapProjectIDUserRole ' + mapProjectIDUserRole );

        List<ECO_SecurityObjectAccess__c> listSOA = [ select Id, ObjectName__c, RoleName__c, ReadWriteAccess__c, Error_Description__c from ECO_SecurityObjectAccess__c Where ObjectName__c = :TriggerObjectName ];
        
        for( ECO_SecurityObjectAccess__c soa : listSOA )
        {
            mapSOA.put( soa.RoleName__c, soa.ReadWriteAccess__c );
            mapSObA.put( soa.RoleName__c, soa );
        }	
        
        system.debug( 'TriggerObjectName ' + TriggerObjectName + ' mapSOA 305 ' + mapSOA );

        String roleName;
        
        Boolean FirstTimeProjectCreation = false;
            
        for( SObject proj : listObjects )            
        {
           	Boolean hasAccess = true;
            
            if( TriggerObjectName == 'pse__Proj__c' )
            {
                roleName = mapProjectIDUserRole.get( proj.Id );   
                
                DateTime CreateDate = DateTime.valueof(proj.get('CreatedDate')) ; 
                
                DateTime timeNow =  system.now();
                
                Long createTimeSecond = CreateDate.GetTime();
                
                Long currentTimeSecond = timeNow.GetTime();
                
                Decimal Diff = (currentTimeSecond - createTimeSecond) ;
                
                // Under 3000 milliseconds or 3 seconds meaning we are at creation process (Not update).
                if( Diff < 3000 )
                    FirstTimeProjectCreation = true;
                
                system.debug( 'Diff CreateDate -  timeNow ' + CreateDate + ' === ' + timeNow + ' Diff === ' + Diff );
            }
            else	
	   		if(( TriggerObjectName == 'QuestionnaireSet__c' ) || (  TriggerObjectName == 'BudgetSetupQuestionnaire__c' ) || ( TriggerObjectName == 'Risk__c' ) 
               	|| ( TriggerObjectName == 'ProjectActivities__c' ) || ( TriggerObjectName == 'ProjectAgreement__c') ||  ( TriggerObjectName == 'BudgetHeader__c') 
              	|| ( TriggerObjectName == 'Induction__c' ) || ( TriggerObjectName == 'Deliverable__c' ) || ( TriggerObjectName == 'ProjectCity__c' ) 
           		|| ( TriggerObjectName == 'Funding__c' )  || ( TriggerObjectName == 'ProjectReview__c' )  || ( TriggerObjectName == 'ChangeManager__c' ) 
               	|| ( TriggerObjectName == 'POHeader__c' ) || ( TriggerObjectName == 'ProjectTeamMember__c' ) || ( TriggerObjectName == 'Project_Site__c' ) 
          		|| ( TriggerObjectName == 'Stakeholder__c' ) || ( TriggerObjectName == 'CommunicationPlan__c' ) || ( TriggerObjectName == 'DOARegister__c' )  
                || ( TriggerObjectName == 'DOAApprovalRequest__c' ) || ( TriggerObjectName == 'DOAConditions__c' ) || ( TriggerObjectName == 'VendorSub__c' ) 
                || (TriggerObjectName == 'VendorSite__c' ) || (TriggerObjectName == 'SurveySchedule__c' ) || (TriggerObjectName == 'EarnedValueHeader__c' )  )
            {
               	roleName = mapProjectIDUserRole.get(String.valueof(proj.get('Project__c')) ); 
                
                system.debug( 'TriggerObjectName projectIDs 353 ' + projectIDs + ' => ' + TriggerObjectName );

                /*
                DateTime CreateDate = DateTime.valueof(proj.get('CreatedDate')) ; 
                
                DateTime timeNow =  system.now();
                
                Long createTimeSecond = CreateDate.GetTime();
                
                Long currentTimeSecond = timeNow.GetTime();
                
                Decimal Diff = (currentTimeSecond - createTimeSecond) ;
                
                // Under 3000 milliseconds or 3 seconds meaning we are at creation process (Not update).
                if( Diff < 3000 )
                    FirstTimeProjectCreation = true;
                
                system.debug( 'Diff CreateDate -  timeNow ' + CreateDate + ' === ' + timeNow + ' Diff === ' + Diff );
                
                */
                
            }             
            else	
            if( TriggerObjectName == 'Packages__c' )
            {
               	roleName = mapProjectIDUserRole.get(String.valueof(proj.get('Scope__c')) );               
    
                system.debug( 'projectIDs Packages__c ' + projectIDs );           
            }
            else	
            if( TriggerObjectName == 'pse__Project_Task__c' )
            {
               	roleName = mapProjectIDUserRole.get(String.valueof(proj.get('pse__Project__c')) );               
    
                system.debug( 'projectIDs pse__Project_Task__c ' + projectIDs );           
            }
            else	
	        if( ( TriggerObjectName == 'TechnicalQualityTeam__c' ) || ( TriggerObjectName == 'TechnicalQualityReview__c' ) || ( TriggerObjectName == 'DeliverableRevision__c' ) )
            {
                    Id ProjectId = mapTQTIdToProject.get(proj.id);
                    roleName = mapProjectIDUserRole.get(ProjectId);
            }             
            
            system.debug( 'roleName for project ' + roleName + ' ' + proj.Id  );
            string error_desc = '';
            
            // Role blank means no PTM record found for the project and the user
            if( ( String.isblank(roleName) ) || ( roleName == null ) )
            {
                if(( Test.isRunningTest() ) || FirstTimeProjectCreation )
                    return;
                
            	hasAccess = false;  
                error_desc = 'Project Team Member record not found for the user (' + uName + ' | ' + userId + ') while editing object ' + TriggerObjectName;
            }                
            else
            if ( mapSOA.containsKey(roleName) )
            {
                hasAccess = mapSOA.get( roleName );
                
                if( ! hasAccess )
                {
                	error_desc = mapSObA.get( roleName ).Error_Description__c;	    
                    system.debug( 'Error ' + error_desc );
                }   
                
	            system.debug( 'roleName for project ' + roleName + ' hasAccess ' + hasAccess + ' ' + proj.Id  );
            } 
            else
            {
                // PTM is there but NO custom settings found for the Object and role, by default give the user access
                
            }                
            
            if( ! hasAccess )
            {                
                //proj.addError( addErrorMessage );
                proj.addError( error_desc );
            }                
        }    
    }    
}