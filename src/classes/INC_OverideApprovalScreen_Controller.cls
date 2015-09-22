public with sharing class INC_OverideApprovalScreen_Controller {
/*
	public EnrollmentPlan__c oEnrollmentPlan{get;set;}
  public ProcessInstance currentProcessinstance{get;set;}
  public Enrollment_Comments__c oComments{get;set;}
  public String sRejectReason {get;set;}
  public String sComments{get;set;}
  public boolean canApprove{get;set;}
    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public INC_OverideApprovalScreen_Controller(ApexPages.StandardController stdController) {
        this.oEnrollmentPlan = (EnrollmentPlan__c)stdController.getRecord();
        oEnrollmentPlan = INC_Service_EnrollmentPlan.getEnrollmentPlan(new set<id>{oEnrollmentPlan.ID})[0];
        oComments = new Enrollment_Comments__c(EnrollmentApplication__c = oEnrollmentPlan.ID);
        canApprove = true;
        //create a blank step just as a place holder for comments
        getApprovalInProcess();
        if((currentProcessinstance == null) || (currentProcessinstance.Workitems == null || currentProcessinstance.Workitems.size() == 0)){
            apexpages.addMessage(new apexpages.message(apexpages.severity.error,'Item has no pending steps to approve.'));
            canApprove = false;
        }
    }

    private void getApprovalInProcess(){
        list<ProcessInstance> lProcesses = [Select id
                                           , LastActorID
                                           , Status
                                           , TargetObjectId
                                           , (Select ID
                                                       ,StepStatus
                                                       ,Comments
                                                       ,ActorID
                                                       ,OriginalActorID
                                                       ,StepNodeID
                                              From Steps)
                                           , (Select ID 
                                                       , ActorID
                                                       , ProcessInstanceID
                                              From Workitems)
                                           , (Select ID
                                                       ,NodeStatus
                                              from Nodes)
                                  From ProcessInstance
                                  Where TargetObjectID =: oEnrollmentPlan.ID];
        if(lProcesses != null && lProcesses.size() > 0){
          currentProcessinstance = lProcesses[0];
        }
    }    


    private PageReference createRequest(String sAction){
        pageReference p = new pageReference('/' + oEnrollmentPlan.id);
        p.SetRedirect(true);
        Approval.ProcessWorkitemRequest req1 = new Approval.ProcessWorkitemRequest();
        req1.setComments(sComments);
        req1.setAction(sAction);
        if(currentProcessinstance.WorkItems[0].id != null){
          req1.setWorkItemId(currentProcessinstance.WorkItems[0].id);
          Approval.ProcessResult result = Approval.Process(req1);
          system.Debug(logginglevel.error,'processing request: ' + req1);
          return p;
        }else{
          //some sort of error here.
            system.Debug(logginglevel.error,' Not processing request: ' + req1);
        
        }
        return null;
    }

    public pageReference approve(){
        pageReference pRef =  createRequest('Approve');
        if(pRef != null){
           if(sComments != null && sComments.length() > 0){
              createApprovalComments();
           }
        }

        return pRef;
    }

    public PageReference reject(){
         System.Debug(logginglevel.error,'Rejecting ');
         if(sRejectReason != null && (sComments != null && sComments.length() > 0)){
            return createRequest('Reject');
         }else{
            ApexPages.addMessage(new apexpages.message(apexpages.severity.error,'You must select a reason code and enter a comment to reject.'));
         }

         return null;
    }
    public pageReference cancel(){
       pageReference pRef = new pageReference('/' + oEnrollmentPlan.id);
       pRef.SetRedirect(true);
       return pRef;
    }
    private void createApprovalComments(){
        oComments.Comments__c = sComments;
        oComments.Type__c = 'Approval';
    }
    private void createRejectionComments(){
        oComments.Comments__c = sComments;
        oComments.Type__c = 'Rejection';
    }



    private boolean saveComments(){
      return true;
    }

    public list<SelectOption> getReasonCodes(){
      List<SelectOption> options = new List<SelectOption>();
        
       Schema.DescribeFieldResult fieldResult =
       Enrollment_Comments__c.Reason_Codes__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       options.add(new selectOption('',''));
       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }       
       return options;
    }

  */  
}