public class ECO_Service_ProjectSnapshots {
    public static final String ODC_Exps = 'ODC - Exps';
    public static final String ODC_Subs = 'ODC - Subs';
    public static final String ODC_Contingency = 'ODC - Contingency';

    public static final String BILLED_0to30 = 'Billed0to30';
    public static final String BILLED_31to60 = 'Billed31to60';
    public static final String BILLED_61to90 = 'Billed61to90';
    public static final String BILLED_91to180 = 'Billed91to180';
    public static final String BILLED_181Plus = 'Billed181Plus';
    
    public static final String UNBILLED_0to30 = 'Unbilled0to30';
    public static final String UNBILLED_31to60 = 'Unbilled31to60';
    public static final String UNBILLED_61to90 = 'Unbilled61to90';
    public static final String UNBILLED_91to180 = 'Unbilled91to180';
    public static final String UNBILLED_181Plus = 'Unbilled181Plus';
    
    public static final String AECOM_FISCAL_WEEK_END_DAY = 'Friday';
    
    public DateTime pSnapshotDateTime {get; set;}
    public Date pSnapshotDate {get; set;}
    public Date pSnapshotLatestFiscalWeekEndDate {get; set;}
    
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
    
    private map<Id, List<Id>> organizationProjectsMap;
    private map<Id, String> organizationNameMap;
    private map<String, Decimal> organizationProjectPercentage;
    private Id primaryOrganizationId;
    private List<Id> projectIds;

    public static Set<String> plReportCategorySet = new Set<String>();
            
    Map<Id, FinancialMetrics> originalBudgetHeaderMap;
    Map<Id, FinancialMetrics> approvedBudgetHeaderMap;
    Map<Id, DateTime> lastUpdatedBudgetDateMap;
    Map<Id, FinancialMetrics> forecastBudgetHeaderMap;
    Map<Id, FinancialMetrics> draftBudgetHeaderMap;
    Map<Id, FinancialMetrics> unapprovedBudgetHeaderMap;
    Map<String, pse__Time_Period__c> timePeriodMap;
    Map<Id, FinancialMetrics> mtdActualFinancialMetricsMap;
    Map<Id, FinancialMetrics> itdActualFinancialMetricsMap;
    Map<Id, FinancialMetrics> ytdActualFinancialMetricsMap;
    Map<Id, FinancialMetrics> totalCostITD3MonthsAgoMetricsMap;

    Map<Id, ProjectSnapshot__c> originalOrForecastBudgetCostsMap;
    Map<Id, ProjectSnapshot__c> originalOrForecastBudgetHoursMap;
    Map<Id, ProjectSnapshot__c> previousFMForecastMap;

    Map<Id, BillingMetrics> billingMetricsARMap;
    Map<Id, Decimal> billingMetricsAR0to30Map;
    Map<Id, Decimal> billingMetricsAR31to60Map;
    Map<Id, Decimal> billingMetricsAR61to90Map;
    Map<Id, Decimal> billingMetricsAR91to180Map;
    Map<Id, Decimal> billingMetricsAR181PlusMap;
    
    Map<Id, BillingMetrics> unbilledMetricsARMap;
    Map<Id, Decimal> unbilledMetricsAR0to30Map;
    Map<Id, Decimal> unbilledMetricsAR31to60Map;
    Map<Id, Decimal> unbilledMetricsAR61to90Map;
    Map<Id, Decimal> unbilledMetricsAR91to180Map;
    Map<Id, Decimal> unbilledMetricsAR181PlusMap;
    
    @TestVisible private class ProjectOrganization
    {
        public Id OrganizationId {get; set;}
        public String OrganizationName {get; set;}
        public Decimal AllocationPercentage {get; set;}
    }
        
    @TestVisible private class FinancialMetrics
    {
        public Decimal TotalRevenue {get; set;}
        public Decimal TotalCost {get; set;}
        public Decimal TotalLabor {get; set;}
        public Decimal TotalNonLabor {get; set;}
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
            TotalContingency = 0;
            CostsODCEXPS = 0;
            CostsODCSUBS = 0;
            Labor = 0;
            Fringe = 0;
            Overhead = 0;
            Hours = 0;
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
    
    public ECO_Service_ProjectSnapshots(List<Id> snapshotProjectIds)
    {
        organizationProjectsMap = new map<Id, List<Id>>();
        organizationNameMap = new map<Id, String>();
        organizationProjectPercentage = new map<String, Decimal>(); 
        projectIds = snapshotProjectIds;
    }
    
