public with sharing class ECO_DOA_ApprovalRequestController {

	public list<DOA_TriggerWrapper> lstDOATriggers {get; set;}
	public list<DOAApprovalRequest__c> lstDOARequests {get; set;}
	public set<id> setRequestIds {get;set;}
	public list<DOAConditions__c> lstDOAConditions {get; set;}


	public string questionOne {get;set;}
	public string questionTwo {get;set;}
	public string questionThree {get;set;}

	public list<SelectOption> types { get; set; }

	public DOARegister__c newTrigger {get;set;}

	public id projectID {get;set;}
	public pse__Proj__c theProject {get; set;}

	public ECO_DOA_ApprovalRequestController() {
		lstDOATriggers = new list<DOA_TriggerWrapper>();
		lstDOARequests = new list<DOAApprovalRequest__c>();
		lstDOAConditions = new list<DOAConditions__c>();
		setRequestIds = new set<id>();

		String projID = ApexPages.currentPage().getParameters().get('projectID');
        if (projID != null) {
            this.projectID = projID;
            theProject = [select Id, Name from pse__Proj__c where Id = :projID];

            loadTriggers();
            loadApprovalRequest();
            loadConditions();
        }

        types = new List<SelectOption>();
        types.add(new SelectOption('No', 'No'));
        types.add(new SelectOption('Yes', 'Yes'));        

        newTrigger = new DOARegister__c();

	}

	private void loadTriggers(){

        string strSOQL = 'SELECT ';
            
        for (Schema.FieldSetMember fsmField: SObjectType.DOARegister__c.FieldSets.DOA_TriggerView.getFields()) {
            strSOQL += fsmField.getFieldPath() + ', ';
        }
        
        strSOQL += 'ID, DOAApprovalRequest__c FROM DOARegister__c WHERE Project__c = \'' + projectID + '\' order by DOAApprovalRequest__c ASC';

        list<DOARegister__c> lstRiskSearch = (list<DOARegister__c>)Database.query(strSOQL);

        for(DOARegister__c DOAR: lstRiskSearch){
        	lstDOATriggers.add(new DOA_TriggerWrapper(DOAR));
        }
	}

	private void loadApprovalRequest(){

        string strSOQL = 'SELECT ';
            
        for (Schema.FieldSetMember fsmField: SObjectType.DOAApprovalRequest__c.FieldSets.DOA_RequestView.getFields()) {
            strSOQL += fsmField.getFieldPath() + ', ';
        }
        
        strSOQL += 'ID FROM DOAApprovalRequest__c WHERE Project__c = \'' + projectID + '\'';

        lstDOARequests = (list<DOAApprovalRequest__c>)Database.query(strSOQL);

        for(DOAApprovalRequest__c AR: lstDOARequests){
        	setRequestIds.add(AR.id);
        }
        

	}

	private void loadConditions(){

		if(setRequestIds.size() >0){
	        string strSOQL = 'SELECT ';
	            
	        for (Schema.FieldSetMember fsmField: SObjectType.DOAConditions__c.FieldSets.DOA_ApprovalView.getFields()) {
	            strSOQL += fsmField.getFieldPath() + ', ';
	        }
	        
	        strSOQL += 'ID FROM DOAConditions__c WHERE DOAApprovalRequest__c IN: setRequestIds';

	        lstDOAConditions = (list<DOAConditions__c>)Database.query(strSOQL);
    	}
	}

	public pagereference addTrigger(){
		try{
			newTrigger.Project__c = projectID;
			insert newTrigger;

			newTrigger = new DOARegister__c();

			lstDOATriggers = new list<DOA_TriggerWrapper>();
			loadTriggers();

        } catch (Exception e) {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to add a DOA Trigger. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            return null;
        }

        return null;
	}

	public pagereference  questions(){

		boolean found = false;

		for(DOA_TriggerWrapper t: lstDOATriggers ){
			if(t.bChecked){
				found = true;
				break;
			}
		}

		if(found){
			return new pagereference('/apex/ECO_DOA_ApprovalRequestCreation');
		} else {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Cannot make a request without selecting DOA Triggers.');
            ApexPages.addMessage(oMsg);			
			return null;
		}


		
	}

	public pagereference  back(){
		return new pagereference('/apex/ECO_DOA_ApprovalRequest');
	}

	public pagereference createRequest(){
		

		list<recordtype> lstDOART = [select id, name from recordtype where sObjectType='DOAApprovalRequest__c' and name='DOA Create'];

		DOAApprovalRequest__c oNewDOA = new DOAApprovalRequest__c();
		
		oNewDOA.Project__c = projectID;
		oNewDOA.recordtypeid = lstDOART[0].id;
		oNewDOA.ApprovalStatus__c = 'Unapproved';

		Savepoint oSavePoint = Database.setSavepoint();

        
        try {
			insert oNewDOA;
        } catch (Exception e) {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to create a DOA Request. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            Database.rollback(oSavePoint);
            return null;
        }

		list<DOARegister__c> lstTriggersToUpdate = new list<DOARegister__c>();

		for(DOA_TriggerWrapper t: lstDOATriggers ){
			if(t.bChecked){
				t.oTrigger.DOAApprovalRequest__c = oNewDOA.id;
				lstTriggersToUpdate.add(t.oTrigger);
			}
		}

		try {
			update lstTriggersToUpdate;
        } catch (Exception e) {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to Update DOA Triggers. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            Database.rollback(oSavePoint);
            return null;
        }

		list<recordtype> lstRecordTypes = [select id, name from recordtype where sObjectType ='Form__c'];
		map<string, id> mapRecType = new map<string, id>();

		for(recordtype r: lstRecordTypes){
			mapRecType.put(r.name, r.id);
		}

		list<form__c> lstFormsToInsert = new list<form__c>();

		form__c newForm = new form__c();
		form__c newForm2 = new form__c();
		newForm.DOAApprovalRequest__c = oNewDOA.id;
		newForm2.DOAApprovalRequest__c = oNewDOA.id;

		if(questionOne == 'No'){
			newForm.recordtypeid = mapRecType.get('RFA');
			lstFormsToInsert.add(newForm);
		} else if(questionTwo == 'Yes'){
			newForm.recordtypeid = mapRecType.get('ORM Memo');
			lstFormsToInsert.add(newForm);
		} else if (questionThree == 'Yes'){
			newForm.recordtypeid = mapRecType.get('RCST');
			lstFormsToInsert.add(newForm);
			newForm2.recordtypeid = mapRecType.get('ORM Memo');
			lstFormsToInsert.add(newForm2);
		} else if (questionThree == 'No'){
			newForm.recordtypeid = mapRecType.get('RFA');
			lstFormsToInsert.add(newForm);
		}


		try {
			insert lstFormsToInsert;
		} catch (Exception e) {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to create a DOA Form. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            Database.rollback(oSavePoint);
            return null;
        }
		//return new pagereference('/' + oNewDOA.id);
		//return new pagereference('/'+ oNewDOA.id +'/e?retURL=/'+ oNewDOA.id);
		return new pagereference('/'+ lstFormsToInsert[0].id +'/e?retURL=/'+ oNewDOA.id);
	}

	public pagereference stub(){
		return null;
	}

	public pagereference answerone(){
		questionTwo = null;
		questionThree = null;
		return null;
	}

	public pagereference answertwo(){
		questionThree = null;
		return null;
	}

	public pagereference answerthree(){
		return null;
	}	


	public class DOA_TriggerWrapper {

		public boolean bChecked {get;set;}
		public DOARegister__c oTrigger {get;set;}

		public DOA_TriggerWrapper(DOARegister__c oTrigger){
			this.oTrigger = oTrigger;
			bChecked = false;
		}
	}
}