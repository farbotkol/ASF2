public with sharing class INC_ApprovalDetailComponentController {
	
	private ProcessInstance oProcessInstance;
	public list<DisplayRow> listRows {get;set;}
	
	public String relatedRecordId;
    public String getRelatedRecordID(){ return relatedRecordId; }
    
    public void setRelatedRecordID(ID s){
        relatedRecordId = s;
        INC_ApprovalDetailComponentController();
    }

	public void INC_ApprovalDetailComponentController() {
		System.Debug(logginglevel.error,'relatedRecordId ' + relatedRecordID);
		list<ApprovalStep> steps = getAllApprovalStep();
		buildDisplayRows(steps);
		System.Debug(logginglevel.error,'steps ' + steps);
	}

	public list<DisplayRow> getRows(){
		return listRows;
	}
	//===========================================================//

	//Main method called by the controller

	//==========================================================//

	public List<ApprovalStep> getAllApprovalStep() {

		List<ApprovalStep> lstApprovalStep = new List<ApprovalStep>();

		 

		ProcessInstance processInstance = getProcessInstance();

		Map<Id,ProcessNode> mpProcessNode = getProcessNode(processInstance);

		 

		if(processInstance == null) return lstApprovalStep;

		for(ProcessInstanceWorkItem wk: ProcessInstance.WorkItems){
			lstApprovalStep.add(new approvalStep(wk,ProcessInstance));
			system.debug(logginglevel.error,'workitem.name ' + wk.OriginalActor.Name);
		}
	 

		for(ProcessInstanceStep stepInstance : processInstance.Steps){

		ApprovalStep approvalStep = new ApprovalStep(stepInstance,mpProcessNode.get(stepInstance.StepNodeID));

		lstApprovalStep.add(approvalStep);

		}

		System.Debug(logginglevel.error,'ProcessInstance.name: ' + processInstance.LastActor.Name);
		return lstApprovalStep;

	}

	public void buildDisplayRows(list<ApprovalStep> lSteps){
		listRows = new list<DisplayRow>();
		for(ApprovalStep appStep: lSteps){
			System.Debug(logginglevel.error,'Appstep: ' + appStep);
			DisplayRow DR = new DisplayRow();
			if(appStep.instanceStep == null){
				//if Node step is null then this is the active pending step
				//first create the header row
				DR.sCol1App = 'Step: ' + appStep.ListProcessInstanceNode[0].ProcessNodeName;
				DR.sCol1ApproveUrl = '';
				DR.sCol1ReassingUrl = '';
				DR.sRowClass = 'tertiaryPalette extraRow dataRow even first';
				DR.sCol7 = 'Pending';
				DR.HeaderRow = true;
				listRows.add(DR);
				DR = new DisplayRow();
				System.Debug(logginglevel.error,'Instance: ' + appStep.oProcessInstance.WorkItems[0]);
				DR.scol1Res = 'Reassign';
				DR.sCol1App = ' | Approve / Reject'; //
				DR.scol2 = appStep.oProcessInstance.WorkItems[0].CreatedDate.Format();
				DR.scol3 = 'Pending';
				DR.scol4 = appStep.oProcessInstance.WorkItems[0].OriginalActor.Name;
				DR.scol4ID = appStep.oProcessInstance.WorkItems[0].OriginalActorID;
				DR.scol5 = appStep.oProcessInstance.WorkItems[0].OriginalActor.Name;
				DR.scol5ID = appStep.oProcessInstance.WorkItems[0].OriginalActorID;
				DR.sCol6 = '';
				DR.sCol7 = '';
				DR.sCol1ApproveUrl += relatedRecordId;
				DR.sCol1ReassingUrl = '/' + appStep.oProcessInstance.WorkItems[0].id;
				DR.sCol1ReassingUrl += '/e?et=REASSIGN&retURL=/' + relatedRecordId;
			}else{
				if(appStep.nodeStep == null){
					DR.sCol1App = 'Approval Request Submitted'; 
					DR.sCol7 = '';
				}else{
					DR.sCol1App = 'Step: ' + appStep.nodeStep.Name;
					DR.sCol7 = appStep.instanceStep.StepStatus;
				}
				DR.sCol1ApproveUrl = '';
				DR.sCol1ReassingUrl = '';
				DR.HeaderRow = true;
				DR.sRowClass = 'tertiaryPalette extraRow dataRow even first';
				listRows.add(DR);

				DR = new DisplayRow();
				DR.sCol2 = appStep.instanceStep.CreatedDate.format();
				if(Appstep.instanceStep.StepStatus == 'Started'){
					DR.sCol3 = 'Submitted';
				}else{
					DR.sCol3 = appStep.instanceStep.StepStatus;
				}
				DR.sCol4 = appStep.instanceStep.OriginalActor.Name;
				DR.sCol4ID = appStep.instanceStep.OriginalActorID;
				DR.sCol5 = appStep.instanceStep.Actor.Name;
				DR.sCol5ID = appStep.instanceStep.ActorId;
				DR.sCol6 = appStep.instanceStep.Comments;
				DR.sCol7 = '';
			}
			listRows.add(DR);
		}
	}

	//=====================================================================

	//get All Process Nodes attached to Process Instance

	//==================================================================//

	public Map<Id,ProcessNode> getProcessNode(ProcessInstance processInstance){

		if(processInstance == null) return null;

		 

		return new Map<Id,ProcessNode>([SELECT Id,Name FROM ProcessNode

		WHERE ProcessDefinitionId = :processInstance.ProcessDefinitionId]);

	}

	 

	//======================================================================

	//Get the Process Instance Attached to the Record    
	//======================================================================

	private ProcessInstance getProcessInstance(){

		List<ProcessInstance> lstProcessInstance = [SELECT Id, ProcessDefinitionID, Status,LastActor.Name,

		(Select StepStatus,StepNodeId, OriginalActorID ,OriginalActor.Name,ActorId, Actor.Name, Comments,

		CreatedDate, CreatedById,CreatedBy.Name FROM Steps ORDER BY CreatedDate DESC),
		
		(Select ID, OriginalActorID,OriginalActor.Name, ProcessInstanceID, CreatedDate from WorkItems)

		FROM ProcessInstance

		WHERE TargetObjectId = :relatedRecordId];

		if(lstProcessInstance.size() == 0) {

		return null;

		}

		return lstProcessInstance[0];

	}

	 
	public class DisplayRow{
		public String sCol1ReassingUrl {get;set;}
		public String sCol1ApproveUrl {get;set;}
		public String sCol1Res {get;set;}
		public String sCol1App {get;set;}
		public String sCol2 {get;set;}
		public String sCol3 {get;set;}
		public String sCol4 {get;set;}
		public String sCol4ID {get;set;}
		public String sCol5 {get;set;}
		public String sCol5ID {get;set;}
		public String sCol6 {get;set;}
		public String sCol7 {get;set;}
		public String sRowClass{get;set;}
		public boolean HeaderRow{get;set;}
		public DisplayRow(){
			HeaderRow=false;
			sCol1ApproveUrl = '/apex/INC_EnrollmentApprovalOveride?id=';
			sCol1ReassingUrl = '';
			sRowClass = 'dataRow even first';
		}
	}
	 

	 

	//======================================================================

	//Inner Class : Approval Process Step that holds the Step Notes and Approver Comments and Details

	//===================================================================//

	public class ApprovalStep {

		public ProcessInstanceStep instanceStep {get;set;}

		public ProcessNode nodeStep {get;set;}

		public ProcessInstanceWorkItem workItem {get;set;}

	 	public ProcessInstance oProcessInstance {get;set;}

	 	public list<ProcessInstanceNode> ListProcessInstanceNode{get;set;}

		public ApprovalStep(ProcessInstanceStep instanceStep,ProcessNode node){

			this.instanceStep = instanceStep;

			this.nodeStep = node;

		}

		public ApprovalStep(ProcessInstanceWorkItem item, ProcessInstance instance){
			this.workItem = item;
			this.oProcessInstance = instance;
			this.ListProcessInstanceNode = [Select ID
													 ,ProcessNodeName
													 ,NodeStatus
													 ,CompletedDate
											From ProcessInstanceNode 
											where ProcessInstanceID = : instance.id
											and NodeStatus = 'Pending'];
		}

	}



	
}