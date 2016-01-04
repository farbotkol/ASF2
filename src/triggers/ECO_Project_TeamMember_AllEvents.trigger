trigger ECO_Project_TeamMember_AllEvents on ProjectTeamMember__c ( after update, after insert, before insert, before update, after delete ) {

    system.debug( 'ECO_Project_TeamMember_AllEvents ');
    
    if(trigger.isAfter && trigger.isInsert){
        ECO_Project_TeamMember_Triggers.permissionGanttView(trigger.new);
    }


    if(trigger.isAfter && (!trigger.isDelete) ){ 
        system.debug( 'ECO_Project_TeamMember_AllEvents->CreateSharingForTeamMembers');
        ECO_Project_TeamMember_Triggers.CreateSharingForTeamMembers(trigger.new);
    }
    
    if(trigger.isAfter && trigger.isUpdate){ 
        System.debug( 'Delete Team Member' + trigger.isAfter + ' == ' + trigger.isDelete + ' == ' + trigger.isUpdate );
        ECO_Project_TeamMember_Triggers.DeleteSharingForTeamMembers( trigger.old,  trigger.oldMap, trigger.newMap );
    }    
    
    if( trigger.isBefore && ( trigger.isUpdate || trigger.isInsert ) ){
        ECO_Project_TeamMember_Triggers.handleBeforeInsert(trigger.new);
        ECO_Project_TeamMember_Triggers.setProjectFields(trigger.new);
        
        if( trigger.isUpdate )
        {            
        	ECO_Service_RecordAccess.getProjectRecordAccess( trigger.new );
        }            
    }      
}