public with sharing class ECO_StakeholdersController
{
	public pse__Proj__c oProject {get; set;}
	public List<TeamMember> lActiveMembersKey {get; set;}
	public List<TeamMember> lInactiveMembersKey {get; set;}
	public List<TeamMember> lMembersTeam {get; set;}
	public List<TeamMember> lInactiveMembersTeam {get; set;}
	public List<ProjectRole__c> lProjectRoles {get; set;}
	public List<ProjectTeamMember__c> lProjectTeamMembers {get; set;}
	public List<ProjectTeamMember__c> lProjectKeyMembers {get; set;}
	//public List<VendorSub__c> lVendorSubs {get; set;}
	public List<Stakeholder__c> lStakeholders {get; set;}
	public List<CommunicationPlan__c> lCommPlans {get; set;}
	public list<SurveySchedule__c> lSurveySchedules {get; set;}
	public List<Project_Site__c> lProjectSites {get; set;}
	public List<Account> lAccounts {get; set;}
	public Set<Id> setAccountIds {get; set;}
	public List<ProjectTeamMember__c> lDelete_ProjectTeamMembers {get; set;}
	//public List<VendorSub__c> lDelete_VendorSubs {get; set;}
	public List<Stakeholder__c> lDelete_Stakeholders {get; set;}
	public List<CommunicationPlan__c> lDelete_CommPlans {get; set;}
	public list<SurveySchedule__c> lDelete_SurveySchedules {get; set;}
	public String recordObjectType {get; set;}
	public String recordObjectId {get; set;}
	public ApexPages.StandardController oStandardController {get; set;}
	public Boolean showStakeholderNote {get; set;}
	public Boolean showCommPlanNote {get; set;}
	public Boolean showVacantKeyMemberNote {get; set;}
	


	private void SearchSites(){

    	string strSOQL = 'SELECT ';
    	
    	for (Schema.FieldSetMember fsmField: SObjectType.Project_Site__c.FieldSets.pse_ClientFinder_Display_Fieldset.getFields()) {
    		strSOQL += fsmField.getFieldPath() + ', ';
    	}
    	
    	strSOQL += 'ID, SITE__C, Is_Billing__c, Is_Default_Top_Task__c, Is_End__c, Is_Primary_End__c, Site__r.Account__c  FROM Project_Site__c WHERE Project__c=\'' + oProject.Id + '\'';

    	lProjectSites = (list<Project_Site__c>)Database.query(strSOQL);
	}	


	public ECO_StakeholdersController(ApexPages.StandardController oStandardController) 
	{
		this.oStandardController = oStandardController;
		oProject = (pse__Proj__c)oStandardController.getRecord();
		//System.debug('oProject: ' + oProject);
		if(oProject != null)
		{
			lProjectSites = new list<Project_Site__c>();

			SearchSites();

			lProjectRoles = new List<ProjectRole__c>([Select Id, Name, Type__c From ProjectRole__c Where Active__c = true Order By SortOrder__c ASC]);
			lProjectTeamMembers = new List<ProjectTeamMember__c>([Select Id, ProjectRole__c, ProjectRole__r.Name, ProjectRole__r.Type__c, Contact__c, contact__r.pse__Is_Resource_Active__c, ProjectRoleTitle__c, Project__c, StartDate__c, EndDate__c, Phone__c, Email__c, Active__c From ProjectTeamMember__c Where ProjectRole__r.Type__c = 'Team Member' And Project__c = :oProject.Id]);
			lProjectKeyMembers = new List<ProjectTeamMember__c>([Select Id, ProjectRole__c, Contact__c, ProjectRoleTitle__c, Project__c, StartDate__c, EndDate__c, Phone__c, Email__c, Active__c From ProjectTeamMember__c Where ProjectRole__r.Type__c = 'Key Member' And Project__c = :oProject.Id]);
			//lVendorSubs = new List<VendorSub__c>([Select Id, Account__c, ContactName__c, ServicesType__c, VendorName__c, Phone__c, Email__c From VendorSub__c Where Project__c = :oProject.Id]);
			lStakeholders = new List<Stakeholder__c>([Select Id, StakeholderType__c, Organization__c, ContactName__c, ContactPhone__c, Interest__c, AECOMContact__c From Stakeholder__c Where Project__c = :oProject.Id]);
			lCommPlans = new List<CommunicationPlan__c>([Select Id, When__c, ResponsiblePerson__c, How__c, Frequency__c, Audience__c, Activity__c, GenerateTask__c, ResponsiblePTM__c From CommunicationPlan__c Where Project__c = :oProject.Id]);

			//lProjectSites = new List<Project_Site__c>([Select Site__r.Account__c, Site__r.Account__r.Name From Project_Site__c Where Project__c = :oProject.Id]);
			lSurveySchedules = new list<SurveySchedule__c>([select Id, Name, Comments__c, ScheduledDate__c from SurveySchedule__c]);
			showStakeholderNote = false;
			showCommPlanNote = false;
			showVacantKeyMemberNote = false;
			if(lStakeholders.isEmpty())
				 showStakeholderNote = true;
			if(lCommPlans.isEmpty())
				showCommPlanNote = true;

			setAccountIds = new Set<Id>();
			for(Project_Site__c oPS : lProjectSites)
			{
				setAccountIds.add(oPS.Site__r.Account__c);
			}
			lAccounts = getClientInfo();
			
			lActiveMembersKey = new List<TeamMember>();
			lInactiveMembersKey = new List<TeamMember>();
			lMembersTeam = new List<TeamMember>();
			lInactiveMembersTeam = new List<TeamMember>();

			for(ProjectRole__c pr : lProjectRoles)
			{
				if(pr.Type__c == 'Key Member')
				{
					TeamMember tm = new TeamMember(oProject, lProjectRoles);
					tm.RoleID = pr.Id;
					tm.RoleName = pr.Name;
					tm.RoleType = pr.Type__c;
					for(ProjectTeamMember__c pkm : lProjectKeyMembers)
					{
						if(pkm.Contact__c != null)
						{
							if(pr.Id == pkm.ProjectRole__c)
							{
								if(!pkm.Active__c)
								{
									TeamMember inactiveTM = new TeamMember(oProject, lProjectRoles);
									inactiveTM.RoleID = pr.Id;
									inactiveTM.RoleName = pr.Name;
									inactiveTM.RoleType = pr.Type__c;
									inactiveTM.oPTM = pkm;
									lInactiveMembersKey.add(inactiveTM);
								}
								else
								{
									tm.oPTM = pkm;
								}
							}
						}
					}
					lActiveMembersKey.add(tm);
				}
			}
			
			for(TeamMember tm : lActiveMembersKey)
			{
				if(tm.oPTM.Contact__c == null)
				{
					showVacantKeyMemberNote = true;
					break;
				}
			}
			
			for(ProjectTeamMember__c ptm : lProjectTeamMembers)
			{
				if(ptm.Contact__c != null)
				{
					TeamMember tm = new TeamMember(oProject, lProjectRoles);
					tm.RoleID = ptm.ProjectRole__c;
					tm.RoleName = ptm.ProjectRole__r.Name;
					tm.RoleType = ptm.ProjectRole__r.Type__c;
					tm.oPTM = ptm;

					if(ptm.contact__r.pse__Is_Resource_Active__c){
						lMembersTeam.add(tm);
					} else {
						lInactiveMembersTeam.add(tm);
					}
					
				}	
			}
			
			if(lMembersTeam.isEmpty())
			{
				TeamMember tm = new TeamMember(oProject, lProjectRoles);
				tm.RoleType = 'Team Member';
				lMembersTeam.add(tm);
			}

			//if(lVendorSubs.isEmpty())
			//	lVendorSubs.add(new VendorSub__c(Project__c = oProject.Id));
				
			if(lStakeholders.isEmpty())
				lStakeholders.add(new Stakeholder__c(Project__c = oProject.Id));
				
			if(lCommPlans.isEmpty())
				lCommPlans.add(new CommunicationPlan__c(Project__c = oProject.Id));
			
			lDelete_ProjectTeamMembers = new List<ProjectTeamMember__c>();
			//lDelete_VendorSubs = new List<VendorSub__c>();
			lDelete_Stakeholders = new List<Stakeholder__c>();
			lDelete_CommPlans = new List<CommunicationPlan__c>();
			lDelete_SurveySchedules = new list<SurveySchedule__c>();
		}
	}
	
	public List<Schema.FieldSetMember> getAccountBasicListFields()
	{
		return SObjectType.Account.FieldSets.Basic_List_Set.getFields();
	}
	
	public List<Account> getClientInfo()
	{
		List<Account> lAccounts = new List<Account>();
		if(setAccountIds.size() > 0)
		{
			String query = 'SELECT Id';
			for(Schema.FieldSetMember f : getAccountBasicListFields()) 
			{
	            query += ', ' + f.getFieldPath();
	        }
	        query += ' FROM Account WHERE Id In :setAccountIds';
	        lAccounts = Database.query(query);
		}
		return lAccounts;
	}

	public PageReference ReturnToProject()
	{
		PageReference oPR = new PageReference('/' + oProject.Id);
		oPR.setRedirect(true);
		return oPR;
	}
	
	private Boolean isValid()
	{
		List<TeamMember> lAllKeyMembers = new List<TeamMember>();
		lAllKeyMembers.addAll(lActiveMembersKey);
		lAllKeyMembers.addAll(lInactiveMembersKey);
		for(TeamMember tm1 : lAllKeyMembers)
		{
			for(TeamMember tm2 : lAllKeyMembers)
			{
				if(tm1.oPTM.Id != tm2.oPTM.Id)
				{
					String contactID1 = tm1.oPTM.Contact__c;
					String contactID2 = tm2.oPTM.Contact__c;
					String roleID1 = tm1.RoleID;
					String roleID2 = tm2.RoleID;
					//make sure the same person or role is not represented twice during the same time frame
					if( (contactID1 != null) && (contactID1 == contactID2 || roleID1 == roleID2) )
					{                        
                        
						Date startDate1 = tm1.oPTM.StartDate__c;
						Date startDate2 = tm2.oPTM.StartDate__c;
						Date endDate1 = tm1.oPTM.EndDate__c;
						Date endDate2 = tm2.oPTM.EndDate__c;
						if(endDate1 == null)
						{
							endDate1 = Date.newInstance(2199,12,31);
						}
						if(endDate2 == null)
						{
							endDate2 = Date.newInstance(2199,12,31);
						}
						if( (startDate1 != null) && ((startDate1 >= startDate2 && startDate1 <= endDate2) || (endDate1 >= startDate2 && endDate1 <= endDate2)) )
						{
							System.debug('overlapping dates!');
                            system.debug( 'contactID1 ' + contactID1 + ' ' + startDate1 );
							ApexPages.Message oPageMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Please ensure that the same person or role (active or inactive) is not assigned twice during the same time frame.');
		            		ApexPages.addMessage(oPageMessage);
		            		tm1.oPTM.Contact__c.addError('Conflicts with another role!');
		            		tm2.oPTM.Contact__c.addError('Conflicts with another role!');
							return false;
						}
					}
				}
			}
		}
		return true;
	}
	
	public PageReference SaveAll()
	{
		PageReference oPR;

		if(isValid())
		{
			lProjectTeamMembers.clear();
            
            //system.debug( 'lActiveMembersKey =>' + lActiveMembersKey );
            
            //List<ProjectShare> sharesToCreate = new List<ProjectShare>();
            
			for(TeamMember tm : lActiveMembersKey)
			{
				if(tm.oPTM.Contact__c != null)
				{
					tm.oPTM.ProjectRole__c = tm.RoleID;
					tm.oPTM.Is_Active__c = true;
					lProjectTeamMembers.add(tm.oPTM);
					if(tm.RoleName == 'Project Manager')
					{
						oProject.pse__Project_Manager__c = tm.oPTM.Contact__c;
					}
					if(tm.RoleName == 'Project Approver 2')
					{
						oProject.PnLManager__c = tm.oPTM.Contact__c;
					}					
                    
                    system.debug( 'Name =>' + tm.oPTM.Contact__r.name + ' ' + tm.oPTM.Contact__r.pse__Salesforce_User__c + ' ' +  tm.oPTM.Contact__r.name );                    
				}
			}
			for(TeamMember tm : lInactiveMembersKey)
			{
				if(tm.oPTM.Contact__c != null)
				{
					tm.oPTM.ProjectRole__c = tm.RoleID;
					tm.oPTM.Is_Active__c = false;
					lProjectTeamMembers.add(tm.oPTM);
				}
			}
			for(TeamMember tm : lMembersTeam)
			{
				if(tm.oPTM.Contact__c != null)
				{
					tm.oPTM.ProjectRole__c = tm.RoleID;
					lProjectTeamMembers.add(tm.oPTM);
				}
			}
			/*
			for(Integer i=0; i<lVendorSubs.size(); i++)
			{
				if(lVendorSubs[i].Account__c == null || lVendorSubs[i].VendorName__c == null)
					lVendorSubs.remove(i);
			}
			*/
			for(Integer i=0; i<lStakeholders.size(); i++)
			{
				if(lStakeholders[i].StakeholderType__c == null)
					lStakeholders.remove(i);
			}
			for(Integer i=0; i<lCommPlans.size(); i++)
			{
				if(lCommPlans[i].Activity__c == null)
				 	lCommPlans.remove(i);
			}

			for(Integer i=0; i<lSurveySchedules.size(); i++)
			{
				if(lSurveySchedules[i].ScheduledDate__c == null)
					lSurveySchedules.remove(i);
			}			
			
			try
			{
				oStandardController.save();
				upsert lProjectTeamMembers;
                system.debug( 'lProjectTeamMembers =>' + lProjectTeamMembers.size() );
				//upsert lVendorSubs;
				upsert lStakeholders;
				upsert lCommPlans;
				upsert lSurveySchedules;
				delete lDelete_ProjectTeamMembers;
                system.debug( 'lDelete_ProjectTeamMembers =>' + lDelete_ProjectTeamMembers.size() );
				//delete lDelete_VendorSubs;
				delete lDelete_Stakeholders;
				delete lDelete_CommPlans;
				delete lDelete_SurveySchedules;
				update oProject;
				//ApexPages.Message oPageMessage = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Saved successfully.');
				//ApexPages.addMessage(oPageMessage);
				System.debug('Saved successfully. Reloading page..');
				oPR = ApexPages.currentPage();
				oPR.getParameters().clear();
				oPR.getParameters().put('id', oProject.Id);
				oPR.setRedirect(true);
			}
			catch(DMLException e)
			{
				System.debug('Error: ' + e.getMessage());
				//ApexPages.Message oPageMessage = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
				ApexPages.addMessages(e);
				for (Integer i = 0; i < e.getNumDml(); i++) 
				{
					for(ProjectTeamMember__c oPTM : lProjectTeamMembers)
					{
						if(oPTM.Id == e.getDmlId(i))
						{
							oPTM.Contact__c.addError('Please correct');
						}
					}
				}
			}
		}
		return oPR;
	}
	
	public void addRecord()
	{
		/*
		if(recordObjectType == 'VendorSub__c')
		{
			lVendorSubs.add(new VendorSub__c(Project__c = oProject.Id));
		}
		*/
		if(recordObjectType == 'MembersTeam')
		{
			TeamMember tm = new TeamMember(oProject, lProjectRoles);
			tm.RoleType = 'Team Member';
			lMembersTeam.add(tm);
		}
		else if(recordObjectType == 'KeyMember')
		{
			TeamMember tm = new TeamMember(oProject, lProjectRoles);
			tm.RoleType = 'Key Member';
			lActiveMembersKey.add(tm);
		}
		else if(recordObjectType == 'Stakeholder__c')
		{
			lStakeholders.add(new Stakeholder__c(Project__c = oProject.Id));
		}
		else if(recordObjectType == 'CommunicationPlan__c')
		{
			lCommPlans.add(new CommunicationPlan__c(Project__c = oProject.Id));
		}
		else if(recordObjectType == 'SurveySchedule__c')
		{
			lSurveySchedules.add(new SurveySchedule__c());
		}
		
	}
	
	public PageReference defaultDates(){
		for(TeamMember tm:lActiveMembersKey){
			if(tm.oPTM.StartDate__c == null && tm.oPTM.Contact__c != null){
				tm.oPTM.StartDate__c = oProject.EstimatedStartDate__c;
			}
		}
		return null;
	}

	public void removeRecord()
	{
		/*
		if(recordObjectType == 'VendorSub__c')
		{
			for(Integer i=0; i<lVendorSubs.size(); i++)
			{
				if(lVendorSubs[i].Id == recordObjectId)
					lDelete_VendorSubs.add(lVendorSubs.remove(i));
			}
		}
		*/
		if(recordObjectType == 'MembersTeam')
		{
			for(Integer i=0; i<lProjectTeamMembers.size(); i++)
			{
				if(lProjectTeamMembers[i].Id == recordObjectId)
					lDelete_ProjectTeamMembers.add(lProjectTeamMembers.remove(i));
			}
			for(Integer i=0; i<lMembersTeam.size(); i++)
			{
				if(lMembersTeam[i].oPTM.Id == recordObjectId)
					lMembersTeam.remove(i);
			}
		}
		else if(recordObjectType == 'Stakeholder__c')
		{
			for(Integer i=0; i<lStakeholders.size(); i++)
			{
				if(lStakeholders[i].Id == recordObjectId)
					lDelete_Stakeholders.add(lStakeholders.remove(i));
			}
		}
		else if(recordObjectType == 'CommunicationPlan__c')
		{
			for(Integer i=0; i<lCommPlans.size(); i++)
			{
				if(lCommPlans[i].Id == recordObjectId)
					lDelete_CommPlans.add(lCommPlans.remove(i));
			}
		}
		else if(recordObjectType == 'SurveySchedule__c')
		{
			for(Integer i=0; i<lSurveySchedules.size(); i++)
			{
				if(lSurveySchedules[i].Id == recordObjectId)
					lDelete_SurveySchedules.add(lSurveySchedules.remove(i));
			}
		}		
		
	}
	
	Class TeamMember
	{
		public pse__Proj__c oProject {get; set;}
		public List<ProjectRole__c> lProjectRoles {get; set;}
		public String RoleID {get; set;}
		public String RoleName {get; set;}
		public String RoleType {get; set;}
		public ProjectTeamMember__c oPTM {get; set;}
		public List<SelectOption> lTeamRoleTypes {get; set;}
		public List<SelectOption> lKeyRoleTypes {get; set;}

		public TeamMember(pse__Proj__c proj, List<ProjectRole__c> prList)
		{
			this.oPTM = new ProjectTeamMember__c();
			this.oProject = proj;
			this.lProjectRoles = prList;
			oPTM.Project__c = oProject.Id;
			lTeamRoleTypes = new List<SelectOption>();
			lTeamRoleTypes.add(new SelectOption('', '--None--'));
			lKeyRoleTypes = new List<SelectOption>();
			lKeyRoleTypes.add(new SelectOption('', '--None--'));
			
			for(ProjectRole__c pr : lProjectRoles)
			{
				if(pr.Type__c == 'Team Member')
				{
					lTeamRoleTypes.add(new SelectOption(pr.Id, pr.Name));
				}
				else if(pr.Type__c == 'Key Member')
				{
					lKeyRoleTypes.add(new SelectOption(pr.Id, pr.Name));
				}
			}
		}
	}
}