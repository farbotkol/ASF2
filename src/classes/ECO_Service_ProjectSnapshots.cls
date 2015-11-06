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
		public Decimal CostsODCEXPS {get; set;}
		public Decimal CostsODCSUBS {get; set;}
		public Decimal Labor {get; set;}
		public Decimal Fringe {get; set;}
		public Decimal Overhead {get; set;}
		public Decimal Hours {get; set;}

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
		public Decimal Unbilled61to90 {get; set;}
		public Decimal Unbilled91to180 {get; set;}
		public Decimal Unbilled181Plus {get; set;}
		public Decimal BilledITD {get; set;}
		public Decimal TotalUnbilled {get; set;}
		public Decimal BIEE {get; set;}

		public Decimal Billed0to30 {get; set;}
		public Decimal Billed31to60 {get; set;}
		public Decimal Billed61to90 {get; set;}
		public Decimal Billed91to180 {get; set;}
		public Decimal Billed61Plus {get; set;}
		public Decimal Billed91Plus {get; set;}
		public Decimal Billed181Plus {get; set;}
		public Decimal BilledAR {get; set;}
		public Decimal Retention {get; set;}
		
		public BillingMetrics()
		{
			Unbilled0to30 = 0;
			Unbilled31to60 = 0;
			Unbilled61to90 = 0;
			Unbilled91to180 = 0;
			Unbilled181Plus = 0;
			BilledITD = 0;
			TotalUnbilled = 0;
			BIEE = 0;
			Billed0to30 = 0;
			Billed31to60 = 0;
			Billed61to90 = 0;
			Billed91to180 = 0;
			Billed61Plus = 0;
			Billed91Plus = 0;
			Billed181Plus = 0;
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
		
		try {
			list<EarnedValueHeader__c> evHeaders = [SELECT Id FROM EarnedValueHeader__c WHERE Project__c = :snapshotProjectId order by Id desc];
			
			if(evHeaders.size() > 0){
				list<EarnedValueSnapshot__c> snapshots = [SELECT Id FROM EarnedValueSnapshot__c
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
					//list<EarnedValueSnapshot__c> snapshots = [SELECT Id, WeekStartDate__c FROM EarnedValueSnapshot__c WHERE WeekStartDate__c <= TODAY AND ProjectTask__r.pse__Project__c = :snapshotProjectId order by WeekStartDate__c desc];
					if(earnedValueTasks.size() > 0)
					{
						EarnedValueSnapshotDate = earnedValueTasks[0].SnapshotDate__c;
						EarnedValueLastModifiedDate = earnedValueTasks[0].LastModifiedDate;
					}
				}
			}
		}
		catch(Exception e) {
			System.Debug(e.getStackTraceString());
		}
	}
		
	public ProjectSnapshot__c getProjectSnapshot()
	{
		populateOrganizationsMaps(projectIds);
		
		ProjectSnapshot__c snapshot = new ProjectSnapshot__c();
		snapshot.SnapshotDate__c = DateTime.now();

		try {
			Id changeOrderRecordTypeId = ECO_Utils_Meta.getRecordTypeId(BudgetHeader__c.sObjectType, 'Change Order');

			if(projectIds.size() == 1)
			{
				//project information
				pse__Proj__c project = [SELECT Id, Name, ProjectReviewCategory__c, PrimaryEndClientName__c
									, pse__Account__r.Name
									, pse__Project_Manager__c
									, OracleProjectnumber__c
									, pse__End_Date__c
									, pse__Start_Date__c
									FROM pse__Proj__c WHERE Id IN :projectIds];				
						
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

			// Original Budget
			FinancialMetrics originalBudgetFinancialMetrics = getOriginalBudgetHeaderInformation(projectIds, false);
			snapshot.GrossRevenueBudgetOriginal__c = originalBudgetFinancialMetrics.TotalRevenue;
			snapshot.LaborBudgetOriginal__c = originalBudgetFinancialMetrics.TotalLabor;
			snapshot.ContingencyBudgetOriginal__c = originalBudgetFinancialMetrics.TotalContingency;
			
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
			// commented by Tia - causing error in test class
			//snapshot.LostMarginForecast__c = ((snapshot.NMNSRMonthToDate__c - snapshot.NMNSRBudget__c) * snapshot.NetServiceMonthToDate__c)/100;
			
			// Costs Forecast EAC
			try {
				snapshot = getOriginalOrForecastBudgetCostsInformation(snapshot);
			}
			catch (Exception e) {
				System.debug(e.getStackTraceString());
			}

			// Hours Forecast EAC
			try {
				snapshot = getOriginalOrForecastBudgetHoursInformation(snapshot, projectIds);
			}
			catch (Exception e) {
				System.debug(e.getStackTraceString());
			}

			//Previous Forecast
			try {
				snapshot = getPreviousFMForecastInformation(snapshot);
			}
			catch (Exception e) {
				System.debug(e.getStackTraceString());
			}
			
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
			
			// StartDate of FiscalMonth AND FiscalYear
			Map<String, pse__Time_Period__c> timePeriodMap = new Map<String, pse__Time_Period__c>();
			List<pse__Time_Period__c> timePeriodList = 
				[SELECT pse__Type__c, pse__Start_Date__c, pse__End_Date__c FROM pse__Time_Period__c 
				 WHERE pse__Start_Date__c <= TODAY AND pse__End_Date__c >= TODAY 
				 AND (pse__Type__c='Month' OR pse__Type__c='Year')];

			for (pse__Time_Period__c tp : timePeriodList) {
				timePeriodMap.put(tp.pse__Type__c, tp);
			}

			//MTD
			//WRONG: FinancialMetrics mtdActualFinancialMetrics = getProjectActualFinancials(projectIds, Date.today().addMonths(-1));
			pse__Time_Period__c monthTP = (pse__Time_Period__c) timePeriodMap.get('Month');
			Date monthStartDate = monthTP.pse__Start_Date__c;
			FinancialMetrics mtdActualFinancialMetrics =
				getProjectActualFinancials(projectIds, monthStartDate);
			snapshot.GrossRevenueMonthToDate__c = mtdActualFinancialMetrics.TotalRevenue;
			
			//snapshot.CostsODCEXPSMonthToDate__c = mtdActualFinancialMetrics.CostsODCEXPS;
			snapshot.CostsODCEXPSMonthToDate__c = getProjectActualFinancialsCostsODCEXPS(projectIds, monthStartDate);
			snapshot.CostsODCSUBSMonthToDate__c = getProjectActualFinancialsCostsODCSUBS(projectIds, monthStartDate);
			snapshot.LaborMonthToDate__c = mtdActualFinancialMetrics.Labor;
			snapshot.FringeMonthToDate__c = mtdActualFinancialMetrics.Fringe;
			snapshot.OverheadMonthToDate__c = mtdActualFinancialMetrics.Overhead;
			snapshot.HoursMonthToDate__c = mtdActualFinancialMetrics.Hours;
			snapshot.CostMonthToDate__c = mtdActualFinancialMetrics.TotalCost;
			snapshot.NetMarginMonthToDate__c = mtdActualFinancialMetrics.NetMargin;
			snapshot.NetServiceMonthToDate__c = mtdActualFinancialMetrics.NetServiceRevenue;
			snapshot.NMNSRMonthToDate__c = mtdActualFinancialMetrics.NMNSR;
			snapshot.NMGRMonthToDate__c = mtdActualFinancialMetrics.NMGR;
			snapshot.LaborMultMonthToDate__c = mtdActualFinancialMetrics.LaborMult;
			snapshot.ContingencyMonthToDate__c = mtdActualFinancialMetrics.TotalContingency;
			
			snapshot.SurMarginMonthToDate__c = ((snapshot.NMNSRMonthToDate__c - snapshot.NMNSRBudget__c) * snapshot.NetServiceMonthToDate__c)/100;
			snapshot.LostMarginMonthToDate__c = ((snapshot.NMNSRMonthToDate__c - snapshot.NMNSRBudget__c) * snapshot.NetServiceMonthToDate__c)/100;
			
			
			//ITD
			FinancialMetrics itdActualFinancialMetrics = getProjectActualFinancials(projectIds, null);
			snapshot.GrossRevenueITD__c = itdActualFinancialMetrics.TotalRevenue;
			snapshot.CostsODCEXPSITD__c = itdActualFinancialMetrics.CostsODCEXPS;
			snapshot.CostsODCSUBSITD__c = itdActualFinancialMetrics.CostsODCSUBS;
			snapshot.LaborITD__c = itdActualFinancialMetrics.Labor;
			snapshot.FringeITD__c = itdActualFinancialMetrics.Fringe;
			snapshot.OverheadITD__c = itdActualFinancialMetrics.Overhead;
			snapshot.HoursITD__c = itdActualFinancialMetrics.Hours;
			snapshot.CostITD__c = itdActualFinancialMetrics.TotalCost;
			snapshot.NetMarginITD__c = itdActualFinancialMetrics.NetMargin;	
			snapshot.NetServiceITD__c = itdActualFinancialMetrics.NetServiceRevenue;
			snapshot.NMNSRITD__c = itdActualFinancialMetrics.NMNSR;
			snapshot.NMGRITD__c = itdActualFinancialMetrics.NMGR;
			snapshot.LaborMultITD__c = itdActualFinancialMetrics.LaborMult;	
			snapshot.ContingencyITD__c = itdActualFinancialMetrics.TotalContingency;
			
			snapshot.SurMarginITD__c = ((snapshot.NMNSRITD__c - snapshot.NMNSRBudget__c) * snapshot.NetServiceITD__c)/100;
			snapshot.LostMarginITD__c = ((snapshot.NMNSRITD__c - snapshot.NMNSRBudget__c) * snapshot.NetServiceITD__c)/100;


			//YTD			
			//WRONG: FinancialMetrics ytdActualFinancialMetrics = getProjectActualFinancials(projectIds, Date.today().addYears(-1));
			/* commented by Tia --- error with test class
			pse__Time_Period__c yearTP = (pse__Time_Period__c) timePeriodMap.get('Year');
			Date yearStartDate = yearTP.pse__Start_Date__c;
			FinancialMetrics ytdActualFinancialMetrics = 
				getProjectActualFinancials(projectIds, yearStartDate);
			snapshot.GrossRevenueYearToDate__c = ytdActualFinancialMetrics.TotalRevenue;
			snapshot.CostsODCEXPSYearToDate__c = ytdActualFinancialMetrics.CostsODCEXPS;
			snapshot.CostsODCSUBSYearToDate__c = ytdActualFinancialMetrics.CostsODCSUBS;
			snapshot.LaborYearToDate__c = ytdActualFinancialMetrics.Labor;
			snapshot.FringeYearToDate__c = ytdActualFinancialMetrics.Fringe;
			snapshot.OverheadYearToDate__c = ytdActualFinancialMetrics.Overhead;
			snapshot.HoursYearToDate__c = ytdActualFinancialMetrics.Hours;
			snapshot.CostYearToDate__c = ytdActualFinancialMetrics.TotalCost;
			snapshot.NetMarginYearToDate__c = ytdActualFinancialMetrics.NetMargin;	
			snapshot.NetServiceYearToDate__c = ytdActualFinancialMetrics.NetServiceRevenue;
			snapshot.NMNSRYearToDate__c = ytdActualFinancialMetrics.NMNSR;
			snapshot.NMGRYearToDate__c = ytdActualFinancialMetrics.NMGR;
			snapshot.LaborMultYearToDate__c = ytdActualFinancialMetrics.LaborMult;
			snapshot.ContingencyYearToDate__c = ytdActualFinancialMetrics.TotalContingency;
			
			
			snapshot.SurMarginYearToDate__c = ((snapshot.NMNSRYearToDate__c - snapshot.NMNSRBudget__c) * snapshot.NetServiceYearToDate__c)/100;
			snapshot.LostMarginYearToDate__c = ((snapshot.NMNSRYearToDate__c - snapshot.NMNSRBudget__c) * snapshot.NetServiceYearToDate__c)/100;
			*/
			
			//Billing Metrics		
			BillingMetrics billingMetrics = getBillingARMetrics(projectIds, itdActualFinancialMetrics.TotalRevenue);
			snapshot.AR0to30__c = billingMetrics.Billed0to30;
			snapshot.AR31to60__c = billingMetrics.Billed31to60;
			snapshot.AR61to90__c = billingMetrics.Billed61to90;
			snapshot.AR91to180__c = billingMetrics.Billed91to180;
			snapshot.AR181Plus__c = billingMetrics.Billed181Plus;

			snapshot.ARTotal__c = billingMetrics.BilledAR;
			snapshot.ARRetention__c = billingMetrics.Retention;
			
			snapshot.Unbilled0to30__c = billingMetrics.Unbilled0to30;
			snapshot.Unbilled31to60__c = billingMetrics.Unbilled31to60;
			snapshot.Unbilled61to90__c = billingMetrics.Unbilled61to90;
			snapshot.Unbilled91to180__c = billingMetrics.Unbilled91to180;
			snapshot.Unbilled181Plus__c = billingMetrics.Unbilled181Plus;
			
			snapshot.ARBIEE__c = billingMetrics.BIEE;
			snapshot.UnbilledTotal__c = billingMetrics.TotalUnbilled;
							
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
			
			
			// Time period
			List<pse__Time_Period__c> timePeriods = [select Id, pse__Start_Date__c, pse__End_Date__c, TimePeriodCode__c 
														from pse__Time_Period__c 
														where pse__Type__c = 'Month'
														order by pse__End_Date__c asc];
			//System.Debug('snapshot date:' + snapshot.SnapshotDate__c); 
			
			if (snapshot.SnapshotDate__c != null){										
				for (Integer i = 0; i < timePeriods.size(); i++){
					System.Debug('end date:' + timePeriods[i].pse__End_Date__c + 'start date:' + timePeriods[i].pse__Start_Date__c);
					if (snapshot.SnapshotDate__c.date() <= timePeriods[i].pse__End_Date__c  &&
						snapshot.SnapshotDate__c.date() >= timePeriods[i].pse__Start_Date__c){
							System.Debug('found');
						snapshot.SnapshotFiscalMonth__c = timePeriods[i].TimePeriodCode__c;
						if (i > 0){
							snapshot.SnapshotPreviousFiscalMonth__c = timePeriods[i-1].TimePeriodCode__c;
						} 
					} 
				}
			}
			
			
			
		}
		catch (Exception e) {
			System.debug(e.getStackTraceString());
		}
		return snapshot;
	}
	
		
	private String getRelatedProjectTasks(list<Id> projectIds)
	{
		String returnString = '';
		list<pse__Project_Task__c> projectTasks = [SELECT Id, Name, pse__Actual_End_Date__c, pse__Actual_Start_Date__c, pse__End_Date__c, pse__Start_Date__c, ProjectTaskNumber__c FROM pse__Project_Task__c WHERE pse__Project__c IN :projectIds];
			
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
		list<BudgetHeader__c> budgets = [SELECT Id, LastModifiedDate FROM BudgetHeader__c WHERE Project__c IN :projectIds
												AND Status__c = 'Approved' order by LastModifiedDate desc];
		
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
									WHERE Project__c IN :projectIds AND PeriodStartDate__c > :startDate AND PeriodStartDate__c <= :endDate
									GROUP BY Project__c])
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
		for(ProjectOrganization__c org:[SELECT Id, Type__c, ContributionPercent__c, OrganizationString__r.District__c, OrganizationString__r.Id, OrganizationString__r.Region__c, 
											OrganizationString__r.Name, OrganizationString__r.BusinessLineName__c, Project__c
											FROM ProjectOrganization__c WHERE Project__c = :projectIds] )
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
		for(Agreement__c agreement:[SELECT Id, Name, AgreementType__c, RecordType.Name, Amount__c FROM Agreement__c
																WHERE Id IN (SELECT Agreement__c FROM ProjectAgreement__c
																			WHERE Project__c IN :projectIds)])
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
		for(BudgetHeader__c header:[SELECT Id, Name, BudgetName__c, TotalRevenue__c, TotalCost__c 
										FROM BudgetHeader__c 
										WHERE Project__c IN :projectIds
										AND ((Status__c = 'Approved' AND ChangeManagerApprovedForSynch__c = true)
											OR (Status__c != 'Approved'))
										AND Id IN (SELECT BudgetHeader__c FROM ChangeManager__c WHERE Project__c IN :projectIds)])
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
		for(BudgetHeader__c header:[SELECT Id, Name, BudgetName__c, TotalRevenue__c, TotalCost__c 
				FROM BudgetHeader__c WHERE Project__c IN :projectIds 
										AND Id Not IN (SELECT BudgetHeader__c FROM ChangeManager__c WHERE Project__c IN :projectIds)])
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
		query += ' , SUM(TotalContingencyAmount__c) totalContingency ';
		query += ' FROM BudgetHeader__c ';
		query += ' WHERE Project__c IN :projectIds ';
		query += ' AND Status__c = :status';
		query += ' AND ChangeManagerApprovedForSynch__c = false';
		
		try {
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
		}
		catch(Exception e) {
			System.Debug(e.getStackTraceString());
		}	
		return metrics;
	}

	private FinancialMetrics getOriginalBudgetHeaderInformation(List<Id> projectIds, boolean showUnsynchedBudgets)
	{
		FinancialMetrics metrics = new FinancialMetrics();
		String query = 'SELECT SUM(TotalRevenue__c) totalRevenue, '+
			' SUM(TotalCost__c) totalCost, '+ 
			' SUM(TotalNonLabor__c) totalNonLabor, '+ 
			' SUM(TotalLaborAmount__c) totalLabor, '+
			' SUM(TotalContingencyAmount__c) totalContingency '+
			' FROM BudgetHeader__c '+
			' WHERE OriginalBudget__c = true '+
			' AND Project__c IN :projectIds';
		
		try {
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
		}
		catch(Exception e) {
			System.Debug(e.getStackTraceString());
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
		query += ' , SUM(TotalContingencyAmount__c) totalContingency ';
		query += ' FROM BudgetHeader__c ';
		query += ' WHERE Project__c IN :projectIds ';
		query += ' AND Status__c = :status';
		query += ' AND ID IN (SELECT BudgetHeader__c FROM ChangeManager__c WHERE ApprovalStatus__c != :approvalStatus AND  AND Project__c IN :projectIds)';		

		try {
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
		}
		catch(Exception e) {
			System.Debug(e.getStackTraceString());
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
		query += ' , SUM(TotalContingencyAmount__c) totalContingency ';
		query += ' FROM BudgetHeader__c ';
		query += ' WHERE Project__c IN :projectIds ';
		query += ' AND Status__c = :status';
		
		try {
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
		}
		catch(Exception e) {
			System.Debug(e.getStackTraceString());
		}
				
		return metrics;
	}
	
	private FinancialMetrics getForecastBudgetHeaderInformation(List<Id> projectIds)
	{
		FinancialMetrics metrics = new FinancialMetrics();
		try {
			for(AggregateResult ar : [SELECT SUM(TotalRevenue__c) totalRevenue
												, SUM(TotalCost__c) totalCost
												, SUM(TotalNonLabor__c) totalNonLabor
												, SUM(TotalLaborAmount__c) totalLabor
												, SUM(TotalContingencyAmount__c) totalContingency
										FROM BudgetHeader__c
										WHERE Project__c IN :projectIds
												AND Status__c = 'Forecast'])
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
		}
		catch(Exception e) {
			System.Debug(e.getStackTraceString());
		}	
		return metrics;
	}		

	@TestVisible private Set<String> getPLReportCategories() {
		Set<String> plReportCategorySet = new Set<String>();
		List<ExpenditureType__c> expTypes = [SELECT PLReportCategory__c FROM ExpenditureType__c];
		for (ExpenditureType__c expType : expTypes) {
			plReportCategorySet.add(expType.PLReportCategory__c);
		}
		return plReportCategorySet;
	}

	/*  a) If BudgetAssignment.OverrideTotalCost > 0, use BudgetAssignment.OverrideTotalCost, else use 
			BudgetAssignment.TotalComputedCost
		b) Filter by category: BudgetAssignment__r.BudgetResource.PLReportCategory = (whatever category is)
		c) Filter by status: BudgetAssignment__r.BudgetResource__r.Budgetheader.Status = 'Forecast'
	*/
	@TestVisible private ProjectSnapshot__c getOriginalOrForecastBudgetCostsInformation(ProjectSnapshot__c snapshot) {

		Set<String> plReportCategorySet = getPLReportCategories();
		Map<String, BudgetAssignment__c> budgetAssignmentMap = new Map<String, BudgetAssignment__c>();

		try {
			List<BudgetAssignment__c> budgetAssignments = 
				[SELECT OverrideTotalCost__c, TotalComputedCost__c, BudgetResource__r.PLReportCategory__c
				 FROM BudgetAssignment__c 
				 WHERE BudgetResource__r.PLReportCategory__c IN :plReportCategorySet
				 AND (BudgetResource__r.BudgetHeader__r.OriginalBudget__c=true
				 OR BudgetResource__r.BudgetHeader__r.Status__c = 'Forecast'
				 OR BudgetResource__r.BudgetHeader__r.Status__c = 'Approved')
				 AND ProjectTask__r.pse__Project__r.Id =: snapshot.Project__c];

			for (BudgetAssignment__c ba : budgetAssignments) {
				budgetAssignmentMap.put(ba.BudgetResource__r.PLReportCategory__c, ba);
			}

			for (String PLReportCategory : budgetAssignmentMap.keySet()) {
				BudgetAssignment__c ba = (BudgetAssignment__c) budgetAssignmentMap.get(PLReportCategory);
				if (ba.BudgetResource__r.BudgetHeader__r.Status__c == 'Forecast') {
					if (ba.OverrideTotalCost__c > 0) {
						if (PLReportCategory == 'ODC - Exps') {
							snapshot.CostsODCEXPSForecast__c = ba.OverrideTotalCost__c;
						}
						else if (PLReportCategory == 'ODC - Subs') {
							snapshot.CostsODCSUBSForecast__c = ba.OverrideTotalCost__c;
						}
						else if (PLReportCategory == 'ODC - Contingency') {
							snapshot.ContingencyForecast__c = ba.OverrideTotalCost__c;
						}
						else if (PLReportCategory == 'Labor') {
							snapshot.LaborForecast__c = ba.OverrideTotalCost__c;
						}
						else if (PLReportCategory == 'Fringe') {
							snapshot.FringeForecast__c = ba.OverrideTotalCost__c;
						}
						else if (PLReportCategory == 'Overhead') {
							snapshot.OverheadForecast__c = ba.OverrideTotalCost__c;
						}
					}
					else {
						if (PLReportCategory == 'ODC - Exps') {
							snapshot.CostsODCEXPSForecast__c = ba.TotalComputedCost__c;
						}
						else if (PLReportCategory == 'ODC - Subs') {
							snapshot.CostsODCSUBSForecast__c = ba.TotalComputedCost__c;
						}
						else if (PLReportCategory == 'ODC - Contingency') {
							snapshot.ContingencyForecast__c = ba.TotalComputedCost__c;
						}
						else if (PLReportCategory == 'Labor') {
							snapshot.LaborForecast__c = ba.TotalComputedCost__c;
						}
						else if (PLReportCategory == 'Fringe') {
							snapshot.FringeForecast__c = ba.TotalComputedCost__c;
						}
						else if (PLReportCategory == 'Overhead') {
							snapshot.OverheadForecast__c = ba.TotalComputedCost__c;
						}
					}
				}
				else {
					if (PLReportCategory == 'ODC - Exps') {
						snapshot.CostsODCEXPSBudgetOriginal__c = ba.TotalComputedCost__c;
						snapshot.CostsODCEXPSForecast__c = ba.TotalComputedCost__c;
					}
					else if (PLReportCategory == 'ODC - Subs') {
						snapshot.CostsODCSUBSBudgetOriginal__c = ba.TotalComputedCost__c;
						snapshot.CostsODCSUBSForecast__c = ba.TotalComputedCost__c;
					}
					else if (PLReportCategory == 'ODC - Contingency') {
						snapshot.ContingencyBudgetOriginal__c = ba.TotalComputedCost__c;
						snapshot.ContingencyForecast__c = ba.TotalComputedCost__c;
					}
					else if (PLReportCategory == 'Labor') {
						snapshot.LaborBudgetOriginal__c = ba.TotalComputedCost__c;
						snapshot.LaborForecast__c = ba.TotalComputedCost__c;
					}
					else if (PLReportCategory == 'Fringe') {
						snapshot.FringeBudgetOriginal__c = ba.TotalComputedCost__c;
						snapshot.FringeForecast__c = ba.TotalComputedCost__c;
					}
					else if (PLReportCategory == 'Overhead') {
						snapshot.OverheadBudgetOriginal__c = ba.TotalComputedCost__c;
						snapshot.OverheadForecast__c = ba.TotalComputedCost__c;
					}
				}
			}
		}
		catch(Exception e) {
			System.Debug(e.getStackTraceString());
		}
		return snapshot;
	}

	/* Total number of hours in current forecast budget (by Budget Assignment: ExpenditureResourceType=Lab; 
	   use Quantity; filter where Budget Header: Status  = Forecast)
	*/
	@TestVisible private ProjectSnapshot__c getOriginalOrForecastBudgetHoursInformation(ProjectSnapshot__c snapshot, 
		List<Id> projectIds) {
		try {
			List<AggregateResult> results = 
				[SELECT SUM(Quantity__c) Hours 
				 FROM BudgetAssignment__c
				 WHERE BudgetResource__r.ExpenditureResourceType__c = 'LAB'
				 AND (BudgetResource__r.BudgetHeader__r.OriginalBudget__c=true
				 OR BudgetResource__r.BudgetHeader__r.Status__c = 'Forecast' 
				 OR BudgetResource__r.BudgetHeader__r.Status__c = 'Approved') 
				 AND ProjectTask__r.pse__Project__r.Id IN : projectIds];

			for(AggregateResult ar: results)
			{
				Decimal hours = (Decimal)ar.get('Hours');
				if(hours != null) {
					snapshot.HoursBudgetOriginal__c = hours;
					snapshot.HoursForecast__c = hours;
					snapshot.HoursBudget__c = hours;
				}
			}
		}
		catch(Exception e) {
			System.Debug(e.getStackTraceString());
		}
		return snapshot;
	}

	@TestVisible private ProjectSnapshot__c getPreviousFMForecastInformation(ProjectSnapshot__c snapshot) 
	{
		String prevFiscalMonth = snapshot.SnapshotPreviousFiscalMonth__c;
		List<ProjectSnapshot__c> projectSnapshots = getPreviousFMForecastInformation(prevFiscalMonth);
		if (projectSnapshots != null && projectSnapshots.size() > 0) {
			ProjectSnapshot__c snapshotPrevFM = projectSnapshots[0]; //Should there be multi Snapshots ?
			snapshot.GrossRevenueForecastPrevME__c = snapshotPrevFM.GrossRevenueForecast__c;
			snapshot.CostsODCEXPSForecastPrevME__c = snapshotPrevFM.CostsODCEXPSForecast__c;
			snapshot.CostsODCSUBSForecastPrevME__c = snapshotPrevFM.CostsODCSUBSForecast__c;
			snapshot.ContingencyForecastPrevME__c = snapshotPrevFM.ContingencyForecast__c;
			snapshot.LaborForecastPrevME__c = snapshotPrevFM.LaborForecast__c;
			snapshot.FringeForecastPrevME__c = snapshotPrevFM.FringeForecast__c;
			snapshot.OverheadForecastPrevME__c = snapshotPrevFM.OverheadForecast__c;
			snapshot.HoursForecastPrevME__c = snapshotPrevFM.HoursForecast__c;
			snapshot.LostMarginForecast__c = snapshotPrevFM.LostMarginForecast__c;
			snapshot.ProjectEndDatePrevME__c = snapshotPrevFM.ProjectEndDate__c;
		}
		return snapshot;
	}

	private List<ProjectSnapshot__c> getPreviousFMForecastInformation(String prevFiscalMonth) 
	{	
		List<ProjectSnapshot__c> projSnapshots;
		try {
			projSnapshots = [SELECT Id, GrossRevenueForecast__c, 
				CostsODCEXPSForecast__c, CostsODCSUBSForecast__c, ContingencyForecast__c,
				LaborForecast__c, FringeForecast__c, OverheadForecast__c, HoursForecast__c, 
				LostMarginForecast__c, ProjectEndDate__c
				FROM ProjectSnapshot__c 
				WHERE SnapshotType__c = 'Auto' 
				AND SnapshotFiscalMonth__c =: prevFiscalMonth
				LIMIT 1]; // Which projSnapshot to SELECT if more than 1 ?
		}
		catch(Exception e) {
			System.Debug(e.getStackTraceString());
		}
		return projSnapshots;
	}
	
	private FinancialMetrics getDraftBudgetHeaderInformation(list<Id> projectIds)
	{
		FinancialMetrics metrics = new FinancialMetrics();
		try {
			for(AggregateResult ar : [SELECT SUM(TotalRevenue__c) totalRevenue
												, SUM(TotalCost__c) totalCost
												, SUM(TotalNonLabor__c) totalNonLabor
												, SUM(TotalLaborAmount__c) totalLabor
												, SUM(TotalContingencyAmount__c) totalContingency
										FROM BudgetHeader__c
										WHERE Project__c IN :projectIds
												AND Status__c = 'Estimate'])
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
		}
		catch(Exception e) {
			System.Debug(e.getStackTraceString());
		}	
		return metrics;
	}	
	
	/* "To find beginning of fiscal month AND fiscal year for MTD AND YTD calculations:
		Query Time Period object WHERE Start Date <= Today (or any input date) AND End Date >= Today
		AND WHERE (Type = 'Month' OR Type = 'Year').
		Take the Start Date FROM those records to become start date for current month or year, respectively.
		These become your time period start date for data calculations."
	*/
	private FinancialMetrics getProjectActualFinancials(list<Id> projectIds, Date asOfDate)
	{
		FinancialMetrics metrics = new FinancialMetrics();
		list<AggregateResult> results = new list<AggregateResult>();
		String query = 'SELECT SUM(Amount__c) totalRevenue FROM Revenue__c WHERE ProjectNumber__c IN :projectIds';
		if(asOfDate != null)
			query += ' AND GLDate__c >= :asOfDate AND GLDate__c <= TODAY';
		
		try {
			results = database.query(query); 
			
			for(AggregateResult ar: results)
			{
				if(ar.get('totalRevenue') != null)
					metrics.TotalRevenue = (Decimal)ar.get('totalRevenue');
			}
			
			query = 'SELECT SUM(ProjectRawCost__c) totalCost FROM CostDistLine__c WHERE ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id IN :projectIds';																						
			if(asOfDate != null)
				query += ' AND GLDate__c >= :asOfDate AND GLDate__c <= TODAY';
			results = database.query(query);
			for(AggregateResult ar: results)
			{
				if(ar.get('totalCost') != null)
					metrics.TotalCost = (Decimal)ar.get('totalCost');
					metrics.NetMargin = metrics.TotalRevenue - metrics.TotalCost;
			}

			query = 'SELECT SUM(ProjectRawCost__c) totalLabor FROM CostDistLine__c WHERE ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id IN :projectIds AND ExpenditureItem__r.ExpenditureType__c like  \'LAB% \'';																						
			if(asOfDate != null)
				query += ' AND GLDate__c >= :asOfDate AND GLDate__c <= TODAY';
			results = database.query(query);
			for(AggregateResult ar: results)
			{
				if(ar.get('totalLabor') != null)
					metrics.TotalLabor = (Decimal)ar.get('totalLabor');
			}
			
			query = 'SELECT SUM(ProjectRawCost__c) totalNonLabor FROM CostDistLine__c WHERE ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id IN :projectIds AND (NOT ExpenditureItem__r.ExpenditureType__c like  \'LAB% \')';																						
			if(asOfDate != null)
				query += ' AND GLDate__c >= :asOfDate AND GLDate__c <= TODAY';
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
		}
		catch(Exception e) {
			System.Debug(e.getStackTraceString());
		}
		return metrics;	
	}

	private Decimal getProjectActualFinancialsCostsODCEXPS(List<Id> projectIds, Date asOfDate)
	{
		FinancialMetrics metrics = new FinancialMetrics();
		list<AggregateResult> results = new list<AggregateResult>();
	
		try {
			//CostsODCEXPS
			String query = 'SELECT SUM(ProjectFunctionalBurdenedCost__c) CostsODCEXPS FROM CostDistLine__c'+
				' WHERE ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id IN :projectIds AND'+
				' ExpenditureItem__r.PLReportCategory__c = \'ODC - Exps\' ';																						
			if(asOfDate != null)
				query += ' AND ExpenditureItem__r.ExpenditureItemDate__c >= :asOfDate AND'+
					' ExpenditureItem__r.ExpenditureItemDate__c <= TODAY';
			results = database.query(query);
			for(AggregateResult ar : results)
			{
				if(ar.get('CostsODCEXPS') != null)
					metrics.CostsODCEXPS = (Decimal)ar.get('CostsODCEXPS');
			}
		}
		catch(Exception e) {
			System.Debug(e.getStackTraceString());
		}
		return metrics.CostsODCEXPS;
	}

	private Decimal getProjectActualFinancialsCostsODCSUBS(List<Id> projectIds, Date asOfDate)
	{
		FinancialMetrics metrics = new FinancialMetrics();
		list<AggregateResult> results = new list<AggregateResult>();
	
		try {
			//CostsODCSUBS
			String query = 'SELECT SUM(ProjectFunctionalBurdenedCost__c) CostsODCSUBS FROM CostDistLine__c'+
				' WHERE ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id IN :projectIds AND'+
				' ExpenditureItem__r.PLReportCategory__c = \'ODC - Subs\' ';																						
			if(asOfDate != null)
				query += ' AND ExpenditureItem__r.ExpenditureItemDate__c >= :asOfDate AND'+
					' ExpenditureItem__r.ExpenditureItemDate__c <= TODAY';
			results = database.query(query);
			for(AggregateResult ar : results)
			{
				if(ar.get('CostsODCSUBS') != null)
					metrics.CostsODCSUBS = (Decimal)ar.get('CostsODCSUBS');
			}
		}
		catch(Exception e) {
			System.Debug(e.getStackTraceString());
		}
		return metrics.CostsODCSUBS;
	}

	private Decimal getProjectActualFinancialsCostsLabor(List<Id> projectIds, Date asOfDate)
	{
		FinancialMetrics metrics = new FinancialMetrics();
		list<AggregateResult> results = new list<AggregateResult>();
	
		try {
			//Labor
			String query = 'SELECT SUM(ProjectFunctionalBurdenedCost__c) Labor FROM CostDistLine__c'+
				' WHERE ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id IN :projectIds AND'+
				' ExpenditureItem__r.PLReportCategory__c = \'Labor\' AND'+
				' ExpenditureItem__r.PLReportCategory__c != \'Fringe\' AND'+
				' ExpenditureItem__r.PLReportCategory__c != \'Overhead\' ';																					
			if(asOfDate != null)
				query += ' AND ExpenditureItem__r.ExpenditureItemDate__c >= :asOfDate AND'+
					' ExpenditureItem__r.ExpenditureItemDate__c <= TODAY';
			results = database.query(query);
			for(AggregateResult ar : results)
			{
				if(ar.get('Labor') != null)
					metrics.Labor = (Decimal)ar.get('Labor');
			}
		}
		catch(Exception e) {
			System.Debug(e.getStackTraceString());
		}
		return metrics.Labor;
	}

	private Decimal getProjectActualFinancialsCostsFringe(List<Id> projectIds, Date asOfDate)
	{
		FinancialMetrics metrics = new FinancialMetrics();
		list<AggregateResult> results = new list<AggregateResult>();
	
		try {
			//Fringe
			String query = 'SELECT SUM(ProjectFunctionalBurdenedCost__c) Fringe FROM CostDistLine__c'+
				' WHERE ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id IN :projectIds AND'+
				' ExpenditureItem__r.PLReportCategory__c = \'Fringe\' ';																					
			if(asOfDate != null)
				query += ' AND ExpenditureItem__r.ExpenditureItemDate__c >= :asOfDate AND'+
					' ExpenditureItem__r.ExpenditureItemDate__c <= TODAY';
			results = database.query(query);
			for(AggregateResult ar : results)
			{
				if(ar.get('Fringe') != null)
					metrics.Fringe = (Decimal)ar.get('Fringe');
			}
		}
		catch(Exception e) {
			System.Debug(e.getStackTraceString());
		}
		return metrics.Fringe;
	}

	private Decimal getProjectActualFinancialsCostsOverhead(List<Id> projectIds, Date asOfDate)
	{
		FinancialMetrics metrics = new FinancialMetrics();
		list<AggregateResult> results = new list<AggregateResult>();
	
		try {
			//Overhead
			String query = 'SELECT SUM(ProjectFunctionalBurdenedCost__c) Overhead FROM CostDistLine__c'+
				' WHERE ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id IN :projectIds AND'+
				' ExpenditureItem__r.PLReportCategory__c = \'Overhead\' ';																					
			if(asOfDate != null)
				query += ' AND ExpenditureItem__r.ExpenditureItemDate__c >= :asOfDate AND'+
					' ExpenditureItem__r.ExpenditureItemDate__c <= TODAY';
			results = database.query(query);
			for(AggregateResult ar : results)
			{
				if(ar.get('Overhead') != null)
					metrics.Overhead = (Decimal)ar.get('Overhead');
			}
		}
		catch(Exception e) {
			System.Debug(e.getStackTraceString());
		}
		return metrics.Overhead;
	}

	private Decimal getProjectActualFinancialsCostsHours(List<Id> projectIds, Date asOfDate)
	{
		FinancialMetrics metrics = new FinancialMetrics();
		list<AggregateResult> results = new list<AggregateResult>();
	
		try {
			//Hours
			String query = 'SELECT SUM(ExpenditureItem__r.Quantity__c) Hours FROM CostDistLine__c'+
				' WHERE ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id IN :projectIds';																
			if(asOfDate != null)
				query += ' AND ExpenditureItem__r.ExpenditureItemDate__c >= :asOfDate AND'+
					' ExpenditureItem__r.ExpenditureItemDate__c <= TODAY';
			results = database.query(query);
			for(AggregateResult ar : results)
			{
				if(ar.get('Hours') != null)
					metrics.Hours = (Decimal)ar.get('Hours');
			}
		}
		catch(Exception e) {
			System.Debug(e.getStackTraceString());
		}
		return metrics.Hours;
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
		try {
			for(AggregateResult ar: [SELECT SUM(InvoiceAmount__c) totalBilled, SUM(RetentionAmount__c) totalRetention
							FROM Billing__c WHERE ProjectNumber__c IN :projectIds])
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
			for(AggregateResult ar: [SELECT SUM(InvoiceAmount__c) totalBilled0to30 
							FROM Billing__c WHERE ProjectNumber__c IN :projectIds AND
							InvoiceDate__c <= :startDate AND InvoiceDate__c >= :endDate])
			{
				if(ar.get('totalBilled0to30') != null)
				{
					billingMetrics.Billed0to30 = (Decimal)ar.get('totalBilled0to30');
				}
			}
			
			startDate = Date.today().addDays(-31);
			endDate = Date.today().addDays(-60);
			for(AggregateResult ar: [SELECT SUM(InvoiceAmount__c) totalBilled31to60 
							FROM Billing__c WHERE ProjectNumber__c IN :projectIds AND
							InvoiceDate__c <= :startDate AND InvoiceDate__c >= :endDate])
			{
				if(ar.get('totalBilled31to60') != null)
					billingMetrics.Billed31to60 = (Decimal)ar.get('totalBilled31to60');
			}

			startDate = Date.today().addDays(-61);
			endDate = Date.today().addDays(-90);
			for(AggregateResult ar: [SELECT SUM(InvoiceAmount__c) totalBilled61to90 
							FROM Billing__c WHERE ProjectNumber__c IN :projectIds AND
							InvoiceDate__c <= :startDate AND InvoiceDate__c >= :endDate])
			{
				if(ar.get('totalBilled61to90') != null)
					billingMetrics.Billed61to90 = (Decimal)ar.get('totalBilled61to90');
			}

			startDate = Date.today().addDays(-91);
			endDate = Date.today().addDays(-180);
			for(AggregateResult ar: [SELECT SUM(InvoiceAmount__c) totalBilled91to180 
							FROM Billing__c WHERE ProjectNumber__c IN :projectIds AND
							InvoiceDate__c <= :startDate AND InvoiceDate__c >= :endDate])
			{
				if(ar.get('totalBilled91to180') != null)
					billingMetrics.Billed91to180 = (Decimal)ar.get('totalBilled91to180');
			}
	
			startDate = Date.today().addDays(-181);
			for(AggregateResult ar: [SELECT SUM(InvoiceAmount__c) totalBilled181Plus 
							FROM Billing__c WHERE ProjectNumber__c IN :projectIds AND
							InvoiceDate__c <= :startDate])
			{
				if(ar.get('totalBilled181Plus') != null)
					billingMetrics.Billed181Plus = (Decimal)ar.get('totalBilled181Plus');
			}		
			

			// Unbilled
			startDate = Date.today().addDays(-180);
			for(AggregateResult ar:[SELECT SUM(Amount__c) totalRevenue FROM Revenue__c WHERE ProjectNumber__c IN :projectIds 
													AND GLDate__c < :startDate])
			{
				if((Decimal)ar.get('totalRevenue') != null)
					billingMetrics.Unbilled181Plus = (Decimal)ar.get('totalRevenue') - billingMetrics.BilledAR;
				else
					billingMetrics.Unbilled181Plus = 0 - billingMetrics.BilledAR;
			}					

			startDate = Date.today().addDays(-90);
			for(AggregateResult ar:[SELECT SUM(Amount__c) totalRevenue FROM Revenue__c WHERE ProjectNumber__c IN :projectIds 
													AND GLDate__c < :startDate])
			{
				if((Decimal)ar.get('totalRevenue') != null)
					billingMetrics.Unbilled91to180 = (Decimal)ar.get('totalRevenue') - (billingMetrics.BilledAR + billingMetrics.Unbilled181Plus);
				else
					billingMetrics.Unbilled91to180 = 0 - (billingMetrics.BilledAR + billingMetrics.Unbilled181Plus);
			}

			startDate = Date.today().addDays(-60);
			for(AggregateResult ar:[SELECT SUM(Amount__c) totalRevenue FROM Revenue__c WHERE ProjectNumber__c IN :projectIds 
													AND GLDate__c < :startDate])
			{
				if((Decimal)ar.get('totalRevenue') != null)	
					billingMetrics.Unbilled61to90 = (Decimal)ar.get('totalRevenue') - (billingMetrics.BilledAR + billingMetrics.Unbilled181Plus + billingMetrics.Unbilled91to180);
				else
					billingMetrics.Unbilled61to90 = 0 - (billingMetrics.BilledAR + billingMetrics.Unbilled181Plus + billingMetrics.Unbilled91to180);
			}

			startDate = Date.today().addDays(-30);
			for(AggregateResult ar:[SELECT SUM(Amount__c) totalRevenue FROM Revenue__c WHERE ProjectNumber__c IN :projectIds 
													AND GLDate__c < :startDate])
			{
				if((Decimal)ar.get('totalRevenue') != null)	
					billingMetrics.Unbilled31to60 = (Decimal)ar.get('totalRevenue') - (billingMetrics.BilledAR + billingMetrics.Unbilled181Plus + billingMetrics.Unbilled91to180 + billingMetrics.Unbilled61to90);
				else
					billingMetrics.Unbilled31to60 = 0 - (billingMetrics.BilledAR + billingMetrics.Unbilled181Plus + billingMetrics.Unbilled91to180 + billingMetrics.Unbilled61to90);
			}		
			
			startDate = Date.today().addDays(0);
			for(AggregateResult ar:[SELECT SUM(Amount__c) totalRevenue FROM Revenue__c WHERE ProjectNumber__c IN :projectIds 
													AND GLDate__c < :startDate])
			{
				if((Decimal)ar.get('totalRevenue') != null)	
					billingMetrics.Unbilled0to30 = (Decimal)ar.get('totalRevenue') - (billingMetrics.BilledAR + billingMetrics.Unbilled181Plus + billingMetrics.Unbilled91to180 + billingMetrics.Unbilled61to90 + billingMetrics.Unbilled31to60);
				else
					billingMetrics.Unbilled0to30 = 0 - (billingMetrics.BilledAR + billingMetrics.Unbilled181Plus + billingMetrics.Unbilled91to180 + billingMetrics.Unbilled61to90 + billingMetrics.Unbilled31to60);
			}
		}
		catch(Exception e) {
			System.Debug(e.getStackTraceString());
		}
		return billingMetrics;
	}
}