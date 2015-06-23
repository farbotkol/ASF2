public without sharing class ECO_Utils_Meta {
	
	public class RecordTypeNotFoundException extends Exception {} 
	public class InvalidPicklistValueException extends Exception {}
	
	private static final Map<String,Map<String,Schema.RecordTypeInfo>> sObjectRecordTypes = new Map<String,Map<String,Schema.RecordTypeInfo>>();
	
	public static Id getRecordTypeId(SObjectType so, String recordTypeName) {
		if (so != null 
			&& recordTypeName != null 
			&& recordTypeName != '') {
				Schema.DescribeSObjectResult r = so.getDescribe();
				if (r != null && !sObjectRecordTypes.containsKey(r.getName())) {
					sObjectRecordTypes.put(r.getName(), r.getRecordTypeInfosByName());
				}

				Map<String, Schema.RecordTypeInfo> recTypeInfos = sObjectRecordTypes.get(r.getName());
				Schema.RecordTypeInfo recTypeInfo = recTypeInfos.get(recordTypeName);
				//System.debug('recTypeInfo=' + recTypeInfo);
				if (recTypeInfo != null) {
					return recTypeInfo.getRecordTypeId();
				}
		}

		throw new RecordTypeNotFoundException('RecordType \'' + recordTypeName + '\' was not found for SObjectType \'' + so + '\'.');
	}
	
	// runs before insert/update
	public static void setRecordTypeId (List<sObject> sObjectsToSet) {
		
		Schema.sObjectType sot = sObjectsToSet.getSObjectType();

		for (sObject so : sObjectsToSet) {
			Id recordTypeId = getRecordTypeId(sot, (String)so.get('RecordTypeName__c'));
			
			if (recordTypeId != null) {
				so.put('RecordTypeId', recordTypeId);
			}
		}
	}	
	
	// These will return a profile Id given a name and is coded to minimize number of Soql queries.
	private static Map<String, Id> profileNameToIdMap;
	private class ProfileNotFoundException extends Exception {}
	public static Id getProfileId (String profileName) {
		if (null == profileNameToIdMap) {
			profileNameToIdMap = new Map<String, Id>();
			
			for (Profile p : [SELECT Id
									, Name 
							FROM Profile 
							LIMIT 10000]){
				profileNameToIdMap.put(p.Name, p.Id);
			}
		}
		
		Id profileId = profileNameToIdMap.get(profileName); 
		if(null == profileId){
			throw new ProfileNotFoundException('Profile \''+profileName+'\' not found.');
		} else {
			return profileId;
		}
	}
	
	public class SelectAll{
        public string allfields;
        public string SOQL;
        
        public Map<string, schema.sobjecttype> allSObjects {get; set;}
        
        public SelectAll(){
            allSObjects = schema.getglobaldescribe();
        }
        
        public string GetFields(string sfo){
            schema.sobjecttype q = allSObjects.get(sfo);
            schema.describesobjectresult d = q.getdescribe();
            map<string, schema.sobjectfield> m = d.fields.getmap();
            set<string> s = m.keyset();
            string query = '';
            for(string f : s){
                query = query+f+', ';
            }
            query = query.substring(0,query.length()-2);
            this.allfields = query;
            this.SOQL = 'SELECT ' + query + ' FROM ' + sfo;
            
            return this.allfields;
        }
    }
    
    public static list<SelectOption> getPicklistValues(SObject obj, String fld)
    {
		list<SelectOption> options = new list<SelectOption>();
		// Get the object type of the SObject.
		Schema.sObjectType objType = obj.getSObjectType(); 
		// Describe the SObject using its object type.
		Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
		// Get a map of fields for the SObject
		map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
		// Get the list of picklist values for this field.
		list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
		// Add these values to the selectoption list.
		for (Schema.PicklistEntry a : values)
		{ 
			options.add(new SelectOption(a.getValue(), a.getLabel())); 
		}
		return options;
   }
}