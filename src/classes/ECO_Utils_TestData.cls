/*
 *  @Author: Sujit Kumar
 *  @Created: Aug 10, 2015
 *  This is a utility class that provides data for test classes.
 *  All the builder nested classes are based on the Builder GoF design pattern.
 *  Advantages: 1) Prevent proliferation of constructors - telescoping constructor anti-pattern
                2) Reduced coupling on constructors.
                3) Defaults provided for most common attribute values
 */
 
public class ECO_Utils_TestData {

	public class AccountBuilder {
		
		public AccountBuilder() {
			name = 'test account';
		}
		
		public String name { get; set; }
		 
		public AccountBuilder withName(String name) {
	        this.name = name;
	        return this;
	    }
	    
		public Account build() {
	    	Account myAccount = new Account(name = this.name);
	    	insert myAccount;
	    	return myAccount;
	    }
	}
	
	public class ProjectBuilder {
		
		public ProjectBuilder() {
	        this.acct = new AccountBuilder().build();
	        this.startDate = Date.today();
	        this.endDate = startDate.addDays(56); // 8 weeks
	        this.projectTasks = new List<pse__Project_Task__c>();
	    }
	    
		public Account acct { get; set; }
		public Date startDate { get; set; }
		public Date endDate { get; set; }
		public List<pse__Project_Task__c> projectTasks { get; set; }
		 
		public ProjectBuilder withAccount(Account acct) {
	        this.acct = acct;
	        return this;
	    }
	    
	    public ProjectBuilder withStartDate(Date startDate) {
	        this.startDate = startDate;
	        return this;
	    }
	    
	    public ProjectBuilder withEndDate(Date endDate) {
	        this.endDate = endDate;
	        return this;
	    }
	    
	    public ProjectBuilder withProjectTask(pse__Project_Task__c myTask) {
	        this.projectTasks.add(myTask);
	        return this;
	    }
	    
		 public pse__Proj__c build() {
	        pse__Proj__c myProj = new pse__Proj__c	(
	        											pse__Account__c = this.acct.Id, 
	        											pse__Start_Date__c = this.startDate,
	        											pse__End_Date__c = this.endDate
	        										);
	        insert myProj;
	        return myProj;
	    }
	}


	public class ProjectTaskBuilder {
		
		public ProjectTaskBuilder() {
	        this.earnedValueCurve = 'Even';
	        this.totalApprovedCost = 10000; // 8 weeks
	    }
	    
	    public String taskName { get; set; }
	    public Id projectId { get; set; }
	    public String earnedValueCurve { get; set; }
	    public Integer totalApprovedCost { get; set; }
	    
		public ProjectTaskBuilder withTaskName(String taskName) {
	        this.taskName = taskName;
	        return this;
	    }
	    
	    public ProjectTaskBuilder withprojectId(Id projectId) {
	        this.projectId = projectId;
	        return this;
	    }
	    
	    public ProjectTaskBuilder withTotalApprovedCost(Integer totalApprovedCost) {
	        this.totalApprovedCost = totalApprovedCost;
	        return this;
	    }
	    
	    public ProjectTaskBuilder withEarnedValueCurve(String earnedValueCurve) {
	        this.earnedValueCurve = earnedValueCurve;
	        return this;
	    }
	    
		 public pse__Project_Task__c build() {
	        pse__Project_Task__c myProjTask = new pse__Project_Task__c	
	        										(
	        											Name = this.taskName, 
	        											pse__Project__c = this.projectId,
	        											EarnedValueCurve__c = this.earnedValueCurve,
	        											TotalApprovedCost__c = this.totalApprovedCost
	        										);
	        return myProjTask;
	    }
	}


	public class EarnedValueReportBuilder {

		public EarnedValueReportBuilder() {
			// Add defaults here if any
			this.committed = false;
	    }
	    
	    public String reportName { get; set; }
	    public Id projectId { get; set; }
	    public Date snapshotDate { get; set; }
	    public Boolean committed { get; set; }
	    
