/*
 *  @Author: Sujit Kumar
 *  Created: July 6th, 2015
 *
 *  Methods to be tested:
 *
 *      init
 *      getStartOfWeekDatesBetweenProjectStartAndEndDates
 *      initStartOfWeekDatesBetweenProjectStartAndEndDates
 *      findCurrentSavedStateOfEachReport
 *
 *      moveToSelectedSnapshotDate
 *      moveForwardByAWeek
 *      moveBackwardByAWeek
 *
 *      saveEarnedValueTasksForSnapshot
 *      commitEarnedValueTasksForSnapshot
 *
 *      Below 2 are called as part of save and commit, no need to test independently:
 *      createEarnedValueGoogleChartJSON
 *      createCpiAndSpiGoogleChartJSON
 *      returnToProject
 *
 */

@isTest
private class ECO_EarnedValueReport2ControllerTest {

    
    /*
    Given:
        Create a project with no actual start and actual end dates
    When:
        init method is called
    Then:
        ECO_EarnedvalueReportControllerException is thrown
    */
    static testMethod void givenProjectNoStartAndEndDates_WhenInitCalled_ThenExceptionThrown() {
        pse__Proj__c myProj = ECO_Utils_TestData.createProject();
        ApexPages.StandardController sc = new ApexPages.StandardController(myProj);
        ECO_EarnedValueReport2Controller evrController = new ECO_EarnedValueReport2Controller(sc);
        Exception ex;
        
        try { 
        	evrController.init(); 
        } catch (Exception e) {
        	ex = e;
        }
        system.assertNotEquals(null, ex);
        system.assert(ex instanceOf ECO_EarnedValueReport2Controller.ECO_EarnedvalueReportControllerException);
        
        // Set the start date, but not the end date - u should still get same exception
        myProj.pse__Start_Date__c = Date.today();
        try { 
        	evrController.init(); 
        } catch (Exception e) {
        	ex = e;
        }
        System.assertNotEquals(null, ex);
        System.assert(ex instanceOf ECO_EarnedValueReport2Controller.ECO_EarnedvalueReportControllerException);
    }
    
    
    
