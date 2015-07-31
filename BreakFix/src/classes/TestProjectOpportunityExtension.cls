@istest
public with sharing class TestProjectOpportunityExtension {
    public static Opportunity opp;

    @isTest (seeAllData=true)
    static void testProjectOpportunityExtension() {
        createTestData();
        
        ApexPages.Standardcontroller ctl = new ApexPages.Standardcontroller(opp);
        ProjectOpportunityExtension ext = new ProjectOpportunityExtension(ctl);
        ext.saveProject();
    }
    
    private static void createTestData() {
Map<String,Id> recordTypes = new Map<String,Id>();
        List<Opportunity> opportunities = new List<Opportunity>(); 
        for(RecordType  recType :[Select Name, Id From RecordType where SobjectType ='Opportunity']){
            recordTypes.put(recType.Name,recType.Id);
        }
        
        Id aecomId;
        for(AECOM_Primary_Department__c aecom :[select id from AECOM_Primary_Department__c limit 1]){
            aecomId = aecom.id;
        }
       // Account
        Account acc1=new Account();
        acc1.Name='Test Account1';
        acc1.Type__c='Client';
        acc1.Client_Group__c='Industrial/Commercial';
        acc1.Client_Subgroup__c='Small - population under 500K';
        acc1.Legacy_AccountID__c='1221234';
        acc1.City__c='testCity';
        insert acc1;
        
        // Master Contract
        opp=new Opportunity();
        opp.AccountId=acc1.id;
        opp.Name='Test';
        opp.Primary_Business_Line__c='Water';
        opp.AECOM_Primary_Dept_Lookup__c=aecomId;
        opp.CloseDate=Date.today();
        opp.StageName='5B Test';
        opp.RecordTypeId=recordTypes.get('Program - APAC');
        
        opp.Legacy_OpportunityID__c='test' + System.now();
        opp.Project_State_Province__c = 'This is text DEscription';   
        opp.CM_Type__c='Test';     
        opp.Contract_Est_Months__c = 5;
        opp.WinDate__c = system.today();
        opp.Project_State_Province__c='WI';
        opp.AECOM_Job_Number__c='01010101';
        opp.Services__c = 'Test 1';
        opp.Energy_Service_Type__c = 'Test 2';
        insert opp;
        
        // Account
        Account part=new Account();
        part.Name='Test Account1';
        part.Type__c='Subcontractor';
        part.Client_Group__c='Industrial/Commercial';
        part.Client_Subgroup__c='Small - population under 500K';
        part.Legacy_AccountID__c='01101101';
        part.City__c='testCity';
        insert part;
        
        Partner op = new Partner();
        op.OpportunityId = opp.id;
        op.AccountToId=part.ID;
        op.Role = 'Alliance Partner';
        insert op;
        
            // Account
        Account prime=new Account();
        prime.Name='Test Account1';
        prime.Type__c='Subcontractor';
        prime.Client_Group__c='Industrial/Commercial';
        prime.Client_Subgroup__c='Small - population under 500K';
        prime.Legacy_AccountID__c='011011301';
        prime.City__c='testCity';
        insert prime;
        
        Partner op2 = new Partner();
        op2.OpportunityId = opp.id;
        op2.AccountToId=prime.ID;
        op2.Role = 'Prime';
        insert op2;
       
    }
    
    
     
}