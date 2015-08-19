public with sharing class INC_EnrollmentApp_Controller {

	private EnrollmentPlan__c oEnrollmentApp;
    public string enrollcharId {get;set;}
    private final ApexPages.StandardController stdController;
    public Enrollment_Comments__c oEnrollComment{get;set;}
    public String sMessage{get;set;}
    public String sRectypeName{get;set;}
    public boolean isRejectedRecType {get;set;}
    public boolean bTandM {get;set;}
    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public INC_EnrollmentApp_Controller(ApexPages.StandardController stdController) {
        
        this.stdController = stdController;
        if(!Test.isRunningTest()){
          stdController.addFields(new list<String>{'IncentivePlan__r.ContractType__c'});
        }
        this.oEnrollmentApp = (EnrollmentPlan__c)stdController.getRecord();
        enrollcharId = String.ValueOF(oEnrollmentApp.id).mid(0,15);
        ID rejectedRecTypeID = Schema.SObjectType.EnrollmentPlan__c.getRecordTypeInfosByName().get('Rejected').getRecordTypeId();
        if(rejectedRecTypeID == oEnrollmentApp.RecordTypeID){
            isRejectedRecType = true;
            getLatestRejectionComment();
        }else{
            isRejectedRecType = false;
        }
        if(oEnrollmentApp.IncrementalGMvsBaseline__c > 4){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Incremental GM% vs Baseline is greater than 4%'));
        }
        bTandM = oEnrollmentApp.IncentivePlan__r.ContractType__c == 'Time & Material'?true:false;
        System.Debug(logginglevel.error,'isRejectedRecType ' + isRejectedRecType);
    }

    public String getRecordName() {
        return 'Hello ';
    }
    public pageReference save(){
        System.debug(logginglevel.error,'Save in custom controller');
        stdController.save();
        pageReference pf = new pageReference('/apex/INC_EnrollmentApp?id=' + oEnrollmentApp.Id);
        return pf;
    }

    public PageReference submit(){
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();  
        req1.setComments('Submitted for Approval');
        req1.setObjectId(oEnrollmentApp.ID);
        req1.setSubmitterID(UserInfo.getUserId());
        try{
            Approval.ProcessResult result = Approval.process(req1); 
            }catch(Exception e){
                System.Debug(logginglevel.error,'Exception: ' + e.getMessage());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'All criteria has not be met.'));
            }
        pageReference pf = new pageReference('/apex/INC_EnrollmentApp?id=' + oEnrollmentApp.Id);
        return null;   

    } 
    public pageReference saveAndReturnToBudget(){
        stdController.save();
        pageReference pr = ApexPages.currentPage();
        pr.setAnchor('budgetsection');
        pr.setredirect(true);
        return pr;
    }
    public pageReference chooseplan(){
        pageReference pr = new pageReference('/apex/INC_Chose?id=' + oEnrollmentApp.id);
        pr.setredirect(true);
        return pr;
    }

    public pageReference showAppMetrics(){
        pageReference pr = new pageReference('/apex/INC_ShowEnrollmentMetrics?id=' + oEnrollmentApp.id);
        pr.setredirect(true);
        return pr;
    }

    public pageReference reassignApprovers(){
        pageReference pr = new pageReference('/apex/INC_AssignApprovers?id=' + oEnrollmentApp.id);
        pr.setredirect(true);
        return pr;
    }
   
    public pageReference createChangeRequest(){
        pageReference pr = null;
        if(oEnrollmentApp.EnrollmentStatus__c == 'Enrolled'){
            pr = new pageReference('/apex/INC_EnrollmentApp?id='+INC_Service_EnrollmentPlan.cloneEnrollment(oEnrollmentApp.id,INC_Service_EnrollmentPlan.RequestType.CHANGE));
            pr.setredirect(true);
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Current application needs to be Enrolled to create a change request.'));
        }

        return pr;
    }

    public pageReference createPaymentRequest(){
      pageReference pr = null;
      if(oEnrollmentApp.EnrollmentStatus__c == 'Enrolled'){
        pr = new pageReference('/apex/INC_EnrollmentApp?id='+INC_Service_EnrollmentPlan.cloneEnrollment(oEnrollmentApp.id,INC_Service_EnrollmentPlan.RequestType.PAYMENT));
            pr.setredirect(true);
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Current application needs to be Enrolled to create a change request.'));
        }

        return pr;
    }

    public void updateCommentsfromApprovals(){
        oEnrollmentApp = INC_Service_EnrollmentPlan.getEnrollmentPlan(new set<id>{oEnrollmentApp.ID})[0];
        if(oEnrollmentApp.ApprovalRecentlyProcessed__c){
            INC_Service_EnrollmentPlan.createEnrollmentCommentsFromApproval(new set<id>{oEnrollmentApp.ID});
        }
       
    }
//code for rejection comments section
    private void getLatestRejectionComment(){
        list<Enrollment_Comments__c> lComments = [Select ID
                                                          , Comments__c
                                                          , Type__c
                                                          , Reason_Codes__c
                                                          , Approver__c
                                                          , Approver__r.Name
                                                 From Enrollment_Comments__c
                                                 Where EnrollmentApplication__c =: oEnrollmentApp.ID
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
          oEnrollComment = new Enrollment_Comments__c(EnrollmentApplication__c = oEnrollmentApp.ID);
        }

    }

    public pageReference saveComments(){
      System.Debug(logginglevel.error,'Saving');
        if(oEnrollComment.Reason_Codes__c == null){
            System.debug(logginglevel.error,'oEnrollComment.Reason_Codes__c ');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'You must choose a reason code before saving.'));
        }else{
            ID workFlowID = ECO_Utils_sObject.getRecordTypeId(EnrollmentPlan__c.sObjectType,'Workflow');
            System.Debug(logginglevel.error,'Workflowid ' + workFlowID);
            oEnrollmentApp.ApprovalRecentlyProcessed__c = false;
            
            if(workFlowID != null){
              oEnrollmentApp.RecordTypeID=workFlowID;
              System.savePoint sp = Database.setSavePoint();
              try{
                  system.debug(logginglevel.error,'Updating records');
                  update oEnrollmentApp;
                  return null;
              }catch(Exception e){
                  system.debug('Handling Exception:  '+e.getMessage() + ' ' + e.getStackTraceString());
                  system.debug(logginglevel.error, 'enrollmentPlan update error: ' + e);
                  Database.rollBack(sp);
              }
              try{
                  system.debug(logginglevel.error,'Updating records');
                  upsert oEnrollComment;
                  return null;
              }catch(Exception e){
                  system.debug('Handling Exception:  '+e.getMessage() + ' ' + e.getStackTraceString());
                  system.debug(logginglevel.error, 'comment creation error: ' + e);
                  Database.rollBack(sp);
              }  
     
            }
              
        }

        //pageReference pr = new PageReference('/apex/INC_EnrollmentApp?id='+oEnrollmentApp.id);
        //pr.setredirect(true);
        return null;
    }




















}