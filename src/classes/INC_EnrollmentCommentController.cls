public without sharing class INC_EnrollmentCommentController {

	public EnrollmentPlan__c oEnrollmentApp{get;set;}
    public Enrollment_Comments__c oEnrollComment{get;set;}
    public boolean isRejectedRecType{get;set;}
    public String sMessage{get;set;}
    public boolean bCommentFound{get;set;}
    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public INC_EnrollmentCommentController() {
        oEnrollmentApp = INC_Service_EnrollmentPlan.getEnrollmentPlan(new set<id>{Apexpages.currentpage().getParameters().get('id')})[0];
         ID rejectedRecTypeID = Schema.SObjectType.EnrollmentPlan__c.getRecordTypeInfosByName().get('Rejected Application').getRecordTypeId();
            
           
            if(rejectedRecTypeID == oEnrollmentApp.RecordTypeID){
                isRejectedRecType = true;
                bCommentFound = getLatestRejectionComment();

            }else{
                isRejectedRecType = false;
            }

    }

    private boolean getLatestRejectionComment(){
        boolean bReturn = false;
        
        list<Enrollment_Comments__c> lComments;
        if(oEnrollmentApp.ApplicationType__c !='OPT'){
                                        lComments = [Select ID
                                                          , Comments__c
                                                          , Type__c
                                                          , Reason_Codes__c
                                                          , Approver__c
                                                          , Approver__r.Name
                                                          , IsRejection__c
                                                          , Final_Rejection__c
                                                 From Enrollment_Comments__c
                                                 Where EnrollmentApplication__c =: oEnrollmentApp.ID
                                                 and (Type__c = 'Rejection' or Type__c ='Rejection for Corrections')
                                                 and (Reason_Codes__c = null)
                                                 Order by CreatedDate];
        }else{
                                        lComments = [Select ID
                                                          , Comments__c
                                                          , Type__c
                                                          , Reason_Codes__c
                                                          , Approver__c
                                                          , Approver__r.Name
                                                          , IsRejection__c
                                                          , Final_Rejection__c
                                                 From Enrollment_Comments__c
                                                 Where EnrollmentApplication__c =: oEnrollmentApp.ID
                                                 and (Type__c = 'Rejection')
                                                 and (Reason_Codes__c = null)
                                                 Order by CreatedDate];
        }
        //find the latest one, hopefully the query should only return one.  But I have to account for bad data
        System.Debug(logginglevel.error,'lcomments: 2 ' + lComments);
        if(lComments != Null && lComments.size() > 0){
                bReturn = true;
                oEnrollComment = lComments[0];
                if(oEnrollmentApp.ApplicationType__c != 'OPT'){
                  sMessage = lComments[0].Approver__r.Name + ' rejected the application.  A rejection code must be selected before any changes to the';
                  sMessage += ' application are possible.';
                }else{
                  sMessage = lComments[0].Approver__r.Name + ' approved opting out of the application.  A rejection code must be selected.';
                }
        }else{
          oEnrollComment = new Enrollment_Comments__c(EnrollmentApplication__c = oEnrollmentApp.ID);
        }

        return bReturn;
    }


    public pageReference saveComments(){
      System.Debug(logginglevel.error,'Saving');
        if(oEnrollComment.Reason_Codes__c == null){
            System.debug(logginglevel.error,'oEnrollComment.Reason_Codes__c ');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'You must choose a reason code before saving.'));
        }else{
          if(oEnrollComment.Comments__c != null && oEnrollComment.Comments__c != 'Please enter a comment.'
             && oEnrollComment.Comments__c != ''){
            ID workFlowID = ECO_Utils_sObject.getRecordTypeId(EnrollmentPlan__c.sObjectType,'Workflow');
            ID paymentID = ECO_Utils_sObject.getRecordTypeId(EnrollmentPlan__c.sObjectType,'Payment Request');
            System.Debug(logginglevel.error,'Workflowid ' + workFlowID);
            System.Debug(logginglevel.error,'paymentID ' + workFlowID);
            oEnrollmentApp.ApprovalRecentlyProcessed__c = false;
           // oEnrollmentApp.EnrollmentStatus__c = 'Rejected for Correction';
            if(workFlowID != null && paymentID != null){

              if(oEnrollmentApp.ApplicationType__c == 'PAY'){
                  oEnrollmentApp.RecordTypeID=paymentID;
              } else {
                  oEnrollmentApp.RecordTypeID=workFlowID;
              }

              System.savePoint sp = Database.setSavePoint();
              try{
                  system.debug(logginglevel.error,'Updating records');
                  update oEnrollmentApp;
              }catch(Exception e){
                  system.debug('Handling Exception:  '+e.getMessage() + ' ' + e.getStackTraceString());
                  system.debug(logginglevel.error, 'enrollmentPlan update error: ' + e);
                  Database.rollBack(sp);
              }
              try{
                  system.debug(logginglevel.error,'Updating Comments');
                  upsert oEnrollComment;
              }catch(Exception e){
                  system.debug('Handling Exception:  '+e.getMessage() + ' ' + e.getStackTraceString());
                  system.debug(logginglevel.error, 'comment creation error: ' + e);
                  Database.rollBack(sp);
              }  
              
              System.Debug(logginglevel.error,'oEnrollmentApp.Reason_Codes__c: ' + oEnrollComment.Reason_Codes__c);

              String sReason = oEnrollComment.Reason_Codes__c;

              /*if(sReason == 'Project in Litigation' ||
                 sReason.contains('Project is Intercompany') ||
                 sReason == 'Project on Hold' ||
                 sReason == 'Project Nearing Completion' ||
                 sReason == 'Poor Project Performance'){
                if(oEnrollmentApp.ApplicationType__c != 'OPT'){
                  System.Debug(logginglevel.error,'rejecting all');
                  rejectAll();
                }
              } */
              if(oEnrollComment.Final_Rejection__c && oEnrollmentApp.ApplicationType__c != 'OPT'){
                 System.Debug(logginglevel.error,'rejecting all');
                  rejectAll();
              }
            }
          }else{
                System.Debug(logginglevel.error,'Not saving comments');
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'You must enter a valid comment.'));
            
          }
              
        }

        //pageReference pr = new PageReference('/apex/INC_EnrollmentApp?id='+oEnrollmentApp.id);
        //pr.setredirect(true);
        return null;
    }

    public static Id getWorkItemId(Id targetObjectId)
    {
      Id retVal = null;
      for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
          where p.ProcessInstance.TargetObjectId =: targetObjectId])
      {
          retVal =  workItem.Id;
      }
      return retVal;
    }

    public pageReference rejectAll(){
      /*ID workItem = getWorkItemId(oEnrollmentApp.ID);
      while(workItem != null){
          //req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
          req.setWorkitemId(workItem);
              // Submit the request for approval
          workItem = getWorkItemId(oEnrollmentApp.id);
       
      }
      return new pageReference('/apex/INC_EnrollmentApp?id=' + oEnrollmentApp.id);*/

      ID workItem = getWorkItemId(oEnrollmentApp.ID);
      While(workItem != null){
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
          req.setComments('System generated final rejection.');
          req.setAction('Reject');
          //req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
          req.setWorkitemId(workItem);
              // Submit the request for approval
          Approval.ProcessResult result =  Approval.process(req);
          workItem = getWorkItemId(oEnrollmentApp.id);
      }

      oEnrollmentApp = INC_Service_EnrollmentPlan.getEnrollmentPlan(new set<id>{oEnrollmentApp.ID})[0];
      oEnrollmentApp.ApprovalRecentlyProcessed__c = false;
      //oEnrollmentApp.EnrollmentStatus__c = 'Rejected';
      update oEnrollmentApp;

      /*If(workItem != null){
            List<ProcessInstanceWorkitem> workitems = new List<ProcessInstanceWorkitem>([select Id from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId =:oEnrollmentApp.id]);

            list<Approval.ProcessWorkitemRequest> itemsToUpdate = new list<Approval.ProcessWorkitemRequest>();

            for(ProcessInstanceWorkitem w: workitems){
                Approval.ProcessWorkitemRequest PWR = new Approval.ProcessWorkitemRequest();
                PWR.setComments('Recalled due to final Rejection');
                PWR.setAction('Removed');
                PWR.setWorkItemId(w.Id);
                itemsToUpdate.add(PWR);
            }                
            System.Debug(logginglevel.error,'itemsToUpdate: ' + itemsToUpdate);
            if(itemsToUpdate.size() > 0){
                list<Approval.ProcessResult> results =  Approval.process(itemsToUpdate);
                System.debug(logginglevel.error,'results: ' + results);
            }
      }
      */

      return new pageReference('/apex/INC_EnrollmentApp?id=' + oEnrollmentApp.id);


    }

}