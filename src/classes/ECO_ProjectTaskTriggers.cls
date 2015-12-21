public with sharing class ECO_ProjectTaskTriggers {
    
    public static Boolean run = true;
    public static Boolean hasUpdateRan = false;
    public static Boolean updatingBurden = false;
    public static Boolean copyingCarrying = false;
    public static Set<String> executedMethods = new Set<String>();

    public class TaskWrapper {
        pse__Project_Task__c parent;
        List<pse__Project_Task__c> children;


    }

    private static Map<Id, pse__Project_Task__c> mapTasksById;
    private static Map<Id, pse__Project_Task__c> tasksToUpdateForecasts;

    public static void recalculateBudgets(List<pse__Project_Task__c> tNew) {

        if (!run) return;

        if (executedMethods.contains('recalculateBudgets')) return;
        executedMethods.add('recalculateBudgets');

        List<BudgetAssignment__c> budgetAssignmentsToUpdate = new List<BudgetAssignment__c>();
        Map<Id, String> mapWorkTypeById = new Map<Id,String>();

        for (pse__Project_Task__c task : tNew) {
            mapWorkTypeById.put(task.Id, task.WorkTypeName__c);
        }

        for (BudgetAssignment__c ba : [Select Id, WorkTypeName__c, BudgetTask__r.ProjectTask__c
                                        From BudgetAssignment__c
                                        Where BudgetTask__r.ProjectTask__c IN :mapWorkTypeById.keySet()]) {

            String workType = mapWorkTypeById.get(ba.BudgetTask__r.ProjectTask__c);
            system.debug(ba.Id + ' - workType: ' + workType);
            ba.WorkTypeName__c = workType;

            budgetAssignmentsToUpdate.add(ba);
        }

        run = false;
        update budgetAssignmentsToUpdate;
        run = true;
    }
    public static void rollupForecastDates(Map<Id, pse__Project_Task__c> tNewMap, Map<Id, pse__Project_Task__c> tOldMap) {
        System.debug(LoggingLevel.INFO, 'rollupForecastDates - run ' + run);
        if (!run) return;

        if (executedMethods.contains('rollupForecastDates')) return;
        executedMethods.add('rollupForecastDates');

        Set<Id> projectIds = new Set<Id>();
        tasksToUpdateForecasts = new Map<Id,pse__Project_Task__c>();

        for (pse__Project_Task__c task : tNewMap.values()) {
            projectIds.add(task.pse__Project__c);
        }


        mapTasksById = 
            new Map<Id, pse__Project_Task__c>(
                [SELECT Id, Name, pse__Project__c, pse__Parent_Task__c, ForecastStartDate__c, ForecastEndDate__c,
                    (SELECT Id, Name, pse__Project__c, pse__Parent_Task__c, ForecastStartDate__c, ForecastEndDate__c FROM pse__Immediate_Sub_Tasks__r)
                 FROM pse__Project_Task__c 
                 WHERE pse__Project__c IN :projectIds]);

        // We only need to validate if it's on update
        if(tOldMap != null) { 
            for (pse__Project_Task__c task : tNewMap.values()) {
                pse__Project_Task__c dTask = mapTasksById.get(task.Id);

                Date oldStartDate = tOldMap.get(task.Id).ForecastStartDate__c;
                Date oldEndDate = tOldMap.get(task.Id).ForecastEndDate__c;

                if (oldStartDate == task.ForecastStartDate__c && 
                    oldEndDate == task.ForecastEndDate__c) {
                    continue;
                }

               // Validate if forecast dates are changed that there aren't any children
               if (!dTask.pse__Immediate_Sub_Tasks__r.isEmpty()) {
                    task.addError('Forecast Date changed on Task with children'); 
               }

               System.debug(LoggingLevel.INFO, 'Date roll up for task: ' + task.Id);
               // Only do rollup if date change expands forecast range in either direction
               //if ( task.ForecastStartDate__c < oldStartDate || oldEndDate < task.ForecastEndDate__c ) {
                if (task.pse__Parent_Task__c != null) {
                    rollupDates(mapTasksById.get(task.pse__Parent_Task__c));
                }
               //}
                
            }
        } // End Validation

        if(!tasksToUpdateForecasts.isEmpty()) {
            run = false;

            update tasksToUpdateForecasts.values();

            run = true;

        }
    }

    public static pse__Project_Task__c rollupDates(pse__Project_Task__c task) {    
        Boolean changed = false;

        Date newStartDate = null;
        Date newEndDate = null;

        for (pse__Project_Task__c subTask : task.pse__Immediate_Sub_Tasks__r) {
            if (newStartDate == null || subTask.ForecastStartDate__c < newStartDate) {
                newStartDate = subTask.ForecastStartDate__c;
            }

            if (newEndDate == null || subTask.ForecastEndDate__c > newEndDate) {
                newEndDate = subTask.ForecastEndDate__c;
            }
        }

        if (newStartDate != task.ForecastStartDate__c) {
            task.ForecastStartDate__c = newStartDate;
            changed = true;
        }

        if (newEndDate != task.ForecastEndDate__c) {
            task.ForecastEndDate__c = newEndDate;
            changed = true;
        }

        System.debug(LoggingLevel.INFO, 'changed: ' + changed + ' task: ' + task);
        System.debug(LoggingLevel.INFO, task.Name + ': Dates ' + newStartDate + ' - ' + newEndDate);
        
        if(changed) {
            tasksToUpdateForecasts.put(task.Id, task);
        }

        if (task.pse__Parent_Task__c == null || !changed) {
            return null;
        }

        pse__Project_Task__c parentTask = mapTasksById.get(task.pse__Parent_Task__c);

        // Update child task
        for (pse__Project_Task__c subTask : parentTask.pse__Immediate_Sub_Tasks__r) {
            if(subTask.Id == task.Id) {
                subTask.ForecastStartDate__c = newStartDate;
                subTask.ForecastEndDate__c = newEndDate;
            }
        }

        return rollupDates(mapTasksById.get(task.pse__Parent_Task__c));
    } 

    public static void recalculateProjects(Set<Id> projectIds, Boolean force) {
        List<pse__Proj__c> projects = [select id, RevisedStartDate__c, RevisedEndDate__c, pse__Start_Date__c, pse__End_Date__c, (select id, pse__Start_Date__c, pse__End_Date__c from pse__Project_Tasks__r) from pse__Proj__c where id in :projectIds];

        List<pse__Proj__c> toUpdate = new List<pse__Proj__c>();

        List<WeeklyRollupEntry__c> toUpsert = new List<WeeklyRollupEntry__c>();
        
        List<pse__Time_Period__c> timePeriods = ECO_ProjectTaskService.calcTimePeriods;
        
        for (pse__Proj__c project : projects) { 
            Date newStartDate = null;
            Date newEndDate = null;

            System.debug('calculating project - ' + project);

            Integer i1 = 0;
            for (pse__Project_Task__c task : project.pse__Project_Tasks__r) {
                if ((newStartDate == null) || (task.pse__Start_Date__c < newStartDate)) {
                    newStartDate = task.pse__Start_Date__c;
                }

                if ((newEndDate == null) || (task.pse__End_Date__c > newEndDate)) {
                    newEndDate = task.pse__End_Date__c;
                }

                i1++;
            }

            System.debug('project task count - ' + i1);

            Boolean changed = false;

            // Uncommented by Sujit as per Michael, TODO: please review with Graham
            if (project.pse__Start_Date__c != newStartDate) {
                project.pse__Start_Date__c = newStartDate;
                changed = true;
            }

            // Uncommented by Sujit as per Michael, TODO: please review with Graham
            if (project.pse__End_Date__c != newEndDate) {
                project.pse__End_Date__c = newEndDate;
                changed = true;
            }

            if (project.RevisedStartDate__c != newStartDate) {
                project.RevisedStartDate__c = newStartDate;
                changed = true;
            }

            if (project.RevisedEndDate__c != newEndDate) {
                project.RevisedEndDate__c = newEndDate;
                changed = true;
            }

            if (changed) {
                toUpdate.add(project);
            }

//          newStartDate = (newStartDate < project.pse__Start_Date__c) ? newStartDate : project.pse__Start_Date__c;
//          newEndDate = (newEndDate > project.pse__End_Date__c) ? newEndDate : project.pse__End_Date__c;

            if (changed || force) {
                Integer i = 1;

                if (newStartDate == null)
                    continue;

                Date currentDate = newStartDate.toStartOfWeek();

//              for (Date currentDate = project.pse__Start_Date__c; currentDate <= project.pse__End_Date__c; currentDate = currentDate.addDays(7)) {
                while (currentDate <= newEndDate.addDays(7)) {
                    WeeklyRollupEntry__c rollup = new WeeklyRollupEntry__c(
                        Project__c = project.id,
                        CompositeKey__c = ECO_Service_Snapshots.DateToSnapshotKey(currentDate, project.id),
                        PeriodStartDate__c = ECO_Service_Snapshots.getFirstDateOfWeek(currentDate));
                    
                    // time period
                    if (rollup.PeriodStartDate__c != null){ 
                        pse__Time_Period__c fm = ECO_Utils_Date.getFiscalPeriod(rollup.PeriodStartDate__c, 0, timePeriods);  
                        if (fm != null){
                            rollup.FiscalMonth__c = fm.TimePeriodCode__c;
                        }
                    }   

                    toUpsert.add(rollup);
system.debug('toupsert----------'+toupsert);
                    if (i >= 500)
                        break;

                    i++;

                    currentDate = currentDate.addDays(7);
                }

                System.debug('spitting out - ' + i);
            }
        }   

        // Prevent project task triggers running recursivley TODO: Verify with michael
        run = false;
        update toUpdate;
       
        System.debug('upserting WeeklyRollupEntry(s) - ' + toUpsert);

        upsert toUpsert CompositeKey__c;
         run = true;
    }

    public static void recalculateProjectDates (List<pse__Project_Task__c> tNew) {
        if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('ECO_ProjectTask_AllEvents')) {
            return;
        }

        if (executedMethods.contains('recalculateProjectDates')) return;
        executedMethods.add('recalculateProjectDates');


        if (updatingBurden) {
            return;
        }

        Set<Id> projectIds = new Set<Id>();

        for (pse__Project_Task__c task : tNew) {
            if (task.pse__Project__c != null) {
                projectIds.add(task.pse__Project__c);
            }
        }

        recalculateProjects(projectIds, false);
    }

    public static void applyLookups(List<pse__Project_Task__c> tNew) {
        if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('ECO_ProjectTask_AllEvents')) {
            return;
        }

        if (executedMethods.contains('applyLookups')) return;
        executedMethods.add('applyLookups');

        Set<Id> projectIds = new Set<Id>();

        for (pse__Project_Task__c task : tNew) {
            projectIds.add(task.pse__Project__c);
        }

        List<pse__Proj__c> projects = [select id, CarryingOutOrganization__c, CarryingOutOrganization__r.OUID__c from pse__Proj__c where id in :projectIds];

        Map<Id, Id> projectMap = new Map<Id, Id>();
        Map<Id, String> projectMapString = new Map<Id, String>();

        for (pse__Proj__c project : projects) {
            projectMap.put(project.id, project.CarryingOutOrganization__c);
            projectMapString.put(project.id, project.CarryingOutOrganization__r.OUID__c);
        }

        Set<String> owningOrgs = new Set<String>();
        Map<String, List<pse__Project_Task__c>> owningOrgMap = new Map<String, List<pse__Project_Task__c>>();

        for (pse__Project_Task__c task : tNew) {
            task.CarryingOutOrganization__c = projectMap.get(task.pse__Project__c);

            String owningOrg = projectMapString.get(task.pse__Project__c);

            owningOrgs.add(owningOrg);

            List<pse__Project_Task__c> ptasks = owningOrgMap.get(owningOrg);

            if (ptasks == null) {
                ptasks = new List<pse__Project_Task__c>();

                owningOrgMap.put(owningOrg, ptasks);
            }

            ptasks.add(task);
        }

        List<BurdenReference__c> burdenReferences = [select id, OU_ID__c, Home_Field__c, OU_Schedule__c, Schedule__c, Ind_Rate_Sch_Id__c from BurdenReference__c where OU_ID__c in :owningOrgs];

        for (BurdenReference__c burdenReference : burdenReferences) {
            System.debug('burden reference - ' + burdenReference);

            List<pse__Project_Task__c> ptasks = owningOrgMap.get(burdenReference.OU_ID__c);

            for (pse__Project_Task__c task : ptasks) {
                String workType = task.WorkTypeName__c;

                if (workType == null)
                    continue;

                String homeField = burdenReference.Home_Field__c;

                if (homeField == null)
                    continue;

                System.debug('worktype - ' + workType);
                System.debug('homeField - ' + homeField);   

                if (workType.left(4).equalsIgnoreCase(homeField.left(4))) {  // both start with HOME or FIEL, found a match
                    task.Burden_Reference_Schedule_Name__c = burdenReference.OU_Schedule__c;
                    task.CostIndRateSCHID__c = burdenReference.Ind_Rate_Sch_Id__c;
                }
            }
        }
    }

    public static void copyCarryingOutToTask(List<pse__Project_Task__c> tNew) {
        if (copyingCarrying)
            return;

        if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('ECO_ProjectTask_AllEvents')) {
            return;
        }

        copyingCarrying = true;

        Set<Id> projectIds = new Set<Id>();

        for (pse__Project_Task__c task : tNew) {
            projectIds.add(task.pse__Project__c);
        }

        List<pse__Proj__c> projects = [select id, CarryingOutOrganization__c from pse__Proj__c where id in :projectIds];

        Map<Id, String> projectMap = new Map<Id, String>();

        for (pse__Proj__c project : projects) {
            projectMap.put(project.id, project.CarryingOutOrganization__c);
        }

        for (pse__Project_Task__c task : tNew) {
            task.CarryingOutOrganization__c = projectMap.get(task.pse__Project__c);
        }

        copyingCarrying = false;
    }

    public static void getScheduleName(List<pse__Project_Task__c> tNew) {
        if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('ECO_ProjectTask_AllEvents')) {
            return;
        }

        if (updatingBurden) {
            return;
        }

        updatingBurden = true;  // prevent recursion

        Set<Id> taskIds = new Set<Id>();

        for (pse__Project_Task__c task : tNew) {
            taskIds.add(task.id);
        }       

        //List<pse__Project_Task__c> tasks = [select TaskOrg__r.OrganizationString__r.OUID__c, WorkTypeName__c, Burden_Reference_Schedule_Name__c from pse__Project_Task__c where id in :taskIds];
        List<pse__Project_Task__c> tasks = [select CarryingOutOrganization__r.OUID__c, WorkTypeName__c, Burden_Reference_Schedule_Name__c from pse__Project_Task__c where id in :taskIds];

        Set<String> owningOrgs = new Set<String>();
        Map<String, pse__Project_Task__c> owningOrgMap = new Map<String, pse__Project_Task__c>();

        for (pse__Project_Task__c task : tasks) {
            //String owningOrg = task.TaskOrg__r.OrganizationString__r.OUID__c;
            String owningOrg = task.CarryingOutOrganization__r.OUID__c;

            System.debug('hey1 - ' + owningOrg + ' - ' + task);
            
            owningOrgs.add(owningOrg);

            owningOrgMap.put(owningOrg, task);
        }

        List<BurdenReference__c> burdenReferences = [select id, OU_ID__c, Home_Field__c, OU_Schedule__c, Schedule__c, Ind_Rate_Sch_Id__c from BurdenReference__c where OU_ID__c in :owningOrgs];

        List<pse__Project_Task__c> toUpdate = new List<pse__Project_Task__c>();

        for (BurdenReference__c burdenReference : burdenReferences) {
            System.debug('burden reference - ' + burdenReference);

            pse__Project_Task__c task = owningOrgMap.get(burdenReference.OU_ID__c);

            String workType = task.WorkTypeName__c;

            System.debug('herea');

            if (workType == null)
                continue;

            System.debug('hereb');

            String homeField = burdenReference.Home_Field__c;

            if (homeField == null)
                continue;

            System.debug('worktype - ' + workType);
            System.debug('homeField - ' + homeField);   

            if (workType.left(4).equalsIgnoreCase(homeField.left(4))) {  // both start with HOME or FIEL, found a match
                if (task.Burden_Reference_Schedule_Name__c == null) {
                    if (burdenReference.OU_Schedule__c == null) {
                        // same

                        System.debug('here1');
                    } else {
                        task.Burden_Reference_Schedule_Name__c = burdenReference.OU_Schedule__c;
                        task.CostIndRateSCHID__c = burdenReference.Ind_Rate_Sch_Id__c;

                        toUpdate.add(task);

                        System.debug('here2');
                    }
                } else {
                    if (burdenReference.OU_Schedule__c == null) {
                        task.Burden_Reference_Schedule_Name__c = null;
                        task.CostIndRateSCHID__c = null;

                        toUpdate.add(task);

                        System.debug('here3');
                    } else if (!task.Burden_Reference_Schedule_Name__c.equals(burdenReference.OU_Schedule__c)) {
                        task.Burden_Reference_Schedule_Name__c = burdenReference.OU_Schedule__c;
                        task.CostIndRateSCHID__c = burdenReference.Ind_Rate_Sch_Id__c;

                        toUpdate.add(task);

                        System.debug('here4');
                    } else {
                        // same

                        System.debug('here5');
                    }
                }
            }
        }

        update toUpdate;

        updatingBurden = false;
    }

    // TAL - I ripped this out of the trigger body and put it here...... but I didn't write it.
    public static void legacyCalcsFromTriggerBody (Boolean isBefore
                                                    , Boolean isInsert
                                                    , Boolean isUpdate
                                                    , Boolean isDelete
                                                    , Boolean isAfter
                                                    , List<pse__Project_Task__c> tNew
                                                    , List<pse__Project_Task__c> tOld
                                                    , Map<Id, pse__Project_Task__c> tOldMap) {
        
        if (!run) {
            return;
        }

        if (updatingBurden) {
            return;
        }
        
        if (executedMethods.contains('legacyCalcsFromTriggerBody')) return;
        executedMethods.add('legacyCalcsFromTriggerBody');

        Boolean isTriggerEnabled = ECO_TriggerSettings.getIsTriggerEnabled('ECO_ProjectTask_AllEvents');

         if (isBefore && isTriggerEnabled) {
    
            ECO_ProjectTaskValidator validator = new ECO_ProjectTaskValidator();
    
            //set any top level tasks to financial - to support creating from gantt
            if(isInsert){          
                validator.setTopTasksFinancial(tNew);
            }
    
            if (isInsert || isUpdate) {
                validator.validateForInsertAndUpdate(tNew, isUpdate); 
            }
    
    
            if(isDelete){
                validator.validateForDelete(tOld);           
            }
    
         }
    
        if(isAfter && isUpdate && isTriggerEnabled){
            Set<Id> tasksToSyncNow = new Set<Id>();
            Set<Id> tasksToSyncLater = new Set<Id>();
    
    
            for(pse__Project_Task__c newVersion : tNew){
                pse__Project_Task__c oldVersion = ( pse__Project_Task__c)tOldMap.get(newVersion.Id);
                if(oldVersion.OracleSyncStatus__c == 'S'){  //task has been succesfully synce with oracle
                    if(newVersion.IsChargeable__c && !oldVersion.IsChargeable__c ){
                        tasksToSyncNow.add(newVersion.Id);
                    }else if(!newVersion.IsChargeable__c && oldVersion.IsChargeable__c){
                        tasksToSyncLater.add(newVersion.Id);
                    }
                }
                
            }
    
            if(!tasksToSyncLater.isEmpty()){
                ECO_Service_ProjectSync.SetupSyncLaterTasks(tasksToSyncLater);
            }
    
            if(!tasksToSyncNow.isEmpty()){
                ECO_Service_ProjectSync.SetupSyncNowTasks(tasksToSyncNow);
                ECO_Service_ProjectSync.initiateTaskSyncNowProcessing();
            }
       
        }
    }
    
    
    public static void calculateEarnedValueSnaps (List<pse__Project_Task__c> newTasks) {
        if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('PT_CalcEV')) {
            return;
        }

        if (executedMethods.contains('calculateEarnedValueSnaps')) return;
        executedMethods.add('calculateEarnedValueSnaps');

        if (updatingBurden) {
            return;
        }
        
        List<EarnedValueSnapshot__c> evsToUpsert = new List<EarnedValueSnapshot__c>();
        List<EarnedValueSnapshot__c> evsToDelete = new List<EarnedValueSnapshot__c>();
        
        for (pse__Project_Task__c pt : [SELECT Id 
                                                , pse__Project__c
                                                , pse__Start_Date__c
                                                , pse__End_Date__c
                                                , TotalApprovedCost__c
                                                , EarnedValueCurve__c
                                                , TotalEstimateCost__c
                                                , (SELECT Id 
                                                        , ThisWeekNumber__c
                                                    FROM EarnedValueSnapshots__r)
                                    FROM pse__Project_Task__c 
                                    WHERE Id IN :newTasks]) {
                                        
            system.debug('EarnedValueCurve__c:  '+pt.EarnedValueCurve__c);
            
            Map<String, List<EarnedValueSnapshot__c>> returnedMap;
            
            try{
                if ('S Curve'.equalsIgnoreCase(pt.EarnedValueCurve__c)) {
                    returnedMap = ECO_Service_EarnedValue.calculateSCurveForTask(pt, pt.EarnedValueSnapshots__r);
                } else if ('Front Loaded'.equalsIgnoreCase(pt.EarnedValueCurve__c)) {
                    returnedMap = ECO_Service_EarnedValue.calculateFrontLoadedCurveForTask(pt, pt.EarnedValueSnapshots__r);
                } else if ('Even'.equalsIgnoreCase(pt.EarnedValueCurve__c)) {
                    returnedMap = ECO_Service_EarnedValue.calculateEvenCurveForTask(pt, pt.EarnedValueSnapshots__r);
                } else if ('Bell Shaped'.equalsIgnoreCase(pt.EarnedValueCurve__c)) {
                    returnedMap = ECO_Service_EarnedValue.calculateBellCurveForTask(pt, pt.EarnedValueSnapshots__r);
                } else if ('Back Loaded'.equalsIgnoreCase(pt.EarnedValueCurve__c)) {
                    returnedMap = ECO_Service_EarnedValue.calculateBackLoadedCurveForTask(pt, pt.EarnedValueSnapshots__r);
                }
            }
            catch(Exception ex){
                system.debug('Error: ' + ex);
            }
            
            if (returnedMap != null && returnedMap.get('Upsert') != null) {
                evsToUpsert.addAll(returnedMap.get('Upsert'));
            }
            
            if (returnedMap != null && returnedMap.get('Delete') != null) {
                evsToDelete.addAll(returnedMap.get('Delete'));
            }
        }
        
        if (!evsToUpsert.isEmpty()) {
            run = false;
            upsert evsToUpsert CompositeKey__c;
            run = true;
        }
        
        if (!evsToDelete.isEmpty()) {
            run = false;
            delete evsToDelete;
            run = true;
        }
    }
    
    public static void handleDefaultingTaskOwningCustomer(list<pse__Project_Task__c> projectTasks)
    {
        if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('PT_TaskOwning')) {
            return;
        }

        if (executedMethods.contains('handleDefaultingTaskOwningCustomer')) return;
        executedMethods.add('handleDefaultingTaskOwningCustomer');

        if (updatingBurden) {
            return;
        }
        
        map<Id, list<pse__Project_Task__c>> projectToProjectTaskMap = new map<Id, list<pse__Project_Task__c>>();
        for(pse__Project_Task__c projectTask:projectTasks)
        {
            if(projectToProjectTaskMap.get(projectTask.pse__Project__c) == null)
                projectToProjectTaskMap.put(projectTask.pse__Project__c, new list<pse__Project_Task__c>());
            projectToProjectTaskMap.get(projectTask.pse__Project__c).add(projectTask);
        }
        
        map<Id, Project_Site__c> projectSiteMap = new map<Id, Project_Site__c>();
        for(Project_Site__c projectSite:[select Id, Project__c from Project_Site__c where Is_Default_Top_Task__c = true and Project__c in :projectToProjectTaskMap.keyset()])
        {
            projectSiteMap.put(projectSite.Project__c, projectSite);
        }
        
        for(pse__Proj__c project:[select Id from pse__Proj__c where Id in :projectToProjectTaskMap.keyset() and EnableTopTaskCustomerFlag__c = true])
        {
            for(pse__Project_Task__c task:projectToProjectTaskMap.get(project.Id))
            {
                if(projectSiteMap.get(task.pse__Project__c) != null)
                    task.TopTaskOwningCustomer__c = projectSiteMap.get(task.pse__Project__c).Id; 
            }
        }
        
    }

    public static void replicateNewProjectTask(list<pse__Project_Task__c> lProjectTasks){
        if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('PROJTASK_BudgetReplicate')) {
            return;
        }

        if (executedMethods.contains('replicateNewProjectTask')) return;
        executedMethods.add('replicateNewProjectTask');

        //set<Id> lProjectsToQuery.add(oTask.Project__c) = new set<Id>();
        map<Id, list<pse__Project_Task__c>> mTasksByProjectId = new map<Id, list<pse__Project_Task__c>>();

        for(pse__Project_Task__c oTask : lProjectTasks){
            if(!mTasksByProjectId.containsKey(oTask.pse__Project__c))
                mTasksByProjectId.put(oTask.pse__Project__c, new list<pse__Project_Task__c>());

            mTasksByProjectId.get(oTask.pse__Project__c).add(oTask);
        }

        list<pse__Proj__c> lProjects = new list<pse__Proj__c>([SELECT Id,
                                                                      (SELECT Id
                                                                       FROM BudgetHeaders__r
                                                                       WHERE Status__c = :ECO_DTO_BudgetHeader.STATUS_ESTIMATE)
                                                               FROM pse__Proj__c
                                                               WHERE Id in :mTasksByProjectId.keySet()]);

        list<BudgetTask__c> lBudgetTasksToInsert = new list<BudgetTask__c>();

        for(pse__Proj__c oProject : lProjects){
            for(BudgetHeader__c oBudgetHeader : oProject.BudgetHeaders__r){
                for(pse__Project_Task__c oProjectTask : mTasksByProjectId.get(oProject.Id)){
                    BudgetTask__c oBudgetTaskToInsert = new BudgetTask__c();
                    oBudgetTaskToInsert.ProjectTask__c = oProjectTask.Id;
                    oBudgetTaskToInsert.BudgetHeader__c = oBudgetHeader.Id;
                    oBudgetTaskToInsert.TaskName__c = oProjectTask.Name;

                    lBudgetTasksToInsert.add(oBudgetTaskToInsert);
                }
            }
        }

        if(lBudgetTasksToInsert.size() > 0){
            insert lBudgetTasksToInsert;
        }
    }

    public static void handleRemovingAssociatedFunding(list<pse__Project_Task__c> projectTasks)
    {
        if (executedMethods.contains('handleRemovingAssociatedFunding')) return;
        executedMethods.add('handleRemovingAssociatedFunding');

        List<Id> projectTaskIds = new List<Id>();
        for(pse__Project_Task__c projectTask:projectTasks)
        {
            if(!projectTask.ChangeManagerIsNew__c)
                projectTask.addError('This task has been sycned to Oracle.  You are not allowed to delete this task.');
            projectTaskIds.add(projectTask.Id);
        }

        list<Funding__c> fundings = [select Id from Funding__c where ProjectTask__c in :projectTaskIds];

        if(!fundings.isEmpty())
            delete fundings;
    }
    
    public static void calculateFiscalMonths(list<pse__Project_Task__c> projectTasks)
    {
        if (executedMethods.contains('calculateFiscalMonths')) return;
        executedMethods.add('calculateFiscalMonths');
        
        list<date> enddatelist = new list<date>();
        for (pse__Project_Task__c ba : projectTasks){
             if (ba.pse__End_Date__c != null){ 
                 
                 enddatelist.add((ba.pse__End_Date__c).addmonths(2));
                 enddatelist.add((ba.pse__End_Date__c).addmonths(-3));
             }
        }
        system.debug('enddatelist----'+enddatelist);
         List<pse__Time_Period__c> timePeriods  = new  List<pse__Time_Period__c>();
        if(enddatelist.size()>0)
        {
            // Time period
          timePeriods = ECO_Utils_Date.calcTimePeriods(enddatelist,'Month');
        // Time period
       // List<pse__Time_Period__c> timePeriods = ECO_ProjectTaskService.calcTimePeriods;
        
        pse__Time_Period__c fm = null;
        for (pse__Project_Task__c pt : projectTasks){
            if (pt.pse__End_Date__c != null){   
                fm = ECO_Utils_Date.getFiscalPeriod(pt.pse__End_Date__c, 0, timePeriods);  
                if (fm != null){
                    pt.EndDateFiscalMonth__c = fm.TimePeriodCode__c;
                }
                
                fm = ECO_Utils_Date.getFiscalPeriod(pt.pse__End_Date__c, 1, timePeriods);  
                if (fm != null){
                    pt.EndDatePreviousFiscalMonth__c = fm.TimePeriodCode__c;
                }
            }
        }
    }
    }
}