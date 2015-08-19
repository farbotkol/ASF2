public with sharing virtual class ECO_ProjectReviewsController 
{
	protected pse__Proj__c theProject { get; set; }
	public ApexPages.StandardController oStandardController {get; set;}
	public ProjectReview__c oProjectReview {get; set;}
	public List<ECO_Utils_Activities.Attendee> lAttendees {get; set;}
	public List<EventRelation> lInvitees {get; set;}
	public List<AgendaItem__c> lAgendaItems {get; set;}
	public List<AgendaItem__c> lDelete_AgendaItems {get; set;}
	public List<Event> lEvents {get; set;}
	public List<SelectOption> lRTOptions {get; set;}
	public String recordObjectType {get; set;}
	public String recordObjectId {get; set;}
	public Boolean showScheduleButton {get; set;}
	public Boolean showKPIs {get; set;}
	public Boolean perfActiveStatus {get; set;}
	public Boolean isPerfReview {get; set;}
	public Boolean isProjectPerfReview {get; set;}
	public Boolean showOtherSections {get; set;}
	public Map<Id,RecordType> mRecordTypes {get; set;}
	public List<KPI_Result__c> lKPI_Results {get; set;}
	public list<DOAConditions__c> lstDOAConditions {get; set;}
	public list<Task> reviewTasks {get; set;}

	public ECO_ProjectReviewsController(ApexPages.StandardController oStandardController) 
	{
		this.oStandardController = oStandardController;
		list<string> lFields = new list<string>();
        lFields.add('Project__c');
        lFields.add('EventID__c');
        lFields.add('ProjectReviewTemplate__c');
        oStandardController.addFields(lFields);
        lstDOAConditions = new list<DOAConditions__c>();
		isProjectPerfReview = false;
		oProjectReview = (ProjectReview__c)oStandardController.getRecord();

		if(ECO_Utils_String.NullCheck(oProjectReview.Project__c) == '')
		{
			oProjectReview.Project__c = ApexPages.currentPage().getParameters().get('ProjectId');
		}

        if(ECO_Utils_String.NullCheck(oProjectReview.RecordTypeId) == '')
        {
            oProjectReview.RecordTypeId = ApexPages.currentPage().getParameters().get('RecordTypeId');
        }
        
		if(ECO_Utils_String.NullCheck(oProjectReview.Project__c) == '')
		{
			ApexPages.Message oPageMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'You have reached this page improperly, please access it from the Project screen.');
            ApexPages.addMessage(oPageMessage);
            return;
		}

		mRecordTypes = new Map<Id,RecordType>([Select Id, Name From RecordType Where Id = :oProjectReview.RecordTypeId]);
		
		if(ECO_Utils_String.NullCheck(oProjectReview.Name) == '')
		{
			if(mRecordTypes.get(oProjectReview.RecordTypeId).Name == 'Project Performance Review' || mRecordTypes.get(oProjectReview.RecordTypeId).Name == 'Monthly Project Review')
			{	
				DateTime dt = DateTime.now();
				String month = dt.format('MMMMM');
				oProjectReview.Name = month + ' ' + mRecordTypes.get(oProjectReview.RecordTypeId).Name;	
			}
			else {
				oProjectReview.Name = mRecordTypes.get(oProjectReview.RecordTypeId).Name + ' ' + 'Review';
			}
		} 		

		if(ECO_Utils_String.NullCheck(oProjectReview.ProjectReviewTemplate__c) == '')
		{
			List<ProjectReviewTemplate__c> lPRT = new List<ProjectReviewTemplate__c>([Select Id From ProjectReviewTemplate__c Where TemplateType__c = :mRecordTypes.get(oProjectReview.RecordTypeId).Name Limit 1]);
			if(!lPRT.isEmpty())
			{
				oProjectReview.ProjectReviewTemplate__c = lPRT[0].Id;
			}
		}

		isPerfReview = false;

		getTheProject();

		showScheduleButton = true;
		perfActiveStatus = false;
		showOtherSections = false;
		lAttendees = new List<ECO_Utils_Activities.Attendee>();
		lKPI_Results = new List<KPI_Result__c>();
		
		if(oProjectReview.EventID__c != null)
		{
			lEvents = new List<Event>([Select Id From Event Where Id = :oProjectReview.EventID__c Limit 1]);
			if(!lEvents.isEmpty())
			{
				showScheduleButton = false;
			}
			else
			{
				oProjectReview.EventID__c = null;
			}
			fetchInviteesAndAttendees();
		}
		


		if(oProjectReview.Status__c == null)
		{
			oProjectReview.Status__c = 'Not Started';
		}
		if(oProjectReview.Status__c != 'Not Started')
		{
			perfActiveStatus = true;
		}

		if(mRecordTypes.get(oProjectReview.RecordTypeId).Name == 'Project Performance Review' || mRecordTypes.get(oProjectReview.RecordTypeId).Name == 'Monthly Project Review') {
			showKPIs = true;
		} else {
			showKPIs = false;
		}
		loadConditions();	
		
		
			
	}
	
	public void init()
	{
		if(mRecordTypes.get(oProjectReview.RecordTypeId).Name != 'Project Performance Review' && mRecordTypes.get(oProjectReview.RecordTypeId).Name != 'Monthly Project Review')
		{
			oProjectReview.Status__c = 'Assessing';
		}
				
		if(ApexPages.currentPage().getParameters().get('ProjectId') != null)
			insert oProjectReview;

		
		if(mRecordTypes.get(oProjectReview.RecordTypeId).Name == 'Project Performance Review' || mRecordTypes.get(oProjectReview.RecordTypeId).Name == 'Monthly Project Review')
		{
			PerformHealthCheck();
			isPerfReview = true;
			if(mRecordTypes.get(oProjectReview.RecordTypeId).Name == 'Project Performance Review')
				isProjectPerfReview = true;
		}		
		
		if(isPerfReview && perfActiveStatus)
		{
			showOtherSections = true;
		}
		else if(!isPerfReview)
		{		
			showOtherSections = true;
		}		
		
		ECO_Utils_Meta.SelectAll soUtil = new ECO_Utils_Meta.SelectAll();
		soUtil.GetFields('ProjectReview__c');
		String queryString = soUtil.SOQL;
		queryString = querystring.replace('FROM ProjectReview__c', ', ProjectReviewTemplate__r.Purpose__c, RecordType.Name FROM ProjectReview__c');
		queryString += ' WHERE Id = \''+ oProjectReview.Id +'\'';
		
		list<ProjectReview__c> projectReviews = Database.query(queryString);
		oProjectReview = projectReviews[0];
		
		reviewTasks = [select Id, Subject,  ActivityDate, OwnerId from Task where whatId = :oProjectReview.Id];
	
		fetchAgendaItems();
		
		lDelete_AgendaItems = new List<AgendaItem__c>();	
	}

	private void loadConditions(){

		//if(setRequestIds.size() >0){
	        string strSOQL = 'SELECT ';
	        string projectID = oProjectReview.Project__c;
	            
	        for (Schema.FieldSetMember fsmField: SObjectType.DOAConditions__c.FieldSets.DOA_ApprovalView.getFields()) {
	            strSOQL += fsmField.getFieldPath() + ', ';
	        }
	        
	        strSOQL += 'ID FROM DOAConditions__c WHERE Project__c =: projectID';

	        lstDOAConditions = (list<DOAConditions__c>)Database.query(strSOQL);
    	//}
	}

			
	public List<Schema.FieldSetMember> getCustomProjSetupFields()
	{
		return SObjectType.pse__Proj__c.FieldSets.pse_ProjectFieldsforCustomProjectSetup.getFields();
	}
	
	public void PerformHealthCheck()
	{
		lKPI_Results = [Select Id, Trigger_Name__c, Evaluation_Result__c, Alert_Message__c, Explanation__c From KPI_Result__c Where Project_Review__c = :oProjectReview.Id Order By Evaluation_Result__c DESC];
		if(lKPI_Results.isEmpty())
		{
			System.debug('PerformHealthCheck, ProjectID: ' + oProjectReview.Project__c);
			List<ECO_HealthCheckEvaluator.Response> lResponses = new List<ECO_HealthCheckEvaluator.Response>(ECO_HealthCheckEvaluator.EvaluateProject(oProjectReview.Project__c));
			for(ECO_HealthCheckEvaluator.Response resp : lResponses)
			{
				System.debug('Message: ' + resp.message);
				KPI_Result__c oKPI = new KPI_Result__c();
				oKPI.Trigger_Name__c = resp.triggerName;
				oKPI.Project_Review__c = oProjectReview.Id;
				oKPI.Evaluation_Result__c = resp.evalResult;
				oKPI.Alert_Message__c = resp.message;
				lKPI_Results.add(oKPI);
			}
		}
	}

	public PageReference SaveHealthCheck()
	{
		//oProjectReview.Project__c = theProject.Id;
		oProjectReview.Status__c = 'Assessing';
		oProjectReview.Snapshot_Date__c = Date.today();
		
		update oProjectReview;
		
		upsert lKPI_Results;
		SaveAll();		
		
		ECO_Service_ProjectSnapshots projectSnapshotService = new ECO_Service_ProjectSnapshots(theProject.Id);
		ProjectSnapshot__c projectSnapshot = projectSnapshotService.getProjectSnapshot();
		projectSnapshot.ProjectReview__c = oProjectReview.Id;
		insert projectSnapshot;
		upsert lKPI_Results;
		//return SaveAll();
		
		showOtherSections = true;
		
		return null;
	}

	public Pagereference newTask(){
 
    	PageReference pageRef = new PageReference('/00T/e?what_id=' + oProjectReview.Id + '&retURL=' + oProjectReview.Id);

    	pageRef.setRedirect(True);

    	return PageRef;

    }

	public pse__Proj__c getTheProject()
	{
		if(theProject == null)
		{
			String query = 'SELECT Id, ProjectNumber__c, CarryingOutOrganization__c, CarryingOutOrganization__r.Region__c, pse__Project_Manager__c, NetServicesRevenue__c, ProjectOwningOrg__c, TotalMargin__c, PrimaryEndClient__c, TotalBidBudget__c, PrimaryBillingClient__c';
			for(Schema.FieldSetMember f : getCustomProjSetupFields()) 
			{
	            query += ', ' + f.getFieldPath();
	        }
	        query += ' FROM pse__Proj__c WHERE Id = \'' + oProjectReview.Project__c + '\' Limit 1';
	        theProject = Database.query(query);
		}
		return theProject;
	}
	
	public void fetchAgendaItems()
	{
		lAgendaItems = new List<AgendaItem__c>([Select Id, Name, Agenda_Num__c, ProjectReview__c, Comments__c From AgendaItem__c Where ProjectReview__c = :oProjectReview.Id Order By Agenda_Num__c]);
		List<AgendaItemTemplate__c>  lAgendaItemTemplates;

		if(lAgendaItems.isEmpty() && isProjectPerfReview)
		{
			lAgendaItemTemplates = new List<AgendaItemTemplate__c>([Select Id, Name, Section__c, SortOrder__c, Description__c From AgendaItemTemplate__c Where ProjectReviewTemplate__r.TemplateType__c = :mRecordTypes.get(oProjectReview.RecordTypeId).Name]);
			Integer iAgendaNum = 1;

			if(!lAgendaItemTemplates.isEmpty())
			{
				for(AgendaItemTemplate__c ait : lAgendaItemTemplates)
				{
					lAgendaItems.add(new AgendaItem__c(Agenda_Num__c = iAgendaNum, Name = ait.Name, Section__c = ait.Section__c, SortOrder__c = ait.SortOrder__c, Description__c = ait.Description__c, ProjectReview__c = oProjectReview.Id, AgendaItemTemplate__c = ait.Id));
					iAgendaNum++;					
				}			
			}
			if(lAgendaItems.isEmpty())
			{
				lAgendaItems.add(new AgendaItem__c(ProjectReview__c = oProjectReview.Id));
			}
		}
		
		else if((oProjectReview.MeetingMinutes__c == null || oProjectReview.MeetingMinutes__c == '') && !isProjectPerfReview)
		{
			lAgendaItemTemplates = new List<AgendaItemTemplate__c>([Select Id, Name, Section__c, SortOrder__c, Description__c From AgendaItemTemplate__c Where ProjectReviewTemplate__r.TemplateType__c = :mRecordTypes.get(oProjectReview.RecordTypeId).Name]);
			Integer iAgendaNum = 1;

			if(!lAgendaItemTemplates.isEmpty())
			{
				String meetingMinutesAgendateItems = '<html><b>Agenda Items</b>'; 
				for(AgendaItemTemplate__c ait : lAgendaItemTemplates)
				{
					meetingMinutesAgendateItems += '<li>' + ait.Name + '</li>';
				}
				meetingMinutesAgendateItems += '</ul></html>';
				oProjectReview.MeetingMinutes__c = meetingMinutesAgendateItems;				
			}
		}
	}

	public void fetchInviteesAndAttendees()
	{
		lInvitees = ECO_Utils_Activities.getInvitees(oProjectReview.EventID__c);
		lAttendees = ECO_Utils_Activities.getAttendees(lInvitees);
	}
	
	public void addRecord()
	{
		if(recordObjectType == 'AgendaItem__c')
		{
			lAgendaItems.add(new AgendaItem__c(ProjectReview__c = oProjectReview.Id));
		}
	}
	
	public void removeRecord()
	{
		if(recordObjectType == 'AgendaItem__c')
		{
			for(Integer i=0; i<lAgendaItems.size(); i++)
			{
				if(lAgendaItems[i].Id == recordObjectId)
					lDelete_AgendaItems.add(lAgendaItems.remove(i));
			}
		}
	}
	
	public PageReference SaveAll()
	{
//		for(Integer i=0; i<lAgendaItems.size(); i++)
//		{
//			if(lAgendaItems[i].Name == null)
//				lAgendaItems.remove(i);
//		}
		PageReference oPR;
		try
		{
			update oProjectReview;
			//oPR = oStandardController.save();
//			upsert lAgendaItems;
			
//			if(!lDelete_AgendaItems.isEmpty())
//				delete lDelete_AgendaItems;

			if(!lKPI_Results.isEmpty())
				update lKPI_Results;
		}
		catch(DMLException e)
		{
			System.debug('Error: ' + e.getMessage());
		}
		//oPR.setRedirect(true);
		return null;
	}
	
	public PageReference ReturnToProjectFromReview()
	{
		PageReference oPR = new PageReference('/' + theProject.Id);
		//oPR.setRedirect(true);
		return oPR;
	}
	
	public PageReference ScheduleMeeting()
	{
		update oProjectReview;
		if(oProjectReview.ScheduledDate__c != null)
		{
			Event evt;
			Id eventRecordTypeId = ECO_Utils_Meta.getRecordTypeId(Event.sObjectType, 'Eco Project Event');

			if(oProjectReview.EventID__c == null)
			{
				evt = new Event();
				evt.WhatId = oProjectReview.Id;
				evt.StartDateTime = oProjectReview.ScheduledDate__c;
				evt.Subject = oProjectReview.Name + ' - ' + theProject.Name;
				evt.DurationInMinutes = 60;
				evt.RecordTypeId = eventRecordTypeId;
				insert evt;
				oProjectReview.EventID__c = evt.Id;
				update oProjectReview;				
			}
		}
		else
		{
			ApexPages.Message oPageMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Please specify the Scheduled Date before scheduling a meeting.');
            ApexPages.addMessage(oPageMessage);
            return null;
		}
		return ManageEvent();
	}
	
	public PageReference ManageEvent()
	{
		PageReference oPR;
		if(oProjectReview.EventID__c != null)
		{
			//oPR = new PageReference('/' + oProjectReview.EventID__c + '/e?retURL=' + EncodingUtil.urlEncode(ApexPages.currentPage().getURL(), 'UTF-8'));
			oPR = new PageReference('/' + oProjectReview.EventID__c + '/e');
			oPR.getParameters().put('retURL', '/' + oProjectReview.Id);
			oPR.getParameters().put('saveURL', '/' + oProjectReview.Id);			
			oPR.setRedirect(true);
		}
		return oPR;
	}
	
	public PageReference CreateCalendarInvite()
	{
		PageReference oPR;
		if(oProjectReview.EventID__c != null)
		{
			oPR = new PageReference('/servlet/servlet.OutlookEvent?id=' + oProjectReview.EventID__c);
			oPR.setRedirect(true);
		}
		return oPR;
	}
	
	public String getProjectSnapshotRecord()
	{
		list<ProjectSnapshot__c> projectSnapshotRecords = [select Id from ProjectSnapshot__c where Project__c = :theProject.Id  order by Id desc limit 1];
		
		if(projectSnapshotRecords.size() > 0)
			return projectSnapshotRecords[0].Id;
		return '';
	}	
	
	public PageReference printProjectReviews () {
    	PageReference oPageReference = Page.ECO_ProjectReviewsPdf;
		oPageReference.getParameters().put('Id', oProjectReview.Id);
    	oPageReference.setRedirect(true);
    	return oPageReference;
    }  
}