		public EarnedValueReportBuilder withReportName(String reportName) {
	        this.reportName = reportName;
	        return this;
	    }
	    
	    public EarnedValueReportBuilder withprojectId(Id projectId) {
	        this.projectId = projectId;
	        return this;
	    }
	    
	    public EarnedValueReportBuilder withSnapshotDate(Date snapshotDate) {
	        this.snapshotDate = snapshotDate;
	        return this;
	    }
	    
	    public EarnedValueReportBuilder withCommitted(Boolean committed) {
	        this.committed = committed;
	        return this;
	    }
	    
		 public EarnedValueHeader__c build() {
	        EarnedValueHeader__c myReport = new EarnedValueHeader__c	
	        										(
	        											ReportName__c = this.reportName, 
	        											Project__c = this.projectId,
	        											SnapshotDate__c = this.snapshotDate,
	        											Committed__c = this.committed
	        										);
	        insert myReport;
	        return myReport;
	    }
	}
	
	
	public class EarnedValueTaskBuilder {

		public EarnedValueTaskBuilder() {
			// Add defaults here if any
			this.committed = false;
			this.notifyTaskOwner = false;
			this.percentComplete = 0.00;
	    }

	    public Id taskId { get; set; }
	    public Id reportId { get; set; }
	    public Date snapshotDate { get; set; }
	    public Boolean committed { get; set; }
	    public Boolean notifyTaskOwner { get; set; }
	    public Decimal percentComplete { get; set; }
	    
		public EarnedValueTaskBuilder withTaskId(Id taskId) {
	        this.taskId = taskId;
	        return this;
	    }
	    
	    public EarnedValueTaskBuilder withReportId(Id reportId) {
	        this.reportId = reportId;
	        return this;
	    }
	    
	    public EarnedValueTaskBuilder withSnapshotDate(Date snapshotDate) {
	        this.snapshotDate = snapshotDate;
	        return this;
	    }
	    
	    public EarnedValueTaskBuilder withCommitted(Boolean committed) {
	        this.committed = committed;
	        return this;
	    }
	    
	    public EarnedValueTaskBuilder withNotifyTaskOwner(Boolean notifyTaskOwner) {
	        this.notifyTaskOwner = notifyTaskOwner;
	        return this;
	    }
	    
		public EarnedValueTaskBuilder withPercentComplete(Decimal percentComplete) {
	        this.percentComplete = percentComplete;
	        return this;
	    }	    
	    
		 public EarnedValueTask__c build() {
	        EarnedValueTask__c myEVT = new EarnedValueTask__c	
	        										(
	        											ProjectTask__c = this.taskId, 
	        											EarnedValueHeader__c = this.reportId,
	        											SnapshotDate__c = this.snapshotDate,
	        											Committed__c = committed,
	        											NotifyTaskOwner__c = notifyTaskOwner,
	        											PercentComplete__c = percentComplete
	        										);
	        return myEVT;
	    }
	}

	public virtual class ProjectWrapper {
		
		public pse__Proj__c project { get; set; }
		public List<pse__Project_Task__c> listOfTasks { get; set; }
		
		public ProjectWrapper(pse__Proj__c project, List<pse__Project_Task__c> listOfTasks) {
			this.project = project;
			this.listOfTasks = listOfTasks;
		}
	}
	
	
	public class ReportWrapper extends ProjectWrapper {
		
		public EarnedValueHeader__c report { get; set; }
		public List<EarnedValueTask__c> listOfEVTs { get; set; }
		
		public ReportWrapper(ProjectWrapper pw, EarnedValueHeader__c report, List<EarnedValueTask__c> listOfEVTs) {
			super(pw.project, pw.listOfTasks);
			this.report = report;
			this.listOfEVTs = listOfEVTs;
		}
	}
	
	public static pse__Proj__c createProject() {
		pse__Proj__c testProject = new ProjectBuilder().build();
		return testProject;
	}
	
	public static pse__Proj__c createProject(Date startDate, Date endDate) {
		pse__Proj__c testProject = new ProjectBuilder().withStartDate(startDate).withEndDate(endDate).build();
		return testProject;
	}
	
