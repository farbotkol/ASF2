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
    
    public DateTime pSnapshotDateTime {get; set;}
    public Date pSnapshotDate {get; set;}
    
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
        /*public Decimal NetMargin {get; set;}
        public Decimal NetServiceRevenue {get;set;}
        public Decimal NMNSR {get; set;}
        public Decimal NMGR {get; set;}*/
        public Decimal LaborMult {get; set;}
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
            /*NetMargin = 0;
            NetServiceRevenue = 0;
            NMNSR = 0;
            NMGR = 0;
            LaborMult = 0;*/
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
            List<EarnedValueHeader__c> evHeaders = [SELECT Id FROM EarnedValueHeader__c WHERE Project__c = :snapshotProjectId order by Id desc];
            
            if (evHeaders.size() > 0){
                List<EarnedValueSnapshot__c> snapshots = [SELECT Id FROM EarnedValueSnapshot__c
                                                    WHERE ProjectTask__r.pse__Project__c = :snapshotProjectId];
                
                if (snapshots.size() > 0)
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
                    
                    if (earnedValueTasks.size() > 0)
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
        snapshotList = createProjectSnapshots(pSnapshotAsOfDateTime);
        if (snapshotList != null && snapshotList.size() > 0) {
            return snapshotList[0];
        }
        else {
            return null;
        }
    }
    
    public List<ProjectSnapshot__c> createProjectSnapshots(DateTime pSnapshotAsOfDateTime)
    {
        pSnapshotDateTime = pSnapshotAsOfDateTime;
        pSnapshotDate = pSnapshotDateTime.date();
        
        List<ProjectSnapshot__c> snapshotList = new List<ProjectSnapshot__c>();
        try {
            System.debug(System.LoggingLevel.WARN, '___createProjectSnapshots Query rows INITIAL='+Limits.getQueryRows());
            
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

            if (projects != null && projects.size() > 0) {
                System.debug(System.LoggingLevel.WARN, '___Query rows ='+Limits.getQueryRows());
                Id changeOrderRecordTypeId = 
                    ECO_Utils_Meta.getRecordTypeId(BudgetHeader__c.sObjectType, 'Change Order');

                originalBudgetHeaderMap = getOriginalBudgetHeaderMap(projectIds, false);
                approvedBudgetHeaderMap = getApprovedBudgetHeaderMap(projectIds, false);
                lastUpdatedBudgetDateMap = getLastUpdatedBudgetDateMap(projectIds);
                forecastBudgetHeaderMap = getForecastBudgetHeaderMap(projectIds);
                draftBudgetHeaderMap = getDraftBudgetHeaderMap(projectIds);
                unapprovedBudgetHeaderMap = getUnapprovedBudgetHeaderMap(projectIds, true);
                
                timePeriodMap = getTimePeriodMap();
System.debug(System.LoggingLevel.WARN, '___Query rows ='+Limits.getQueryRows());      
      
                pse__Time_Period__c monthTP = (pse__Time_Period__c) timePeriodMap.get('Month');
                Date monthStartDate = monthTP.pse__Start_Date__c;
                mtdActualFinancialMetricsMap = getProjectActualFinancialsMap(projectIds, monthStartDate);    
System.debug(System.LoggingLevel.WARN, '___Query rows ='+Limits.getQueryRows());

                itdActualFinancialMetricsMap = getProjectActualFinancialsMap(projectIds, null);
System.debug(System.LoggingLevel.WARN, '___Query rows ='+Limits.getQueryRows());

                billingMetricsARMap = getBillingMetricsARMap(projectIds, itdActualFinancialMetricsMap);
System.debug(System.LoggingLevel.WARN, '___Query rows ='+Limits.getQueryRows());

                pse__Time_Period__c yearTP = (pse__Time_Period__c) timePeriodMap.get('Year');
                Date yearStartDate = yearTP.pse__Start_Date__c;
                ytdActualFinancialMetricsMap = getProjectActualFinancialsMap(projectIds, yearStartDate); 
System.debug(System.LoggingLevel.WARN, '___Query rows ='+Limits.getQueryRows());

                billingMetricsAR0to30Map = getBillingMetricsARDateRangeMap(projectIds, BILLED_0to30);
                System.debug(System.LoggingLevel.WARN, '___billingMetricsAR0to30Map='+billingMetricsAR0to30Map);
                billingMetricsAR31to60Map = getBillingMetricsARDateRangeMap(projectIds, BILLED_31to60);
                System.debug(System.LoggingLevel.WARN, '___billingMetricsAR31to60Map='+billingMetricsAR31to60Map);
                billingMetricsAR61to90Map = getBillingMetricsARDateRangeMap(projectIds, BILLED_61to90);
                System.debug(System.LoggingLevel.WARN, '___billingMetricsAR61to90Map='+billingMetricsAR61to90Map);
                billingMetricsAR91to180Map = getBillingMetricsARDateRangeMap(projectIds, BILLED_91to180);
                System.debug(System.LoggingLevel.WARN, '___billingMetricsAR91to180Map='+billingMetricsAR91to180Map);
                billingMetricsAR181PlusMap = getBillingMetricsAR181PlusMap(projectIds);
                System.debug(System.LoggingLevel.WARN, '___billingMetricsAR181PlusMap='+billingMetricsAR181PlusMap);

System.debug(System.LoggingLevel.WARN, '___Query rows ='+Limits.getQueryRows());

                // Note: Unbilled calculations are in reverse order
                unbilledMetricsAR181PlusMap = getUnbilledMetricsARDateRangeMap(projectIds, UNBILLED_181Plus);
                unbilledMetricsAR91to180Map = getUnbilledMetricsARDateRangeMap(projectIds, UNBILLED_91to180);
                unbilledMetricsAR61to90Map = getUnbilledMetricsARDateRangeMap(projectIds, UNBILLED_61to90);
                unbilledMetricsAR31to60Map = getUnbilledMetricsARDateRangeMap(projectIds, UNBILLED_31to60);
                unbilledMetricsAR0to30Map = getUnbilledMetricsARDateRangeMap(projectIds, UNBILLED_0to30);

System.debug(System.LoggingLevel.WARN, '___Query rows ='+Limits.getQueryRows());
                
                ProjectSnapshot__c snapshot;
                
                Map<Id, ProjectSnapshot__c> projIdToSnapshotMap = new Map<Id, ProjectSnapshot__c>();

                for (pse__Proj__c project : projects) {
                    snapshot = new ProjectSnapshot__c();
                    snapshot.SnapshotDate__c = DateTime.now();
                    snapshot.ProjectName__c = project.Name;
                    snapshot.ProjectRating__c = project.ProjectReviewCategory__c;
                    snapshot.ClientName__c = project.pse__Account__r.Name;
                    snapshot.ProjectManager__c = project.pse__Project_Manager__c;
                    snapshot.ProjectDirector__c = ECO_Service_ProjectTeam.getActiveProjectApproverId(project.Id);
                    snapshot.ProjectNumber__c = project.OracleProjectNumber__c;
                    snapshot.ProjectStartDate__c = project.pse__Start_Date__c;
                    snapshot.ProjectEndDate__c = project.pse__End_Date__c;
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
                        snapshot.PrimaryOrganization__c = organizationNameMap.get(primaryOrganizationId);//getPrimaryOrganization(projectId);

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
                            //snapshot.EarnedValueCPI__c = earnedValueController.mapDateCPI.get(EarnedValueSnapshotDate);
                            //snapshot.EarnedValueSPI__c = earnedValueController.mapDateSPI.get(EarnedValueSnapshotDate);
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
                    
                    // MTD
                    FinancialMetrics mtdFinancialMetrics = mtdActualFinancialMetricsMap.get(project.Id);
                    snapshot = getMtdActualFinancialMetricsMapInformation(mtdFinancialMetrics, snapshot, monthStartDate);
                    
                    // ITD
                    FinancialMetrics itdFinancialMetrics = itdActualFinancialMetricsMap.get(project.Id);
                    snapshot = getItdActualFinancialMetricsMapInformation(itdFinancialMetrics, snapshot);
                    
                    // YTD
                    FinancialMetrics ytdFinancialMetrics = ytdActualFinancialMetricsMap.get(project.Id);
                    snapshot = getYtdActualFinancialMetricsMapInformation(ytdFinancialMetrics, snapshot, yearStartDate);
                    
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
                    
                    System.debug(System.LoggingLevel.WARN, '___createProjectSnapshots: snapshot='+snapshot);
                    snapshotList.add(snapshot);
                }   
            }
            
            if (snapshotList.size() > 0) {
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

    private Map<Id, Decimal> getBillingMetricsAR181PlusMap(List<Id> projectIds)
    {
        Map<Id, Decimal> billingMetricsMap = new Map<Id, Decimal>();
        Date startDate;
        Date endDate;
        BillingMetrics billingMetrics;
        try {
            startDate = pSnapshotDate;
            endDate = pSnapshotDate.addDays(-181);
            for (AggregateResult ar: [SELECT ProjectNumber__c, SUM(InvoiceAmount__c) totalBilled
                            FROM Billing__c WHERE ProjectNumber__c IN :projectIds AND
                            InvoiceDate__c <= :startDate
                            GROUP BY ProjectNumber__c])
            {
                Decimal totalBilled = (Decimal)ar.get('totalBilled');
                if (totalBilled != null)
                {
                    billingMetrics = new BillingMetrics();
                    Id projId = (Id) ar.get('ProjectNumber__c');
                    billingMetricsMap.put(projId, totalBilled);
                }
            }
        }
        catch (Exception e) {
            System.debug(e.getStackTraceString());
        }
        return billingMetricsMap;
    }

    private Map<Id, Decimal> getBillingMetricsARDateRangeMap(List<Id> projectIds, String range)
    {
        Map<Id, Decimal> billingMetricsMap = new Map<Id, Decimal>();
        Date startDate; 
        Date endDate;
        try {
            if (range == BILLED_0to30) {
                startDate = pSnapshotDate;
                endDate = pSnapshotDate.addDays(-30);
            }
            else if (range == BILLED_31to60) {
                startDate = pSnapshotDate.addDays(-31);
                endDate = pSnapshotDate.addDays(-60);
            }
            else if (range == BILLED_61to90) {
                startDate = pSnapshotDate.addDays(-61);
                endDate = pSnapshotDate.addDays(-90);
            }
            else if (range == BILLED_91to180) {
                startDate = pSnapshotDate.addDays(-91);
                endDate = pSnapshotDate.addDays(-180);
            }

System.debug(System.LoggingLevel.WARN, '___startDate='+startDate+', endDate='+endDate);
            for (AggregateResult ar: [SELECT ProjectNumber__c, SUM(InvoiceAmount__c) totalBilled
                            FROM Billing__c WHERE ProjectNumber__c IN :projectIds AND
                            InvoiceDate__c <= :startDate AND InvoiceDate__c >= :endDate 
                            GROUP BY ProjectNumber__c])
            {
                Id projId = (Id) ar.get('ProjectNumber__c');
                Decimal totalBilled = (Decimal)ar.get('totalBilled');
System.debug(System.LoggingLevel.WARN, '___projId='+projId+', totalBilled='+totalBilled);
                if (totalBilled == null)
                {
                    totalBilled = 0;
                }        
                billingMetricsMap.put(projId, totalBilled);
            }
System.debug(System.LoggingLevel.WARN, '___getBillingMetricsARDateRangeMap='+billingMetricsMap);
        }
        catch (Exception e) {
            System.debug(e.getStackTraceString());
        }
        return billingMetricsMap;
    }

    ////////// Start Unbilled
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
            
            for (AggregateResult ar: [SELECT ProjectNumber__c, SUM(Amount__c) totalRevenue
                            FROM Revenue__c WHERE ProjectNumber__c IN :projectIds
                            AND GLDate__c <= :startDate
                            GROUP BY ProjectNumber__c])
            {
                Decimal unbilledValue = 0;
                Decimal totalRevenue = (Decimal)ar.get('totalRevenue');
                Id projId = (Id) ar.get('ProjectNumber__c');
                System.debug(System.LoggingLevel.WARN, '___range='+range+', totalRevenue='+totalRevenue+', projId='+projId);
                if (billingMetricsARMap != null) {
                    System.debug(System.LoggingLevel.WARN, '___billingMetricsARMap='+billingMetricsARMap);
                    if (range == UNBILLED_181Plus) {
                        if (totalRevenue != null)
                        {
                            unbilledValue = totalRevenue - billingMetricsARMap.get(projId).BilledAR;
                        }
                        else {
                            unbilledValue = 0 - billingMetricsARMap.get(projId).BilledAR;
                        }
                        System.debug(System.LoggingLevel.WARN, '___UNBILLED_181Plus='+unbilledValue);
                    }
                    else if (range == UNBILLED_91to180) {
                        if (totalRevenue != null)
                        {
                            unbilledValue = totalRevenue - (billingMetricsARMap.get(projId).BilledAR + unbilledMetricsAR181PlusMap.get(projId)); 
                        }
                        else {
                            unbilledValue = 0 - (billingMetricsARMap.get(projId).BilledAR + unbilledMetricsAR181PlusMap.get(projId)); 
                        }
                        System.debug(System.LoggingLevel.WARN, 'UNBILLED_91to180='+unbilledValue);
                    }
                    else if (range == UNBILLED_61to90) {
                        if (totalRevenue != null)
                        {
                            unbilledValue = totalRevenue - (billingMetricsARMap.get(projId).BilledAR + unbilledMetricsAR181PlusMap.get(projId) + 
                                unbilledMetricsAR91to180Map.get(projId));
                        }
                        else {
                            unbilledValue = 0 - (billingMetricsARMap.get(projId).BilledAR + unbilledMetricsAR181PlusMap.get(projId) + 
                                unbilledMetricsAR91to180Map.get(projId)); 
                        }
                        System.debug(System.LoggingLevel.WARN, 'UNBILLED_61to90='+unbilledValue);
                    }
                    else if (range == UNBILLED_31to60) {
                        if (totalRevenue != null)
                        {
                            unbilledValue = totalRevenue - (billingMetricsARMap.get(projId).BilledAR + unbilledMetricsAR181PlusMap.get(projId) + 
                                unbilledMetricsAR91to180Map.get(projId) + unbilledMetricsAR61to90Map.get(projId));
                        }
                        else {
                            unbilledValue = 0 - (billingMetricsARMap.get(projId).BilledAR + unbilledMetricsAR181PlusMap.get(projId) + 
                                unbilledMetricsAR91to180Map.get(projId) + unbilledMetricsAR61to90Map.get(projId));
                        }
                        System.debug(System.LoggingLevel.WARN, 'UNBILLED_31to60='+unbilledValue);
                    }
                    else if (range == UNBILLED_0to30) {
                        if (totalRevenue != null)
                        {
                            unbilledValue = totalRevenue - (billingMetricsARMap.get(projId).BilledAR + unbilledMetricsAR181PlusMap.get(projId) + 
                                unbilledMetricsAR91to180Map.get(projId) + unbilledMetricsAR61to90Map.get(projId) + unbilledMetricsAR31to60Map.get(projId));
                        }
                        else {
                            unbilledValue = 0 - (billingMetricsARMap.get(projId).BilledAR + unbilledMetricsAR181PlusMap.get(projId) + 
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
            snapshot.LaborBudgetOriginal__c = originalBudgetFinancialMetrics.TotalLabor;
            snapshot.ContingencyBudgetOriginal__c = originalBudgetFinancialMetrics.TotalContingency;
        }
        return snapshot;
    }

    @TestVisible private ProjectSnapshot__c getApprovedBudgetHeaderMapInformation(FinancialMetrics approvedBudgetFinancialMetrics, ProjectSnapshot__c snapshot) {
        if (approvedBudgetFinancialMetrics != null) {
            snapshot.GrossRevenueBudget__c = approvedBudgetFinancialMetrics.TotalRevenue;
            snapshot.CostBudget__c = approvedBudgetFinancialMetrics.TotalCost;
            /*snapshot.NetMarginBudget__c = approvedBudgetFinancialMetrics.NetMargin;
            snapshot.NetServiceBudget__c = approvedBudgetFinancialMetrics.NetServiceRevenue;
            snapshot.NMNSRBudget__c = approvedBudgetFinancialMetrics.NMNSR;
            snapshot.NMGRBudget__c = approvedBudgetFinancialMetrics.NMGR;*/
            snapshot.LaborMultBudget__c = approvedBudgetFinancialMetrics.LaborMult;
            snapshot.ContingencyBudget__c = approvedBudgetFinancialMetrics.TotalContingency;
        }
        return snapshot;
    }

    @TestVisible private Map<Id, DateTime> getLastUpdatedBudgetDateMap(List<Id> projectIds)
    {
        Map<Id, DateTime> lastUpdatedBudgetDateMap = new Map<Id, DateTime>();
        List<BudgetHeader__c> budgets = [SELECT Project__c, LastModifiedDate FROM BudgetHeader__c 
                                         WHERE Project__c IN :projectIds
                                         AND Status__c = 'Approved' ORDER BY LastModifiedDate DESC];
        
        if (budgets.size() > 0) {
            for (BudgetHeader__c bh : budgets) {
                lastUpdatedBudgetDateMap.put(bh.Project__c, bh.LastModifiedDate);
            }
            System.debug(System.LoggingLevel.WARN, '___lastUpdatedBudgetDateMap='+lastUpdatedBudgetDateMap);
        }
        return lastUpdatedBudgetDateMap;
    }

    @TestVisible private Map<String, pse__Time_Period__c> getTimePeriodMap() {
        Map<String, pse__Time_Period__c> timePeriodMap = new Map<String, pse__Time_Period__c>();
        List<pse__Time_Period__c> timePeriodList = 
            [SELECT pse__Type__c, pse__Start_Date__c, pse__End_Date__c FROM pse__Time_Period__c 
             WHERE pse__Start_Date__c <= TODAY AND pse__End_Date__c >= TODAY 
             AND (pse__Type__c='Month' OR pse__Type__c='Year')];

        for (pse__Time_Period__c tp : timePeriodList) {
            timePeriodMap.put(tp.pse__Type__c, tp);
        }
        return timePeriodMap;
    }

    @TestVisible private ProjectSnapshot__c getForecastBudgetHeaderMapInformation(FinancialMetrics forecastBudgetFinancialMetrics, ProjectSnapshot__c snapshot) {
        if (forecastBudgetFinancialMetrics != null) {
            snapshot.GrossRevenueForecast__c = forecastBudgetFinancialMetrics.TotalRevenue;
            snapshot.CostForecast__c = forecastBudgetFinancialMetrics.TotalCost;
            /*snapshot.NetMarginForecast__c = forecastBudgetFinancialMetrics.NetMargin; 
            snapshot.NetServiceForecast__c = forecastBudgetFinancialMetrics.NetServiceRevenue;
            snapshot.NMNSRForecast__c = forecastBudgetFinancialMetrics.NMNSR;
            snapshot.NMGRForecast__c = forecastBudgetFinancialMetrics.NMGR;*/
            snapshot.LaborMultForecast__c = forecastBudgetFinancialMetrics.LaborMult;
            snapshot.ContingencyForecast__c = forecastBudgetFinancialMetrics.TotalContingency;
        }
        return snapshot;
    }        

    @TestVisible private ProjectSnapshot__c getDraftBudgetHeaderMapInformation(FinancialMetrics draftBudgetFinancialMetrics, ProjectSnapshot__c snapshot) {
        if (draftBudgetFinancialMetrics != null) {
            snapshot.GrossRevenueDraft__c = draftBudgetFinancialMetrics.TotalRevenue;
            snapshot.CostDraft__c = draftBudgetFinancialMetrics.TotalCost;
            /*snapshot.NetMarginDraft__c = draftBudgetFinancialMetrics.NetMargin; 
            snapshot.NetServiceDraft__c = draftBudgetFinancialMetrics.NetServiceRevenue;
            snapshot.NMNSRDraft__c = draftBudgetFinancialMetrics.NMNSR;
            snapshot.NMGRDraft__c = draftBudgetFinancialMetrics.NMGR;*/
            snapshot.LaborMultDraft__c = draftBudgetFinancialMetrics.LaborMult;
            snapshot.ContingencyDraft__c = draftBudgetFinancialMetrics.TotalContingency;
        }
        return snapshot;
    }

    @TestVisible private ProjectSnapshot__c getUnapprovedBudgetHeaderMapInformation(FinancialMetrics unapprovedBudgetFinancialMetrics, ProjectSnapshot__c snapshot) {
        if (unapprovedBudgetFinancialMetrics != null) {
            snapshot.GrossRevenueUnapproved__c = unapprovedBudgetFinancialMetrics.TotalRevenue;
            snapshot.CostUnapproved__c = unapprovedBudgetFinancialMetrics.TotalCost;
            /*snapshot.NetMarginUnapproved__c = unapprovedBudgetFinancialMetrics.NetMargin;   
            snapshot.NetServiceUnapproved__c = unapprovedBudgetFinancialMetrics.NetServiceRevenue;
            snapshot.NMNSRUnapproved__c = unapprovedBudgetFinancialMetrics.NMNSR;
            snapshot.NMGRUnapproved__c = unapprovedBudgetFinancialMetrics.NMGR;*/
            snapshot.LaborMultUnapproved__c = unapprovedBudgetFinancialMetrics.LaborMult;
            snapshot.ContingencyUnapproved__c = unapprovedBudgetFinancialMetrics.TotalContingency; 
        }
        return snapshot;
    }

    @TestVisible private ProjectSnapshot__c getMtdActualFinancialMetricsMapInformation(FinancialMetrics mtdActualFinancialMetrics, 
            ProjectSnapshot__c snapshot, Date monthStartDate) {
        if (mtdActualFinancialMetrics != null) {
            snapshot.GrossRevenueMonthToDate__c = mtdActualFinancialMetrics.TotalRevenue;
            snapshot.CostMonthToDate__c = mtdActualFinancialMetrics.TotalCost;
            /*snapshot.NetMarginMonthToDate__c = mtdActualFinancialMetrics.NetMargin;
            snapshot.NetServiceMonthToDate__c = mtdActualFinancialMetrics.NetServiceRevenue;
            snapshot.NMNSRMonthToDate__c = mtdActualFinancialMetrics.NMNSR;
            snapshot.NMGRMonthToDate__c = mtdActualFinancialMetrics.NMGR;*/
            snapshot.LaborMultMonthToDate__c = mtdActualFinancialMetrics.LaborMult;
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
            /*snapshot.NetMarginITD__c = itdActualFinancialMetrics.NetMargin;
            snapshot.NetServiceITD__c = itdActualFinancialMetrics.NetServiceRevenue;
            snapshot.NMNSRITD__c = itdActualFinancialMetrics.NMNSR;
            snapshot.NMGRITD__c = itdActualFinancialMetrics.NMGR;*/
            snapshot.LaborMultITD__c = itdActualFinancialMetrics.LaborMult;
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
            /*snapshot.NetMarginYearToDate__c = ytdActualFinancialMetrics.NetMargin;
            snapshot.NetServiceYearToDate__c = ytdActualFinancialMetrics.NetServiceRevenue;
            snapshot.NMNSRYearToDate__c = ytdActualFinancialMetrics.NMNSR;
            snapshot.NMGRYearToDate__c = ytdActualFinancialMetrics.NMGR;*/
            snapshot.LaborMultYearToDate__c = ytdActualFinancialMetrics.LaborMult;
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

    public Map<Id, FinancialMetrics> getProjectActualFinancialsCosts(List<Id> projectIds, Date asOfDate)
    {
        Map<Id, FinancialMetrics> metricsMap = new Map<Id, FinancialMetrics>();
        list<AggregateResult> results = new list<AggregateResult>();
    
        try {
            String query = 
                'SELECT ExpenditureItem__r.ProjectTask__r.pse__Project__c projectId,'+
                ' SUM(ProjectFunctionalBurdenedCost__c) funcBurdenedCost,'+ 
                ' ExpenditureItem__r.PLReportCategory__c category'+
                ' FROM CostDistLine__c'+
                ' WHERE ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id IN :projectIds';

            if (asOfDate != null) {
                query += ' AND ExpenditureItem__r.ExpenditureItemDate__c >= :asOfDate'+
                    ' AND ExpenditureItem__r.ExpenditureItemDate__c <= TODAY';
            }
            
            query += ' GROUP BY ExpenditureItem__r.PLReportCategory__c, ExpenditureItem__r.ProjectTask__r.pse__Project__c'+
                     ' ORDER BY ExpenditureItem__r.ProjectTask__r.pse__Project__c';
                     
            //System.debug(System.LoggingLevel.WARN, '___ProjectActualFinancialsCosts projectIds='+projectIds+', asOfDate='+asOfDate);
            //System.debug(System.LoggingLevel.WARN, '___query='+query);
            results = database.query(query);
            plReportCategorySet = getPLReportCategories();

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
                
                String arCategory = (String) ar.get('category');
                Decimal funcBurdenedCost = (Decimal)ar.get('funcBurdenedCost');
                
                if (arCategory != null && funcBurdenedCost != null && plReportCategorySet.contains(arCategory)) {
                    //System.debug(System.LoggingLevel.WARN, '___arCategory='+arCategory+', funcBurdenedCost='+funcBurdenedCost);
                    if (arCategory == ODC_Exps) {
                        metrics.CostsODCEXPS = funcBurdenedCost;
                    }
                    else if (arCategory == ODC_Subs) {
                        metrics.CostsODCSUBS = funcBurdenedCost;
                    }
                    else if (arCategory == ODC_Contingency) {
                        metrics.TotalContingency = funcBurdenedCost;
                    }
                    else if (arCategory == 'Labor') {
                        metrics.Labor = funcBurdenedCost;
                    }
                    else if (arCategory == 'Fringe') {
                        metrics.Fringe = funcBurdenedCost;
                    }
                    else if (arCategory == 'Overhead') {
                        metrics.Overhead = funcBurdenedCost;
                    }
                }
                metricsMap.put(currentProjectId, metrics); // store populated metrics data
            }
            System.debug(System.LoggingLevel.WARN, '___ProjectActualFinancialsCostsMap='+metricsMap);
        }
        catch (Exception e) {
            System.debug(e.getStackTraceString());
        }
        return metricsMap;
    }

    public Map<Id, FinancialMetrics> getProjectActualFinancialsCostsLabor(List<Id> projectIds, Date asOfDate)
    {
        Map<Id, FinancialMetrics> metricsMap = new Map<Id, FinancialMetrics>();
        list<AggregateResult> results = new list<AggregateResult>();
    
        try {
            String query = 
                'SELECT ExpenditureItem__r.ProjectTask__r.pse__Project__c projectId,'+ 
                ' SUM(ProjectFunctionalBurdenedCost__c) Labor FROM CostDistLine__c'+
                ' WHERE ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id IN :projectIds' +
                ' AND ExpenditureItem__r.PLReportCategory__c = \'Labor\''+
                ' AND ExpenditureItem__r.PLReportCategory__c != \'Fringe\''+
                ' AND ExpenditureItem__r.PLReportCategory__c != \'Overhead\' ';  

            if (asOfDate != null) {
                query += ' AND ExpenditureItem__r.ExpenditureItemDate__c >= :asOfDate'+
                    ' AND ExpenditureItem__r.ExpenditureItemDate__c <= TODAY';
            }

            query += ' GROUP BY ExpenditureItem__r.ProjectTask__r.pse__Project__c';
            System.debug(System.LoggingLevel.WARN, '___projectIds='+projectIds+', asOfDate='+asOfDate);
            System.debug(System.LoggingLevel.WARN, '___query='+query);
            results = database.query(query);
            plReportCategorySet = getPLReportCategories();

            for (AggregateResult ar : results)
            {
                FinancialMetrics metrics = new FinancialMetrics();
                Decimal laborValue =  (Decimal)ar.get('Labor');
                if (laborValue != null) {
                    metrics.Labor = laborValue;
                    metricsMap.put((Id)ar.get('projectId'), metrics);
                    System.debug(System.LoggingLevel.WARN, '___CostsLaborMap='+metricsMap);
                }
            }
        }
        catch (Exception e) {
            System.debug(e.getStackTraceString());
        }
        return metricsMap;
    }

    public Map<Id, FinancialMetrics> getProjectActualFinancialsCostsHours(List<Id> projectIds, Date asOfDate)
    {
        Map<Id, FinancialMetrics> metricsMap = new Map<Id, FinancialMetrics>();
        list<AggregateResult> results = new list<AggregateResult>();
    
        try {
            String query = 
                'SELECT ExpenditureItem__r.ProjectTask__r.pse__Project__c projectId,'+ 
                ' SUM(ExpenditureItem__r.Quantity__c) Hours FROM CostDistLine__c'+
                ' WHERE ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id IN :projectIds';

            if (asOfDate != null) {
                query += ' AND ExpenditureItem__r.ExpenditureItemDate__c >= :asOfDate'+
                    ' AND ExpenditureItem__r.ExpenditureItemDate__c <= TODAY';
            }

            query += ' GROUP BY ExpenditureItem__r.ProjectTask__r.pse__Project__c';
            results = database.query(query);
            plReportCategorySet = getPLReportCategories();

            for (AggregateResult ar : results)
            {
                Decimal hoursValue = (Decimal)ar.get('Hours');
                FinancialMetrics metrics = new FinancialMetrics();
                if (hoursValue != null) {
                    metrics.Hours = hoursValue;
                    metricsMap.put((Id)ar.get('projectId'), metrics);
                }
            }
        }
        catch (Exception e) {
            System.debug(e.getStackTraceString());
        }
        return metricsMap;
    }

    // Time period
    private Map<Id, ProjectSnapshot__c> getSnapshotFiscalMonths(List<ProjectSnapshot__c> snapshots) {
        Map<Id, ProjectSnapshot__c> projectIdToSnapshotMap = new Map<Id, ProjectSnapshot__c>();
        List<pse__Time_Period__c> timePeriods = ECO_ProjectTaskService.calcTimePeriods;
        
        for (ProjectSnapshot__c snapshot : snapshots) {
            pse__Time_Period__c fm = null;
            if (snapshot.SnapshotDate__c != null){                                      
                fm = ECO_Utils_Date.getFiscalPeriod(snapshot.SnapshotDate__c.date(), 0, timePeriods);  
                if (fm != null){
                    snapshot.SnapshotFiscalMonth__c = fm.TimePeriodCode__c;
                } 
                
                fm = ECO_Utils_Date.getFiscalPeriod(snapshot.SnapshotDate__c.date(), 1, timePeriods);  
                if (fm != null){
                    snapshot.SnapshotPreviousFiscalMonth__c = fm.TimePeriodCode__c;
                }

                projectIdToSnapshotMap.put(snapshot.Project__c, snapshot);
            }
        }
        return projectIdToSnapshotMap;
    }

    private String getRelatedProjectTasks(List<Id> projectIds)
    {
        String returnString = '';
        System.debug(System.LoggingLevel.WARN, '___getRelatedProjectTasks Query rows BEFORE='+Limits.getQueryRows());
        List<pse__Project_Task__c> projectTasks = [SELECT Id, Name, pse__Actual_End_Date__c, pse__Actual_Start_Date__c, 
            pse__End_Date__c, pse__Start_Date__c, ProjectTaskNumber__c FROM pse__Project_Task__c 
            WHERE pse__Project__c IN :projectIds];
        System.debug(System.LoggingLevel.WARN, '___getRelatedProjectTasks Query rows AFTER='+Limits.getQueryRows());
        System.debug(System.LoggingLevel.WARN, '___getRelatedProjectTasks rows='+projectTasks.size());
        for (pse__Project_Task__c projectTask:projectTasks)
        {
            if (returnString == '')
                returnString = projectTask.Name + ';;' + projectTask.ProjectTaskNumber__c + ';;' + projectTask.pse__Start_Date__c.format()  + ';;' + projectTask.pse__End_Date__c.format()  + ';;' + projectTask.pse__Actual_Start_Date__c + ';;' + projectTask.pse__Actual_End_Date__c;
            else
                returnString += '::' + projectTask.Name + ';;' + projectTask.ProjectTaskNumber__c + ';;' + projectTask.pse__Start_Date__c.format()  + ';;' + projectTask.pse__End_Date__c.format()  + ';;' + projectTask.pse__Actual_Start_Date__c + ';;' + projectTask.pse__Actual_End_Date__c;            
        }
        return returnString;
    }
    
    private DateTime getLastUpdatedBudgetDate(List<Id> projectIds)
    {
        List<BudgetHeader__c> budgets = [SELECT Id, LastModifiedDate FROM BudgetHeader__c WHERE Project__c IN :projectIds
                                                AND Status__c = 'Approved' order by LastModifiedDate desc];
        
        if (budgets.size() > 0)
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
        map<Id, Decimal> projectsFutureSpendMap = new map<Id, Decimal>();
        for (AggregateResult ar : [SELECT SUM(ApprovedCost__c) ApprovedCost, Project__c
                                    FROM WeeklyRollupEntry__c
                                    WHERE Project__c IN :projectIds AND PeriodStartDate__c > :startDate 
                                    AND PeriodStartDate__c <= :endDate
                                    GROUP BY Project__c])
        {
            if (ar.get('ApprovedCost') != null)
            {
                projectsFutureSpendMap.put((Id)ar.get('Project__c'), (Decimal)ar.get('ApprovedCost'));
            }
        }   
        return projectsFutureSpendMap;
    }
    
    private void populateOrganizationsMaps(List<Id> projectIds)
    {   
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
        
    private String getRelatedAgreements(List<Id> projectIds)
    {   
        String agreements = ''; 
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
        return agreements;
    }

    private String getPendingChangeOrders(List<Id> projectIds, Id recordTypeId)
    {
        String changeOrders = '';
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
        return changeOrders;            
    }
    
    private String getDraftChangedOrders(List<Id> projectIds, Id recordTypeId)
    {   
        String changeOrders = '';   
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
                    
                /*metrics.NetMargin = metrics.TotalRevenue - metrics.TotalCost;
                metrics.NetServiceRevenue = metrics.TotalRevenue - metrics.TotalNonLabor;
                
                if (metrics.TotalRevenue != 0)
                    metrics.NMGR = ((metrics.TotalRevenue - metrics.TotalCost)/metrics.TotalRevenue) * 100;
                if (metrics.TotalRevenue - metrics.TotalNonLabor != 0)   
                    metrics.NMNSR = ((metrics.TotalRevenue - metrics.TotalCost)/(metrics.TotalRevenue - metrics.TotalNonLabor)) * 100;
                */
                if (metrics.TotalLabor != 0)
                    metrics.LaborMult = (metrics.TotalRevenue - metrics.TotalNonLabor)/metrics.TotalLabor;
                
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
                    
                /*metrics.NetMargin = metrics.TotalRevenue - metrics.TotalCost;
                metrics.NetServiceRevenue = metrics.TotalRevenue - metrics.TotalNonLabor;
                
                if (metrics.TotalRevenue != 0)
                    metrics.NMGR = ((metrics.TotalRevenue - metrics.TotalCost)/metrics.TotalRevenue) * 100;
                if (metrics.TotalRevenue - metrics.TotalNonLabor != 0)   
                    metrics.NMNSR = ((metrics.TotalRevenue - metrics.TotalCost)/(metrics.TotalRevenue - metrics.TotalNonLabor)) * 100;
                */
                if (metrics.TotalLabor != 0)
                    metrics.LaborMult = (metrics.TotalRevenue - metrics.TotalNonLabor)/metrics.TotalLabor;
                
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
            String query = 'SELECT Project__c, SUM(TotalRevenue__c) totalRevenue, SUM(TotalCost__c) totalCost,'+
                ' SUM(TotalNonLabor__c) totalNonLabor, SUM(TotalLaborAmount__c) totalLabor,'+
                ' SUM(TotalContingencyAmount__c) totalContingency'+
                ' FROM BudgetHeader__c'+
                ' WHERE Project__c IN :projectIds'+
                ' AND Status__c = \'Forecast\' '+
                ' GROUP BY Project__c';
            
            List<AggregateResult> results = database.query(query);
            for (AggregateResult ar : results) {
                System.debug(System.logginglevel.WARN, '___getForecastBudgetHeaderMap projectId='+(Id)ar.get('Project__c'));
                FinancialMetrics metrics = new FinancialMetrics();
                metrics.TotalRevenue = returnMapDecimalValue((Decimal)ar.get('totalRevenue'));
                metrics.TotalCost = returnMapDecimalValue((Decimal)ar.get('totalCost'));
                metrics.TotalNonLabor = returnMapDecimalValue((Decimal)ar.get('totalNonLabor'));
                metrics.TotalLabor = returnMapDecimalValue((Decimal)ar.get('totalLabor'));  
                metrics.TotalContingency = returnMapDecimalValue((Decimal)ar.get('totalContingency'));  
                    
                /*metrics.NetMargin = metrics.TotalRevenue - metrics.TotalCost;
                metrics.NetServiceRevenue = metrics.TotalRevenue - metrics.TotalNonLabor;
                
                if (metrics.TotalRevenue != 0)
                    metrics.NMGR = ((metrics.TotalRevenue - metrics.TotalCost)/metrics.TotalRevenue) * 100;
                if (metrics.TotalRevenue - metrics.TotalNonLabor != 0)   
                    metrics.NMNSR = ((metrics.TotalRevenue - metrics.TotalCost)/(metrics.TotalRevenue - metrics.TotalNonLabor)) * 100;
                */
                if (metrics.TotalLabor != 0)
                    metrics.LaborMult = (metrics.TotalRevenue - metrics.TotalNonLabor)/metrics.TotalLabor;
                
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
                    
                /*metrics.NetMargin = metrics.TotalRevenue - metrics.TotalCost;
                metrics.NetServiceRevenue = metrics.TotalRevenue - metrics.TotalNonLabor;
                
                if (metrics.TotalRevenue != 0)
                    metrics.NMGR = ((metrics.TotalRevenue - metrics.TotalCost)/metrics.TotalRevenue) * 100;
                if (metrics.TotalRevenue - metrics.TotalNonLabor != 0)   
                    metrics.NMNSR = ((metrics.TotalRevenue - metrics.TotalCost)/(metrics.TotalRevenue - metrics.TotalNonLabor)) * 100;
                */
                if (metrics.TotalLabor != 0)
                    metrics.LaborMult = (metrics.TotalRevenue - metrics.TotalNonLabor)/metrics.TotalLabor;
                
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
                    
                /*metrics.NetMargin = metrics.TotalRevenue - metrics.TotalCost;
                metrics.NetServiceRevenue = metrics.TotalRevenue - metrics.TotalNonLabor;
                
                if (metrics.TotalRevenue != 0)
                    metrics.NMGR = ((metrics.TotalRevenue - metrics.TotalCost)/metrics.TotalRevenue) * 100;
                if (metrics.TotalRevenue - metrics.TotalNonLabor != 0)   
                    metrics.NMNSR = ((metrics.TotalRevenue - metrics.TotalCost)/(metrics.TotalRevenue - metrics.TotalNonLabor)) * 100;
                */
                if (metrics.TotalLabor != 0)
                    metrics.LaborMult = (metrics.TotalRevenue - metrics.TotalNonLabor)/metrics.TotalLabor;
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
                query += ' AND GLDate__c >= :asOfDate AND GLDate__c <= TODAY ';
            }
            query += ' GROUP BY ProjectNumber__c';
            
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
            String query = 'SELECT ExpenditureItem__r.ProjectTask__r.pse__Project__c projectId,'+ 
                ' SUM(ProjectRawCost__c) totalCost FROM CostDistLine__c'+ 
                ' WHERE ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id IN :projectIds'+
                ' AND GLDate__c <= :asOfDate'+
                ' GROUP BY ExpenditureItem__r.ProjectTask__r.pse__Project__c';
            
            List<AggregateResult> results = database.query(query);
            for (AggregateResult ar: results)
            {
                Decimal totalCostValue = (Decimal)ar.get('totalCost');
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

/********
SELECT pseProjectc projectId,
SUM(TotalProjectRawCostc) totalCost FROM pseProject_Taskc'+
WHERE pseProjectc IN :projectIds
GROUP BY pseProject__c
**/
    @TestVisible private Map<Id, FinancialMetrics> getProjectActualFinancialsTotalCostMap(List<Id> projectIds, 
        Date asOfDate, Map<Id, FinancialMetrics> totalRevenueMap)
    {
        Map<Id, FinancialMetrics> metricsMap = new Map<Id, FinancialMetrics>();
        FinancialMetrics metrics = new FinancialMetrics();
        System.debug(System.LoggingLevel.WARN, '___getProjectActualFinancialsTotalCostMap Query rows ='+Limits.getQueryRows());
            
        try {
            String query = 'SELECT ExpenditureItem__r.ProjectTask__r.pse__Project__c projectId,'+ 
                ' SUM(ProjectRawCost__c) totalCost FROM CostDistLine__c'+ 
                ' WHERE ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id IN :projectIds ';                                                                                       
            if (asOfDate != null) {
                query += ' AND GLDate__c >= :asOfDate AND GLDate__c <= TODAY ';
            }
            query += ' GROUP BY ExpenditureItem__r.ProjectTask__r.pse__Project__c';
            
            System.debug(System.LoggingLevel.WARN, '___getProjectActualFinancialsTotalCostMap Query rows ='+Limits.getQueryRows());       
            
            List<AggregateResult> results = database.query(query);
            System.debug(System.LoggingLevel.WARN, '___getProjectActualFinancialsTotalCostMap Query rows ='+Limits.getQueryRows());
            
            for (AggregateResult ar: results)
            {
                Decimal totalCostValue = (Decimal)ar.get('totalCost');
                if (totalCostValue != null) {
                    metrics.TotalCost = totalCostValue;
                    Decimal totalRevenueValue = (Decimal) totalRevenueMap.get((Id)ar.get('projectId')).TotalRevenue;
                    //metrics.NetMargin = totalRevenueValue - metrics.TotalCost;
                    metricsMap.put((Id)ar.get('projectId'), metrics);
                }
            }
        }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }
        return metricsMap; 
    }

    @TestVisible private Map<Id, FinancialMetrics> getProjectActualFinancialsTotalLaborMap(List<Id> projectIds, Date asOfDate)
    {
        Map<Id, FinancialMetrics> metricsMap = new Map<Id, FinancialMetrics>();
        FinancialMetrics metrics = new FinancialMetrics();
        try {
            String query = 'SELECT ExpenditureItem__r.ProjectTask__r.pse__Project__c projectId,'+ 
                ' SUM(ProjectRawCost__c) totalLabor FROM CostDistLine__c'+
                ' WHERE ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id IN :projectIds'+
                ' AND ExpenditureItem__r.ExpenditureType__c like  \'LAB% \' ';
            if (asOfDate != null) {
                query += ' AND GLDate__c >= :asOfDate AND GLDate__c <= TODAY ';
            }
            query += ' GROUP BY ExpenditureItem__r.ProjectTask__r.pse__Project__c';
            
            List<AggregateResult> results = database.query(query);
            for (AggregateResult ar: results)
            {
                Decimal totalLaborValue = (Decimal)ar.get('totalLabor');
                if (totalLaborValue != null) {
                    metrics.TotalLabor = totalLaborValue;
                    metricsMap.put((Id)ar.get('projectId'), metrics);
                }
            }
        }
        catch(Exception e) {
            System.Debug(e.getStackTraceString());
        }
        return metricsMap; 
    }

    @TestVisible private Map<Id, FinancialMetrics> getProjectActualFinancialsTotalNonLaborMap(List<Id> projectIds, Date asOfDate)
    {
        Map<Id, FinancialMetrics> metricsMap = new Map<Id, FinancialMetrics>();
        FinancialMetrics metrics = new FinancialMetrics();
        try {
            String query = 'SELECT ExpenditureItem__r.ProjectTask__r.pse__Project__c projectId,'+ 
                ' SUM(ProjectRawCost__c) totalNonLabor FROM CostDistLine__c'+
                ' WHERE ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id IN :projectIds ' + 
                ' AND (NOT ExpenditureItem__r.ExpenditureType__c like \'LAB% \') ';
            if (asOfDate != null) {
                query += ' AND GLDate__c >= :asOfDate AND GLDate__c <= TODAY ';
            }
            query += ' GROUP BY ExpenditureItem__r.ProjectTask__r.pse__Project__c';
            
            List<AggregateResult> results = database.query(query);
            for (AggregateResult ar: results)
            {
                Decimal totalNonLaborValue = (Decimal)ar.get('totalNonLabor');
                if (totalNonLaborValue != null) {
                    metrics.TotalNonLabor = totalNonLaborValue;
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
            Map<Id, FinancialMetrics> totalCostMap = getProjectActualFinancialsTotalCostMap(projectIds, asOfDate, totalRevenueMap);
            System.debug(System.LoggingLevel.WARN, '___Query rows ='+Limits.getQueryRows());
            Map<Id, FinancialMetrics> totalLaborMap = getProjectActualFinancialsTotalLaborMap(projectIds, asOfDate);
            System.debug(System.LoggingLevel.WARN, '___Query rows ='+Limits.getQueryRows());
            Map<Id, FinancialMetrics> totalNonLaborMap = getProjectActualFinancialsTotalNonLaborMap(projectIds, asOfDate);
            System.debug(System.LoggingLevel.WARN, '___Query rows ='+Limits.getQueryRows());
            
            Map<Id, FinancialMetrics> funcBurdenedCostsMap = getProjectActualFinancialsCosts(projectIds, asOfDate);
            System.debug(System.LoggingLevel.WARN, '___Query rows ='+Limits.getQueryRows());
            Map<Id, FinancialMetrics> funcBurdenedCostsLaborMap = getProjectActualFinancialsCostsLabor(projectIds, asOfDate);
            System.debug(System.LoggingLevel.WARN, '___Query rows ='+Limits.getQueryRows());
            Map<Id, FinancialMetrics> funcBurdenedCostsHoursMap = getProjectActualFinancialsCostsHours(projectIds, asOfDate);
            System.debug(System.LoggingLevel.WARN, '___Query rows ='+Limits.getQueryRows());
            
            for (Id projId : projectIds) {
                metrics = new FinancialMetrics();
                FinancialMetrics totalRevenueMetrics = totalRevenueMap.get(projId);
                FinancialMetrics totalCostMetrics = totalCostMap.get(projId);
                FinancialMetrics totalLaborMetrics = totalLaborMap.get(projId);
                FinancialMetrics totalNonLaborMetrics = totalNonLaborMap.get(projId);
                
                FinancialMetrics funcBurdenedCostsMetrics = funcBurdenedCostsMap.get(projId);
                FinancialMetrics funcBurdenedCostsLaborMetrics = funcBurdenedCostsLaborMap.get(projId);
                FinancialMetrics funcBurdenedCostsHoursMetrics = funcBurdenedCostsHoursMap.get(projId);

                if (totalRevenueMetrics != null) {
                    metrics.totalRevenue = totalRevenueMetrics.totalRevenue;
                }

                /*if (totalRevenueMetrics != null && totalNonLaborMetrics != null) {    
                    metrics.NetServiceRevenue = getNetService(totalRevenueMetrics.TotalRevenue, totalNonLaborMetrics.TotalNonLabor); 
                    System.debug(System.LoggingLevel.WARN, '___metrics.NetServiceRevenue='+metrics.NetServiceRevenue);
                }
                
                if (totalRevenueMetrics != null && totalCostMetrics != null) {
                    metrics.NMGR = getNMGR(totalCostMetrics.NetMargin, totalRevenueMetrics.TotalRevenue);
                    System.debug(System.LoggingLevel.WARN, '___metrics.NMGR='+metrics.NMGR);
                }
                
                if (totalCostMetrics != null) {
                    metrics.NMNSR = getNMNSRC(totalCostMetrics.NetMargin, metrics.NetServiceRevenue);
                    System.debug(System.LoggingLevel.WARN, '___metrics.NMNSR='+metrics.NMNSR);
                }*/
                
                if (totalRevenueMetrics != null && totalLaborMetrics != null && totalNonLaborMetrics != null) {   
                    metrics.LaborMult = getLaborMult(totalRevenueMetrics.TotalRevenue, totalNonLaborMetrics.TotalNonLabor, totalLaborMetrics.TotalLabor);
                    System.debug(System.LoggingLevel.WARN, '___metrics.LaborMult='+metrics.LaborMult); 
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
        if (plReportCategorySet.isEmpty()) {
            List<AggregateResult> arList = [SELECT PLReportCategory__c FROM ExpenditureType__c 
                 WHERE PLReportCategory__c != Null GROUP BY PLReportCategory__c]; // Distinct values
            for (AggregateResult ar : arList) {
                plReportCategorySet.add((String) ar.get('PLReportCategory__c'));
            }
            //System.debug(System.LoggingLevel.WARN, '___plReportCategorySet='+plReportCategorySet);
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
                    ProjectTask__r.pse__Project__r.Id, BudgetResource__r.BudgetHeader__r.Status__c,
                    BudgetResource__r.BudgetHeader__r.OriginalBudget__c
                 FROM BudgetAssignment__c 
                 WHERE BudgetResource__r.PLReportCategory__c IN :plReportCategorySet
                 AND (BudgetResource__r.BudgetHeader__r.OriginalBudget__c=true
                 OR BudgetResource__r.BudgetHeader__r.Status__c = 'Forecast'
                 OR BudgetResource__r.BudgetHeader__r.Status__c = 'Approved')
                 AND ProjectTask__r.pse__Project__r.Id IN : projectIds];

            for (BudgetAssignment__c ba : budgetAssignments) {
                String PLReportCategory = ba.BudgetResource__r.PLReportCategory__c;
                Id projId = ba.ProjectTask__r.pse__Project__r.Id;
                ProjectSnapshot__c snapshot = projectIdToSnapshotMap.get(projId);
                BudgetHeader__c bHeader = ba.BudgetResource__r.BudgetHeader__r;
                if (bHeader != null) {
                    String bStatus = bHeader.status__c;
                    Boolean origBudget = bHeader.OriginalBudget__c;
                    
                    if (bStatus == 'Forecast') {
                        if (ba.OverrideTotalCost__c > 0) {
                            if (PLReportCategory == ODC_Exps) {
                                snapshot.CostsODCEXPSForecast__c = ba.OverrideTotalCost__c;
                            }
                            else if (PLReportCategory == ODC_Subs) {
                                snapshot.CostsODCSUBSForecast__c = ba.OverrideTotalCost__c;
                            }
                            else if (PLReportCategory == ODC_Contingency) {
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
                            if (PLReportCategory == ODC_Exps) {
                                snapshot.CostsODCEXPSForecast__c = ba.TotalComputedCost__c;
                            }
                            else if (PLReportCategory == ODC_Subs) {
                                snapshot.CostsODCSUBSForecast__c = ba.TotalComputedCost__c;
                            }
                            else if (PLReportCategory == ODC_Contingency) {
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
                    else if (origBudget) {
                        if (PLReportCategory == ODC_Exps) {
                            snapshot.CostsODCEXPSBudgetOriginal__c = ba.TotalComputedCost__c;  
                        }
                        else if (PLReportCategory == ODC_Subs) {
                            snapshot.CostsODCSUBSBudgetOriginal__c = ba.TotalComputedCost__c;
                        }
                        else if (PLReportCategory == ODC_Contingency) {
                            snapshot.ContingencyBudgetOriginal__c = ba.TotalComputedCost__c;
                        }
                        else if (PLReportCategory == 'Labor') {
                            snapshot.LaborBudgetOriginal__c = ba.TotalComputedCost__c;
                        }
                        else if (PLReportCategory == 'Fringe') {
                            snapshot.FringeBudgetOriginal__c = ba.TotalComputedCost__c;
                        }
                        else if (PLReportCategory == 'Overhead') {
                            snapshot.OverheadBudgetOriginal__c = ba.TotalComputedCost__c;
                        }
                    }
                    else if (bStatus == 'Approved'){
                        
                        if (PLReportCategory == ODC_Exps) {
                            snapshot.CostsODCEXPSBudget__c = ba.TotalComputedCost__c;
                        }
                        else if (PLReportCategory == ODC_Subs) {
                            snapshot.CostsODCSUBSBudget__c = ba.TotalComputedCost__c;
                        }
                        else if (PLReportCategory == ODC_Contingency) {
                            snapshot.ContingencyBudget__c = ba.TotalComputedCost__c;
                        }
                        else if (PLReportCategory == 'Labor') {
                            snapshot.LaborBudget__c = ba.TotalComputedCost__c;
                        }
                        else if (PLReportCategory == 'Fringe') {
                            snapshot.FringeBudget__c = ba.TotalComputedCost__c;
                        }
                        else if (PLReportCategory == 'Overhead') {
                            snapshot.OverheadBudget__c = ba.TotalComputedCost__c;
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

    /* Total number of hours in current forecast budget (by Budget Assignment: ExpenditureResourceType=Lab; 
       use Quantity; filter where Budget Header: Status  = Forecast)
    */
    @TestVisible private Map<Id, ProjectSnapshot__c> getOriginalOrForecastBudgetHoursMap(List<Id> projectIds,
            Map<Id, ProjectSnapshot__c> projectIdToSnapshotMap) {
        try {
            List<AggregateResult> results = 
                [SELECT SUM(Quantity__c) Hours, ProjectTask__r.pse__Project__r.Id projectId
                 FROM BudgetAssignment__c
                 WHERE BudgetResource__r.ExpenditureResourceType__c = 'LAB'
                 AND (BudgetResource__r.BudgetHeader__r.OriginalBudget__c=true
                 OR BudgetResource__r.BudgetHeader__r.Status__c = 'Forecast' 
                 OR BudgetResource__r.BudgetHeader__r.Status__c = 'Approved') 
                 AND ProjectTask__r.pse__Project__r.Id IN : projectIds
                 GROUP BY ProjectTask__r.pse__Project__r.Id];

            for (AggregateResult ar : results)
            {
                Decimal hours = (Decimal)ar.get('Hours');
                if (hours != null) {
                    Id projId = (Id) ar.get('projectId');
                    ProjectSnapshot__c snapshot = projectIdToSnapshotMap.get(projId);
                    snapshot.HoursBudgetOriginal__c = hours;
                    snapshot.HoursForecast__c = hours;
                    snapshot.HoursBudget__c = hours;
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
        List<String> prevFiscalMonthList = new List<String>();
        for (ProjectSnapshot__c ps : projectIdToSnapshotMap.values()) {
            prevFiscalMonthList.add(ps.SnapshotPreviousFiscalMonth__c);
        }

        if (prevFiscalMonthList.size() > 0) {
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
    
    private Decimal getLaborMult(Decimal revenue, Decimal nonLabor, Decimal labor)
    {
        Decimal laborMultValue = 0;
        System.debug(System.LoggingLevel.WARN, '___ START getLaborMult(...) ');
        try {
            System.debug(System.LoggingLevel.WARN, '___getLaborMult: revenue='+revenue+', nonLabor='+nonLabor+', labor='+labor);
            if (labor == 0) {
                return 0;
            }
            laborMultValue = (revenue - nonLabor)/labor;
        }
        catch(Exception e) {
            System.Debug(System.LoggingLevel.WARN, '___getLaborMult: '+e.getStackTraceString());
        }
        return laborMultValue;
    }
    
    /*private Decimal getNetService(Decimal revenue, Decimal nonLabor)
    {
        System.debug(System.LoggingLevel.WARN, '___getNetService: revenue='+revenue+', nonLabor='+nonLabor);
        if (revenue != null && nonLabor != null) {
            return revenue - nonLabor;
        }
        else {
            return 0;
        }
    }
    
    private Decimal getNMGR(Decimal netMargin, Decimal revenue)
    {
        if (revenue == 0)
            return 0;
        return (netMargin/revenue) * 100;
    }   
    
    private Decimal getNMNSRC(Decimal netMargin, Decimal netService)
    {
        if (netService == 0)
            return 0;
        return (netMargin/netService) * 100;        
    }*/
}