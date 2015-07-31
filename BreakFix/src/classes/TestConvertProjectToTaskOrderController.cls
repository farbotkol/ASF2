/*************************************************************************
//Name                : TestConvertProjectToTaskOrderController
//Author              : Aslam Bari
//Description         : For coverage ConvertProjectToTaskOrderController
//Date                : Aug 17, 2010
*************************************************************************/
@istest private  class TestConvertProjectToTaskOrderController{
@isTest private static void testController(){
    Map<String,ID> recordTypesMap = new Map<String,ID>();
    for(RecordType r:[select id,Name from RecordType where sObjectType='Opportunity' and isActive=true]){
        recordTypesMap.put(r.Name,r.Id);
        system.debug('###' + r.Name);
    }
    Opportunity newOpp = new Opportunity(Legacy_OpportunityID__c='101');
    newOpp.RecordTypeId = recordTypesMap.get('Program - APAC');
    newOpp.Name = 'test';
    newOpp.StageName = '1 Lead';
    newOpp.CloseDate = System.today().addDays(30);
    insert newOpp;
    
    Opportunity newOpp2 = new Opportunity(Legacy_OpportunityID__c='102');
    newOpp2.RecordTypeId = recordTypesMap.get('Task Order - APAC');
    newOpp2.Name = 'test';
    newOpp2.StageName = '1 Lead';
    newOpp2.CloseDate = System.today().addDays(30);
    insert newOpp2;
    
    ApexPages.StandardController sc = new ApexPages.StandardController(newOpp);
    ConvertProjectToTaskOrderController pToTController = new ConvertProjectToTaskOrderController(sc);
    pToTController.newTask.Master_Contract_lookup__c = newOpp2.Id;
    pToTController.searchOpportunities();
    pToTController.opportunityName = 'test';
    pToTController.searchOpportunities();
    pToTController.opportunityName = '&&&&';
    pToTController.searchOpportunities();
    pToTController.createNewTaskOrder();
    pToTController.getShowMoreThen100();
    pToTController.cancel();
    
    pToTController.opportunityName = null;
    pToTController.searchOpportunities1();
        
    pToTController.opportunityName = 'test';
    pToTController.masterContracts =null;
    pToTController.searchOpportunities1();
    
    pToTController.selectedOption = '';
    pToTController.searchOpportunities1();
    
    
    pToTController.masterId = newOpp2.Id;
    pToTController.opportunityName = null;
    pToTController.createNewTaskOrder();
    
    System.assertEquals(pToTController.newTask.Master_Contract_lookup__c,newOpp2.Id );
    pToTController.getOptions();
    
    pToTController.goNext();
    pToTController.goPrevious();
}
}