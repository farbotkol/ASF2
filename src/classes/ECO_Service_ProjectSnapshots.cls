public class ECO_Service_ProjectSnapshots {
	
	public ECO_EarnedValueReportController earnedValueController {get; set;}
	public Date EarnedValueSnapshotDate {get; set;}
	public DateTime EarnedValueLastModifiedDate {get; set;}
	
	private map<Id, Decimal> projectMonth1FutureSpend;
	private map<Id, Decimal> projectMonth2FutureSpend;
	private map<Id, Decimal> projectMonth3FutureSpend;
	private map<Id, Decimal> projectMonth4FutureSpend;
	private map<Id, Decimal> projectMonth5FutureSpend;
	private map<Id, Decimal> projectMonth6FutureSpend;
	private map<Id, Decimal> projectMonth7FutureSpend;
	private map<Id, Decimal> projectMonth8FutureSpend;
	private map<Id, Decimal> projectMonth9FutureSpend;
	private map<Id, Decimal> projectMonth10FutureSpend;
	private map<Id, Decimal> projectMonth11FutureSpend;
	private map<Id, Decimal> projectMonth12FutureSpend;
	
	private map<Id, list<Id>> organizationProjectsMap;
	private map<Id, String> organizationNameMap;
	private map<String, Decimal> organizationProjectPercentage;
	private Id primaryOrganizationId;
	private list<Id> projectIds;
		
	private class ProjectOrganization
	{
		public Id OrganizationId {get; set;}
		public String OrganizationName {get; set;}
		public Decimal AllocationPercentage {get; set;}
	}
		
	private class FinancialMetrics
	{
		public Decimal TotalRevenue {get; set;}
		public Decimal TotalCost {get; set;}
		public Decimal NetMargin {get; set;}
		public Decimal NetServiceRevenue {get;set;}
		public Decimal NMNSR {get; set;}
		public Decimal NMGR {get; set;}
		public Decimal LaborMult {get; set;}
		public Decimal TotalLabor {get; set;}
		public Decimal TotalNonLabor {get; set;}
		public Decimal SurplusMargin {get; set;}
		public Decimal LostMargin {get; set;}
		public Decimal TotalContingency {get; set;}
		
		public FinancialMetrics()
		{
			TotalRevenue = 0;
			TotalCost = 0;
			TotalLabor = 0;
			TotalNonLabor = 0;
			NetMargin = 0;
			NetServiceRevenue = 0;
			NMNSR = 0;
			NMGR = 0;
			LaborMult = 0;
			TotalContingency = 0;
		}
	}
	
	private class BillingMetrics
	{
		public Decimal Unbilled0to30 {get; set;}
		public Decimal Unbilled31to60 {get; set;}
		public Decimal Unbilled60Plus {get; set;}
		public Decimal BilledITD {get; set;}
		public Decimal TotalUnbilled {get; set;}
		public Decimal BIEE {get; set;}

		public Decimal Billed0to30 {get; set;}
		public Decimal Billed31to60 {get; set;}
		public Decimal Billed60Plus {get; set;}
		public Decimal Billed90Plus {get; set;}
		public Decimal BilledAR {get; set;}
		public Decimal Retention {get; set;}
		
		public BillingMetrics()
		{
			Unbilled0to30 = 0;
			Unbilled31to60 = 0;
			Unbilled60Plus = 0;
			BilledITD = 0;
			TotalUnbilled = 0;
			BIEE = 0;
			Billed0to30 = 0;
			Billed31to60 = 0;
			Billed60Plus = 0;
			Billed90Plus = 0;
			BilledAR = 0;
			Retention = 0;
		}	
	}
	
	public ECO_Service_ProjectSnapshots(list<Id> snapshotProjectIds)
	{
		organizationProjectsMap = new map<Id, list<Id>>();
		organizationNameMap = new map<Id, String>();
		organizationProjectPercentage = new map<String, Decimal>();	
		
		projectIds = snapshotProjectIds;	
		
		//getProjectSnapshot(projectIds);	
	}
	
	public ECO_Service_ProjectSnapshots(Id snapshotProjectId)
	{
		organizationProjectsMap = new map<Id, list<Id>>();
		organizationNameMap = new map<Id, String>();
		organizationProjectPercentage = new map<String, Decimal>();	
		projectIds = new list<Id>();
		projectIds.add(snapshotProjectId);
		
		list<EarnedValueHeader__c> evHeaders = [select Id from EarnedValueHeader__c where Project__c = :snapshotProjectId order by Id desc];
		
		if(evHeaders.size() > 0){
			list<EarnedValueSnapshot__c> snapshots = [select Id FROM EarnedValueSnapshot__c
 												WHERE ProjectTask__r.pse__Project__c = :snapshotProjectId];
			
			if(snapshots.size() > 0)
			{
				earnedValueController = new ECO_EarnedValueReportController(evHeaders[0].Id);
			
				list<EarnedValueTask__c> earnedValueTasks =	[SELECT EarnedValueSnapshot__c
												, EarnedValueSnapshot__r.WeekStartDate__c
												, SnapshotDate__c
												, LastModifiedDate
											FROM EarnedValueTask__c
											WHERE EarnedValueHeader__c = :evHeaders[0].Id
											ORDER BY SnapshotDate__c DESC
											LIMIT 1];
				//list<EarnedValueSnapshot__c> snapshots = [select Id, WeekStartDate__c from EarnedValueSnapshot__c where WeekStartDate__c <= TODAY and ProjectTask__r.pse__Project__c = :snapshotProjectId order by WeekStartDate__c desc];
				if(earnedValueTasks.size() > 0)
				{
					EarnedValueSnapshotDate = earnedValueTasks[0].SnapshotDate__c;
					EarnedValueLastModifiedDate = earnedValueTasks[0].LastModifiedDate;
				}
			}
		}
	}
		
	public ProjectSnapshot__c getProjectSnapshot()
	{
		populateOrganizationsMaps(projectIds);
		
		ProjectSnapshot__c snapshot = new ProjectSnapshot__c();
		snapshot.SnapshotDate__c = DateTime.now();
		Id changeOrderRecordTypeId = ECO_Utils_Meta.getRecordTypeId(BudgetHeader__c.sObjectType, 'Change Order');

		if(projectIds.size() == 1)
		{
			//project information
			pse__Proj__c project = [select Id, Name, ProjectReviewCategory__c, PrimaryEndClientName__c
								, pse__Account__r.Name
								, pse__Project_Manager__c
								, OracleProjectnumber__c
								, pse__End_Date__c
								, pse__Start_Date__c
								from pse__Proj__c where Id in :projectIds];				
					
			snapshot.ProjectName__c = project.Name;
			snapshot.ProjectRating__c = project.ProjectReviewCategory__c;
			snapshot.ClientName__c = project.pse__Account__r.Name;
			snapshot.ProjectManager__c = project.pse__Project_Manager__c;
			snapshot.ProjectDirector__c = ECO_Service_ProjectTeam.getActiveProjectApproverId(project.Id);
			snapshot.ProjectNumber__c = project.OracleProjectNumber__c;
			snapshot.ProjectStartDate__c = project.pse__Start_Date__c;
			snapshot.ProjectEndDate__c = project.pse__End_Date__c;
			snapshot.Project__c = project.Id;
			
			//Change Orders	
			snapshot.ChangeOrdersPending__c = getPendingChangeOrders(projectIds, changeOrderRecordTypeId);
			snapshot.ChangeOrdersDraft__c = getDraftChangedOrders(projectIds, changeOrderRecordTypeId);
			
			//Primary Organization
			snapshot.PrimaryOrganization__c = organizationNameMap.get(primaryOrganizationId);//getPrimaryOrganization(projectId);

			//Agreements
			snapshot.RelatedAgreements__c = getRelatedAgreements(projectIds);
			
			//Project Tasks
			snapshot.ProjectTasks__c = getRelatedProjectTasks(projectIds);
			
			//Organizations
			for(Id organizationId:organizationNameMap.keyset()){
				if(organizationId != primaryOrganizationId)
				{
					if(snapshot.SecondaryOrganizations__c == '' || snapshot.SecondaryOrganizations__c == null)
						snapshot.SecondaryOrganizations__c = organizationNameMap.get(organizationId);	
					else
						snapshot.SecondaryOrganizations__c += '::' + organizationNameMap.get(organizationId);
				}	
			}	
			
			//Earned Value
			//map<Date, Decimal> mapTest = earnedValueController.mapDateCPI;
			if(EarnedValueSnapshotDate != null)
			{
				
				snapshot.EarnedValueCPI__c = earnedValueController.mapDateCPI.get(EarnedValueSnapshotDate);
				snapshot.EarnedValueSPI__c = earnedValueController.mapDateSPI.get(EarnedValueSnapshotDate);
				snapshot.EarnedValuePlannedValue__c = earnedValueController.mapDatePlannedValues.get(EarnedValueSnapshotDate);
				snapshot.EarnedValue__c = earnedValueController.mapDateEarnedValues.get(EarnedValueSnapshotDate);
				snapshot.EarnedValueActualSpend__c = earnedValueController.mapDateActualCosts.get(EarnedValueSnapshotDate);
				snapshot.EarnedValueLastUpdated__c = EarnedValueLastModifiedDate;
				snapshot.EarnedValueOverallProgress__c = 0;
				snapshot.EarnedValuePercentBudgetSpent__c = 0;
			}					
		}
		//Approved
		FinancialMetrics approvedBudgetFinancialMetrics = getApprovedBudgetHeaderInformation(projectIds, 'Approved', false);
		snapshot.GrossRevenueBudget__c = approvedBudgetFinancialMetrics.TotalRevenue;
		snapshot.CostBudget__c = approvedBudgetFinancialMetrics.TotalCost;
		snapshot.NetMarginBudget__c = approvedBudgetFinancialMetrics.NetMargin;
		snapshot.NetServiceBudget__c = approvedBudgetFinancialMetrics.NetServiceRevenue;
		snapshot.NMNSRBudget__c = approvedBudgetFinancialMetrics.NMNSR;
		snapshot.NMGRBudget__c = approvedBudgetFinancialMetrics.NMGR;
		snapshot.LaborMultBudget__c = approvedBudgetFinancialMetrics.LaborMult;
		snapshot.ContingencyBudget__c = approvedBudgetFinancialMetrics.TotalContingency;
		snapshot.LastUpdatedBudget__c = getLastUpdatedBudgetDate(projectIds);

		//Forecast
		FinancialMetrics forecastBudgetFinancialMetrics = getForecastBudgetHeaderInformation(projectIds);
		snapshot.GrossRevenueForecast__c = forecastBudgetFinancialMetrics.TotalRevenue + snapshot.GrossRevenueBudget__c;
		snapshot.CostForecast__c = forecastBudgetFinancialMetrics.TotalCost + snapshot.CostBudget__c;
		snapshot.NetMarginForecast__c = forecastBudgetFinancialMetrics.NetMargin + snapshot.NetMarginBudget__c;	
		snapshot.NetServiceForecast__c = forecastBudgetFinancialMetrics.NetServiceRevenue + snapshot.NetServiceBudget__c;
		snapshot.NMNSRForecast__c = forecastBudgetFinancialMetrics.NMNSR + snapshot.NMNSRBudget__c;
		snapshot.NMGRForecast__c = forecastBudgetFinancialMetrics.NMGR + snapshot.NMGRBudget__c;
		snapshot.LaborMultForecast__c = forecastBudgetFinancialMetrics.LaborMult + snapshot.LaborMultBudget__c;
		snapshot.ContingencyForecast__c = forecastBudgetFinancialMetrics.TotalContingency + snapshot.ContingencyBudget__c;
		
		//Draft
		//FinancialMetrics draftBudgetFinancialMetrics = getDraftBudgetHeaderInformation(projectIds, changeOrderRecordTypeId);
		FinancialMetrics draftBudgetFinancialMetrics = getDraftBudgetHeaderInformation(projectIds);		
		snapshot.GrossRevenueDraft__c = draftBudgetFinancialMetrics.TotalRevenue;
		snapshot.CostDraft__c = draftBudgetFinancialMetrics.TotalCost;
		snapshot.NetMarginDraft__c = draftBudgetFinancialMetrics.NetMargin;	
		snapshot.NetServiceDraft__c = draftBudgetFinancialMetrics.NetServiceRevenue;
		snapshot.NMNSRDraft__c = draftBudgetFinancialMetrics.NMNSR;
		snapshot.NMGRDraft__c = draftBudgetFinancialMetrics.NMGR;
		snapshot.LaborMultDraft__c = draftBudgetFinancialMetrics.LaborMult;
		snapshot.ContingencyDraft__c = draftBudgetFinancialMetrics.TotalContingency;
		
		//Unapproved
		FinancialMetrics unapprovedBudgetFinancialMetrics = getBudgetHeaderInformation(projectIds, 'Approved', true);
		snapshot.GrossRevenueUnapproved__c = unapprovedBudgetFinancialMetrics.TotalRevenue;
		snapshot.CostUnapproved__c = unapprovedBudgetFinancialMetrics.TotalCost;
		snapshot.NetMarginUnapproved__c = unapprovedBudgetFinancialMetrics.NetMargin;	
		snapshot.NetServiceUnapproved__c = unapprovedBudgetFinancialMetrics.NetServiceRevenue;
		snapshot.NMNSRUnapproved__c = unapprovedBudgetFinancialMetrics.NMNSR;
		snapshot.NMGRUnapproved__c = unapprovedBudgetFinancialMetrics.NMGR;
		snapshot.LaborMultUnapproved__c = unapprovedBudgetFinancialMetrics.LaborMult;
		snapshot.ContingencyUnapproved__c = unapprovedBudgetFinancialMetrics.TotalContingency;		
				
		//MTD
		FinancialMetrics mtdActualFinancialMetrics = getProjectActualFinancials(projectIds, Date.today().addMonths(-1));
		snapshot.GrossRevenueMonthToDate__c = mtdActualFinancialMetrics.TotalRevenue;
		snapshot.CostMonthToDate__c = mtdActualFinancialMetrics.TotalCost;
		snapshot.NetMarginMonthToDate__c = mtdActualFinancialMetrics.NetMargin;
		snapshot.NetServiceMonthToDate__c = mtdActualFinancialMetrics.NetServiceRevenue;
		snapshot.NMNSRMonthToDate__c = mtdActualFinancialMetrics.NMNSR;
		snapshot.NMGRMonthToDate__c = mtdActualFinancialMetrics.NMGR;
		snapshot.LaborMultMonthToDate__c = mtdActualFinancialMetrics.LaborMult;
		snapshot.ContingencyMonthToDate__c = mtdActualFinancialMetrics.TotalContingency;
		snapshot.SurMarginMonthToDate__c = 0;
		snapshot.LostMarginMonthToDate__c = 0;

		snapshot.SurMarginMonthToDate__c = ((snapshot.NMNSRMonthToDate__c - snapshot.NMNSRBudget__c) * snapshot.NetServiceMonthToDate__c)/100;
		snapshot.LostMarginMonthToDate__c = ((snapshot.NMNSRMonthToDate__c - snapshot.NMNSRBudget__c) * snapshot.NetServiceMonthToDate__c)/100;
		
		
		//ITD
		FinancialMetrics itdActualFinancialMetrics = getProjectActualFinancials(projectIds, null);
		snapshot.GrossRevenueITD__c = itdActualFinancialMetrics.TotalRevenue;
		snapshot.CostITD__c = itdActualFinancialMetrics.TotalCost;
		snapshot.NetMarginITD__c = itdActualFinancialMetrics.NetMargin;	
		snapshot.NetServiceITD__c = itdActualFinancialMetrics.NetServiceRevenue;
		snapshot.NMNSRITD__c = itdActualFinancialMetrics.NMNSR;
		snapshot.NMGRITD__c = itdActualFinancialMetrics.NMGR;
		snapshot.LaborMultITD__c = itdActualFinancialMetrics.LaborMult;	
		snapshot.ContingencyITD__c = itdActualFinancialMetrics.TotalContingency;
		snapshot.SurMarginITD__c = 0;
		snapshot.LostMarginITD__c = 0;

		snapshot.SurMarginITD__c = ((snapshot.NMNSRITD__c - snapshot.NMNSRBudget__c) * snapshot.NetServiceITD__c)/100;
		snapshot.LostMarginITD__c = ((snapshot.NMNSRITD__c - snapshot.NMNSRBudget__c) * snapshot.NetServiceITD__c)/100;


		//YTD			
		FinancialMetrics ytdActualFinancialMetrics = getProjectActualFinancials(projectIds, Date.today().addYears(-1));
		snapshot.GrossRevenueYearToDate__c = ytdActualFinancialMetrics.TotalRevenue;
		snapshot.CostYearToDate__c = ytdActualFinancialMetrics.TotalCost;
		snapshot.NetMarginYearToDate__c = ytdActualFinancialMetrics.NetMargin;	
		snapshot.NetServiceYearToDate__c = ytdActualFinancialMetrics.NetServiceRevenue;
		snapshot.NMNSRYearToDate__c = ytdActualFinancialMetrics.NMNSR;
		snapshot.NMGRYearToDate__c = ytdActualFinancialMetrics.NMGR;
		snapshot.LaborMultYearToDate__c = ytdActualFinancialMetrics.LaborMult;
		snapshot.ContingencyYearToDate__c = ytdActualFinancialMetrics.TotalContingency;
		
		snapshot.SurMarginYearToDate__c = ((snapshot.NMNSRYearToDate__c - snapshot.NMNSRBudget__c) * snapshot.NetServiceYearToDate__c)/100;
		snapshot.LostMarginYearToDate__c = ((snapshot.NMNSRYearToDate__c - snapshot.NMNSRBudget__c) * snapshot.NetServiceYearToDate__c)/100;
		
		//Billing Metrics		
		BillingMetrics billingMetrics = getBillingARMetrics(projectIds, itdActualFinancialMetrics.TotalRevenue);
		snapshot.CashPerfBilled0__c = billingMetrics.Billed0to30;
		snapshot.CashPerfBilled31__c = billingMetrics.Billed31to60;
		snapshot.CashPerfBilled60__c = billingMetrics.Billed60Plus;
		snapshot.CashPerfBilled90__c = billingMetrics.Billed90Plus;
		snapshot.CashPerfBilledAR__c = billingMetrics.BilledAR;
		snapshot.CashPerfRetention__c = billingMetrics.Retention;
		
		snapshot.CashPerfUnbilled60__c = billingMetrics.UnBilled60Plus;
		snapshot.CashPerfUnbilled30__c = billingMetrics.Unbilled31to60;
		snapshot.CashPerfUnbilled0__c = billingMetrics.Unbilled0to30;
		snapshot.CashPerfBIEE__c = billingMetrics.BIEE;
		snapshot.CashPerfTotalUnbilled__c = billingMetrics.TotalUnbilled;
							
		//Future Spend
		projectMonth1FutureSpend = getFutureSpendForPeriodMap(projectIds, Date.today(), Date.today().addMonths(1));
		projectMonth2FutureSpend = getFutureSpendForPeriodMap(projectIds, Date.today().addMonths(1), Date.today().addMonths(2));		
		projectMonth3FutureSpend = getFutureSpendForPeriodMap(projectIds, Date.today().addMonths(2), Date.today().addMonths(3));		
		projectMonth4FutureSpend = getFutureSpendForPeriodMap(projectIds, Date.today().addMonths(3), Date.today().addMonths(4));		
		projectMonth5FutureSpend = getFutureSpendForPeriodMap(projectIds, Date.today().addMonths(4), Date.today().addMonths(5));		
		projectMonth6FutureSpend = getFutureSpendForPeriodMap(projectIds, Date.today().addMonths(5), Date.today().addMonths(6));		

		Decimal projectPercent;
		Decimal month1Spend = 0;
		Decimal month2Spend = 0;
		Decimal month3Spend = 0;
		Decimal month4Spend = 0;
		Decimal month5Spend = 0;
		Decimal month6Spend = 0;
		
		for(Id organizationId:organizationNameMap.keyset())
		{
			for(Id projId:organizationProjectsMap.get(organizationId))
			{
				projectPercent = organizationProjectPercentage.get(organizationId + '-' + projId);	
				month1Spend += projectPercent/100 * returnMapDecimalValue(projectMonth1FutureSpend.get(projId));
				month2Spend += projectPercent/100 * returnMapDecimalValue(projectMonth2FutureSpend.get(projId));
				month3Spend += projectPercent/100 * returnMapDecimalValue(projectMonth3FutureSpend.get(projId));
				month4Spend += projectPercent/100 * returnMapDecimalValue(projectMonth4FutureSpend.get(projId));
				month5Spend += projectPercent/100 * returnMapDecimalValue(projectMonth5FutureSpend.get(projId));
				month6Spend += projectPercent/100 * returnMapDecimalValue(projectMonth6FutureSpend.get(projId));
			}
			if(snapshot.PrimaryFutureSpend__c == '' || snapshot.PrimaryFutureSpend__c == null)
				snapshot.PrimaryFutureSpend__c = organizationNameMap.get(organizationId);
			else
				snapshot.PrimaryFutureSpend__c += ';;' + organizationNameMap.get(organizationId);
			snapshot.PrimaryFutureSpend__c += '::' + month1Spend;
			snapshot.PrimaryFutureSpend__c += '::' + month2Spend;
			snapshot.PrimaryFutureSpend__c += '::' + month3Spend;
			snapshot.PrimaryFutureSpend__c += '::' + month4Spend;
			snapshot.PrimaryFutureSpend__c += '::' + month5Spend;
			snapshot.PrimaryFutureSpend__c += '::' + month6Spend;				
		}
		
		snapshot.FutureSpendMonth1__c = getTotalFutureSpendForPeriod(projectMonth1FutureSpend.values());
		snapshot.FutureSpendMonth2__c = getTotalFutureSpendForPeriod(projectMonth2FutureSpend.values());
		snapshot.FutureSpendMonth3__c = getTotalFutureSpendForPeriod(projectMonth3FutureSpend.values());
		snapshot.FutureSpendMonth4__c = getTotalFutureSpendForPeriod(projectMonth4FutureSpend.values());
		snapshot.FutureSpendMonth5__c = getTotalFutureSpendForPeriod(projectMonth5FutureSpend.values());
		snapshot.FutureSpendMonth6__c = getTotalFutureSpendForPeriod(projectMonth6FutureSpend.values());
		
		return snapshot;
	}
	
		
	private String getRelatedProjectTasks(list<Id> projectIds)
	{
		String returnString = '';
		list<pse__Project_Task__c> projectTasks = [select Id, Name, pse__Actual_End_Date__c, pse__Actual_Start_Date__c, pse__End_Date__c, pse__Start_Date__c, ProjectTaskNumber__c from pse__Project_Task__c where pse__Project__c in :projectIds];
			
		for(pse__Project_Task__c projectTask:projectTasks)
		{
			if(returnString == '')
				returnString = projectTask.Name + ';;' + projectTask.ProjectTaskNumber__c + ';;' + projectTask.pse__Start_Date__c.format()  + ';;' + projectTask.pse__End_Date__c.format()  + ';;' + projectTask.pse__Actual_Start_Date__c + ';;' + projectTask.pse__Actual_End_Date__c;
			else
				returnString += '::' + projectTask.Name + ';;' + projectTask.ProjectTaskNumber__c + ';;' + projectTask.pse__Start_Date__c.format()  + ';;' + projectTask.pse__End_Date__c.format()  + ';;' + projectTask.pse__Actual_Start_Date__c + ';;' + projectTask.pse__Actual_End_Date__c;			
		}
		return returnString;
		//return returnString.replace('null', ' ');
	}
	
	private DateTime getLastUpdatedBudgetDate(list<Id> projectIds)
	{
		list<BudgetHeader__c> budgets = [select Id, LastModifiedDate from BudgetHeader__c where Project__c in :projectIds
												and Status__c = 'Approved' order by LastModifiedDate desc];
		
		if(budgets.size() > 0)
			return budgets[0].LastModifiedDate;
		return null;
	}
	
	private Decimal returnMapDecimalValue(Decimal value)
	{
		if(value == null)
			return 0;
		return value;
	}
	
	private Decimal getTotalFutureSpendForPeriod(list<Decimal> projectMonthTotals)
	{
		Decimal retVal = 0;
		for(Decimal total:projectMonthTotals)
		{
			retVal += total;	
		}
		return retVal;
	}
	
	private map<Id, Decimal> getFutureSpendForPeriodMap(list<Id> projectIds, Date startDate, Date endDate)
	{
		//Decimal futureSpend = 0;
		map<Id, Decimal> projectsFutureSpendMap = new map<Id, Decimal>();
		for(AggregateResult ar : [SELECT SUM(ApprovedCost__c) ApprovedCost, Project__c
									FROM WeeklyRollupEntry__c
									WHERE Project__c in :projectIds and PeriodStartDate__c > :startDate and PeriodStartDate__c <= :endDate
									group by Project__c])
		{
			if(ar.get('ApprovedCost') != null)
			{
				projectsFutureSpendMap.put((Id)ar.get('Project__c'), (Decimal)ar.get('ApprovedCost'));
			}
		}	
		return projectsFutureSpendMap;
	}
	
	private void populateOrganizationsMaps(list<Id> projectIds)
	{	
		for(ProjectOrganization__c org:[select Id, Type__c, ContributionPercent__c, OrganizationString__r.District__c, OrganizationString__r.Id, OrganizationString__r.Region__c, 
											OrganizationString__r.Name, OrganizationString__r.BusinessLineName__c, Project__c
											from ProjectOrganization__c where Project__c = :projectIds] )
		{
			organizationProjectPercentage.put(org.OrganizationString__r.Id + '-' + org.Project__c, org.ContributionPercent__c);
			if(organizationProjectsMap.get(org.OrganizationString__r.Id) == null)
				organizationProjectsMap.put(org.OrganizationString__r.Id, new list<Id>());
			organizationProjectsMap.get(org.OrganizationString__r.Id).add(org.Project__c);
			organizationNameMap.put(org.OrganizationString__r.Id, org.OrganizationString__r.Region__c + '-' + org.OrganizationString__r.District__c + '-' + org.OrganizationString__r.BusinessLineName__c + '-' + org.OrganizationString__r.Name);
			if(org.Type__c == 'Primary')
				primaryOrganizationId = org.OrganizationString__r.Id;	
		}
	}
		
	private String getRelatedAgreements(list<Id> projectIds)
	{	
		String agreements = '';	
		for(Agreement__c agreement:[select Id, Name, AgreementType__c, RecordType.Name, Amount__c from Agreement__c
																where Id in (select Agreement__c from ProjectAgreement__c
																			where Project__c in :projectIds)])
		{
			if(agreements == '')
				agreements = agreement.RecordType.Name + ';;' + agreement.AgreementType__c + ';;' + agreement.Amount__c;
			else
				agreements += '::' + agreement.RecordType.Name + ';;' + agreement.AgreementType__c + ';;' + agreement.Amount__c;
		}
		return agreements;
	}

	private String getPendingChangeOrders(list<Id> projectIds, Id recordTypeId)
	{
		
		String changeOrders = '';
		for(BudgetHeader__c header:[select Id, Name, BudgetName__c, TotalRevenue__c, TotalCost__c 
										from BudgetHeader__c 
										where Project__c in :projectIds
										and ((Status__c = 'Approved' and ChangeManagerApprovedForSynch__c = true)
											or (Status__c != 'Approved'))
										and Id in (select BudgetHeader__c from ChangeManager__c where Project__c in :projectIds)])
		{
			if(changeOrders == '')
				changeOrders = 	header.BudgetName__c  + ';;' + header.TotalRevenue__c + ';;' + header.TotalCost__c;
			else
				changeOrders += '::' + header.BudgetName__c  + ';;' + header.TotalRevenue__c + ';;' + header.TotalCost__c;
		}
		return changeOrders;			
	}
	
	
	private String getDraftChangedOrders(list<Id> projectIds, Id recordTypeId)
	{	
		String changeOrders = '';	
		for(BudgetHeader__c header:[select Id, Name, BudgetName__c, TotalRevenue__c, TotalCost__c 
				from BudgetHeader__c where Project__c in :projectIds 
										and Id Not in (select BudgetHeader__c from ChangeManager__c where Project__c in :projectIds)])
		{
			if(changeOrders == '')
				changeOrders = 	header.BudgetName__c  + ';;' + header.TotalRevenue__c + ';;' + header.TotalCost__c;
			else
				changeOrders += '::' + header.BudgetName__c  + ';;' + header.TotalRevenue__c + ';;' + header.TotalCost__c;
		}
		return changeOrders;
	}

	private FinancialMetrics getApprovedBudgetHeaderInformation(list<Id> projectIds, String status, boolean showUnsynchedBudgets)
	{
		FinancialMetrics metrics = new FinancialMetrics();
		String query = 'SELECT SUM(TotalRevenue__c) totalRevenue ';
		query += ' , SUM(TotalCost__c) totalCost ';
		query += ' , SUM(TotalNonLabor__c) totalNonLabor ';
		query += ' , SUM(TotalLaborAmount__c) totalLabor ';
		query += ' , sum(TotalContingencyAmount__c) totalContingency ';
		query += ' FROM BudgetHeader__c ';
		query += ' WHERE Project__c in :projectIds ';
		query += ' AND Status__c = :status';
		query += ' AND ChangeManagerApprovedForSynch__c = false';
		
		list<AggregateResult> results = database.query(query); 
		for(AggregateResult ar : results)
		{
			metrics.TotalRevenue = returnMapDecimalValue((Decimal)ar.get('totalRevenue'));
			metrics.TotalCost = returnMapDecimalValue((Decimal)ar.get('totalCost'));
			metrics.TotalNonLabor = returnMapDecimalValue((Decimal)ar.get('totalNonLabor'));
			metrics.TotalLabor = returnMapDecimalValue((Decimal)ar.get('totalLabor'));	
			metrics.TotalContingency = returnMapDecimalValue((Decimal)ar.get('totalContingency'));	
				
			metrics.NetMargin = metrics.TotalRevenue - metrics.TotalCost;
			metrics.NetServiceRevenue = metrics.TotalRevenue - metrics.TotalNonLabor;
			
			if(metrics.TotalRevenue != 0)
				metrics.NMGR = ((metrics.TotalRevenue - metrics.TotalCost)/metrics.TotalRevenue) * 100;
			if(metrics.TotalRevenue - metrics.TotalNonLabor != 0)	
				metrics.NMNSR = ((metrics.TotalRevenue - metrics.TotalCost)/(metrics.TotalRevenue - metrics.TotalNonLabor)) * 100;
			if(metrics.TotalLabor != 0)
				metrics.LaborMult = (metrics.TotalRevenue - metrics.TotalNonLabor)/metrics.TotalLabor;
		}
				
		return metrics;
	}

	private FinancialMetrics getUnapprovedBudgetHeaderInformation(list<Id> projectIds, String status, boolean showUnsynchedBudgets)
	{
		FinancialMetrics metrics = new FinancialMetrics();
		//list<BudgetHeader__c> 
		String approvalStatus = 'Approved';
		String query = 'SELECT SUM(TotalRevenue__c) totalRevenue ';
		query += ' , SUM(TotalCost__c) totalCost ';
		query += ' , SUM(TotalNonLabor__c) totalNonLabor ';
		query += ' , SUM(TotalLaborAmount__c) totalLabor ';
		query += ' , sum(TotalContingencyAmount__c) totalContingency ';
		query += ' FROM BudgetHeader__c ';
		query += ' WHERE Project__c in :projectIds ';
		query += ' AND Status__c = :status';
		query += ' AND ID in (select BudgetHeader__c from ChangeManager__c where ApprovalStatus__c != :approvalStatus and  and Project__c in :projectIds)';		

		list<AggregateResult> results = database.query(query); 
		
		for(AggregateResult ar : results)
		{
			metrics.TotalRevenue = returnMapDecimalValue((Decimal)ar.get('totalRevenue'));
			metrics.TotalCost = returnMapDecimalValue((Decimal)ar.get('totalCost'));
			metrics.TotalNonLabor = returnMapDecimalValue((Decimal)ar.get('totalNonLabor'));
			metrics.TotalLabor = returnMapDecimalValue((Decimal)ar.get('totalLabor'));	
			metrics.TotalContingency = returnMapDecimalValue((Decimal)ar.get('totalContingency'));	
				
			metrics.NetMargin = metrics.TotalRevenue - metrics.TotalCost;
			metrics.NetServiceRevenue = metrics.TotalRevenue - metrics.TotalNonLabor;
			
			if(metrics.TotalRevenue != 0)
				metrics.NMGR = ((metrics.TotalRevenue - metrics.TotalCost)/metrics.TotalRevenue) * 100;
			if(metrics.TotalRevenue - metrics.TotalNonLabor != 0)	
				metrics.NMNSR = ((metrics.TotalRevenue - metrics.TotalCost)/(metrics.TotalRevenue - metrics.TotalNonLabor)) * 100;
			if(metrics.TotalLabor != 0)
				metrics.LaborMult = (metrics.TotalRevenue - metrics.TotalNonLabor)/metrics.TotalLabor;
		}
				
		return metrics;
	}	

	private FinancialMetrics getBudgetHeaderInformation(list<Id> projectIds, String status, boolean showUnsynchedBudgets)
	{
		FinancialMetrics metrics = new FinancialMetrics();
		String query = 'SELECT SUM(TotalRevenue__c) totalRevenue ';
		query += ' , SUM(TotalCost__c) totalCost ';
		query += ' , SUM(TotalNonLabor__c) totalNonLabor ';
		query += ' , SUM(TotalLaborAmount__c) totalLabor ';
		query += ' , sum(TotalContingencyAmount__c) totalContingency ';
		query += ' FROM BudgetHeader__c ';
		query += ' WHERE Project__c in :projectIds ';
		query += ' AND Status__c = :status';
		
		list<AggregateResult> results = database.query(query); 
		for(AggregateResult ar : results)
		{
			metrics.TotalRevenue = returnMapDecimalValue((Decimal)ar.get('totalRevenue'));
			metrics.TotalCost = returnMapDecimalValue((Decimal)ar.get('totalCost'));
			metrics.TotalNonLabor = returnMapDecimalValue((Decimal)ar.get('totalNonLabor'));
			metrics.TotalLabor = returnMapDecimalValue((Decimal)ar.get('totalLabor'));	
			metrics.TotalContingency = returnMapDecimalValue((Decimal)ar.get('totalContingency'));	
				
			metrics.NetMargin = metrics.TotalRevenue - metrics.TotalCost;
			metrics.NetServiceRevenue = metrics.TotalRevenue - metrics.TotalNonLabor;
			
			if(metrics.TotalRevenue != 0)
				metrics.NMGR = ((metrics.TotalRevenue - metrics.TotalCost)/metrics.TotalRevenue) * 100;
			if(metrics.TotalRevenue - metrics.TotalNonLabor != 0)	
				metrics.NMNSR = ((metrics.TotalRevenue - metrics.TotalCost)/(metrics.TotalRevenue - metrics.TotalNonLabor)) * 100;
			if(metrics.TotalLabor != 0)
				metrics.LaborMult = (metrics.TotalRevenue - metrics.TotalNonLabor)/metrics.TotalLabor;
		}
				
		return metrics;
	}
	
	private FinancialMetrics getForecastBudgetHeaderInformation(list<Id> projectIds)
	{
		FinancialMetrics metrics = new FinancialMetrics();
		for(AggregateResult ar : [SELECT SUM(TotalRevenue__c) totalRevenue
											, SUM(TotalCost__c) totalCost
											, SUM(TotalNonLabor__c) totalNonLabor
											, SUM(TotalLaborAmount__c) totalLabor
											, sum(TotalContingencyAmount__c) totalContingency
									FROM BudgetHeader__c
									WHERE Project__c in :projectIds
											and Status__c = 'Forecast'])
		{
			metrics.TotalRevenue = returnMapDecimalValue((Decimal)ar.get('totalRevenue'));
			metrics.TotalCost = returnMapDecimalValue((Decimal)ar.get('totalCost'));
			metrics.TotalNonLabor = returnMapDecimalValue((Decimal)ar.get('totalNonLabor'));
			metrics.TotalLabor = returnMapDecimalValue((Decimal)ar.get('totalLabor'));	
			metrics.TotalContingency = returnMapDecimalValue((Decimal)ar.get('totalContingency'));	
				
			metrics.NetMargin = metrics.TotalRevenue - metrics.TotalCost;
			metrics.NetServiceRevenue = metrics.TotalRevenue - metrics.TotalNonLabor;
			
			if(metrics.TotalRevenue != 0)
				metrics.NMGR = ((metrics.TotalRevenue - metrics.TotalCost)/metrics.TotalRevenue) * 100;
			if(metrics.TotalRevenue - metrics.TotalNonLabor != 0)	
				metrics.NMNSR = ((metrics.TotalRevenue - metrics.TotalCost)/(metrics.TotalRevenue - metrics.TotalNonLabor)) * 100;
			if(metrics.TotalLabor != 0)
				metrics.LaborMult = (metrics.TotalRevenue - metrics.TotalNonLabor)/metrics.TotalLabor;
		}
				
		return metrics;
	}		
	
	private FinancialMetrics getDraftBudgetHeaderInformation(list<Id> projectIds)
	{
		FinancialMetrics metrics = new FinancialMetrics();
		for(AggregateResult ar : [SELECT SUM(TotalRevenue__c) totalRevenue
											, SUM(TotalCost__c) totalCost
											, SUM(TotalNonLabor__c) totalNonLabor
											, SUM(TotalLaborAmount__c) totalLabor
											, sum(TotalContingencyAmount__c) totalContingency
									FROM BudgetHeader__c
									WHERE Project__c in :projectIds
											and Status__c = 'Estimate'])
		{
			metrics.TotalRevenue = returnMapDecimalValue((Decimal)ar.get('totalRevenue'));
			metrics.TotalCost = returnMapDecimalValue((Decimal)ar.get('totalCost'));
			metrics.TotalNonLabor = returnMapDecimalValue((Decimal)ar.get('totalNonLabor'));
			metrics.TotalLabor = returnMapDecimalValue((Decimal)ar.get('totalLabor'));	
			metrics.TotalContingency = returnMapDecimalValue((Decimal)ar.get('totalContingency'));	
				
			metrics.NetMargin = metrics.TotalRevenue - metrics.TotalCost;
			metrics.NetServiceRevenue = metrics.TotalRevenue - metrics.TotalNonLabor;
			
			if(metrics.TotalRevenue != 0)
				metrics.NMGR = ((metrics.TotalRevenue - metrics.TotalCost)/metrics.TotalRevenue) * 100;
			if(metrics.TotalRevenue - metrics.TotalNonLabor != 0)	
				metrics.NMNSR = ((metrics.TotalRevenue - metrics.TotalCost)/(metrics.TotalRevenue - metrics.TotalNonLabor)) * 100;
			if(metrics.TotalLabor != 0)
				metrics.LaborMult = (metrics.TotalRevenue - metrics.TotalNonLabor)/metrics.TotalLabor;
		}
				
		return metrics;
	}	
	
	private FinancialMetrics getProjectActualFinancials(list<Id> projectIds, Date asOfDate)
	{
		FinancialMetrics metrics = new FinancialMetrics();
		list<AggregateResult> results = new list<AggregateResult>();
		String query = 'select sum(Amount__c) totalRevenue from Revenue__c where ProjectNumber__c in :projectIds';
		if(asOfDate != null)
			query += ' and GLDate__c >= :asOfDate and GLDate__c <= TODAY';
		results = database.query(query); 
		
		for(AggregateResult ar: results)
		{
			if(ar.get('totalRevenue') != null)
				metrics.TotalRevenue = (Decimal)ar.get('totalRevenue');
		}
		
		query = 'select SUM(ProjectRawCost__c) totalCost FROM CostDistLine__c WHERE ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id in :projectIds';																						
		if(asOfDate != null)
			query += ' and GLDate__c >= :asOfDate and GLDate__c <= TODAY';
		results = database.query(query);
		for(AggregateResult ar: results)
		{
			if(ar.get('totalCost') != null)
				metrics.TotalCost = (Decimal)ar.get('totalCost');
				metrics.NetMargin = metrics.TotalRevenue - metrics.TotalCost;
		}

		query = 'select SUM(ProjectRawCost__c) totalLabor FROM CostDistLine__c WHERE ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id in :projectIds and ExpenditureItem__r.ExpenditureType__c like  \'LAB% \'';																						
		if(asOfDate != null)
			query += ' and GLDate__c >= :asOfDate and GLDate__c <= TODAY';
		results = database.query(query);
		for(AggregateResult ar: results)
		{
			if(ar.get('totalLabor') != null)
				metrics.TotalLabor = (Decimal)ar.get('totalLabor');
		}
		
		query = 'select SUM(ProjectRawCost__c) totalNonLabor FROM CostDistLine__c WHERE ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id in :projectIds  and (NOT ExpenditureItem__r.ExpenditureType__c like  \'LAB% \')';																						
		if(asOfDate != null)
			query += ' and GLDate__c >= :asOfDate and GLDate__c <= TODAY';
		results = database.query(query);
		for(AggregateResult ar: results)
		{
			if(ar.get('totalNonLabor') != null)
				metrics.TotalNonLabor = (Decimal)ar.get('totalNonLabor');
		}				
		
		metrics.NetServiceRevenue = getNetService(metrics.TotalRevenue, metrics.TotalNonLabor);	
		metrics.NMGR = getNMGR(metrics.NetMargin, metrics.TotalRevenue);
		metrics.NMNSR = getNMNSRC(metrics.NetMargin, metrics.NetServiceRevenue);
		metrics.LaborMult = getLaborMult(metrics.TotalRevenue, metrics.TotalNonLabor, metrics.TotalLabor);
		metrics.SurplusMargin = getSurplusMargin();
		metrics.LostMargin = getLostMargin();
		
		return metrics;		
	}
	
	private Decimal getLaborMult(Decimal revenue, Decimal nonLabor, Decimal labor)
	{
		if(labor == 0)
			return 0;
		return (revenue - nonLabor)/labor;
	}
	
	private Decimal getSurplusMargin()
	{
		
		return null;
	}
	
	private Decimal getLostMargin()
	{
		
		return null;
	}	
	
	private Decimal getNetService(Decimal revenue, Decimal nonLabor)
	{
		return revenue - nonLabor;
	}
	
	private Decimal getNMGR(Decimal netMargin, Decimal revenue)
	{
		if(revenue == 0)
			return 0;
		return (netMargin/revenue) * 100;
	}	
	
	private Decimal getNMNSRC(Decimal netMargin, Decimal netService)
	{
		if(netService == 0)
			return 0;
		return (netMargin/netService) * 100;		
	}		
	
	private BillingMetrics getBillingARMetrics(list<Id> projectIds, Decimal totalRevenue)
	{
		Date startDate;
		Date endDate;
		
		BillingMetrics billingMetrics = new BillingMetrics();
		for(AggregateResult ar: [select SUM(InvoiceAmount__c) totalBilled, SUM(RetentionAmount__c) totalRetention
						from Billing__c where ProjectNumber__c in :projectIds])
		{
			if(ar.get('totalBilled') != null)
			{
				if((Decimal)ar.get('totalBilled') != null)
					billingMetrics.BilledAR = (Decimal)ar.get('totalBilled');	
				billingMetrics.Retention = 	(Decimal)ar.get('totalRetention');	
				billingMetrics.TotalUnbilled = totalRevenue - billingMetrics.BilledAR;
				if((billingMetrics.TotalUnbilled) < 0)
					billingMetrics.BIEE = 	totalRevenue - billingMetrics.BilledAR;
			}
		}	
				
		startDate = Date.today();
		endDate = Date.today().addDays(-30);
		for(AggregateResult ar: [select SUM(InvoiceAmount__c) totalBilled0to30 
						from Billing__c where ProjectNumber__c in :projectIds and
						InvoiceDate__c <= :startDate and InvoiceDate__c >= :endDate])
		{
			if(ar.get('totalBilled0to30') != null)
			{
				billingMetrics.Billed0to30 = (Decimal)ar.get('totalBilled0to30');
			}
		}
		
		startDate = Date.today().addDays(-31);
		endDate = Date.today().addDays(-60);
		for(AggregateResult ar: [select SUM(InvoiceAmount__c) totalBilled31to60 
						from Billing__c where ProjectNumber__c in :projectIds and
						InvoiceDate__c <= :startDate and InvoiceDate__c >= :endDate])
		{
			if(ar.get('totalBilled31to60') != null)
				billingMetrics.Billed31to60 = (Decimal)ar.get('totalBilled31to60');
		}

		startDate = Date.today().addDays(-60);
		for(AggregateResult ar: [select SUM(InvoiceAmount__c) totalBilled60plus 
						from Billing__c where ProjectNumber__c in :projectIds and
						InvoiceDate__c <= :startDate])
		{
			if(ar.get('totalBilled60plus') != null)
				billingMetrics.Billed60Plus = (Decimal)ar.get('totalBilled60plus');
		}
		
		startDate = Date.today().addDays(-90);
		for(AggregateResult ar: [select SUM(InvoiceAmount__c) totalBilled90plus 
						from Billing__c where ProjectNumber__c in :projectIds and
						InvoiceDate__c <= :startDate])
		{
			if(ar.get('totalBilled90plus') != null)
				billingMetrics.Billed90Plus = (Decimal)ar.get('totalBilled90plus');
		}		
			
		startDate = Date.today().addDays(-60);
		for(AggregateResult ar:[select sum(Amount__c) totalRevenue from Revenue__c where ProjectNumber__c in :projectIds 
												and  GLDate__c < :startDate])
		{
			if((Decimal)ar.get('totalRevenue') != null)
				billingMetrics.Unbilled60Plus = (Decimal)ar.get('totalRevenue') - billingMetrics.BilledAR;
			else
				billingMetrics.Unbilled60Plus = 0 - billingMetrics.BilledAR;
		}					

		startDate = Date.today().addDays(-30);
		for(AggregateResult ar:[select sum(Amount__c) totalRevenue from Revenue__c where ProjectNumber__c in :projectIds 
												and  GLDate__c < :startDate])
		{
			if((Decimal)ar.get('totalRevenue') != null)
				billingMetrics.Unbilled31to60 = (Decimal)ar.get('totalRevenue') - (billingMetrics.BilledAR + billingMetrics.Unbilled60Plus);
			else
				billingMetrics.Unbilled31to60 = 0 - (billingMetrics.BilledAR + billingMetrics.Unbilled60Plus);
		}	
		
		startDate = Date.today().addDays(0);
		for(AggregateResult ar:[select sum(Amount__c) totalRevenue from Revenue__c where ProjectNumber__c in :projectIds 
												and  GLDate__c < :startDate])
		{
			if((Decimal)ar.get('totalRevenue') != null)	
				billingMetrics.Unbilled0to30 = (Decimal)ar.get('totalRevenue') - (billingMetrics.BilledAR + billingMetrics.Unbilled60Plus + billingMetrics.Unbilled31to60);
			else
				billingMetrics.Unbilled0to30 = 0 - (billingMetrics.BilledAR + billingMetrics.Unbilled60Plus + billingMetrics.Unbilled31to60);
		}
		return billingMetrics;
	}
}