public with sharing class ECO_ProjectTeamFlyoutController {

	public id sProjectId {get; set;}
	private boolean bInitialDefault;
	public List<SelectOption> lTeamRoleTypes {get; set;}	

	public ECO_ProjectTeamFlyoutController() {
		oProjectTeamMember = new ProjectTeamMember__c();
        bInitialDefault = true;
		lTeamRoleTypes = new List<SelectOption>();
		lTeamRoleTypes.add(new SelectOption('', '--None--'));     
		for(ProjectRole__c role:[Select Id, Name, Type__c From ProjectRole__c Where Active__c = true and Type__c = 'Team Member' Order By Name ASC]) 
		{
			lTeamRoleTypes.add(new SelectOption(role.Id, role.Name));
		}  
	}
	
	public ProjectTeamMember__c oProjectTeamMember {
    
    	get{
            if(bInitialDefault){
            	 oProjectTeamMember.Project__c = sProjectId;
                //oProjectTeamMember.PlanElement__c = sPlanElement;
                //sFilterCriteria = sPlanElement;
                bInitialDefault = false;
            }

            return oProjectTeamMember;
        }

        set;
	}
	
	public list<ProjectTeamMember__c> lProjectTeamMembers {
        get{
            string sSOQL = 'SELECT ';

            //for (Schema.FieldSetMember fsmField: SObjectType.Risk__c.FieldSets.RiskFlyoutDisplayFields.getFields()) {
            //     sSOQL += fsmField.getFieldPath() + ', ';
            //}

            sSOQL += ' Id, Name, Contact__c, ProjectRoleTitle__c, Email__c, Phone__c, ProjectRole__c, ProjectRole__r.Type__c FROM ProjectTeamMember__c WHERE Project__c =\'' + sProjectId + '\'';
//            sSOQL += ' and ProjectRole__r.Type__c = \'' + 'Team Member' + '\'';
            sSOQL += ' and (ProjectRole__r.Type__c = \'' + 'Team Member' + '\' or  (ProjectRole__r.Type__c = \'' + 'Key Member' + '\' AND Active__c = true))';


            
//            if(ECO_Utils_String.NullCheck(sFilterCriteria) != ''){
//                sSOQL += ' and PlanElement__c = \'' + sFilterCriteria + '\'';
//            }

            sSOQL += ' ORDER BY Name';

            return (list<ProjectTeamMember__c>)Database.query(sSOQL);
        }

        set;
	}
	


	public PageReference saveTeamMember()
	{
        try {
           
            insert oProjectTeamMember;
        } catch (Exception e) {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attmpting to save risk: ' + e);
            ApexPages.addMessage(oMsg);
            return null;
        }       

        oProjectTeamMember = new ProjectTeamMember__c();
        return null;		
	}	
}