@isTest(SeeAllData=true)
//seealldata is true for connectAPI code in class. 
private class Service_Catalog_AECOMServiceCatalogTEST
{


    static testmethod void testAddUserToChatterGroup()
    {
     //set up chatter user 
     Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];  
     User u = new User(Alias = 'standt', Email='SFDC@aecom.com',  
     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',  
     LocaleSidKey='en_US', ProfileId = p.Id,  
     TimeZoneSidKey='America/Los_Angeles', UserName='SFDC@aecom.com'); 

     String chatterGroupId;
     List<Service_Catalog_Settings__c> mcs = Service_Catalog_Settings__c.getall().values();
        chatterGroupId = mcs[0].ChatterId__c;
  
      

Test.startTest();    
      System.RunAs(u)
      {
            
            Service_Catalog_AECOMServiceCatalog  sc = new Service_Catalog_AECOMServiceCatalog();
            sc.Onload();   
            sc.addUserToChatterGroup();
            Integer count = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId = :chatterGroupId AND MemberId = :u.Id];
            System.assertEquals(count,1);//check user is added
            sc.Onload();   
            sc.removeUserFromChatterGroup();      
            count = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId = :chatterGroupId AND MemberId = :u.Id];
            System.assertEquals(count,0); //check user is removed         
                     
      }
      
Test.stopTest();      

    }
    

        
    
}