    /*
    Given:
        Create a project with actual start and actual end dates
    When:
        invoke method getStartOfWeekDatesBetweenProjectStartAndEndDates
    Then:
        valid start of week dates between project start and end dates
    */
    static testMethod void givenProjectWithStartAndEndDates_WhenGetStartOfWeekDatesBetweenProjectStartAndEndDates_ThenValidStartOfWeekDates() {
        // TODO: No need for this, move the method getStartOfWeekDatesBetweenProjectStartAndEndDates into ECO_Utils_Date
        // Refactor after demo
        // Already Wrote test case in ECO_Utils_DateTest
        System.assert(true);
    }
    
    
    /*
    Given:
        Create a project with actual start and actual end dates
        The project should have 5 tasks
    When:
        init method is called
    Then:
        the default report is created for the start of week of project start date
        startOfWeekDatesBetweenProjectStartAndEndDates should have all start of week dates from project start date to project end date
        scrolling flags should be set correctly - left is false, right is true
        there should be 5 available tasks with percent complete set to 0 for each of the tasks 
        verify chartJSON and cpiAndSpiJSON
        
    */
    static testMethod void givenProjectWithStartAndEndDates_WhenInitCalled_DefaultReportCreated() {
    	// Given:
    	Integer numOfWeeks = 5, numOfProjectTasks = 5;
        ECO_Utils_TestData.ProjectWrapper myProjWrapper = ECO_Utils_TestData.createProjectWithTasks('A', numOfProjectTasks, numOfWeeks);
        ApexPages.StandardController sc = new ApexPages.StandardController(myProjWrapper.project);
        ECO_EarnedValueReport2Controller evrController = new ECO_EarnedValueReport2Controller(sc);
        Exception ex;
        
        // When:
        test.startTest();
        try { 
        	evrController.init(); 
        } catch (Exception e) {
        	ex = e;
        }
        test.stopTest();
        
        // Then:
        System.assertEquals(null, ex);
        // verify selectedSnapshotDate
        Date startOfWeekOfStartDate = Date.today().toStartOfWeek();
        System.assertEquals(startOfWeekOfStartDate, evrController.selectedSnapshotDate);
        
        // Verify each of startOfWeekDatesBetweenProjectStartAndEndDates
        Date eachStartOfWeekDate = startOfWeekOfStartDate;
        for (SelectOption eachSelect : evrController.startOfWeekDatesBetweenProjectStartAndEndDates) {
        	String expectedLabel = ECO_Utils_Date.formatDateAsMMSlashDDSlashYYYY(eachStartOfWeekDate);
        	
        	String expectedValue = expectedLabel + ' (' + ECO_EarnedValueReport2Controller.UNSAVED + ')';
        	System.assertEquals(ECO_Utils_Date.formatDateAsMMSlashDDSlashYYYY(eachStartOfWeekDate), eachSelect.getLabel());
        	System.assertEquals(ECO_Utils_Date.formatDateAsMMSlashDDSlashYYYY(eachStartOfWeekDate), eachSelect.getValue());
        	eachStartOfWeekDate = eachStartOfWeekDate.addDays(7);
        }
        
        // verify flags
        System.assert(evrController.hasNextWeek);
        System.assert(!evrController.hasPrevWeek);
        
        // verify tasks and EVTs
        System.assertEquals(numOfProjectTasks, evrController.numAvailableTasks);
        List<ECO_EarnedValueReport2Controller.ProjectTaskWrapper> expectedAvailableTasks;
        for (ECO_EarnedValueReport2Controller.ProjectTaskWrapper eachPWT : expectedAvailableTasks) {
        	System.assertNotEquals(null, eachPWT.earnedValueTask);
        }
    }    
    
    
    /*
    Given:
        Create a project with actual start and actual end dates
        The project should have 5 tasks
        The project should have 2 reports created for 2 of the week start dates - create reports using DML
        The reports are in unsaved state.
    When:
        init method is called
    Then:
        the default report should be for the most recent week start date for which a report exists
        startOfWeekDatesBetweenProjectStartAndEndDates should have all start of week dates from project start date to project end date
        scrolling flags should be set correctly
        there should be 5 available tasks with percent complete set to 0 for each of the tasks 
        veirfy chartJSON and cpiAndSpiJSON
        
    */
    static testMethod void givenProjectWith2UnSavedReports_WhenInitCalled_DefaultReportForMostRecentWeek() {
        // Given
    	Integer numOfWeeks = 8, numOfProjectTasks = 5;
        ECO_Utils_TestData.ProjectWrapper myProjWrapper = ECO_Utils_TestData.createProjectWithTasks('A', numOfProjectTasks, numOfWeeks);
        
        EarnedValueHeader__c  reportForFirstWeek = ECO_Utils_TestData.createReport(myProjWrapper, 1);
        EarnedValueHeader__c reportForSecondWeek = ECO_Utils_TestData.createReport(myProjWrapper, 2);
    	
        ApexPages.StandardController sc = new ApexPages.StandardController(myProjWrapper.project);
        ECO_EarnedValueReport2Controller evrController = new ECO_EarnedValueReport2Controller(sc);
        Exception ex;
        
		// When:
        test.startTest();
        try { 
        	evrController.init(); 
        } catch (Exception e) {
        	ex = e;
        }
        test.stopTest();
        
        // Then:
        System.assertEquals(null, ex);
        
        // verify selectedSnapshotDate
        Date startOfWeekOfFirstWeek = Date.today().toStartOfWeek();
        Date startOfWeekOfSecondWeek = startOfWeekOfFirstWeek.addDays(7);
        System.assertEquals(startOfWeekOfSecondWeek, evrController.selectedSnapshotDate);
        
        // Verify each of startOfWeekDatesBetweenProjectStartAndEndDates
        Date eachStartOfWeekDate = startOfWeekOfFirstWeek;
        for (SelectOption eachSelect : evrController.startOfWeekDatesBetweenProjectStartAndEndDates) {
        	String expectedLabel = ECO_Utils_Date.formatDateAsMMSlashDDSlashYYYY(eachStartOfWeekDate);
        	
        	String expectedValue = expectedLabel + ' (' + ECO_EarnedValueReport2Controller.UNSAVED + ')';
        	System.assertEquals(ECO_Utils_Date.formatDateAsMMSlashDDSlashYYYY(eachStartOfWeekDate), eachSelect.getLabel());
        	System.assertEquals(ECO_Utils_Date.formatDateAsMMSlashDDSlashYYYY(eachStartOfWeekDate), eachSelect.getValue());
        	eachStartOfWeekDate = eachStartOfWeekDate.addDays(7);
        }
        
        // verify flags
        System.assert(evrController.hasNextWeek);
        System.assert(evrController.hasPrevWeek);
        
        // verify tasks and EVTs
        System.assertEquals(numOfProjectTasks, evrController.numAvailableTasks);
        List<ECO_EarnedValueReport2Controller.ProjectTaskWrapper> expectedAvailableTasks;
        for (ECO_EarnedValueReport2Controller.ProjectTaskWrapper eachPWT : expectedAvailableTasks) {
        	System.assertNotEquals(null, eachPWT.earnedValueTask);
        }
    }    
    
    