    public ECO_Service_ProjectSnapshots(Id snapshotProjectId)
    {
        organizationProjectsMap = new map<Id, List<Id>>();
        organizationNameMap = new map<Id, String>();
        organizationProjectPercentage = new map<String, Decimal>(); 
        projectIds = new List<Id>();
        projectIds.add(snapshotProjectId);
        
        try {
            List<EarnedValueHeader__c> evHeaders = [SELECT Id FROM EarnedValueHeader__c 
            WHERE Project__c = :snapshotProjectId order by Id desc];
            
            if (!evHeaders.isEmpty()){
                List<EarnedValueSnapshot__c> snapshots = [SELECT Id FROM EarnedValueSnapshot__c
                                                    WHERE ProjectTask__r.pse__Project__c = :snapshotProjectId];
                
                if (!snapshots.isEmpty())
                {
                    earnedValueController = new ECO_EarnedValueReportController(evHeaders[0].Id);
                
                    List<EarnedValueTask__c> earnedValueTasks = [SELECT EarnedValueSnapshot__c
                                                    , EarnedValueSnapshot__r.WeekStartDate__c
                                                    , SnapshotDate__c
                                                    , LastModifiedDate
                                                FROM EarnedValueTask__c
                                                WHERE EarnedValueHeader__c = :evHeaders[0].Id
                                                ORDER BY SnapshotDate__c DESC
                                                LIMIT 1];
                    
                    if (!earnedValueTasks.isEmpty())
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
        
    public ProjectSnapshot__c getProjectSnapshot(DateTime pSnapshotAsOfDateTime)
    {
        List<ProjectSnapshot__c> snapshotList;
        if (pSnapshotAsOfDateTime == null) {
        	pSnapshotAsOfDateTime = DateTime.now();
        }
        snapshotList = createProjectSnapshots(pSnapshotAsOfDateTime);
        if (snapshotList != null && !snapshotList.isEmpty()) {
            return snapshotList[0];
        }
        else {
            return null;
        }
    }
    
    public List<ProjectSnapshot__c> createProjectSnapshots(DateTime pSnapshotAsOfDateTime)
    {
        pSnapshotDateTime = pSnapshotAsOfDateTime;
        if (pSnapshotAsOfDateTime == null) {
        	pSnapshotAsOfDateTime = DateTime.now();
        }
        pSnapshotDate = pSnapshotDateTime.date();
        System.debug(System.LoggingLevel.WARN, '___pSnapshotDate='+pSnapshotDate);
        
        List<ProjectSnapshot__c> snapshotList = new List<ProjectSnapshot__c>();
        try {
            System.debug(System.LoggingLevel.WARN, '___createProjectSnapshots Query rows INITIAL='+
            	Limits.getQueryRows());
            
            populateOrganizationsMaps(projectIds);
            
            List<pse__Proj__c> projects;
            
            try {
                projects = [SELECT Id, Name, ProjectReviewCategory__c, PrimaryEndClientName__c, pse__Account__r.Name,
                    pse__Project_Manager__c, OracleProjectnumber__c, pse__End_Date__c, pse__Start_Date__c
                    FROM pse__Proj__c WHERE Id IN :projectIds];     
            }
            catch(Exception e) {
                System.Debug(e.getStackTraceString());
            }

            if (projects != null && !projects.isEmpty()) {
                System.debug(System.LoggingLevel.WARN, '___projects.size() ='+projects.size());
                Id changeOrderRecordTypeId = 
                    ECO_Utils_Meta.getRecordTypeId(BudgetHeader__c.sObjectType, 'Change Order');

                originalBudgetHeaderMap = getOriginalBudgetHeaderMap(projectIds, false);
                approvedBudgetHeaderMap = getApprovedBudgetHeaderMap(projectIds, false);
                lastUpdatedBudgetDateMap = getLastUpdatedBudgetDateMap(projectIds);
                forecastBudgetHeaderMap = getForecastBudgetHeaderMap(projectIds);
                draftBudgetHeaderMap = getDraftBudgetHeaderMap(projectIds);
                unapprovedBudgetHeaderMap = getUnapprovedBudgetHeaderMap(projectIds, true);
                
                pSnapshotLatestFiscalWeekEndDate = getLatestFiscalWeekEndDate();
                
                timePeriodMap = getTimePeriodMap();
      			Date monthStartDate;
      			Date yearStartDate;
      			
      			if (!timePeriodMap.isEmpty()) {
	                pse__Time_Period__c monthTP = (pse__Time_Period__c) timePeriodMap.get('Month');
	                if (monthTP != null) {
		                monthStartDate = monthTP.pse__Start_Date__c;
		                System.debug(System.LoggingLevel.WARN, '___monthStartDate='+monthStartDate);
		                if (monthStartDate != null) {
			                mtdActualFinancialMetricsMap = getProjectActualFinancialsMap(projectIds, monthStartDate);  
							System.debug(System.LoggingLevel.WARN, '___mtdActualFinancialMetricsMap='+mtdActualFinancialMetricsMap);
		                }
	                }
      			}
      			
                itdActualFinancialMetricsMap = getProjectActualFinancialsMap(projectIds, null);

                billingMetricsARMap = getBillingMetricsARMap(projectIds, itdActualFinancialMetricsMap);

				if (!timePeriodMap.isEmpty()) {
	                pse__Time_Period__c yearTP = (pse__Time_Period__c) timePeriodMap.get('Year');
	                if (yearTP != null) {
		                yearStartDate = yearTP.pse__Start_Date__c;
		                System.debug(System.LoggingLevel.WARN, '___yearStartDate='+yearStartDate);
		                if (yearStartDate != null) {
		                	ytdActualFinancialMetricsMap = getProjectActualFinancialsMap(projectIds, yearStartDate);
							System.debug(System.LoggingLevel.WARN, '___ytdActualFinancialMetricsMap='+ytdActualFinancialMetricsMap);
		                }
	                }
				}
				
				Map<Id, List<Billing__c>> billingMetricsARMapProjects = getBillingMetricsARMap(projectIds);
				System.debug(System.LoggingLevel.WARN, '___billingMetricsARMapProjects='+billingMetricsARMapProjects);
				getBillingMetricsARDateRangeMap(projectIds, billingMetricsARMapProjects); // sets up individual billingMetrics "Date Range" maps
				System.debug(System.LoggingLevel.WARN, '___billingMetricsAR0to30Map='+billingMetricsAR0to30Map);
                System.debug(System.LoggingLevel.WARN, '___billingMetricsAR31to60Map='+billingMetricsAR31to60Map);
                System.debug(System.LoggingLevel.WARN, '___billingMetricsAR61to90Map='+billingMetricsAR61to90Map);
                System.debug(System.LoggingLevel.WARN, '___billingMetricsAR91to180Map='+billingMetricsAR91to180Map);
                System.debug(System.LoggingLevel.WARN, '___billingMetricsAR181PlusMap='+billingMetricsAR181PlusMap);
                
				System.debug(System.LoggingLevel.WARN, '___Query rows BILLED='+Limits.getQueryRows());

                // Note: Unbilled calculations are in reverse order
                unbilledMetricsAR181PlusMap = getUnbilledMetricsARDateRangeMap(projectIds, UNBILLED_181Plus);
                unbilledMetricsAR91to180Map = getUnbilledMetricsARDateRangeMap(projectIds, UNBILLED_91to180);
                unbilledMetricsAR61to90Map = getUnbilledMetricsARDateRangeMap(projectIds, UNBILLED_61to90);
                unbilledMetricsAR31to60Map = getUnbilledMetricsARDateRangeMap(projectIds, UNBILLED_31to60);
                unbilledMetricsAR0to30Map = getUnbilledMetricsARDateRangeMap(projectIds, UNBILLED_0to30);

				System.debug(System.LoggingLevel.WARN, '___Query rows UNBILLED='+Limits.getQueryRows());
                
                ProjectSnapshot__c snapshot;
                
                Map<Id, ProjectSnapshot__c> projIdToSnapshotMap = new Map<Id, ProjectSnapshot__c>();

                for (pse__Proj__c project : projects) {
                    snapshot = new ProjectSnapshot__c();
                    snapshot.SnapshotDate__c = pSnapshotDate;
                    snapshot.ProjectName__c = project.Name;
                    snapshot.ProjectRating__c = project.ProjectReviewCategory__c;
                    snapshot.ClientName__c = project.pse__Account__r.Name;
                    snapshot.ProjectManager__c = project.pse__Project_Manager__c;
                    snapshot.ProjectDirector__c = ECO_Service_ProjectTeam.getActiveProjectApproverId(project.Id);
                    snapshot.ProjectNumber__c = project.OracleProjectNumber__c;
                    snapshot.ProjectStartDate__c = project.pse__Start_Date__c;
                    snapshot.ProjectEndDate__c = project.pse__End_Date__c;
                    
                    snapshot.CostsODCEXPSBudgetOriginal__c = 0;
                    snapshot.CostsODCSUBSBudgetOriginal__c = 0;
                    snapshot.ContingencyBudgetOriginal__c = 0;
                    snapshot.LaborBudgetOriginal__c = 0;
                    snapshot.FringeBudgetOriginal__c = 0;
                    snapshot.OverheadBudgetOriginal__c = 0;
                    
                    snapshot.CostsODCEXPSBudget__c = 0;
                    snapshot.CostsODCSUBSBudget__c = 0;
                    snapshot.ContingencyBudget__c = 0;
                    snapshot.LaborBudget__c = 0;
                    snapshot.FringeBudget__c = 0;
                    snapshot.OverheadBudget__c = 0;
                    
                    snapshot.CostsODCEXPSUnapproved__c = 0;
                    snapshot.CostsODCSUBSUnapproved__c = 0;
                    snapshot.ContingencyUnapproved__c = 0;
                    snapshot.LaborUnapproved__c = 0;
                    snapshot.FringeUnapproved__c = 0;
                    snapshot.OverheadUnapproved__c = 0;
	                
	                snapshot.CostsODCEXPSForecast__c = 0;
	                snapshot.CostsODCSUBSForecast__c = 0;
	                snapshot.ContingencyForecast__c = 0;
	                snapshot.LaborForecast__c = 0;
	                snapshot.FringeForecast__c = 0;
	                snapshot.OverheadForecast__c = 0;
	                
	                snapshot.HoursBudget__c = 0;
	                snapshot.HoursBudgetOriginal__c = 0;
	                snapshot.HoursForecast__c = 0;
	                snapshot.HoursDraft__c = 0;
	                snapshot.HoursUnapproved__c = 0;
	                
                    snapshot.AR0to30__c = 0;
                    snapshot.AR31to60__c = 0;
                    snapshot.AR61to90__c = 0;
                    snapshot.AR91to180__c = 0;
                    snapshot.AR181Plus__c = 0;
                    snapshot.Unbilled181Plus__c = 0;
                    snapshot.Unbilled91to180__c = 0;
                    snapshot.Unbilled61to90__c = 0;
                    snapshot.Unbilled31to60__c = 0;
                    snapshot.Unbilled0to30__c = 0;
                    snapshot.Project__c = project.Id;
                    projIdToSnapshotMap.put(project.Id, snapshot);
                }

                List<ProjectSnapshot__c> tempSnapshotList = projIdToSnapshotMap.values();
                projIdToSnapshotMap = getSnapshotFiscalMonths(tempSnapshotList);
                originalOrForecastBudgetCostsMap = getOriginalOrForecastBudgetCostsMap(projectIds, projIdToSnapshotMap);
                originalOrForecastBudgetHoursMap = getOriginalOrForecastBudgetHoursMap(projectIds, projIdToSnapshotMap);
                previousFMForecastMap = getPreviousFMForecastMap(projIdToSnapshotMap);
                
                totalCostITD3MonthsAgoMetricsMap = getTotalCostITD3MonthsAgoMap(projectIds);
                
                populateFutureSpendMaps(projectIds);
                
                for (pse__Proj__c project : projects) {
                    snapshot = projIdToSnapshotMap.get(project.Id);
                    if (projectIds.size() == 1) {
                        //Change Orders 
                        snapshot.ChangeOrdersPending__c = getPendingChangeOrders(projectIds, changeOrderRecordTypeId);
                        snapshot.ChangeOrdersDraft__c = getDraftChangedOrders(projectIds, changeOrderRecordTypeId);
                        
                        //Primary Organization
                        snapshot.PrimaryOrganization__c = organizationNameMap.get(primaryOrganizationId);

                        //Agreements
                        snapshot.RelatedAgreements__c = getRelatedAgreements(projectIds);
                        
                        //Project Tasks
                        snapshot.ProjectTasks__c = getRelatedProjectTasks(projectIds);
                        
                        //Organizations
                        for (Id organizationId:organizationNameMap.keyset()){
                            if (organizationId != primaryOrganizationId)
                            {
                                if (snapshot.SecondaryOrganizations__c == '' || snapshot.SecondaryOrganizations__c == null) {
                                    snapshot.SecondaryOrganizations__c = organizationNameMap.get(organizationId);   
                                }
                                else {
                                    snapshot.SecondaryOrganizations__c += '::' + organizationNameMap.get(organizationId);
                                }
                            }   
                        }   
                        
                        //Earned Value
                        if (EarnedValueSnapshotDate != null)
                        {
                            snapshot.EarnedValuePlannedValue__c = earnedValueController.mapDatePlannedValues.get(EarnedValueSnapshotDate);
                            snapshot.EarnedValue__c = earnedValueController.mapDateEarnedValues.get(EarnedValueSnapshotDate);
                            snapshot.EarnedValueActualSpend__c = earnedValueController.mapDateActualCosts.get(EarnedValueSnapshotDate);
                            snapshot.EarnedValueLastUpdated__c = EarnedValueLastModifiedDate;
                            snapshot.EarnedValueOverallProgress__c = 0;
                            snapshot.EarnedValuePercentBudgetSpent__c = 0;
                        }
                    }

                    // Original Budget
                    FinancialMetrics originalBudgetFinancialMetrics = originalBudgetHeaderMap.get(project.Id);
                    snapshot = getOriginalBudgetHeaderMapInformation(originalBudgetFinancialMetrics, snapshot);
                    
                    //Approved Budget
                    FinancialMetrics approvedBudgetFinancialMetrics = approvedBudgetHeaderMap.get(project.Id);
                    snapshot = getApprovedBudgetHeaderMapInformation(approvedBudgetFinancialMetrics, snapshot);
                    
                    //LastUpdated Budget
                    if (lastUpdatedBudgetDateMap != null) {
                        snapshot.LastUpdatedBudget__c = lastUpdatedBudgetDateMap.get(project.Id);
                    }
                    
                    //Forecast Budget
                    FinancialMetrics forecastBudgetFinancialMetrics = forecastBudgetHeaderMap.get(project.Id);
                    snapshot = getForecastBudgetHeaderMapInformation(forecastBudgetFinancialMetrics, snapshot);
                    
                    //RunRateAverageCost related
                    FinancialMetrics costITD3MonthsAgoFinancialMetrics = totalCostITD3MonthsAgoMetricsMap.get(project.Id);
                    snapshot = getTotalCostITD3MonthsAgoMapInformation(costITD3MonthsAgoFinancialMetrics, snapshot);
                    
                    // Costs Forecast EAC
                    snapshot = originalOrForecastBudgetCostsMap.get(project.Id);

                    // Hours Forecast EAC
                    snapshot = originalOrForecastBudgetHoursMap.get(project.Id);
                    
                    //Previous Forecast
                    snapshot = previousFMForecastMap.get(project.Id);

                    //Draft
                    FinancialMetrics draftBudgetFinancialMetrics = draftBudgetHeaderMap.get(project.Id);
                    snapshot = getDraftBudgetHeaderMapInformation(draftBudgetFinancialMetrics, snapshot);

                    //Unapproved                
                    FinancialMetrics unapprovedBudgetFinancialMetrics = unapprovedBudgetHeaderMap.get(project.Id);
                    snapshot = getUnapprovedBudgetHeaderMapInformation(unapprovedBudgetFinancialMetrics, snapshot);
                    
	                if (!timePeriodMap.isEmpty()) {
	                    // MTD
	                    if (mtdActualFinancialMetricsMap != null && !mtdActualFinancialMetricsMap.isEmpty()) {
		                    FinancialMetrics mtdFinancialMetrics = mtdActualFinancialMetricsMap.get(project.Id);
		                    snapshot = getMtdActualFinancialMetricsMapInformation(mtdFinancialMetrics, snapshot, monthStartDate);
	                    }
	                }
	                    
                    // ITD
                    FinancialMetrics itdFinancialMetrics = itdActualFinancialMetricsMap.get(project.Id);
                    snapshot = getItdActualFinancialMetricsMapInformation(itdFinancialMetrics, snapshot);
                    
                    if (!timePeriodMap.isEmpty()) {
	                    // YTD
	                    if (ytdActualFinancialMetricsMap != null && !ytdActualFinancialMetricsMap.isEmpty()) {
		                    FinancialMetrics ytdFinancialMetrics = ytdActualFinancialMetricsMap.get(project.Id);
		                    snapshot = getYtdActualFinancialMetricsMapInformation(ytdFinancialMetrics, snapshot, yearStartDate);
	                    }
                    }
                    
                    // Billing Metrics
                    System.debug(System.LoggingLevel.WARN, '___createProjectSnapshots: billingMetricsARMap='+billingMetricsARMap);
                    BillingMetrics billingMetricsAR = billingMetricsARMap.get(project.Id);
                    if (billingMetricsAR != null) {
                        snapshot = getBillingMetricsARMapInformation(billingMetricsAR, snapshot);
                        if (billingMetricsAR0to30Map.containsKey(project.Id)) {
                            snapshot.AR0to30__c = billingMetricsAR0to30Map.get(project.Id);
                        }
                        
                        if (billingMetricsAR31to60Map.containsKey(project.Id)) {
                            snapshot.AR31to60__c = billingMetricsAR31to60Map.get(project.Id);
                        }
                        
                        if (billingMetricsAR61to90Map.containsKey(project.Id)) {
                            snapshot.AR61to90__c = billingMetricsAR61to90Map.get(project.Id);
                        }
                        
                        if (billingMetricsAR91to180Map.containsKey(project.Id)) {
                            snapshot.AR91to180__c = billingMetricsAR91to180Map.get(project.Id);
                        }
                        
                        if (billingMetricsAR181PlusMap.containsKey(project.Id)) {
                            snapshot.AR181Plus__c = billingMetricsAR181PlusMap.get(project.Id);
                        }
                        
                        snapshot.ARTotal__c = billingMetricsAR.BilledAR;
                        snapshot.ARRetention__c = billingMetricsAR.Retention;
                        snapshot.ARBIEE__c = billingMetricsAR.BIEE;
                        snapshot.UnbilledTotal__c = billingMetricsAR.TotalUnbilled;
                        
                        System.debug(System.LoggingLevel.WARN, '___createProjectSnapshots: Billed snapshot='+snapshot);
                    }
                    
                    // Unbilled Metrics 
                    if (unbilledMetricsAR181PlusMap.containsKey(project.Id)) {
                        snapshot.Unbilled181Plus__c = unbilledMetricsAR181PlusMap.get(project.Id);
                    }
                    
                    if (unbilledMetricsAR91to180Map.containsKey(project.Id)) {
                        snapshot.Unbilled91to180__c = unbilledMetricsAR91to180Map.get(project.Id);
                    }
                    
                    if (unbilledMetricsAR61to90Map.containsKey(project.Id)) {
                        snapshot.Unbilled61to90__c = unbilledMetricsAR61to90Map.get(project.Id);
                    }
                    
                    if (unbilledMetricsAR31to60Map.containsKey(project.Id)) {
                        snapshot.Unbilled31to60__c = unbilledMetricsAR31to60Map.get(project.Id);
                    }
                    
                    if (unbilledMetricsAR0to30Map.containsKey(project.Id)) {
                        snapshot.Unbilled0to30__c = unbilledMetricsAR0to30Map.get(project.Id);
                    }
                    
                    // Future Spend
                    snapshot = getFutureSpendInformation(snapshot);
                    
                    //System.debug(System.LoggingLevel.WARN, '___createProjectSnapshots: snapshot='+snapshot);
                    snapshotList.add(snapshot);
                }   
            }
            
            if (!snapshotList.isEmpty()) {
                System.debug(System.loggingLevel.WARN, '___snapshotList.size()='+snapshotList.size());
                insert snapshotList;
            } 
        }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }
        return snapshotList;
    }
    
    /////// Future Spend
    @TestVisible private void populateFutureSpendMaps(List<Id> projectIds) {
        projectMonth1FutureSpend = getFutureSpendForPeriodMap(projectIds, pSnapshotDate, pSnapshotDate.addMonths(1));
        projectMonth2FutureSpend = getFutureSpendForPeriodMap(projectIds, pSnapshotDate.addMonths(1), pSnapshotDate.addMonths(2));        
        projectMonth3FutureSpend = getFutureSpendForPeriodMap(projectIds, pSnapshotDate.addMonths(2), pSnapshotDate.addMonths(3));        
        projectMonth4FutureSpend = getFutureSpendForPeriodMap(projectIds, pSnapshotDate.addMonths(3), pSnapshotDate.addMonths(4));        
        projectMonth5FutureSpend = getFutureSpendForPeriodMap(projectIds, pSnapshotDate.addMonths(4), pSnapshotDate.addMonths(5));        
        projectMonth6FutureSpend = getFutureSpendForPeriodMap(projectIds, pSnapshotDate.addMonths(5), pSnapshotDate.addMonths(6));        
    }
    
    @TestVisible private ProjectSnapshot__c getFutureSpendInformation(ProjectSnapshot__c snapshot) {
        Decimal projectPercent;
        Decimal month1Spend = 0;
        Decimal month2Spend = 0;
        Decimal month3Spend = 0;
        Decimal month4Spend = 0;
        Decimal month5Spend = 0;
        Decimal month6Spend = 0;
        
        for (Id organizationId:organizationNameMap.keyset())
        {
            for (Id projId:organizationProjectsMap.get(organizationId))
            {
                projectPercent = organizationProjectPercentage.get(organizationId + '-' + projId);  
                month1Spend += projectPercent/100 * returnMapDecimalValue(projectMonth1FutureSpend.get(projId));
                month2Spend += projectPercent/100 * returnMapDecimalValue(projectMonth2FutureSpend.get(projId));
                month3Spend += projectPercent/100 * returnMapDecimalValue(projectMonth3FutureSpend.get(projId));
                month4Spend += projectPercent/100 * returnMapDecimalValue(projectMonth4FutureSpend.get(projId));
                month5Spend += projectPercent/100 * returnMapDecimalValue(projectMonth5FutureSpend.get(projId));
                month6Spend += projectPercent/100 * returnMapDecimalValue(projectMonth6FutureSpend.get(projId));
            }
            
            if (snapshot.PrimaryFutureSpend__c == '' || snapshot.PrimaryFutureSpend__c == null) {
                snapshot.PrimaryFutureSpend__c = organizationNameMap.get(organizationId);
            }
            else {
                snapshot.PrimaryFutureSpend__c += ';;' + organizationNameMap.get(organizationId);
            }
            
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
    ///// END: Future Spend

    private Map<Id, BillingMetrics> getBillingMetricsARMap(List<Id> projectIds, Map<Id, FinancialMetrics> itdActualFinancialMetricsMap)
    {
        Map<Id, BillingMetrics> billingMetricsMap = new Map<Id, BillingMetrics>();
        BillingMetrics billingMetrics;
        try {
            System.debug(System.LoggingLevel.WARN, '___itdActualFinancialMetricsMap='+itdActualFinancialMetricsMap);
            
            /**ERROR: SOQL "cuts off" after FROM Billing__c: for (AggregateResult ar: [SELECT ProjectNumber__c, SUM(InvoiceAmount__c) totalBilled, SUM(RetentionAmount__c) totalRetention
                            FROM Billing__c WHERE ProjectNumber__c IN :projectIds GROUP BY ProjectNumber__c])
            */
            String query = 'SELECT ProjectNumber__c, SUM(InvoiceAmount__c) totalBilled, SUM(RetentionAmount__c) totalRetention'+
                ' FROM Billing__c WHERE ProjectNumber__c IN :projectIds GROUP BY ProjectNumber__c';
            
            List<AggregateResult> results = database.query(query); 
            System.debug(System.LoggingLevel.WARN, '___SOQL queries='+Limits.getQueries());
            for (AggregateResult ar : results) {      
                Decimal totalBilledValue = (Decimal) ar.get('totalBilled');
                if (totalBilledValue != null)
                {   
                    if (itdActualFinancialMetricsMap != null) {
                        billingMetrics = new BillingMetrics();
                        Id projId = (Id) ar.get('ProjectNumber__c');
                        System.debug(System.LoggingLevel.WARN, '___projId from ProjectNumber__c='+projId);
                        FinancialMetrics itdFM = itdActualFinancialMetricsMap.get(projId);
                        if (itdFM != null) {
                            Decimal totalRevenue = itdFM.TotalRevenue;
                            System.debug(System.LoggingLevel.WARN, '___itdFM totalRevenue='+totalRevenue);
                            if (totalBilledValue != null) {
                                billingMetrics.BilledAR = (Decimal)ar.get('totalBilled');   
                            }
                            billingMetrics.Retention =  (Decimal)ar.get('totalRetention');  
                            billingMetrics.TotalUnbilled = totalRevenue - billingMetrics.BilledAR;
                            if ((billingMetrics.TotalUnbilled) < 0) {
                                billingMetrics.BIEE = totalRevenue - billingMetrics.BilledAR;
                            }
                            billingMetricsMap.put(projId, billingMetrics);
                            System.debug(System.LoggingLevel.WARN, '___billingMetricsMap='+billingMetricsMap);
                        }
                    }
                }
            }
        }
        catch (Exception e) {
            System.debug(e.getStackTraceString());
        }
        return billingMetricsMap;
    }

    @TestVisible private ProjectSnapshot__c getBillingMetricsARMapInformation(BillingMetrics billingMetricsAR, ProjectSnapshot__c snapshot) {
        if (billingMetricsAR != null) {
            snapshot.ARTotal__c = billingMetricsAR.BilledAR;
            snapshot.ARRetention__c = billingMetricsAR.Retention;
            snapshot.ARBIEE__c = billingMetricsAR.BIEE;
            snapshot.UnbilledTotal__c = billingMetricsAR.TotalUnbilled;
        }
        return snapshot;
    }

	private Map<Id, List<Billing__c>> getBillingMetricsARMap(List<Id> projectIds)
    {
        Map<Id, List<Billing__c>> billingMetricsMap = new Map<Id, List<Billing__c>>();
        //BillingMetrics billingMetrics;
        try {
            List<Billing__c> billingList = [SELECT ProjectNumber__c, InvoiceDate__c, InvoiceAmount__c
                           FROM Billing__c WHERE ProjectNumber__c IN :projectIds 
                           AND InvoiceDate__c <= :pSnapshotDate];
            
            // For each Project add to its List of Billings
            List<Billing__c> metricsBillingList;
            for (Billing__c billing : billingList) {
                Id projId = (Id) billing.ProjectNumber__c;      
                if (billingMetricsMap.get(projId) == null) {
                	metricsBillingList = new List<Billing__c>();
                	metricsBillingList.add(billing);
                }
                else {
                	metricsBillingList = billingMetricsMap.get(projId);
                	metricsBillingList.add(billing);
                }
                billingMetricsMap.put(projId, metricsBillingList);
            }  
        }
        catch (Exception e) {
            System.debug(e.getStackTraceString());
        }
        return billingMetricsMap;
    }
    
    private void getBillingMetricsARDateRangeMap(List<Id> projectIds, Map<Id, List<Billing__c>> billingMetricsMap)
    {
        try {
    		billingMetricsAR0to30Map = new Map<Id, Decimal>();
    		billingMetricsAR31to60Map = new Map<Id, Decimal>();
			billingMetricsAR61to90Map = new Map<Id, Decimal>();
			billingMetricsAR91to180Map = new Map<Id, Decimal>();
			billingMetricsAR181PlusMap = new Map<Id, Decimal>();
			
			for (Id projId : projectIds) {
				billingMetricsAR0to30Map.put(projId, 0.0);
				billingMetricsAR31to60Map.put(projId, 0.0);
				billingMetricsAR61to90Map.put(projId, 0.0);
				billingMetricsAR91to180Map.put(projId, 0.0);
				billingMetricsAR181PlusMap.put(projId, 0.0);
			}
			
            Date startDate0to30 = pSnapshotDate.addDays(-30);
            Date endDate0to30 = pSnapshotDate;
        
            Date startDate31to60 = pSnapshotDate.addDays(-60);
            Date endDate31to60 = pSnapshotDate.addDays(-31);
        
        	Date startDate61to90 = pSnapshotDate.addDays(-90);
            Date endDate61to90 = pSnapshotDate.addDays(-61);
        
            Date startDate91to180 = pSnapshotDate.addDays(-180);
            Date endDate91to180 = pSnapshotDate.addDays(-91);
            
            Date startDate181Plus = pSnapshotDate.addDays(-181);
            
        	for (Id projId : billingMetricsMap.keyset()) {
        		List<Billing__c> billingList = (List<Billing__c>) billingMetricsMap.get(projId);
        		System.debug(System.LoggingLevel.WARN, '___billingList='+billingList);
        		for (Billing__c billing : billingList) {
        			Date invoiceDate = billing.InvoiceDate__c;
        			System.debug(System.LoggingLevel.WARN, '___invoiceDate='+invoiceDate);
        			System.debug(System.LoggingLevel.WARN, '___startDate0to30='+startDate0to30+', endDate0to30='+endDate0to30);
        			if (invoiceDate >= startDate0to30 && invoiceDate <= endDate0to30) {
        				Decimal billed = (Decimal) billingMetricsAR0to30Map.get(projId);
        				System.debug(System.LoggingLevel.WARN, '___billed='+billed);
        				billed += billing.InvoiceAmount__c;
        				System.debug(System.LoggingLevel.WARN, '___billed AFTER='+billed);
        				billingMetricsAR0to30Map.put(projId, billed);
        			}
        			else if (invoiceDate >= startDate31to60 && invoiceDate <= endDate31to60) {
        				Decimal billed = (Decimal) billingMetricsAR31to60Map.get(projId);
        				billed += billing.InvoiceAmount__c;
        				billingMetricsAR31to60Map.put(projId, billed);
        			}
        			else if (invoiceDate >= startDate61to90 && invoiceDate <= endDate61to90) {
        				Decimal billed = (Decimal) billingMetricsAR61to90Map.get(projId);
        				billed += billing.InvoiceAmount__c;
        				billingMetricsAR61to90Map.put(projId, billed);
        			}
        			else if (invoiceDate >= startDate91to180 && invoiceDate <= endDate91to180) {
        				Decimal billed = (Decimal) billingMetricsAR91to180Map.get(projId);
        				billed += billing.InvoiceAmount__c;
        				billingMetricsAR91to180Map.put(projId, billed);
        			}
        			else if (invoiceDate <= startDate181Plus) {
        				Decimal billed = (Decimal) billingMetricsAR181PlusMap.get(projId);
        				billed += billing.InvoiceAmount__c;
        				billingMetricsAR181PlusMap.put(projId, billed);
        			}
        		}
        	}
        }
        catch (Exception e) {
            System.debug(e.getStackTraceString());
        }
    }
    
    ////////// 
      //  Start Unbilled
    //////////////
    private Map<Id, Decimal> getUnbilledMetricsARDateRangeMap(List<Id> projectIds, String range)
    {
        Map<Id, Decimal> unbilledMetricsMap = new Map<Id, Decimal>();
        Date startDate;
        try {
            if (range == UNBILLED_0to30) {
                startDate = pSnapshotDate;
            }
            else if (range == UNBILLED_31to60) {
                startDate = pSnapshotDate.addDays(-31);
            }
            else if (range == UNBILLED_61to90) {
                startDate = pSnapshotDate.addDays(-61);
            }
            else if (range == UNBILLED_91to180) {
                startDate = pSnapshotDate.addDays(-91);
            }
            else if (range == UNBILLED_181Plus) {
                startDate = pSnapshotDate.addDays(-180);
            }
            System.debug(System.LoggingLevel.WARN, '___getUnbilledMetricsARDateRangeMap: range='+range+', startDate='+startDate+', projectIds='+projectIds);
            
            String query = 'SELECT ProjectNumber__c, SUM(Amount__c) totalRevenue'+
                           ' FROM Revenue__c WHERE ProjectNumber__c IN :projectIds'+
                           ' AND GLDate__c <= :startDate'+
                           ' GROUP BY ProjectNumber__c';
            List<AggregateResult> results = database.query(query); 
            for (AggregateResult ar : results) {
                Decimal unbilledValue = 0;
                Decimal totalRevenue = (Decimal)ar.get('totalRevenue');
                Id projId = (Id) ar.get('ProjectNumber__c');
                System.debug(System.LoggingLevel.WARN, '___range='+range+', totalRevenue='+totalRevenue+', projId='+projId);
                if (billingMetricsARMap != null && !billingMetricsARMap.isEmpty()) {
                    System.debug(System.LoggingLevel.WARN, '___billingMetricsARMap='+billingMetricsARMap);
                    Decimal billedARValue = 0;
                    if (billingMetricsARMap.get(projId) != null) {
                    	billedARValue = billingMetricsARMap.get(projId).BilledAR;
                    	if (billedARValue == null) {
                    		billedARValue = 0;
                    	}
                    }
                    
                    if (range == UNBILLED_181Plus) {
                        if (totalRevenue != null)
                        {
                            unbilledValue = totalRevenue - billedARValue;
                        }
                        else {
                            unbilledValue = 0 - billedARValue;
                        }
                        System.debug(System.LoggingLevel.WARN, '___UNBILLED_181Plus='+unbilledValue);
                    }
                    else if (range == UNBILLED_91to180) {
                        if (totalRevenue != null)
                        {
                            unbilledValue = totalRevenue - (billedARValue + unbilledMetricsAR181PlusMap.get(projId)); 
                        }
                        else {
                            unbilledValue = 0 - (billedARValue + unbilledMetricsAR181PlusMap.get(projId)); 
                        }
                        System.debug(System.LoggingLevel.WARN, 'UNBILLED_91to180='+unbilledValue);
                    }
                    else if (range == UNBILLED_61to90) {
                        if (totalRevenue != null)
                        {
                            unbilledValue = totalRevenue - (billedARValue + unbilledMetricsAR181PlusMap.get(projId) + 
                                unbilledMetricsAR91to180Map.get(projId));
                        }
                        else {
                            unbilledValue = 0 - (billedARValue + unbilledMetricsAR181PlusMap.get(projId) + 
                                unbilledMetricsAR91to180Map.get(projId)); 
                        }
                        System.debug(System.LoggingLevel.WARN, 'UNBILLED_61to90='+unbilledValue);
                    }
                    else if (range == UNBILLED_31to60) {
                        if (totalRevenue != null)
                        {
                            unbilledValue = totalRevenue - (billedARValue + unbilledMetricsAR181PlusMap.get(projId) + 
                                unbilledMetricsAR91to180Map.get(projId) + unbilledMetricsAR61to90Map.get(projId));
                        }
                        else {
                            unbilledValue = 0 - (billedARValue + unbilledMetricsAR181PlusMap.get(projId) + 
                                unbilledMetricsAR91to180Map.get(projId) + unbilledMetricsAR61to90Map.get(projId));
                        }
                        System.debug(System.LoggingLevel.WARN, 'UNBILLED_31to60='+unbilledValue);
                    }
                    else if (range == UNBILLED_0to30) {
                        if (totalRevenue != null)
                        {
                            unbilledValue = totalRevenue - (billedARValue + unbilledMetricsAR181PlusMap.get(projId) + 
                                unbilledMetricsAR91to180Map.get(projId) + unbilledMetricsAR61to90Map.get(projId) + unbilledMetricsAR31to60Map.get(projId));
                        }
                        else {
                            unbilledValue = 0 - (billedARValue + unbilledMetricsAR181PlusMap.get(projId) + 
                                unbilledMetricsAR91to180Map.get(projId) + unbilledMetricsAR61to90Map.get(projId) + unbilledMetricsAR31to60Map.get(projId));
                        }
                        System.debug(System.LoggingLevel.WARN, 'UNBILLED_0to30='+unbilledValue);
                    }
                    System.debug(System.LoggingLevel.WARN, '___unbilledValue='+unbilledValue);
                    unbilledMetricsMap.put(projId, unbilledValue);
                }
            }
        }
        catch (Exception e) {
            System.debug(e.getStackTraceString());
        }
        return unbilledMetricsMap;
    }
    //////// END Unbilled

    @TestVisible private ProjectSnapshot__c getOriginalBudgetHeaderMapInformation(FinancialMetrics originalBudgetFinancialMetrics, ProjectSnapshot__c snapshot) {
        if (originalBudgetFinancialMetrics != null) {
            snapshot.GrossRevenueBudgetOriginal__c = originalBudgetFinancialMetrics.TotalRevenue;
            snapshot.CostOrigBudget__c = originalBudgetFinancialMetrics.TotalCost;
        }
        return snapshot;
    }

    @TestVisible private ProjectSnapshot__c getApprovedBudgetHeaderMapInformation(FinancialMetrics approvedBudgetFinancialMetrics, ProjectSnapshot__c snapshot) {
        if (approvedBudgetFinancialMetrics != null) {
            snapshot.GrossRevenueBudget__c = approvedBudgetFinancialMetrics.TotalRevenue;
            snapshot.CostBudget__c = approvedBudgetFinancialMetrics.TotalCost;
        }
        return snapshot;
    }

    @TestVisible private Map<Id, DateTime> getLastUpdatedBudgetDateMap(List<Id> projectIds)
    {
        Map<Id, DateTime> lastUpdatedBudgetDateMap = new Map<Id, DateTime>();
        try {
	        List<BudgetHeader__c> budgets = [SELECT Project__c, LastModifiedDate FROM BudgetHeader__c 
	                                         WHERE Project__c IN :projectIds
	                                         AND Status__c = 'Approved' ORDER BY LastModifiedDate DESC];
	        
	        if (!budgets.isEmpty()) {
	            for (BudgetHeader__c bh : budgets) {
	                lastUpdatedBudgetDateMap.put(bh.Project__c, bh.LastModifiedDate);
	            }
	            System.debug(System.LoggingLevel.WARN, '___lastUpdatedBudgetDateMap='+lastUpdatedBudgetDateMap);
	        }
        }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }
        return lastUpdatedBudgetDateMap;
    }

    @TestVisible private Map<String, pse__Time_Period__c> getTimePeriodMap() {
        Map<String, pse__Time_Period__c> timePeriodMap = new Map<String, pse__Time_Period__c>();
        try {
	        List<pse__Time_Period__c> timePeriodList = 
	            [SELECT pse__Type__c, pse__Start_Date__c, pse__End_Date__c FROM pse__Time_Period__c 
	             WHERE pse__Start_Date__c <= :pSnapshotDate AND pse__End_Date__c >= :pSnapshotDate 
	             AND (pse__Type__c='Month' OR pse__Type__c='Year')];
	
	        for (pse__Time_Period__c tp : timePeriodList) {
	            timePeriodMap.put(tp.pse__Type__c, tp);
	        }
	        System.debug(System.LoggingLevel.WARN, '___pSnapshotDate='+pSnapshotDate+', timePeriodMap='+timePeriodMap);     
	    }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }
        return timePeriodMap;
    }

	// pSnapshotLatestFiscalWeekEndDate = latest Friday before pSnapshotDate (based on AECOM fiscal week)
	@TestVisible private Date getLatestFiscalWeekEndDate() {
		DateTime tmpDateTime;
		if (pSnapshotDate == null) {
			return Date.today();
		}
		else {
			tmpDateTime = pSnapshotDateTime;
			for (Integer i=1; i < 7; i++) {
				if (tmpDateTime.format('EEEE') == AECOM_FISCAL_WEEK_END_DAY) {
					return tmpDateTime.date();
				}
				else {
					tmpDateTime = pSnapshotDateTime.addDays(-1);
				}
			}	
		}
		return tmpDateTime.date();
	}
	
	// Time period
    private Map<Id, ProjectSnapshot__c> getSnapshotFiscalMonths(List<ProjectSnapshot__c> snapshots) {
        Map<Id, ProjectSnapshot__c> projectIdToSnapshotMap = new Map<Id, ProjectSnapshot__c>();
        List<Date> endDateList = new List<Date>();
        for (ProjectSnapshot__c snapshot : snapshots) {
             if (snapshot.SnapshotDate__c != null){ 
                 endDateList.add((snapshot.SnapshotDate__c.date()).addmonths(2));
                 endDateList.add((snapshot.SnapshotDate__c.date()).addmonths(-3));
             }
        }
        System.debug(System.LoggingLevel.WARN, '___endDateList='+endDateList);
        List<pse__Time_Period__c> timePeriods  = new  List<pse__Time_Period__c>();
        
        if (endDateList.size()>0) {
	        timePeriods = ECO_Utils_Date.calcTimePeriods(endDateList, 'Month'); 
	        System.debug(System.LoggingLevel.WARN, '___timePeriods='+timePeriods);
	        
	        pse__Time_Period__c fm = null;
	        for (ProjectSnapshot__c snapshot : snapshots) {
	            if (snapshot.SnapshotDate__c != null) {                                      
	                fm = ECO_Utils_Date.getFiscalPeriod(snapshot.SnapshotDate__c.date(), 0, timePeriods);
	                System.debug(System.LoggingLevel.WARN, '___fm='+fm);
	                if (fm != null){
	                    snapshot.SnapshotFiscalMonth__c = fm.TimePeriodCode__c;
	                } 
	                System.Debug(System.LoggingLevel.WARN, '___SnapshotFiscalMonth__c=' + snapshot.SnapshotFiscalMonth__c);
	                
	                fm = ECO_Utils_Date.getFiscalPeriod(snapshot.SnapshotDate__c.date(), 1, timePeriods);  
	                if (fm != null) {
	                    snapshot.SnapshotPreviousFiscalMonth__c = fm.TimePeriodCode__c;
	                }
					System.Debug(System.LoggingLevel.WARN, '___SnapshotPreviousFiscalMonth__c=' + snapshot.SnapshotPreviousFiscalMonth__c);
	                
	                projectIdToSnapshotMap.put(snapshot.Project__c, snapshot);
	            }
            }
        }
        return projectIdToSnapshotMap;
    }
	
    @TestVisible private ProjectSnapshot__c getForecastBudgetHeaderMapInformation(FinancialMetrics forecastBudgetFinancialMetrics, 
    		ProjectSnapshot__c snapshot) {
        if (forecastBudgetFinancialMetrics != null) {
            snapshot.GrossRevenueForecast__c = forecastBudgetFinancialMetrics.TotalRevenue;
            snapshot.CostForecast__c = forecastBudgetFinancialMetrics.TotalCost;
            //snapshot.ContingencyForecast__c = forecastBudgetFinancialMetrics.TotalContingency;
        }
        return snapshot;
    }        

    @TestVisible private ProjectSnapshot__c getDraftBudgetHeaderMapInformation(FinancialMetrics draftBudgetFinancialMetrics, 
    		ProjectSnapshot__c snapshot) {
        if (draftBudgetFinancialMetrics != null) {
            snapshot.GrossRevenueDraft__c = draftBudgetFinancialMetrics.TotalRevenue;
            snapshot.CostDraft__c = draftBudgetFinancialMetrics.TotalCost;
            //snapshot.ContingencyDraft__c = draftBudgetFinancialMetrics.TotalContingency;
        }
        return snapshot;
    }

    @TestVisible private ProjectSnapshot__c getUnapprovedBudgetHeaderMapInformation(FinancialMetrics unapprovedBudgetFinancialMetrics, 
    		ProjectSnapshot__c snapshot) {
        if (unapprovedBudgetFinancialMetrics != null) {
            snapshot.GrossRevenueUnapproved__c = unapprovedBudgetFinancialMetrics.TotalRevenue;
            snapshot.CostUnapproved__c = unapprovedBudgetFinancialMetrics.TotalCost;
            //snapshot.ContingencyUnapproved__c = unapprovedBudgetFinancialMetrics.TotalContingency; 
        }
        return snapshot;
    }

    @TestVisible private ProjectSnapshot__c getMtdActualFinancialMetricsMapInformation(FinancialMetrics mtdActualFinancialMetrics, 
            ProjectSnapshot__c snapshot, Date monthStartDate) {
        if (mtdActualFinancialMetrics != null) {
            snapshot.GrossRevenueMonthToDate__c = mtdActualFinancialMetrics.TotalRevenue;
            snapshot.CostMonthToDate__c = mtdActualFinancialMetrics.TotalCost;
            snapshot.ContingencyMonthToDate__c = mtdActualFinancialMetrics.TotalContingency;
            snapshot.CostsODCEXPSMonthToDate__c = mtdActualFinancialMetrics.CostsODCEXPS;
            snapshot.CostsODCSUBSMonthToDate__c = mtdActualFinancialMetrics.CostsODCSUBS;
            snapshot.LaborMonthToDate__c = mtdActualFinancialMetrics.Labor;
            snapshot.FringeMonthToDate__c = mtdActualFinancialMetrics.Fringe;
            snapshot.OverheadMonthToDate__c = mtdActualFinancialMetrics.Overhead;
            snapshot.HoursMonthToDate__c = mtdActualFinancialMetrics.Hours;
        }
        return snapshot;
    }

    @TestVisible private ProjectSnapshot__c getItdActualFinancialMetricsMapInformation(FinancialMetrics itdActualFinancialMetrics, 
            ProjectSnapshot__c snapshot) {
        if (itdActualFinancialMetrics != null) {
            snapshot.GrossRevenueITD__c = itdActualFinancialMetrics.TotalRevenue;
            snapshot.CostITD__c = itdActualFinancialMetrics.TotalCost;
            snapshot.ContingencyITD__c = itdActualFinancialMetrics.TotalContingency;
            snapshot.CostsODCEXPSITD__c = itdActualFinancialMetrics.CostsODCEXPS;
            snapshot.CostsODCSUBSITD__c = itdActualFinancialMetrics.CostsODCSUBS;
            snapshot.LaborITD__c = itdActualFinancialMetrics.Labor;
            snapshot.FringeITD__c = itdActualFinancialMetrics.Fringe;
            snapshot.OverheadITD__c = itdActualFinancialMetrics.Overhead;
            snapshot.HoursITD__c = itdActualFinancialMetrics.Hours;
        }
        return snapshot;
    }
    
    @TestVisible private ProjectSnapshot__c getTotalCostITD3MonthsAgoMapInformation(FinancialMetrics costITD3MonthsAgoFinancialMetrics, ProjectSnapshot__c snapshot) {
        if (costITD3MonthsAgoFinancialMetrics != null) {
            snapshot.CostInceptionto3MonthsAgo__c = costITD3MonthsAgoFinancialMetrics.TotalCost; 
        }
        return snapshot;
    }

    @TestVisible private ProjectSnapshot__c getYtdActualFinancialMetricsMapInformation(FinancialMetrics ytdActualFinancialMetrics, 
            ProjectSnapshot__c snapshot, Date yearStartDate) {
        if (ytdActualFinancialMetrics != null) {
            snapshot.GrossRevenueYearToDate__c = ytdActualFinancialMetrics.TotalRevenue;
            snapshot.CostYearToDate__c = ytdActualFinancialMetrics.TotalCost;
            snapshot.ContingencyYearToDate__c = ytdActualFinancialMetrics.TotalContingency;
            snapshot.CostsODCEXPSYearToDate__c = ytdActualFinancialMetrics.CostsODCEXPS;
            snapshot.CostsODCSUBSYearToDate__c = ytdActualFinancialMetrics.CostsODCSUBS;
            snapshot.LaborYearToDate__c = ytdActualFinancialMetrics.Labor;
            snapshot.FringeYearToDate__c = ytdActualFinancialMetrics.Fringe;
            snapshot.OverheadYearToDate__c = ytdActualFinancialMetrics.Overhead;
            snapshot.HoursYearToDate__c = ytdActualFinancialMetrics.Hours;
        }
        return snapshot;
    }

    public Map<Id, FinancialMetrics> getProjectActualFinancialsCostsWeeklyRollups(List<Id> projectIds, Date asOfDate)
    {
        Map<Id, FinancialMetrics> metricsMap = new Map<Id, FinancialMetrics>();
        list<AggregateResult> results = new list<AggregateResult>();
    
        try {
            String query = 
                'SELECT Project__c projectId,'+
                ' SUM(ProjectFunctionalBurdenedCost__c) funcBurdenedCost,'+ 
                ' SUM(ProjectFunctionalRawCost__c) funcRawCost,'+ 
                ' SUM(ProjectFunctionalRawCostPLODCEXPS__c) funcCostODCEXPS,'+ 
                ' SUM(ProjectFunctionalRawCostPLODCSUBS__c) funcCostODCSubs,'+ 
                ' SUM(ProjectFunctionalRawCostPLLabor__c) funcCostLabor,'+ 
                ' SUM(ProjectFunctionalRawCostPLFringe__c) funcCostFringe,'+ 
                ' SUM(ProjectFunctionalRawCostPLOverhead__c) funcCostOverhead, '+ 
                ' SUM(ProjectHours__c) projHours, '+ 
                ' SUM(ProjectFunctionalRawCostResourceLabor__c) funcCostResourceLabor, '+ 
                ' SUM(ProjectFunctionalRawCostResourceNonLabor__c) funcCostResourceNonLabor '+ 
                ' FROM WeeklyRollupEntry__c'+
                ' WHERE Project__c IN :projectIds';
                
            if (asOfDate != null) {
                query += ' AND PeriodStartDate__c >= :asOfDate';
                if (pSnapshotDate != Date.today()) {
                    query += ' AND PeriodStartDate__c <= :pSnapshotLatestFiscalWeekEndDate';
                }
            }
            query += ' GROUP BY Project__c'+
                     ' ORDER BY Project__c';
            System.debug(System.LoggingLevel.WARN, '___getProjectActualFinancialsCostsWeeklyRollups query= '+query);
            results = database.query(query);
            System.debug(System.LoggingLevel.WARN, '___getProjectActualFinancialsCostsWeeklyRollups results= '+results.size());
            
            Id projectId;
            Id currentProjectId;
            FinancialMetrics metrics;
            for (AggregateResult ar : results)
            {
                projectId = (Id) ar.get('projectId');
                if (currentProjectId == null) {
                    currentProjectId = projectId;
                    metrics = new FinancialMetrics();
                }
                else if (projectId != currentProjectId) {
                    metrics = new FinancialMetrics(); // reset
                    currentProjectId = projectId;
                }
                
                Decimal funcBurdenedCost = (Decimal)ar.get('funcBurdenedCost');
                
                if (funcBurdenedCost != null) {
                        metrics.CostsODCEXPS = (Decimal)ar.get('funcCostODCEXPS');
                        metrics.CostsODCSUBS = (Decimal)ar.get('funcCostODCSubs');
                        metrics.TotalContingency = funcBurdenedCost;
                        metrics.Labor = (Decimal)ar.get('funcCostLabor');
                        metrics.Fringe = (Decimal)ar.get('funcCostFringe');
                        metrics.Overhead = (Decimal)ar.get('funcCostOverhead');
                        metrics.Hours = (Decimal)ar.get('projHours');
                        metrics.TotalLabor = (Decimal)ar.get('funcCostResourceLabor');
                        metrics.TotalNonLabor = (Decimal)ar.get('funcCostResourceNonLabor');
                }
                metricsMap.put(currentProjectId, metrics);
            }
            System.debug(System.LoggingLevel.WARN, '___ProjectActualFinancialsCostsMap='+metricsMap);
        }
        catch (Exception e) {
            System.debug(e.getStackTraceString());
        }
        return metricsMap;
    }

    // Run this after WeeklyRollupEntry__c query
	public Map<Id, FinancialMetrics> getProjectActualFinancialsCostsPartialWeek(List<Id> projectIds, Map<Id, FinancialMetrics> metricsMap)
    {          
    	try {
	        if (pSnapshotDate != Date.today()) {
	        	String query = 
	                'SELECT ExpenditureItem__r.ProjectTask__r.pse__Project__c,'+
	                ' ProjectFunctionalBurdenedCost__c,'+ 
	                ' ProjectFunctionalRawCost__c,'+
	                ' ExpenditureItem__r.Quantity__c,'+
	                ' ExpenditureItem__r.PLReportCategory__c,'+
	                ' ExpenditureItem__r.ExpenditureResourceType__c,'+
	                ' ExpenditureItem__r.ExpenditureItemDate__c'+
	                ' FROM CostDistLine__c'+
	                ' WHERE ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id IN :projectIds'+
	                ' AND ExpenditureItem__r.ExpenditureItemDate__c > :pSnapshotLatestFiscalWeekEndDate'+
	                ' AND ExpenditureItem__r.ExpenditureItemDate__c <= :pSnapshotDate'+
	                ' ORDER BY ExpenditureItem__r.ProjectTask__r.pse__Project__c';    
			
				List<CostDistLine__c> cdlList = database.query(query);
				
				for (Id projectId : projectIds) {
					FinancialMetrics metrics = metricsMap.get(projectId);
					for (CostDistLine__c cdl : cdlList) {		
						if (cdl.ExpenditureItem__r.PLReportCategory__c == ODC_Exps) {
	                        metrics.CostsODCEXPS += cdl.ProjectFunctionalBurdenedCost__c;
	                    }
	                    else if (cdl.ExpenditureItem__r.PLReportCategory__c == ODC_Subs) {
	                        metrics.CostsODCSUBS = cdl.ProjectFunctionalBurdenedCost__c;
	                    }
	                    else if (cdl.ExpenditureItem__r.PLReportCategory__c == ODC_Contingency) {
	                        metrics.TotalContingency += cdl.ProjectFunctionalBurdenedCost__c;
	                    }
	                    else if (cdl.ExpenditureItem__r.PLReportCategory__c == 'Labor') {
	                        metrics.Labor += cdl.ProjectFunctionalBurdenedCost__c;
	                    }
	                    else if (cdl.ExpenditureItem__r.PLReportCategory__c == 'Fringe') {
	                        metrics.Fringe += cdl.ProjectFunctionalBurdenedCost__c;
	                    }
	                    else if (cdl.ExpenditureItem__r.PLReportCategory__c == 'Overhead') {
	                        metrics.Overhead += cdl.ProjectFunctionalBurdenedCost__c;
	                    }
	                    else if (cdl.ExpenditureItem__r.PLReportCategory__c == 'Hours') {
	                        metrics.Hours += cdl.ExpenditureItem__r.Quantity__c;
	                    }
	                    else if (cdl.ExpenditureItem__r.ExpenditureResourceType__c == 'LAB') {
	                        metrics.TotalLabor += cdl.ProjectFunctionalBurdenedCost__c;
	                    }
	                    else if (cdl.ExpenditureItem__r.ExpenditureResourceType__c != 'LAB') {
	                        metrics.TotalNonLabor += cdl.ProjectFunctionalBurdenedCost__c;
	                    }
					}
					metricsMap.put(projectId, metrics);
				}
	        }
	    }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }		
        return metricsMap;	
    }

	public Map<Id, FinancialMetrics> getProjectActualFinancialsCosts(List<Id> projectIds, Date asOfDate)
    {
    	Map<Id, FinancialMetrics> metricsMap = getProjectActualFinancialsCostsWeeklyRollups(projectIds, asOfDate);
    	getProjectActualFinancialsCostsPartialWeek(projectIds, metricsMap);
    	return metricsMap;
    }

    private String getRelatedProjectTasks(List<Id> projectIds)
    {
        String returnString = '';
        try {
	        List<pse__Project_Task__c> projectTasks = [SELECT Id, Name, ForecastEndDate__c, ForecastStartDate__c,
	            pse__End_Date__c, pse__Start_Date__c, ProjectTaskNumber__c FROM pse__Project_Task__c
	            WHERE pse__Project__c IN :projectIds];
	        System.debug(System.LoggingLevel.WARN, '___getRelatedProjectTasks rows='+projectTasks.size());

            String forecastStart = '';
            String forecastEnd = '';
            String actualStart = '';
            String actualEnd = '';

	        for (pse__Project_Task__c projectTask:projectTasks)
	        {
                if(projectTask.ForecastStartDate__c != null)
                    forecastStart = projectTask.ForecastStartDate__c.format();

                if(projectTask.ForecastEndDate__c != null)
                    forecastEnd = projectTask.ForecastEndDate__c.format();

                if(projectTask.pse__Start_Date__c != null)
                    actualStart = projectTask.pse__Start_Date__c.format();

                if(projectTask.pse__End_Date__c != null)
                    actualEnd = projectTask.pse__End_Date__c.format();
                        
	            if (returnString == '') {
	                returnString = projectTask.Name + ';;' + projectTask.ProjectTaskNumber__c + ';;' +
	                	forecastStart  + ';;' + forecastEnd  + ';;' +
	                	actualStart + ';;' + actualEnd;
	            }
	            else {
	            	returnString += '::' + projectTask.Name + ';;' + projectTask.ProjectTaskNumber__c + ';;' +
	            		forecastStart + ';;' + forecastEnd  + ';;' + actualStart + ';;' + actualEnd;
	            }  
                forecastStart = '';
                forecastEnd = '';
                actualStart = '';
                actualEnd = '';      
	        }
	        System.debug(System.LoggingLevel.WARN, '___getRelatedProjectTasks returnString='+returnString);
	    }
        catch(Exception e) {
            System.Debug('EXCEPTION: '+e.getStackTraceString());
        }
        return returnString;
    }
    
    private DateTime getLastUpdatedBudgetDate(List<Id> projectIds)
    {
        List<BudgetHeader__c> budgets = [SELECT Id, LastModifiedDate FROM BudgetHeader__c WHERE Project__c IN :projectIds
                                                AND Status__c = 'Approved' order by LastModifiedDate desc];
        
        if (! budgets.isEmpty())
            return budgets[0].LastModifiedDate;
        return null;
    }
    
    private Decimal returnMapDecimalValue(Decimal value)
    {
        if (value == null)
            return 0;
        return value;
    }
    
    private Decimal getTotalFutureSpendForPeriod(List<Decimal> projectMonthTotals)
    {
        Decimal retVal = 0;
        for (Decimal total:projectMonthTotals)
        {
            retVal += total;    
        }
        return retVal;
    }
    
    public Map<Id, Decimal> getFutureSpendForPeriodMap(List<Id> projectIds, Date startDate, Date endDate)
    {
    	Map<Id, Decimal> projectsFutureSpendMap = new Map<Id, Decimal>();
    	try {      
	        String query = 'SELECT SUM(ApprovedCost__c) ApprovedCost, Project__c'+
	                       ' FROM WeeklyRollupEntry__c'+
	                       ' WHERE Project__c IN :projectIds AND PeriodStartDate__c > :startDate'+
	                       ' AND PeriodStartDate__c <= :endDate'+
	                       ' GROUP BY Project__c';
	        List<AggregateResult> results = database.query(query); 
            for (AggregateResult ar : results) {
	            if (ar.get('ApprovedCost') != null)
	            {
	                projectsFutureSpendMap.put((Id)ar.get('Project__c'), (Decimal)ar.get('ApprovedCost'));
	            }
	        }  
	    }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        } 
        return projectsFutureSpendMap;
    }
    
    private void populateOrganizationsMaps(List<Id> projectIds)
    {   
    	try {
	        for (ProjectOrganization__c org:[SELECT Id, Type__c, ContributionPercent__c, OrganizationString__r.District__c, OrganizationString__r.Id, OrganizationString__r.Region__c, 
	                                            OrganizationString__r.Name, OrganizationString__r.BusinessLineName__c, Project__c
	                                            FROM ProjectOrganization__c WHERE Project__c = :projectIds] )
	        {
	            organizationProjectPercentage.put(org.OrganizationString__r.Id + '-' + org.Project__c, org.ContributionPercent__c);
	            if (organizationProjectsMap.get(org.OrganizationString__r.Id) == null)
	                organizationProjectsMap.put(org.OrganizationString__r.Id, new List<Id>());
	            organizationProjectsMap.get(org.OrganizationString__r.Id).add(org.Project__c);
	            organizationNameMap.put(org.OrganizationString__r.Id, org.OrganizationString__r.Region__c + '-' + org.OrganizationString__r.District__c + '-' + org.OrganizationString__r.BusinessLineName__c + '-' + org.OrganizationString__r.Name);
	            if (org.Type__c == 'Primary')
	                primaryOrganizationId = org.OrganizationString__r.Id;   
	        }
	  	}
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }
    }
        
