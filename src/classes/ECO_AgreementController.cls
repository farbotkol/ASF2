global virtual class ECO_AgreementController {
  
    public Agreement__c agreement {get; set;}
    public pse__Proj__c project {get; set;}
    
    public Boolean MSAChanged {get; set;}
    
    private Transient Attachment contractAttachment;
    public String overrideContractAttachmentName  {get;set;}

    private Transient Attachment programPlanAttachment;
    public String overrideProgramPlanAttachmentName  {get;set;}

    private Transient Attachment guidanceAttachment;
    public String overrideGuidanceAttachmentName  {get;set;}

    private Transient Attachment businessDevelopmentAttachment;
    public String overrideBusinessDevelopmentAttachmentName  {get;set;}

    private Transient Attachment meetingMinutesAttachment;
    public String overrideMeetingMinutesAttachmentName  {get;set;}

    public map<Id, Attachment> attachmentsMap {get; set;}
    
    public list<OtherDirectCost__c> otherDirectCosts {get; set;}    
    public list<ManagementTeam__c> managementTeamMembers {get; set;}
    public list<Approved_Sub__c> approvedSubs {get; set;}
    public list<MSATeamingPartner__c> msaTeamingPartners {get; set;}
    public list<Agreement__c> relatedAgreements {get; set;}
    public list<BillRate__c> billingRates {get; set;}
    public list<Note> notes {get; set;}
    public list<Funding__c> fundings{get; set;}
    public list<ManagementTeam__c> msaManagementTeamMembers{get;set;}
    public list<DOAConditions__c> msaDOAConditions {get; set;}
    public list<pse__Proj__c> projects {get; set;}
    
    protected String projectId;
    private String projectAccountId;
    public String mode {get;set;}
    private String recordTypeId;
    private String contractType;
    private String accountId;
    public Id agreementId {get;set;}
    public Agreement__c msaAgreement {get; set;}
    private Boolean createdFromAgreementPage = false;
    
    public String projectFundingId {get; set;}
    
    public String contractDocumentType {get; set;}
    public String contractDocumentComments {get; set;}
    public String guidanceAttachmentComments{get; set;}
    public String programPlanAttachmentComments{get; set;}
    public String businessDevelopmentAttachmentComments{get;set;}
    public String meetingMinutesAttachmentComments{get;set;}
    public Map<Id, list<Funding__c>> projectFundingMap {get; set;}
    public string agreementRecordType {get;set;}
    
    public string testTabId {get; set;}
    
    public ECO_AgreementController(ApexPages.standardController sc)
    {
        agreement = (Agreement__c)sc.getRecord();  
        MSAChanged = false;                  
    }
    
    public void handleDeletingCancelledChildObject()
    {
    	String delRecordId = Apexpages.currentPage().getParameters().get('RecordToDelete');
		String delRecordType = Apexpages.currentPage().getParameters().get('DeleteRecordType');
		if(delRecordType == 'ManagementTeam')
		{	
			ManagementTeam__c managementTeamMember = [select Id from ManagementTeam__c where Id = :delRecordId];
			delete managementTeamMember;
		}  
		else if(delRecordTYpe == 'PurchaseOrder')
		{
			POHeader__c purchaseOrder = [select Id from POHeader__c where Id = :delRecordId];
			delete purchaseOrder;
		}	
    }
    
    public void init()
    {
    	if(Apexpages.currentPage().getParameters().get('RecordToDelete') != null)
		{
			handleDeletingCancelledChildObject();		
		}
    	 	   
        projectId = ApexPages.currentPage().getParameters().get('ProjectId');
        recordTypeId = ApexPages.currentPage().getParameters().get('RecordType'); 
        mode = ApexPages.currentPage().getParameters().get('Mode'); 
      
        if(mode == 'New')
            project = [select Id, Name, EstimatedContractValue__c, EcoSystemReferenceNumber__c, OracleProjectnumber__c, pse__Project_Manager__c from pse__Proj__c where Id = :projectId limit 1];       
                
        if(recordTypeId != null && recordTypeId != '')
        {  
            mode = 'New';     
            createdFromAgreementPage = true;
            agreementRecordType = [select Id, Name from RecordType where Id = :recordTypeId].Name;
        }
        else if((recordTypeId == null || recordTypeId == '') && (contractType == '' || contractType == null))
        {
            agreement = ECO_Service_Agreement.getAgreementFromId(agreement.Id);
            
            if(agreement.Project__c != null) 
            	project = ECO_Service_Agreement.getProjectFromId(agreement.Project__c); 
            else
            {
            	if(!agreement.ISMSA__c)
            	{
            		project = ECO_Service_Agreement.getProjectFromProjectAgreement(agreement.Id); 
            		agreement.Project__c = project.Id; 
            		update agreement;
            		agreement = ECO_Service_Agreement.getAgreementFromId(agreement.Id);	  
            	}        
            }        
            
            agreementRecordType = agreement.RecordType.Name;
        } 

        populateRelatedAgreementObjects();     
    }
       
    public String getContractReviewStatus()
    {
    	list<Contract_Review__c> requests = [select Id, Status_Review__c from Contract_Review__c where Agreement__c = :agreement.Id];
    	
    	if(requests.size() == 0)	
    		return 'Not Submitted';
    	return requests[0].Status_Review__c;  	
    }   
    
    private void populateRelatedAgreementObjects()
    {
        if(mode != 'New')
        {           
            relatedAgreements = new list<Agreement__c>();
            attachmentsMap = new Map<Id, Attachment>([select Id, Name, ContentType, LastModifiedDate, LastModifiedById from Attachment where parentId = :agreement.Id]);
            managementTeamMembers = [select Id, Name, TeamMember__r.Name, Role__c, TeamMember__r.Title, TeamMember__r.Phone, TeamMember__r.Email from ManagementTeam__c where Agreement__c = :agreement.Id];				
            approvedSubs = [select Id, Name, Contact_Name__c, Email__c, Phone__c, Role__c, Account__r.Name, Comments__c from Approved_Sub__c where Agreement__c = :agreement.Id];
            msaTeamingPartners = [select Id, Name, Contact_Name__c, Email__c, Phone__c, Role__c, Account__r.Name from MSATeamingPartner__c where Agreement__c = :agreement.Id];
            otherDirectCosts = [select Id, Name, Type__c, Comments__c, Description__c, Markup__c, Allowable__c from OtherDirectCost__c where Agreement__c = :agreement.Id];
            relatedAgreements = [select Id, Name, Project__r.pse__Project_Status__c, Project__r.OracleProjectnumber__c, Amount__c,
            										Project__r.pse__Billing_Eligible_Last_Updated__c, Project__r.EstimatedContractValue__c, 
            										Project__r.pse__Project_Manager__c, Project__r.Task_number__c, Project__r.ProjectNumber__c, 
            										Project__r.Name, project__r.TotalApprovedCost__c, project__r.CostComplete__c, project__r.GoProbability__c, project__r.GetProbability__c
            						from Agreement__c where MSAReference__c = :agreement.Id];
            billingRates = [select Id, Name, BillRatePeriod__r.BillRateStart__c, BillRatePeriod__r.BillRateEnd__c, LaborCategory__c, BillRate__c from BillRate__c where Agreement__c = :agreement.Id order by BillRatePeriod__r.BillRateStart__c, LaborCategory__c limit 10];
            notes = [select Id, ParentId, Title, Body from Note where parentId = :agreement.Id];
            fundings = [select Id, Name, Project__c, AllocatedAmount__c, DateAllocatedDate__c,CreatedDate, TotalBaselinedAmount__c from Funding__c where Agreement__c = :agreement.Id];   
			if(agreement.MSAReference__c != null)
			{
            	msaManagementTeamMembers = [select Id, Name, TeamMember__r.Name, Role__c, TeamMember__r.Title, TeamMember__r.Phone, TeamMember__r.Email from ManagementTeam__c where Agreement__c = :agreement.MSAReference__c];				
				msaDOAConditions = [select Id, Name, DOARegister__c, Mitigation_Plan__c, DoATriggerNo__c, TriggerDescription__c, DOAApprovalRequest__c, Completed__c, ComplianceDate__c, ComplianceStatus__c, Level__c from DOAConditions__c where Agreement__c = :agreement.MSAReference__c];
			}
			projects = [select Id, Name from pse__Proj__c where Id in (select Project__c from ProjectAgreement__c where Agreement__c  = :agreement.Id)];
			if(projects.size() > 1)
			{
				projectFundingMap = new map<Id, list<Funding__c>>();
				for(pse__Proj__c proj:projects)
				{
					projectFundingMap.put(proj.Id, new list<Funding__c>());	
				}
				for(Funding__c fund:fundings)
				{
					projectFundingMap.get(fund.Project__c).add(fund);
				}	
			}			
        }   
        else
        {
            attachmentsMap = new map<Id, Attachment>();
            otherDirectCosts = new list<OtherDirectCost__c>();
            managementTeamMembers = new list<ManagementTeam__c> ();
            approvedSubs = new list<Approved_Sub__c>();
            msaTeamingPartners = new list<MSATeamingPartner__c>();
            billingRates = new list<BillRate__c>();
            fundings = new list<Funding__c>();
            notes = new list<Note>();       
            relatedAgreements = new list<Agreement__c>();
            msaManagementTeamMembers = new list<ManagementTeam__c>();
            msaDOAConditions = new list<DOAConditions__c>();
        }       
    }
    
    /*public Component.Apex.TabPanel getProjectFundingTabs()
    {
    	Component.Apex.TabPanel myTabPanel = new Component.Apex.TabPanel();
    	myTabPanel.switchType = 'client';
		//create parent panelComponent.Apex.TabPanel myTabPanel = new Component.Apex.TabPanel();
		for (pse__Proj__c project:[select Id, Name from pse__Proj__c where Id in (select Project__c from ProjectAgreement__c where Agreement__c  = :agreement.Id)])  //just a sample, this could easily be a SOQL loop
		{
			Component.Apex.Tab myTab = new Component.Apex.Tab();
 			myTab.Label = project.Name;
  			//add child tabs to the parent
  			
  			Component.Apex.CommandButton command = new Component.Apex.CommandButton();
            command.value='Manage Funding';
            command.expressions.action='{!manageFundingFromTab}';
            
            Component.Apex.OutputText ouputTextProjectId = new Component.Apex.OutputText();
            //textValue.expressions.value = '{!project.Id}';
            ouputTextProjectId.value = project.Id;
            
             Component.Apex.OutputText ouputTextProjectId2 = new Component.Apex.OutputText();
            ouputTextProjectId2.expressions.value = '{!testTabId}';
            //ouputTextProjectId.value = project.Id;
            
            Component.Apex.PageblockTable table = new Component.Apex.PageblockTable();
            table.expressions.value='{!fundings}';
            table.var = 'funding';
            
            Component.Apex.Column firstNameCol = new Component.Apex.Column();
            firstNameCol.expressions.value = '{!funding.DateAllocatedDate__c}';            
            table.childComponents.add(firstNameCol);

            Component.Apex.Column secondNameCol = new Component.Apex.Column();
            secondNameCol.expressions.value = '{!funding.AllocatedAmount__c}';
                        
            myTab.childComponents.add(command);
            myTab.childComponents.add(table);
    		myTab.childComponents.add(ouputTextProjectId);
    		myTab.childComponents.add(ouputTextProjectId2);
    		myTabPanel.childComponents.add(myTab);
		}
		return myTabPanel;
    }*/
    
    /*public PageReference manageFundingFromTab()
    {
    	String delRecordId = Apexpages.currentPage().getParameters().get('RecordToDelete');
    	return null;
    } */
    
    public Attachment contractAttach
    {
        get
        {
            if(contractAttachment==null)
            {
                contractAttachment = new Attachment(parentid = agreement.id);
            }
            return contractAttachment;
        }
        set;
    }    
 
    public Attachment guidanceAttach
    {
        get
        {
            if(guidanceAttachment==null)
            {
                guidanceAttachment = new Attachment(parentid = agreement.id);
            }
            return guidanceAttachment;
        }
        set;
    } 
    
    public Attachment programPlanAttach
    {
        get
        {
            if(programPlanAttachment==null)
            {
                programPlanAttachment = new Attachment(parentid = agreement.id);
            }
            return programPlanAttachment;
        }
        set;
    }     
    
    public Attachment businessDevelopmentAttach
    {
        get
        {
            if(businessDevelopmentAttachment==null)
            {
                businessDevelopmentAttachment = new Attachment(parentid = agreement.id);
            }
            return businessDevelopmentAttachment;
        }
        set;
    }      
       
    public Attachment meetingMinutesAttach
    {
        get
        {
            if(meetingMinutesAttachment==null)
            {
                meetingMinutesAttachment = new Attachment(parentid = agreement.id);
            }
            return meetingMinutesAttachment;
        }
        set;
    }       
    
    public PageReference msaProjectSnapshot()
    {
     	PageReference pageRef = new PageReference('/apex/ECO_MSAProjectSnapshot');
    	
    	pageRef.getParameters().put('MSAId', agreement.Id);
    	pageRef.getParameters().put('retURL', '/apex/ECO_AgreementView?Id='+agreement.Id);
    	pageRef.getParameters().put('save_new', '1');
    	pageRef.getParameters().put('sfdc.override', '1');
    	   	
    	return pageRef;
    }
    
    public PageReference initiateContractReview()
    {
    	PageReference pageRef = new PageReference('/apex/NewContractReview');
    	
    	pageRef.getParameters().put('AgreementId', agreement.Id);
    	pageRef.getParameters().put('retURL', '/apex/ECO_AgreementView?Id='+agreement.Id);
    	pageRef.getParameters().put('save_new', '1');
    	pageRef.getParameters().put('sfdc.override', '1');
    	
    	return pageRef;    	
    } 
    
    public PageReference launchSegmentationQuestionnaire()
    {
    	PageReference pageRef = new PageReference('/apex/ECO_ProjectSegmentation');
    	
    	pageRef.getParameters().put('retURL', '/apex/ECO_AgreementView?Id='+agreement.Id);
    	pageRef.getParameters().put('AgreementId', agreement.Id);
    	pageRef.getParameters().put('Id', agreement.Id);
    	pageRef.getParameters().put('save_new', '1');
    	pageRef.getParameters().put('sfdc.override', '1');
    	return pageRef;
    }
    
    public PageReference returnToAgreement()
    {
        return new PageReference('/a4Y/o');
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
    
	public list<SelectOption> getContractDocumentTypes()
	{
	    list<SelectOption> options = new list<SelectOption>();
	    options.add(new SelectOption('', '--None--'));
	    options.add(new SelectOption('Executed Contract', 'Executed Contract'));
	    options.add(new SelectOption('Task Order', 'Task Order'));
	    options.add(new SelectOption('RFP', 'RFP'));
	    options.add(new SelectOption('Proposal', 'Proposal'));
	    options.add(new SelectOption('Clarifications', 'Clarifications'));
	    options.add(new SelectOption('Addendum', 'Addendum'));
	    options.add(new SelectOption('Teaming Agreement', 'Teaming Agreement'));
	
	    return options;
	}    
	
	public class ContractAttachment
	{
		public String attachmentId {get; set;}
		public String attachmentType {get; set;}
		public String comments {get; set;}
		public Attachment attachment {get; set;}		
	}
	
	public class MSAAttachment
	{
		public String attachmentId {get; set;}
		public Attachment attachment {get; set;}		
		public String comments {get; set;}		
	}
       
    public list<ContractAttachment> getAttachedContractFiles()
    {
    	ContractAttachment contractAttachment;
    	
    	map<String, ContractAttachment> contractAttachmentsMap = new map<String, ContractAttachment>();
    	
    	list<String> attachmentIdQueryList = new list<String>();
        list<String> attachmentIds = new list<String>();
        
        if(agreement.ContractAttachment__c != null && agreement.ContractAttachment__c != '')         
            attachmentIds = agreement.ContractAttachment__c.split('::');
            
        String typeCommentsString = '';
       	for(String attachmentString:attachmentIds)
       	{
       		contractAttachment = new ContractAttachment();	
       		contractAttachment.attachmentId = attachmentString.split(';;').get(0);
       		
       		typeCommentsString = attachmentString.split(';;').get(1);	
       		contractAttachment.attachmentType = typeCommentsString.substring(0, typeCommentsString.indexOf('||')); //typeCommentsString.split('||').get(0);
       		contractAttachment.comments = typeCommentsString.substring(typeCommentsString.indexOf('||') +2, typeCommentsString.length()); // typeCommentsString.split('||').get(1);
       		//00Pe0000002braBEAQ;;Executed Contract||No Comments::
       			
       		contractAttachmentsMap.put(contractAttachment.attachmentId, contractAttachment);
       	} 
       	attachmentIdQueryList.addAll(contractAttachmentsMap.keySet());	   
        list<Attachment> attachments = getAttachmentListFromIdList(attachmentIdQueryList);
        
        for(Attachment attachment:attachments)
        {
        	contractAttachmentsMap.get(attachment.Id).Attachment = attachment;
        }
        
        return contractAttachmentsMap.values();
        
    }    
    
    public void saveContractAttachment()
    {
        if(contractAttachment.Body != null)
        {   
            if(overrideContractAttachmentName != null && overrideContractAttachmentName != '')
                contractAttachment.Name = overrideContractAttachmentName;  
                             
            insert contractAttachment;
            
            if(contractDocumentType == null || contractDocumentType == '')
            	contractDocumentType = '--None--';
            
            if(contractDocumentComments == null || contractDocumentComments == '')
            	contractDocumentComments = 'No Comments';	
            
            if(agreement.ContractAttachment__c != null)
            {
                agreement.ContractAttachment__c += contractAttachment.Id + ';;' + contractDocumentType + '||' + contractDocumentComments + '::';
            }
            else
                agreement.ContractAttachment__c =  contractAttachment.Id + ';;' + contractDocumentType + '||' + contractDocumentComments + '::';          
            update agreement;
            
            attachmentsMap = new Map<Id, Attachment>([select Id, Name, ContentType, LastModifiedDate, LastModifiedById from Attachment where parentId = :agreement.Id]);
            contractAttachment = null;
        }           
    }    

    public list<MSAAttachment> getAttachedGuidanceFiles()
    {      
    	MSAAttachment guidanceAttachment;
    	
    	map<String, MSAAttachment> guidanceAttachmentsMap = new map<String, MSAAttachment>();
    	
    	list<String> attachmentIdQueryList = new list<String>();
        list<String> attachmentIds = new list<String>();
        
        if(agreement.GuidanceAttachment__c != null && agreement.GuidanceAttachment__c != '')         
            attachmentIds = agreement.GuidanceAttachment__c.split('::');
       	for(String attachmentString:attachmentIds)
       	{
       		guidanceAttachment = new MSAAttachment();	
       		guidanceAttachment.attachmentId = attachmentString.split(';;').get(0);
       		guidanceAttachment.comments = attachmentString.split(';;').get(1);	
       			
       		guidanceAttachmentsMap.put(guidanceAttachment.attachmentId, guidanceAttachment);
       	} 
       	attachmentIdQueryList.addAll(guidanceAttachmentsMap.keySet());	   
        list<Attachment> attachments = getAttachmentListFromIdList(attachmentIdQueryList);
        
        for(Attachment attachment:attachments)
        {
        	guidanceAttachmentsMap.get(attachment.Id).Attachment = attachment;
        }
        
        return guidanceAttachmentsMap.values();                
    }    
    
    public void saveGuidanceAttachment()
    {
        if(guidanceAttachment.Body != null)
        {   
            if(overrideGuidanceAttachmentName != null && overrideGuidanceAttachmentName != '')
                guidanceAttachment.Name = overrideGuidanceAttachmentName;               
            insert guidanceAttachment;
            
            if(guidanceAttachmentComments == null || guidanceAttachmentComments == '')
            	guidanceAttachmentComments = 'No Comments';
            
            if(agreement.GuidanceAttachment__c != null)
                agreement.GuidanceAttachment__c += guidanceAttachment.Id + ';;' + guidanceAttachmentComments + '::';
            else
                agreement.GuidanceAttachment__c = guidanceAttachment.Id + ';;' + guidanceAttachmentComments + '::';         
            update agreement;
            
            attachmentsMap = new Map<Id, Attachment>([select Id, Name, ContentType, LastModifiedDate, LastModifiedById from Attachment where parentId = :agreement.Id]);
            guidanceAttachmentComments = '';
            guidanceAttachment = null;
        }           
    }    

    public list<MSAAttachment> getAttachedProgramPlanFiles()
    {
       	MSAAttachment programPlanAttachment;
    	
    	map<String, MSAAttachment> programPlansAttachmentsMap = new map<String, MSAAttachment>();
    	
    	list<String> attachmentIdQueryList = new list<String>();
        list<String> attachmentIds = new list<String>();
        
        if(agreement.ProgramPlanAttachment__c != null)         
            attachmentIds = agreement.ProgramPlanAttachment__c.split('::');
            
       	for(String attachmentString:attachmentIds)
       	{
       		programPlanAttachment = new MSAAttachment();	
       		programPlanAttachment.attachmentId = attachmentString.split(';;').get(0);
       		programPlanAttachment.comments = attachmentString.split(';;').get(1);	
       			
       		programPlansAttachmentsMap.put(programPlanAttachment.attachmentId, programPlanAttachment);
       	} 
       	attachmentIdQueryList.addAll(programPlansAttachmentsMap.keySet());	   
        list<Attachment> attachments = getAttachmentListFromIdList(attachmentIdQueryList);
        
        for(Attachment attachment:attachments)
        {
        	programPlansAttachmentsMap.get(attachment.Id).Attachment = attachment;
        }       
        return programPlansAttachmentsMap.values();       
    }    
    
    public void saveProgramPlanAttachment()
    {
        if(programPlanAttachment.Body != null)
        {   
            if(overrideProgramPlanAttachmentName != null && overrideProgramPlanAttachmentName != '')
                programPlanAttachment.Name = overrideProgramPlanAttachmentName;             
            insert programPlanAttachment;

            if(programPlanAttachmentComments == null || programPlanAttachmentComments == '')
            	programPlanAttachmentComments = 'No Comments';
           
            if(agreement.ProgramPlanAttachment__c != null)
                agreement.ProgramPlanAttachment__c += programPlanAttachment.Id + ';;' + programPlanAttachmentComments + '::';
            else
                agreement.ProgramPlanAttachment__c = programPlanAttachment.Id + ';;' + programPlanAttachmentComments + '::';            
            update agreement;
            
            attachmentsMap = new Map<Id, Attachment>([select Id, Name, ContentType, LastModifiedDate, LastModifiedById from Attachment where parentId = :agreement.Id]);
            
            programPlanAttachmentComments = '';
            programPlanAttachment = null;
        }           
    }  
    
    public PageReference viewMSA()
    {
    	PageReference pageRef = new PageReference('/' + agreement.MSAReference__c);
    	return pageRef;
    }
    
    public list<POHeader__c> getPurchaseOrders()
    {
    	list<POHeader__c> purchaseOrders = [select Id, Name, PODate__c, POType__c, Project__c, Requestor__c, Status__c
    										, CreatedDate, CreatedById, Total__c from POHeader__c where Agreement__c = :agreement.Id];
    	
    	if(purchaseOrders.size() == 0)
    		return null;
    	return purchaseOrders;  	
    }
       
    public PageReference newPurchaseOrder()
    {
    	POHeader__c purchaseOrder = new POHeader__c(Agreement__c = agreement.Id, Project__c = project.Id);
    	insert purchaseOrder;
    	
    	PageReference myPage = new PageReference('/' + purchaseOrder.Id + '/e');
    	myPage.getParameters().put('saveURL', '/apex/ECO_AgreementView?Id=' + agreement.Id);
    	myPage.getParameters().put('retURL', '/apex/ECO_AgreementView?Id=' + agreement.Id + '&RecordToDelete='+ purchaseOrder.Id + '&DeleteRecordType=PurchaseOrder');
   
    	return myPage;
    }
    
    public list<MSAAttachment> getAttachedBusinessDevelopmentFiles()
    {
       	MSAAttachment businessDevelopmentAttachment;
    	
    	map<String, MSAAttachment> businessDevelopmentAttachmentsMap = new map<String, MSAAttachment>();
    	
    	list<String> attachmentIdQueryList = new list<String>();
        list<String> attachmentIds = new list<String>();
        
        if(agreement.BusinessDevelopmentAttachment__c != null)         
            attachmentIds = agreement.BusinessDevelopmentAttachment__c.split('::');
            
       	for(String attachmentString:attachmentIds)
       	{
       		businessDevelopmentAttachment = new MSAAttachment();	
       		businessDevelopmentAttachment.attachmentId = attachmentString.split(';;').get(0);
       		businessDevelopmentAttachment.comments = attachmentString.split(';;').get(1);	
       			
       		businessDevelopmentAttachmentsMap.put(businessDevelopmentAttachment.attachmentId, businessDevelopmentAttachment);
       	} 
       	attachmentIdQueryList.addAll(businessDevelopmentAttachmentsMap.keySet());	   
        list<Attachment> attachments = getAttachmentListFromIdList(attachmentIdQueryList);
        
        for(Attachment attachment:attachments)
        {
        	businessDevelopmentAttachmentsMap.get(attachment.Id).Attachment = attachment;
        }       
        return businessDevelopmentAttachmentsMap.values();                 
    }    
    
    public void saveBusinessDevelopmentAttachment()
    {
        if(businessDevelopmentAttachment.Body != null)
        {   
            if(overrideBusinessDevelopmentAttachmentName != null && overrideBusinessDevelopmentAttachmentName != '')
                businessDevelopmentAttachment.Name = overrideBusinessDevelopmentAttachmentName;             
            insert businessDevelopmentAttachment;
            
            if(businessDevelopmentAttachmentComments == null || businessDevelopmentAttachmentComments == '')
            	businessDevelopmentAttachmentComments = 'No Comments';
                     
            if(agreement.BusinessDevelopmentAttachment__c != null)
                agreement.BusinessDevelopmentAttachment__c += businessDevelopmentAttachment.Id + ';;' + businessDevelopmentAttachmentComments + '::';
            else
                agreement.BusinessDevelopmentAttachment__c = businessDevelopmentAttachment.Id + ';;' + businessDevelopmentAttachmentComments + '::';            
            update agreement;
            
            attachmentsMap = new Map<Id, Attachment>([select Id, Name, ContentType, LastModifiedDate, LastModifiedById from Attachment where parentId = :agreement.Id]);
            
            businessDevelopmentAttachmentComments = '';
            businessDevelopmentAttachment = null;
        }           
    } 

    public list<MSAAttachment> getAttachedMeetingMinutesFiles()
    {
       	MSAAttachment meetingMinutesAttachment;
    	
    	map<String, MSAAttachment> meetingMinutesAttachmentsMap = new map<String, MSAAttachment>();
    	
    	list<String> attachmentIdQueryList = new list<String>();
        list<String> attachmentIds = new list<String>();
        
        if(agreement.MeetingMinutesAttachment__c != null)         
            attachmentIds = agreement.MeetingMinutesAttachment__c.split('::');
            
       	for(String attachmentString:attachmentIds)
       	{
       		meetingMinutesAttachment = new MSAAttachment();	
       		meetingMinutesAttachment.attachmentId = attachmentString.split(';;').get(0);
       		meetingMinutesAttachment.comments = attachmentString.split(';;').get(1);	
       			
       		meetingMinutesAttachmentsMap.put(meetingMinutesAttachment.attachmentId, meetingMinutesAttachment);
       	} 
       	attachmentIdQueryList.addAll(meetingMinutesAttachmentsMap.keySet());	   
        list<Attachment> attachments = getAttachmentListFromIdList(attachmentIdQueryList);
        
        for(Attachment attachment:attachments)
        {
        	meetingMinutesAttachmentsMap.get(attachment.Id).Attachment = attachment;
        }       
        return meetingMinutesAttachmentsMap.values();                   
    }    
    
    public void saveMeetingMinutesAttachment()
    {
        if(meetingMinutesAttachment.Body != null)
        {   
            if(overrideMeetingMinutesAttachmentName != null && overrideMeetingMinutesAttachmentName != '')
                meetingMinutesAttachment.Name = overrideMeetingMinutesAttachmentName;               
            insert meetingMinutesAttachment;
            
            if(meetingMinutesAttachmentComments == null || meetingMinutesAttachmentComments == '')
            	meetingMinutesAttachmentComments = 'No Comments';
                
            if(agreement.MeetingMinutesAttachment__c != null)
                agreement.MeetingMinutesAttachment__c += meetingMinutesAttachment.Id + ';;' + meetingMinutesAttachmentComments + '::';
            else
                agreement.MeetingMinutesAttachment__c = meetingMinutesAttachment.Id + ';;' + meetingMinutesAttachmentComments + '::';          
            update agreement;
            
            attachmentsMap = new Map<Id, Attachment>([select Id, Name, ContentType, LastModifiedDate, LastModifiedById from Attachment where parentId = :agreement.Id]);
            meetingMinutesAttachmentComments = '';
            meetingMinutesAttachment = null;
        }           
    } 

    public PageReference editBillingRates()
    {
        PageReference pageReference = new PageReference('/apex/ECO_ContractBillingRate');
        pageReference.getParameters().put('AgreementId', agreement.Id);
        pageReference.getParameters().put('retURL', '/apex/ECO_AgreementView?'+agreement.Id);
        return pageReference;
    }
    
    public PageReference manageFundingByProject()
    {
    	String fundingProjectId = Apexpages.currentPage().getParameters().get('FundingProjectId');
    	
        PageReference pageReference = new PageReference('/apex/ECO_ProjectFunding');
        pageReference.getParameters().put('AgreementId', agreement.Id);
        pageReference.getParameters().put('ProjectId', projectFundingId);
        pageReference.getParameters().put('retURL', '/apex/ECO_AgreementView?'+agreement.Id);
        return pageReference;    	    	
    }
    
    
    public PageReference manageFunding()
    {
    	if(agreement.Project__c == null)
    	{
    		list<ProjectAgreement__c> projectAgreements = [select Id, Project__c from ProjectAgreement__c where Agreement__c = :agreement.Id];
    		if(projectAgreements.size() > 0)
    		{
    			agreement.Project__c = projectAgreements[0].Project__c;
    			update agreement;
    		}
    	}
        PageReference pageReference = new PageReference('/apex/ECO_ProjectFunding');
        pageReference.getParameters().put('AgreementId', agreement.Id);
        pageReference.getParameters().put('ProjectId', agreement.Project__c);
        pageReference.getParameters().put('retURL', '/apex/ECO_AgreementView?'+agreement.Id);
        return pageReference;
    }
    
    public PageReference newManagementTeamMember()
    {   	
    	update agreement;
    	
    	ManagementTeam__c teamMember =  new ManagementTeam__c(Agreement__c = agreement.Id);
    	insert teamMember;
    	
    	PageReference myPage = new PageReference('/' + teamMember.Id + '/e');
    	myPage.getParameters().put('saveURL', '/apex/ECO_AgreementView?Id=' + agreement.Id);
    	myPage.getParameters().put('retURL', '/apex/ECO_AgreementView?Id=' + agreement.Id + '&RecordToDelete='+ teamMember.Id + '&DeleteRecordType=ManagementTeam');
   
    	return myPage;
    	//return null;
    }    

    public PageReference editAgreement()
    {        
        PageReference editAgreement = new PageReference('/apex/ECO_AgreementView?Id='+agreement.Id);        
        editAgreement.getParameters().put('nooverride', '1');
        editAgreement.getParameters().put('retURL', '/apex/ECO_AgreementView?Id='+agreement.Id); 
        editAgreement.getParameters().put('mode', 'Edit');
        
        return editAgreement;   
    }    

    /*public PageReference newApprovedSub()
    {
    	update agreement;
    	
    	Approved_Sub__c approvedSub =  new Approved_Sub__c(Agreement__c = agreement.Id);
    	insert approvedSub;
    	
    	PageReference myPage = new PageReference('/' + approvedSub.Id + '/e');
    	myPage.getParameters().put('saveURL', '/apex/ECO_AgreementView?Id=' + agreement.Id);
    	myPage.getParameters().put('retURL', '/apex/ECO_AgreementView?Id=' + agreement.Id + '&RecordToDelete='+ approvedSub.Id + '&DeleteRecordType=ApprovedSub');
   		myPage.getParameters().put('save_new', '1');
    	return myPage;    	
    }

    public PageReference createNewMSATeamingPartner()
    {
        Schema.DescribeSObjectResult result = MSATeamingPartner__c.SObjectType.getDescribe();
        PageReference myPage = new PageReference('/' + result.getKeyPrefix() + '/e');

        // set the ID on a lookup field
        myPage.getParameters().put('CF00Ne0000001Hxyw_lktp', agreement.Id); 
        // set the Name on a lookup field
        myPage.getParameters().put('CF00Ne0000001Hxyw', agreement.Name);
        myPage.getParameters().put('retURL', '/apex/ECO_AgreementView?Id='+agreement.Id);
        myPage.getParameters().put('saveURL', '/apex/ECO_AgreementView?Id='+agreement.Id);

        //myPage.getParameters().put('Agreement__c', agreement.Id);

        myPage.setRedirect(true);
        return myPage;
    }*/

    /*public PageReference createNewOtherDirectCosts()
    {
        Schema.DescribeSObjectResult result = OtherDirectCost__c.SObjectType.getDescribe();
        PageReference myPage = new PageReference('/' + result.getKeyPrefix() + '/e');

        // set the ID on a lookup field
        myPage.getParameters().put('CF00Ne0000001Hxnt_lktp', agreement.Id); 
        // set the Name on a lookup field
        myPage.getParameters().put('CF00Ne0000001Hxnt', agreement.Name);
        myPage.getParameters().put('retURL', '/apex/ECO_AgreementView?Id='+agreement.Id);
        myPage.getParameters().put('saveURL', '/apex/ECO_AgreementView?Id='+agreement.Id);

        myPage.setRedirect(true);
        return myPage;      
    }*/
    
    public PageReference createNewNote()
    {
        PageReference myPage = new PageReference('/002/e?parent_id=' + String.ValueOf(agreement.Id).left(15) +'&retURL=/apex/ECO_AgreementView?Id='+agreement.Id);
        return myPage;     
    }

    // Return a list of data points for a chart
    public List<Data> getData() {
        return ECO_AgreementController.getChartData();
    }
    
    // Make the chart data available via JavaScript remoting
    @RemoteAction
    public static List<Data> getRemoteData() {
        return ECO_AgreementController.getChartData();
    }

    // The actual chart data; needs to be static to be
    // called by a @RemoteAction method
    public static List<Data> getChartData() {
        List<Data> data = new List<Data>();
        data.add(new Data('Jan', 30, 90, 55));
        data.add(new Data('Feb', 44, 15, 65));
        data.add(new Data('Mar', 25, 32, 75));
        data.add(new Data('Apr', 74, 28, 85));
        data.add(new Data('May', 65, 51, 95));
        data.add(new Data('Jun', 33, 45, 99));
        data.add(new Data('Jul', 92, 82, 30));
        data.add(new Data('Aug', 87, 73, 45));
        data.add(new Data('Sep', 34, 65, 55));
        data.add(new Data('Oct', 78, 66, 56));
        data.add(new Data('Nov', 80, 67, 53));
        data.add(new Data('Dec', 17, 70, 70));
        return data;
    }
    
    // Wrapper class
    public class Data {
        public String name { get; set; }
        public Integer data1 { get; set; }
        public Integer data2 { get; set; }
        public Integer data3 { get; set; }
        public Data(String name, Integer data1, Integer data2, Integer data3) {
            this.name = name;
            this.data1 = data1;
            this.data2 = data2;
            this.data3 = data3;
        }
    }
    
    private String populateAgreementNumber()
    {
        String numberOfProjects = '';
        list<Agreement__c> projectAgreements = [select Id from Agreement__c where project__c = :project.Id];

        numberOfProjects = '-' + String.valueOf(projectAgreements.size() + 1);          
            
        return project.OracleProjectnumber__c + numberOfProjects;   
    }
        
    public PageReference save()
    {
        agreement.CurrencyIsoCode = agreement.FundingCurrencyCode__c; 
        //agreement.TERMID__c = ECO_Service_Agreement.getPaymentTermIdFromString(agreement.PaymentTerms__c);
        
        if(agreement.Amount__c <= 0)
        {
        	ApexPages.Message oPageMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Agreement Amount (Confirmed) needs to be greater than zero!');
            ApexPages.addMessage(oPageMessage);
        	return null;
        }
        	
        if(createdFromAgreementPage)
        {
            if(agreement.Project__c != null)
            {
                project = ECO_Service_Agreement.getProjectFromId(agreement.Project__c);  
                Integer projectAgreementCount = ECO_Service_Agreement.getNextProjectAgreementCount(agreement.Project__c);
                if(project.OracleProjectnumber__c != null && project.OracleProjectnumber__c != '')
                	agreement.AgreementNumber__c = project.OracleProjectnumber__c + '-' + String.valueOf(projectAgreementCount);
                agreement.ProjectAgreementRecordCount__c = projectAgreementCount;
                agreement.AgreementAmountEstimated__c = project.EstimatedContractValue__c;
            }
            
            insert agreement;
            //MSA might not be related to a project
            if(agreement.Project__c != null)
            {
                ProjectAgreement__c projectAgreement = new ProjectAgreement__c(Agreement__c = agreement.Id, Project__c = agreement.Project__c);
 
                insert projectAgreement;   
            } 
        }
        else{
        	agreement.ChangeManagerIsChanged__c = true;
        	String err = ECO_SObjectService.saveResultReturnErrors(agreement); 
        	if(err != '')
        	{
        		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, err.replace('&quot;', '"'))); 
              	return null;
        	}        		
        }
            
        if((MSAChanged && agreement.MSAReference__c != null) || (mode == 'New'  && agreement.MSAReference__c != null))
        	copyMSADOAConditionsToProjectConditions();
        
        //agreement = ECO_Service_Agreement.getAgreementFromId(agreement.Id);
                     
        PageReference viewAgreement = new PageReference('/' + agreement.Id);        
        //set the page for the 'continue' action on the recordtype screen
        //viewAgreement.getParameters().put('nooverride', '1');
        viewAgreement.getParameters().put('retURL', '/' + agreement.Project__c); 
        //editAgreement.getParameters().put('saveURL', '/apex/ECO_AgreementView?Id='+agreement.Id);          
        //viewAgreement.getParameters().put('mode', '');
        
        
        return viewAgreement;       
    }
    
    private void copyMSADOAConditionsToProjectConditions()
    {
    	list<DOAConditions__c> msaDOAConditions = [select Id, Name, ComplianceDate__c, ComplianceStatus__c, TriggerDescription__c from DOAConditions__c where Agreement__c = :agreement.MSAReference__c];
		
		DOAConditions__c newCondition;
		list<DOAConditions__c> projectConditions = new list<DOAConditions__c>();
		for(DOAConditions__c condition:msaDOAConditions)
		{
			newCondition = new DOAConditions__c();
			newCondition = condition;
			newCondition.Id = null;
			newCondition.Project__c = agreement.Project__c;
			newCondition.Agreement__c = agreement.Id;
			projectConditions.add(newCondition);			
		}
		if(!projectConditions.isEmpty())
			insert projectConditions;
    }
    
    public String getPageBlockMode()
    {
        if(mode == 'New' || mode == 'Edit')
            return 'Edit';
        return 'View';
    }

    public PageReference printPdf()
    {
    	PageReference pageRef = new PageReference('/apex/ECO_AgreementViewPdf?Id='+agreement.Id);
    	pageRef.getParameters().put('retURL', '/apex/ECO_AgreementView?Id='+agreement.Id);
    	pageRef.setRedirect(true);
    	return pageRef;
    } 
}