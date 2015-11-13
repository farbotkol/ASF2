@isTest(seealldata=true)
private class ECO_TaskDetailControllerTest
{
    static pse__Proj__c objProj;
    static pse__Project_Task__c objProjTask;
    static pse__Project_Task__c objPProjTask;
    
    static testMethod void myUnitTest1()
    {
        Test.StartTest();
        createProject();
        createParentProjectTask();
        //createProjectTask();
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
        objProjTask = new pse__Project_Task__c();
        objProjTask.Name = 'Test Project Task';
        objProjTask.FinancialTask__c = true;
        objProjTask.OracleSyncStatus__c = 'P';
        objProjTask.pse__Project__c = objProj.Id;
        objProjTask.pse__Parent_Task__c = objPProjTask.Id;
        insert objProjTask ;
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