    private String getRelatedAgreements(List<Id> projectIds)
    {   
        String agreements = '';
        try {
	        for (Agreement__c agreement:[SELECT Id, Name, AgreementType__c, RecordType.Name, Amount__c FROM Agreement__c
	                                                                WHERE Id IN (SELECT Agreement__c FROM ProjectAgreement__c
	                                                                            WHERE Project__c IN :projectIds)])
	        {
	            if (agreements == '')
	                agreements = agreement.RecordType.Name + ';;' + agreement.AgreementType__c + ';;' + agreement.Amount__c;
	            else
	                agreements += '::' + agreement.RecordType.Name + ';;' + agreement.AgreementType__c + ';;' + agreement.Amount__c;
	        }
	        System.debug(System.LoggingLevel.WARN, '___getRelatedAgreements Query rows ='+Limits.getQueryRows());
        }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }
        return agreements;
    }

    private String getPendingChangeOrders(List<Id> projectIds, Id recordTypeId)
    {
        String changeOrders = '';
        try {
	        for (BudgetHeader__c header:[SELECT Id, Name, BudgetName__c, TotalRevenue__c, TotalCost__c 
	                                        FROM BudgetHeader__c 
	                                        WHERE Project__c IN :projectIds
	                                        AND ((Status__c = 'Approved' AND ChangeManagerApprovedForSynch__c = true)
	                                            OR (Status__c != 'Approved'))
	                                        AND Id IN (SELECT BudgetHeader__c FROM ChangeManager__c WHERE Project__c IN :projectIds)])
	        {
	            if (changeOrders == '')
	                changeOrders =  header.BudgetName__c  + ';;' + header.TotalRevenue__c + ';;' + header.TotalCost__c;
	            else
	                changeOrders += '::' + header.BudgetName__c  + ';;' + header.TotalRevenue__c + ';;' + header.TotalCost__c;
	        }
	    }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }
        return changeOrders;            
    }
    
    private String getDraftChangedOrders(List<Id> projectIds, Id recordTypeId)
    {   
        String changeOrders = ''; 
        try {  
	        for (BudgetHeader__c header:[SELECT Id, Name, BudgetName__c, TotalRevenue__c, TotalCost__c 
	                FROM BudgetHeader__c WHERE Project__c IN :projectIds 
	                                        AND Id Not IN (SELECT BudgetHeader__c FROM ChangeManager__c 
	                                        WHERE Project__c IN :projectIds)])
	        {
	            if (changeOrders == '')
	                changeOrders =  header.BudgetName__c  + ';;' + header.TotalRevenue__c + ';;' + header.TotalCost__c;
	            else
	                changeOrders += '::' + header.BudgetName__c  + ';;' + header.TotalRevenue__c + ';;' + header.TotalCost__c;
	        }
	    }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }
        return changeOrders;
    }

    @TestVisible private Map<Id, FinancialMetrics> getOriginalBudgetHeaderMap(List<Id> projectIds, boolean showUnsynchedBudgets)
    {
        Map<Id, FinancialMetrics> metricsMap = new Map<Id, FinancialMetrics>();
        String query = 'SELECT Project__c, SUM(TotalRevenue__c) totalRevenue,'+
            ' SUM(TotalCost__c) totalCost,'+ 
            ' SUM(TotalNonLabor__c) totalNonLabor,'+ 
            ' SUM(TotalLaborAmount__c) totalLabor,'+
            ' SUM(TotalContingencyAmount__c) totalContingency'+
            ' FROM BudgetHeader__c'+
            ' WHERE OriginalBudget__c = true'+
            ' AND Project__c IN :projectIds'+
            ' GROUP BY Project__c';
        
        System.debug(System.LoggingLevel.WARN, '___query='+query);
        try {
            List<AggregateResult> results = database.query(query); 
            for (AggregateResult ar : results) {
                FinancialMetrics metrics = new FinancialMetrics();
                metrics.TotalRevenue = returnMapDecimalValue((Decimal)ar.get('totalRevenue'));
                metrics.TotalCost = returnMapDecimalValue((Decimal)ar.get('totalCost'));
                metrics.TotalNonLabor = returnMapDecimalValue((Decimal)ar.get('totalNonLabor'));
                metrics.TotalLabor = returnMapDecimalValue((Decimal)ar.get('totalLabor'));  
                metrics.TotalContingency = returnMapDecimalValue((Decimal)ar.get('totalContingency'));  
                
                metricsMap.put((Id)ar.get('Project__c'), metrics);
            }
        }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }   
        return metricsMap;
    }

    @TestVisible private Map<Id, FinancialMetrics> getApprovedBudgetHeaderMap(List<Id> projectIds, boolean showUnsynchedBudgets)
    {
        Map<Id, FinancialMetrics> metricsMap = new Map<Id, FinancialMetrics>();
        String query = 'SELECT Project__c, SUM(TotalRevenue__c) totalRevenue,'+
            ' SUM(TotalCost__c) totalCost,'+
            ' SUM(TotalNonLabor__c) totalNonLabor,'+
            ' SUM(TotalLaborAmount__c) totalLabor,'+
            ' SUM(TotalContingencyAmount__c) totalContingency'+
            ' FROM BudgetHeader__c'+
            ' WHERE Project__c IN :projectIds'+
            ' AND Status__c = \'Approved\''+
            ' AND ChangeManagerApprovedForSynch__c = false'+
            ' GROUP BY Project__c';
        
        try {
            List<AggregateResult> results = database.query(query); 
            for (AggregateResult ar : results) {
                FinancialMetrics metrics = new FinancialMetrics();
                metrics.TotalRevenue = returnMapDecimalValue((Decimal)ar.get('totalRevenue'));
                metrics.TotalCost = returnMapDecimalValue((Decimal)ar.get('totalCost'));
                metrics.TotalNonLabor = returnMapDecimalValue((Decimal)ar.get('totalNonLabor'));
                metrics.TotalLabor = returnMapDecimalValue((Decimal)ar.get('totalLabor'));  
                metrics.TotalContingency = returnMapDecimalValue((Decimal)ar.get('totalContingency'));  
               
                metricsMap.put((Id)ar.get('Project__c'), metrics);
            }
        }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }   
        return metricsMap;
    }

    @TestVisible private Map<Id, FinancialMetrics> getForecastBudgetHeaderMap(List<Id> projectIds)
    {
        Map<Id, FinancialMetrics> metricsMap = new Map<Id, FinancialMetrics>();
        try {
            String query = 'SELECT Project__c, '+
            	' SUM(TotalRevenue__c) totalRevenue, SUM(TotalCost__c) totalCost,'+
                ' SUM(TotalNonLabor__c) totalNonLabor, SUM(TotalLaborAmount__c) totalLabor,'+
                ' SUM(TotalContingencyAmount__c) totalContingency'+
                ' FROM BudgetHeader__c'+
                ' WHERE Project__c IN :projectIds'+
                ' AND Status__c = \'Forecast\' '+
                ' AND BudgetAsOfDate__c <= :pSnapshotDate' +
                ' GROUP BY Project__c';
            
            List<AggregateResult> results = database.query(query);
            System.debug(System.logginglevel.WARN, '___getForecastBudgetHeaderMap query='+query);
                
            for (AggregateResult ar : results) {
                FinancialMetrics metrics = new FinancialMetrics();
                metrics.TotalRevenue = returnMapDecimalValue((Decimal)ar.get('totalRevenue'));
                metrics.TotalCost = returnMapDecimalValue((Decimal)ar.get('totalCost'));
                metrics.TotalNonLabor = returnMapDecimalValue((Decimal)ar.get('totalNonLabor'));
                metrics.TotalLabor = returnMapDecimalValue((Decimal)ar.get('totalLabor'));  
                metrics.TotalContingency = returnMapDecimalValue((Decimal)ar.get('totalContingency'));  
                
                metricsMap.put((Id)ar.get('Project__c'), metrics);
                System.debug(System.logginglevel.WARN, '___getForecastBudgetHeaderMap metrics='+metrics);
            }
        }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }   
        return metricsMap;
    }

    @TestVisible private Map<Id, FinancialMetrics> getDraftBudgetHeaderMap(List<Id> projectIds)
    {
        Map<Id, FinancialMetrics> metricsMap = new Map<Id, FinancialMetrics>();
        try {
            String query = 'SELECT Project__c, SUM(TotalRevenue__c) totalRevenue, SUM(TotalCost__c) totalCost,'+
                ' SUM(TotalNonLabor__c) totalNonLabor,'+
                ' SUM(TotalLaborAmount__c) totalLabor,'+
                ' SUM(TotalContingencyAmount__c) totalContingency'+
                ' FROM BudgetHeader__c'+
                ' WHERE Project__c IN :projectIds'+
                ' AND Status__c = \'Estimate\' '+
                ' GROUP BY Project__c';
            List<AggregateResult> results = database.query(query);
            for (AggregateResult ar : results) {
                FinancialMetrics metrics = new FinancialMetrics();
                metrics.TotalRevenue = returnMapDecimalValue((Decimal)ar.get('totalRevenue'));
                metrics.TotalCost = returnMapDecimalValue((Decimal)ar.get('totalCost'));
                metrics.TotalNonLabor = returnMapDecimalValue((Decimal)ar.get('totalNonLabor'));
                metrics.TotalLabor = returnMapDecimalValue((Decimal)ar.get('totalLabor'));  
                metrics.TotalContingency = returnMapDecimalValue((Decimal)ar.get('totalContingency'));  
                
                metricsMap.put((Id)ar.get('Project__c'), metrics);
                System.debug(System.logginglevel.WARN, '___getDraftBudgetHeaderMap metrics='+metrics);
            }
        }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }   
        return metricsMap;
    }

    @TestVisible private Map<Id, FinancialMetrics> getUnapprovedBudgetHeaderMap(List<Id> projectIds, boolean showUnsynchedBudgets)
    {
        Map<Id, FinancialMetrics> metricsMap = new Map<Id, FinancialMetrics>();
        String approvalStatus = 'Approved';
        String query = 'SELECT Project__c, SUM(TotalRevenue__c) totalRevenue,'+
            ' SUM(TotalCost__c) totalCost,'+
            ' SUM(TotalNonLabor__c) totalNonLabor,'+
            ' SUM(TotalLaborAmount__c) totalLabor,'+
            ' SUM(TotalContingencyAmount__c) totalContingency'+
            ' FROM BudgetHeader__c'+
            ' WHERE Project__c IN :projectIds'+
            ' AND Status__c != \''+ approvalStatus + '\''+
            ' AND Id IN (SELECT BudgetHeader__c FROM ChangeManager__c WHERE ApprovalStatus__c != \''+ approvalStatus + '\''+
            ' AND Project__c IN :projectIds)'+
            ' GROUP BY Project__c';     
            
        System.debug(System.LoggingLevel.WARN, '___query='+query);
        try {
            List<AggregateResult> results = database.query(query); 
            
            for (AggregateResult ar : results) {
                FinancialMetrics metrics = new FinancialMetrics();
                metrics.TotalRevenue = returnMapDecimalValue((Decimal)ar.get('totalRevenue'));
                metrics.TotalCost = returnMapDecimalValue((Decimal)ar.get('totalCost'));
                metrics.TotalNonLabor = returnMapDecimalValue((Decimal)ar.get('totalNonLabor'));
                metrics.TotalLabor = returnMapDecimalValue((Decimal)ar.get('totalLabor'));  
                metrics.TotalContingency = returnMapDecimalValue((Decimal)ar.get('totalContingency'));  
                
                metricsMap.put((Id)ar.get('Project__c'), metrics);
            }
        }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }   
        return metricsMap;
    }   
    

    @TestVisible private Map<Id, FinancialMetrics> getProjectActualFinancialsTotalRevenueMap(List<Id> projectIds, Date asOfDate)
    {
        Map<Id, FinancialMetrics> metricsMap = new Map<Id, FinancialMetrics>();
        FinancialMetrics metrics = new FinancialMetrics();
        try {
            String query = 'SELECT ProjectNumber__c, SUM(Amount__c) totalRevenue FROM Revenue__c'+
                ' WHERE ProjectNumber__c IN :projectIds ';
            if (asOfDate != null) {
                query += ' AND GLDate__c >= :asOfDate';
            }
            query += ' AND GLDate__c <= :pSnapshotDate' +
            		 ' GROUP BY ProjectNumber__c';
            
            System.debug(System.LoggingLevel.WARN, '___SOQL queries='+System.Limits.getQueries());
            List<AggregateResult> results = database.query(query); 
            for (AggregateResult ar: results)
            {
                Decimal totalRevenueValue = (Decimal)ar.get('totalRevenue');
                if (totalRevenueValue != null) {
                    metrics.TotalRevenue = totalRevenueValue;
                    metricsMap.put((Id)ar.get('ProjectNumber__c'), metrics);
                }
            }
        }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }
        return metricsMap; 
    }
    
    @TestVisible private Map<Id, FinancialMetrics> getTotalCostITD3MonthsAgoMap(List<Id> projectIds)
    {
        Date asOfDate = pSnapshotDate.addDays(-90);
        Map<Id, FinancialMetrics> metricsMap = new Map<Id, FinancialMetrics>();
        FinancialMetrics metrics = new FinancialMetrics();
        try {
            String query = 'SELECT Project__c projectId,'+
            	' SUM(ProjectFunctionalRawCost__c) funcRawCost'+ 
                ' FROM WeeklyRollupEntry__c'+
                ' WHERE Project__c IN :projectIds'+
	           	' AND PeriodStartDate__c <= :asOfDate'+
	           	' GROUP BY Project__c'+
	            ' ORDER BY Project__c';
            
            List<AggregateResult> results = database.query(query);
            for (AggregateResult ar: results)
            {
                Decimal totalCostValue = (Decimal)ar.get('funcRawCost');
                if (totalCostValue != null) {
                    metrics.TotalCost = totalCostValue;
                    metricsMap.put((Id)ar.get('projectId'), metrics);
                }
            }
        }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }
        return metricsMap; 
    }

    @TestVisible private Map<Id, FinancialMetrics> getProjectActualFinancialsMap(List<Id> projectIds, Date asOfDate)
    {
        Map<Id, FinancialMetrics> metricsMap = new Map<Id, FinancialMetrics>();
        FinancialMetrics metrics;
        
        try {
            Map<Id, FinancialMetrics> totalRevenueMap = getProjectActualFinancialsTotalRevenueMap(projectIds, asOfDate);
            System.debug(System.LoggingLevel.WARN, '___Query rows ='+Limits.getQueryRows());
             
            Map<Id, FinancialMetrics> financialCostsMap = getProjectActualFinancialsCosts(projectIds, asOfDate);
            System.debug(System.LoggingLevel.WARN, '___Query rows ='+Limits.getQueryRows());
            
            for (Id projId : projectIds) {
                metrics = new FinancialMetrics();
                FinancialMetrics totalRevenueMetrics = totalRevenueMap.get(projId);
                FinancialMetrics totalCostMetrics = financialCostsMap.get(projId);
                
                FinancialMetrics totalLaborMetrics = financialCostsMap.get(projId);
                FinancialMetrics totalNonLaborMetrics = financialCostsMap.get(projId);
                
                FinancialMetrics funcBurdenedCostsMetrics = financialCostsMap.get(projId);
                FinancialMetrics funcBurdenedCostsLaborMetrics = financialCostsMap.get(projId);
                FinancialMetrics funcBurdenedCostsHoursMetrics = financialCostsMap.get(projId);

                if (totalRevenueMetrics != null) {
                    metrics.totalRevenue = totalRevenueMetrics.totalRevenue;
                }
                
                if (funcBurdenedCostsMetrics != null) {
                    metrics.CostsODCEXPS = funcBurdenedCostsMetrics.CostsODCEXPS;
                    metrics.CostsODCSUBS = funcBurdenedCostsMetrics.CostsODCSUBS;
                    metrics.TotalContingency = funcBurdenedCostsMetrics.TotalContingency;
                    metrics.Fringe = funcBurdenedCostsMetrics.Fringe;
                    metrics.Overhead = funcBurdenedCostsMetrics.Overhead;
                }
                
                if (funcBurdenedCostsLaborMetrics != null) {
                    metrics.Labor = funcBurdenedCostsLaborMetrics.Labor;
                }
                
                if (funcBurdenedCostsHoursMetrics != null) {
                    metrics.Hours = funcBurdenedCostsHoursMetrics.Hours;
                }
                metricsMap.put(projId, metrics);
            }
        }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }
        return metricsMap; 
    }

    @TestVisible private static Set<String> getPLReportCategories() {
    	try {
	        if (plReportCategorySet.isEmpty()) {
	            List<AggregateResult> arList = [SELECT PLReportCategory__c FROM ExpenditureType__c 
	                 WHERE PLReportCategory__c != Null GROUP BY PLReportCategory__c]; // Distinct values
	            for (AggregateResult ar : arList) {
	                plReportCategorySet.add((String) ar.get('PLReportCategory__c'));
	            }
	            System.debug(System.LoggingLevel.WARN, '___plReportCategorySet='+plReportCategorySet);
	        }
	    }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }
        return plReportCategorySet;
    }

    /*  a) If BudgetAssignment.OverrideTotalCost > 0, use BudgetAssignment.OverrideTotalCost, else use 
              BudgetAssignment.TotalComputedCost
        b) Filter by category: BudgetAssignment__r.BudgetResource.PLReportCategory = (whatever category is)
        c) Filter by status: BudgetAssignment__r.BudgetResource__r.Budgetheader.Status = 'Forecast'
    */
    @TestVisible private Map<Id, ProjectSnapshot__c> getOriginalOrForecastBudgetCostsMap(List<Id> projectIds,
            Map<Id, ProjectSnapshot__c> projectIdToSnapshotMap) {
        plReportCategorySet = getPLReportCategories();      
        try {
            List<BudgetAssignment__c> budgetAssignments = 
                [SELECT OverrideTotalCost__c, TotalComputedCost__c, BudgetResource__r.PLReportCategory__c,
                    BudgetResource__r.BudgetHeader__r.Project__c, BudgetResource__r.BudgetHeader__r.Status__c,
                    BudgetResource__r.BudgetHeader__r.OriginalBudget__c
                 FROM BudgetAssignment__c 
                 WHERE BudgetResource__r.PLReportCategory__c IN :plReportCategorySet
                 AND BudgetResource__r.BudgetHeader__r.Project__c IN : projectIds];

            for (BudgetAssignment__c ba : budgetAssignments) {
                String PLReportCategory = ba.BudgetResource__r.PLReportCategory__c;
                Id projId = ba.BudgetResource__r.BudgetHeader__r.Project__c;
                ProjectSnapshot__c snapshot = projectIdToSnapshotMap.get(projId);
                BudgetHeader__c bHeader = ba.BudgetResource__r.BudgetHeader__r;
                if (bHeader != null) {
                    String bStatus = bHeader.status__c;
                    
                    Boolean origBudget = bHeader.OriginalBudget__c;
                    if (origBudget) { // Original Budget
                    	if (PLReportCategory == ODC_Exps) {
                            snapshot.CostsODCEXPSBudgetOriginal__c += ba.TotalComputedCost__c;  
                        }
                        else if (PLReportCategory == ODC_Subs) {
                            snapshot.CostsODCSUBSBudgetOriginal__c += ba.TotalComputedCost__c;
                        }
                        else if (PLReportCategory == ODC_Contingency) {
                            snapshot.ContingencyBudgetOriginal__c += ba.TotalComputedCost__c;
                        }
                        else if (PLReportCategory == 'Labor') {
                            snapshot.LaborBudgetOriginal__c += ba.TotalComputedCost__c;
                        }
                        else if (PLReportCategory == 'Fringe') {
                            snapshot.FringeBudgetOriginal__c += ba.TotalComputedCost__c;
                        }
                        else if (PLReportCategory == 'Overhead') {
                            snapshot.OverheadBudgetOriginal__c += ba.TotalComputedCost__c;
                        }
                    }
                    
                    if (bStatus == 'Approved') {
                        if (PLReportCategory == ODC_Exps) {
                            snapshot.CostsODCEXPSBudget__c += ba.TotalComputedCost__c;
                        }
                        else if (PLReportCategory == ODC_Subs) {
                            snapshot.CostsODCSUBSBudget__c += ba.TotalComputedCost__c;
                        }
                        else if (PLReportCategory == ODC_Contingency) {
                            snapshot.ContingencyBudget__c += ba.TotalComputedCost__c;
                        }
                        else if (PLReportCategory == 'Labor') {
                            snapshot.LaborBudget__c += ba.TotalComputedCost__c;
                        }
                        else if (PLReportCategory == 'Fringe') {
                            snapshot.FringeBudget__c += ba.TotalComputedCost__c;
                        }
                        else if (PLReportCategory == 'Overhead') {
                            snapshot.OverheadBudget__c += ba.TotalComputedCost__c;
                        }
                    }
                    else { // Unapproved
                    	if (PLReportCategory == ODC_Exps) {
                            snapshot.CostsODCEXPSUnapproved__c += ba.TotalComputedCost__c;
                        }
                        else if (PLReportCategory == ODC_Subs) {
                            snapshot.CostsODCSUBSUnapproved__c += ba.TotalComputedCost__c;
                        }
                        else if (PLReportCategory == ODC_Contingency) {
                            snapshot.ContingencyUnapproved__c += ba.TotalComputedCost__c;
                        }
                        else if (PLReportCategory == 'Labor') {
                            snapshot.LaborUnapproved__c += ba.TotalComputedCost__c;
                        }
                        else if (PLReportCategory == 'Fringe') {
                            snapshot.FringeUnapproved__c += ba.TotalComputedCost__c;
                        }
                        else if (PLReportCategory == 'Overhead') {
                            snapshot.OverheadUnapproved__c += ba.TotalComputedCost__c;
                        }
                        
                        if (bStatus == 'Forecast') {
	                        if (ba.OverrideTotalCost__c > 0) {
	                            if (PLReportCategory == ODC_Exps) {
	                                snapshot.CostsODCEXPSForecast__c += ba.OverrideTotalCost__c;
	                            }
	                            else if (PLReportCategory == ODC_Subs) {
	                                snapshot.CostsODCSUBSForecast__c += ba.OverrideTotalCost__c;
	                            }
	                            else if (PLReportCategory == ODC_Contingency) {
	                                snapshot.ContingencyForecast__c += ba.OverrideTotalCost__c;
	                            }
	                            else if (PLReportCategory == 'Labor') {
	                                snapshot.LaborForecast__c += ba.OverrideTotalCost__c;
	                            }
	                            else if (PLReportCategory == 'Fringe') {
	                                snapshot.FringeForecast__c += ba.OverrideTotalCost__c;
	                            }
	                            else if (PLReportCategory == 'Overhead') {
	                                snapshot.OverheadForecast__c += ba.OverrideTotalCost__c;
	                            }
	                        }
	                        else {
	                            if (PLReportCategory == ODC_Exps) {
	                                snapshot.CostsODCEXPSForecast__c += ba.TotalComputedCost__c;
	                            }
	                            else if (PLReportCategory == ODC_Subs) {
	                                snapshot.CostsODCSUBSForecast__c += ba.TotalComputedCost__c;
	                            }
	                            else if (PLReportCategory == ODC_Contingency) {
	                                snapshot.ContingencyForecast__c += ba.TotalComputedCost__c;
	                            }
	                            else if (PLReportCategory == 'Labor') {
	                                snapshot.LaborForecast__c += ba.TotalComputedCost__c;
	                            }
	                            else if (PLReportCategory == 'Fringe') {
	                                snapshot.FringeForecast__c += ba.TotalComputedCost__c;
	                            }
	                            else if (PLReportCategory == 'Overhead') {
	                                snapshot.OverheadForecast__c += ba.TotalComputedCost__c;
	                            }
	                        }
	                    }
	                    else if (bStatus == 'Estimate') { // Draft
	                        if (PLReportCategory == ODC_Exps) {
	                            snapshot.CostsODCEXPSDraft__c += ba.TotalComputedCost__c;
	                        }
	                        else if (PLReportCategory == ODC_Subs) {
	                            snapshot.CostsODCSUBSDraft__c += ba.TotalComputedCost__c;
	                        }
	                        else if (PLReportCategory == ODC_Contingency) {
	                            snapshot.ContingencyDraft__c += ba.TotalComputedCost__c;
	                        }
	                        else if (PLReportCategory == 'Labor') {
	                            snapshot.LaborDraft__c += ba.TotalComputedCost__c;
	                        }
	                        else if (PLReportCategory == 'Fringe') {
	                            snapshot.FringeDraft__c += ba.TotalComputedCost__c;
	                        }
	                        else if (PLReportCategory == 'Overhead') {
	                            snapshot.OverheadDraft__c += ba.TotalComputedCost__c;
	                        }
	                    }
                    } 
                }
                System.debug(System.LoggingLevel.WARN, '___projectIdToSnapshotMap: snapshot='+snapshot);
                projectIdToSnapshotMap.put(projId, snapshot);
            }
        }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }
        return projectIdToSnapshotMap;
    }

    /* Total number of hours in current forecast budget (by Budget Assignment: ExpenditureResourceType=Lab; 
       use Quantity; filter where Budget Header: Status  = Forecast)
    */
    @TestVisible private Map<Id, ProjectSnapshot__c> getOriginalOrForecastBudgetHoursMap(List<Id> projectIds,
            Map<Id, ProjectSnapshot__c> projectIdToSnapshotMap) {
        try {
            List<AggregateResult> results = 
                [SELECT SUM(Quantity__c) Hours,
                 BudgetResource__r.BudgetHeader__r.Project__c projectId, 
                 BudgetResource__r.BudgetHeader__r.OriginalBudget__c OrigBudget, 
                 BudgetResource__r.BudgetHeader__r.Status__c Status
                 FROM BudgetAssignment__c
                 WHERE BudgetResource__r.ExpenditureResourceType__c = 'LAB'
                 AND BudgetResource__r.BudgetHeader__r.Project__c IN : projectIds
                 GROUP BY
                 	BudgetResource__r.BudgetHeader__r.Project__c, 
                 	BudgetResource__r.BudgetHeader__r.OriginalBudget__c, 
                 	BudgetResource__r.BudgetHeader__r.Status__c];

            for (AggregateResult ar : results)
            {
                Decimal hours = (Decimal)ar.get('Hours');
                if (hours != null) {
                    Id projId = (Id) ar.get('projectId');
                    ProjectSnapshot__c snapshot = projectIdToSnapshotMap.get(projId);
                   	String bStatus = (String) ar.get('Status');
                    Boolean origBudget = (Boolean) ar.get('OrigBudget');
                    
                    if (origBudget) {
                    	snapshot.HoursBudgetOriginal__c += hours;
                    }
                    
                    if (bStatus == 'Approved') {
                    	snapshot.HoursBudget__c += hours;
	                }
	                else { // Unapproved
	                    snapshot.HoursUnapproved__c += hours;
	                    
	                    if (bStatus == 'Forecast') {
	                    	snapshot.HoursForecast__c += hours;
	                    }
	                    else if (bStatus == 'Estimate') { // Draft
	                    	snapshot.HoursDraft__c += hours;
	                    }
	                }
	                
                	projectIdToSnapshotMap.put(projId, snapshot);
                }
            }
        }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }
        return projectIdToSnapshotMap;
    }

    @TestVisible private Map<Id, ProjectSnapshot__c> getPreviousFMForecastMap(Map<Id, ProjectSnapshot__c> projectIdToSnapshotMap) 
    {
    	try {
	        List<String> prevFiscalMonthList = new List<String>();
	        for (ProjectSnapshot__c ps : projectIdToSnapshotMap.values()) {
	            prevFiscalMonthList.add(ps.SnapshotPreviousFiscalMonth__c);
	        }
	
	        if (!prevFiscalMonthList.isEmpty()) {
	            List<ProjectSnapshot__c> snapshotPrevFMList = getPreviousFMForecastInformation(prevFiscalMonthList);
	
	            for (ProjectSnapshot__c snapshotPrevFM : snapshotPrevFMList) {
	                Id projId = snapshotPrevFM.Project__c;
	                ProjectSnapshot__c snapshot = projectIdToSnapshotMap.get(projId);
	                snapshot.GrossRevenueForecastPrevME__c = snapshotPrevFM.GrossRevenueForecast__c;
	                snapshot.CostsODCEXPSForecastPrevME__c = snapshotPrevFM.CostsODCEXPSForecast__c;
	                snapshot.CostsODCSUBSForecastPrevME__c = snapshotPrevFM.CostsODCSUBSForecast__c;
	                snapshot.ContingencyForecastPrevME__c = snapshotPrevFM.ContingencyForecast__c;
	                snapshot.LaborForecastPrevME__c = snapshotPrevFM.LaborForecast__c;
	                snapshot.FringeForecastPrevME__c = snapshotPrevFM.FringeForecast__c;
	                snapshot.OverheadForecastPrevME__c = snapshotPrevFM.OverheadForecast__c;
	                snapshot.HoursForecastPrevME__c = snapshotPrevFM.HoursForecast__c;
	                snapshot.LostMarginForecastPrevME__c = snapshotPrevFM.LostMarginForecast__c;
	                snapshot.ProjectEndDatePrevME__c = snapshotPrevFM.ProjectEndDate__c;
	                snapshot.CashFlowITDPrevME__c = snapshotPrevFM.CashFlowITD__c;
	                projectIdToSnapshotMap.put(projId, snapshot);
	            }
	        }
        }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }
        return projectIdToSnapshotMap;
    }

    private List<ProjectSnapshot__c> getPreviousFMForecastInformation(List<String> prevFiscalMonthList) 
    {   
        List<ProjectSnapshot__c> projSnapshots;
        try {
            projSnapshots = [SELECT Id, Project__c, GrossRevenueForecast__c, 
                CostsODCEXPSForecast__c, CostsODCSUBSForecast__c, ContingencyForecast__c,
                LaborForecast__c, FringeForecast__c, OverheadForecast__c, HoursForecast__c, 
                LostMarginForecast__c, ProjectEndDate__c, CashFlowITD__c
                FROM ProjectSnapshot__c 
                WHERE SnapshotType__c = 'Auto' 
                AND SnapshotFiscalMonth__c IN : prevFiscalMonthList];
        }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }
        return projSnapshots;
    }
}