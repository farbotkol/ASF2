/*************************************************************************
*
* PURPOSE: Trigger to update User projects summary fields
*
* CREATED: 2014 Ethos Solutions - www.ethos.com
* AUTHOR: Brian Lau
***************************************************************************/

trigger rsUserProjectsSummaryTrigger on PR_Team_Employee__c (after insert, after update, after delete) {

	// Map of projectss that will be summarized in user, keys are user Ids
	Map<Id, List<PR_Team_Employee__c>> projects = new Map<Id, List<PR_Team_Employee__c>>(); 
	Set<Id> alreadyAddedPPIds = new Set<Id>();
	Set<Id> userIds = new Set<Id>();

	// Map of Record Types names and their information
	Map<String,Schema.RecordTypeInfo> mRtInfo = PR_Team_Employee__c.SObjectType.getDescribe().getRecordTypeInfosByName();

	//Map of Projects fields, we'll use this for labeling the User summary
	Map<String, Schema.SObjectField> projectFields = Schema.SObjectType.PR_Team_Employee__c.fields.getMap();

	// Check if the profile part is approved and we're not deleting it, add it to the map
	// otherwise we'll add just the user id to grab their approved projects
	for(PR_Team_Employee__c pp : Trigger.isUpdate || Trigger.isInsert ? Trigger.new : Trigger.Old) {
		if(pp.Status__c == rsPRTeamEmployee.S_APPROVED && !Trigger.isDelete) {
			if(projects.containsKey(pp.EmployeeUser__c)) projects.get(pp.EmployeeUser__c).add(pp);
			else projects.put(pp.EmployeeUser__c, new List<PR_Team_Employee__c>{pp});
			alreadyAddedPPIds.add(pp.Id);
		}
		userIds.add(pp.EmployeeUser__c);
	}

	List<User> users = [Select AECOM_Projects_Summary__c, Non_AECOM_Projects_Summary__c
						from User
						where Id IN: userIds];

	// Set of user ids used in Dynamic SOQL, projects.keyset doesn't work requires setting the keyset to a set
	userIds.addAll(projects.keySet());

	// Query projects that are approved to recreate the the summary fields
	List<PR_Team_Employee__c> queryPP = (List<PR_Team_Employee__c>)Database.query('Select ' + String.join(new List<String>(projectFields.keySet()),',') + 
																				' from PR_Team_Employee__c' +
																				' where Id NOT IN: alreadyAddedPPIds' + 
																				' AND Status__c = ' + rsStringUtil.quote(rsPRTeamEmployee.S_APPROVED) +
																				' AND EmployeeUser__c IN: userIds');

	// Add the queried projects to the Map
	for(PR_Team_Employee__c pp : queryPP) {
		if(projects.containsKey(pp.EmployeeUser__c)) projects.get(pp.EmployeeUser__c).add(pp);
		else projects.put(pp.EmployeeUser__c,new List<PR_Team_Employee__c>{pp});
	}

	Integer aecomLimit = User.AECOM_Projects_Summary__c.getDescribe().getLength();
	Integer nonAecomLimit = User.Non_AECOM_Projects_Summary__c.getDescribe().getLength();

	// For now we'll only add the required fields to the summary
	// In case of data migration where a lot of the required fields will not be
	// filled out, let's only add them if they have a value
	for(User u : users) {

		Boolean aecomLimitReached = false;
		Boolean nonAecomLimitReached = false;

		// We'll clear the projects summary fields 
		u.AECOM_Projects_Summary__c = '';
		u.Non_AECOM_Projects_Summary__c = '';

		// For the case the user doesn't have any previous approved projects
		List<PR_Team_Employee__c> userProjects = projects.containsKey(u.Id) ? projects.get(u.Id) : new List<PR_Team_Employee__c>();
		for(PR_Team_Employee__c pp : userProjects) {

			// AECOM Projects Summary 
			if(pp.RecordTypeId == mRtInfo.get(rsPRTeamEmployee.RT_AECOMPROJECT).getRecordTypeId() && !aecomLimitReached) {
				u.AECOM_Projects_Summary__c += String.isNotBlank(pp.Project_Name__c) ? '[' + projectFields.get('Project_ID__c').getDescribe().getLabel() + ']: ' + pp.Project_Name__c + ', ' : '';
				u.AECOM_Projects_Summary__c += String.isNotBlank(pp.Project_Role__c) ? '[' + projectFields.get('Project_Role__c').getDescribe().getLabel() + ']: ' + pp.Project_Role__c + ', ' : '';
				u.AECOM_Projects_Summary__c += String.isNotBlank(pp.Client__c) ? '[' + Label.Client_Name + ']: ' + pp.Client__c + ', ' : '';
				u.AECOM_Projects_Summary__c += String.isNotBlank(pp.Project_Group_Editable__c) ? '[' + Label.Project_Group + ']: ' + pp.Project_Group_Editable__c + ', ' : '';
				u.AECOM_Projects_Summary__c += String.isNotBlank(pp.Location_Country__c) ? '[' + Label.Location_Country + ']: ' + pp.Location_Country__c + ', ' : '';
			  	if(pp.Date_Involvement_Started__c != null) {
			  		u.AECOM_Projects_Summary__c += '[' + Label.Date_Involvement_Started + ']: ' + pp.Date_Involvement_Started__c.format() + ', ';
		  		} 
		  		if(pp.Date_Involvement_Ended__c != null) {
		  			u.AECOM_Projects_Summary__c += '[' + Label.Date_Involvement_Ended + ']: ' + pp.Date_Involvement_Ended__c.format() + ', ';
		  		}
		  		u.AECOM_Projects_Summary__c += String.isNotBlank(pp.Description__c) ? '[' + projectFields.get('Description__c').getDescribe().getLabel() + ']: ' + pp.Description__c : '';
		  		u.AECOM_Projects_Summary__c += String.isNotBlank(u.AECOM_Projects_Summary__c) ? '\r\n' : '';

		  		// set limit reached and add indicator that more data exists but field cannot hold any more
		  		if(u.AECOM_Projects_Summary__c.length() >= aecomLimit) {
		  			aecomLimitReached = true;
		  			u.AECOM_Projects_Summary__c = u.AECOM_Projects_Summary__c.subString(0,aecomLimit-3) + '...';
		  		}
			}

			// Non-AECOM Projects Summary
			else if(pp.RecordTypeId == mRtInfo.get(rsPRTeamEmployee.RT_NONAECOMPROJECT).getRecordTypeId() && !aecomLimitReached) {
				u.Non_AECOM_Projects_Summary__c += String.isNotBlank(pp.Project_Name__c) ? '[' + projectFields.get('Project_ID__c').getDescribe().getLabel() + ']: ' + pp.Project_Name__c + ', ' : '';
				u.Non_AECOM_Projects_Summary__c += String.isNotBlank(pp.Project_Role__c) ? '[' + projectFields.get('Project_Role__c').getDescribe().getLabel() + ']: ' + pp.Project_Role__c + ', ' : '';
				u.Non_AECOM_Projects_Summary__c += String.isNotBlank(pp.Client__c) ? '[' + Label.Client_Name + ']: ' + pp.Client__c + ', ' : '';
				u.Non_AECOM_Projects_Summary__c += String.isNotBlank(pp.Project_Group_Editable__c) ? '[' + Label.Project_Group + ']: ' + pp.Project_Group_Editable__c + ', ' : '';
				u.Non_AECOM_Projects_Summary__c += String.isNotBlank(pp.Location_Country__c) ? '[' + Label.Location_Country + ']: ' + pp.Location_Country__c + ', ' : '';
			  	if(pp.Date_Involvement_Started__c != null) {
			  		u.Non_AECOM_Projects_Summary__c += '[' + Label.Date_Involvement_Started + ']: ' + pp.Date_Involvement_Started__c.format() + ', ';
		  		} 
		  		if(pp.Date_Involvement_Ended__c != null) {
		  			u.Non_AECOM_Projects_Summary__c += '[' + Label.Date_Involvement_Ended + ']: ' + pp.Date_Involvement_Ended__c.format() + ', ';
		  		}
		  		u.Non_AECOM_Projects_Summary__c += String.isNotBlank(pp.Description__c) ? '[' + projectFields.get('Description__c').getDescribe().getLabel() + ']: ' + pp.Description__c : '';
		  		u.Non_AECOM_Projects_Summary__c += String.isNotBlank(u.Non_AECOM_Projects_Summary__c) ? '\r\n' : '';

		  		// set limit reached and add indicator that more data exists but field cannot hold any more
		  		if(u.Non_AECOM_Projects_Summary__c.length() >= nonAecomLimit) {
		  			nonAecomLimitReached = true;
		  			u.Non_AECOM_Projects_Summary__c = u.Non_AECOM_Projects_Summary__c.subString(0,nonAecomLimit-3) + '...';
		  		}
			}

			//Break out of this loop, no point if we're not adding anything
			if(aecomLimitReached && nonAecomLimitReached) {
				break;
			}
		}
	}
	update users;
}