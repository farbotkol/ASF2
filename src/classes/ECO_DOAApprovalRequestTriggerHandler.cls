public class ECO_DOAApprovalRequestTriggerHandler {

	private static void handleDOAApprovalStampingHelper(string approverCount, string approvedCount, DOAApprovalRequest__c DOAR, Schema.FieldSet fs){

        integer iApproverCount = 0;
        integer iApprovedCount = 0;

        for (Schema.FieldSetMember fsmField: fs.getFields()) {

            string checkbox = fsmField.getFieldPath();
            string fieldLabel = fsmField.getLabel();
            string approver = checkbox.replace('CheckApp__c', 'Approver__c');
            string approvedby = checkbox.replace('CheckApp__c', 'ApprovedBy__c');
            string approvedbyDate = checkbox.replace('CheckApp__c', 'TimeApp__c');


            if(DOAR.get(checkbox) == true && DOAR.get(approver) == null){
            	DOAR.adderror('Trying to set ' + fieldLabel + ' without a specified approver');
            	return;
            }

            if(DOAR.get(checkbox) == true && DOAR.get(approvedby) == null){
            	DOAR.put(approvedby, UserInfo.getName());
            	DOAR.put(approvedbyDate, datetime.now());
            }


        	if(DOAR.get(checkbox) == true){
        		iApprovedCount++;
        	}

        	if(DOAR.get(approver) != null){
        		iApproverCount++;
        	}


        }

        DOAR.put(approverCount, iApproverCount);
        DOAR.put(approvedCount, iApprovedCount);        

	}

	public static void handleDOAApprovalStamping(list<DOAApprovalRequest__c> approvalRequests){

		for(DOAApprovalRequest__c DOAR: approvalRequests){

			handleDOAApprovalStampingHelper('AECOMHubCountofApprovers__c', 'AECOMHubCountofApproved__c', DOAR, SObjectType.DOAApprovalRequest__c.FieldSets.EcoAECOMHubDoAapprovalCheck);
			handleDOAApprovalStampingHelper('DCSHubCountofApprovers__c', 'DCSHubCountOfApproved__c', DOAR, SObjectType.DOAApprovalRequest__c.FieldSets.EcoDCSHubDoAapprovalCheck);
			handleDOAApprovalStampingHelper('EnterpriseCountofApprovers__c', 'EnterpriseCountofApproved__c', DOAR, SObjectType.DOAApprovalRequest__c.FieldSets.EcoEnterpriseDoAapprovalCheck);
			handleDOAApprovalStampingHelper('GeoCountOfApprovers__c', 'GeoCountofApproved__c', DOAR, SObjectType.DOAApprovalRequest__c.FieldSets.EcoGeoDoAapprovalCheck);
			handleDOAApprovalStampingHelper('GroupCountofApprovers__c', 'GroupCountofApproved__c', DOAR, SObjectType.DOAApprovalRequest__c.FieldSets.EcoGroupDoAApprovalCheck);
    	}
	}



	public static void handleDOAApprovalRequestChange(list<DOAApprovalRequest__c> approvalRequests)
	{
		list<Id> projectIds = new list<Id>();
		for(DOAApprovalRequest__c approvalRequest:approvalRequests)
		{
			if(approvalRequest.Project__c != null)	
				projectIds.add(approvalRequest.Project__c);
		}
						
		set<Id> projectsWithUnapprovedRequests = new set<Id>();
		for(DOAApprovalRequest__c request:[select Id, Project__c from DOAApprovalRequest__c 
										   where Project__c in :projectIds 
										   and ApprovalStatus__c != 'Approved'])
		{
			projectsWithUnapprovedRequests.add(request.Project__c);	
		}
		
		list<pse__Proj__c> updatedProjects = new list<pse__Proj__c>();
		for(pse__Proj__c project:[select Id, Name, DOAUnapprovedRequestsExist__c from pse__Proj__c where Id in :projectIds])
		{
			if(projectsWithUnapprovedRequests.contains(project.Id) && project.DOAUnapprovedRequestsExist__c == false)
			{
				project.DOAUnapprovedRequestsExist__c = true;
				updatedProjects.add(project);			
			}
			else if(!projectsWithUnapprovedRequests.contains(project.Id) && project.DOAUnapprovedRequestsExist__c == true)
			{
				project.DOAUnapprovedRequestsExist__c = false;
				updatedProjects.add(project);				
			}
		}
		
		if(updatedProjects.size() > 0)
			update updatedProjects;
	}

}