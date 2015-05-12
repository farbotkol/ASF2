@isTest
public with sharing class ContractReviewTest {

  @isTest 
  private static void TestContractReviewTrigger() 
    {
        // ctry = [SELECT Id, name FROM Country__c WHERE name = 'Australia'];
        Country__c ctry = new Country__c(Name='Someplace', Country_Code__c='SP');
        insert ctry;
        
        Opportunity mockOpp = TestCoverageSmokeMocks.mockOpp(true);

        AECOM_Primary_Department__c dept = [select id from AECOM_Primary_Department__c limit 1];

        List<Opportunity_Department__c> mockOppDepList = TestCoverageSmokeMocks.mockOppDepList(true, 1, mockOpp, dept,null, null );

        Go_No_Go_Conversation__c a = new Go_No_Go_Conversation__c();
        a.Opportunity__c = mockOpp.id;
        insert a;   

        Go_No_Go_Conversation__c gng;

        gng = [SELECT id,Opportunity__c FROM Go_No_Go_Conversation__c limit 1 ];
     

        // Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];

        Contract_Review__c cr = new Contract_Review__c();
        cr.Country__c = ctry.Id;
        cr.Date_Required__c = Date.today();
        cr.Opportunity_GNG__c = gng.Id; 

        insert cr; 

        System.assert(cr.Opportunity_GNG__c != null);

        cr.Opportunity_GNG__c = null;

        update cr;

        System.assert(cr.Opportunity_GNG__c == null);
        
    }    
  
     
    @isTest 
    private static void TestContractReviewSharing() 
    {
      User user = [SELECT id, Legal__c  FROM user WHERE profile.UserLicense.Name = 'Force.com - App Subscription' and Legal__c = false and isactive = true limit 1 ];


      Country__c ctry = new Country__c(Name='Someplace', Country_Code__c='SP');
      insert ctry;


      Contract_Review__c cr = new Contract_Review__c();
      cr.Country__c = ctry.Id;
      cr.Date_Required__c = Date.today(); 

      insert cr; 

      boolean wassuccess = ContractReviewSharing.manualShareRead(cr.id,  user.id,  'Read');

      System.assert(wassuccess);
        
    }    
    
    
    
    @isTest 
    private static void TestLegalFlagTrigger() 
    {
    	
      StaticHelper.excludeIt = false;
        
        
        // Test a 'Salesforce' licence user 
      User user = [SELECT id, Legal__c  FROM user WHERE profile.UserLicense.Name = 'salesforce' and Legal__c = false and isactive = true limit 1 ];
      user.Legal__c = true;  
      update user ;

      Integer i = [SELECT COUNT()  From PermissionSetAssignment p
      where p.PermissionSet.Name = 'Contract_Reviewer_SF' and p.AssigneeId  = :user.Id];
      //There should be a Contract_Reviewer_SF PermissionSet for the user
      System.assert(i == 1);

      user.Legal__c = false; 
      update user ;

      i = [SELECT COUNT()  From PermissionSetAssignment p
      where p.PermissionSet.Name = 'Contract_Reviewer_SF' and p.AssigneeId  = :user.Id];
      //There should NOT be a Contract_Reviewer_SF PermissionSet for the user
      System.assert(i == 0);

      //Test a 'Force.com - App Subscription' licence user 
      user = [SELECT id, Legal__c  FROM user WHERE profile.UserLicense.Name = 'Force.com - App Subscription' and Legal__c = false and isactive = true limit 1 ];
      user.Legal__c = true; 
      update user ;

      i = [SELECT COUNT()  From PermissionSetAssignment p
      where p.PermissionSet.Name = 'Contract_Reviewer' and p.AssigneeId  = :user.Id];

      //There should be a Contract_Reviewer_SF PermissionSet for the user
      System.assert(i == 1);
      user.Legal__c = false; 
      update user ;

      i = [SELECT COUNT()  From PermissionSetAssignment p
      where p.PermissionSet.Name = 'Contract_Reviewer' and p.AssigneeId  = :user.Id];
      //There should NOT be a Contract_Reviewer_SF PermissionSet for the user
      System.assert(i == 0);

    }
    
    
    @isTest 
    private static void TestInvocableMethodContractReviewAssign() 
    {
  
      Country__c ctry = new Country__c(Name='Someplace', Country_Code__c='SP');
      insert ctry;

      Opportunity mockOpp = TestCoverageSmokeMocks.mockOpp(true);

      AECOM_Primary_Department__c dept = [select id from AECOM_Primary_Department__c limit 1];

      List<Opportunity_Department__c> mockOppDepList = TestCoverageSmokeMocks.mockOppDepList(true, 1, mockOpp, dept,null, null );

      Go_No_Go_Conversation__c a = new Go_No_Go_Conversation__c();
      a.Opportunity__c = mockOpp.id;
      insert a;   

      Go_No_Go_Conversation__c gng;

      gng = [SELECT id,Opportunity__c FROM Go_No_Go_Conversation__c limit 1 ];

          
      Contract_Review__c cr = new Contract_Review__c();
      cr.Country__c = ctry.Id;
      cr.Date_Required__c = Date.today();
      cr.Opportunity_GNG__c = gng.Id; 
        		
      insert cr; 

      ContractReviewVariable crv = new ContractReviewVariable();
      crv.crId = cr.Id;
      crv.queueName = 'Legal ANZ VSA';

      List<ContractReviewVariable> crvl = new List<ContractReviewVariable>{};

      crvl.add(crv);

      ContractReview.Assign(crvl);
		
		
    }
    
    
    @isTest
    public static  void testBatchUpdateOpportunityNameSearchable() {
    

      Country__c ctry = new Country__c(Name='Someplace', Country_Code__c='SP');
      insert ctry;
      
      Opportunity mockOpp = TestCoverageSmokeMocks.mockOpp(true);

      AECOM_Primary_Department__c dept = [select id from AECOM_Primary_Department__c limit 1];

      List<Opportunity_Department__c> mockOppDepList = TestCoverageSmokeMocks.mockOppDepList(true, 1, mockOpp, dept,null, null );

      Go_No_Go_Conversation__c a = new Go_No_Go_Conversation__c();
      a.Opportunity__c = mockOpp.id;
      insert a;   


  		Test.StartTest();   
  		BatchUpdateOpportunityNameSearchable batchprocess = new BatchUpdateOpportunityNameSearchable();
  		ID batchprocessid = Database.executeBatch(batchprocess);
  		
  		Test.StopTest();    		 	
  		Go_No_Go_Conversation__c gng = [select Opportunity_Name__c, Opportunity_Name_Searchable__c 
  		    		 						from Go_No_Go_Conversation__c limit 1];						 						
  		System.assert(gng.Opportunity_Name__c == gng.Opportunity_Name_Searchable__c);
		
   }
   
   
   //a once off trigger
   @isTest
    public static  void testBatchUpdateUserCRSPermissionSets() {

      User user = TestCoverageSmokeMocks.mockUser(true);

  		Test.StartTest();   
  		
      BatchUpdateUserCRSPermissionSets batchprocess = new BatchUpdateUserCRSPermissionSets();
  		ID batchprocessid = Database.executeBatch(batchprocess);
  		
  		Test.StopTest();   

      integer cnt = [select count() from PermissionSetAssignment where PermissionSet.Name like '%Contract_Reviewer%' and AssigneeId = :user.Id];

      System.assert(cnt == 1, cnt);
 
		
   }

    
}