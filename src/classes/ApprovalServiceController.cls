public class ApprovalServiceController {
    public class ServiceResponse
    {
        public boolean bSuccess {get; set;}
        public string sErrorMessage {get; set;}
        
        public ServiceResponse(){
            bSuccess = true;
        }
        
        public ServiceResponse(boolean b_Success, string s_ErrorMessage){
            bSuccess = b_Success;
            sErrorMessage = s_ErrorMessage;
        }
    }
    public class DTO_Approval
    {
        public Id sApprovalId {get; set;}
        public string sApprovalName {get; set;}
        public boolean reqApprove = true;
        public boolean reqReject;
        public DTO_Approval(List<ProcessInstanceWorkitem> lprocessWorkItems){
            /*Approval.ProcessWorkitemRequest reqProcess;
            Approval.ProcessResult result; */
            for(ProcessInstanceWorkitem oPWI : lprocessWorkItems){
                if(reqApprove){
                    approve(oPWI.Id);
                }
                else
                    reject(oPWI.Id);
            }

        }
    }
    public static ServiceResponse approve(Id sApprovalProcess){
        Approval.ProcessWorkitemRequest reqProcess = new Approval.ProcessWorkitemRequest();
        Approval.ProcessResult result;
        reqProcess.setAction('Approve');
        reqProcess.setComments('Approved by :'+UserInfo.getName());
        reqProcess.setWorkitemId(sApprovalProcess);
        Approval.ProcessResult apprResult= Approval.Process(reqProcess);
        System.debug('In Approve, sApprovalProcess :'+sApprovalProcess);
        System.debug('In Approve, apprResult :'+apprResult);
        return new ServiceResponse();
    }
    public static ServiceResponse reject(Id sApprovalProcess){
        Boolean status;
        String statusMessage = '';
        Approval.ProcessWorkitemRequest reqProcess = new Approval.ProcessWorkitemRequest();
        Approval.ProcessResult result;
        reqProcess.setAction('Reject');
        reqProcess.setComments('Rejected by :'+UserInfo.getName());
        reqProcess.setWorkitemId(sApprovalProcess);
        System.debug('In Reject, sApprovalProcess :'+sApprovalProcess);
        Approval.ProcessResult rejectResult= Approval.Process(reqProcess);
        System.debug('In Approve, apprResult :'+rejectResult);
        return new ServiceResponse();
    }
    //public static DTO_Approval getPendingApprovals(Id sUserTrackingId){
    public PageReference getPendingApprovals(){
        Id iActorId = UserInfo.getUserId();
        List<ProcessInstance> lprocessInstance2 = new List<ProcessInstance>([SELECT Id, (SELECT Id, ActorId, ProcessInstanceId FROM WorkItems) FROM ProcessInstance Where Status = 'Pending' AND Id in (Select ProcessInstanceId From ProcessInstanceWorkitem Where ActorId = :iActorId)]);
        List<ProcessInstanceWorkitem> lPWI = new List<ProcessInstanceWorkitem>();
        /*List<ProcessInstanceWorkitem> lprocessInstance = new List<ProcessInstanceWorkitem>([SELECT Id, ActorId, ProcessInstanceId FROM ProcessInstanceWorkitem Where ActorId = :iActorId]);
        List<Id> lprocessInstancelist = new List<Id>();
        for(ProcessInstanceWorkitem oPWI : lprocessInstance){
            System.debug('oPWI.ProcessInstanceId   :  '+ oPWI.ProcessInstanceId);
            lprocessInstancelist.add(oPWI.ProcessInstanceId);
        }*/
        System.debug('lprocessInstance2.siz:  '+lprocessInstance2.size()+'   ActorId: '+ iActorId);
        
        for(ProcessInstance oPI : lprocessInstance2){
            for(ProcessInstanceWorkitem oPWI : oPI.WorkItems){
                System.debug('oPWI.id  '+oPWI.Id);
                lPWI.add(oPWI);
            }
        }
        new DTO_Approval(lPWI);
        return null;
    }
}