	public static ProjectWrapper createProjectWithTasks(String prefix, Integer nTasks, Integer nWeeks) {
		Date endDate = Date.today().addDays(7 * nWeeks); // nWeeks
		pse__Proj__c testProject = new ProjectBuilder().withEndDate(endDate).build();
		
		List<pse__Project_Task__c> listOfTasks = new List<pse__Project_Task__c>();
		for (Integer i = 1; i <= nTasks; ++i) {
			pse__Project_Task__c projTask = new ProjectTaskBuilder().withTaskName(prefix + '-' + i)
																	.withProjectId(testProject.Id)
																	.build();
			listOfTasks.add(projTask);
		}

		System.debug('listOfTasks: ' + listOfTasks);
		insert listOfTasks;
		return new ProjectWrapper(testProject, listOfTasks);
	}
	
	public static EarnedValueHeader__c createReport(ProjectWrapper myProjWrapper, Integer reportForNthWeek) {
		return createReport(myProjWrapper, reportForNthWeek, false);
	}
	
	public static EarnedValueHeader__c createReport(ProjectWrapper myProjWrapper, Integer reportForNthWeek, Boolean committed) {
		Date startOfWeekOfStartDate = myProjWrapper.project.pse__Start_Date__c.toStartofWeek();
		if (reportForNthWeek > 1) {
			startOfWeekOfStartDate = startOfWeekOfStartDate.addDays(7 * (reportForNthWeek - 1));
		}
		EarnedValueHeader__c myReport = new EarnedValueReportBuilder()
												.withProjectId(myProjWrapper.project.Id)
												.withSnapshotDate(startOfWeekOfStartDate)
												.withReportName(ECO_Utils_Date.formatDateAsMMSlashDDSlashYYYY(startOfWeekOfStartDate))
												.withCommitted(committed)
												.build();
    	return myReport;
	}
	
	public static List<EarnedValueTask__c> createEarnedValueTasks(ProjectWrapper myProjWrapper, EarnedValueHeader__c myReport, Integer basePercentComplete) {
		return 	createEarnedValueTasks(myProjWrapper, myReport, basePercentComplete, false);
	}
	
	
	public static List<EarnedValueTask__c> createEarnedValueTasks(ProjectWrapper myProjWrapper, EarnedValueHeader__c myReport, Integer basePercentComplete, Boolean committed) {
		List<EarnedValueTask__c> listOfEVTs = new List<EarnedValueTask__c>();
		Integer i = 1;
		for (pse__Project_Task__c eachTask : myProjWrapper.listOfTasks) {
	    	EarnedValueTask__c evt = new EarnedValueTaskBuilder()
												.withTaskId(eachTask.Id)
												.withReportId(myReport.Id)
												.withSnapshotDate(myProjWrapper.project.pse__Start_Date__c.toStartofWeek())
												.withCommitted(committed)
												.withPercentComplete(basePercentComplete + i)
												.build();
	   		listOfEVTs.add(evt);
	   		i = i + 1;
		}
		insert listOfEVTs;
		return listOfEVTs;
	}
	
	public static ReportWrapper createReportAndEarnedValueTasks(ProjectWrapper pw, Integer reportForNthWeek, Integer basePercentComplete, Boolean committed) {
		EarnedValueHeader__c evReport = createReport(pw, reportForNthWeek);
		List<EarnedValueTask__c> listOfEVTs = createEarnedValueTasks(pw, evReport, basePercentComplete);
		ReportWrapper rw = new ReportWrapper(pw, evReport, listOfEVTs);
		return rw;
	}
	
	public static ReportWrapper createProjectWithTasksAndEVReportAndEVTasks(Integer nTasks, Integer nWeeks, Integer reportForNthWeek, Integer basePercentComplete) {
		ProjectWrapper pw = createProjectWithTasks('A', nTasks, nWeeks);
		return createReportAndEarnedValueTasks(pw, reportForNthWeek, basePercentComplete, false);
	}
	
}