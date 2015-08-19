public with sharing class ECO_BudgetQuestionnaireController {
	
	private class BudgetQuestionnaireControllerException extends Exception {}
	
	public pse__Proj__c theProject							{ get; set; }
	public Map<Integer, BudgetMilestone__c>	milestones		{ get; set; }
	public Map<Integer, RelocationSecondment__c> relocs		{ get; set; }
	public Integer selectedRecordNumber						{ get; set; }
	
	private Set<BudgetMilestone__c> milestonesToDelete;
	private List<RelocationSecondment__c> relocsToDelete;
	private String retURL;
	
	private Transient Attachment budgetQuestionnaireAttachment;
	public String overrideBudgetQuestionnaireName  {get;set;}
	public map<Id, Attachment> attachmentsMap {get; set;}	
		
	public ECO_BudgetQuestionnaireController (ApexPages.StandardController con) {
		theProject = ECO_Service_Projects.getProjectById(con.getId());
		
		if (theProject.DateLastCompletedBudgetQuestionnaire__c == null 
			&& !theProject.AgreementsProject__r.isEmpty()) {
				theProject.PaymentTerms__c = theProject.AgreementsProject__r[0].PaymentTerms__c;
		}
		
		try {
			retURL = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('retURL'), 'UTF-8');
		} catch (Exception e) {
			retURL = '/'+theProject.Id;
		}
		
		milestonesToDelete = new Set<BudgetMilestone__c>();
		relocsToDelete = new List<RelocationSecondment__c>();
		
		populateMilestones();
		populateRelocs();
		populateAttachmentsMap();
		
	}
	
	private void populateAttachmentsMap()
	{
		attachmentsMap = new Map<Id, Attachment>([select Id, Name, ContentType, LastModifiedDate, LastModifiedById from Attachment where parentId = :theProject.Id]);
	}
	
	public Attachment docBudgetQuestionnaireAttachment
    {
        get
        {
            if(budgetQuestionnaireAttachment==null)
            {
                budgetQuestionnaireAttachment = new Attachment(parentid = theProject.id);
            }
            return budgetQuestionnaireAttachment;
        }
        set;
    }	
    
    private list<Attachment> getAttachmentListFromIdList(list<String> attachmentIds)
    {
    	list<Attachment> attachments = new list<Attachment>();
        for(String attachmentId:attachmentIds)
    	{
    		if(attachmentsMap.containsKey(attachmentId) && attachmentId != null && attachmentId != '')
    			attachments.add(attachmentsMap.get(attachmentId));
    	}
    	return attachments;	
    }
       
    public list<Attachment> getAttachedBudgetQuestionnaireFiles()
    {

    	list<String> attachmentIds = new list<String>();
    	if(theProject.BudgetQuestionnaireAttachments__c != null)
			attachmentIds = theProject.BudgetQuestionnaireAttachments__c.split(';');
			
    	return getAttachmentListFromIdList(attachmentIds);
    }
    
    public void saveBudgetQuestionnaireAttachmentAndProject()
    {
    	if(budgetQuestionnaireAttachment.Body != null)
    	{	
    		if(overrideBudgetQuestionnaireName != null && overrideBudgetQuestionnaireName != '')
    			budgetQuestionnaireAttachment.Name = overrideBudgetQuestionnaireName;   			
    		insert budgetQuestionnaireAttachment;
    		
    		if(theProject.BudgetQuestionnaireAttachments__c != null)
    			theProject.BudgetQuestionnaireAttachments__c += budgetQuestionnaireAttachment.Id + ';';
    		else
    			theProject.BudgetQuestionnaireAttachments__c = budgetQuestionnaireAttachment.Id + ';';    		
    		update theProject;
    		
    		attachmentsMap = new Map<Id, Attachment>([select Id, Name, ContentType, LastModifiedDate, LastModifiedById from Attachment where parentId = :theProject.Id]);
    		budgetQuestionnaireAttachment = null;
    	}    	   	
    }    
	
	public PageReference goToAttachmentPage () {
		try {
			system.debug('selectedRecordNumber:  '+selectedRecordNumber);
			
			RelocationSecondment__c thisReloc = relocs.get(selectedRecordNumber);
			
			upsert thisReloc;
			
			PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/p/attach/NoteAttach?pid='+thisReloc.Id+'&parentname=Relocation+%2F+Secondment&retURL=%2Fapex%2FECO_BudgetQuestionnaire%3Fid%3D'+theProject.Id);
			
			return pr;
		} catch (Exception e) {
			ApexPages.addMessages(e);
			return null;
		}
	}
	
	private void populateMilestones () {
		milestones = new Map<Integer, BudgetMilestone__c>();
		
		Integer recordNumber=0;
		for (BudgetMilestone__c bm : [SELECT Id
											, Amount__c
											, ExDate__c
											, Project__c
											, Description__c
									FROM BudgetMilestone__c 
									WHERE Project__c = :theProject.Id
										ORDER BY ExDate__c]) {
			milestones.put(recordNumber, bm);
			recordNumber++;
		}
		
		if (milestones.isEmpty()) {
			for (Integer i = 0; i <= 4; i++) {
				addMilestone();
			}
		}
	}
	
	private void populateRelocs () {
		relocs = new Map<Integer, RelocationSecondment__c>();
		
		Integer recordNumber=0;
		for (RelocationSecondment__c rs : [SELECT Id
											, EstimatedCost__c
											, HomeLocation__c
											, Name__c
											, Project__c
											, SecondmentLocation__c
											, (SELECT Id
													, Name 
												FROM Attachments)
									FROM RelocationSecondment__c 
									WHERE Project__c = :theProject.Id
										ORDER BY Name__c]) {
			relocs.put(recordNumber, rs);
			recordNumber++;
		}
		
		if (relocs.isEmpty()) {
			for (Integer i = 0; i <= 4; i++) {
				addReloc();
			}
		}
	}
	
	private Integer getNextMilestoneNumber () {
		Integer milestoneNumber = 0;
		for (Integer i : milestones.keySet()) {
			if (milestoneNumber <= i) {
				milestoneNumber = i+1;
			}
		}
		return milestoneNumber;
	}
	
	private Integer getNextRelocNumber () {
		Integer relocNumber = 0;
		for (Integer i : relocs.keySet()) {
			if (relocNumber <= i) {
				relocNumber = i+1;
			}
		}
		return relocNumber;
	}
	
	public PageReference saveAndReturn () {
		doSaveAction();
		
		return new PageReference(retURL);
	}
	
	public void doSaveAction () {
		System.savepoint sp = Database.setSavepoint();
		
		try {
			theProject.DateLastCompletedBudgetQuestionnaire__c = Datetime.now();
			
			system.debug('theProject.DateLastCompletedBudgetQuestionnaire__c:  '+theProject.DateLastCompletedBudgetQuestionnaire__c);
			
			update theProject;

			List<BudgetMilestone__c> milestonesToUpsert = new List<BudgetMilestone__c>();

			for (BudgetMilestone__c milestone : milestones.values()) {
				if (milestone.ExDate__c != null) {
					milestonesToUpsert.add(milestone);
				}
			}
			
			if (!milestonesToUpsert.isEmpty()) {
				upsert milestonesToUpsert;
			}
			
			if (!milestonesToDelete.isEmpty()) {
				delete new List<BudgetMilestone__c>(milestonesToDelete);
			}
			
			if (!relocs.isEmpty()) {
				upsert relocs.values();
			}
			
			if (!relocsToDelete.isEmpty()) {
				delete relocsToDelete;
			}
		} catch (Exception e) {
			system.debug('Handling Exception:  '+e.getLineNumber()+'-'+e.getMessage()+'- '+e.getStackTraceString());
			Database.rollback(sp);
			ApexPages.addMessages(e);
		}
	}
	
	public PageReference addMilestone () {
		milestones.put(getNextMilestoneNumber(), new BudgetMilestone__c(Project__c = theProject.Id));
		return null;
	}
	
	public PageReference removeMilestone () {
		system.debug('milestones:  '+milestones);
		system.debug('selectedRecordNumber:  '+selectedRecordNumber);
		
		BudgetMilestone__c selectedMilestone = milestones.get(selectedRecordNumber);
		
		if (selectedMilestone.Id != null) {
			milestonesToDelete.add(new BudgetMilestone__c(Id = selectedMilestone.Id));
		}
		
		milestones.remove(selectedRecordNumber);
		return null;
	}
	
	public PageReference addReloc () {
		relocs.put(getNextRelocNumber(), new RelocationSecondment__c(Project__c = theProject.Id));
		return null;
	}
	
	public PageReference removeReloc () {
		RelocationSecondment__c selectedRelocation = relocs.get(selectedRecordNumber);
		
		if (selectedRelocation.Id != null) {
			relocsToDelete.add(new RelocationSecondment__c(Id = selectedRelocation.Id));
		}
		
		relocs.remove(selectedRecordNumber);
		return null;
	}
	
	public PageReference cancelAndReturn () {
		return new PageReference(retURL);
	}
	
	public PageReference toggleEscalationSection () {
		if (!theProject.EscalationApplies__c) {
			theProject.EscalationDate__c = null;
			theProject.EscalationDescription__c = '';
		}
		return null;
	}
	
	public PageReference toggleMilestoneSection () {
		return null;
	}
	
	public PageReference calculateMilestones () {
		try {
			Boolean hasErrors = false;
			if (theProject.MilestoneFrequency__c == null) {
				hasErrors = true;
				theProject.MilestoneFrequency__c.addError('Milestone frequency is required to calculate milestones.');
			}
			
			if (theProject.pse__Start_Date__c == null) {
				hasErrors = true;
				theProject.pse__Start_Date__c.addError('Project Start Date is required to calculate milestones.');
			}
			
			if (theProject.pse__End_Date__c == null) {
				hasErrors = true;
				theProject.pse__End_Date__c.addError('Project end date is required to calculate milestones.');
			}
			
			Integer daysBetweenStartAndEnd = theProject.pse__Start_Date__c.daysBetween(theProject.pse__End_Date__c);
			Integer wholePeriodsBetweenStartAndEnd = Integer.valueOf(daysBetweenStartAndEnd / theProject.MilestoneFrequency__c);
			
			milestones = new Map<Integer, BudgetMilestone__c>();
			Date milestoneDate = theProject.pse__Start_Date__c;
			for (Integer i=0;i<wholePeriodsBetweenStartAndEnd;i++) {
				BudgetMilestone__c newMilestone = new BudgetMilestone__c(Project__c = theProject.Id);
				newMilestone.ExDate__c = milestoneDate;
				milestones.put(i, newMilestone);
				
				milestoneDate = milestoneDate.addDays(Integer.valueOf(theProject.MilestoneFrequency__c));
			}
			
			if (milestones.values()[milestones.size()-1].ExDate__c != theProject.pse__End_Date__c) {
				BudgetMilestone__c newMilestone = new BudgetMilestone__c(Project__c = theProject.Id);
				newMilestone.ExDate__c = theProject.pse__End_Date__c;
				milestones.put(getNextMilestoneNumber(), newMilestone);
			}
			
			if (hasErrors) {
				//throw new BudgetQuestionnaireControllerException('Validation Error Caught!');
			}
			
			
		} catch (Exception e) {
			ApexPages.addMessages(e);
		}
		return null;
	}
}