public with sharing class ECO_GlobalBusinessService {

    public SharedServicesRequest__c SSR {get; set;}
    public String selectedRecordType {get; set;}

    
    
    public ECO_GlobalBusinessService(ApexPages.StandardController controller)
    {
        SSR = (SharedServicesRequest__c)controller.getRecord();
    }
    
    /*public PageReference recordTypeSelected()
    {
        RecordType recordType = [select Id, Name from RecordType where Id = :selectedRecordType];
            
            
        return  new PageReference( );                
    }*/
    
    
    public list<RecordType> getGBSRecordTypes()
    {
        return [select Id, toLabel(Name), DeveloperName, Description from RecordType where sObjectType = 'SharedServicesRequest__c'];
    }
}