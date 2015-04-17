/*************************************************************************
*
* PURPOSE: Trigger to calculate the date by which a case must be resolved
* based on the Business Hours that are defined
*
* CREATED: 2014 Ethos Solutions - www.ethos.com
* AUTHOR: Kyle Johnson
***************************************************************************/
trigger sshCalculateResolveBy on Case (after insert, before update) {

	Set<Id> caseIds = new Set<Id>();

	List<BusinessHours> busHours = [select Id from BusinessHours where Name = 'Shared Services North America'];

	if(!busHours.isEmpty()){

		for (Case so : Trigger.new) {
			//--Make sure that the record type is correct and that SLA Target has a value
			if( (so.RecordTypeId == sshUserContactUtils.getRecordTypeIdByName('Shared Services AP') ) && so.SS_SLA_Target__c != null){

				caseIds.add(so.Id);

				if(Trigger.isBefore){ //--Modify the Case directly as it will be updated after modification
					so.SS_Resolve_By__c = BusinessHours.add(busHours[0].Id, so.CreatedDate, (Long)(so.SS_SLA_Target__c * 3600000) );
				}
			}
		}

		if(Trigger.isAfter && !caseIds.isEmpty()){
			//--Query for Cases associated with the trigger's batch since this will happen after insert
			List<Case> cases = [select CreatedDate, SS_SLA_Target__c from Case where Id in :caseIds];

			if(!cases.isEmpty()){
				for(Case cs : cases){
					cs.SS_Resolve_By__c = BusinessHours.add(busHours[0].Id, cs.CreatedDate, (Long)(cs.SS_SLA_Target__c * 3600000) );
				}

				update cases;
			}
		}

	}

}