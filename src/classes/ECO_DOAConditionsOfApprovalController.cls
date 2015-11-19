public with sharing class ECO_DOAConditionsOfApprovalController {
	
	public DOAConditions__c doaConditions {get; set;}
    public DOAApprovalRequest__c doaApproval {get;set;}
	public Agreement__c agreement {get; set;}
    public Id DoaApprovalId {get;set;}
    public Id doaConditionsId {get;set;}
    public String retVFP {get;set;}
    public Id projectId {get;set;}
    public Boolean lockFields {get;set;}
    public String retUrl {get;set;}
	public ECO_DOAConditionsOfApprovalController(ApexPages.StandardController standardController)
	{
		doaConditions = (DOAConditions__c)standardController.getRecord();
        
        DoaApprovalId = ApexPages.currentPage().getParameters().get('doaId');
        retUrl = ApexPages.currentPage().getParameters().get('retURL');
        retVFP = ApexPages.currentPage().getParameters().get('retvfp');
        doaApproval = new DOAApprovalRequest__c();
        lockFields = false;
        
        System.debug('doaConditions:  '+doaConditions.Id);
        System.debug('retVFP:   '+retVFP);
        System.debug('returl::'+retUrl);
        if(doaConditions == null)
            lockfields = false;
        else{
            doaConditionsId = doaConditions.Id;
            Map<String, Schema.SObjectField> objfieldMap = DOAConditions__c.sObjectType.getDescribe().fields.getMap();
     
            String strfieldName = '';
            
            for(Schema.SObjectField Field : objfieldMap.Values()){
                 Schema.DescribeFieldResult fieldResult = Field.getDescribe();
                 strfieldName += fieldResult.getName() + ',';
            }
            strfieldName =  strfieldName + 'Project__r.pse__Project_Manager__r.pse__Salesforce_User__c'+ ',';
            strfieldName = strfieldName.substring(0, strfieldName.length()-1);
            
            List<DOAConditions__c> lDOA = Database.query('Select ' + strfieldName + ' From DOAConditions__c Where Id = :doaConditionsId');
            if(lDOA.size() >0 ){
                doaConditions = lDOA[0];
                System.debug('Project Manager: '+doaConditions.Project__r.pse__Project_Manager__r.pse__Salesforce_User__c);
                System.debug('Logged in user: '+UserInfo.getUserId());
                if(UserInfo.getUserId() == doaConditions.Project__r.pse__Project_Manager__r.pse__Salesforce_User__c)
                    lockFields = true;
            }
        }
        System.debug('lockfields::'+lockFields);
	}

	public void init()
	{
		if(Apexpages.currentPage().getParameters().get('Agreement__c') != null)
		{
			doaConditions.Agreement__c = Apexpages.currentPage().getParameters().get('Agreement__c'); 
			agreement = [select Id, AgreementNumber__c, ContractTitle__c from Agreement__c where Id = :doaConditions.Agreement__c];		
		}
		//else
            //agreement = [select Id, AgreementNumber__c, ContractTitle__c from Agreement__c where Id = :doaConditions.Agreement__c];
        /*if(ApexPages.currentPage().getParameters().get('doaId') != null)
            doaConditions.DOAApprovalRequest__c = ApexPages.currentPage().getParameters().get('doaId');*/
        if(DoaApprovalId != null){
            doaApproval = [Select Id, Project__c From DOAApprovalRequest__c Where Id = :DoaApprovalId];
            doaConditions.Project__c = doaApproval.Project__c;
            doaConditions.DOAApprovalRequest__c = DoaApprovalId;
        }
            
	}
    public PageReference Cancel(){
         PageReference pageRef;
        	
            if(!String.isBlank(returl))
                pageRef = new PageReference(returl);
        	else if(doaConditions.DOAApprovalRequest__c != null || doaConditions.DOAApprovalRequest__c != ''){
                if(retVFP != null || retVFP != '')
               		pageRef = new PageReference('/apex/ECO_DOAApprovals?Id=' + doaConditions.DOAApprovalRequest__c);
                else
                    pageRef = new PageReference('/'+doaConditions.DOAApprovalRequest__c);
            }
            else
                pageRef = new PageReference('/'+doaConditions.Agreement__c);
            System.debug('pageRef    = '+pageRef);
            return pageRef;
    }
	public PageReference save()
	{
        try{
            PageReference pageRef;
            if(doaConditions.Id == null)
                
                insert doaConditions;
            else
                update doaConditions;
            System.debug('doaConditions id is = '+doaConditions.Id);
            System.debug('doaConditions agreement is = '+doaConditions.Agreement__c);
            if(!String.isBlank(returl))
                pageRef = new PageReference(returl);
            else if(doaConditions.DOAApprovalRequest__c != null || doaConditions.DOAApprovalRequest__c != ''){
                if(retVFP != null || retVFP != '')
                	pageRef = new PageReference('/apex/ECO_DOAApprovals?Id=' + doaConditions.DOAApprovalRequest__c);
                else
                    pageRef = new PageReference('/'+doaConditions.DOAApprovalRequest__c);
                
            }
            else
                pageRef = new PageReference('/'+doaConditions.Agreement__c);
            System.debug('pageRef    = '+pageRef);
            return pageRef;
        } catch (Exception e) {
	            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to creating DOA Condition. Please contact your administrator with the following error: ' + e);
	            ApexPages.addMessage(oMsg);
	            return null;
		}
	}
    
    public PageReference returnToDOA(){
        Pagereference Pgref;
        if(doaConditions.DOAApprovalRequest__c != null || doaConditions.DOAApprovalRequest__c !=''){
            if(retVFP != null || retVFP != '')
                Pgref = new PageReference('/apex/ECO_DOAApprovals?Id=' + doaConditions.DOAApprovalRequest__c);
            else
            	Pgref = new PageReference('/'+doaConditions.DOAApprovalRequest__c);
            System.debug('Pgref:   '+Pgref);
            System.debug('doaConditions.DOAApprovalRequest__c:   '+doaConditions.DOAApprovalRequest__c);
       		return Pgref; 
        }
        else if((doaConditions.Agreement__c != null || doaConditions.Agreement__c != '')){
            Pgref = new PageReference('/' + doaConditions.Agreement__c);
            System.debug('Pgref:   '+Pgref);
            System.debug('doaConditions.Agreement__c:   '+doaConditions.Agreement__c);
            return Pgref; 
        }
        else 
            return null;
    }
}