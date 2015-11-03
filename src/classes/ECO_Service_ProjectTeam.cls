public with sharing class ECO_Service_ProjectTeam {


    public static Id getActiveProjectAccountantId(Id projectId)
    {
    	list<ProjectTeamMember__c> teamMembers = [select Id, User__c, Contact__r.pse__Salesforce_User__c from ProjectTeamMember__c where ProjectRole__r.Name = 'Project Accountant' and Project__c = :projectId and Active__c = true];
		if(!teamMembers.isEmpty())
		{
			return teamMembers[0].Contact__r.pse__Salesforce_User__c;
		}
    	return null;
    }


    public static Id getActiveProjectApproverId(Id projectId)
    {
    	list<ProjectTeamMember__c> teamMembers = [select Id, User__c, Contact__r.pse__Salesforce_User__c from ProjectTeamMember__c where ProjectRole__r.Name = 'Project Approver' and Project__c = :projectId and Active__c = true];
		if(!teamMembers.isEmpty())
		{
			return teamMembers[0].Contact__r.pse__Salesforce_User__c;
		}
    	return null;
    }
    
    public static Id getActiveProjectFinanceLead(Id projectId)
    {
    	list<ProjectTeamMember__c> teamMembers = [select Id, User__c, Contact__r.pse__Salesforce_User__c from ProjectTeamMember__c where ProjectRole__r.Name = 'Finance Lead' and Project__c = :projectId and Active__c = true];
		if(!teamMembers.isEmpty())
		{
			return teamMembers[0].Contact__r.pse__Salesforce_User__c;
		}
    	return null;
    }    
    
    public static Id getActiveCFODelegate(Id projectId)
    {
    	list<ProjectTeamMember__c> teamMembers = [select Id, User__c, Contact__r.pse__Salesforce_User__c from ProjectTeamMember__c where ProjectRole__r.Name = 'CFO or Delegate' and Project__c = :projectId and Active__c = true];
		if(!teamMembers.isEmpty())
		{
			return teamMembers[0].Contact__r.pse__Salesforce_User__c;
		}
    	return null;
    }     

    public static Id getProjectManagerFromProjectTeam(Id projectId)
    {
        ProjectRole__c role = [select Id from ProjectRole__c where Name = 'Project Manager'];

        list<ProjectTeamMember__c> projectTeamMembers = [select Id, Role__c, Active__c, Contact__r.pse__Salesforce_User__c from ProjectTeamMember__c 
                                                         where Project__c = :projectId and Active__c = true 
                                                            and ProjectRole__c = :role.Id];    
                                                                     
        if(!projectTeamMembers.isEmpty())
            return projectTeamMembers[0].Contact__r.pse__Salesforce_User__c;
                
        return null;
    }

    public static Id populateProjectAccountant(Id projectId)
    {
        list<ProjectTeamMember__c> teamMembers = [select Id, User__c, Contact__r.pse__Salesforce_User__c from ProjectTeamMember__c where ProjectRole__r.Name = 'Project Accountant' and Project__c = :projectId and Active__c = true];
        if(!teamMembers.isEmpty())
        {
            return teamMembers[0].Contact__r.pse__Salesforce_User__c;
        }
        return null;
    }

    public static Id populateProjectFinanceLead(Id projectId)
    {
        list<ProjectTeamMember__c> teamMembers = [select Id, User__c, Contact__r.pse__Salesforce_User__c from ProjectTeamMember__c where ProjectRole__r.Name = 'Finance Lead' and Project__c = :projectId and Active__c = true];
        if(!teamMembers.isEmpty())
        {
            return teamMembers[0].Contact__r.pse__Salesforce_User__c;
        }
        return null;
    }    

}