    /*
    Given:
        Create a project with actual start and actual end dates
        The project should have 5 tasks
        The project should have 3 reports created for 3 week start dates - create reports using DML
        One report is in unsaved state, other is in-progress and the third is Committed.
    When:
        initStartOfWeekDatesBetweenProjectStartAndEndDates method is called
    Then:
        verify valid saved state of each of the 3 reports - one in Unsaved state, one in-progress
        and the 3rd one in Committed state.
        
    */  
    static testMethod void givenProjectWith3ReportsInDiffStates_findCurrentSavedStateOfEachReport_ReportsInValidState() {
        // Given:
    	Integer numOfWeeks = 8, numOfProjectTasks = 5;
        ECO_Utils_TestData.ProjectWrapper myProjWrapper = ECO_Utils_TestData.createProjectWithTasks('A', numOfProjectTasks, numOfWeeks);
        
        Integer firstWeek = 1, secondWeek = 2, thirdWeek = 3;
        EarnedValueHeader__c  firstWeekUnsavedReport = ECO_Utils_TestData.createReport(myProjWrapper, firstWeek);
        
        Boolean isCommitted = false;
        EarnedValueHeader__c  secondWeekInProgressReportWrapper = ECO_Utils_TestData.createReportAndEarnedValueTasks(myProjWrapper, secondWeek, 10, isCommitted).report;

        isCommitted = true;
        EarnedValueHeader__c  thirdWeekCommittedReportWrapper = ECO_Utils_TestData.createReportAndEarnedValueTasks(myProjWrapper, thirdWeek, 20, isCommitted).report;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController(myProjWrapper.project);
        ECO_EarnedValueReport2Controller evrController = new ECO_EarnedValueReport2Controller(sc);
        Exception ex;
        
		// When:
        test.startTest();
        try { 
        	evrController.initStartOfWeekDatesBetweenProjectStartAndEndDates(); 
        } catch (Exception e) {
        	ex = e;
        }
        test.stopTest();
        
        // Then:
        System.assertEquals(null, ex);
        List<SelectOption> dropDownListBoxEntries = evrController.startOfWeekDatesBetweenProjectStartAndEndDates;
        System.assertEquals(3, dropDownListBoxEntries.size());
        SelectOption firstSelectOption = dropDownListBoxEntries.get(0);
        SelectOption secondSelectOption = dropDownListBoxEntries.get(1);
        SelectOption thirdSelectOption = dropDownListBoxEntries.get(2);

		// Asserts for 1st week        
        Date startOfWeekOfFirstReport = Date.today().toStartOfWeek();
        String formattedLabelForFirstReport = ECO_Utils_Date.formatDateAsMMSlashDDSlashYYYY(startOfWeekOfFirstReport);
        String formattedLabelForFirstReportWithState = formattedLabelForFirstReport + ' (' + ECO_EarnedValueReport2Controller.UNSAVED + ')';
        System.assertEquals(formattedLabelForFirstReport, firstSelectOption.getValue());
        System.assertEquals(formattedLabelForFirstReportWithState, firstSelectOption.getLabel());
        
		// Asserts for 2nd week        
        Date startOfWeekOfSecondReport = Date.today().toStartOfWeek();
        String formattedLabelForSecondReport = ECO_Utils_Date.formatDateAsMMSlashDDSlashYYYY(startOfWeekOfSecondReport);
        String formattedLabelForSecondReportWithState = formattedLabelForSecondReport + ' (' + ECO_EarnedValueReport2Controller.IN_PROGRESS + ')';
        System.assertEquals(formattedLabelForSecondReport, firstSelectOption.getValue());
        System.assertEquals(formattedLabelForSecondReportWithState, firstSelectOption.getLabel());
        
        // Asserts for 3rd week        
        Date startOfWeekOfThirdReport = Date.today().toStartOfWeek();
        String formattedLabelForThirdReport = ECO_Utils_Date.formatDateAsMMSlashDDSlashYYYY(startOfWeekOfThirdReport);
        String formattedLabelForThirdReportWithState = formattedLabelForThirdReport + ' (' + ECO_EarnedValueReport2Controller.COMMITTED + ')';
        System.assertEquals(formattedLabelForThirdReport, firstSelectOption.getValue());
        System.assertEquals(formattedLabelForThirdReportWithState, firstSelectOption.getLabel());
    }
        
    
    /*
    Given:
        Create a project with actual start and actual end dates
        The project should have 5 tasks
        The project should have 3 reports created for 3 succeesive week start dates - create reports using DML
        One report is in unsaved state, other is in-progress and the third is Committed.
    When:
        moveToSelectedSnapshotDate method is called
    Then:
        verify valid saved state of the report for the next week
        verify prior and current values of the columns
    */  
    static testMethod void givenProjectWith3ReportsInDiffStates_moveToSelectedSnapshotDate_ValidReportForThatDate() {
       // Given:
    	Integer numOfWeeks = 8, numOfProjectTasks = 5;
        ECO_Utils_TestData.ProjectWrapper myProjWrapper = ECO_Utils_TestData.createProjectWithTasks('A', numOfProjectTasks, numOfWeeks);
        
        Integer firstWeek = 1, secondWeek = 2, thirdWeek = 3;
        
        EarnedValueHeader__c  firstWeekUnsavedReport = ECO_Utils_TestData.createReport(myProjWrapper, firstWeek);
        
        Boolean isCommitted = false;
        Integer basePercentCompleteSecondWeek = 10;
        EarnedValueHeader__c  secondWeekInProgressReportWrapper = ECO_Utils_TestData.createReportAndEarnedValueTasks(myProjWrapper, secondWeek, basePercentCompleteSecondWeek, isCommitted).report;

        isCommitted = true;
        Integer basePercentCompleteThirdWeek = 20;
        EarnedValueHeader__c  thirdWeekCommittedReportWrapper = ECO_Utils_TestData.createReportAndEarnedValueTasks(myProjWrapper, thirdWeek, basePercentCompleteThirdWeek, isCommitted).report;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController(myProjWrapper.project);
        ECO_EarnedValueReport2Controller evrController = new ECO_EarnedValueReport2Controller(sc);
        Exception ex;
        
        // Move to start of 3rd week of project
        Date startOfWeekOfThirdWeekOfProject = Date.today().toStartOfWeek().addDays(14);
        
        Map<Id, Decimal> mapOfTaskIdToPercentCompleteForSecondWeek;
        
		// When:
        test.startTest();
        try { 
        	evrController.init();
        	evrController.selectedSnapshotDate = startOfWeekOfThirdWeekOfProject;
        	evrController.moveToSelectedSnapshotDate();
        	mapOfTaskIdToPercentCompleteForSecondWeek = evrController.getPriorWeekMapOfTaskIdToPercentComplete();
        } catch (Exception e) {
        	ex = e;
        }
        test.stopTest();
        
        // Then:
        system.assertEquals(null, ex);
        
        System.assert(evrController.hasNextWeek);
        System.assert(evrController.hasPrevWeek);
        
        System.assertEquals(ECO_Utils_Date.formatDateAsMMSlashDDSlashYYYY(startOfWeekOfThirdWeekOfProject), evrController.evhRecord.ReportName__c);
        for (ECO_EarnedValueReport2Controller.ProjectTaskWrapper ptw : evrController.availableTasks) {   		
    		Decimal percentCompleteForPriorWeek = mapOfTaskIdToPercentCompleteForSecondWeek.get(ptw.earnedValueTask.ProjectTask__c);
    		// each week is 10 more as 3rd week base percent is 10% more than 2nd week
    		System.assertEquals(percentCompleteForPriorWeek + 10, ptw.earnedValueTask.PercentComplete__c); 
    	}
    }
    
