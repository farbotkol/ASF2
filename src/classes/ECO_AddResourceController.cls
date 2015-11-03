public with sharing class ECO_AddResourceController {
	public ApexPages.StandardController stdController {get; set;}

	public BudgetHeader__c budgetHeader {get; set;}
	public pse__Proj__c theProject {get; set;}

	public List<SelectOption> allProjectTeamMembers {get; set;}

	public String selectedProjectTeamMember {get; set;}

	public List<ECO_DTO_ProjectTeamMember> members {get; set;}

	public String jobNameSelections {get; set;}
	public String jobNameJSON {get; set;}

	public List<SelectOption> businessLineChoices {get; set;}
	public List<SelectOption> regionChoices {get; set;}

	public String businessLineSelection {get; set;}
	public String regionSelection {get; set;}

	public String searchName {get; set;}
	public String searchRole {get; set;}
	public String searchPhone {get; set;}
	public String searchEmail {get; set;}

	public String thesoql {get; set;}

	public ECO_AddResourceController(ApexPages.StandardController stdController) {
		this.stdController = stdController;

		List<String> fields = new List<String>();
		fields.add('Project__c');
		stdController.addFields(fields);

		budgetHeader = (BudgetHeader__c) stdController.getRecord();

		theProject = [select id, DefaultBillRate__c, DefaultUpliftLabor__c from pse__Proj__c where id = :budgetHeader.Project__c];

		populateProjectTeam();
		populateOrganizationStrings();
		populateJobNameChoices();
	}

	private String notNull(String value1, String value2, String value3) {
		if (value1 != null)
			return value1;

		if (value2 != null)
			return value2;

		return value3;
	}

	public void populateProjectTeam () {
		members = new List<ECO_DTO_ProjectTeamMember>();

		allProjectTeamMembers = new List<SelectOption>();

		allProjectTeamMembers.add(new SelectOption('', '--- Choose a Team Member ---'));

		List<String> names = new List<String>();
		Map<String, Id> nameMap = new Map<String, Id>();

		Id projid = theProject.id;

		String soql = 'select id, role__c, projectrole__r.name, name__c, name, startdate__c, enddate__c, Phone__c, Email__c from projectteammember__c where project__c = :projid';

		if ((searchName != null) && (!searchName.trim().equals(''))) {
			soql += ' and name like \'%' + searchName.trim() + '%\'';
		}

		if ((searchRole != null) && (!searchRole.trim().equals(''))) {
			soql += ' and ProjectRole__r.name like \'%' + searchRole.trim() + '%\'';
		}

		if ((searchPhone != null) && (!searchPhone.trim().equals(''))) {
			soql += ' and Phone__c like \'%' + searchPhone.trim() + '%\'';
		}

		if ((searchEmail != null) && (!searchEmail.trim().equals(''))) {
			soql += ' and Email__c like \'%' + searchEmail.trim() + '%\'';
		}

		soql += ' order by name, projectrole__r.name';

		System.debug('the soql - ' + soql);

		thesoql = soql;

		List<ProjectTeamMember__c> memberList = Database.query(soql);
		
		for (ProjectTeamMember__c ptm : memberList) {
			String roleName = notNull(ptm.ProjectRole__r.name, ptm.Role__c, 'no role');

			String name = notNull(ptm.name__c, ptm.name, 'no name');

			name += ' (' + roleName + ')';

			names.add(name);
			nameMap.put(name, ptm.Id);

			members.add(new ECO_DTO_ProjectTeamMember(ptm));
		}

		names.sort();

		for (String name : names) {
			allProjectTeamMembers.add(new SelectOption(nameMap.get(name), name));
		}
	}

	public void populateOrganizationStrings() {
		Map<String, String> businessLineMap = new Map<String, String>();
		Map<String, String> regionMap = new Map<String, String>();

		if ((jobNameSelections == null) || (jobNameSelections.trim().equals(''))) {
			List<OrganizationString__c> orgStrings = [select id, BusinessLineName__c, Region__c from OrganizationString__c where (BusinessLineName__c != null) or (Region__c != null)];

			for (OrganizationString__c orgString : orgStrings) {
				if (orgString.BusinessLineName__c != null)
					businessLineMap.put(orgString.BusinessLineName__c, orgString.id);

				if (orgString.Region__c != null)
					regionMap.put(orgString.Region__c, orgString.id);	
			}
		} else {
			List<Contact> contacts = [select id, OrganizationBusinessLine__c, OrganizationRegion__c from Contact where JobName__c = :jobNameSelections and ((OrganizationBusinessLine__c != null) or (OrganizationRegion__c != null))];

			for (Contact con : contacts) {
				if (con.OrganizationBusinessLine__c != null)
					businessLineMap.put(con.OrganizationBusinessLine__c, con.OrganizationBusinessLine__c);

				if (con.OrganizationRegion__c != null)
					regionMap.put(con.OrganizationRegion__c, con.OrganizationRegion__c);	
			}
		}

		List<String> businessLineList = new List<String>(businessLineMap.keySet());
		List<String> regionList = new List<String>(regionMap.keySet());

		businessLineList.sort();
		regionList.sort();

		businessLineChoices = new List<SelectOption>();

		businessLineChoices.add(new SelectOption('', 'Select Business Line (optional)'));

		for (String s : businessLineList) {
			businessLineChoices.add(new SelectOption(businessLineMap.get(s), s));
		}

		regionChoices = new List<SelectOption>();

		regionChoices.add(new SelectOption('', 'Select Region (optional)'));

		for (String s : regionList) {
			regionChoices.add(new SelectOption(regionMap.get(s), s));
		}
	}

	private void populateJobNameChoices() {
		Map<String, ECO_Job_Name__c> jobNames = ECO_Job_Name__c.getAll();

		List<String> listt = new List<String>();

		for (ECO_Job_Name__c jobName : jobNames.values()) {
			listt.add(jobName.name__c);
		}

		listt.sort();

		jobNameJSON = '[';

		Boolean first = true;

		for (String s : listt) {
			if (s.indexOf('"') != -1)
				continue;  // TODO - probably shouldn't skip, maybe escape is a better option

			if (!first)
				jobNameJSON += ',';

			jobNameJSON += '"' + s + '"';

			first = false;

			//jobNameChoices.add(new SelectOption(s, s));
		}

		jobNameJSON += ']';
   	}

	public PageReference addExistingResource() {
		List<BudgetResource__c> toAdd = new List<BudgetResource__c>();

		for (ECO_DTO_ProjectTeamMember member : members) {
			if (!member.selected)
				continue;

			BudgetResource__c newBudgetColumn = new BudgetResource__c();

			newBudgetColumn.BudgetHeader__c = budgetHeader.id;
			newBudgetColumn.OverrideRatesOnLines__c = true;
			newBudgetColumn.ResourceType__c = 'Labor/Person';

			newBudgetColumn.OverrideBillRate__c = theProject.DefaultBillRate__c;
			newBudgetColumn.OverrideUplift__c = theProject.DefaultUpliftLabor__c;
			newBudgetColumn.JobName__c = null;

			newBudgetColumn.ProjectTeamMember__c = member.member.id;

			toAdd.add(newBudgetColumn);
		}

//		insert newBudgetColumn;
		insert toAdd;

		PageReference pr = new PageReference('/apex/ECO_BudgetLabourDetail2?id=' + budgetHeader.id);
		pr.setRedirect(true);

		return pr;
	}

	public PageReference addFoundResource() {
		return null;
	}

	public Double computeAverageCostRate() {
		populateOrganizationStrings();

		String soql = 'select id, pse__Default_Cost_Rate__c from Contact where JobName__c = :jobNameSelections';

		if ((businessLineSelection != null) && (businessLineSelection != '')) {
			soql += ' and OrganizationBusinessLine__c = :businessLineSelection';
		}

		if ((regionSelection != null) && (regionSelection != '')) {
			soql += ' and OrganizationRegion__c = :regionSelection';
		}

		soql += ' limit 100';
		
		List<Contact> contacts = null;

		try {
			contacts = Database.query(soql);
		} catch (Exception ex) {

		}

		Double acc = 0;
		Double ct = 0;

		for (Contact con : contacts) {
			if (con.pse__Default_Cost_Rate__c > 0) {
				acc += con.pse__Default_Cost_Rate__c;
				ct++;
			}
		}

		if (ct > 0)
			return acc / ct;

		return 0.0;	
	}

	public PageReference addGenericResource() {
		BudgetResource__c newBudgetColumn = new BudgetResource__c();

		newBudgetColumn.BudgetHeader__c = budgetHeader.id;
		newBudgetColumn.OverrideRatesOnLines__c = true;
		newBudgetColumn.ResourceType__c = 'Labor/Person';

		newBudgetColumn.ResourceName__c = null;
		newBudgetColumn.ProjectTeamMember__c = null;
		newBudgetColumn.OverrideRawCost__c = computeAverageCostRate();
		newBudgetColumn.JobName__c = jobNameSelections;
		newBudgetColumn.OverrideUplift__c = theProject.DefaultUpliftLabor__c;

		insert newBudgetColumn;

		PageReference pr = new PageReference('/apex/ECO_BudgetLabourDetail2?id=' + budgetHeader.id);
		pr.setRedirect(true);

		return pr;
	}
}