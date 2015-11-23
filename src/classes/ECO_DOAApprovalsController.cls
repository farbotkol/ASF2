public with sharing class ECO_DOAApprovalsController {
    public DOAApprovalRequest__c oDOA {get;set;}
    public List<Form__c> lForm {get;set;}
    public List<DOARegister__c> lDOARegister {get;set;}
    public List<DOAConditions__c> lDOAConditions {get;set;}
    public List<ComplianceConditionsofApproval__c> lCompliance {get;set;}
    public Boolean isDOAAdmin {get;set;}
    public Boolean inQueue {get;set;}
    public String doaId {get;set;}
    public Group oGroup {get;set;}
    public ECO_DOAApprovalsController(ApexPages.StandardController stdcontroller) {
    doaId = ApexPages.currentPage().getParameters().get('Id');
        init();
    }
    public void init(){
        Map<String, Schema.SObjectField> objfieldMap = DOAApprovalRequest__c.sObjectType.getDescribe().fields.getMap();
 
        String strfieldName = '';
        
        for(Schema.SObjectField Field : objfieldMap.Values()){
             Schema.DescribeFieldResult fieldResult = Field.getDescribe();
             strfieldName += fieldResult.getName() + ',';
        }
         
        strfieldName = strfieldName.substring(0, strfieldName.length()-1);
        
        List<DOAApprovalRequest__c> lDOA = Database.query('Select ' + strfieldName + ' From DOAApprovalRequest__c Where Id = :doaId');
        oDOA = lDOA[0];
        oGroup = [Select Id, DeveloperName From Group Where DeveloperName = 'DOAApprovalQueue'];
        if(oDOA.OwnerId == oGroup.Id)
            inQueue = true;
        lForm = [Select Id, Name, CreatedById, CreatedDate From Form__c Where DOAApprovalRequest__c =: oDOA.Id];
        lDOARegister = [Select Id, EnterpriseDOA__c, DCSsubDOA__c, RiskTitle__c, DOATrigger__c, ApprovalStatus__c From DOARegister__c Where DOAApprovalRequest__c = :oDOA.Id];
        lDOAConditions = [Select Id, Name, CreatedBy__c, Mitigation_Plan__c, CreatedDate From DOAConditions__c Where DOAApprovalRequest__c = :oDOA.Id];
        lCompliance = [Select Id, Name, ComplianceStatus__c, GeneralComments__c, ComplianceStatusDate__c, ConditionsCompleted__c, ConditionsCompletedDate__c From ComplianceConditionsofApproval__c Where DOAApprovalRequest__c = :oDOA.Id];
        System.debug('oDOA id is :'+oDOA.Id);
        User oUser = [Select Id, isDoaAdmin__c From User Where Id = :UserInfo.getUserId()];
        isDOAAdmin = oUser.isDoaAdmin__c;
        System.debug('isDOAAdmin:'+isDOAAdmin);
        System.debug('oUser.isDoaAdmin__c:   '+oUser.isDoaAdmin__c);
    }
    public PageReference saveDOA(){
        try{
            update oDOA;
            init();
            System.debug('oDOA:   '+oDOA);
            //PageReference pageRef = new PageReference('/apex/ECO_DOAApprovals?Id=' + oDOA.Id);
            //System.debug('pageRef:   '+pageRef);
            //return ApexPages.currentPage();
            return null;
        }catch(Exception e) {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to update DOA Approval Request. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            return null;
        }
    }
    public PageReference submitAECOMHub(){
        try{
            if(oDOA.SubmitAECOMHubForApproval__c==false && oDOA.AECOMHubCountofApprovers__c >0 && oDOA.AECOMHubApprovalsRequired__c ==true ){ 
                oDOA.SubmitAECOMHubforApproval__c = true ;
                update oDOA; 
            } 
            else{ 
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that AECOM Hub has Approvers and that AECOM Hub Checkbox is selected.');
                ApexPages.addMessage(myMsg); 
                //alert('Please ensure that AECOM Hub has Approvers and that AECOM Hub Checkbox is selected.'); 
            } 
            return null;
         }catch(Exception e) {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to update DOA Approval Request. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            return null;
        }
    }
    public PageReference submitGeography(){
        system.debug('inside geography');
        try{
            if(oDOA.SubmitGeographyforApproval__c==false && oDOA.GeoCountOfApprovers__c >0 && oDOA.GeographyApprovalsRequired__c ==true ){ 
                system.debug('inside geography if');
                oDOA.SubmitGeographyforApproval__c = true ;
                update oDOA; 
            } 
            else{ 
                system.debug('inside geography else');
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that Geography has Approvers and that Geography Checkbox is selected.');
                ApexPages.addMessage(myMsg); 
                //alert('Please ensure that AECOM Hub has Approvers and that AECOM Hub Checkbox is selected.'); 
            } 
            return null;
        }catch(Exception e) {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to update DOA Approval Request. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            return null;
        }
    }
    public PageReference submitGroup(){
        system.debug('inside group');
        try{
            if(oDOA.SubmitGroupforApproval__c==false && oDOA.GroupCountofApprovers__c >0 && oDOA.GroupApprovalsRequired__c ==true ){ 
                system.debug('inside group if');
                oDOA.SubmitGroupforApproval__c = true ;
                update oDOA; 
                return null;
            } 
            else{ 
                system.debug('inside group else');
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that Group has Approvers and that Group Checkbox is selected.');
                ApexPages.addMessage(myMsg); 
                //alert('Please ensure that AECOM Hub has Approvers and that AECOM Hub Checkbox is selected.'); 
                return null;
            } 
         }catch(Exception e) {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to update DOA Approval Request. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            return null;
        }
        
    }
    public PageReference submitEnterprise(){
        try{
            if(oDOA.SubmitEnterpriseforApproval__c==false && oDOA.EnterpriseCountofApprovers__c >0 && oDOA.EnterpriseApprovalsRequired__c ==true ){ 
                oDOA.SubmitEnterpriseforApproval__c = true ;
                update oDOA; 
            } 
            else{ 
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that Enterprise has Approvers and that Enterprise Checkbox is selected.');
                ApexPages.addMessage(myMsg); 
                //alert('Please ensure that AECOM Hub has Approvers and that AECOM Hub Checkbox is selected.'); 
            } 
            return null;
         }catch(Exception e) {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to update DOA Approval Request. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            return null;
        }
    }
    public PageReference submitDCSHub(){
        try{
            if(oDOA.SubmitDCSHubforApproval__c==false && oDOA.DCSHubCountofApprovers__c >0 && oDOA.DCSHubApprovalsRequired__c ==true ){ 
                oDOA.SubmitDCSHubforApproval__c = true ;
                update oDOA; 
            } 
            else{ 
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that DCS Hub has Approvers and that DCS Hub Checkbox is selected.');
                ApexPages.addMessage(myMsg); 
                //alert('Please ensure that AECOM Hub has Approvers and that AECOM Hub Checkbox is selected.'); 
            } 
            return null;
         }catch(Exception e) {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to update DOA Approval Request. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            return null;
        }
    }
    public PageReference submitDOA(){
        try{
            System.debug('inside submitDOA before update:   '+oDOA.Id+'    '+oDOA.AssigntoDoAApprovalQueue__c);
            if(oDOA.AssigntoDoAApprovalQueue__c != true){
                oDOA.AssigntoDoAApprovalQueue__c = true;
              update oDOA;
            }
            System.debug('inside submitDOA after update:   '+oDOA.Id+'    '+oDOA.AssigntoDoAApprovalQueue__c);
            return null;
        }catch(Exception e) {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to update DOA Approval Request. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            return null;
        }
    }
    public PageReference submitDOAQueue(){
        try{
            system.debug('before update: '+oDOA.Id+'    '+oDOA.AssigntoDoAApprovalQueue__c);
            if(oDOA.AssigntoDoAApprovalQueue__c != true){
                oDOA.AssigntoDoAApprovalQueue__c = true;
                update oDOA;
                init();
            }
            System.debug('after update:   '+oDOA.Id+'    '+oDOA.AssigntoDoAApprovalQueue__c);    
            return null;
        }catch(Exception e) {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to update DOA Approval Request. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            return null;
        }
    }
}