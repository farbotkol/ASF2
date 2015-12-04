/* Author: Sujit Kumar
 *
 * Rebuild (refactor) the EVR screen July 2015
 */
public with sharing class ECO_EarnedValueReport2Controller {
        
        public Boolean hasNextWeek  { get; set; }
        
        public Boolean hasPrevWeek  { get; set; }
        
        public pse__Proj__c Project { get; set; }
        
        public Id projectId { get; set; }
        
        public List<ProjectTaskWrapper> availableTasks { get; set; }
        
        public Integer numAvailableTasks { get; set; }
        
        public String chartJSON  { get; set; }
        
    public String cpiAndSpiJSON { get; set; }
    
    public Boolean isEdit {get; private set;}
    
    public EarnedValueHeader__c evhRecord { get; set; }
    
    public Date selectedSnapshotDate { get; set; }
    
    public List<SelectOption> startOfWeekDatesBetweenProjectStartAndEndDates { get; set; }

    public List<SelectOption> projectTeamMembers {get; set;}
    public List<SelectOption> projectTeamMembersForAssign {get; set;}

    public String filterProjectTeamMember {get; set;}
    
    public static final String UNSAVED = 'Unsaved';
    
    public static final String IN_PROGRESS = 'In-progress';
    
    public static final String COMMITTED = 'Committed';
  
    
    /*
     * Returns a map with key-value pairs where the
     *       Key is: Week Name MM/DD/YYYY
     *       Value is: Saved State
     *          where Saved States are: Unsaved, In-progress and Committed
     *
     *  Algorithm of this method:
     *      Run a SOQL to get all the EVHs for the current project
     *      If no EVTs exist for a given report (EVH), set the saved state for that report to 'Unsaved'
     *      For each evh, if there is any EVT with the Committed__c field set to true then
     *         set the saved state to 'Committed', otherwise just set it to 'In-progress'
     */
     public Map<String, String> findCurrentSavedStateOfEachReport(List<String> startOfWeekDates) {
        Map<String, String> mapOfReportNameToItsCurrentSavedState = new Map<String, String>();
        
        List<EarnedValueHeader__c> listOfAllEVHsForThisProject = [        
                                                                SELECT Id, 
                                                                           Project__c, 
                                                                           ReportName__c, 
                                                                           Comments__c, 
                                                                           SnapshotDate__c
                                                                FROM EarnedValueHeader__c
                                                                WHERE Project__c = :projectId
                                                        ];
        
        // Initialize the state to UNSAVED for every report                                                                             
        for (EarnedValueHeader__c eachEVH : listOfAllEVHsForThisProject) {
                mapOfReportNameToItsCurrentSavedState.put(eachEVH.ReportName__c, UNSAVED);
        }
                                                                                                        
                // Find all reports for the project with report names between start and end of project                                                                                                          
        Map<ID, EarnedValueHeader__c> mapOfEVHs = new Map<ID, EarnedValueHeader__c>([       
                                                                                                        SELECT Id, 
                                                                                                                   Project__c, 
                                                                                                                   ReportName__c, 
                                                                                                                   Comments__c, 
                                                                                                                   SnapshotDate__c
                                                                                                        FROM EarnedValueHeader__c
                                                                                                        WHERE Project__c = :projectId
                                                                                                        AND ReportName__c in :startOfWeekDates]);
                                                                                
                // For the reports, find all EVTs that are NOT Committed
                List<EarnedValueTask__c> listOfInProgressEVTs = [ select  Id, 
                                                                                                                        EarnedValueHeader__c, 
                                                                                                                        EarnedValueHeader__r.ReportName__c, 
                                                                                                                        Committed__c 
                                                                                                        from EarnedValueTask__c 
                                                                                                        where EarnedValueHeader__c in :mapOfEVHs.keySet() 
                                                                                                        and Committed__c = false];
                for (EarnedValueTask__c eachEVT : listOfInProgressEVTs) {
                        mapOfReportNameToItsCurrentSavedState.put(eachEVT.EarnedValueHeader__r.ReportName__c, IN_PROGRESS);
                }       
                                                                                                                
                // For the above reports, find all EVTs that are Committed                                                                                              
        List<EarnedValueTask__c> listOfCommittedEVTs = [  select  Id, 
                                                                                                                                EarnedValueHeader__c, 
                                                                                                                                EarnedValueHeader__r.ReportName__c, 
                                                                                                                                Committed__c 
                                                                                                                from EarnedValueTask__c 
                                                                                                                where EarnedValueHeader__c in :mapOfEVHs.keySet() 
                                                                                                                and Committed__c = true];
                for (EarnedValueTask__c eachEVT : listOfCommittedEVTs) {
                        mapOfReportNameToItsCurrentSavedState.put(eachEVT.EarnedValueHeader__r.ReportName__c, COMMITTED);
                }       

                System.debug('mapOfReportNameToItsCurrentSavedState: ' + mapOfReportNameToItsCurrentSavedState);        
        return mapOfReportNameToItsCurrentSavedState;
     }
     
     
        /*
     *  Go to the most recent week with an earned value entry in it. 
         *  If none exists start on the first week of the project based on actual start date
     */
        public EarnedValueHeader__c getDefaultReport() {
                List<EarnedValueHeader__c> listOfEVRs = [ SELECT Id, 
                                                                                                                   Project__c, 
                                                                                                                   ReportName__c, 
                                                                                                                   Comments__c, 
                                                                                                                   SnapshotDate__c
                                                                                                FROM EarnedValueHeader__c
                                                                                                WHERE Project__c = :projectId
                                                                                                AND SnapshotDate__c != null
                                                                                                order by SnapshotDate__c desc];
        if (!listOfEVRs.isEmpty()) {
                EarnedValueHeader__c existingReport = listOfEVRs.get(0);
                selectedSnapshotDate = existingReport.SnapshotDate__c;
                System.debug('found default report!');
                return existingReport;
        }
        
        System.debug('Could not find any report for project: ' + project.Name + ', creating a new one!');
        // if no EVR exists, go and create one using a snapshot as of the project start date 
        EarnedValueHeader__c newEVR = new EarnedValueHeader__c();
        newEVR.Project__c = projectId;
        newEVR.SnapshotDate__c = project.pse__Start_Date__c.toStartofWeek();
//        newEVR.ReportName__c = ECO_Utils_Date.formatDateAsMMSlashDDSlashYYYY(newEVR.SnapshotDate__c);
        newEVR.ReportName__c = newEVR.SnapshotDate__c.format();
        selectedSnapshotDate = newEVR.SnapshotDate__c;
        return newEVR;
        }
        
        
        /*
     *  Go to the week of the snapshot date and find the report for that week & return that
         *  If none exists create a new report for that week start date and return that report
     */ 
        public EarnedValueHeader__c getReportForSnapshotDate(Date weekStartDate) {
                List<EarnedValueHeader__c> listOfEVRs = [ SELECT Id, 
                                                                                                                   Project__c, 
                                                                                                                   ReportName__c, 
                                                                                                                   Comments__c, 
                                                                                                                   SnapshotDate__c
                                                                                                FROM EarnedValueHeader__c
                                                                                                WHERE Project__c = :projectId
                                                                                                AND SnapshotDate__c = :weekStartDate
                                                                                        ];
        if (!listOfEVRs.isEmpty()) {
                EarnedValueHeader__c existingReport = listOfEVRs.get(0);
                selectedSnapshotDate = existingReport.SnapshotDate__c;
                System.debug('found report for week start date of ' + weekStartDate);
                return existingReport;
        }
        
        System.debug('Could not find any report for project: ' + project.Name + ', for week start date: ' + weekStartDate + ', creating a new one!');
        // if no EVR exists, go and create one using a snapshot as of the project start date 
        EarnedValueHeader__c newEVR = new EarnedValueHeader__c();
        newEVR.Project__c = projectId;
        newEVR.SnapshotDate__c = weekStartDate;
        DateTime startDateTime = DateTime.newInstance(newEVR.SnapshotDate__c, Time.newInstance(0,0,0,0));
        newEVR.ReportName__c = startDateTime.format('MM/dd/yyyy');
        selectedSnapshotDate = newEVR.SnapshotDate__c;
        return newEVR;          
        }
        
        
        /*
         *  Sets 2 flags: hasNextWeek and hasPrevWeek
         *  If 7 days after selectedSnapshotDate goes beyond start of week of project end date, set hasNextWeek to false
         *  If 7 days before selectedSnapshotDate is earlier than start of week of project start date, set hasPrevWeek to false
         */
        public void setFlagsForScrollingByWeek() {
                // System.debug('In setFlagsForScrollingByWeek, selectedSnapshotDate: ' + selectedSnapshotDate);
                Date nextWeekDate = selectedSnapshotDate.addDays(7);
                
                Date startOfWeekOfProjectEndDate = project.pse__End_Date__c.toStartofWeek();
                // System.debug('In setFlagsForScrollingByWeek, startOfWeekOfProjectEndDate: ' + startOfWeekOfProjectEndDate);
                // System.debug('In setFlagsForScrollingByWeek, nextWeekDate: ' + nextWeekDate);
                if (nextWeekDate > startOfWeekOfProjectEndDate) {
                        hasNextWeek = false;
                } else {
                        hasNextWeek = true;
                }
                // System.debug('In setFlagsForScrollingByWeek, hasNextWeek: ' + hasNextWeek);
                
                Date prevWeekDate = selectedSnapshotDate.addDays(-7);
                Date startOfWeekOfProjectStartDate = project.pse__Start_Date__c.toStartofWeek();
                // System.debug('In setFlagsForScrollingByWeek, startOfWeekOfProjectStartDate: ' + startOfWeekOfProjectStartDate);
                // System.debug('In setFlagsForScrollingByWeek, prevWeekDate: ' + prevWeekDate);
                if (prevWeekDate < startOfWeekOfProjectStartDate) {
                        hasPrevWeek = false;
                } else {
                        hasPrevWeek = true;
                }
                // System.debug('In setFlagsForScrollingByWeek, hasPrevWeek: ' + hasPrevWeek);
        }
        
        /*
         *  Returns the start of week dates between:
         *    start of week of project start date
         *    and
         *    start of week of project end date.
         */
        public List<String> getStartOfWeekDatesBetweenProjectStartAndEndDates() {
                System.debug('In getStartOfWeekDatesBetweenProjectStartAndEndDates');
                List<String> listOfStartOfWeekDatesBetweenProjectStartAndEndDates = new List<String>();
                
                System.debug('setting firstWeekStartDate, pse start date: ' + project.pse__Start_Date__c);
                System.debug('setting lastWeekStartDate, pse end date: ' + project.pse__End_Date__c);
                Date firstWeekStartDate = project.pse__Start_Date__c.toStartofWeek();
                Date lastWeekStartDate = project.pse__End_Date__c.toStartofWeek();
                
                startOfWeekDatesBetweenProjectStartAndEndDates = new List<SelectOption>();
                Date currentWeekStartDate = firstWeekStartDate;
                while (currentWeekStartDate <= lastWeekStartDate) {
                        System.debug('In getStartOfWeekDatesBetweenProjectStartAndEndDates, inside loop');
                        //String dateAsMMSlashDDSlashYYYY = ECO_Utils_Date.formatDateAsMMSlashDDSlashYYYY(currentWeekStartDate);
                        String dateAsMMSlashDDSlashYYYY = currentWeekStartDate.format();
                        listOfStartOfWeekDatesBetweenProjectStartAndEndDates.add(dateAsMMSlashDDSlashYYYY);      
                        currentWeekStartDate = currentWeekStartDate.addDays(7);
                }
                System.debug('All start of week dates: ' + listOfStartOfWeekDatesBetweenProjectStartAndEndDates);
                return listOfStartOfWeekDatesBetweenProjectStartAndEndDates;
        }
        
        
        /*
         *  Populates SelectOption for the list of reports to be shown in a dropdown list on the UI
         */
        public void initStartOfWeekDatesBetweenProjectStartAndEndDates() {
                System.debug('In initStartOfWeekDatesBetweenProjectStartAndEndDates');
                List<String> startOfWeekDates = getStartOfWeekDatesBetweenProjectStartAndEndDates();
                Map<String, String> mapOfReportLabelToReportSavedState = findCurrentSavedStateOfEachReport(startOfWeekDates);
                for (String eachDate : startOfWeekDates) {
                        String valueOfSelectOption = eachDate + ' (' + UNSAVED + ')';
                        if (mapOfReportLabelToReportSavedState.containsKey(eachDate)) {
                                valueOfSelectOption = eachDate + ' (' + mapOfReportLabelToReportSavedState.get(eachDate) + ')';
                        }
                        startOfWeekDatesBetweenProjectStartAndEndDates.add(new SelectOption(eachDate, valueOfSelectOption));
                }
                System.debug('All start of week dates: ' + startOfWeekDatesBetweenProjectStartAndEndDates);
        }
        
        
        public void moveForwardByAWeek() {
                moveByNDays(7);
        }

        
        public void moveBackwardByAWeek() {
                moveByNDays(-7);
        }
        
        
        /*
         *         Add/Subtract N days to selectedSnapshotDate
         *         If date is after/before current project end/start date, disable going forward/backward by setting booleans
         *         After adding or subtracting n days, check if there is an EVHeader with the date name as the name of the report
         *         If none exists, create it. If one already exists, load the EVRs for that report.
         *      
         */
        public void moveByNDays(Integer nDays) {
                Date futureStartOfWeekDate = selectedSnapshotDate.addDays(nDays);
                moveToSnapshotDate(futureStartOfWeekDate);
        }
        
        
        /*
         *         Check if there is an EVHeader with the date name as the name of the report
         *         If none exists, create it. If one already exists, load the EVRs for that report.
         *      
         */
        public void moveToSelectedSnapshotDate() {
                moveToSnapshotDate(selectedSnapshotDate);
        }
        
        
        /*
         *         Check if there is an EVHeader with the date name as the name of the report
         *         If none exists, create it. If one already exists, load the EVRs for that report.
         *      
         */
        public void moveToSnapshotDate(Date futureStartOfWeekDate) {
                evhRecord = getReportForSnapshotDate(futureStartOfWeekDate);
                if (evhRecord.Id == null) {
                        System.debug('selectedSnapshotDate: ' + selectedSnapshotDate);
                        System.debug('no report found for date: ' + futureStartOfWeekDate + ', inserting a new report');
                        insert evhRecord;
                }
                isEdit = false;
                availableTasks = getProjectTasksForSnapshotDate();
                numAvailableTasks = availableTasks.size();
                setFlagsForScrollingByWeek();
        }
        
        
        public ECO_EarnedValueReport2Controller(ApexPages.StandardController stdController) {
                filterProjectTeamMember = '-1';  // All

                projectId = stdController.getId();
                project = [select Name, ProjectSectionHeaderName__c, pse__Start_Date__c, pse__End_Date__c, EVRulesGuidelines__c from pse__Proj__c where Id = :projectId];
        }
        
        
        /*
         *  On Load: Query all Project Tasks and have a Child Query for Earned Value Task where
         *      Project Tasks is related to Project and Earned Value Task is of the Selected Week.
         *      Then merge Project Task with Earned Value Task
         * 
         */
        public void init() {
                List<ProjectTeamMember__c> members = [select Contact__r.pse__Salesforce_User__c, name from ProjectTeamMember__c where active__c = true and Project__c = :projectId order by name];

                projectTeamMembers = new List<SelectOption>();
                projectTeamMembersForAssign = new List<SelectOption>();

                SelectOption option = new SelectOption('-1', 'All');
                projectTeamMembers.add(option);

                option = new SelectOption('0', 'Not Assigned');
                projectTeamMembers.add(option);

                option = new SelectOption('', 'Not Assigned');
                projectTeamMembersForAssign.add(option);

                for (ProjectTeamMember__c member : members) {
                    if (member.Contact__r.pse__Salesforce_User__c == null)
                        continue;

                    if (member.name == null)
                        continue;
                    
                    option = new SelectOption(member.Contact__r.pse__Salesforce_User__c, member.name);
                    projectTeamMembers.add(option);
                    projectTeamMembersForAssign.add(option);
                }

                if (project.pse__Start_Date__c == null) {
                        throw new ECO_EarnedvalueReportControllerException('Project start date cannot be empty!');
                }
                if (project.pse__End_Date__c == null) {
                        throw new ECO_EarnedvalueReportControllerException('Project end date cannot be empty!');
                }
                
                initStartOfWeekDatesBetweenProjectStartAndEndDates();
                
                evhRecord = getDefaultReport();
                setFlagsForScrollingByWeek();
                
                if (evhRecord.Id == null) {
                        System.debug('Inserting a new report for date: ' + selectedSnapshotDate);
                        insert evhRecord;
                }
                isEdit = false;
                
                availableTasks = getProjectTasksForSnapshotDate();
                numAvailableTasks = availableTasks.size();

                chartJSON = createEarnedValueGoogleChartJSON();
        cpiAndSpiJSON = createCpiAndSpiGoogleChartJSON();
        }
        
        
        private List<ProjectTaskWrapper> getProjectTasksForSnapshotDate() {
                Date snapShotDate = evhRecord.SnapshotDate__c;
                Id reportId = evhRecord.Id;
                Datetime startOfTime = DateTime.newInstance(1900, 1 , 1);
                List<pse__Project_Task__c> tasks = ECO_Service_ProjectSync.GetOracleProjectTaskRecordsforProjectAndReport(projectId, reportId, startOfTime, snapShotDate);
                
        Map<Id, Decimal> priorWeekMapOfTaskIdToPercentComplete = getPriorWeekMapOfTaskIdToPercentComplete();
        
        List<ProjectTaskWrapper> results = new List<ProjectTaskWrapper>();
        for (pse__Project_Task__c task : tasks) {
                if (task.Earned_Value_Tasks__r == null || task.Earned_Value_Tasks__r.size() == 0) {
                        ProjectTaskWrapper wrapper = new ProjectTaskWrapper();
                        wrapper.earnedValueTask = new EarnedValueTask__c();
                        wrapper.earnedValueTask.ProjectTask__c = task.Id;
                        wrapper.earnedValueTask.EarnedValueHeader__c = reportId;
                        wrapper.earnedValueTask.SnapshotDate__c = snapShotDate;
                        wrapper.task = task;
                        wrapper.isSelected = true;
                                wrapper.disableSelect = true;
                        wrapper.notifyOwnerOnCreate = false;
                        if (wrapper.earnedValueTask.PercentComplete__c == null) wrapper.earnedValueTask.PercentComplete__c = 0.00;
                        if (wrapper.task.TotalApprovedCost__c != null && wrapper.earnedValueTask.PercentComplete__c != null) {
                                Decimal calcEarnedValue = wrapper.task.TotalApprovedCost__c * (wrapper.earnedValueTask.PercentComplete__c / 100);                                               
                                wrapper.earnedValue = calcEarnedValue.setScale(2);
                        }
                        if (priorWeekMapOfTaskIdToPercentComplete.containsKey(task.Id)) {
                                wrapper.priorComplete = priorWeekMapOfTaskIdToPercentComplete.get(task.Id);
                        } else {
                                wrapper.priorComplete = 0;
                        }
                                wrapper.canEdit = true;

                                if (filterProjectTeamMember.equals('-1')) {  // All
                                    results.add(wrapper);   
                                } else if (filterProjectTeamMember.equals('0')) {  // Not assigned
                                    if (task.ProjectTaskOwner__c == null) {
                                        results.add(wrapper);   
                                    }
                                } else {  // specific request
                                    if (task.ProjectTaskOwner__c != null) {
                                        if (task.ProjectTaskOwner__c.equals(filterProjectTeamMember)) {
                                            results.add(wrapper);   
                                        }
                                    }
                                }
                } else {
                        for (EarnedValueTask__c evTask : task.Earned_Value_Tasks__r) {
                                ProjectTaskWrapper wrapper = new ProjectTaskWrapper();
                                wrapper.task = task;
                                wrapper.isSelected = true;
                                        wrapper.disableSelect = true;
                                wrapper.earnedValueTask = evTask;
                                wrapper.notifyOwnerOnCreate = evTask.NotifyTaskOwner__c;
                                wrapper.earnedValue = 0.00;
                                if (wrapper.earnedValueTask.PercentComplete__c == null) wrapper.earnedValueTask.PercentComplete__c = 0.00;
                                if (wrapper.task.TotalApprovedCost__c != null && wrapper.earnedValueTask.PercentComplete__c != null) {
                                        Decimal calcEarnedValue = wrapper.task.TotalApprovedCost__c * (wrapper.earnedValueTask.PercentComplete__c / 100);                                               
                                        wrapper.earnedValue = calcEarnedValue.setScale(2);
                                }
                                if (priorWeekMapOfTaskIdToPercentComplete.containsKey(task.Id)) {
                                        wrapper.priorComplete = priorWeekMapOfTaskIdToPercentComplete.get(task.Id);
                                } else {
                                        wrapper.priorComplete = 0;
                                }
                                        wrapper.canEdit = true;

                                        if (filterProjectTeamMember.equals('-1')) {  // All
                                            results.add(wrapper);   
                                        } else if (filterProjectTeamMember.equals('0')) {  // Not assigned
                                            if (task.ProjectTaskOwner__c == null) {
                                                results.add(wrapper);   
                                            }
                                        } else {  // specific request
                                            if (task.ProjectTaskOwner__c != null) {
                                                if (task.ProjectTaskOwner__c.equals(filterProjectTeamMember)) {
                                                    results.add(wrapper);   
                                                }
                                            }
                                        }
                        } // end of for loop of ev tasks for each project task
                }
        } // end of for loop of tasks
        return results;
    }
        
    public PageReference returnToProject(){
        PageReference pageRef = new PageReference('/' + projectId);
        pageRef.setRedirect(true);
        return pageRef;
    }


    
    
    private void calculateEarnedValueForAllAvailableTasks() {
        for (ProjectTaskWrapper ptw : availableTasks) {                 
                System.debug('TotalApprovedCost__c: ' + ptw.task.TotalApprovedCost__c);
                System.debug('PercentComplete__c: ' + ptw.earnedValueTask.PercentComplete__c);
                if (ptw.task.TotalApprovedCost__c != null && ptw.earnedValueTask.PercentComplete__c > 0) {           
                        Decimal earnedValueForTask = ptw.task.TotalApprovedCost__c * (ptw.earnedValueTask.PercentComplete__c / 100);
                        ptw.earnedValue = earnedValueForTask.setScale(2, RoundingMode.HALF_UP);
                }
        }
    }

    private String createEarnedValueGoogleChartJSON(){  
        list<WeeklyRollupEntry__c> lWeeklyRollupEntries = new list<WeeklyRollupEntry__c>([SELECT id
                                                                                                                                                                                   , PeriodStartDate__c
                                                                                                                                                                                   , AppliedApprovedCost__c
                                                                                                                                                                                   , ProjectFunctionalBurdenedCost__c
                                                                                                                                                                                   , EarnedValue__c
                                                                                                                                                                         FROM WeeklyRollupEntry__c 
                                                                                                                                                                         WHERE Project__c = :projectId]);

        List<EarnedValueHeader__c> listOfEVRs = [SELECT Id 
                                                                                                          , SnapshotDate__c
                                                                                                          , (SELECT id
                                                                                                                      , TrendEAC1__c
                                                                                                                  , TrendEAC2__c
                                                                                                             FROM Earned_Value_Tasks__r
                                                                                                            )
                                                                                                 FROM EarnedValueHeader__c
                                                                                                 WHERE Project__c = :projectId
                                                                                                 AND SnapshotDate__c != null
                                                                                                 ORDER BY SnapshotDate__c DESC];
        Decimal dTrendEAC1 = 0;
        Decimal dTrendEAC2 = 0;

        if (!listOfEVRs.isEmpty()) {
                EarnedValueHeader__c existingReport = listOfEVRs.get(0);

                for(EarnedValueTask__c oEarnedValueTask : existingReport.Earned_Value_Tasks__r){
                        dTrendEAC1 += ECO_Utils_String.NullCheck(oEarnedValueTask.TrendEAC1__c);
                        dTrendEAC2 += ECO_Utils_String.NullCheck(oEarnedValueTask.TrendEAC2__c);
                }
        }

        String sTrendEAC1 = String.valueOf(dTrendEAC1);
        String sTrendEAC2 = String.valueOf(dTrendEAC2);

        list<list<String>> lResults = new list<list<String>>();

        for(WeeklyRollupEntry__c oWeeklyRollupEntry : lWeeklyRollupEntries){
                list<String> lResultLine = new list<String>();

                lResultLine.add(String.valueOf(oWeeklyRollupEntry.PeriodStartDate__c));
                lResultLine.add(String.valueOf(ECO_Utils_String.NullCheck(oWeeklyRollupEntry.AppliedApprovedCost__c)));
                lResultLine.add(String.valueOf(ECO_Utils_String.NullCheck(oWeeklyRollupEntry.ProjectFunctionalBurdenedCost__c)));
                lResultLine.add(String.valueOf(ECO_Utils_String.NullCheck(oWeeklyRollupEntry.EarnedValue__c)));
                lResultLine.add(sTrendEAC1);
                lResultLine.add(sTrendEAC2);

                lResults.add(lResultLine);
        }

        return JSON.serialize(lResults);
    }

    private String createCpiAndSpiGoogleChartJSON(){    
        list<WeeklyRollupEntry__c> lWeeklyRollupEntries = new list<WeeklyRollupEntry__c>([SELECT id
                                                                                                                                                                                   , PeriodStartDate__c
                                                                                                                                                                                   , SPI__c
                                                                                                                                                                                   , CPI__c
                                                                                                                                                                         FROM WeeklyRollupEntry__c 
                                                                                                                                                                         WHERE Project__c = :projectId]);

        list<list<String>> lResults = new list<list<String>>();

        for(WeeklyRollupEntry__c oWeeklyRollupEntry : lWeeklyRollupEntries){
                list<String> lResultLine = new list<String>();

                lResultLine.add(String.valueOf(oWeeklyRollupEntry.PeriodStartDate__c));
                lResultLine.add(String.valueOf(ECO_Utils_String.NullCheck(oWeeklyRollupEntry.CPI__c)));
                lResultLine.add(String.valueOf(ECO_Utils_String.NullCheck(oWeeklyRollupEntry.SPI__c)));

                lResults.add(lResultLine);
        }

        return JSON.serialize(lResults);
    }

        /*
         *      On Save: Upsert the Earned Value Tasks if they have a percent complete value entered. 
         *      If they have a null value for percent complete don't insert.
         */
    public void saveEarnedValueTasksForSnapshot(){
        saveEarnedValueTasksForSnapshot(true);
    }
        
        /*
         *      On Save: Upsert the Earned Value Tasks if they have a percent complete value entered. 
         *      If they have a null value for percent complete don't insert.
         *  parameter Boolean saveOnly if set to true implies just save and no commit
         *  parameter Boolean saveOnly if set to false implies a save followed by a commit
         */
    public void saveEarnedValueTasksForSnapshot(Boolean saveOnly){
        Savepoint sp = Database.setSavepoint();

        try {
            List<pse__Project_Task__c> tasksToSave = new List<pse__Project_Task__c>();

            for (ProjectTaskWrapper wrapper : availableTasks) {
                tasksToSave.add(wrapper.task);
            }

            update tasksToSave;
        } catch (Exception e) {
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error has occurred while saving! ' + e.getMessage()));
            throw e;
        }
        
        try {                   
                List<EarnedValueTask__c> evTasksToSave = getAvailableTasksUserCanAccess();
                calculateEarnedValueForAllAvailableTasks();
                if(!evTasksToSave.isEmpty()){
                                upsert evTasksToSave;
                                
                                if (saveOnly) {
                                        chartJSON = createEarnedValueGoogleChartJSON();
                                cpiAndSpiJSON = createCpiAndSpiGoogleChartJSON();
                                }                       
                }
                
                if (saveOnly) ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Changes successfully saved!' ));
        } catch(Exception e) {
                Database.rollback(sp);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error has occurred while saving! ' + e.getMessage()));
                throw e;
        }
        
        try {
            Decimal dEarnedValue = 0;
            for(ProjectTaskWrapper oPTW : availableTasks){
               dEarnedValue += ECO_Utils_String.NullCheck(oPTW.earnedValue);
            }
 
            WeeklyRollupEntry__c rollup = new WeeklyRollupEntry__c();
            rollup.Project__c = project.id;
            rollup.CompositeKey__c = ECO_Service_Snapshots.DateToSnapshotKey(selectedSnapshotDate, project.id);
            rollup.PeriodStartDate__c = ECO_Service_Snapshots.getFirstDateOfWeek(selectedSnapshotDate);
            rollup.EarnedValue__c = dEarnedValue;
            System.debug('rollup: ' + rollup);
            upsert rollup CompositeKey__c;
        } catch(Exception e) {
                Database.rollback(sp);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error has occurred while saving! ' + e.getMessage()));
                throw e;
        }

        if (saveOnly) init();
    }
    
    public void commitEarnedValueTasksForSnapshot() {
        saveEarnedValueTasksForSnapshot(false);
        
        Savepoint sp = Database.setSavepoint();
        try{
                evhRecord.Committed__c = true;
                upsert evhRecord;
                
            List<EarnedValueTask__c> evTasksToCommit = getAvailableTasksUserCanAccess();
            if(!evTasksToCommit.isEmpty()){
                Boolean tasksOK = true;
                for(EarnedValueTask__c evTask : evTasksToCommit){
                    if(evTask.PercentComplete__c == null){
                        throw new ECO_EarnedvalueReportControllerException('Percent complete for task ' + evTask.ProjectTask__r.Name + ' cannot be empty!');
                    }
                }             
            }
            System.debug('found ' + evTasksToCommit.size() + ' tasks to commit');

                if(!evTasksToCommit.isEmpty()){
                                for(EarnedValueTask__c evTask : evTasksToCommit){
                                evTask.Committed__c = true;
                        }
                        System.debug('Committing ' + evTasksToCommit.size() + ' tasks!');
                                update evTasksToCommit;

                                chartJSON = createEarnedValueGoogleChartJSON();
                        cpiAndSpiJSON = createCpiAndSpiGoogleChartJSON();
                        //rerenderChart = true;
                }

                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Changes successfully committed!' ));

        } catch(Exception e) {
                Database.rollback(sp);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error has occurred while committing changes! ' + e.getMessage()));
        }

        init();
    }

    private List<EarnedValueTask__c> getAvailableTasksUserCanAccess() {
        List<EarnedValueTask__c> results = new List<EarnedValueTask__c>();
            for(ProjectTaskWrapper wrapper : availableTasks){
                if(wrapper.canEdit){    //user can access task
                        if(!wrapper.earnedValueTask.Committed__c){      //if input already committed skip it                                    
                                        results.add(wrapper.earnedValueTask);
                        }
                }                       
            }
            return results;
    }

    private Map<Id, EarnedValueTask__c> getAllEarnedValueTasksByProjectTaskForReport(String reportName){
        Map<Id, EarnedValueTask__c> results = new Map<Id, EarnedValueTask__c>();
        
        List<EarnedValueHeader__c> reports = [Select Id from EarnedValueHeader__c where ReportName__c = :reportName and Project__c = :projectId limit 1];
        if (!reports.isEmpty()) {
                System.debug('found EVH for report name: ' + reportName);
                Id evHeaderId = reports.get(0).Id;
                List<EarnedValueTask__c> allEVTasks =     [       SELECT Id,
                                                                                                                        PercentComplete__c,
                                                                                                                        ProjectTask__c,
                                                                                                                        ProjectTask__r.Name,
                                                                                                                        TaskName__c,
                                                                                                                        NotifyTaskOwner__c,
                                                                                                                        Comments__c,
                                                                                                                        Committed__c,
                                                                                                                        CostAccruals__c,
                                                                                                                        EarnedValueSnapshot__c,
                                                                                                                        EarnedValueSnapshot__r.WeekStartDate__c,
                                                                                                                        TaskTotalApprovedCostSnapshot__c,
                                                                                                                        SnapshotDate__c
                                                                                                                FROM EarnedValueTask__c
                                                                                                                WHERE EarnedValueHeader__c = :evHeaderId
                                                                                                        ];
                if(!allEVTasks.isEmpty()){
                        for(EarnedValueTask__c evTask : allEVTasks){                            
                                results.put(evTask.ProjectTask__c, evTask);
                        }
                }
        } else {
                System.debug('Did not find any EVH for report name: ' + reportName);
        }
        System.debug('project task id to evtask map: ' + results);
        return results;
    }
    
    
    public Map<Id, Decimal> getPriorWeekMapOfTaskIdToPercentComplete(){
        Map<Id, Decimal> results = new Map<Id, Decimal>();

                Date snapShotPriorDate = getPriorSnapShotDate();
            system.debug('selectedSnapshotDate = ' + selectedSnapshotDate);
        system.debug('snapShotPriorDate = ' + snapShotPriorDate);

                if(snapShotPriorDate != null){
                        //String reportNameForPriorDate = ECO_Utils_Date.formatDateAsMMSlashDDSlashYYYY(snapShotPriorDate);
                        String reportNameForPriorDate = snapShotPriorDate.format();
                        Map<Id, EarnedValueTask__c> mapOfProjectTaskIdToEVT = getAllEarnedValueTasksByProjectTaskForReport(reportNameForPriorDate);
            
                for (Id eachProjectTaskId : mapOfProjectTaskIdToEVT.keySet()) {
                                EarnedValueTask__c evt = mapOfProjectTaskIdToEVT.get(eachProjectTaskId);
                                Decimal priorComplete = 0;
                                if(evt.PercentComplete__c != null){
                                        priorComplete = evt.PercentComplete__c;
                                }
                                System.debug('putting task id: ' + eachProjectTaskId + ', task name: ' + evt.ProjectTask__r.Name + ', with priorComplete value of ' + priorComplete);
                                results.put(eachProjectTaskId, priorComplete);
                        }
                }
        return results;
    }
    
    
    private Date getPriorSnapShotDate() {
        Date priorWeekStartDate = selectedSnapshotDate.addDays(-7);
        if (priorWeekStartDate < project.pse__Start_Date__c.toStartofWeek()) {
                return null;
        } else {
                return priorWeekStartDate;
        }
    }

    public PageReference requestTaskManagerInput() {
        Set<Id> userIds = new Set<Id>();

        for (ProjectTaskWrapper wrapper : availableTasks) {
            if (!UserInfo.getUserId().equals(wrapper.task.ProjectTaskOwner__c)) {
                userIds.add(wrapper.task.ProjectTaskOwner__c);
            }
        }

        List<ProjectTeamMember__c> members = [select id, Request_Input__c, Contact__r.pse__Salesforce_User__c from ProjectTeamMember__c where Project__c = :projectId];

        // Set<Id> memberIds = new Set<Id>();

        List<ProjectTeamMember__c> toUpdate = new List<ProjectTeamMember__c>();

        for (ProjectTeamMember__c member : members) {
            if (userIds.contains(member.Contact__r.pse__Salesforce_User__c)) {
                if (member.Request_Input__c) {
                    member.Request_Input__c = false;
                    toUpdate.add(member);
                }
            }
        }

        update toUpdate;  // force any that were true to false first, otherwise workflow won't fire

        toUpdate = new List<ProjectTeamMember__c>();

        for (ProjectTeamMember__c member : members) {
            if (userIds.contains(member.Contact__r.pse__Salesforce_User__c)) {
                member.Request_Input__c = true;
                toUpdate.add(member);
            }
        }

        update toUpdate;

        // Database.executeBatch(new ECO_EarnedValueRequestTMInputEmailBatch(memberIds), 1);

        return null;
    }
    
        public class ProjectTaskWrapper {
        
        public pse__Project_Task__c task {get;set;}
        // public BudgetTask__c budgetTask {get;set;}
        public Boolean isSelected {get;set;}
        public Boolean notifyOwnerOnCreate {get;set;}
        public Boolean disableSelect {get;set;}
        public Decimal priorComplete {get;set;}
        public EarnedValueTask__c earnedValueTask {get;set;}
        public Decimal earnedValue {get;set;}
        public Boolean canEdit {get;set;}
        // public EarnedValueSnapshot__c earnedValueSnapshot {get;set;}
        
        public ProjectTaskWrapper() {

        }
    }

    public class ECO_EarnedvalueReportControllerException extends Exception {

    }
}