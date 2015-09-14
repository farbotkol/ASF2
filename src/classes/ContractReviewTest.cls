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
    private static void TestLegalFlagTrigger1()
    {
    	
      StaticHelper.excludeIt = false;
        
        // Test a 'Salesforce' licence user 
      User user = [SELECT id, Legal__c  FROM user WHERE profile.UserLicense.Name = 'salesforce' and Legal__c = false and isactive = true limit 1 ];
      
      Test.startTest();
      user.Legal__c = false;  
      update user ;
      Test.stopTest();

      Integer i = [SELECT COUNT()  From PermissionSetAssignment p
      where p.PermissionSet.Name = 'Contract_Reviewer_SF' and p.AssigneeId  = :user.Id];
      //There should be a Contract_Reviewer_SF PermissionSet for the user
      System.assert(i == 0);

    }


    @isTest 
    private static void TestLegalFlagTrigger2()
    {
      StaticHelper.excludeIt = false;

      User user = [SELECT id, Legal__c  FROM user WHERE profile.UserLicense.Name = 'salesforce' and Legal__c = true and isactive = true limit 1 ];

      Test.startTest();

      user.Nationality__c = 'Australia';
      user.Legal__c = false; 
      update user ;        
      Test.stopTest();

      Integer i = [SELECT COUNT()  From PermissionSetAssignment p
      where p.PermissionSet.Name = 'Contract_Reviewer_SF' and p.AssigneeId  = :user.Id];
      //There should NOT be a Contract_Reviewer_SF PermissionSet for the user
      System.assert(i == 0, i);

    }


    @isTest 
    private static void TestLegalFlagTrigger3()
    {
      StaticHelper.excludeIt = false;
      //Test a 'Force.com - App Subscription' licence user 
      User user = [SELECT id, Legal__c  FROM user WHERE profile.UserLicense.Name = 'Force.com - App Subscription' and Legal__c = false and isactive = true limit 1 ];
      
      Test.startTest();
      user.Legal__c = true; 
      update user ;
      Test.stopTest();

      Integer i = [SELECT COUNT()  From PermissionSetAssignment p
      where p.PermissionSet.Name = 'Contract_Reviewer' and p.AssigneeId  = :user.Id];

      //There should be a Contract_Reviewer_SF PermissionSet for the user
      System.assert(i == 1);
    }

    @isTest 
    private static void TestLegalFlagTrigger4()
    {
      StaticHelper.excludeIt = false;
      //Test a 'Force.com - App Subscription' licence user 
      User user = [SELECT id, Legal__c  FROM user WHERE profile.UserLicense.Name = 'Force.com - App Subscription' and Legal__c = true and isactive = true limit 1 ];

      Test.startTest();      
      user.Nationality__c = 'Australia';
      user.Legal__c = false; 
      update user ;

      Test.stopTest();

      Integer i = [SELECT COUNT()  From PermissionSetAssignment p
      where p.PermissionSet.Name = 'Contract_Reviewer' and p.AssigneeId  = :user.Id];
      //There should NOT be a Contract_Reviewer_SF PermissionSet for the user
      System.assert(i == 0, i);
    }

       
    @isTest 
    private static void TestLegalFlagTrigger5()
    {
      StaticHelper.excludeIt = false;
      //Test a 'Force.com - App Subscription' licence user 
      User user = [SELECT id, Legal__c  FROM user WHERE profile.UserLicense.Name = 'salesforce' and Legal__c = false and isactive = true limit 1 ];

      Test.startTest();      
      user.Nationality__c = 'Australia 1';
      user.Legal__c = true; 
      update user ;

      Test.stopTest();

      Integer i = [SELECT COUNT()  From PermissionSetAssignment p
      where p.PermissionSet.Name = 'Contract_Reviewer_SF' and p.AssigneeId  = :user.Id];
      //There should NOT be a Contract_Reviewer_SF PermissionSet for the user
      System.assert(i == 1, i);
    }

    @isTest 
    private static void TestLegalFlagTrigger6()
    {
      StaticHelper.excludeIt = false;
 
      User user = [SELECT id, Legal__c  FROM user WHERE profile.UserLicense.Name = 'Force.com - App Subscription' and Legal__c = false and isactive = true limit 1 ];

      Test.startTest();      
      user.Nationality__c = 'Australia 1';
      update user ;

      Test.stopTest();

      Integer i = [SELECT COUNT()  From PermissionSetAssignment p
      where p.PermissionSet.Name = 'Contract_Reviewer_General_User' and p.AssigneeId  = :user.Id];
    
      System.assert(i == 1, i);
    }


    public static User mockAdmin()  
    {
      Profile p = [select id from profile where name='System Administrator'];
      User u = new User(LastName = 'Test User', Alias = 'AXKSJUE', Username = 'Test@test12343456677.com.' + 'AXKSJUEUENF', CommunityNickname = 'n' + 'AXKSJU' , Email='SFDCTestCase@aecom.com', emailencodingkey='UTF-8', languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id, timezonesidkey='America/Los_Angeles', EmployeeNumber = '123345' );
      insert u;
      return u;
    }   

    @isTest 
    private static void TestLegalFlagTrigger_GlobalPermissionSets()
    {
      StaticHelper.excludeIt = false;

      User admin = mockAdmin() ;

      //Test a 'Force.com - App Subscription' licence user 
      User user = [SELECT id, Legal__c  FROM user WHERE profile.UserLicense.Name = 'Force.com - App Subscription' and Legal__c = false and isactive = true limit 1 ];

      

      PermissionSet ps = new PermissionSet();
      ps.Name='TestPermissionSet';
      ps.label='TestPermissionSet';
      insert ps;


      PermissionSet ps2 = new PermissionSet();
      ps2.Name='TestPermissionSet2';
      ps2.label='TestPermissionSet2';
      insert ps2;


      PermissionSetAssignment psa = new  PermissionSetAssignment();
      psa.AssigneeId = user.Id;
      psa.PermissionSetId = ps2.Id;
      insert psa;


      System.runAs(admin)
      {
        Global_Permission_Sets__c customSetting = new Global_Permission_Sets__c(Name='TestPermissionSet',permission_set_name__c='TestPermissionSet');
        insert customSetting;

        Global_Permission_Sets__c customSetting2 = new Global_Permission_Sets__c(Name='TestPermissionSet2',permission_set_name__c='TestPermissionSet2');
        insert customSetting2;
      }

      Test.startTest();      
      user.Nationality__c = 'Australia 1';
      update user ;

      Test.stopTest();

      Integer i = [SELECT COUNT()  From PermissionSetAssignment p
      where p.PermissionSet.Name = 'TestPermissionSet' and p.AssigneeId  = :user.Id];
      
      //There should  be a TestPermissionSet PermissionSet for the user
      System.assert(i == 1, i);
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