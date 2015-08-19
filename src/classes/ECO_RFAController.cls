public with sharing class ECO_RFAController {

	private final string PRMDelim = ',,,,';
	private final string PRMItemDelim = '!!';

	public Form__c oForm {get;set;}
	public list<DOARegister__c> DOARegisters {get;set;}
	public list<DOARegister__c> NonProjectRelatedMatters {get;set;}

	public integer selectedIndex {get;set;}

	private integer index;

	public ECO_RFAController(ApexPages.StandardController stdController) {
		this.oForm = (Form__c)stdController.getRecord();

		if(oForm.id == null){
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You have arrived to this page through inappropriate channels');
            ApexPages.addMessage(oMsg);
		}


        string strSOQL = 'SELECT ';
        string formid = oForm.id;
            
        for (Schema.FieldSetMember fsmField: SObjectType.Form__c.FieldSets.RFABusinessGroup.getFields()) {
            strSOQL += fsmField.getFieldPath() + ', ';
        }
        
        strSOQL += 'ID, DOAApprovalRequest__c, ReasonForRequest__c, ProposedReviewCategoryChange__c, JustificationReviewCategoryChange__c, NonProjectRelatedMatters__c FROM Form__c WHERE id=: formid';

        list<Form__c> lstform = (list<Form__c>)Database.query(strSOQL);
		oForm = lstform[0];

		this.DOARegisters = [select id, name, EnterpriseDOA__c, DCSsubDOA__c, DOATrigger__c, RiskTitle__c from DOARegister__c where DOAApprovalRequest__c =: oForm.DOAApprovalRequest__c];

		NonProjectRelatedMatters = new list<DOARegister__c>();

		index = 0;

		if(oForm.NonProjectRelatedMatters__c != null){
			list<string> lstPRM = oForm.NonProjectRelatedMatters__c.split(PRMDelim, 0);


			for(string PRM: lstPRM){

				if(PRM == null || PRM==''){
					continue;
				}

				index +=1;

				list<string> PRMitems = PRM.split(PRMItemDelim, 0);

				if(PRMitems.size() == 3){
					NonProjectRelatedMatters.add(new DOARegister__c(IndexNumber__c = index, EnterpriseDOA__c = PRMitems[0], DCSsubDOA__c = PRMitems[1], DOATrigger__c = PRMitems[0]));

				} else {
		            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Encountered an error while trying to read Non Project Related Matters: ' + PRM);
		            ApexPages.addMessage(oMsg);
				}	
			}
		}

	}

	public pagereference AddNonProjectRelatedMatter(){
		index +=1;
		NonProjectRelatedMatters.add(new DOARegister__c(IndexNumber__c = index));
		return null;
	}

	public pagereference RemoveNonProjectRelatedMatter(){

		list<DOARegister__c> newlist = new list<DOARegister__c>();

		for(DOARegister__c d: NonProjectRelatedMatters){
			if(d.IndexNumber__c != selectedIndex){
				newlist.add(d);
			}
		}

		NonProjectRelatedMatters = newlist;

		return null;
	}


	private boolean writeAddNonProjectRelatedMatterToField(){
		
		string finalstorage ='';

		for(DOARegister__c d: NonProjectRelatedMatters){

			if(d.EnterpriseDOA__c == null || d.DCSsubDOA__c == null || d.DOATrigger__c == null || d.EnterpriseDOA__c.trim().length() == 0 || d.DCSsubDOA__c.trim().length() == 0 || d.DOATrigger__c.trim().length() == 0){
	            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please complete all fields for Non-Project Matters');
	            ApexPages.addMessage(oMsg);
	            return false;
			}

			finalstorage += PRMDelim + d.EnterpriseDOA__c + PRMItemDelim + d.DCSsubDOA__c + PRMItemDelim + d.DOATrigger__c;
		
		}

		oForm.NonProjectRelatedMatters__c = finalstorage;
		return true;
	}

	public pagereference saveForm(){
		if(writeAddNonProjectRelatedMatterToField()){

			try{
				update oForm;
			} catch (Exception e) {
	            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to update the form. Please contact your administrator with the following error: ' + e);
	            ApexPages.addMessage(oMsg);
	            return null;
			}
		}
		return null;

	}


}