public without sharing class CFM_ProjectContactEditController {


	public Boolean isEditMode { get; set; }
	public CFM_Project project { get; set; }
	public Contact surveyContact { get; set; }

	public String modifiedProjectName { get; set; }

	public String contactMode { get; set; }

	public Boolean wasSaved { get; set; }

	public CFM_ProjectContactEditController(ApexPages.StandardController sc) {
		isEditMode = false;
		getProject(sc.getId());
		wasSaved = false;

		if (project.obj.CFM_Survey_Contact__c != null) {
			contactMode = '1'; // Contact information is correct
			surveyContact = getContact(project.obj.CFM_Survey_Contact__c);	
		}
		else {
			surveyContact = new Contact(); // Placeholder obj for user to put in contact information
		}
	}

	private void getProject(Id projectId) {
		project = CFM_Project.findAllFields.findById(projectId);
		modifiedProjectName = project.obj.Modified_Project_Name__c;
	}

	public Boolean getHasExistingContact() {
		return project.obj.CFM_Survey_Contact__c != null;
	}


	public list<SelectOption> getContactOptions() {
	    List<SelectOption> options = new List<SelectOption>();

	    options.add(new SelectOption('1', 'This contact information is correct'));
	    options.add(new SelectOption('2', 'This is the right contact but the information is out of date. I have entered the updates below:'));
	    options.add(new SelectOption('3', 'This is the wrong contact, use the new information below:'));

	    return options;
	}

	public PageReference switchContactMode() {
		if (contactMode == '1') {
			surveyContact = getContact(project.obj.CFM_Survey_Contact__c);	
		}
		else if (contactMode == '2') {
			surveyContact = getContact(project.obj.CFM_Survey_Contact__c);	
		}
		else if (contactMode == '3') {
			surveyContact = new Contact();
		}

		return null;
	}


	public PageReference setEditMode() {
		isEditMode = true;
		return null;
	}


	public PageReference cancelEdit() {
		contactMode = '1';
		getProject(project.getId());
		isEditMode = false;
		return null;
	}


	public PageReference performSave() {
		
		if (String.isBlank(surveyContact.LastName)) {
			CFM_PageUtil.addError('Please enter the contact\'s last name');
			return null;
		}
		if (String.isBlank(surveyContact.Email)) {
			CFM_PageUtil.addError('Please enter the contact\'s email');
			return null;
		}

		if (surveyContact.Id != null) {
			update surveyContact;
		}
		else {
			List<Contact> existingContact = [Select Id from Contact where AccountId = :project.obj.Owner__c and Email = :surveyContact.Email];

			surveyContact.AccountId = project.obj.Owner__c;
			surveyContact.Status__c = 'Active';

			if (existingContact.size() > 0) {
				surveyContact.Id = existingContact.get(0).Id;
			}
			
			upsert surveyContact; 


			project.obj.CFM_Survey_Contact__c = surveyContact.Id;
		}

		project.obj.Modified_Project_Name__c = modifiedProjectName;
	
		project.save();

		wasSaved = true;


		CFM_PageUtil.addConfirm('Contact information updated');

		return null;
	}


	private static Contact getContact(Id contactId) {
		return [Select Id, FirstName, LastName, Email, Phone, Survey_Language__c from Contact where Id = :contactId];	
	}
}