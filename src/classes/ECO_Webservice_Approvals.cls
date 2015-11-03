global with sharing class ECO_Webservice_Approvals {
    global class ServiceResponse
    {
        webservice boolean bSuccess {get; set;}
        webservice string sErrorMessage {get; set;}
        
        public ServiceResponse(){
            bSuccess = true;
        }
        
        public ServiceResponse(boolean b_Success, string s_ErrorMessage){
            bSuccess = b_Success;
            sErrorMessage = s_ErrorMessage;
        }
    }
    //Ask Michael how to set a record to reject or approve
    global class DTO_Approval
    {
        webservice Id sApprovalId {get; set;}
        webservice string sApprovalName {get; set;}

        public DTO_Approval(ProcessInstanceWorkitem oProcessWorkItem){
            
            sApprovalId = oProcessWorkItem.Id;
            /*Approval.ProcessWorkitemRequest reqProcess;
            Approval.ProcessResult result; 
            for(ProcessInstanceWorkitem oPWI : lprocessWorkItems){
                if(reqApprove){
                    approve(oPWI.Id);
                }
                else
                    reject(oPWI.Id);
            }*/
        }
    }
    
    //Approve a given approval process based upon the supplied ID
    //NOTE: You may need additional identifiers to do this, I am assuming you just need an approval id
    webService static ServiceResponse approve(Id sApprovalProcess){
        try{
            Approval.ProcessWorkitemRequest reqProcess = new Approval.ProcessWorkitemRequest();
            reqProcess.setAction('Approve');
            reqProcess.setComments('Approved by :'+UserInfo.getName());
            reqProcess.setWorkitemId(sApprovalProcess);
            Approval.ProcessResult apprResult= Approval.Process(reqProcess);
            return new ServiceResponse();
        }catch(DMLException e){
            System.debug('Exception occured in approve:  '+e.getMessage());
            return null;
        }
        
    }
    
    //Reject a given approval process based upon the supplied ID
    //NOTE: You may need additional identifiers to do this, I am assuming you just need an approval id
    webService static ServiceResponse reject(Id sApprovalProcess){
        try{
            Approval.ProcessWorkitemRequest reqProcess = new Approval.ProcessWorkitemRequest();
            Approval.ProcessResult result;
            reqProcess.setAction('Reject');
            reqProcess.setComments('Rejected by :'+UserInfo.getName());
            reqProcess.setWorkitemId(sApprovalProcess);
            Approval.ProcessResult rejectResult= Approval.Process(reqProcess);
            return new ServiceResponse();
        }catch(DMLException e){
            System.debug('Exception occured in reject:  '+e.getMessage());
            return null;
        }
        
    }
    
    //Return a list of pending Salesforce Approvals based on User Tracking Id
    //Create Service Method to get pending approvals
    webService static list<DTO_Approval> getPendingApprovals(){
        Id iActorId = UserInfo.getUserId();
        List<ProcessInstance> lprocessInstance2 = new List<ProcessInstance>([SELECT Id, (SELECT Id, ActorId, ProcessInstanceId FROM WorkItems) FROM ProcessInstance Where Status = 'Pending' AND Id in (Select ProcessInstanceId From ProcessInstanceWorkitem Where ActorId = :iActorId)]);
        //List<ProcessInstanceWorkitem> lPWI = new List<ProcessInstanceWorkitem>();
        /*List<ProcessInstanceWorkitem> lprocessInstance = new List<ProcessInstanceWorkitem>([SELECT Id, ActorId, ProcessInstanceId FROM ProcessInstanceWorkitem Where ActorId = :iActorId]);
        List<Id> lprocessInstancelist = new List<Id>();
        for(ProcessInstanceWorkitem oPWI : lprocessInstance){
            System.debug('oPWI.ProcessInstanceId   :  '+ oPWI.ProcessInstanceId);
            lprocessInstancelist.add(oPWI.ProcessInstanceId);
        }
        System.debug('lprocessInstance.siz:  '+lprocessInstance.size()+ '  lprocessInstancelist.size:  '+lprocessInstancelist.size());*/
        list<DTO_Approval> lApprovalsToReturn = new list<DTO_Approval>();
        
        for(ProcessInstance oPI : lprocessInstance2){
            for(ProcessInstanceWorkitem oPWI : oPI.WorkItems){
                //lPWI.add(oPWI);
                lApprovalsToReturn.add(new DTO_Approval(oPWI));
            }
        }

        return lApprovalsToReturn;
    }
   
}