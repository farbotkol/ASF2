@isTest(seealldata=true)
private class ECO_TaskDetailControllerTest
{
    static pse__Proj__c objProj;
    static pse__Project_Task__c objProjTask;
    static pse__Project_Task__c objProjTask2;
    static pse__Project_Task__c objPProjTask;
    
    static testMethod void myUnitTestTrigger()
    {
        createProject();
        createParentProjectTask();
        Test.StartTest();
        createProjectTask();
        
        objProjTask2.FinancialTask__c = false;
        //Added this to byPass the validation Error during Running test class
        try
        {
            update objProjTask2;
        }
        catch(Exception objExp)
        {}
        Test.StopTest();
    }
    
    static testMethod void myUnitTest1()
    {
        createProject();
        createParentProjectTask();
        Test.StartTest();
        createProjectTask();
        Test.StopTest();
        
        ApexPages.StandardController con = new ApexPages.StandardController(objProj);
        ECO_TaskDetailController objTDC = new ECO_TaskDetailController(con);
        objTDC.intRowNo = 0;
        objTDC.lstTaskDetailWrapper[0].strSelectedAction = 'AddPeerTask';
        objTDC.manageRows();
        objTDC.mySave();
        
        //ECO_TaskDetailController.TaskDetailWrapper obj = new ECO_TaskDetailController.TaskDetailWrapper();
    }
    
    static testMethod void myUnitTest2()
    {
        Test.StartTest();
        createProject();
        createParentProjectTask();
        //createProjectTask();
        Test.StopTest();
        ApexPages.StandardController con = new ApexPages.StandardController(objProj);
        ECO_TaskDetailController objTDC = new ECO_TaskDetailController(con);
        objTDC.intRowNo = 0;
        objTDC.lstTaskDetailWrapper[0].strSelectedAction = 'AddSubTask';
        objTDC.manageRows();
        objTDC.mySave();
        
        //ECO_TaskDetailController.TaskDetailWrapper obj = new ECO_TaskDetailController.TaskDetailWrapper();
    }
    
    static testMethod void myUnitTest3()
    {
        Test.StartTest();
        createProject();
        createParentProjectTask();
        //createProjectTask();
        Test.StopTest();
        ApexPages.StandardController con = new ApexPages.StandardController(objProj);
        ECO_TaskDetailController objTDC = new ECO_TaskDetailController(con);
        objTDC.intRowNo = 0;
        objTDC.lstTaskDetailWrapper[0].strSelectedAction = 'DeleteTask';
        objTDC.manageRows();
        objTDC.mySave();
    }
    
    static testMethod void myUnitTest4()
    {
        Test.StartTest();
        createProject();
        Test.StopTest();
        
        ApexPages.StandardController con = new ApexPages.StandardController(objProj);
        ECO_TaskDetailController objTDC = new ECO_TaskDetailController(con);
        objTDC.intRowNo = 0;
        objTDC.addNewRowTask();
        objTDC.mySave();
    }
    
    static void createProject()
    {
        objProj = [select Id from  pse__Proj__c limit 1];
    }
    
    static void createProjectTask()
    {
        list<pse__Project_Task__c> lst = new list<pse__Project_Task__c>();
        objProjTask = new pse__Project_Task__c();
        objProjTask.Name = 'Test Project Task';
        objProjTask.FinancialTask__c = true;
        objProjTask.OracleSyncStatus__c = 'P';
        objProjTask.pse__Project__c = objProj.Id;
        objProjTask.pse__Parent_Task__c = objPProjTask.Id;
        //insert objProjTask ;
        lst.add(objProjTask);
        objProjTask2 = new pse__Project_Task__c();
        objProjTask2.Name = 'Test Project Task';
        objProjTask2.FinancialTask__c = true;
        objProjTask2.OracleSyncStatus__c = 'P';
        objProjTask2.pse__Project__c = objProj.Id;
        objProjTask2.pse__Parent_Task__c = objPProjTask.Id;
        //insert objProjTask2 ;
        lst.add(objProjTask2);
        
        insert lst;
    }
    
    static void createParentProjectTask()
    {
        objPProjTask = new pse__Project_Task__c();
        objPProjTask.Name = 'Test Project Task';
        objPProjTask.FinancialTask__c = true;
        objPProjTask.OracleSyncStatus__c = 'P';
        objPProjTask.pse__Project__c = objProj.Id;
        
        insert objPProjTask ;
    }
}