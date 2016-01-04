public with sharing class ECO_ProjectTaskService {
  public ECO_ProjectTaskService() {
    
  }
   public static List<pse__Time_Period__c> calcTimePeriods  = new List<pse__Time_Period__c>();
 /* public static List<pse__Time_Period__c> calcTimePeriods (list<date> enddatelist ,string type){
      List<pse__Time_Period__c> calcTimePeriods = new list<pse__Time_Period__c>([select id,TimePeriodCode__c,pse__End_Date__c,pse__Start_Date__c from pse__Time_Period__c where pse__Type__c =:type and pse__Start_Date__c <=:enddatelist and pse__End_Date__c  >=:enddatelist]);
  return calcTimePeriods ;
  }
  */
  public static List<ECO_ProjectTask> getProjectTaskList(Id projectId) {
    List<pse__Project_Task__c> projectTasks = [select Id,Name,ForecastEndDate__c,pse__order__c,ProjectTaskNumber__c,ForecastStartDate__c,IsBillable__c,IsChargeable__c
                            ,EarnedValueCurve__c,Duration__c,FinancialTask__c,pse__Start_Date_Time__c, pse__End_Date_Time__c,
                             pse__Project__c,Task_Sequence_No__c,WorkTypeName__c,pse__Parent_Task__c,OracleSyncStatus__c,
                             TaskOrg__c,pse__Project__r.PrimarySiteId__c,pse__Parent_Task__r.OracleSyncStatus__c
                             from pse__Project_Task__c where pse__Project__c =: projectId order by pse__order__c];

    List<ECO_ProjectTask> tempTasks = new List<ECO_ProjectTask>();

    Map<Id, ECO_ProjectTask> taskMap = new Map<Id, ECO_ProjectTask>();

    for (pse__Project_Task__c task : projectTasks) {
      ECO_ProjectTask newTask = new ECO_ProjectTask(task);

      tempTasks.add(newTask);
      taskMap.put(newTask.id, newTask);
    }

    for (ECO_ProjectTask task : tempTasks) {
      if (task.parentTaskId != null) {
        ECO_ProjectTask parent = taskMap.get(task.parentTaskId);

        parent.addChild(task);
      }
    }

    List<ECO_ProjectTask> tasks = new List<ECO_ProjectTask>();

    for (ECO_ProjectTask task : tempTasks) {
      if (task.parentTaskId == null) {
        setIndentLevel(tasks, task, 0);
      }
    }

    return tasks;
  }

  private static void setIndentLevel(List<ECO_ProjectTask> tasks, ECO_ProjectTask task, Integer level) {
    task.indentLevel = level;

    tasks.add(task);

    if (task.parentTaskId != null) {
      if (task.parentClasses == null) {
        task.parentClasses = task.parentTaskId;
      } else {
        task.parentClasses += ' ' + task.parentTaskId;
      }
    }

    for (ECO_ProjectTask child : task.children) {
      setIndentLevel(tasks, child, level + 1);
    }
  }
}