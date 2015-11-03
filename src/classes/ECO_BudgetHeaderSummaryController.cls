public with sharing class ECO_BudgetHeaderSummaryController {
	public pse__Proj__c theProject{ get; set; }
    
    public ECO_DTO_BudgetHeaderWrapper budgetWrapper {get; set;}
    
    private Boolean isThisFirstBudget;
    
    public String selectedBudgetHeader {get; set;}
    public String selectedAction {get; set;}
    
   	public ECO_BudgetHeaderSummaryController (ApexPages.StandardController con) {
		theProject = ECO_Service_Projects.getProjectById(con.getId());
        
        if (theProject.BudgetHeaders__r.isEmpty()) {
			isThisFirstBudget = true;
		} else {
			isThisFirstBudget = false;
		}
        
        if(!isThisFirstBudget) {
        	budgetWrapper = new ECO_DTO_BudgetHeaderWrapper(theProject.Id);    
        }
    }
    
    public PageReference goToQuestionnaire () {
		PageReference pageReference = Page.ECO_BudgetQuestionnaire;
		pageReference.getParameters().put('retURL', '/apex/ECO_BudgetHeaderSummary?id='+theProject.Id);
		pageReference.getParameters().put('id', theProject.Id);
		return pageReference;
	}
    
    public PageReference onAction() {
        String bhId = Apexpages.currentPage().getParameters().get('budgetHeaderId');
        String actionSelected = Apexpages.currentPage().getParameters().get('actionSelected');
        
        system.debug('budgetHeaderId:' + bhId);
        system.debug('selectionAction:' + actionSelected);
        
        if(actionSelected == 'SubmitInternalChange') {
			Id newChangeManagerId = ECO_Service_ChangeManager.createNewInternalChangeManagerFromBudget(bhId, theProject.Id);
            PageReference changeManagerPage = new PageReference('/apex/ECO_ChangeManagerDetail?Id=' + newChangeManagerId + '&mode=Edit');
			changeManagerPage.setRedirect(true);
            return changeManagerPage;
        }
        else if (actionSelected == 'SubmitExternalChange') {
            Id newChangeManagerId = ECO_Service_ChangeManager.createNewExternalChangeManagerFromBudget(bhId, theProject.Id);
            PageReference changeManagerPage = new PageReference('/apex/ECO_ChangeManagerDetail?Id=' + newChangeManagerId + '&mode=Edit');
			changeManagerPage.setRedirect(true);
            return changeManagerPage;
        }
        else if (actionSelected == 'ViewInternalChange') {
            ECO_DTO_BudgetHeader dtoBudgetHeader = budgetWrapper.findBudgetHeaderDTOById(Id.valueOf(bhId));
            PageReference changeManagerPage = new PageReference('/apex/ECO_ChangeManagerDetail?Id=' + dtoBudgetHeader.budgetHeaderChangeManagerMap.get('Internal Change') + '&mode=Edit');
			changeManagerPage.setRedirect(true);
            return changeManagerPage;
        }
        else if(actionSelected == 'ViewExternalChange') {
            ECO_DTO_BudgetHeader dtoBudgetHeader = budgetWrapper.findBudgetHeaderDTOById(Id.valueOf(bhId));
            PageReference changeManagerPage = new PageReference('/apex/ECO_ChangeManagerDetail?Id=' + dtoBudgetHeader.budgetHeaderChangeManagerMap.get('External Change') + '&mode=Edit');
			changeManagerPage.setRedirect(true);
            return changeManagerPage;
        }
        
        PageReference pageReference = new PageReference('/apex/ECO_BudgetHeaderSummary?Id=' + theProject.Id);
        pageReference.setRedirect(true);
		return pageReference;
    }
    
    public PageReference onLoad () {
		if (theProject.DateLastCompletedBudgetQuestionnaire__c == null) {
			return goToQuestionnaire();
		}
		
		if (isThisFirstBudget) {
            System.savePoint oSavePoint = Database.setSavepoint();
            
            BudgetHeader__c oBudgetHeader = new BudgetHeader__c();
            
            try {
                oBudgetHeader.Project__c = theProject.Id;
                oBudgetHeader.BudgetName__c = 'Estimate 1';
                oBudgetHeader.RecordTypeId = ECO_Utils_Meta.getRecordTypeId(BudgetHeader__c.sObjectType, 'Baseline');
                oBudgetHeader.Status__c = 'Estimate';
                
                insert oBudgetHeader; 
            } catch (Exception e) {
                system.debug('Handled Exception:  '+e.getMessage());
                system.debug('Handled Exception.getLineNumber:  '+e.getLineNumber());
                Database.rollback(oSavePoint);
                ApexPages.addMessages(e);
            }
            
            try {
                List<BudgetTask__c> lBudgetTask = new List<BudgetTask__c>();
                
                for (pse__Project_Task__c oProjectTask : [SELECT Id, Name 
                                                		  FROM pse__Project_Task__c 
                                                		  WHERE pse__Project__c = :theProject.Id]) {
    
                    BudgetTask__c oBudgetTask = new BudgetTask__c();
                    oBudgetTask.ProjectTask__c = oProjectTask.Id;
                    oBudgetTask.BudgetHeader__c = oBudgetHeader.Id;
                    oBudgetTask.TaskName__c = oProjectTask.Name;
                    lBudgetTask.add(oBudgetTask);
                }
                
                if (!lBudgetTask.isEmpty()) {
                    insert lBudgetTask;
                }
    
            } catch (Exception e) {
                system.debug('Handled Exception:  '+e.getMessage());
                system.debug('Handled Exception.getLineNumber:  '+e.getLineNumber());
                Database.rollback(oSavePoint);
                ApexPages.addMessages(e);
            }
            
            budgetWrapper = new ECO_DTO_BudgetHeaderWrapper(theProject.Id);
		}
		
		return null;
	}
}