    /*
    Given:
        Create a project with actual start and actual end dates
        The project should have 5 tasks
        The project should have 3 reports created for 3 succeesive week start dates - - create reports using DML
        One report is in unsaved state, other is in-progress and the third is Committed.
    When:
        moveForwardByAWeek method is called
    Then:
        verify valid saved state of the report for the next week
        verify prior and current values of the columns
    */  
    static testMethod void givenProjectWith3ReportsInDiffStates_moveForwardByAWeek_ReportsInValidState() {

    }   
    
    /*
    Given:
        Create a project with actual start and actual end dates
        The project should have 5 tasks
        The project should have 3 reports created for 3 succeesive week start dates - create reports using DML
        One report is in unsaved state, other is in-progress and the third is Committed.
    When:
        moveBackwardByAWeek method is called
    Then:
        verify valid saved state of the report for the next week
        verify prior and current values of the columns
    */  
    static testMethod void givenProjectWith3ReportsInDiffStates_moveBackwardByAWeek_ReportsInValidState() {

    }       
    
    /*
    Given:
        Create a project with actual start and actual end dates
        The project should have 5 tasks
        The project should have 1 report created for the first week in unsaved state - create report using DML
    When:
        saveEarnedValueTasksForSnapshot method is called on the first report which is in unsaved state, it should go to in-progress
    Then:
        verify in-progress state of the report for the first week
        verify the total earned value in WeeklyRollupEntry
    */  
    static testMethod void givenProjectWithUnsavedReport_saveEarnedValueTasksForSnapshot_ReportHasInProgressState() {
       // Given:
    	Integer numOfWeeks = 8, numOfProjectTasks = 5, firstWeek = 1;
        ECO_Utils_TestData.ProjectWrapper myProjWrapper = ECO_Utils_TestData.createProjectWithTasks('A', numOfProjectTasks, numOfWeeks);
        ApexPages.StandardController sc = new ApexPages.StandardController(myProjWrapper.project);
        ECO_EarnedValueReport2Controller evrController = new ECO_EarnedValueReport2Controller(sc);
        
        Boolean isCommitted = false;
        Integer basePercentComplete = 10;
        EarnedValueHeader__c  firstWeekInProgressReport = ECO_Utils_TestData.createReportAndEarnedValueTasks(myProjWrapper, firstWeek, basePercentComplete, isCommitted).report;
        Exception ex;
        
        // Start of week of project start date
        Date startOfWeekOfFirstWeekOfProject = Date.today().toStartOfWeek();
                
		// When:
        test.startTest();
        try { 
        	evrController.init();
        	evrController.saveEarnedValueTasksForSnapshot(false);
        } catch (Exception e) {
        	ex = e;
        }
        test.stopTest();
        
        // Then:
        System.assertEquals(null, ex);
        
        // Verify report name is the first week
        System.assertEquals(ECO_Utils_Date.formatDateAsMMSlashDDSlashYYYY(startOfWeekOfFirstWeekOfProject), evrController.evhRecord.ReportName__c);
        
        // Verify In-progress state of the 1st week
        List<SelectOption> dropDownListBoxEntries = evrController.startOfWeekDatesBetweenProjectStartAndEndDates;
        System.assert(dropDownListBoxEntries.size() >= 1);
        SelectOption firstSelectOption = dropDownListBoxEntries.get(0);
        
        String formattedLabelForFirstReport = ECO_Utils_Date.formatDateAsMMSlashDDSlashYYYY(startOfWeekOfFirstWeekOfProject);
        String formattedLabelForFirstReportWithState = formattedLabelForFirstReport + ' (' + ECO_EarnedValueReport2Controller.IN_PROGRESS + ')';
        System.assertEquals(formattedLabelForFirstReport, firstSelectOption.getValue());
        System.assertEquals(formattedLabelForFirstReportWithState, firstSelectOption.getLabel());
        
        // Verify the total earned value
        Decimal totalEarnedValue = 0.00;
        for (Integer i = 1; i <= 5; i++) {
        	Integer percentComplete = basePercentComplete + i;
        	Decimal earnedValueForTask = 10000 * (percentComplete / 100);
        	totalEarnedValue += earnedValueForTask.setScale(2, RoundingMode.HALF_UP);
        }
        
        String ckey = ECO_Service_Snapshots.DateToSnapshotKey(evrController.selectedSnapshotDate, evrController.project.id);
        WeeklyRollupEntry__c rollup = [select Id, Project__c, CompositeKey__c, EarnedValue__c from WeeklyRollupEntry__c where compositekey__c = :ckey];
        System.assertEquals(totalEarnedValue, rollup.EarnedValue__c);
        
        // TODO: verify createEarnedValueGoogleChartJSON and createCpiAndSpiGoogleChartJSON
    }
    
