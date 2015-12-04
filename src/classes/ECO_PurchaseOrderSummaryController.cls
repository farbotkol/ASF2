public without sharing class ECO_PurchaseOrderSummaryController {

	public class POException extends Exception {}

	public string sJSON {get; set;}
	
	private Id purchaseOrderId;
    private Id messageQueueId;
    private String messageQueueJobName;

    public Integer numSuccessfulSyncs {get; private set;}
    public Integer numFailedAttemptedSyncs {get; private set;}

    private final Integer numberRelatedItemsToDisplay = 20;
 
    private DateTime lastSync;

    public List<POLineItem__c> poLineItems{get; set;}
    public List<nonSyncItem> invalidPOLineItems {get;set;}
    public List<POLineItem__c> validPOLineItems {get;set;}

    private List<Distribution__c> distributions;
    public List<nonSyncItem> invalidDistributions {get;set;}
    public List<Distribution__c> validDistributions {get;set;}
    public POStatus__c poStatus {get; private set;}
    public List<POStatus__c> poStatusList {get; private set;}

	public String validPOLineItemLimitMsg {get; private set;}
	public String invalidPOLineItemLimitMsg {get; private set;}
	public String validDistributionLimitMsg {get; private set;}
	public String invalidDistributionLimitMsg {get; private set;}

	public Boolean allowRequestSubmit {get; private set;}
	public String lastSyncStr {get; private set;}

	public Boolean hasSyncHistory {get; private set;}
	public Boolean hasRequestFailures {get; private set;}
    public List<syncHistoryHelper> syncHistory {get; private set;}
    public List<syncHistoryHelper> requestFailures {get; private set;}

    public String retUrl {get; private set;}

    public String selectedPOLineItemTab {get; set;}
    public String selectedDistributionTab {get; set;}
    
    public Integer numInvalidPOLineItems {get; private set;}
    public Integer numValidPOLineItems {get; private set;}
    public Integer numInvalidDistributions {get; private set;}
    public Integer numValidDistributions {get; private set;}

    public POHeader__c poHeader {get;set;}

    public boolean allowNewPOLineItems {get; private set;}

	private String poHeaderMsg;
	private String poLineItemMsg;
	private String distributionMsg;
	private Id projectId;
	private Id agreementId;
	private Boolean isFromAgreement; 
	private ProjectTeamMember__c projectManager;

	public boolean hideEverything {get; private set;}
	public boolean allowPOHeaderSave {get; private set;}
	public boolean allowPOCloseout {get; private set;}
	public boolean allowPOCancel {get; private set;}
	public boolean showCreateAndSubmitForApproval {get; private set;}

	public POLineItem__c currentPOLineItem {get; set;}

	public String currentPOLineItem_TaskName {get;set;}
	public String currentPOLineItem_TaskId {get;set;}
	public String currentPOLineItem_Id {get;set;}
	public String currentPOLineItem_Amount {get;set;}
	public String currentPOLineItem_CurrencyIsoCode {get;set;}

	public String taskFilter {get;set;}
	public Boolean noSearchResults {get; private set;}
	public List<pse__Project_Task__c> projectTasks {get; private set;}
	// Sanchivan : Removed as per VSO Bug 2106
	//public list<POcommitment__c> poCommitments {get; set;}
	
	private ApexPAges.StandardsetController setCon;
	private final Integer pagingResultSize = 10;

	public String validationMsgSummary {get; private set;}
	public Boolean showValidationMsg {get; private set;}

	public String savePOBtnValue {get; private set;}
	public String returnBtnValue {get; private set;}

	public List<SelectOption> optSelectProjectSites {get; private set;}
	public String selProjectSiteId {get;set;}

	public List<SelectOption> optAgreements {get; private set;}

	public String showHideDistributionBtnStr {get; private set;}

	public String selectedVendorId {get;set;}

	public String agreementIdentifier {get; private set;}

	public Boolean debugMode {get; private set;}

	public Boolean canEditHeader {get; private set;}

	public Boolean hasBeenApproved {get; private set;}

	public Boolean pendingApproval {get; private set;}

	private Boolean useApprovalProcess;

    public Boolean showSyncMsg {get;set;}
    public String syncProgressMsg {get;set;}
    private boolean syncErrorOccurred = false;

    @TestVisible
    private List<String> stepMsgs;

    private Integer intProgressBarNumCells;
    private String progressErrors;

    public Boolean pollMessageQueue {get; private set;}
    public Boolean showPollingMsg {get; private set;}
    public String pollingMessageQueueMsg {get; private set;}
    public String pollingMessageQueueMsgBottom {get; private set;}
    public String purchaseOrderSyncProcessingResult {get; private set;}

    private String syncAttemptResult;

    public Boolean isApprovedDoSyncNow {get; private set;}
    
    public Decimal totalPurchaseOrderLineAmount{get; private set;}
    public Decimal totalAllocatedAmount{get; private set;}
    public Decimal totalRemainingAmount{get; private set;}

    public ECO_PurchaseOrderSummaryController(ApexPages.StandardController stdController) {
        
    	POHeader__c rec = (POHeader__c)stdController.getRecord();

    	purchaseOrderId = rec.Id;

    	hideEverything = false;
    	isApprovedDoSyncNow = false;
    	poHeader = new POHeader__c();
    	allowNewPOLineItems = false;
		allowRequestSubmit = true;
		poIsClosedOutOrClosedOut = false;
		showCreateAndSubmitForApproval = false;
		allowPOCloseout = false;	
		allowPOCancel = false;	
		poHeaderMsg = '';
		poLineItemMsg = '';
		distributionMsg = '';
		validationMsgSummary = '';
		showValidationMsg = false;
		returnBtnValue = 'Return to Project';
		isFromAgreement = false;
		allowPOHeaderSave = true;
		hasBeenApproved = false;
		pendingApproval = false;
		showHideDistributionBtnStr = 'Show Distributions';
		agreementIdentifier = '';

		useApprovalProcess = true;	//false = to allow oracle group to generate po's for testing, otherwise should be true

		numSuccessfulSyncs = 0;
   	    numFailedAttemptedSyncs = 0;

   	    vendorSites = new List<VendorSite__c>();
		optSelectProjectSites = new List<SelectOption>();
		optAgreements = new List<SelectOption>();
		poStatus = new POStatus__c();
		debugMode = isDebugEnabled();
		canEditHeader = false;

    	if(purchaseOrderId == null) {
    		savePOBtnValue = 'Add Purchase Order Lines';
    		allowRequestSubmit = false;
    		showCreateAndSubmitForApproval = true;
    		projectId = checkForUrlIdParam('projectId');
    		agreementId = checkForUrlIdParam('agreementId');
    		
            if(projectId == null && agreementId == null) {
    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'A You have reached this page incorrectly. A Project Id or Agreement Id is missing!'));
    			hideEverything = true;
				return;
			} else if(projectId == null && agreementId != null) {
				projectId = [SELECT Project__c FROM Agreement__c WHERE Id = :agreementId].Project__c;

				if(projectId == null) {
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'A Project must be selected for the Agreement! Please return the the Agreement and select a Project.'));
	    			allowPOHeaderSave = false;
	    			returnBtnValue = 'Return to Agreement';
	    			isFromAgreement = true;
	    			return;
				}				
    		}

    		if(projectId != null) {
    			projectManager = getProjectManager();
    			poHeader.Project__c = projectId;
    			if(projectManager != null){
    				poHeader.Requestor__c = projectManager.Contact__c;
    			}   			
    		}
    			
    		if(agreementId != null) {
    			poHeader.Agreement__c = agreementId;
    			returnBtnValue = 'Return to Agreement';
    			isFromAgreement = true;
    		}
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Click \'Add Purchase Order Lines\' to create a new Purchase Order.'));
    		
    	} else {
    		savePOBtnValue = 'Save Purchase Order';
    		poHeader = ECO_Service_PurchaseOrders.GetPurchaseOrder(purchaseOrderId);

    		if(!String.isEmpty(poHeader.Agreement__r.VendorSite__r.AccountName__c)) {
				agreementIdentifier = poHeader.Agreement__r.VendorSite__r.AccountName__c + ' ' +  poHeader.Agreement__r.Name;		
    		}else {
				agreementIdentifier = poHeader.Agreement__r.Name;
    		}
    			
    		projectId = poHeader.Project__c;
    		agreementId = poHeader.Agreement__c;
    		selProjectSiteId = poHeader.VendorSite__c;
    		projectManager = getProjectManager();
    		
    		if(poHeader.CancelFlag__c || poHeader.Status__c == 'Closeout') {
    			poIsClosedOutOrClosedOut = true;
    		}
    		//getTasksForProject();
    		if(agreementId != null && projectId == null) {
    			returnBtnValue = 'Return to Agreement';
    			isFromAgreement = true;
    		}

    		//if(isPurchasedOrderApproved()){
    		//poHeader.Status__c = 'APPROVED';
            if(poHeader.VendorSite__c != null){
                allowNewPOLineItems = true;
            }
            
            allowPOHeaderSave = false;	//can't update poheader - fields will be read only
            if(!String.isEmpty(poHeader.OraclePurchaseOrderId__c)){
                allowPOCancel = true;	
                
                List<POStatus__c> poStatuses = ECO_Service_PurchaseOrders.GetPurchaseOrderStatuses(purchaseOrderId);
                if(!poStatuses.isEmpty()){
                    poStatus = poStatuses.get(0);
                    if(poStatus.AP_Invoice__c != null){
                        allowPOCloseout = true;	
                        allowPOCancel = false;
                    }
                }                
            }   			
    		//}else{
    		//	allowRequestSubmit = false;    			
    		//}

    		//hasBeenApproved = isPurchasedOrderApproved();

    		//disabled for testing
    		//if(useApprovalProcess){
    		pendingApproval = isPurchasedOrderPendingApproval();
    		//}
    	}

    	optSelectProjectSites = getVendorProjectSites();
    	optAgreements = getProjectAgreements();

    	poLineItems = new List<POLineItem__c>();
    	distributions = new List<Distribution__c>();

    	currentPOLineItem = new POLineItem__c();
    	currentPOLineItem_Id = '';

		retUrl = '/apex/' + ApexPages.currentPage().getUrl().split('/apex/')[1];

		taskFilter = '';
		noSearchResults = true;

		messageQueueId = null;
		messageQueueJobName = '';
		sJSON = '';

		validPOLineItemLimitMsg = '';
		invalidPOLineItemLimitMsg = '';
		validDistributionLimitMsg = '';
		invalidDistributionLimitMsg = '';
	
		hasSyncHistory = false;
		hasRequestFailures = false;

		numInvalidPOLineItems = 0;
    	numValidPOLineItems = 0;
    	numInvalidDistributions = 0;
   		numValidDistributions = 0;
  	
   		invalidPOLineItems = new List<nonSyncItem>();
		validPOLineItems = new List<POLineItem__c>();

		invalidDistributions = new List<nonSyncItem>();
     	validDistributions = new  List<Distribution__c>();

		if(purchaseOrderId != null) {
			sJSON = ECO_Service_PurchaseOrders.createPurchaseOrderMessageWrapperJSON(purchaseOrderId, null);
	     	poHeader = ECO_Service_PurchaseOrders.GetPurchaseOrder(purchaseOrderId);

	     	//get last sync date to use to filter out items that have changed
			lastSync = ECO_Service_PurchaseOrders.getLastSuccessfulSyncDateTime(purchaseOrderId, messageQueueJobName);
		    lastSyncStr = 'The project has not yet been synced';
		    if(lastSync == null) {
		    	lastSync = DateTime.newInstance(1900, 1, 1);
		    } else {
		    	lastSyncStr = 'Last sync: ' + lastSync.format();
		    }
		    lastSyncStr = 'Last sync: ' + lastSync.format();

		    validatedAndDisplayWarnings();

		    poStatusList = ECO_Service_PurchaseOrders.GetPurchaseOrderStatuses(purchaseOrderId);
		    if(!poStatusList.isEmpty()){
		    	poStatus = poStatusList.get(0);
		    }
            totalAllocatedAmount = 0.0;
            totalRemainingAmount = 0.0;
            
            for(POStatus__c poStatus : poStatusList) {
                if(poStatus.APTotalAmount__c != Null)
                    totalAllocatedAmount = totalAllocatedAmount + poStatus.APTotalAmount__c;
            }
            
            totalRemainingAmount = totalPurchaseOrderLineAmount - totalAllocatedAmount;
	    }
	    //allowRequestSubmit = true;	
	    //numValidPOLineItems = validPOLineItems.size();
	    /*
		//to do remove call to construct wrapper - replaced by sfdc objects
		requestDTO =  ECO_Service_Projects.createProjectMessageWrapper(projectId, false, false);
		poHeaderMsg = validateProject(project, false);
		*/
		messageQueueJobName = ECO_Service_PurchaseOrders.JOBNAME_PO_SYNC;	//NOT SURE IF THIS NEEDS TO BE DIFFERENT VALUE OR NOT

	    generateSyncHistory();

	    if(!hasSyncHistory && !pendingApproval){
	    	canEditHeader = true;
	    }
	    
        // Sanchivan : Removed as per VSO Bug 2106
	    // poCommitments = getPOCommitmentsForProject();
    }
    
    // Sanchivan : Removed as per VSO Bug 2106
    /*private list<POcommitment__c> getPOCommitmentsForProject() {
    	list<POcommitment__c> poCommits = [select Id, Name, ExpenditureType__c, PODate__c, PONumber__c, POLine__c, POLineStatus__c, SupplierID__c, SupplierName__c, SupplierNumber__c, POLineAmount__c, POAmountBilled__c from POcommitment__c where ProjectNumber__c = :poHeader.Project__c order by PODate__c, PONumber__c, POLine__c];
   		
   		return poCommits;
    }*/

    public Boolean isDebugEnabled() {
    	Boolean result = false;
    	Id userId = UserInfo.getUserId();
    	List<User> users = [SELECT Id, UserPreferencesApexPagesDeveloperMode
    						FROM User
    						WHERE Id = :userId];
        if(!users.isEmpty()){
        	result = users.get(0).UserPreferencesApexPagesDeveloperMode;
        }
    	return result;
    }
   
    public void refreshJSON(){
    	sJSON = ECO_Service_PurchaseOrders.createPurchaseOrderMessageWrapperJSON(purchaseOrderId, messageQueueId);
    	//sJSON = 'messageQueueId = ' + messageQueueId;
    }	

    public void getDefaultPaymentTermsForVendor(){
        System.debug('---Entering getDefaultPaymentTermsForVendor');
    	if(!vendorSites.isEmpty() && selectedVendorId !=''){
    		for(VendorSite__c projSite : vendorSites){
    			if(projSite.Id == selectedVendorId){
    				poHeader.VendorSite__c = projSite.Site__r.Id;
                    poHeader.PaymentTerm__c = projSite.Site__r.PaymentTerms__c;
    			}
    		}
    	}
        optAgreements = getProjectAgreements();
        System.debug('---Exiting getDefaultPaymentTermsForVendor');
    }
    
    private ProjectTeamMember__c getProjectManager(){
    	ProjectTeamMember__c result = null;
    	/*
    	pse__Proj__c	project = [SELECT Id, 
    									pse__Project_Manager__c 
    								FROM pse__Proj__c	
    								WHERE Id = :projectId];
    	if(project != null){
    		result = project.pse__Project_Manager__c;
    	}
    	*/
    	List<ProjectTeamMember__c> pm = ECO_Service_ProjectSync.getProjectManagerForProject(projectId);
    	if(!pm.isEmpty()){
    		result = pm.get(0);
    	}
    	return result;
    }

    private List<VendorSite__c> vendorSites;

    private List<SelectOption> getVendorProjectSites(){
    	List<SelectOption> results = new List<SelectOption>();

    	vendorSites = [SELECT Id, 
				    		AccountName__c,
				    		Site__r.PaymentTerms__c
					    FROM VendorSite__c
					    WHERE Project__c = :projectId
					    AND IsVendor__c = true
					    ORDER BY AccountName__c ASC];

        results.add(new SelectOption('', '-- Choose Vendor --'));
    
    	if(!vendorSites.isEmpty()){
    		for(VendorSite__c psite : vendorSites){   			
    			results.add(new SelectOption(String.valueOf(psite.Id), psite.AccountName__c));
    		}

    		poHeader.PaymentTerm__c = vendorSites.get(0).Site__r.PaymentTerms__c;
    	}	

    	return results;
    }

	private List<SelectOption> getProjectAgreements(){
    	List<SelectOption> results = new List<SelectOption>();
		System.debug('---Entering getProjectAgreements: ' + selProjectSiteId);
    	List<Agreement__c> projectAgreements = [SELECT
                                                	Id, 
    												Name,    
    												VendorSite__r.AccountName__c,
                                                	AgreementNumber__c
    											FROM
                                                	Agreement__c
    											WHERE
                                                	Project__c = :projectId AND VendorSite__c =: selProjectSiteId AND VendorSite__c != Null];

    	results.add(new SelectOption('', '-- Choose Agreement --'));											

    	if(!projectAgreements.isEmpty()){
    		for(Agreement__c agreement : projectAgreements){
    			String vendorName = '';
    			if(!String.isEmpty(agreement.VendorSite__r.AccountName__c)){
    				vendorName = agreement.VendorSite__r.AccountName__c + ' ';
    			}
    			String agreementIdentifier =  vendorName + agreement.AgreementNumber__c;

    			results.add(new SelectOption(String.valueOf(agreement.Id), agreementIdentifier));
    		}
        }
        System.debug('---Exiting getProjectAgreements');
    	return results;
    }

    private Id checkForUrlIdParam(String param){
		Id result = null;
        if(ApexPages.currentPage().getParameters().containsKey(param)){
            result = Id.valueOf(ApexPages.currentPage().getParameters().get(param));          
        }
        return result;
    }

    private String validatePOHeader(POHeader__c po){
    	String results = '';

    	return results;
    }

	private void displayValidationMessage(){
		validationMsgSummary = '';

		if(!String.isEmpty(poHeaderMsg + poLineItemMsg + distributionMsg)){
			showValidationMsg = true;
			validationMsgSummary = 'The purchase order cannot be synced due to missing information on the purchase order or related items:<ul>' + poHeaderMsg + poLineItemMsg + distributionMsg + '</ul>';
		}else{
			showValidationMsg = false;
		}		
	}

