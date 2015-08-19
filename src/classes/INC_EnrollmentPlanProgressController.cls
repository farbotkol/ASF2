public with sharing class INC_EnrollmentPlanProgressController {

	Public EnrollmentPlan__c oEnrollmentPlan {get;set;}
    Public Boolean bShowProgress {get;set;}
    Public String ProgressToolTip {get;set;}
    Public String oneTooltip {get;set;}
    Public String twoTooltip {get;set;}
    Public String threeTooltip {get;set;}
    Public String fourTooltip {get;set;}
    Public String fiveTooltip {get;set;}
    Public String sixTooltip {get;set;}
    Public String sevenTooltip {get;set;}
    Public String eightTooltip {get;set;}
    Public String nineTooltip {get;set;}
    Public String tenTooltip {get;set;} 
    Public String sProgressMessage{get;set;}
    Public boolean loadcomplete{get;set;}
    Public boolean shouldRedirect{get;set;}
    Public String EnrollID{get;set;}

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public INC_EnrollmentPlanProgressController(){
        EnrollID =ApexPages.currentPage().getParameters().get('id');
        system.Debug(logginglevel.error,'progress component id' + EnrollID);
        oEnrollmentPlan = getValues(EnrollID);
        bShowProgress = true;
        setToolTips();
    }
  
    public INC_EnrollmentPlanProgressController(ApexPages.StandardController stdController) {
        this.oEnrollmentPlan = (EnrollmentPlan__c)stdController.getRecord();
        oEnrollmentPlan = getValues();
        bShowProgress = true;
        shouldRedirect = false;
        if(oEnrollmentPlan.StatusNumber__c > 6){
            bShowProgress = false;

        }
        setToolTips();
        loadcomplete = !oEnrollmentPlan.ApprovalRecentlyProcessed__c;
        if(!loadcomplete){
            sProgressMessage = 'Loading comments';
            if(oEnrollmentPlan.EnrollmentStatus__c != 'Rejected'){
                sProgressMessage += ' please do not attempt to edit record until this message disappears';
            }
            sProgressMessage += '...Please Wait';
        }
    }

    public EnrollmentPlan__c getValues(String ID) {
        return [Select ID
                         , StatusNumber__c
                         , EnrollmentStatus__c
                         , WorkflowProcess__c
                         , ExceptionFlag__c
                         ,ApprovalRecentlyProcessed__c
                From EnrollmentPlan__c
                Where Id =: ID];

    }

    public EnrollmentPlan__c getValues() {
        return [Select ID
                         , StatusNumber__c
                         , EnrollmentStatus__c
                         , WorkflowProcess__c
                         , ExceptionFlag__c
                         ,ApprovalRecentlyProcessed__c
                From EnrollmentPlan__c
                Where Id =: oEnrollmentPlan.iD][0];

    }

    public void setToolTips(){
        ProgressToolTip = oEnrollmentPlan.WorkflowProcess__c;
        if(ProgressToolTip != null)
            ProgressToolTip = ProgressToolTip.replace('<br>', '\r\n');
        if(oEnrollmentPlan.StatusNumber__c ==1){
            oneTooltip = 'One Tooltip';
        }
        if(oEnrollmentPlan.StatusNumber__c ==2){
            twoTooltip = 'Two Tooltip';
        }
        if(oEnrollmentPlan.StatusNumber__c ==3){
            threeTooltip = '3 Tooltip';
        }
        if(oEnrollmentPlan.StatusNumber__c ==4){
            fourTooltip = '4 Tooltip';
        }
        if(oEnrollmentPlan.StatusNumber__c ==5){
            fiveTooltip = '5 Tooltip';
        }
        if(oEnrollmentPlan.StatusNumber__c ==6){
            sixTooltip = '6 Tooltip';
        }
        if(oEnrollmentPlan.StatusNumber__c ==7){
            sixTooltip = '7 Tooltip';
        }
        if(oEnrollmentPlan.StatusNumber__c ==8){
            sixTooltip = '8 Tooltip';
        }
        if(oEnrollmentPlan.StatusNumber__c ==9){
            sixTooltip = '9 Tooltip';
        }
        if(oEnrollmentPlan.StatusNumber__c ==10){
            sixTooltip = '10 Tooltip';
        }
    }
  //stuff for comment load section
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
      
    }
    public pageReference checkforenrollmentProcess(){
        String sID =  ApexPages.currentPage().getParameters().get('id');
        EnrollmentPlan__c ep = [Select Id, ApprovalRecentlyProcessed__c
                                From EnrollmentPlan__c
                                where id =: sID][0];
        if(!ep.ApprovalRecentlyProcessed__c){
            shouldRedirect = true;
        }

        return null;
    }

}