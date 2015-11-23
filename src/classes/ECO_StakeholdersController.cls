public with sharing class ECO_StakeholdersController
{
	public pse__Proj__c oProject {get; set;}
	public List<TeamMember> lActiveMembersKey {get; set;}
	public List<TeamMember> lInactiveMembersKey {get; set;}
	public List<TeamMember> lMembersTeam {get; set;}
	public List<TeamMember> lInactiveMembersTeam {get; set;}
	public List<ProjectRole__c> lProjectRoles {get; set;}
	public List<ProjectTeamMember__c> lProjectTeamMembers {get; set;}
	public Map<Id, List<ProjectTeamMember__c>> lProjectKeyMembers {get; set;}
	public List<Stakeholder__c> lStakeholders {get; set;}
	public List<CommunicationPlan__c> lCommPlans {get; set;}
	public list<SurveySchedule__c> lSurveySchedules {get; set;}
	public List<Project_Site__c> lProjectSites {get; set;}
	public List<Account> lAccounts {get; set;}
	public Set<Id> setAccountIds {get; set;}
	public String recordObjectType {get; set;}
	public String recordObjectId {get; set;}
	public ApexPages.StandardController oStandardController {get; set;}
	public Boolean showStakeholderNote {get; set;}
	public Boolean showCommPlanNote {get; set;}
	public Boolean showVacantKeyMemberNote {get; set;}
    public list<SelectOption> clients { get; set; }
    public map<id, list<SelectOption>> mapClient2Contact{ get; set; }
    public list<ScheduleWrapper> lstSSW {get;set;} 
    public map<id, id> mapSiteToAccount { get; set; }
    public ProjectTeamMember__c insertReplaceProjectTeamMember{get; set;}
    public String userSelectQueryType{get; set;}
    public List<Contact> queryDelegates{get; set;}
    public Boolean saveError{get; set;}
    public Contact pAndLTeamMember{get; set;}
    public Contact financeTeamMember{get; set;}
    private static Set<String> financeRoles = new Set<String>{'Project Accountant', 'Project Accountant 2', 'Finance Lead', 'Finance Lead 2'};

    //constructor
	public ECO_StakeholdersController(ApexPages.StandardController oStandardController) 
	{
		this.oStandardController = oStandardController;
		oProject = (pse__Proj__c)oStandardController.getRecord();
		initStakeHolders(oProject);
		resetModalValues();
	}

	//returns a string of the current url to the page
	public String returnURL{
		get{
			return ApexPages.currentPage().getUrl();
		}	
		set;
	}

	private void SearchSites(){

    	string strSOQL = 'SELECT ';
    	
    	for (Schema.FieldSetMember fsmField: SObjectType.Project_Site__c.FieldSets.pse_ClientFinder_Display_Fieldset.getFields()) {
    		strSOQL += fsmField.getFieldPath() + ', ';
    	}
    	
    	strSOQL += 'ID, SITE__C, Is_Billing__c, Is_Default_Top_Task__c, Is_End__c, Is_Primary_End__c, Site__r.Account__c  FROM Project_Site__c WHERE Project__c=\'' + oProject.Id + '\'';

    	lProjectSites = (list<Project_Site__c>)Database.query(strSOQL);

    	clients = new list<SelectOption>(); 

    	set<id> lstSiteID = new set<id>();
    	set<id> lstAccountID = new set<id>();

    	mapSiteToAccount = new map<id, id>(); 

    	clients.add(new SelectOption('', ''));

        for(Project_Site__c p:lProjectSites){
            mapSiteToAccount.put(p.SITE__C, p.Site__r.Account__c);
            clients.add(new SelectOption(p.SITE__C, p.Account_Name__c));
            lstAccountID.add(p.Site__r.Account__c);
        }

        mapClient2Contact = new map<id, list<SelectOption>>();

        for(contact c:[select id, lastname, firstname, OracleContactID__c, site__c, accountid from contact where accountid IN: lstAccountID]){
        	if(!mapClient2Contact.containskey(c.site__c)){
        		mapClient2Contact.put(c.accountid, new list<SelectOption>());
        	} 

        	mapClient2Contact.get(c.accountid).add(new SelectOption(c.id, c.lastname + ', ' + c.firstname));
        }

	}	
	
	//initializes all of the data list on the page
	public void initStakeHolders(pse__Proj__c thisProject) {	
		if(thisProject != null)
		{
			lProjectSites = new list<Project_Site__c>();
			lProjectTeamMembers = new List<ProjectTeamMember__c>();
			lProjectKeyMembers = new Map<Id, List<ProjectTeamMember__c>>();

			SearchSites();

			lProjectRoles = new List<ProjectRole__c>([Select Id, Name, Type__c From ProjectRole__c Where Active__c = true Order By SortOrder__c ASC]);
            
            List<ProjectTeamMember__c> projectTeamMembers = new List<ProjectTeamMember__c>([Select Id, ProjectRole__c, ProjectRole__r.Name, ProjectRole__r.Type__c, Contact__c, Contact__r.Name, Contact__r.pse__Is_Resource_Active__c, Contact__r.pse__Salesforce_User__c, Status__c, ProjectRoleTitle__c, Project__c, StartDate__c, EndDate__c, Phone__c, Email__c, Active__c, Is_Active__c From ProjectTeamMember__c Where Project__c = :thisProject.Id]);
			
			lStakeholders = new List<Stakeholder__c>([Select Id, StakeholderType__c, Organization__c, ContactName__c, ContactPhone__c, Interest__c, AECOMContact__c From Stakeholder__c Where Project__c = :thisProject.Id]);
			
			lCommPlans = new List<CommunicationPlan__c>([Select Id, When__c, ResponsiblePerson__c, How__c, Frequency__c, Audience__c, Activity__c, GenerateTask__c, ResponsiblePTM__c From CommunicationPlan__c Where Project__c = :thisProject.Id]);

			lSurveySchedules = new list<SurveySchedule__c>([select Id, Name, Comments__c, ScheduledDate__c, Client__c, Contact__c, Site_Account__c from SurveySchedule__c Where Project__c = :thisProject.Id]);

			lstSSW = new list<ScheduleWrapper>();

			for(ProjectTeamMember__c projectTeamMember : projectTeamMembers){
				if(projectTeamMember.ProjectRole__r.Type__c == 'Key Member'){
					List<ProjectTeamMember__c> projectMembers = new List<ProjectTeamMember__c>();
					if(lProjectKeyMembers.containsKey(projectTeamMember.ProjectRole__c)){
						projectMembers = lProjectKeyMembers.get(projectTeamMember.ProjectRole__c);
					}
					projectMembers.add(projectTeamMember);
					lProjectKeyMembers.put(projectTeamMember.ProjectRole__c, projectMembers);
					if(projectTeamMember.ProjectRole__r.Name == 'Project Approver 2' && pAndLTeamMember == null){
						pAndLTeamMember = projectTeamMember.Contact__r;
					}
					if(projectTeamMember.ProjectRole__r.Name == 'Finance Lead' && financeTeamMember == null){
						financeTeamMember = projectTeamMember.Contact__r;
					}
				}
				else{
                    //if(projectTeamMember.ProjectRole__r.Name != 'Inactive Deliverable Owner')
						lProjectTeamMembers.add(projectTeamMember);
				}
			}
            
			//create wrapper versions of the surveyschedules			
			if(lSurveySchedules.size() > 0){
				Integer surveyCounter = 0;
				List<Id> siteIds = new List<Id>();
				for(SurveySchedule__c ss: lSurveySchedules){
					siteIds.add(ss.Client__c);
				}

				Map<Id, Site__c> siteMap = new Map<Id, Site__c>([Select Id, Account__c from Site__c where Id IN : siteIds]);
				List<Id> accountIds = new List<Id>();
				for(Site__c site : siteMap.values()){
					accountIds.add(site.Account__c);
				}
				Map<Id, Account> accountIdMap = new Map<Id, Account>([Select Id, (Select Id, Name, AccountId from Contacts order by Name) from Account where Id IN: accountIds]);

				for(SurveySchedule__c ss: lSurveySchedules){
					if(accountIdMap != null && siteMap != null && siteMap.containsKey(ss.Client__c) && accountIdMap.containsKey(siteMap.get(ss.Client__c).Account__c) && accountIdMap.get(siteMap.get(ss.Client__c).Account__c).Contacts != null ){
						List<Contact> contacts = accountIdMap.get(siteMap.get(ss.Client__c).Account__c).Contacts;
						lstSSW.add(new ScheduleWrapper(ss, surveyCounter, contacts));
						++surveyCounter;
					}
				}
			}

			setOptions();

			showStakeholderNote = false;
			showCommPlanNote = false;
			showVacantKeyMemberNote = false;
			if(lStakeholders.isEmpty()){
				showStakeholderNote = true;
			}
			if(lCommPlans.isEmpty()){
				showCommPlanNote = true;
			}

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

			//load Key Roles Data Table
			for(ProjectRole__c pr : lProjectRoles)
			{
				if(pr.Type__c == 'Key Member')
				{
					
					if(lProjectKeyMembers.containsKey(pr.Id)){
						for(Integer i=0; i < lProjectKeyMembers.get(pr.Id).size(); i++)
						{
							ProjectTeamMember__c pkm = lProjectKeyMembers.get(pr.Id)[i];
							TeamMember teamMember = createNewTeamMember(thisProject, pr);
							
							if(pkm.Contact__c != null)
							{
								if(!pkm.Active__c)
								{
									TeamMember inactiveTM = createNewTeamMember(thisProject, pr);
									inactiveTM.oPTM = pkm;
									lInactiveMembersKey.add(inactiveTM);
								}
								else
								{
									teamMember.canEdit = canEditKeyMember(pkm.ProjectRole__r.Name);
									teamMember.oPTM = pkm;
									lActiveMembersKey.add(teamMember);
								}
							}
						}
					}
					else{
						TeamMember teamMember = createNewTeamMember(thisProject, pr);
						teamMember.canEdit = canEditKeyMember(pr.Name);
						lActiveMembersKey.add(teamMember);
					}
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
					List<ProjectRole__c> sortedProjectRoles = lProjectRoles;
					sortedProjectRoles.sort();
					TeamMember tm = new TeamMember(thisProject, lProjectRoles);
					tm.RoleID = ptm.ProjectRole__c;
					tm.RoleName = ptm.ProjectRole__r.Name;
					tm.RoleType = ptm.ProjectRole__r.Type__c;
					tm.oPTM = ptm;

					if(ptm.contact__r.pse__Is_Resource_Active__c && ptm.Is_Active__c ){
						lMembersTeam.add(tm);
					} else {
						lInactiveMembersTeam.add(tm);
					}
					
				}	
			}
			
			if(lMembersTeam.isEmpty())
			{
				List<ProjectRole__c> sortedProjectRoles = lProjectRoles;
				sortedProjectRoles.sort();
				TeamMember tm = new TeamMember(thisProject, lProjectRoles);
				tm.RoleType = 'Team Member';
				lMembersTeam.add(tm);
			}

			if(lStakeholders.isEmpty()){
				lStakeholders.add(new Stakeholder__c(Project__c = thisProject.Id));
			}
		}
	}

	//does the current project have all of the necessary default team members assigned to allow editing?
	private Boolean canEditKeyMember(String projectRoleName){
		if(projectRoleName == 'CFO or Delegate'){
			return false;
		}
		else if(financeRoles.contains(projectRoleName) && financeTeamMember != null){
			if(projectRoleName == 'Finance Lead' && financeTeamMember.pse__Salesforce_User__c == UserInfo.getUserId()){
				return true;
			}
			else if(projectRoleName == 'Finance Lead'){
				return false;
			}
			else{
				return true;
			}
		}
		else if(pAndLTeamMember != null && !financeRoles.contains(projectRoleName)){
			if(projectRoleName == 'Project Approver 2' && pAndLTeamMember.pse__Salesforce_User__c == UserInfo.getUserId()){
				return true;
			}
			else if(projectRoleName == 'Project Approver 2'){
				return false;
			}
			else{
				return true;
			}
		}
		return false;
	}

	//creates a new TeamMember wrapper object
	private TeamMember createNewTeamMember(pse__Proj__c thisProject, ProjectRole__c projectRole){
		TeamMember teamMember = new TeamMember(thisProject, lProjectRoles);
		teamMember.RoleID = projectRole.Id;
		teamMember.RoleName = projectRole.Name;
		teamMember.RoleType = projectRole.Type__c;
		return teamMember;
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

	//resets all fields in modal window after closing the window
	public PageReference resetModalValues(){
		insertReplaceProjectTeamMember = new ProjectTeamMember__c();
		userSelectQueryType = 'Delegate';
		saveError = false;
		queryDelegates = null;
		return null;
	}

	//button that returns to project page
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
                    String roleName = tm2.RoleName;
                
					//make sure the same person or role is not represented twice during the same time frame
					if( (contactID1 != null) && (contactID1 == contactID2 || (roleID1 == roleID2 && roleName != 'Deputy Project Manager' ) ))
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
            
            Set<Id> contactIdsOfTeamMembers = new Set<Id>();

            for(TeamMember tm : lActiveMembersKey)
			{
                system.debug( 'tm.oPTM.Contact__c ' + tm.oPTM.Contact__c );
				if(tm.oPTM.Contact__c != null)
				{
            		contactIdsOfTeamMembers.add( tm.oPTM.Contact__c );
				}
			}
            
			Map<ID, Contact> mapOfContactRecordsForTeamMembers = new Map<ID, Contact> ( [SELECT Id, name, pse__Salesforce_User__r.ProjectAccountantAuthority__c, pse__Salesforce_User__r.ProjectManagerAuthority__c FROM Contact WHERE Id IN :contactIdsOfTeamMembers] );
            
			Contact conTM ;	
            
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
				if(lSurveySchedules[i].ScheduledDate__c == null){
					lSurveySchedules.remove(i);
					lstSSW.remove(i);
				}
			}			
			
			try
			{
				oStandardController.save();
				upsert lProjectTeamMembers;
				upsert lStakeholders;
				upsert lCommPlans;
				upsert lSurveySchedules;
				update oProject;
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

	//resets the queryDelegates list so the modal table will not show
	public PageReference resetQueryTable(){
		queryDelegates = new List<Contact>();
		return null;
	}

	//queries for the key member in the search parameters on the modal window
	public PageReference searchForKeyMembers(){
		String queryContactName = ApexPages.currentPage().getParameters().get('contactName');
		String queryType = ApexPages.currentPage().getParameters().get('queryType');
		String selectedRole = ApexPages.currentPage().getParameters().get('selectedRole');
		String startDate = ApexPages.currentPage().getParameters().get('startDate');
		String contactQuery = 'Select Id, Name, Title, Email, Phone, ReportsTo.Name from Contact Where pse__Is_Resource__c = true and pse__Is_Resource_Active__c = true and pse__Salesforce_User__r.isActive = true';
		String firstName;
		String lastName;

		if(queryContactName != null && queryContactName != ''){
			if(queryContactName.trim().contains(' ')){
				List<String> nameSplit = queryContactName.trim().split(' ');
				firstName = String.escapeSingleQuotes(nameSplit[0].replace(',', ''));
				lastName = String.escapeSingleQuotes(nameSplit[nameSplit.size() - 1].replace(',', ''));
			}
			else{
				firstName = String.escapeSingleQuotes(queryContactName);
			}
		}
		if(queryType == 'Delegate'){
			String delegateQuery = 'Select Delegate__c, Allowed_Organizations__c From Delegate__c';
			if(queryContactName != null && queryContactName != ''){
				delegateQuery += ' Where Delegate__r.FirstName Like \'' + firstName + '%\'';
				if(lastName != null){
					delegateQuery += ' AND Delegate__r.LastName Like \'' + lastName + '%\'';
				}
			}
			if(selectedRole != null && selectedRole != 'undefined' && selectedRole != ''){
				if(delegateQuery.contains('Where')){
					delegateQuery += ' AND';
				}
				else{
					delegateQuery += ' Where';
				}
				if(selectedRole == 'Finance Lead 2'){
					RecordType alternateRecordType = [Select Id from RecordType where SObjectType = 'Delegate__c' AND DeveloperName = 'Alternate'];
					delegateQuery += ' RecordTypeId = \'' + alternateRecordType.Id + '\'';
				}
				else{
					if(selectedRole == 'Project Accountant 2'){
						selectedRole = 'Project Accountant';
					}
					delegateQuery += ' Key_Member_Role__c = \'' + selectedRole + '\'';
				}
			}
			if(pAndLTeamMember != null || financeTeamMember != null){
				if(delegateQuery.contains('Where')){
					delegateQuery += ' AND';
				}
				else{
					delegateQuery += ' Where';
				}
				if(financeRoles.contains(selectedRole)){
					delegateQuery += ' Delegator__c = \'' + financeTeamMember.Id + '\'';
				}
				else{
					delegateQuery += ' Delegator__c = \'' + pAndLTeamMember.Id + '\'';
				}
			}
			if(insertReplaceProjectTeamMember.StartDate__c != null){
				if(delegateQuery.contains('Where')){
					delegateQuery += ' AND';
				}
				else{
					delegateQuery += ' Where';
				}
				delegateQuery += ' (Start_Date__c <= ' + convertDateToSoqlDateString(insertReplaceProjectTeamMember.StartDate__c);
				delegateQuery += ' AND(End_Date__c = NULL OR End_Date__c >= ' + convertDateToSoqlDateString(insertReplaceProjectTeamMember.StartDate__c) + '))';
			}
			else if(startDate != null && startDate != ''){
				if(delegateQuery.contains('Where')){
					delegateQuery += ' AND';
				}
				else{
					delegateQuery += ' Where';
				}
				delegateQuery += ' (Start_Date__c <= ' + convertStringSOQLString(startDate);
				delegateQuery += ' AND(End_Date__c = NULL OR End_Date__c >= ' + convertStringSOQLString(startDate) + '))';
			}
			List<Delegate__c> delegates = Database.query(delegateQuery);
			Set<Id> delegateIds = new Set<Id>();
			pse__proj__c project = [Select Id, PnLManager__r.pse__Salesforce_User__c, CarryingOutOrganization__r.FAManager__r.pse__Salesforce_User__c, CarryingOutOrganization__c from pse__Proj__c where Id =: oProject.Id];
			for(Delegate__c delegate : delegates){
				if(project.CarryingOutOrganization__c != null){
					//look for delegates that are allowed for the project's carrying out organization
					if(delegate.Allowed_Organizations__c != null){
						List<String> tempList = delegate.Allowed_Organizations__c.split(';');
						Set<String> allowedOrganizations = new Set<String>();
						allowedOrganizations.addAll(tempList);
						if(allowedOrganizations.contains(project.CarryingOutOrganization__c)){
							delegateIds.add(delegate.Delegate__c);
						}
					}
					else{
						delegateIds.add(delegate.Delegate__c);
					}
				}
				//no carrying out organization was supplied to the project
				else{
					delegateIds.add(delegate.Delegate__c);
				}
			}
			contactQuery += ' AND Id IN: delegateIds';
		}
		else{
			if(firstName != null){
				if(lastName == null){
					contactQuery += ' And (FirstName Like \'' + firstName + '%\' OR LastName Like \'' + firstName + '%\')';
				}
				else{
					contactQuery += ' And ((FirstName Like \'' + firstName + '%\' AND LastName Like \'' + lastName + '%\')';
					contactQuery += ' OR (FirstName Like \'' + lastName + '%\' AND LastName Like \'' + firstName + '%\'))';
				}
			}
		}
		contactQuery += ' AND (NOT person_id__c Like \'%U\')';
		contactQuery += ' AND pse__Salesforce_User__r.TrackingID__c != null';
		contactQuery += ' LIMIT 50';
		queryDelegates = Database.query(contactQuery);		
		return null;
	}

	//inserts/updates the project team member record for the selected key role
	public PageReference selectReplaceKeyMember(){
		String selectedContactId = ApexPages.currentPage().getParameters().get('selectedContactId');
		String selectedRoleName = ApexPages.currentPage().getParameters().get('selectedRole');
		String startDate = ApexPages.currentPage().getParameters().get('startDate');
		String existingId = ApexPages.currentPage().getParameters().get('existingId');
		String queryType = ApexPages.currentPage().getParameters().get('queryType');

		ProjectRole__c projectRole;
		
		//retrieve the project role object
		for(ProjectRole__c projRole : lProjectRoles){
			if(projRole.Name == selectedRoleName){
				projectRole = projRole;
			}
		}

		//check to make sure the data is validated
		if(validateKeyMember(startDate, projectRole, selectedContactId, existingId)){
			RecordType keyRecordType = [Select Id from RecordType where sobjecttype = 'ProjectTeamMember__c' and Name = 'Key Member'];

			Savepoint savePoint = Database.setSavepoint();

			try{
				List<ProjectTeamMember__c> projectTeamMembers = new List<ProjectTeamMember__c>();
				ProjectTeamMember__c projectTeamMember = new ProjectTeamMember__c(Project__c = oProject.Id, Contact__c = selectedContactId, RecordTypeId = keyRecordType.Id, ProjectRole__c = projectRole.Id, Is_Active__c = true, StartDate__c = insertReplaceProjectTeamMember.StartDate__c);
				
				if(queryType == 'Delegate'){
					projectTeamMember.Status__c = 'Approved';
				}
				else{
					projectTeamMember.Status__c = 'Pending';
					if(financeRoles.contains(selectedRoleName)){
						projectTeamMember.Unfiltered_Delegate_Approver__c = financeTeamMember.pse__Salesforce_User__c;
					}
					else{
						projectTeamMember.Unfiltered_Delegate_Approver__c = pAndLTeamMember.pse__Salesforce_User__c;
					}
				}

				projectTeamMembers.add(projectTeamMember);

				if(existingId != null && existingId != ''){
					projectTeamMembers.add(new ProjectTeamMember__c(Id = existingId, EndDate__c = convertStringToDate(startDate).addDays(-1)));
				}
				
				upsert projectTeamMembers; 
				saveError = false;
				if(projectTeamMember.Status__c == 'Pending'){
					sendApprovalProcess(projectTeamMember, selectedRoleName);
				}
	        }
	        catch(Exception ex){
	        	saveError = true;
	        	Database.rollback(savePoint);
	        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error inserting/updating Key Member ' + ex.getMessage()));
	        }	
	    }
	    else{
	    	saveError = true;
	    }
        return null;
	}

	//starts the aproval process for a requested delegate is they have a pending status
	@TestVisible 
	private void sendApprovalProcess(ProjectTeamMember__c projectTeamMember, String roleName){
		Contact contact;

		if(roleName != 'Project Approver 2' && roleName != 'Finance Lead' && roleName != 'Deputy Project Manager'){
			//find the contact from the loaded list already in viewstate
			for(Contact queryDelegate : queryDelegates){
				if(queryDelegate.Id == projectTeamMember.Contact__c){
					contact = queryDelegate;
				}
			}

			Approval.ProcessSubmitRequest newPendingRequest = new Approval.ProcessSubmitRequest();
	        newPendingRequest.setComments('Submitting request for ' + contact.Name + ' to be in the role of ' + roleName + ' for Project ' + oProject.Name);
			newPendingRequest.setObjectId(projectTeamMember.Id);
	        newPendingRequest.setProcessDefinitionNameOrId('Project_Team_Member_Approve_Team_Member');
	        newPendingRequest.setSkipEntryCriteria(true);
       		Approval.ProcessResult processResult = Approval.process(newPendingRequest);
    	}
	}

	//validates assigning a new team member for key roles to the project
	private Boolean validateKeyMember(String startDate, ProjectRole__c selectedRole, String selectedContactId, String existingId){
		Boolean isValid = true;
		Date startDte;
		Date endDte;

		//Start Date cannot be null
		if(insertReplaceProjectTeamMember.StartDate__c != null){
			startDte = insertReplaceProjectTeamMember.StartDate__c;
		}
		else{
			if(startDate == null || startDate == ''){
				insertReplaceProjectTeamMember.StartDate__c.addError('Start Date is Required');
				isValid = false;
			}
			else{
				startDte =  convertStringToDate(startDate);
			}
		}

		//find the latest end date for the role to compare against start date of new role assignment
		if(existingId != null && lProjectKeyMembers.containsKey(selectedRole.Id) && selectedRole.Name != 'Deputy Project Manager'){
			List<ProjectTeamMember__c> teamMembersInRole = lProjectKeyMembers.get(selectedRole.Id);
			for(ProjectTeamMember__c teamMemberInRole : teamMembersInRole){
				if((endDte == null || teamMemberInRole.EndDate__c > endDte) && teamMemberInRole.EndDate__c != null){
					endDte = teamMemberInRole.EndDate__c;
				}
				else if(endDte == null){
					endDte = teamMemberInRole.StartDate__c;
				}
			}
		}

		if(startDte < Date.today() || startDte <= endDte){
			insertReplaceProjectTeamMember.StartDate__c.addError('Effective Date cannot be less than current day or latest date of chosen role');
			isValid = false;
		}

		//verifies the user is not assigned to any other key role during the same time period
		for(List<ProjectTeamMember__c> teamMembersInRole : lProjectKeyMembers.values()){
			for(ProjectTeamMember__c teamMemberInRole : teamMembersInRole){
				if(teamMemberInRole.Contact__c == selectedContactId && teamMemberInRole.ProjectRole__c != selectedRole.Id){
					if(startDte >= teamMemberInRole.StartDate__c && (startDte <= teamMemberInRole.EndDate__c || teamMemberInRole.EndDate__c == null)){
						isValid = false;
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please ensure that the same Contact is not assigned twice during the same time frame.'));
						break;
					}
				}
			}
		}

		return isValid;
	}

	//converts a date value into a string in the format of yyyy-mm-dd
	private String convertDateToSoqlDateString(Date inputDate){
		String month = String.valueof(inputDate.month());
		String day = String.valueOf(inputDate.day());

		if(month.length() < 2){
			month = '0' + month;
		}

		if(day.length() < 2){
			day = '0' + day;
		}

		return inputDate.year() + '-' + month + '-' + day;
	}

	//converts a string in the format of mm/dd/yyyy, yyyy.mm.dd, yyyy-mm-dd to a date type
	private Date convertStringToDate(String inputDate){
		List<String> dateString = new List<String>();
		if(inputDate.contains('/')){
			dateString = inputDate.split('/');
			return date.newInstance(Integer.valueOf(dateString[2]), Integer.valueOf(dateString[0]), Integer.valueOf(dateString[1]));
		}
		else if(inputDate.contains('.')){
			return Date.valueOf(inputDate.replace('.', '-'));
		}
		return Date.valueOf(inputDate);
	}

	//converts a string in the format of mm/dd/yyyy, yyyy.mm.dd, yyyy-mm-dd to a string in the format of yyyy-mm-dd
	@TestVisible 
	private String convertStringSOQLString(String inputDate){
		List<String> dateString = new List<String>();
		if(inputDate.contains('/')){
			dateString = inputDate.split('/');
			if(dateString[1].length() < 2){
				dateString[1] = 0 + dateString[1];
			}
			if(dateString[0].length() < 2){
				dateString[0] = 0 + dateString[0];
			}
			return dateString[2] + '-' + dateString[0] + '-' + dateString[1];
		}
		else if(inputDate.contains('.')){
			return inputDate.replace('.', '-');
		} 
		return inputDate;
	}
	
	public void addRecord()
	{
		if(recordObjectType == 'MembersTeam')
		{
			TeamMember tm = new TeamMember(oProject, lProjectRoles);
			tm.RoleType = 'Team Member';
			lMembersTeam.add(tm);
		}
		else if(recordObjectType == 'Stakeholder__c')
		{
			lStakeholders.add(new Stakeholder__c(Project__c = oProject.Id));
		}
		else if(recordObjectType == 'CommunicationPlan__c')
		{
			CommunicationPlan__c communicationPlan = new CommunicationPlan__c(Project__c = oProject.Id);
			insert communicationPlan;
			lCommPlans.add(communicationPlan);
		}
		else if(recordObjectType == 'SurveySchedule__c')
		{
			SurveySchedule__c ss = new SurveySchedule__c(Project__c = oProject.Id);
			lSurveySchedules.add(ss);
			lstSSW.add(new ScheduleWrapper(ss, lstSSW.size()));
			setOptions();
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

	//sets the contact picklist for the survey field depending on which client was selected
	public PageReference setOptions(){
		if(ApexPages.currentPage().getParameters().get('surveyToRefresh') != null){
			Integer surveyToRefresh = Integer.valueOf(ApexPages.currentPage().getParameters().get('surveyToRefresh'));
			try{
				Site__c site = [Select Id, Account__c from Site__c where Id =: lstSSW[surveyToRefresh].ss.Client__c];
				List<Contact> contacts = [Select Id, Name from Contact where AccountId =: site.Account__c order by Name];
				lstSSW[surveyToRefresh].cOptions = new list<SelectOption>();
				lstSSW[surveyToRefresh].cOptions.add(new SelectOption(' ', '--None--'));
				for(Contact contact : contacts){
					lstSSW[surveyToRefresh].cOptions.add(new SelectOption(contact.Id, contact.Name));
				}
			}
			catch(Exception ex){
				//no available contacts for the select list
			}
		}
    	return null;
    }

	//removes a record from the related lists
	public PageReference removeRecord(){
		if(recordObjectType == 'MembersTeam')
		{
			Integer teamMemberToRemove = Integer.valueOf(ApexPages.currentPage().getParameters().get('teamMemberToRemove'));
			if(lMembersTeam[teamMemberToRemove].oPTM.Id != null){
				lMembersTeam[teamMemberToRemove].oPTM.Is_Active__c = false;
				lMembersTeam[teamMemberToRemove].oPTM.EndDate__c = Date.today();
				update lMembersTeam[teamMemberToRemove].oPTM;
				lInactiveMembersTeam.add(lMembersTeam[teamMemberToRemove]);
			}
			lMembersTeam.remove(teamMemberToRemove);
		}
		else if(recordObjectType == 'Stakeholder__c')
		{
			Integer otherToRemove = Integer.valueOf(ApexPages.currentPage().getParameters().get('otherToRemove'));
			if(lStakeholders[otherToRemove].Id != null){
				Stakeholder__c stakeHolder = lStakeholders[otherToRemove];
				lStakeholders.remove(otherToRemove);
				delete stakeHolder;
			}
			else{
				lStakeholders.remove(otherToRemove);
			}
		}
		else if(recordObjectType == 'CommunicationPlan__c')
		{
			Integer planToRemove = Integer.valueOf(ApexPages.currentPage().getParameters().get('planToRemove'));
			if(lCommPlans[planToRemove].Id != null){
				CommunicationPlan__c communicationPlan = lCommPlans[planToRemove];
				lcommPlans.remove(planToRemove);
				delete communicationPlan;
			}
			else{
				lcommPlans.remove(planToRemove);
			}
		}
		else if(recordObjectType == 'SurveySchedule__c')
		{
			Integer surveyToRemove = Integer.valueOf(ApexPages.currentPage().getParameters().get('surveyToRemove'));
			if(lSurveySchedules[surveyToRemove].Id != null){
				SurveySchedule__c surveySchedule = lSurveySchedules[surveyToRemove];
				lSurveySchedules.remove(surveyToRemove);
				lstSSW.remove(surveyToRemove);
				delete surveySchedule;
			}
			else{
				lSurveySchedules.remove(surveyToRemove);
				lstSSW.remove(surveyToRemove);
			}
		}		
		return null;
	}
	
	public class TeamMember
	{
		public pse__Proj__c oProject {get; set;}
		public List<ProjectRole__c> lProjectRoles {get; set;}
		public String RoleID {get; set;}
		public String RoleName {get; set;}
		public String RoleType {get; set;}
		public Date previousDate {get; set;}
		public ProjectTeamMember__c oPTM {get; set;}
		public List<SelectOption> lTeamRoleTypes {get; set;}
		public List<SelectOption> lKeyRoleTypes {get; set;}
		public Boolean canEdit{get; set;}

		public TeamMember(pse__Proj__c proj, List<ProjectRole__c> prList){
			this(proj, prList, null, false);
		}

		public TeamMember(pse__Proj__c proj, List<ProjectRole__c> prList, String existingId){
			this(proj, prList, existingId, false);
		}

		public TeamMember(pse__Proj__c proj, List<ProjectRole__c> prList, String existingId, Boolean edit)
		{
			
			this.oProject = proj;
			this.lProjectRoles = prList;
			this.canEdit = edit;
			if(existingId != null){
				this.oPTM = new ProjectTeamMember__c(Id = existingId);
			}
			else{
				this.oPTM = new ProjectTeamMember__c(Project__c = oProject.Id);
			}
			lTeamRoleTypes = new List<SelectOption>();
			lTeamRoleTypes.add(new SelectOption('', '--None--'));
			lKeyRoleTypes = new List<SelectOption>();
			lKeyRoleTypes.add(new SelectOption('', '--None--'));

			for(ProjectRole__c pr : lProjectRoles)
			{
				if(pr.Type__c == 'Team Member' && pr.Name != 'Inactive Deliverable Owner')
				{
					lTeamRoleTypes.add(new SelectOption(pr.Id, pr.Name));
				}
			}

		}
	}

	 public class ScheduleWrapper {
        public SurveySchedule__c ss {get;set;}
        public list<SelectOption> cOptions {get;set;}
        public Integer counter{get; set;}
        public id accountid {get;set;}

        public ScheduleWrapper(SurveySchedule__c oSS, Integer count){
        	this(oSS, count, null);
        }

        public ScheduleWrapper(SurveySchedule__c oSS, Integer count, List<Contact> contacts){
            this.ss = oSS;
            this.counter = count;
            cOptions = new list<SelectOption>();
            if(contacts != null){
            	cOptions = new list<SelectOption>();
				cOptions.add(new SelectOption(' ', '--None--'));
				for(Contact contact : contacts){
					cOptions.add(new SelectOption(contact.Id, contact.Name));
				}
            }
        }
    }
}