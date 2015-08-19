public with sharing class INC_GetEAApprovalComments_Controller {

	public EnrollmentPlan__c oEnrollmentPlan {get;set;}
    public boolean bRefreshPage {get;set;}
    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public INC_GetEAApprovalComments_Controller(ApexPages.StandardController stdController) {
        this.oEnrollmentPlan = (EnrollmentPlan__c)stdController.getRecord();
        oEnrollmentPlan = INC_Service_EnrollmentPlan.getEnrollmentPlan(new set<id>{oEnrollmentPlan.id})[0];
        System.Debug(logginglevel.error,'In Controller');
        bRefreshPage = false;
    }

    public pageReference onLoad(){
        System.debug(logginglevel.error,'In onload');
        if(oEnrollmentPlan.ApprovalRecentlyProcessed__c){
           updateCommentsfromApprovals();
        }

        return null;
    }

    public void updateCommentsfromApprovals(){
        INC_Service_EnrollmentPlan.createEnrollmentCommentsFromApproval(new set<id>{oEnrollmentPlan.ID});
        oEnrollmentPlan.ApprovalRecentlyProcessed__c = false;
        update oEnrollmentPlan;
      //  pageReference p = new pageReference('/' + oEnrollmentPlan.id);
        bRefreshPage = true;
        //return p;
    }
}