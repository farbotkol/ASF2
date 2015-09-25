public with sharing class INC_EnrollmentApp_Controller {

	  public EnrollmentPlan__c oEnrollmentApp{get;set;}
    public String enrollcharId {get;set;}
    private final ApexPages.StandardController stdController;
    public Enrollment_Comments__c oEnrollComment{get;set;}
    public String sMessage{get;set;}
    public String sRectypeName{get;set;}
    public boolean isRejectedRecType {get;set;}
    public boolean bTandM {get;set;}
    public boolean bShowSubmit {get;set;}
    public boolean bShowApprovalHistory{get;set;}
    public String activeTab {get;set;}
    public Boolean showWizard{get;set;}
    public boolean disableStep2{get;set;}
    public boolean bCommentFound{get;set;}
    public boolean bFinished {get;set;}
    public boolean bSubmitWorked{get;set;}
    public boolean bRenderInputFinFields{get;set;}
    public String sExceptions{get;set;}
    

    public INC_EnrollmentApp_Controller(ApexPages.StandardController stdController) {
        activeTab = 'step1';
        bRenderInputFinFields = true;
        bCommentFound = true; //do not move this line.
        System.debug(logginglevel.error,'activeTab: ' + activeTab);
        
        this.stdController = stdController;
        
        if(!Test.isRunningTest()){
          stdController.addFields(new list<String>{'ApplicationExceptionsFP__c'
                                                  ,'ApplicationExceptionsTM__c'
                                                  ,'Application_Exceptions__c'
                                                  ,'StatusNumber__c'
                                                  ,'IncentivePlan__r.ContractType__c'
                                                  ,'IncentiveProject__r.ProjectManager__c'
                                                  ,'IncentiveProject__r.ContractTypeShortName__c'
                                                  ,'WizardStatus__c'
                                                  ,'AppIicationIssues__c'
                                                  ,'InterimPaymentRequested__c'
                                                  , 'ApplicationExceptionsPay__c'
                                                  ,'IncentiveProject__r.DTWAdmin__c'});
        }

        this.oEnrollmentApp = (EnrollmentPlan__c)stdController.getRecord();
        
        setExceptions();

        System.debug(logginglevel.error,UserInfo.getUserId() + ' ' + oEnrollmentApp.IPProjectManager__c);
        if((oEnrollmentApp.AppIicationIssues__c == null || oEnrollmentApp.AppIicationIssues__c == '')&&
                oEnrollmentApp.EnrollmentStatus__c == 'Pending PM Action'){
            bShowSubmit = true;
        }else{
            bShowSubmit = false;
        }

        if(oEnrollmentApp.EnrollmentStatus__c == 'Pending PM Action'){
             bSubmitWorked = false;
        }

        if((UserInfo.getUserId() == oEnrollmentApp.IncentiveProject__r.ProjectManager__c && oEnrollmentApp.WizardStatus__c != 'Complete' &&
           oEnrollmentApp.EnrollmentStatus__c == 'Pending PM Action') && oEnrollmentApp.ApplicationType__c != 'Pay' &&(
                oEnrollmentApp.IncentiveProject__r.ProjectManager__c == UserInfo.getUserId())){
            showWizard = true;
            disableStep2 = false;
            if(oEnrollmentApp.WizardStatus__c == 'Step 1' || oEnrollmentApp.WizardStatus__c == '' || oEnrollmentApp.WizardStatus__c == null){
              activeTab = 'step1';
            }else{
              if(oEnrollmentApp.WizardStatus__c == 'Step 2'){
                activeTab = 'step2';
                System.debug(logginglevel.error,'oEnrollmentApp plan ' + oEnrollmentApp.IncentivePlan__c);
                if(oEnrollmentApp.IncentivePlan__c == null){
                  disableStep2 = true;
                }
                System.debug(logginglevel.error,'disableStep2 ' + disableStep2);
              }else{
                activeTab = 'step3';
              }
            }
        }else{
            showWizard = false;
           
            bRenderInputFinFields = RenderInputFinFields();

            if(oEnrollmentApp.AppIicationIssues__c == null || oEnrollmentApp.AppIicationIssues__c == ''){
              bShowApprovalHistory = true;
            }else{
              if(oEnrollmentApp.ApplicationType__c=='Opt-Out'){
                bShowApprovalHistory = true;
              }else{
                bShowApprovalHistory = false;
              }
            }

            enrollcharId = String.ValueOF(oEnrollmentApp.id).mid(0,15);
            ID rejectedRecTypeID = Schema.SObjectType.EnrollmentPlan__c.getRecordTypeInfosByName().get('Rejected Application').getRecordTypeId();
            
           
            if(rejectedRecTypeID == oEnrollmentApp.RecordTypeID){
                isRejectedRecType = true;
                bCommentFound = getLatestRejectionComment();

            }else{
                isRejectedRecType = false;
            }
            if(oEnrollmentApp.IncrementalGMvsBaseline__c > 4 && isRejectedRecType == false){
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Incremental GM% vs Baseline is greater than 4%'));
            }
            bTandM = oEnrollmentApp.IncentivePlan__r.ContractType__c == 'Time & Material'?true:false;
            System.Debug(logginglevel.error,'isRejectedRecType ' + isRejectedRecType);
          }

    }

    

    public integer getUserType(){
      User currentUser = [Select id, DTWApplicationLevel__c from User where id=:UserInfo.getUserId()][0];
      Integer iReturn = 1;
      if(currentUser.DTWApplicationLevel__c=='Corporate'){
        iReturn = 2;
      }
      if(currentUser.DTWApplicationLevel__c == 'DTW Admin'){
        iReturn = 3;
      }
      return iReturn;
    }

    private void setExceptions(){
        if(oEnrollmentApp.Application_Exceptions__c != null){
          sExceptions = oEnrollmentApp.Application_Exceptions__c;
        } 
        if(oEnrollmentApp.ApplicationExceptionsFP__c != null){ 
          if(sExceptions != null){
            sExceptions += oEnrollmentApp.ApplicationExceptionsFP__c;
          }else{
            sExceptions = oEnrollmentApp.ApplicationExceptionsFP__c;
          }
          
        }
        if(oEnrollmentApp.ApplicationExceptionsTM__c != null){
          if(sExceptions != null){
            sExceptions += oEnrollmentApp.ApplicationExceptionsTM__c;
          }else{
            sExceptions = oEnrollmentApp.ApplicationExceptionsTM__c;
          }
        }

        if(oEnrollmentApp.ApplicationExceptionsPay__c != null){
          if(sExceptions != null){
            sExceptions += oEnrollmentApp.ApplicationExceptionsPay__c;
          }else{
            sExceptions = oEnrollmentApp.ApplicationExceptionsPay__c;
          }
        }
    }

    public boolean RenderInputFinFields(){
      boolean bReturn = true;
      if(oEnrollmentApp.ApplicationType__c == 'PAY'){
        bReturn = false;
      }else{
        if(oEnrollmentApp.StatusNumber__c >= 6 && oEnrollmentApp.EnrollmentStatus__c != 'Rejected for Correction'){
          bReturn = false;
        }
      }

      return bReturn;

    }

    public pageReference proposeOptOut(){
      oEnrollmentApp.WizardStatus__c = 'Complete';
      oEnrollmentApp.EnrollmentStatus__c='Opt-Out';
      try{
        update oEnrollmentApp;
        submit();
        return new pageReference('/' + oEnrollmentApp.ID);
      }catch(Exception e){
        System.Debug('Trapping error when opting out: ' + e.getMessage());
      }

      return null;
    }

    public pageReference enableNextButton(){
      disableStep2 = false;
      return null;
    }

    public pageReference stepone(){
      System.Debug(logginglevel.error,'stepOne');
      activeTab='step1';
      stdController.reset();
      oEnrollmentApp = (EnrollmentPlan__c)stdController.getRecord();
      oEnrollmentApp.WizardStatus__c = 'Step 1';
      disableStep2 = false;
      try{
        update oEnrollmentApp;
      }catch(Exception e){
        //Blah
      }


      return null;
    }

    public pageReference steptwo(){
      System.Debug(logginglevel.error,'stepTwo');
      activeTab='step2';
      stdController.reset();
      oEnrollmentApp = (EnrollmentPlan__c)stdController.getRecord();
      oEnrollmentApp.WizardStatus__c = 'Step 2';
      disableStep2 = true;
      try{
        update oEnrollmentApp;
      }catch(Exception e){
        system.debug(logginglevel.error,'Error saving enrollment ap in step 1 ' + e.getMessage() + ' Stack: ' + e.getStackTraceString());
      }
      return null;
    }

    public PageReference stepThree(){
      System.Debug(logginglevel.error,'Step 3');
      oEnrollmentApp = [Select id
                               ,WizardStatus__c
                               ,IncentivePlan__c From EnrollmentPlan__c where id=:oEnrollmentApp.ID][0];
      if(oEnrollmentApp.IncentivePlan__c == null){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'You must choose an Incentive Plan to continue.'));
      }else{
        activeTab='step3';
      
        oEnrollmentApp = (EnrollmentPlan__c)stdController.getRecord();
        oEnrollmentApp.WizardStatus__c = 'Step 3';
        try{
          update oEnrollmentApp;
        }catch(Exception e){
          system.debug(logginglevel.error,'Error saving enrollment ap in step 2 ' + e.getMessage() + ' Stack: ' + e.getStackTraceString());
        }
      }
      return null;
    }

    public PageReference finishWizard(){
      bFinished = false;
      pageReference pr = new pageReference('/apex/INC_EnrollmentApp?id=' + oEnrollmentApp.ID);
      pr.setredirect(true);
      list<EnrollmentParticipant__c> listEnroll = [Select Id, TargetIncentivePoolAllocated__c  from EnrollmentParticipant__c where EnrollmentPlan__c =: oEnrollmentApp.ID];
      boolean bcontinue = true;
      System.Debug(logginglevel.error, ('listEnroll: ' + listEnroll));
      If(listEnroll != null && listEnroll.size() > 0){
        bContinue = false;
        for(EnrollmentParticipant__c ep: listEnroll){
          if(ep.TargetIncentivePoolAllocated__c != null || ep.TargetIncentivePoolAllocated__c > 0){
            bContinue = true;
          }
        }
      }else{
        bContinue = false;
      }
      if(bContinue){
        try{
          oEnrollmentApp.WizardStatus__c = 'Complete';
           bFinished = true;
          update oEnrollmentApp;

        }catch(exception e){
         system.debug(logginglevel.error,'Error saving enrollment ap in step 3 ' + e.getMessage() + ' Stack: ' + e.getStackTraceString());
        }
      }else{
        System.debug(logginglevel.error,'Can not save because no participants');
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'You must enter at least one participant with a Target % greater than 0.'));
      }

      if(bFinished){
        return pr;
      }
      return null;

    }

    public pageReference openCalculator(){
      PageReference ref = new PageReference('/apex/INC_IncentiveCalculator?');
      return ref;
    }
   
    public pageReference save(){
        System.debug(logginglevel.error,'Save in custom controller');
        try{
          stdController.save();
          }catch(Exception e){
              System.Debug(logginglevel.error,'Error saving enrollment app.' + e.getMessage());
          }
        pageReference pf = new pageReference('/apex/INC_EnrollmentApp?id=' + oEnrollmentApp.Id);
        //pf.setredirect(true);
        return pf;
    }


    public PageReference submitFromWizard(){
      
      bSubmitWorked = false;

      oEnrollmentApp = [Select id, AppIicationIssues__c from EnrollmentPlan__c where id=:oEnrollmentApp.ID][0];
      System.Debug(logginglevel.error,'submit: ' + bSubmitWorked);
      if(oEnrollmentApp.AppIicationIssues__c == null || oEnrollmentApp.AppIicationIssues__c == ''){
         System.Debug(logginglevel.error,'Submitting app');
         bSubmitWorked = true;
         PageReference pr = submit();
         pr=finishWizard();
         /*if(pr != null){
             //return pr;
             return null;
         }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'There are still issues with your application.'));
         }*/

         return null;
      }else{
        System.Debug(logginglevel.error,'Submit Failed');
        bSubmitWorked = false;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'There are still issues with your application: <br/> ' + oEnrollmentApp.AppIicationIssues__c));
      }
      
      //pageReference pf = new pageReference('/apex/INC_EnrollmentApp?id=' + oEnrollmentApp.Id);

      //return pf;
      return null;
    }

    public PageReference submit(){

        list<ProcessInstance> existingApprovals = [SELECT Id, TargetObjectId,Status
                                            FROM ProcessInstance 
                                            WHERE TargetObjectId  =:oEnrollmentApp.ID];
        //this is a check in case they click the button twice or the page doesn't refresh.
        System.Debug(logginglevel.error,'existingApprovals: ' + existingApprovals);
        //to allow for resubmit, need to check to see if existing approvals are "Removed"
        Boolean bContinue = true;
        if(existingApprovals != null && existingApprovals.size() > 0){
          bContinue = false;
          for(ProcessInstance pr: existingApprovals){
            if(pr.Status == 'Removed'){
              bContinue = true;
            }
          }
        }
        bSubmitWorked = true;
        if(bContinue){
          Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();  
          req1.setComments('Submitted for Approval');
          req1.setObjectId(oEnrollmentApp.ID);
          req1.setSubmitterID(UserInfo.getUserId());
          try{
              Approval.ProcessResult result = Approval.process(req1); 
              }catch(Exception e){
                  bSubmitWorked = false;
                  System.Debug(logginglevel.error,'Exception from Submit: ' + e.getMessage());
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'All criteria has not be met.'));
              }
        }
          
        //pageReference pf = new pageReference('/apex/INC_EnrollmentApp?id=' + oEnrollmentApp.Id);
        //return pf;   

        return null;
    } 

    public pageReference finalRejectButton(){
      ID workItem = getWorkItemId(oEnrollmentApp.ID);
       Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
       //req.setComments('Please enter a comment.');
       req.setAction('Reject');
       req.setWorkitemId(workItem);
       Approval.ProcessResult result =  Approval.process(req);
       if(!result.isSuccess()){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Error Rejecting Application.'));
       }
       
       System.Debug(logginglevel.error,'finalRejectButton clicked');
       return new pageReference('/apex/INC_EnrollmentApp?id=' + oEnrollmentApp.ID);
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
     /* 
        No longer reject, step will be rejected during normal process
        If(workItem != null){
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
          req.setComments('Final Rejection.');
          req.setAction('Reject');
          //req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
          req.setWorkitemId(workItem);
              // Submit the request for approval
          Approval.ProcessResult result =  Approval.process(req);
          workItem = getWorkItemId(oEnrollmentApp.id);
       
      }*/

      If(workItem != null){
            List<ProcessInstanceWorkitem> workitems = new List<ProcessInstanceWorkitem>([select Id from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId =:oEnrollmentApp.id]);

            list<Approval.ProcessWorkitemRequest> itemsToUpdate = new list<Approval.ProcessWorkitemRequest>();

            for(ProcessInstanceWorkitem w: workitems){
                Approval.ProcessWorkitemRequest PWR = new Approval.ProcessWorkitemRequest();
                PWR.setComments('Recalled due to final Rejection');
                PWR.setAction('Removed');
                PWR.setWorkItemId(w.Id);
                itemsToUpdate.add(PWR);
            }                

            if(itemsToUpdate.size() > 0){
                list<Approval.ProcessResult> results =  Approval.process(itemsToUpdate);
            }
      }


      return new pageReference('/apex/INC_EnrollmentApp?id=' + oEnrollmentApp.id);


    }

    public pageReference closeApplication(){
      EnrollmentPlan__c oEnrollmentAppToUpdate = new EnrollmentPlan__c();

      oEnrollmentAppToUpdate.Id = oEnrollmentApp.Id;
      oEnrollmentAppToUpdate.EnrollmentStatus__c = 'Closed';

      update oEnrollmentAppToUpdate;

      return new pageReference('/apex/INC_EnrollmentApp?id=' + oEnrollmentApp.id);
    }

    public pageReference closeNoAwardApplication(){
      EnrollmentPlan__c oEnrollmentAppToUpdate = new EnrollmentPlan__c();

      oEnrollmentAppToUpdate.Id = oEnrollmentApp.Id;
      oEnrollmentAppToUpdate.EnrollmentStatus__c = 'Closed - No Award';

      update oEnrollmentAppToUpdate;

      return new pageReference('/apex/INC_EnrollmentApp?id=' + oEnrollmentApp.id);
    }

    private Id getWorkItemId(Id targetObjectId)
    {
      Id retVal = null;
      for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
          where p.ProcessInstance.TargetObjectId =: targetObjectId])
      {
          retVal =  workItem.Id;
      }
      return retVal;
    }

    public pageReference saveAndReturnToBudget(){
        EnrollmentPlan__c ep = (EnrollmentPlan__c)stdController.getRecord();
        System.debug(logginglevel.error,'ep.gmnsr value before save: ' + ep.GMofNSRAdjustment__c);
        stdController.save();
        pageReference pr = new pageReference('/apex/INC_EnrollmentApp?id=' + oEnrollmentApp.ID + '&someval=yes');
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
        String sName = INC_Service_EnrollmentPlan.cloneEnrollment(oEnrollmentApp.id,INC_Service_EnrollmentPlan.RequestType.PAYMENT);
          if(sName != null && sName != ''){
            oEnrollmentApp = INC_Service_EnrollmentPlan.getEnrollmentPlan(new set<id>{sName})[0];
            System.Debug(logginglevel.error,'oEnrollmentApp.Id ' + oEnrollmentApp.ID + ' sName:' + sName);
            submit();
            pr = new pageReference('/apex/INC_EnrollmentApp?id='+ sName);
            pr.setredirect(true);
          }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'There was a error creating your payment request.'));
          }
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
    private boolean getLatestRejectionComment(){
        boolean bReturn = false;
        list<Enrollment_Comments__c> lComments = [Select ID
                                                          , Comments__c
                                                          , Type__c
                                                          , Reason_Codes__c
                                                          , Approver__c
                                                          , Approver__r.Name
                                                          , IsRejection__c
                                                 From Enrollment_Comments__c
                                                 Where EnrollmentApplication__c =: oEnrollmentApp.ID
                                                 and (Type__c = 'Rejection' or Type__c ='Rejection for Corrections')
                                                 and (Reason_Codes__c = null)
                                                 Order by CreatedDate];
        //find the latest one, hopefully the query should only return one.  But I have to account for bad data
        System.Debug(logginglevel.error,'lcomments: ' + lComments);
        if(lComments != Null && lComments.size() > 0){
                bReturn = true;
                oEnrollComment = lComments[0];
                sMessage = lComments[0].Approver__r.Name + ' rejected the application.  A rejection code must be selected before any changes to the';
                sMessage += ' application are possible.';
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
     
              if(oEnrollComment.Reason_Codes__c == 'Project in Litigation' ||
                 oEnrollComment.Reason_Codes__c == 'Project is Intercompany - Client is AECOM' ||
                 oEnrollComment.Reason_Codes__c == 'Project on Hold' ||
                 oEnrollComment.Reason_Codes__c == 'Project Nearing Completion' ||
                 oEnrollComment.Reason_Codes__c == 'Poor Project Performance'){
                  
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




















}