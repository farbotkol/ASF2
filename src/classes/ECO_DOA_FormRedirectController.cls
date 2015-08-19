public with sharing class ECO_DOA_FormRedirectController {

	public Form__c oForm {get;set;}

	public ECO_DOA_FormRedirectController(ApexPages.StandardController stdController) {
		this.oForm = (Form__c)stdController.getRecord();
		
	}

	public pagereference redirectForm(){

		list<RecordType> lstRT = [select id from recordtype where sObjectType='Form__c' and developername='RFA'];

		if(oForm.recordtypeid == lstRT[0].id){
			return new pagereference('/apex/ECO_RFA?id=' + oForm.id);
		} else {
			return new pagereference('/' + oForm.id + '?nooverride=1');
		}
	}

	public pagereference redirectFormEdit(){

		list<RecordType> lstRT = [select id from recordtype where sObjectType='Form__c' and developername='RFA'];

		if(oForm.recordtypeid == lstRT[0].id){
			return new pagereference('/apex/ECO_RFA?id=' + oForm.id);
		} else {
			return new pagereference('/' + oForm.id + '/e?retURL=/' + oForm.DOAApprovalRequest__c + '&nooverride=1');
		}
	}

}