public with sharing class INC_EACreateRejectComments_Controller {

	  public EnrollmentPlan__c oEnrollmentPlan{get;set;}
    public Enrollment_Comments__c oEnrollComment{get;set;}
    public boolean shouldRedirect {get;set;}
    public String url{get;set;}
    public String sMessage{get;set;}
    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public INC_EACreateRejectComments_Controller(ApexPages.StandardController stdController) {
        this.oEnrollmentPlan = (EnrollmentPlan__c)stdController.getRecord();
        this.oEnrollmentPlan = INC_Service_EnrollmentPlan.getEnrollmentPlan(new set<id>{oEnrollmentPlan.id})[0];
        shouldRedirect = false;
        url = '/' + oEnrollmentPlan.ID;
        getLatestRejectionComment();
    }

    private void getLatestRejectionComment(){
        list<Enrollment_Comments__c> lComments = [Select ID
                                                          , Comments__c
                                                          , Type__c
                                                          , Reason_Codes__c
                                                          , Approver__c
                                                          , Approver__r.Name
                                                 From Enrollment_Comments__c
                                                 Where EnrollmentApplication__c =: oEnrollmentPlan.ID
                                                 and (Type__c = 'Rejection' or Type__c ='Rejection for Corrections')
                                                 and (Reason_Codes__c = null)
                                                 Order by CreatedDate];
        //find the latest one, hopefully the query should only return one.  But I have to account for bad data
        System.Debug(logginglevel.error,'lcomments: ' + lComments);
        if(lComments != Null && lComments.size() > 0){
                oEnrollComment = lComments[0];
                sMessage = lComments[0].Approver__r.Name + ' rejected the application.  A rejection code must be selected before any changes to the';
                sMessage += ' application are possible.';
        }else{
          oEnrollComment = new Enrollment_Comments__c(EnrollmentApplication__c = oEnrollmentPlan.ID);
        }

    }

    public pageReference save(){
      System.Debug(logginglevel.error,'Saving');
        if(oEnrollComment.Reason_Codes__c == null){
            System.debug(logginglevel.error,'oEnrollComment.Reason_Codes__c ');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'You must choose a reason code before saving.'));
        }else{
            ID workFlowID = ECO_Utils_sObject.getRecordTypeId(EnrollmentPlan__c.sObjectType,'Workflow');
            System.Debug(logginglevel.error,'Workflowid ' + workFlowID);
            if(workFlowID != null){
              oEnrollmentPlan.RecordTypeID=workFlowID;
              System.savePoint sp = Database.setSavePoint();
              try{
                  system.debug(logginglevel.error,'Updating records');
                  update oEnrollmentPlan;
                  update oEnrollComment;
                  shouldRedirect = true;
                  return null;
              }catch(Exception e){
                  system.debug('Handling Exception:  '+e.getMessage() + ' ' + e.getStackTraceString());
                  system.debug(logginglevel.error, 'enrollmentPlan creation error: ' + e);
                  Database.rollBack(sp);
              }  
            }
              
        }

        return null;
    }
}