/*
	public void getTasksForProject(){

		String soql = 'SELECT Id, Name, ProjectTaskNumber__c, BillTo__c, ShipTo__c,	pse__End_Date__c, ';
		soql +=	'pse__Start_Date__c, IsBillable__c, IsChargeable__c, WorkTypeName__c, pse__Parent_Task__r.Name ';
		soql += 'FROM pse__Project_Task__c ';
		soql += 'WHERE pse__Project__c = :projectId ';
		if(!String.isEmpty(taskFilter)){
			soql += 'AND Name LIKE \'%' + String.escapeSingleQuotes(taskFilter) + '%\' ';
		}
		soql += 'LIMIT ' + pagingResultSize;
		setCon = new ApexPages.StandardsetController(Database.getQueryLocator(soql));
        setCon.setPageSize(pagingResultSize);  
        populateProjectTaskList(); 

	}


	private void populateProjectTaskList(){
		projectTasks = setCon.getRecords(); 
        if(projectTasks.isEmpty()){
            noSearchResults = true;
        }else{
            noSearchResults = false;
        }
		//updatePagingVars();
	}


	public void assignContactToPOLineItem(){
		currentPOLineItem.ProjectTask__c = currentPOLineItem_TaskId;
		currentPOLineItem_TaskName = currentPOLineItem.ProjectTask__r.Name;
	}
*/

	private Boolean isPurchasedOrderApproved(){
		Boolean result = false;
		List<ProcessInstance> approvalProcess = [SELECT Status, SystemModstamp 
												 FROM ProcessInstance
												 WHERE TargetObjectId = :poHeader.Id
												 ORDER BY SystemModstamp DESC];
		if(!approvalProcess.isEmpty()){
			if(approvalProcess.get(0).Status.equalsIgnoreCase('Approved')){
				result = true;
			}
		}
		return result;
	}

	private Boolean isPurchasedOrderPendingApproval(){
		Boolean result = false;
		List<ProcessInstance> approvalProcess = [SELECT Status, 
													SystemModstamp 
												FROM ProcessInstance
												WHERE TargetObjectId = :poHeader.Id
												ORDER BY SystemModstamp DESC];
		if(!approvalProcess.isEmpty()){
			if(approvalProcess.get(0).Status.equalsIgnoreCase('Pending')){
				result = true;
			}
		}else{
			//no approval sumbmissions yet - po status is Pending but is not actually pending an approval
			result = false;
		}
		return result;
	}	

	private Boolean savePurchaseOrder(){
		Boolean saveSuccessful = false;

		try {
            if(selProjectSiteId == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The Vendor Site has not been selected and must be picked before saving the Purchase Order.'));
                return saveSuccessful;
            }

			poHeader.VendorSite__c = Id.valueOf(selProjectSiteId);
			
			List<ProjectTeamMember__c> projectManagers = ECO_Service_ProjectSync.getProjectManagerForProject(projectId);
			if(!projectManagers.isEmpty()){
				poHeader.ProjectManager__c = projectManagers.get(0).Contact__r.pse__Salesforce_User__c;
				// poHeader.ProjectManager__c = projectManagers.get(0).Contact__r.User__c;
			}
			
			if(hasSyncHistory && !syncHistory.isEmpty()) {
				poHeader.ActionFlag__c = 'U';
			}else {
				poHeader.ActionFlag__c = 'C';
			}
			if(poHeader.Id == null) {					
				insert poHeader;
				purchaseOrderId = poHeader.Id;						
											
			}else {					
				update poHeader;
			}

            if(poHeader.VendorSite__c != null) {
                allowNewPOLineItems = true;
            }

			saveSuccessful = true;
		}catch(Exception e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error has occurred while updating the project! ' + e.getMessage()));
		}

		return saveSuccessful;
	}

	public PageReference saveAndSubmitForApproval() {
		isApprovedDoSyncNow = false;

		PageReference pageRef = null;
        
        Id currUserId = UserInfo.getUserId();
        
		//default status to approved since trigger will auto approve if pm, if not approval request will fire setting status to Pending		
		//if(poHeader.ProjectManager__c == UserInfo.getUserId()){
			//poHeader.Status__c = 'APPROVED';
		//}else{
		//	poHeader.Status__c = 'Pending';
		//}
		
		pse__Proj__c project = [SELECT 	
                                	Id, 
    								pse__Project_Manager__c, 
    								pse__Project_Manager__r.pse__Salesforce_User__c,
                                	ProjectApprover__r.pse__Salesforce_User__c,
    								OwnerId
    							FROM 
                                	pse__Proj__c	
    							WHERE 
                                	Id = :projectId];

		if(savePurchaseOrder()) {			
			if(poHeader.CancelFlag__c) {
				poIsClosedOutOrClosedOut = true;
			}

			if(useApprovalProcess) {
				Boolean isPM = false;				
				
				if(project != null) {
					if(project.pse__Project_Manager__r.pse__Salesforce_User__c != null) {
						if(project.pse__Project_Manager__r.pse__Salesforce_User__c == currUserId) {
							isPM = true;
						}
					}else if(project.OwnerId == currUserId) {	// if no pm is set it's assumed project owner is pm
						isPM = true;
					}
				}
				system.debug('isPM = ' + isPM);

				if(isPM) {
					system.debug('pm is user - attempting autoapprove');
                    if(project.ProjectApprover__r.pse__Salesforce_User__c != null) {
                        POHeader__c poheader = [SELECT Id, ProjectManager__c FROM POHeader__c WHERE Id =: poHeader.Id];
                        poheader.ProjectManager__c = project.ProjectApprover__r.pse__Salesforce_User__c;
                        update poheader;
                    }
                    					
                    // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for approval.');
                    req1.setObjectId(poHeader.Id);
                    
                    // Submit on behalf of a specific submitter
                    req1.setSubmitterId(currUserId); 
                    /*if(project.ProjectApprover__r.pse__Salesforce_User__c != null) {
                        List<Id> approverIds = new List<Id>();
                        approverIds.add(project.ProjectApprover__r.pse__Salesforce_User__c);
                        System.debug('approverIds:' + approverIds);
                        req1.setNextApproverIds(approverIds);
                    } */                   	
                    
                    // Submit the record to specific process and skip the criteria evaluation
                    req1.setProcessDefinitionNameOrId('EcoPurchaseOrder');
                    
                    // Submit the approval request for the account
                    Approval.ProcessResult result = Approval.process(req1);
                    
                    return null;
					/*try{                        
						//autoApprovePurchaseOrder();	//if requestor is pm then the approval is submitted and auto approved
						//poHeader.Status__c = 'APPROVED';
						//update poHeader;
						//isApprovedDoSyncNow = true;
					}catch(Exception e){
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error has occurred while approving the purchase order! ' + e.getMessage()));
					}	*/								
				}else if(isApprovedFromApprovalProcess()){
					isApprovedDoSyncNow = true;
				}else{					
					system.debug('pm is not user - sending for approval');

					/*String retUrl = '/apex/ECO_PurchaseOrderSummary?projectId=' + projectId + '&id=' + poHeader.Id;
					pageRef = new PageReference('/p/process/Submit');
					pageRef.getParameters().put('id', poHeader.Id);
					pageRef.getParameters().put('retURL', retUrl);
					pageRef.setRedirect(true);*/
                    
                    List<Contact> lContacts = new List<Contact>([SELECT Id, pse__Salesforce_User__r.Id FROM Contact WHERE Id = :poHeader.Requestor__c]);
                    
                    Contact oContact = new Contact();
                    
                    if(lContacts.size() > 0){
                        oContact = lContacts.get(0);
                    }else{
                        throw new POException('No Requestor has been specified or requestor is not a Salesforce user!');
                    }
                    
                    // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for approval.');
                    req1.setObjectId(poHeader.Id);
                    
                    // Submit on behalf of a specific submitter
                    req1.setSubmitterId(oContact.pse__Salesforce_User__c); 
                    
                    // Submit the record to specific process and skip the criteria evaluation
                    req1.setProcessDefinitionNameOrId('EcoPurchaseOrder');
                    //req1.setSkipEntryCriteria(true);
                    
                    // Submit the approval request for the account
                    Approval.ProcessResult result = Approval.process(req1);
                    
                    return null;
				}
			}else{
				isApprovedDoSyncNow = true;
			}					
		}
		
		return pageRef;
	}

	private Boolean isApprovedFromApprovalProcess(){
		Boolean result = false;
		List<ProcessInstance> approvalProcess = [SELECT Status, 
													SystemModstamp 
												FROM ProcessInstance
												WHERE TargetObjectId = :poHeader.Id
												ORDER BY SystemModstamp DESC];
		if(!approvalProcess.isEmpty()){
			if(approvalProcess.get(0).Status.equalsIgnoreCase('APPROVED')){
				result = true;
			}
		}
		return result;
	}

	/*private void autoApprovePurchaseOrder(){
		ECO_Service_PurchaseOrders.submitForApproval(poHeader, UserInfo.getUserId());
	}*/

	public PageReference updatePurchaseOrder(){
		PageReference pageRef = null;
		if(savePurchaseOrder()){
				pageRef = new PageReference('/apex/ECO_PurchaseOrderSummary');
				pageRef.getParameters().put('projectId', projectId);
				pageRef.getParameters().put('id', poHeader.Id);
				pageRef.setRedirect(true);			
		}
		return pageRef;	
	}
    
	public void closeOutPurchaseOrder(){
		try{
			poHeader.Status__c = 'CLOSEOUT';
			update poHeader;
			poIsClosedOutOrClosedOut = true;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Purchase Order flagged as Closeout!<br/>TBD - business rules and validation to check if purchase order can be cancelled.'));
			
		}catch(Exception e){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'An error has occurred while updating the purchase order: ' + e.getMessage()));
		}
	}

	public Boolean poIsClosedOutOrClosedOut {get; private set;}

	public void cancelPurchaseOrder(){
		poHeader.CancelFlag__c = true;
		saveAndSubmitForApproval();
		/*
		try{
			poHeader.CancelFlag__c = true;
			update poHeader;
			poIsClosedOutOrClosedOut = true;
			//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Purchase Order flagged as cancelled!<br/>TBD - business rules and validation to check if purchase order can be cancelled.'));
			
		}catch(Exception e){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'An error has occurred while updating the purchase order: ' + e.getMessage()));
		}
		*/
	}

	private void validatedAndDisplayWarnings(){
		allowRequestSubmit = true;
		poLineItemMsg = validatePOLineItems();		
		poHeaderMsg = '';
		displayValidationMessage();
	}

	public PageReference gotoPOLineItemPage(){
		PageReference pageRef = new PageReference('/apex/ECO_PurchaseOrderLineItem');
		pageRef.getParameters().put('projectId', projectId);
		pageRef.getParameters().put('poHeaderId', poHeader.Id);
		pageRef.getParameters().put('retURL', retUrl);
		pageRef.setRedirect(true);
		return pageRef;	
	}

	public void doRerenderPOListItems(){
		validatedAndDisplayWarnings();
	}

	public class syncHistoryHelper {
		public String syncLocalDateTime {get;set;}
		public IntegrationMessageQueue__c msgQueue {get;set;}
	}
	
    public void initiateOracleSyncRequest(){
    	messageQueueId = ECO_Service_PurchaseOrders.createMessageQueueForRequest(poHeader.Id, messageQueueJobName);

    	sJSON = ECO_Service_PurchaseOrders.createPurchaseOrderMessageWrapperJSON(purchaseOrderId, messageQueueId);
    	system.debug('controller - initiateOracleSyncRequest - messageQueueId = ' + messageQueueId);
    }

    public void executeOracleSyncRequest(){
    	syncAttemptResult = '';
		//sJSON = ECO_Service_PurchaseOrders.createPurchaseOrderMessageWrapperJSON(purchaseOrderId, messageQueueId);
    	try{
  
	    	ECO_IntegrationEndpoints__c cs = ECO_IntegrationEndpoints__c.getInstance('Purchase Order Sync');
	    	String url = cs.EndPointUrl__c;
	    	//String url = 'https://ecosystem-dev.wgint.com/services/api/PurchaseOrder';
	    	
	    	system.debug('endpoint url = ' + url);

			String resp = '';
		
			resp = ECO_Service_PurchaseOrders.initiateOracleSyncRequest(purchaseOrderId, url, messageQueueId);
		
			system.debug('resp at controller level = ' + resp);
			
			syncAttemptResult = checkResults();
			if(String.isEmpty(syncAttemptResult)){	//no message logged in msgqueue table for some reason
				syncAttemptResult = resp;
			}

			system.debug('syncAttemptResult from resp at controller level = ' + syncAttemptResult);
			system.debug('syncErrorOccurred = ' + syncErrorOccurred);
		}catch(Exception e){
			syncAttemptResult = 'Request has returned an error. Response is : ' + e.getMessage();
			syncErrorOccurred = true;
			//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Request has returned an error. Response is : ' + e.getMessage()));
		}

    	generateSyncHistory();			
    }

    private String checkResults(){
    	String result = '';

    	List<IntegrationMessageQueue__c> msgQueueResults = [SELECT Id, Status__c, SuccessMessage__c, ErrorMessage__c 
    												FROM IntegrationMessageQueue__c
    												WHERE Id = :messageQueueId];
    	
    	if(msgQueueResults.isEmpty()){
			//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unable to find message queue record for this request!'));
			result = 'Unable to find message queue record for this request!';
			syncErrorOccurred = true;
		}else{
			IntegrationMessageQueue__c msgQueueResult = msgQueueResults.get(0);
			/*
			if(String.isEmpty(responseMessage)){
	    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Oracle Number was not returned from successful request!'));
	    		msgQueueResult.Status__c = 'Error';
	    		msgQueueResult.ErrorMessage__c = 'Response Status = 200 but no response body';
				update msgQueueResult;
	    	}else{
	    		poHeader.OraclePurchaseOrderNumber__c = responseMessage.trim().replace('"','');
				update poHeader;

				msgQueueResult.Status__c = 'Success';
				msgQueueResult.SuccessMessage__c = responseMessage.trim();
				update msgQueueResult;

				canEditHeader = false;
	    	}
	    	*/
	    	if(msgQueueResult.Status__c == ECO_Service_PurchaseOrders.STATUS_SUCCESS){
	    		result = 'Request successfully processed! Response was: ' + msgQueueResult.SuccessMessage__c;

	    		String poInfoJson = msgQueueResult.SuccessMessage__c;
	    		ECO_Service_PurchaseOrders.POSuccessResponseJson poInfo = (ECO_Service_PurchaseOrders.POSuccessResponseJson)JSON.deserialize(poInfoJson, ECO_Service_PurchaseOrders.POSuccessResponseJson.class);

				poHeader.OraclePurchaseOrderNumber__c = poInfo.PO_NUMBER;
				poHeader.OraclePurchaseOrderId__c = poInfo.PO_HEADER_ID;
				if(poHeader.CancelFlag__c){	//po has been cancelled
					poHeader.Status__c = 'Cancelled';
				}
				update poHeader;

	    		/*
	    		String poNumber = msgQueueResult.SuccessMessage__c;
	    		poNumber = poNumber.trim().replace('"','');
	    		if(poNumber.isNumeric()){
	    			poHeader.OraclePurchaseOrderNumber__c = poNumber;
	    			update poHeader;
	    		}else{
	    			result = 'po number returned is non-numeric: ' + poNumber;
	    			syncErrorOccurred = true;
	    		}
	    		*/			
	    	}else{
	    		result = msgQueueResult.ErrorMessage__c;
	    		syncErrorOccurred = true;
	    	}	    	
	    }
    	
    	system.debug('checkResults result = ' + result);
    	
    	return result;
    }    

    /*public void doRequest(){
    }*/

    private String checkForEmpty(String stringIn, String fieldLabel){
    	String result = '';
    	if(String.isEmpty(stringIn)){
    		result = fieldLabel + ', ';
    	}
    	return result;
    }

    public PageReference returnToProject(){
    	PageReference pageRef = new PageReference('/' + projectId);
    	if(isFromAgreement || projectId == null){
			pageRef = new PageReference('/' + agreementId);
    	}
    	pageRef.setRedirect(true);
    	return pageRef;
    }

    private void generateSyncHistory(){
    	if(poHeader.Id != null){

    		numSuccessfulSyncs = 0;
   	    	numFailedAttemptedSyncs = 0;

	    	Set<String> successStatus = new Set<String>{ ECO_Service_PurchaseOrders.STATUS_SUCCESS };
			List<IntegrationMessageQueue__c> tmpSyncHistory = ECO_Service_PurchaseOrders.getSyncHistory(poHeader.Id, ECO_Service_PurchaseOrders.JOBNAME_PO_SYNC, successStatus); 
			syncHistory = new List<syncHistoryHelper>();
			for(IntegrationMessageQueue__c tmpRec : tmpSyncHistory){
				syncHistoryHelper syncHelper = new syncHistoryHelper();
				syncHelper.syncLocalDateTime = tmpRec.LastModifiedDate.format();
				syncHelper.msgQueue = tmpRec;
				syncHistory.add(syncHelper);
			}	
		    if(!syncHistory.isEmpty()){
		    	hasSyncHistory = true;
		    	numSuccessfulSyncs = syncHistory.size();
		    }
		    Set<String> otherStatuses = new Set<String> {ECO_Service_PurchaseOrders.STATUS_ERROR, ECO_Service_PurchaseOrders.STATUS_INITIATED, ECO_Service_PurchaseOrders.STATUS_ATTEMPTED, ECO_Service_ProjectSync.STATUS_SENT };
		    List<IntegrationMessageQueue__c> tmpRequestFailures = ECO_Service_PurchaseOrders.getSyncHistory(poHeader.Id, ECO_Service_PurchaseOrders.JOBNAME_PO_SYNC, otherStatuses); 
		    requestFailures = new List<syncHistoryHelper>();
			for(IntegrationMessageQueue__c tmpRec : tmpRequestFailures){
				syncHistoryHelper syncHelper = new syncHistoryHelper();
				syncHelper.syncLocalDateTime = tmpRec.LastModifiedDate.format();
				syncHelper.msgQueue = tmpRec;
				requestFailures.add(syncHelper);
			}	
		    if(!requestFailures.isEmpty()){
		    	hasRequestFailures = true;
		    	numFailedAttemptedSyncs = requestFailures.size();
		    }		
    	}
	}

    public class nonSyncItem{
    	public Id recordId {get;set;}
    	public String recordName {get;set;}
    	public String validationErrorMessage{get;set;}
    }

    public String validatePOLineItems(){
    	String results = '';
    	poLineItems = ECO_Service_PurchaseOrders.GetPurchaseOrderLineItems(purchaseOrderId);
    	validPOLineItems = new List<POLineItem__c>();
    	invalidPOLineItems = new List<nonSyncItem>();
    	
    	String poLineItemTask = Schema.SobjectType.POLineItem__c.fields.ProjectTask__c.label;
    		
    	if(!poLineItems.isEmpty()){
    		for(POLineItem__c poLineItem : poLineItems){
    			String validationMsgForPOLineItem = '';
    			validationMsgForPOLineItem += checkForEmpty(poLineItem.ProjectTask__c, poLineItemTask);

    			if(!String.isEmpty(validationMsgForPOLineItem)){
    				validationMsgForPOLineItem = validationMsgForPOLineItem.substring(0,validationMsgForPOLineItem.length()-2);
  					nonSyncItem badItem = new nonSyncItem();
  					badItem.recordId = poLineItem.Id;
  					badItem.recordName = poLineItem.Name;
  					badItem.validationErrorMessage = 'The following fields must be completed to sync: ' + validationMsgForPOLineItem;
  					invalidPOLineItems.add(badItem);  		
    			}else{
    				validPOLineItems.add(poLineItem);
    			}    			
    		}
    	}
		numValidPOLineItems = validPOLineItems.size();
		numInvalidPOLineItems = invalidPOLineItems.size();

		selectedPOLineItemTab = 'validPOLineItems';
		invalidPOLineItemLimitMsg = '(' + numInvalidPOLineItems + ' records)';
		if(!invalidPOLineItems.isEmpty()){
			allowRequestSubmit = false;
			results += '<li>' + numInvalidPOLineItems + ' PO Line Items failed validation. See the PO Line Items section below for details.</li>';					
			selectedPOLineItemTab = 'invalidPOLineItems';			
		}

		validPOLineItemLimitMsg = '(' +numValidPOLineItems + ' records)';
        
        totalPurchaseOrderLineAmount = 0.0;
        for(POLineItem__c lineItem : poLineItems) {
            if(lineItem.Amount__c != null) {
                totalPurchaseOrderLineAmount =  totalPurchaseOrderLineAmount + lineItem.Amount__c;
            }            
        }
        
    	return results;
    }	

    public PageReference SimulateProcessedByOracle() {

    	poHeader.OraclePurchaseOrderId__c = '654321';
    	update poHeader;

    	PageReference pageRef = new PageReference('/apex/ECO_PurchaseOrderSummary');
		pageRef.getParameters().put('projectId', projectId);
		pageRef.getParameters().put('id', poHeader.Id);
		pageRef.setRedirect(true);
		return pageRef;    	
    }

    public void SimulateInvoicedByOracle(){
    	
    	poStatus.POHeader__c = poHeader.Id;
    	poStatus.AP_Invoice__c = '123456';
    	poStatus.APPaidDate__c = Date.today();
    	insert poStatus;
    }
    
    private String generateProgressBar(Integer currentPosition, String statusMsg, Boolean isError){
    	if(isError){
    		progressErrors += '<font color="red">' + statusMsg + '</font><br/>';
    	}
    	String html = '<table border="1"><tr>';

    	for(Integer i=1; i<intProgressBarNumCells; i++){
    		String tdTitle = '';

    		if(!stepMsgs.isEmpty()){
    			if(stepMsgs.size() >= i){
					tdTitle = stepMsgs.get(i-1);					
    			}
    		}
    		
    		if(i <= currentPosition){
				html += '<td width="20px" height="10px" style="background-color:green;"><span title="' + tdTitle + '"><font color="green">.....</font></span></td>';
    		}else{
    			html += '<td  width="20px" height="10px" >&nbsp</td>';
    		}
    	}
    	html += '</tr></table>';
    	html += '<br/>';
    	html += '<b>' + statusMsg + '</b>';
    	if(!String.isEmpty(progressErrors)){
    		html += '<font color="red">Errors:<font><br/>' + progressErrors;
    	}
    	return html;
    }

    public void createMessageQueueRecord_start(){
	   	intProgressBarNumCells = 6;
	   
	    pollingMessageQueueMsg = '';
	    pollingMessageQueueMsgBottom = '';
	    stepMsgs = new List<String>();
	    stepMsgs.add('');
	    progressErrors = '';
	    showSyncMsg = true;
	    syncProgressMsg = '';
	    syncErrorOccurred = false;
	    showPollingMsg = false;
	    syncProgressMsg = 'Creating Message Queue record...';
	    stepMsgs.add(syncProgressMsg);
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, generateProgressBar(1, syncProgressMsg, false)));
	}

	public void createMessageQueueRecord_complete(){
		try{
			initiateOracleSyncRequest();
		    syncProgressMsg =  'Creating Message Queue record - Complete!';
		    stepMsgs.add(syncProgressMsg);
		    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, generateProgressBar(2, syncProgressMsg, false)));
	    }catch(Exception e){
	    	syncErrorOccurred = true;    		
	    	syncProgressMsg =  'Error occurred while creating Message Queue record!' + e.getMessage();
	    	stepMsgs.add(syncProgressMsg);
		    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, generateProgressBar(2, syncProgressMsg, true)));
	    }    	
	}

    public void sendPOSyncRequest_start(){
	    //syncProgressMsg = 'Sending purchase order request to oracle...';
	    syncProgressMsg = 'Sending purchase order request to oracle...<br/>';
	    stepMsgs.add(syncProgressMsg);	    	
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, generateProgressBar(3, syncProgressMsg, false)));			
	}

    public void sendPOSyncRequest_complete(){
	    //fakeOracleProjectSyncRequest();
	    executeOracleSyncRequest();
	    //syncProgressMsg = syncAttemptResult;
	    syncProgressMsg += syncAttemptResult + '<br/>';

	    ///////////////////////////////testing///////////////////////////
	    //syncErrorOccurred = false;
	    ///////////////////////////////////////////////////////////////////

	    if(syncErrorOccurred){	
	    	stepMsgs.add('An error occurred while sending the request');			
	    }else{	    	
	    	stepMsgs.add('Request successfully sent for purchaseOrderSyncProcessingResult');	
	    }	    

	    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, generateProgressBar(4, syncProgressMsg, syncErrorOccurred)));	       
	}

	public void sendPOSyncRequest_Finish(){
		if(syncErrorOccurred){
			//syncProgressMsg =  'Error occurred while sending purchase order request. Processing cannot continue.<br/>';
			syncProgressMsg += 'Error occurred while sending purchase order request. Processing cannot continue.<br/>';
		    stepMsgs.add('');		    
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, generateProgressBar(5, syncProgressMsg, true)));
			
		}else{
	 		//syncProgressMsg =  'Purchase order request is currently being processed by oracle. You will receive an email if an error occurs.<br/>';
	 		syncProgressMsg += 'Purchase order request is currently being processed by oracle.<br/>';
		    stepMsgs.add('');
		    showPollingMsg = true;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, generateProgressBar(5, syncProgressMsg, false)));
			validatedAndDisplayWarnings();
			hasSyncHistory = true;			
		}	   
	}

	public void checkIfSyncHasBeenProcessed(){
    	pollMessageQueue = true;
    	IntegrationMessageQueue__c msgQueueResult = ECO_Service_ProjectSync.getMessageQueue(this.messageQueueId);

    	if(msgQueueResult == null){
    		//todo - display error - 
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The message queue record with Id =' + messageQueueId + ' could not be found!'));
    		pollMessageQueue = false;
    		return;
    	}

    	if(msgQueueResult.Status__c.equalsIgnoreCase('Success') || msgQueueResult.Status__c.equalsIgnoreCase('Error')){
    		if(msgQueueResult.Status__c.equalsIgnoreCase('Success')){
				pollingMessageQueueMsg = 'The project was successfully processed!';
				pollingMessageQueueMsgBottom = pollingMessageQueueMsg;
				purchaseOrderSyncProcessingResult = 'SUCCESS';
    		}else{
    			pollingMessageQueueMsg = 'An error occurred while processing the project!<br/>' + msgQueueResult.ErrorMessage__c;
    			pollingMessageQueueMsgBottom = pollingMessageQueueMsg;
    			purchaseOrderSyncProcessingResult = 'ERROR';
    		} 
    		generateSyncHistory();
    		pollMessageQueue = false;   		
    	}else{
    		pollingMessageQueueMsg = 'Checking if project has been processed in <span id="pollingTimer">10</span> seconds...';
    		pollingMessageQueueMsgBottom = 'Checking if project has been processed in <span id="pollingTimerBottom">10</span> seconds...';
    	}
    }
    
    public PageReference deletePurchaseOrder() {
        delete poHeader;
        
        PageReference pageRef = new PageReference('/' + projectId);
    	pageRef.setRedirect(true);
    	return pageRef;
    }
}