    /*
    Given:
        Create a project with actual start and actual end dates
        The project should have 5 tasks
        The project should have 1 report created for the first week which is in-progress - create report using DML
    When:
        commitEarnedValueTasksForSnapshot method is called on the first report which is in in-progress state, it should go to committed state
    Then:
        verify committed state of the report for the first week
    */  
    static testMethod void givenProjectWithInProgressReport_commitEarnedValueTasksForSnapshot_ReportInCommittedState() {
       // Given:
    	Integer numOfWeeks = 8, numOfProjectTasks = 5, firstWeek = 1;
        ECO_Utils_TestData.ProjectWrapper myProjWrapper = ECO_Utils_TestData.createProjectWithTasks('A', numOfProjectTasks, numOfWeeks);
        ApexPages.StandardController sc = new ApexPages.StandardController(myProjWrapper.project);
        ECO_EarnedValueReport2Controller evrController = new ECO_EarnedValueReport2Controller(sc);
        
        Boolean isCommitted = true; // this should be true so that the report is already in-progress before commit is called
        Integer basePercentComplete = 10;
        EarnedValueHeader__c  firstWeekInProgressReport = ECO_Utils_TestData.createReportAndEarnedValueTasks(myProjWrapper, firstWeek, basePercentComplete, isCommitted).report;
        Exception ex;
        
        // Start of week of project start date
        Date startOfWeekOfFirstWeekOfProject = Date.today().toStartOfWeek();
                
		// When:
        test.startTest();
        try { 
        	evrController.init();
        	evrController.commitEarnedValueTasksForSnapshot();
        } catch (Exception e) {
        	ex = e;
        }
        test.stopTest();
        
        // Then:
        System.assertEquals(null, ex);
        
        // Verify report name is the first week
        System.assertEquals(ECO_Utils_Date.formatDateAsMMSlashDDSlashYYYY(startOfWeekOfFirstWeekOfProject), evrController.evhRecord.ReportName__c);
        
        // Verify COMMITTED state of the 1st week
        List<SelectOption> dropDownListBoxEntries = evrController.startOfWeekDatesBetweenProjectStartAndEndDates;
        System.assert(dropDownListBoxEntries.size() >= 1);
        SelectOption firstSelectOption = dropDownListBoxEntries.get(0);
        
        String formattedLabelForFirstReport = ECO_Utils_Date.formatDateAsMMSlashDDSlashYYYY(startOfWeekOfFirstWeekOfProject);
        String formattedLabelForFirstReportWithState = formattedLabelForFirstReport + ' (' + ECO_EarnedValueReport2Controller.COMMITTED + ')';
        System.assertEquals(formattedLabelForFirstReport, firstSelectOption.getValue());
        System.assertEquals(formattedLabelForFirstReportWithState, firstSelectOption.getLabel());
        
        // Verify the total earned value
        Decimal totalEarnedValue = 0.00;
        for (Integer i = 1; i <= 5; i++) {
        	Integer percentComplete = basePercentComplete + i;
        	Decimal earnedValueForTask = 10000 * (percentComplete / 100);
        	totalEarnedValue += earnedValueForTask.setScale(2, RoundingMode.HALF_UP);
        }
        
        String ckey = ECO_Service_Snapshots.DateToSnapshotKey(evrController.selectedSnapshotDate, evrController.project.id);
        WeeklyRollupEntry__c rollup = [select Id, Project__c, CompositeKey__c, EarnedValue__c from WeeklyRollupEntry__c where compositekey__c = :ckey];
        System.assertEquals(totalEarnedValue, rollup.EarnedValue__c);
        
        // TODO: verify createEarnedValueGoogleChartJSON and createCpiAndSpiGoogleChartJSON
    }   
    
}