/*
    Purpose: - Controller for the ECO_DelegateManagerEdit Visualforce Page

    Created By: Aaron Pettitt (NTT Data)

    Revision Log: 
        v1.0 - (AP 11/09/2015) -- created 
*/
public with sharing class ECO_DelegateManagerEditController {

    public Delegate__c extensionDelegate{get; set;}
    public ECO_Delegate_Limit__c delegateLimitSettings{get; set;}
	public List<ECO_DelegateManagerController.owningOrganization> owningOrganizations{get; set;}
    private ApexPages.StandardController controller;
    private String redirectURL;
    
    //constructor
    public ECO_DelegateManagerEditController(ApexPages.StandardController standardController) {
        this.controller = standardController;
        this.extensionDelegate = (Delegate__c)standardController.getRecord();
        queryDelegate();
        if(extensionDelegate.Delegator__r.pse__Salesforce_User__c != null && ECO_Delegate_Limit__c.getInstance(extensionDelegate.Delegator__r.pse__Salesforce_User__c) != null){
			delegateLimitSettings = ECO_Delegate_Limit__c.getInstance(extensionDelegate.Delegator__r.pse__Salesforce_User__c);
		}
		else{
			delegateLimitSettings = ECO_Delegate_Limit__c.getOrgDefaults();
		}
		if(extensionDelegate.RecordType.Name == 'Key Roles'){
			populateOwningOrganizations();
		}
		if(ApexPages.currentPage().getParameters().get('retURL') != null){
			redirectURL = ApexPages.currentPage().getParameters().get('retUrl');
		}
    }

	//saves the updated data
    public PageReference save() {
    	try{
    		Boolean anyOrgChecked = false;
			//save all of the selected organizations
			if(extensionDelegate.recordType.Name == 'Key Roles' && owningOrganizations.size() > 0){
				extensionDelegate.Allowed_Organizations__c = '';
				for(ECO_DelegateManagerController.owningOrganization organization : owningOrganizations){
					if(organization.checked){
						extensionDelegate.Allowed_Organizations__c += organization.organization.Id + ';';
						anyOrgChecked = true;
					}
				}
			}
    		update extensionDelegate;
    		controller.save();
    		if(redirectURL != null){
    			return new PageReference('/' + redirectURL);
    		}
    	}
    	catch(Exception ex){
    		if(!ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Inserting Delegate: ' + ex.getMessage()));
			}
    	}
    	return null;
    }

    //returns the current user's currency format
	public String currentCurrency{
		get{
			return UserInfo.getDefaultCurrency();
		}
		set;
	}

	//returns the select options for the yes/no radio buttons
	public List<SelectOption> yesNoOptions{
		get{
			List<SelectOption> options = new List<SelectOption>();
			options.add(new SelectOption('Yes', 'Yes'));
			options.add(new SelectOption('No', 'No'));
			return options;
		}
		set;
	}

    //button function to return to contact 
	public PageReference back(){
		if(ApexPages.currentPage().getParameters().get('retURL') != null){
			return new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
		}
		else{
			return new PageReference('/' + extensionDelegate.Delegator__c);
		}
	}

	//Getters/Setters for all of the Yes/No fields
	public String agreementAmountBypass{
		get{
			if(extensionDelegate.Agreement_Amount_estimated_Bypass__c){
				return 'Yes';
			}
			return 'No';
		} 
		set{
			agreementAmountBypass = value;
			if(value == 'Yes'){
				extensionDelegate.Agreement_Amount_estimated_Bypass__c = true;
			}
			else{
				extensionDelegate.Agreement_Amount_estimated_Bypass__c = false;
			}
		}
	}
	public String agreementAmountBypassLT{
		get{
			if(extensionDelegate.Agreement_Amount_estimated_Bypass_lt__c){
				return 'Yes';
			}
			return 'No';
		} 
		set{
			agreementAmountBypassLT = value;
			if(value == 'Yes'){
				extensionDelegate.Agreement_Amount_estimated_Bypass_lt__c = true;
			}
			else{
				extensionDelegate.Agreement_Amount_estimated_Bypass_lt__c = false;
			}
		}
	}
	public String projectRevenueBudgetBypass{
		get{
			if(extensionDelegate.Project_Revenue_Budget_Bypass__c){
				return 'Yes';
			}
			return 'No';
		} 
		set{
			projectRevenueBudgetBypass = value;
			if(value == 'Yes'){
				extensionDelegate.Project_Revenue_Budget_Bypass__c = true;
			}
			else{
				extensionDelegate.Project_Revenue_Budget_Bypass__c = false;
			}
		}
	}
	public String projectRevenueBudgetBypassLT{
		get{
			if(extensionDelegate.Project_Revenue_Budget_Bypass_lt__c){
				return 'Yes';
			}
			return 'No';
		} 
		set{
			projectRevenueBudgetBypassLT = value;
			if(value == 'Yes'){
				extensionDelegate.Project_Revenue_Budget_Bypass_lt__c = true;
			}
			else{
				extensionDelegate.Project_Revenue_Budget_Bypass_lt__c = false;
			}
		}
	}
	public String backlogValueBypass{
		get{
			if(extensionDelegate.Backlog_Value_Bypass__c){
				return 'Yes';
			}
			return 'No';
		} 
		set{
			backlogValueBypass = value;
			if(value == 'Yes'){
				extensionDelegate.Backlog_Value_Bypass__c = true;
			}
			else{
				extensionDelegate.Backlog_Value_Bypass__c = false;
			}
		}
	}
	public String backlogValueBypassLT{
		get{
			if(extensionDelegate.Backlog_Value_Bypass_lt__c){
				return 'Yes';
			}
			return 'No';
		} 
		set{
			backlogValueBypassLT = value;
			if(value == 'Yes'){
				extensionDelegate.Backlog_Value_Bypass_lt__c = true;
			}
			else{
				extensionDelegate.Backlog_Value_Bypass_lt__c = false;
			}
		}
	}
	public String projectNetMarginValueBypass{
		get{
			if(extensionDelegate.Project_Net_Margin_Value_Bypass__c){
				return 'Yes';
			}
			return 'No';
		} 
		set{
			projectNetMarginValueBypass = value;
			if(value == 'Yes'){
				extensionDelegate.Project_Net_Margin_Value_Bypass__c = true;
			}
			else{
				extensionDelegate.Project_Net_Margin_Value_Bypass__c = false;
			}
		}
	}
	public String projectNetMarginValueBypassLT{
		get{
			if(extensionDelegate.Project_Net_Margin_Value_Bypass_lt__c){
				return 'Yes';
			}
			return 'No';
		} 
		set{
			projectNetMarginValueBypassLT = value;
			if(value == 'Yes'){
				extensionDelegate.Project_Net_Margin_Value_Bypass_lt__c = true;
			}
			else{
				extensionDelegate.Project_Net_Margin_Value_Bypass_lt__c = false;
			}
		}
	}
	public String projectNetMarginNSRBypass{
		get{
			if(extensionDelegate.Project_Net_Margin_age_of_NSR_Bypass__c){
				return 'Yes';
			}
			return 'No';
		} 
		set{
			projectNetMarginNSRBypass = value;
			if(value == 'Yes'){
				extensionDelegate.Project_Net_Margin_age_of_NSR_Bypass__c = true;
			}
			else{
				extensionDelegate.Project_Net_Margin_age_of_NSR_Bypass__c = false;
			}
		}
	}
	public String projectNetMarginNSRBypassLT{
		get{
			if(extensionDelegate.Project_Net_Margin_of_NSR_Bypass_lt__c){
				return 'Yes';
			}
			return 'No';
		} 
		set{
			projectNetMarginNSRBypassLT = value;
			if(value == 'Yes'){
				extensionDelegate.Project_Net_Margin_of_NSR_Bypass_lt__c = true;
			}
			else{
				extensionDelegate.Project_Net_Margin_of_NSR_Bypass_lt__c = false;
			}
		}
	}
	public String percentageChangeInForecastBypass{
		get{
			if(extensionDelegate.age_Change_in_Forecast_Net_Margin_Bypass__c){
				return 'Yes';
			}
			return 'No';
		} 
		set{
			percentageChangeInForecastBypass = value;
			if(value == 'Yes'){
				extensionDelegate.age_Change_in_Forecast_Net_Margin_Bypass__c = true;
			}
			else{
				extensionDelegate.age_Change_in_Forecast_Net_Margin_Bypass__c = false;
			}
		}
	}
	public String percentageChangeInForecastBypassLT{
		get{
			if(extensionDelegate.age_Change_in_Forecast_Net_Margin_Byp_lt__c){
				return 'Yes';
			}
			return 'No';
		} 
		set{
			percentageChangeInForecastBypassLT = value;
			if(value == 'Yes'){
				extensionDelegate.age_Change_in_Forecast_Net_Margin_Byp_lt__c = true;
			}
			else{
				extensionDelegate.age_Change_in_Forecast_Net_Margin_Byp_lt__c = false;
			}
		}
	}
	public String valueChangeInForecastNetMarginBypass{
		get{
			if(extensionDelegate.Value_change_in_Forecast_Net_Margin_Byps__c){
				return 'Yes';
			}
			return 'No';
		} 
		set{
			valueChangeInForecastNetMarginBypass = value;
			if(value == 'Yes'){
				extensionDelegate.Value_change_in_Forecast_Net_Margin_Byps__c = true;
			}
			else{
				extensionDelegate.Value_change_in_Forecast_Net_Margin_Byps__c = false;
			}
		}
	}
	public String valueChangeInForecastNetMarginBypassLT{
		get{
			if(extensionDelegate.Value_change_Forecast_Nt_Margn_Byps_lt__c){
				return 'Yes';
			}
			return 'No';
		} 
		set{
			valueChangeInForecastNetMarginBypassLT = value;
			if(value == 'Yes'){
				extensionDelegate.Value_change_Forecast_Nt_Margn_Byps_lt__c = true;
			}
			else{
				extensionDelegate.Value_change_Forecast_Nt_Margn_Byps_lt__c = false;
			}
		}
	}
	public String c0Bypass{
		get{
			if(extensionDelegate.Project_Review_Category_C_0_Bypass__c){
				return 'Yes';
			}
			return 'No';
		} 
		set{
			c0Bypass = value;
			if(value == 'Yes'){
				extensionDelegate.Project_Review_Category_C_0_Bypass__c = true;
			}
			else{
				extensionDelegate.Project_Review_Category_C_0_Bypass__c = false;
			}
		}
	}
	public String c1Bypass{
		get{
			if(extensionDelegate.Project_Review_Category_C_1_Bypass__c){
				return 'Yes';
			}
			return 'No';
		} 
		set{
			c1Bypass = value;
			if(value == 'Yes'){
				extensionDelegate.Project_Review_Category_C_1_Bypass__c = true;
			}
			else{
				extensionDelegate.Project_Review_Category_C_1_Bypass__c = false;
			}
		}
	}
	public String c2Bypass{
		get{
			if(extensionDelegate.Project_Review_Category_C_2_Bypass__c){
				return 'Yes';
			}
			return 'No';
		} 
		set{
			c2Bypass = value;
			if(value == 'Yes'){
				extensionDelegate.Project_Review_Category_C_2_Bypass__c = true;
			}
			else{
				extensionDelegate.Project_Review_Category_C_2_Bypass__c = false;
			}
		}
	}
	public String c3Bypass{
		get{
			if(extensionDelegate.Project_Review_Category_C_3_Bypass__c){
				return 'Yes';
			}
			return 'No';
		} 
		set{
			c3Bypass = value;
			if(value == 'Yes'){
				extensionDelegate.Project_Review_Category_C_3_Bypass__c = true;
			}
			else{
				extensionDelegate.Project_Review_Category_C_3_Bypass__c = false;
			}
		}
	}
	public String c4Bypass{
		get{
			if(extensionDelegate.Project_Review_Category_C_4_Bypass__c){
				return 'Yes';
			}
			return 'No';
		} 
		set{
			c4Bypass = value;
			if(value == 'Yes'){
				extensionDelegate.Project_Review_Category_C_4_Bypass__c = true;
			}
			else{
				extensionDelegate.Project_Review_Category_C_4_Bypass__c = false;
			}
		}
	}
	//End Getters/Setters for all of the Yes/No fields

	//builds the soql query for the delegate data
	private void queryDelegate(){
    	Set<String> fieldSetFields = ECO_Utils_sObject.getFieldSetMembers('DelegationModuleContactDetails', 'Contact');
		String queryFields = '';
		Boolean foundName = false;

		//create a soql compatible string of field names to select
		for(String fieldSetField : fieldSetFields){
			queryFields += 'Delegate__r.' + fieldSetField + ', ';
			if(fieldSetField == 'Name'){
				foundName = true;
			}
		}

		if(!foundName){
			queryFields += ' Delegate__r.Name, ';
		}

		String query = 'Select Id, Name, ' + queryFields + ' Delegate__c, Delegator__c, Delegator__r.pse__Salesforce_User__c, RecordType.Name, RecordTypeId, Allowed_Organizations__c, ';
		query += 'age_Change_in_Forecast_Net_Margin_lt__c, age_Change_in_Forecast_Net_Margin__c, age_Change_in_Forecast_Net_Margin_Byp_lt__c, age_Change_in_Forecast_Net_Margin_Bypass__c, ';
		query += 'Agreement_Amount_estimated_lt__c, Agreement_Amount_estimated__c, Agreement_Amount_estimated_Bypass_lt__c, Agreement_Amount_estimated_Bypass__c, Backlog_Value_Bypass__c, Backlog_Value_Bypass_lt__c, ';
		query += 'Project_Net_Margin_age_of_NSR_lt__c, Project_Net_Margin_age_of_NSR__c, Project_Net_Margin_of_NSR_Bypass_lt__c, Project_Net_Margin_age_of_NSR_Bypass__c, Project_Net_Margin_Value_lt__c, ';
		query += 'Project_Net_Margin_Value__c, Project_Net_Margin_Value_Bypass_lt__c, Project_Net_Margin_Value_Bypass__c, Project_Revenue_Budget_lt__c, Project_Revenue_Budget__c, ';
		query += 'Project_Revenue_Budget_Bypass_lt__c, Project_Revenue_Budget_Bypass__c, Project_Review_Category_C_0_Bypass__c, Project_Review_Category_C_1_Bypass__c, Project_Review_Category_C_2_Bypass__c, ';
		query += 'Project_Review_Category_C_3_Bypass__c, Project_Review_Category_C_4_Bypass__c, Value_change_in_Forecast_Net_Margin_lt__c, Value_change_in_Forecast_Net_Margin__c, Value_change_Forecast_Nt_Margn_Byps_lt__c, Value_change_in_Forecast_Net_Margin_Byps__c ';
		query += ' from Delegate__c where Id = \'' + extensionDelegate.Id + '\'';
		extensionDelegate = Database.query(query);
    }

    //loads the list owningOrganization wrapper for the owning organization table
	private void populateOwningOrganizations(){
		//retrieve field string from fieldset
		owningOrganizations = new List<ECO_DelegateManagerController.owningOrganization>();
		List<ProjectTeamMember__c> projectTeamMembers = new List<ProjectTeamMember__c>();
		Set<String> organizationStringIds = new Set<String>();

		if(extensionDelegate.Allowed_Organizations__c != null && extensionDelegate.Allowed_Organizations__c.contains(';')){
			List<String> orgStringIds = extensionDelegate.Allowed_Organizations__c.split(';');
			organizationStringIds = new Set<String>(orgStringIds);
		}

		projectTeamMembers = [Select Id, Project__c from ProjectTeamMember__c where Contact__c =: extensionDelegate.Delegator__c and (ProjectRole__r.Name = 'Project Approver 2' OR ProjectRole__r.Name = 'Finance Lead')];
		
		Set<Id> projectIds = new Set<Id>();
		for(ProjectTeamMember__c projectTeamMember : projectTeamMembers){
			projectIds.add(projectTeamMember.Project__c);
		}
		if(projectIds.size() > 0){
			Set<String> organizationStringFields = ECO_Utils_sObject.getFieldSetMembers('Delegate_Owning_Organization_Table', 'OrganizationString__c');
			
			if(organizationStringFields.size() > 0){
				String queryFields = '';

				//create the query field string 
				for(String organizationStringField : organizationStringFields){
					queryFields += 'CarryingOutOrganization__r.' + organizationStringField + ', ';
				}

				//query string
				String query = 'Select Id, CarryingOutOrganization__c, CarryingOutOrganization__r.LocationName__c, ' + queryFields.removeEnd(', ') + ' From pse__Proj__c where Id IN : projectIds';
				List<pse__Proj__c> projects = Database.query(query);
				Set<Id> organizationIdsUsed = new Set<Id>();

				//load the owningOrganizations wrapper from query results
				for(pse__Proj__c project : projects){
					if(!organizationIdsUsed.contains(project.CarryingOutOrganization__c)){
						organizationIdsUsed.add(project.CarryingOutOrganization__c);
						ECO_DelegateManagerController.owningOrganization ownOrganization = new ECO_DelegateManagerController.owningOrganization(project.CarryingOutOrganization__r);
						if(organizationStringIds.contains(project.CarryingOutOrganization__c)){
							ownOrganization.checked = true;
						}
						owningOrganizations.add(ownOrganization);
					}
				}
			}
		}
	}

}