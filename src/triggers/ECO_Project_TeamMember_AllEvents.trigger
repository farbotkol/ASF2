trigger ECO_Project_TeamMember_AllEvents on ProjectTeamMember__c (after update, after insert, before insert) {

    system.debug( 'ECO_Project_TeamMember_AllEvents ');
    
	if(trigger.isBefore && trigger.isInsert)
		ECO_Project_TeamMember_Triggers.handleBeforeInsert(trigger.new);

    if(trigger.isAfter){ 
        system.debug( 'ECO_Project_TeamMember_AllEvents->CreateSharingForTeamMembers');
        ECO_Project_TeamMember_Triggers.CreateSharingForTeamMembers(trigger.new);
    }
}