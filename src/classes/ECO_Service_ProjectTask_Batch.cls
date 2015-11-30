global class  ECO_Service_ProjectTask_Batch implements Database.Batchable<sObject>,Database.Stateful,Schedulable{
    
    String query;
    Public list<string> Fiscallist{get;set;}
      global Database.QueryLocator start(Database.BatchableContext BC) {
       query ='select id from pse__Project_Task__c ';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<pse__Project_Task__c  > scope) {
        list<string> projecttasklist = new list<string>();
        for(pse__Project_Task__c t:scope)
        {
            projecttasklist.add(t.id);
        }
        ECO_Service_ProjectTask ep = new ECO_Service_ProjectTask(projecttasklist);
        List<pse__Project_Task__c> tobeupdatedprojecttasklist = new List<pse__Project_Task__c>();
        tobeupdatedprojecttasklist = ep.getProjectTasks();
        if(tobeupdatedprojecttasklist.size()>0)
            update tobeupdatedprojecttasklist;
    }
    
    global void finish(Database.BatchableContext BC) {
    
    }
    
    global void execute(SchedulableContext sc)
    {
          ECO_Service_ProjectTask_Batch b = new ECO_Service_ProjectTask_Batch();
          database.executebatch(b);
     }
    
}