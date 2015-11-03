public class ECO_BudgetFrameController {
    public Id sProjectId {get; set;}
    public Id sBudgetHeaderId {get; set;}

    public String recordTypeName {get; set;}
    
    public boolean bAllowHeaderNavigation {
        get{
            if(sBudgetHeaderId == null){
                return false;
            }
            
            return true;
        }
        
        private set;
    }
    
    public boolean bHasBudgetHeader {
        get{ 
            if(sBudgetHeaderId == null){
                return false;
            }

            return true;
        }

        private set;
    }
    
    public ECO_BudgetFrameController(){
        Id sRecordId = (Id)ApexPages.currentPage().getParameters().get('Id');
        
        if(sRecordId == null){
            //Handle
            
            return;
        }
        
        String sObjName = sRecordId.getSObjectType().getDescribe().getName();

        if(sObjName == 'pse__Proj__c'){
            sProjectId = sRecordId;
            sBudgetHeaderId = null;
        }else if(sObjName == 'BudgetHeader__c'){
            sProjectId = ECO_Service_Projects.getProjectIdByBudgetHeader(sRecordId);
            sBudgetHeaderId = sRecordId;
            recordTypeName = [SELECT Id, RecordType.DeveloperName FROM BudgetHeader__c Where Id = :sBudgetHeaderId].RecordType.DeveloperName;
        }
    }
	
    public PageReference createEAC() {
        System.savePoint oSavePoint = Database.setSavepoint();

       	try {
            Id budgetHeaderId = ECO_BudgetEACService.createInitECO(sProjectId);
            
            PageReference oPageReference = Page.ECO_BudgetHeader;
            
            oPageReference.getParameters().put('Id', budgetHeaderId);
            return oPageReference;
            
        } catch (Exception e) {
            system.debug(Logginglevel.ERROR, 'Handled Exception:  ' + e.getMessage());
            system.debug(Logginglevel.ERROR, 'Handled Exception.getLineNumber:  ' + e.getLineNumber());
            Database.rollback(oSavePoint);
            ApexPages.addMessages(e);
        }
        
        return null;
    }
    
    public PageReference createChangeOrder(){
        System.savePoint oSavePoint = Database.setSavepoint();

        BudgetHeader__c oBudgetHeader = new BudgetHeader__c();

        try {
            oBudgetHeader.RecordTypeId = ECO_Utils_Meta.getRecordTypeId(BudgetHeader__c.sObjectType, 'Change Order');
            oBudgetHeader.Project__c = sProjectId;
            oBudgetHeader.Status__c = 'Estimate';

            list<BudgetHeader__c> lBudgetHeader = new list<BudgetHeader__c>([SELECT Id FROM BudgetHeader__c WHERE Project__c = :sProjectId]);

            oBudgetHeader.BudgetName__c = 'Change Order ' + lBudgetHeader.size();

            insert oBudgetHeader;
        } catch (Exception e) {
            system.debug('Handled Exception:  '+e.getMessage());
            system.debug('Handled Exception.getLineNumber:  '+e.getLineNumber());
            Database.rollback(oSavePoint);
            ApexPages.addMessages(e);
        }

        try {
            map<Id, BudgetTask__c> mBudgetTask = new map<Id, BudgetTask__c>();
            
            for (pse__Project_Task__c oProjectTask : [SELECT Id
                                                    , Name 
                                                    , (SELECT Id FROM pse__Immediate_Sub_Tasks__r)
                                            FROM pse__Project_Task__c 
                                            WHERE pse__Project__c = :sProjectId]) {

                BudgetTask__c oBudgetTask = new BudgetTask__c();
                oBudgetTask.ProjectTask__c = oProjectTask.Id;
                oBudgetTask.BudgetHeader__c = oBudgetHeader.Id;
                oBudgetTask.TaskName__c = oProjectTask.Name;
                mBudgetTask.put(oProjectTask.Id, oBudgetTask);
            }
            
            if (!mBudgetTask.isEmpty()) {
                insert mBudgetTask.values();
            }

        } catch (Exception e) {
            system.debug('Handled Exception:  '+e.getMessage());
            system.debug('Handled Exception.getLineNumber:  '+e.getLineNumber());
            Database.rollback(oSavePoint);
            ApexPages.addMessages(e);
        }


        PageReference oPageReference = Page.ECO_BudgetHeader;

        oPageReference.getParameters().put('Id', oBudgetHeader.Id);
        
        return oPageReference;
    }

    public PageReference returnToProject(){
        PageReference oPageReference = new PageReference('/' + sProjectId);
        
        return oPageReference;
    }

    public PageReference gotoSetup(){
        PageReference oPageReference = Page.ECO_BudgetQuestionnaire;
		oPageReference.getParameters().put('retURL', '/apex/ECO_BudgetHeaderSummary?id=' + sProjectId);
        oPageReference.getParameters().put('id', sProjectId);
        
        return oPageReference;
    }

    public PageReference showBudgetList(){
        PageReference oPageReference = Page.ECO_BudgetHeaderSummary;

        oPageReference.getParameters().put('id', sProjectId);
        
        return oPageReference;
    }

    public PageReference showBudgetSummary(){
        PageReference oPageReference = Page.ECO_BudgetHeader;

        oPageReference.getParameters().put('id', sBudgetHeaderId);
        
        return oPageReference;
    }

    public PageReference showTaskTab(){
        PageReference oPageReference = Page.ECO_TaskDetail;

        oPageReference.getParameters().put('id', sProjectId);
        
        return oPageReference;
    }

    public PageReference showLaborTab(){
        PageReference oPageReference;
        
        if (recordTypeName != 'EAC')
            oPageReference = Page.ECO_BudgetLabourDetail;
        else {
            oPageReference = Page.ECO_BudgetLabourEAC;
        }
        
        oPageReference.getParameters().put('id', sBudgetHeaderId);
        
        return oPageReference;
    }

    public PageReference showSubTab(){
        PageReference oPageReference = Page.ECO_BudgetSubDetail;
		
        if (recordTypeName == 'EAC') {
            oPageReference = Page.ECO_BudgetSubDetailEAC;
    	}
        oPageReference.getParameters().put('id', sBudgetHeaderId);
        
        return oPageReference;
    }

    public PageReference showODCTab(){
        PageReference oPageReference = Page.ECO_BudgetODCDetail;

        if (recordTypeName == 'EAC') {
            oPageReference = Page.ECO_BudgetODCDetailEAC;
    	}
        oPageReference.getParameters().put('id', sBudgetHeaderId);
        
        return oPageReference;
    }

    public PageReference showContTab(){
        PageReference oPageReference = Page.ECO_BudgetContingency;
        
        if (recordTypeName == 'EAC') {
            oPageReference = Page.ECO_BudgetContingencyEAC;
        }

        oPageReference.getParameters().put('id', sBudgetHeaderId);
        
        return oPageReference;
    }
}