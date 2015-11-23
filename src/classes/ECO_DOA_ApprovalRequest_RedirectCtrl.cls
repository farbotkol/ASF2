public with sharing class ECO_DOA_ApprovalRequest_RedirectCtrl {
  public DOAApprovalRequest__c oDOA {get;set;}
    
    public ECO_DOA_ApprovalRequest_RedirectCtrl(ApexPages.StandardController stdController) {
    this.oDOA = (DOAApprovalRequest__c)stdController.getRecord();
    }
  public pagereference redirectForm(){
        
        return new pagereference('/apex/ECO_DOA_ApprovalRequest_UserBased?id=' + oDOA.id);
        //return null;
    }
}