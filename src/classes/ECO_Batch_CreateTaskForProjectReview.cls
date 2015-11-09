global class ECO_Batch_CreateTaskForProjectReview implements Database.Batchable<sObject> 
{
    global final String query;
    
    global ECO_Batch_CreateTaskForProjectReview()
    {
        this.query = 'Select Id, pse__Project_Manager__c, CreateTaskBatchRan__c, OwnerId From pse__Proj__c Where pse__Project_Manager__c != null And (clAECOMProjectReviewCategory__c = \'C-0\' Or clAECOMProjectReviewCategory__c = \'C-1\' Or clAECOMProjectReviewCategory__c = \'C-1+\' Or clAECOMProjectReviewCategory__c = \'C-2\')';
    }
    
    global Database.QueryLocator start(Database.BatchableContext oBC)
    {
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext oBC, List<sObject> scope)
    {
        Id taskRecordTypeId = ECO_Utils_Meta.getRecordTypeId(Task.sObjectType, 'ECO Tasks');
        List<Task> newTasks = new List<Task>();
        List<pse__Proj__c> updatedProjects = new List<pse__Proj__c>();
        for(sObject sObj : scope)
        {
            pse__Proj__c oProj = (pse__Proj__c)sObj;
            Task t = new Task();
            t.WhatId = oProj.Id;
            t.WhoId = oProj.pse__Project_Manager__c;
            t.Subject = Datetime.now().format('MMMM') + ' Performance Review';
            t.ActivityDate = Datetime.now().addDays(7).date();
            t.ReminderDateTime = Datetime.now().addDays(6);
            t.IsReminderSet = true;
            t.OwnerId = oProj.OwnerId;
            t.RecordTypeId = taskRecordTypeId;
            newTasks.add(t);
        }

        if(!newTasks.isEmpty())
            insert newTasks;
    }
    global void finish(Database.BatchableContext oBC)
    {

    }
}