public with sharing class ECO_PurchaseOrderLineItemController{
	public String taskFilter {get;set;}
	public List<pse__Project_Task__c> projectTasks {get; set;}
	public Boolean noSearchResults {get; private set;}
	public Boolean hasBeenSynced {get; private set;}
	public Boolean hasPreviousVersions {get; private set;}
	public String cancelButtonText {get; private set;}
	public Boolean hasBeenInvoiced {get; private set;}

	private Id projectId;
	private ApexPAges.StandardsetController setCon;
	private final Integer pagingResultSize = 20;

	public POLineItem__c currentPOLineItem {get; set;}
	public String currentPOLineItem_TaskName {get;set;}
	public String currentPOLineItem_TaskId {get;set;}
	public String poHeaderName {get; private set;}
	private Id poLineItemId;
	private Id poHeaderId;
	private List<POLineItem__c> previousVersions;

	public String editType {get; private set;}

	public String retUrl {get; private set;}

	public String searchTaskName{get;set;}

	public ECO_PurchaseOrderLineItemController(ApexPages.StandardController oStandardController) {
		setDefaults();
		poHeaderId = checkForId('poHeaderId');
		projectId = checkForId('projectId');		
		currentPOLineItem_TaskId = checkForId('taskId');

		this.currentPOLineItem = (POLineItem__c)oStandardController.getRecord();
		if(currentPOLineItem.Id != null){
			poLineItemId = currentPOLineItem.Id;
			getPOLineItem();
			hasBeenInvoiced = getInvoiceStatus();
		}else{
			currentPOLineItem.POHeader__c = poHeaderId;
    		currentPOLineItem.LineType__c = 'Unit Rate';
    		currentPOLineItem.LineNumber__c = getDefaultLineNumber();
    		currentPOLineItem.Quantity__c = 1;
    		currentPOLineItem.UnitOfMeasureUserDefined__c = 'Each';
		}

		Initialize();
	}

	public ECO_PurchaseOrderLineItemController(){
		setDefaults();
		poHeaderId = checkForId('poHeaderId');
		projectId = checkForId('projectId');		
		currentPOLineItem_TaskId = checkForId('taskId');
		poLineItemId  = checkForId('Id');

		Initialize();
	}

	private Boolean getInvoiceStatus(){
		Boolean result = false;
		List<POStatus__c> poStatuses = [SELECT Id, AP_Invoice__c
										FROM POStatus__c 
										WHERE POHeader__c = :currentPOLineItem.POHeader__c];
		if(!poStatuses.isEmpty()){
			if(poStatuses.get(0).AP_Invoice__c != null){
				//result = true;
			}
		}
		return result;
	}

	private void getPOLineItem(){
		currentPOLineItem = new POLineItem__c();
    	
    	if(poLineItemId != null){
    		currentPOLineItem = ECO_Service_PurchaseOrders.GetPurchaseOrderLineItem(poLineItemId);
    						
    		if(currentPOLineItem == null){
    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unable to find PO Line Item with Id = ' + poLineItemId + '!'));
				return;
    		}else{

    			editType = 'Edit';
    			if(currentPOLineItem.ProjectTask__c != null){
    				currentPOLineItem_TaskName = currentPOLineItem.ProjectTask__r.ProjectTaskNumber__c + ' (' + currentPOLineItem.ProjectTask__r.Name + ')';
					currentPOLineItem_TaskId = currentPOLineItem.ProjectTask__c;
    			}
    			poHeaderId = currentPOLineItem.POHeader__c;
				projectId = currentPOLineItem.POHeader__r.Project__c;	
				if(currentPOLineItem.OracleSyncDateTime__c != null){
					hasBeenSynced = true;
					cancelButtonText = 'Cancel Purchase Order Line Item';
				}
				previousVersions = ECO_Service_PurchaseOrders.getPreviousPurchaseLineItemVersions(poLineItemId);
				if(!previousVersions.isEmpty()){
					hasPreviousVersions = true;
				}
    		}
    	}    	
	}

	private Decimal getDefaultLineNumber(){
		Decimal result = 1;

		List<POLineItem__c> existingPOLineItems = [SELECT LineNumber__c 
													FROM POLineItem__c 
													WHERE POHeader__c = :poHeaderId
													ORDER BY LineNumber__c DESC LIMIT 1];
		if(!existingPOLineItems.isEmpty()){
			result = existingPOLineItems.get(0).LineNumber__c + 1;
		}
		return result;
	}

	private void setDefaults(){
		cancelButtonText = 'Delete';
		hasBeenInvoiced = false;
		hasBeenSynced = false;
		hasPreviousVersions = false;
		previousVersions = new List<POLineItem__c>();
	}

	private void Initialize(){
		projectTasks = new List<pse__Project_Task__c>();
		taskFilter = '';

		searchTaskName = '';		

		//coming from po summary page or coming from task detail
		if((projectId != null && poHeaderId != null) || (poLineItemId != null) ){
			if(projectId != null)
			getTasksForProject();
    		poHeaderName = [SELECT Name FROM POHeader__c WHERE Id = :poHeaderId].Name;

    		editType = 'Add';    	
		}else{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You have reached this page incorrectly. Project Id is missing!'));
			return;
		}

    	if(ApexPages.currentPage().getParameters().containsKey('retUrl') || ApexPages.currentPage().getParameters().containsKey('retURL')){
    		retUrl = ApexPages.currentPage().getParameters().get('retUrl');
    	}else{
    		retUrl = '/apex/ECO_PurchaseOrderSummary?id=' + poHeaderId;
    	}
	}

	/*public void setSelectedTask(){
		/*

		List<pse__Project_Task__c> tasks = [SELECT Id, Name FROM pse__Project_Task__c WHERE Id = :currentPOLineItem_TaskId];
		if(!tasks.isEmpty()){
			currentPOLineItem_TaskName = tasks.get(0).Name;
		}		
		*/
	//}

	public PageReference saveCurrentPOLineItem(){
		//todo - validation if invoiced
		PageReference pageRef = null;

		Boolean validationOK = true;
		String validationMsg = '';

		if(!String.isEmpty(currentPOLineItem_TaskId)){
			currentPOLineItem.ProjectTask__c = Id.valueOf(currentPOLineItem_TaskId);
		}else{
			validationMsg += '<li>A task must be selected.</li>';
			validationOK = false;
		}
		if(String.isEmpty(currentPOLineItem.ExpenditureType__c)){
			validationMsg += '<li>An expenditure type be selected.</li>';
			validationOK = false;
		}
		if(String.isEmpty(currentPOLineItem.LineDescription__c)){
			validationMsg += '<li>A line description must be completed.</li>';
			validationOK = false;
		}

		system.debug('currentPOLineItem.LineType__c = ' + currentPOLineItem.LineType__c);
		if(currentPOLineItem.LineType__c == 'Unit Rate'){
			if(currentPOLineItem.Quantity__c != null &&  currentPOLineItem.UnitPrice__c != null && currentPOLineItem.Quantity__c != 0 && currentPOLineItem.UnitPrice__c != 0){
				currentPOLineItem.Amount__c = currentPOLineItem.Quantity__c * currentPOLineItem.UnitPrice__c;
			}else{
				validationMsg += '<li>Quantity and Unit Price must be completed if the Line Type is "Unit Rate"</li>';
				validationOK = false;
			}			
		}else{
			system.debug('currentPOLineItem.Amount__c = ' + currentPOLineItem.Amount__c);
			if(currentPOLineItem.Amount__c == null || currentPOLineItem.Amount__c != 0){
				currentPOLineItem.Quantity__c = currentPOLineItem.Amount__c;
				currentPOLineItem.UnitPrice__c = 1;
			}else{
				validationMsg += '<li>Line Amount must be completed if the Line Type is "Fixed Fee"</li>';
				validationOK = false;
			}						
		}

		if(!validationOK){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '<ul>' + validationMsg + '</ul>'));
			return null;
		}

		if(currentPOLineItem.Id == null){	
			//check that line number isn't already in use
			List<POLineItem__c> existingPOLineItems = [SELECT LineNumber__c 
														FROM POLineItem__c 
														WHERE POHeader__c = :currentPOLineItem.POHeader__c 
														AND LineNumber__c = :currentPOLineItem.LineNumber__c];

			if(!existingPOLineItems.isEmpty()){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The Line Number ' + currentPOLineItem.LineNumber__c + ' has already been used. Please enter a different value for the Line Number.'));
				return null;
			}
		}

		Savepoint sp = Database.setSavepoint();

		try{
			if(currentPOLineItem.Id == null){						
				insert currentPOLineItem;					
			}else{

				if(hasBeenSynced){
					//create a clone of the original to use for reference
					POLineItem__c snapshot = ECO_Service_PurchaseOrders.ClonePurchaseOrderLineItemForChangeRequest(currentPOLineItem.Id);
					snapshot.Revision__c = previousVersions.size();
					insert snapshot;

					currentPOLineItem.OracleSyncStatus__c = null;
					currentPOLineItem.OracleSyncDatetime__c = null;
					currentPOLineItem.Revision__c = previousVersions.size() + 1;
					update currentPOLineItem;

				}else{
					update currentPOLineItem;
				}                             
			}	
            
            // Sanchivan: Added code to set the Status to Pending if a PO Line Item is added or edited.
            // Bug 1645
            POHeader__c poHeader = [SELECT Id, Status__c FROM POHeader__c WHERE Id = :currentPOLineItem.POHeader__c];
            if(poHeader.Status__c == 'APPROVED') {
                poHeader.Status__c = 'UNAPPROVED';                
                update poHeader;                    
            } 
            
			pageRef = returnToPurchaseOrder();
		}catch(Exception e){
			Database.rollback(sp);
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
		}
		return pageRef;
	}

	public PageReference cancelPurchaseOrderLineItem(){
		PageReference result = null;
		Savepoint sp = Database.setSavepoint();

		Decimal prevRevisonNumber = 0;

		try{
			if(!hasBeenSynced){				
				if(hasPreviousVersions){
					//if this was an unsynced change order then unarchive the previous version
					prevRevisonNumber = currentPOLineItem.Revision__c - 1;
					POLineItem__c prevVersion = [SELECT Id, 
													OracleSyncStatus__c, 
													OracleSyncDatetime__c
													FROM POLineItem__c
													WHERE ChangeRequestPOLineItem__c = :poLineItemId
													AND Revision__c = :prevRevisonNumber 
													LIMIT 1];
		
					currentPOLineItem = ECO_Service_PurchaseOrders.ClonePurchaseOrderLineItemForChangeRequest(prevVersion.Id);
					currentPOLineItem.Revision__c = prevRevisonNumber;
					currentPOLineItem.IsArchived__c = false;
					currentPOLineItem.Id = poLineItemId;
					update currentPOLineItem;

					delete prevVersion;

				}else{
					delete currentPOLineItem;
				}			

				result = returnToPurchaseOrder();
			}else{
				POLineItem__c snapshot = ECO_Service_PurchaseOrders.ClonePurchaseOrderLineItemForChangeRequest(currentPOLineItem.Id);
				snapshot.Revision__c = previousVersions.size();
				insert snapshot;

				currentPOLineItem.OracleSyncStatus__c = null;
				currentPOLineItem.OracleSyncDatetime__c = null;
				currentPOLineItem.CancelFlag__c = true;
				currentPOLineItem.Revision__c = previousVersions.size() + 1;
				update currentPOLineItem;

				result = returnToPurchaseOrder();
			}
		}catch(Exception e){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error has occurred while deleting or canceling the Purchase Order Line Item: ' + e.getMessage()));
			Database.rollback(sp);
		}
		return result;
	}
    
	public PageReference returnToPurchaseOrder(){
		PageReference pageRef = new PageReference(retUrl);
		pageRef.setRedirect(true);
		return pageRef;
	}

	public void getTasksForProject(){
		String soql = 'SELECT Id, Name, ProjectTaskNumber__c, FinancialTask__c, BillTo__c, ShipTo__c,	pse__End_Date__c, ';
		soql +=	'pse__Start_Date__c, IsBillable__c, IsChargeable__c, WorkTypeName__c, pse__Parent_Task__r.Name ';
		soql += 'FROM pse__Project_Task__c ';
		soql += 'WHERE pse__Project__c = :projectId ';
		if(!String.isEmpty(searchTaskName)){
			soql += 'AND Name LIKE \'%' + String.escapeSingleQuotes(searchTaskName) + '%\' ';
		}
		soql += 'LIMIT ' + pagingResultSize;

		system.debug('soql = ' + soql);
        
        projectTasks = Database.query(soql);
        system.debug('projectTasks size = ' + projectTasks.size());
         if(projectTasks.isEmpty()){
            noSearchResults = true;
        }else{
            noSearchResults = false;
        }
	}

	private Id checkForId(String paramName){
		Id result = null;
        if(ApexPages.currentPage().getParameters().containsKey(paramName)){
            result = Id.valueOf(ApexPages.currentPage().getParameters().get(paramName));          
        }
        return result;
    }
}