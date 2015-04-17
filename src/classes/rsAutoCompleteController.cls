/*************************************************************************
*
* PURPOSE: Auto complete Controller
*
* CREATED: 2014 Ethos Solutions - www.ethos.com
* AUTHOR: Brian Lau
***************************************************************************/
global with sharing class rsAutoCompleteController {
	public rsAutoCompleteController() {
		
	}

	@RemoteAction
    global static List<String> getValues(String prefix, String fieldName) { 

    	List<String> values = new List<String>();
    	prefix = '%' + prefix + '%';
    	List<AggregateResult> parts = new List<AggregateResult>();
    	if(fieldName != 'Skill__c') {
    	    parts = (List<AggregateResult>)Database.query('Select ' + fieldName + ' from rs_Profile_Part__c where ' + fieldName + ' LIKE ' +
    																				rsStringUtil.quote(prefix) + ' group by ' + fieldName + ' limit 10');
    	    for(AggregateResult part : parts) {
		        values.add(String.valueOf(part.get(fieldName)));
		    }
    	} else {
    		parts = (List<AggregateResult>)Database.query('Select ' + fieldName + ', Skill_Area__c from rs_Profile_Part__c where ' + fieldName + ' LIKE ' +
    																				rsStringUtil.quote(prefix) + ' group by ' + fieldName + ', Skill_Area__c limit 10');
    		for(AggregateResult part : parts) {
    			if(part.get('Skill_Area__c') != null) {
		        	values.add(String.valueOf(part.get('Skill_Area__c')) + ' - ' + String.valueOf(part.get(fieldName)));
    			} else {
    				values.add(String.valueOf(part.get(fieldName)));
    			}
		    }
    	}
	    

	    values.sort();
    	return values;


    }
}