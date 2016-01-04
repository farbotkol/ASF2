public class ECO_BudgetEACService {
    public class EacException extends Exception {}

    private static BudgetHeader__c oBudgetHeader;

    private static Map<Id, BudgetTask__c> mBudgetTask;

    private static final String uniqueDelim = ':-:';
    private static Map<String, BudgetResource__c> mapResourceByPTMId;
    private static Map<Id, BudgetResource__c> mapResourceBySubId;
    private static Map<String, BudgetResource__c> mapResourceByContingencyName;
    private static Map<String,BudgetResource__c> mapResourceByExpType;
    private static Map<String, List<BudgetAssignment__c>> mapAssignmentsByPTMId;
    private static Map<Id, List<BudgetAssignment__c>> mapAssignmentsBySubId;
    private static Map<String, List<BudgetAssignment__c>> mapAssignmentsByContingencyName;
    private static Map<String, List<BudgetAssignment__c>> mapAssignmentsByExpType;

    private static Map<String, BudgetAssignment__c> mapAssignmentByUniqueId;
    private static Map<String, BudgetResource__c> mapResourcesByPersonId;

    private static BudgetAssignment__c addExpBA(String expType, Id projectTaskId) {
        Id budgetTaskId = mBudgetTask.get(projectTaskId).Id;
        BudgetResource__c budgetResource = mapResourceByExpType.get(expType);

        if (budgetResource == null) {
            budgetResource = new BudgetResource__c();
            budgetResource.BudgetHeader__c = oBudgetHeader.id;
            budgetResource.OverrideRatesOnLines__c = true;
            budgetResource.ResourceType__c = 'ODC/FEE';
            budgetResource.MarginType__c = 'Percent';
            budgetResource.OverrideFringeMultiplier__c = 0.0;
            budgetResource.OverrideOverheadMultiplier__c = 0.0;
            budgetResource.OverrideFringeMultiplierField__c = 0.0;
            budgetResource.OverrideOverheadMultiplierField__c = 0.0;

            budgetResource.ExpenditureType__c = expType;
            // TODO: ???
            /*      newBudgetColumn.OverrideUplift__c = markupPercentage;
                            newBudgetColumn.ResourceName__c = jobName;
                            
                            newBudgetColumn.CostCalcType__c = unitType;
                            newBudgetColumn.OverrideRawCost__c = unitCost;
                            newBudgetColumn.OverrideFringeMultiplier__c = 0.0;
                            newBudgetColumn.OverrideOverheadMultiplier__c = 0.0;

                            newBudgetColumn.isBillable__c = isBillable;
                            newBudgetColumn.isEstimated__c = isEstimated;
                            newBudgetColumn.isQuoted__c = isQuoted;
                            */
            budgetResource.ResourceName__c = expType;

            mapResourceByExpType.put(expType, budgetResource);
        }

        List<BudgetAssignment__c> oAssignments = mapAssignmentsByExpType.get(expType);

        if (oAssignments == null) {
            oAssignments = new List<BudgetAssignment__c> ();
            mapAssignmentsByExpType.put(expType, oAssignments);
        }

        String uniqueId = expType + uniqueDelim + projectTaskId;
        BudgetAssignment__c ba = mapAssignmentByUniqueId.get(uniqueId);
        if (ba == null) {
            ba = new BudgetAssignment__c();
            ba.EACApprovedTotalCost__c = 0;
            ba.EACForecastTotalCost__c = 0;
            mapAssignmentByUniqueId.put(uniqueId, ba);
            oAssignments.add(ba); // make sure we only the BA once
        }

        ba.BudgetTask__c = budgetTaskId;

        return ba;
    }

    private static BudgetAssignment__c addSubBA(Id subId, Id projectTaskId) {
        return addSubBA(subId, projectTaskId, null);
    }

    private static BudgetAssignment__c addSubBA(Id subId, Id projectTaskId, String vendorId) {
        Id budgetTaskId = mBudgetTask.get(projectTaskId).Id;
        BudgetResource__c budgetResource = mapResourceBySubId.get(subId);

        if (budgetResource == null) {
            budgetResource = new BudgetResource__c();
            budgetResource.BudgetHeader__c = oBudgetHeader.id;
            budgetResource.OverrideRatesOnLines__c = true;
            budgetResource.ResourceType__c = 'Subcontractor';
            // TODO: ???
            // budgetResource.OverrideBillRate__c = theProject.DefaultBillRate__c;
            // budgetResource.OverrideUplift__c = theProject.DefaultUpliftLabor__c;
            budgetResource.JobName__c = null;

            budgetResource.VendorSite__c  = subId;
            mapResourceBySubId.put(subId, budgetResource);
        }

        List<BudgetAssignment__c> oAssignments = mapAssignmentsBySubId.get(subId);

        if (oAssignments == null) {
            oAssignments = new List<BudgetAssignment__c> ();
            mapAssignmentsBySubId.put(subID, oAssignments);
        }

        String uniqueId = subId + uniqueDelim + projectTaskId;
        BudgetAssignment__c ba = mapAssignmentByUniqueId.get(uniqueId);
        if (ba == null) {
            ba = new BudgetAssignment__c();
            ba.EACApprovedTotalCost__c = 0;
            ba.EACForecastTotalCost__c = 0;
            mapAssignmentByUniqueId.put(uniqueId, ba);
            oAssignments.add(ba); // make sure we only the BA once
        }

        ba.BudgetTask__c = budgetTaskId;

        return ba;
    }

    private static BudgetAssignment__c addLaborBA(String ptmId, Id projectTaskId, Boolean isGeneric) {
        Id budgetTaskId = mBudgetTask.get(projectTaskId).Id;

        BudgetResource__c budgetResource;

        budgetResource = mapResourceByPTMId.get(ptmId);
        if (budgetResource == null) {
            budgetResource = new BudgetResource__c();
            budgetResource.BudgetHeader__c = oBudgetHeader.id;
            budgetResource.OverrideRatesOnLines__c = true;
            budgetResource.ResourceType__c = 'Labor/Person';
            // TODO: ???
            // budgetResource.OverrideBillRate__c = theProject.DefaultBillRate__c;
            // budgetResource.OverrideUplift__c = theProject.DefaultUpliftLabor__c;
            budgetResource.ProjectTeamMember__c = ptmId;

            mapResourceByPTMId.put(ptmId, budgetResource);
        }

        List<BudgetAssignment__c> oAssignments = mapAssignmentsByPTMId.get(ptmId);

        if (oAssignments == null) {
            oAssignments = new List<BudgetAssignment__c> ();
            mapAssignmentsByPTMId.put(ptmID, oAssignments);
        }

        String uniqueId = ptmId + '' + projectTaskId;
        BudgetAssignment__c ba = mapAssignmentByUniqueId.get(uniqueId);
        if (ba == null) {
            ba = new BudgetAssignment__c();
            ba.EACApprovedTotalCost__c = 0;
            ba.EACForecastTotalCost__c = 0;
            ba.EACApprovedQuantity__c = 0;
            ba.EACForecastQuantity__c = 0;
            mapAssignmentByUniqueId.put(uniqueId, ba);
            oAssignments.add(ba); // make sure we only the BA once
        }

        ba.BudgetTask__c = budgetTaskId;



        return ba;
    }

    private static List<String> oracleSubsName;
    private static List<String> oracleLabNames;
    private static List<String> oracleExpNames;

    private static void createExpTypes() {
        oracleSubsName = new List<String>();
        oracleLabNames = new List<String>();
        oracleExpNames = new List<String>();

        Map<String, Oracle_Expenditure_Types__c> typesMap = Oracle_Expenditure_Types__c.getAll();
        for (Oracle_Expenditure_Types__c expType : typesMap.values()) {
            String rollupType = expType.Rollup_Type_1__c;
            String name = expType.Expenditure_Type__c;

            if (rollupType == 'SUBS') {
                oracleSubsName.add(name);
            } else if (rollupType == 'LAB') {
                oracleLabNames.add(name);
            } else if (rollupType == 'EXPS') {
                oracleExpNames.add(name);
            }
        }
    }

    public static void createProjectTasks(Id sProjectId) {
        oBudgetHeader = new BudgetHeader__c();
        oBudgetHeader.RecordTypeId = ECO_Utils_Meta.getRecordTypeId(BudgetHeader__c.sObjectType, 'EAC');
        oBudgetHeader.Project__c = sProjectId;
        oBudgetHeader.Status__c = ECO_DTO_BudgetHeader.STATUS_ESTIMATE;

        list<BudgetHeader__c> lBudgetHeader = new list<BudgetHeader__c>([SELECT Id FROM BudgetHeader__c WHERE Project__c = :sProjectId]);

        oBudgetHeader.BudgetName__c = 'EAC ' + lBudgetHeader.size();
        insert oBudgetHeader;
        mBudgetTask = new Map<Id, BudgetTask__c>();

        for (pse__Project_Task__c oProjectTask : [SELECT Id, Name
                FROM pse__Project_Task__c
                WHERE pse__Project__c = :sProjectId]) {

            BudgetTask__c oBudgetTask = new BudgetTask__c();
            oBudgetTask.ProjectTask__c = oProjectTask.Id;
            oBudgetTask.BudgetHeader__c = oBudgetHeader.Id;
            oBudgetTask.TaskName__c = oProjectTask.Name;
            mBudgetTask.put(oProjectTask.Id, oBudgetTask);
        }


        if (!mBudgetTask.isEmpty()) {
            insert mBudgetTask.values();
        }

    }

    public static Id createGenericECO(Id sProjectId) {
        ECO_TriggerSettings.overrideTriggerSetting('PT_CalcEV', false);
        createExpTypes();

        mapAssignmentByUniqueId = new Map <String, BudgetAssignment__c> ();
        mapResourceByPTMId = new Map <String, BudgetResource__c> ();
        mapResourceBySubId = new Map <Id, BudgetResource__c> ();
        mapResourceByContingencyName = new Map <String, BudgetResource__c> ();
        mapResourceByExpType = new Map <String, BudgetResource__c> ();
        // Stores BAs so we can set the BudgetResource__c Id after the records are inserted
        mapAssignmentsByPTMId = new Map <String, List<BudgetAssignment__c>> ();
        mapAssignmentsBySubId = new Map <Id, List<BudgetAssignment__c>> ();
        mapAssignmentsByContingencyName = new Map <String, List<BudgetAssignment__c>> ();
        mapAssignmentsByExpType = new Map <String, List<BudgetAssignment__c>> ();

        mapAssignmentByUniqueId = new Map <String, BudgetAssignment__c> ();

        mapResourcesByPersonId = new Map<String, BudgetResource__c>();

        BudgetResource__c brLabor = new BudgetResource__c();
        List<BudgetAssignment__c> baLabors = new List<BudgetAssignment__c>();
        BudgetResource__c brSub = new BudgetResource__c();
        List< BudgetAssignment__c> baSubs = new List<BudgetAssignment__c>();
        BudgetResource__c brContingency = new BudgetResource__c();
        BudgetAssignment__c baContingency = new BudgetAssignment__c();

        createProjectTasks(sProjectId);

        AggregateResult[] arLabor = [Select Sum(Quantity__c) Quantity__c, Sum(FullyBurdenedCostNumber__c) FullyBurdenedCost__c, BudgetTask__r.ProjectTask__c, BudgetTask__r.BudgetHeader__r.Status__c
                                     From BudgetAssignment__c
                                     Where BudgetTask__r.ProjectTask__r.pse__Project__c = :sProjectId AND ResourceType__c = 'Labor/Person' AND
                                             (BudgetTask__r.BudgetHeader__r.Status__c = 'Forecast' OR BudgetTask__r.BudgetHeader__r.Status__c = 'Approved')
                                             GROUP BY BudgetTask__r.ProjectTask__c, BudgetTask__r.BudgetHeader__r.Status__c
                                    ];

        AggregateResult[] arSubs = [Select Sum(FullyBurdenedCostNumber__c) OverrideTotalCost__c, BudgetTask__r.ProjectTask__c, BudgetResource__r.VendorSite__c, BudgetTask__r.BudgetHeader__r.Status__c
                                    From BudgetAssignment__c
                                    Where BudgetTask__r.ProjectTask__r.pse__Project__c = :sProjectId AND ResourceType__c = 'Subcontractor' AND
                                            (BudgetTask__r.BudgetHeader__r.Status__c = 'Forecast' OR BudgetTask__r.BudgetHeader__r.Status__c = 'Approved')
                                            GROUP BY BudgetTask__r.ProjectTask__c, BudgetResource__r.VendorSite__c, BudgetTask__r.BudgetHeader__r.Status__c
                                   ];

        AggregateResult[] arContingency = [Select Sum(FullyBurdenedCostNumber__c) OverrideTotalCost__c, BudgetTask__r.ProjectTask__c, BudgetResource__r.JobName__c, BudgetTask__r.BudgetHeader__r.Status__c
                                           From BudgetAssignment__c
                                           Where BudgetTask__r.ProjectTask__r.pse__Project__c = :sProjectId AND ResourceType__c = 'Contingency' AND
                                                   (BudgetTask__r.BudgetHeader__r.Status__c = 'Forecast' OR BudgetTask__r.BudgetHeader__r.Status__c = 'Approved')
                                                   GROUP BY BudgetTask__r.ProjectTask__c, BudgetResource__r.JobName__c, BudgetTask__r.BudgetHeader__r.Status__c
                                          ];

        AggregateResult[] arLaborActuals = [SELECT SUM(Quantity__c) Quantity__c, SUM(ProjectFunctionalBurdenedCost__c) totalRawCost, ProjectTask__c
                                            FROM ExpendItem__c Where Project__c = :sProjectId AND ExpenditureType__c IN :oracleLabNames
                                                    GROUP BY ProjectTask__c
                                           ];

        AggregateResult[] arSubActuals = [SELECT SUM(Quantity__c) Quantity__c, SUM(ProjectFunctionalBurdenedCost__c) totalRawCost, ProjectTask__c
                                          FROM ExpendItem__c Where Project__c = :sProjectId AND ExpenditureType__c IN :oracleSubsName
                                                  GROUP BY ProjectTask__c
                                         ];



        for (AggregateResult ar : arLaborActuals) {
            Decimal quantity = (Decimal)ar.get('Quantity__c');
            Decimal totalRawCost = (Decimal)ar.get('totalRawCost');
            Id projectTaskId = (Id)ar.get('ProjectTask__c');

            BudgetAssignment__c ba = addLaborBA(null, projectTaskId, true);

            BudgetResource__c budgetResource = mapResourceByPTMId.get(null);

            if (quantity != 0 && quantity != null) {
                budgetResource.OverrideRawCost__c = totalRawCost / quantity;
            }

            ba.EACActualQuantity__c = quantity;
            ba.EACActualCost__c = totalRawCost;
        }

        for (AggregateResult ar : arLabor) {
            Decimal quantity = (Decimal)ar.get('Quantity__c');
            Id projectTaskId = (Id)ar.get('ProjectTask__c');

            String status = (String)ar.get('Status__c');
            Decimal totalCost = (Decimal)ar.get('FullyBurdenedCost__c');
            totalCost = totalCost == null ? 0 : totalCost;

            BudgetAssignment__c ba = addLaborBA(null, projectTaskId, true);

            if (status == 'Approved') {
                ba.EACApprovedQuantity__c = quantity;
                ba.EACApprovedTotalCost__c = totalCost;
            } else if (status == 'Forecast') {
                ba.EACForecastQuantity__c = quantity;
                ba.EACForecastTotalCost__c = totalCost;
            }
        }

        for (AggregateResult ar : arSubActuals) {
            Id projectTaskId = (Id)ar.get('ProjectTask__c');
            // String vendorId = (String)ar.get('VendorId__c');

            if (projectTaskId == null) continue;


            Decimal totalRawCost = (Decimal)ar.get('totalRawCost');

            BudgetAssignment__c ba = addSubBA(null, projectTaskId);

            ba.EACActualCost__c = totalRawCost;
        }

        for (AggregateResult ar : arSubs) {
            Id projectTaskId = (Id)ar.get('ProjectTask__c');
            Id subId = (Id)ar.get('VendorSite__c');

            if ( projectTaskId == null) continue;
            String status = (String)ar.get('Status__c');
            Decimal quantity = (Decimal)ar.get('OverrideTotalCost__c');


            BudgetAssignment__c ba = addSubBA(null, projectTaskId);

            if (status == 'Approved') {
                ba.EACApprovedTotalCost__c  = quantity;
            } else if (status == 'Forecast') {
                ba.EACForecastTotalCost__c  = quantity;
            }

        }

        // Insert All budgetResources
        List<BudgetResource__c> allBudgets = new List<BudgetResource__c>();
        allBudgets.addAll(mapResourceByPTMId.values());
        allBudgets.addAll(mapResourceByContingencyName.values());
        allBudgets.addAll(mapResourceBySubId.values());
        allBudgets.addAll(mapResourceByExpType.values());
        insert allBudgets;

        //insert mapResourceBySubId.values();
        //insert mapResourceByContingencyName.values();

        for (String contName : mapResourceByContingencyName.keySet()) {
            Id brId = mapResourceByContingencyName.get(contName).Id;

            for (BudgetAssignment__c ba : mapAssignmentsByContingencyName.get(contName)) {
                ba.BudgetResource__c = brId;
            }
        }

        for (String expType : mapResourceByExpType.keySet()) {
            Id brId = mapResourceByExpType.get(expType).Id;

            for (BudgetAssignment__c ba : mapAssignmentsByExpType.get(expType)) {
                ba.BudgetResource__c = brId;
            }
        }

        for (Id subId : mapResourceBySubId.keySet()) {
            Id brId = mapResourceBySubId.get(subId).Id;

            for (BudgetAssignment__c ba : mapAssignmentsBySubId.get(subId)) {
                ba.BudgetResource__c = brId;
            }
        }

        for (String ptmId : mapResourceByPTMId.keySet()) {
            Id brId = mapResourceByPTMId.get(ptmId).Id;

            for (BudgetAssignment__c ba : mapAssignmentsByPTMId.get(ptmId)) {
                ba.BudgetResource__c = brId;
            }
        }

        for (BudgetAssignment__c ba : mapAssignmentByUniqueId.values()) {
            ba.EACForecastTotalCost__c = ifNull(ba.EACApprovedTotalCost__c) + ifNull(ba.EACForecastTotalCost__c);
            ba.EACForecastQuantity__c = ifNull(ba.EACApprovedQuantity__c) + ifNull(ba.EACForecastQuantity__c);
        }

        // Insert All Budget Asssignments
        insert mapAssignmentByUniqueId.values();

        ECO_TriggerSettings.overrideTriggerSetting('PT_CalcEV', true);
        return oBudgetHeader.Id;
    }


// Return Id of new budget header created
    public static Id createInitECO(Id sProjectId) {
        ECO_TriggerSettings.overrideTriggerSetting('PT_CalcEV', false);
        createExpTypes();

        mapResourceByPTMId = new Map <String, BudgetResource__c> ();
        mapResourceBySubId = new Map <Id, BudgetResource__c> ();
        mapResourceByContingencyName = new Map <String, BudgetResource__c> ();
        mapResourceByExpType = new Map <String, BudgetResource__c> ();
        // Stores BAs so we can set the BudgetResource__c Id after the records are inserted
        mapAssignmentsByPTMId = new Map <String, List<BudgetAssignment__c>> ();
        mapAssignmentsBySubId = new Map <Id, List<BudgetAssignment__c>> ();
        mapAssignmentsByContingencyName = new Map <String, List<BudgetAssignment__c>> ();
        mapAssignmentsByExpType = new Map <String, List<BudgetAssignment__c>> ();

        mapAssignmentByUniqueId = new Map <String, BudgetAssignment__c> ();

        mapResourcesByPersonId = new Map<String, BudgetResource__c>();

        Map<String, ProjectTeamMember__c> mapPTMByPersonId = new Map<String, ProjectTeamMember__c> ();
        Map<String, VendorSite__c> mapVSbyVendorId = new Map<String, VendorSite__c> ();


        Set<String> PersonIdsInBudget = new Set<String>();
        Set<Id> VendorIdsInBudget = new Set<Id>();


        createProjectTasks(sProjectId);
        // list<RecordType> lstRT = [select id from recordtype where sObjectType='ChangeManager__c' and developername='InternalChange'];

        // TODO: Make sure assumption that every Account and User has an associated oracle id is true. if not we should account for it in the code.
        // Link Person Ids from PTMs
        for (ProjectTeamMember__c ptm : [Select Id, OraclePersonId__c, Project__c From ProjectTeamMember__c Where Project__c = :sProjectId Order By Is_Active__c]) {
            // If there's an active role that will take precedent over in_active ptms
            mapPTMByPersonId.put(ptm.OraclePersonId__c, ptm);
        }

        // Link Vendor Ids from VS
        for (VendorSite__c vs : [Select Id, Site__r.Account__r.OracleVendorID__c, Project__c From VendorSite__c Where Project__c = :sProjectId]) {
            mapVSbyVendorId.put(vs.Site__r.Account__r.OracleVendorID__c, vs);
        }

        AggregateResult[] arTotals = [Select Sum(Quantity__c) Quantity__c, Sum(FullyBurdenedCostNumber__c) FullyBurdenedCost__c, BudgetTask__r.ProjectTask__c,
                                      BudgetResource__r.ProjectTeamMember__r.Contact__r.Person_ID__c, BudgetTask__r.BudgetHeader__r.Status__c
                                      From BudgetAssignment__c
                                      Where BudgetTask__r.ProjectTask__r.pse__Project__c = :sProjectId AND ResourceType__c = 'Labor/Person' AND
                                              (BudgetTask__r.BudgetHeader__r.Status__c = 'Forecast' OR BudgetTask__r.BudgetHeader__r.Status__c = 'Approved')
                                              GROUP BY BudgetTask__r.ProjectTask__c, BudgetResource__r.ProjectTeamMember__r.Contact__r.Person_ID__c, BudgetTask__r.BudgetHeader__r.Status__c
                                     ];

        AggregateResult[] arSubs = [Select Sum(FullyBurdenedCostNumber__c) OverrideTotalCost__c, BudgetTask__r.ProjectTask__c, BudgetResource__r.VendorSite__c, BudgetTask__r.BudgetHeader__r.Status__c
                                    From BudgetAssignment__c
                                    Where BudgetTask__r.ProjectTask__r.pse__Project__c = :sProjectId AND ResourceType__c = 'Subcontractor' AND
                                            (BudgetTask__r.BudgetHeader__r.Status__c = 'Forecast' OR BudgetTask__r.BudgetHeader__r.Status__c = 'Approved')
                                            GROUP BY BudgetTask__r.ProjectTask__c, BudgetResource__r.VendorSite__c, BudgetTask__r.BudgetHeader__r.Status__c
                                   ];

        AggregateResult[] arContingency = [Select Sum(FullyBurdenedCostNumber__c) OverrideTotalCost__c, BudgetTask__r.ProjectTask__c, BudgetResource__r.JobName__c, BudgetTask__r.BudgetHeader__r.Status__c
                                           From BudgetAssignment__c
                                           Where BudgetTask__r.ProjectTask__r.pse__Project__c = :sProjectId AND ResourceType__c = 'Contingency' AND
                                                   (BudgetTask__r.BudgetHeader__r.Status__c = 'Forecast' OR BudgetTask__r.BudgetHeader__r.Status__c = 'Approved')
                                                   GROUP BY BudgetTask__r.ProjectTask__c, BudgetResource__r.JobName__c, BudgetTask__r.BudgetHeader__r.Status__c
                                          ];

        AggregateResult[] arExp = [Select Sum(FullyBurdenedCostNumber__c) OverrideTotalCost__c, BudgetTask__r.ProjectTask__c, BudgetResource__r.ExpenditureType__c, BudgetTask__r.BudgetHeader__r.Status__c
                                   From BudgetAssignment__c
                                   Where BudgetTask__r.ProjectTask__r.pse__Project__c = :sProjectId AND ResourceType__c = 'ODC/FEE' AND
                                           (BudgetTask__r.BudgetHeader__r.Status__c = 'Forecast' OR BudgetTask__r.BudgetHeader__r.Status__c = 'Approved')
                                           GROUP BY BudgetTask__r.ProjectTask__c, BudgetResource__r.ExpenditureType__c, BudgetTask__r.BudgetHeader__r.Status__c];

        AggregateResult[] arLaborActuals = [SELECT PersonId__c, SUM(Quantity__c) Quantity__c, SUM(ProjectFunctionalBurdenedCost__c) totalRawCost, ProjectTask__c, VendorId__c
                                            FROM ExpendItem__c Where Project__c = :sProjectId AND ExpenditureType__c IN :oracleLabNames
                                                    GROUP BY ProjectTask__c, VendorId__c, PersonId__c
                                           ];

        AggregateResult[] arSubActuals = [SELECT PersonId__c, SUM(Quantity__c) Quantity__c, SUM(ProjectFunctionalBurdenedCost__c) totalRawCost, ProjectTask__c, VendorId__c
                                          FROM ExpendItem__c Where Project__c = :sProjectId AND ExpenditureType__c IN :oracleSubsName
                                                  GROUP BY ProjectTask__c, VendorId__c, PersonId__c
                                         ];

        AggregateResult[] arExpActuals = [SELECT SUM(Quantity__c) Quantity__c, SUM(ProjectFunctionalBurdenedCost__c) totalRawCost, ProjectTask__c, ExpenditureType__c
                                          FROM ExpendItem__c Where Project__c = :sProjectId AND ExpenditureType__c IN :oracleExpNames
                                                  GROUP BY ProjectTask__c, ExpenditureType__c
                                         ];

        for (AggregateResult ar : arSubs) {
            Id subId = (Id)ar.get('VendorSite__c');

            if (subId != null) VendorIdsInBudget.add(subId);
        }

        Set<String> vendorIdsToAdd = new Set<String>();

        // List<ProjectTeamMember__c> vendorSitesToAdd = new List<ProjectTeamMember__c>();

        for (AggregateResult ar : arSubActuals) {
            String vendorId = (String)ar.get('VendorId__c');

            if (vendorId == null) {
                throw new EacException('VendorId is null on Expenditure Item');
            }

            VendorSite__c vs = mapVSbyVendorId.get(vendorId);

            if (vs == null || !VendorIdsInBudget.contains(vs.Id)) {
                vendorIdsToAdd.add(vendorId);
            }
        }

        if (!vendorIdsToAdd.isEmpty()) {
            // create map of sites to vendor Id
            // TODO: Implement adding vendor site

            //throw new EacException('Vendor Site found on expenditure item not in budget');
            //ProjectRole__c prl = [select id from ProjectRole__c where Name = 'Task Manager'];
            List<VendorSite__c> vendorSitesToAdd = new List<VendorSite__c>();

            for (Account acc : [Select Id, OracleVendorID__c, (Select Id From Sites__r Limit 1) From Account Where OracleVendorID__c in :vendorIdsToAdd]) {
                VendorSite__c vendorSite = new VendorSite__c();
                vendorSite.Project__c = sProjectId;
                vendorSite.Site__c = acc.Sites__r[0].Id;
                vendorSite.Type__c = 'Sub';

                vendorSitesToAdd.add(vendorSite);
                mapVSbyVendorId.put(acc.OracleVendorID__c, vendorSite);
            }

            insert vendorSitesToAdd;
        }


        for (AggregateResult ar : arSubActuals) {
            Id projectTaskId = (Id)ar.get('ProjectTask__c');
            String vendorId = (String)ar.get('VendorId__c');

            if (vendorId == 'null' || projectTaskId == null) continue;

            VendorSite__c vs = mapVSByVendorId.get(vendorId);

            Id subId = vs == null ? null : vs.Id;

            Decimal totalRawCost = (Decimal)ar.get('totalRawCost');

            BudgetAssignment__c ba = addSubBA(subId, projectTaskId);

            ba.EACActualCost__c = totalRawCost;
        }


        for (AggregateResult ar : arSubs) {
            Id projectTaskId = (Id)ar.get('ProjectTask__c');
            Id subId = (Id)ar.get('VendorSite__c');

            if (subId == null || projectTaskId == null) continue;
            String status = (String)ar.get('Status__c');
            Decimal quantity = (Decimal)ar.get('OverrideTotalCost__c');


            BudgetAssignment__c ba = addSubBA(subId, projectTaskId);


            if (status == 'Approved') {
                ba.EACApprovedTotalCost__c  = quantity;
            } else if (status == 'Forecast') {
                ba.EACForecastTotalCost__c  = quantity;
            }

        }

        for (AggregateResult ar : arExpActuals) {
            Id projectTaskId = (Id)ar.get('ProjectTask__c');
            String expType = (String)ar.get('ExpenditureType__c');

            if (expType == 'null' || projectTaskId == null) continue;

            Decimal totalRawCost = (Decimal)ar.get('totalRawCost');

            BudgetAssignment__c ba = addExpBA(expType, projectTaskId);

            ba.EACActualCost__c = totalRawCost;
        }

        for (AggregateResult ar : arExp) {
            Id projectTaskId = (Id)ar.get('ProjectTask__c');
            String expType = (String)ar.get('ExpenditureType__c');

            if (expType == null || projectTaskId == null) continue;
            String status = (String)ar.get('Status__c');
            Decimal totalRawCost = (Decimal)ar.get('OverrideTotalCost__c');

            BudgetAssignment__c ba = addExpBA(expType, projectTaskId);

            if (status == 'Approved') {
                ba.EACApprovedTotalCost__c  = totalRawCost;
            } else if (status == 'Forecast') {
                ba.EACForecastTotalCost__c  = totalRawCost;
            }
        }

        for (AggregateResult ar : arContingency) {
            Id projectTaskId = (Id)ar.get('ProjectTask__c');
            String contName = (String)ar.get('JobName__c');

            if (contName == null || projectTaskId == null) continue;
            String status = (String)ar.get('Status__c');
            Decimal quantity = (Decimal)ar.get('OverrideTotalCost__c');
            Id budgetTaskId = mBudgetTask.get(projectTaskId).Id;
            BudgetResource__c budgetResource = mapResourceByContingencyName.get(contName);

            if (budgetResource == null) {
                budgetResource = new BudgetResource__c();
                budgetResource.BudgetHeader__c = oBudgetHeader.id;
                budgetResource.OverrideRatesOnLines__c = true;
                budgetResource.ResourceType__c = 'Contingency';
                // TODO: ???
                // budgetResource.OverrideBillRate__c = theProject.DefaultBillRate__c;
                // budgetResource.OverrideUplift__c = theProject.DefaultUpliftLabor__c;
                budgetResource.JobName__c = contName;

                mapResourceByContingencyName.put(contName, budgetResource);
            }

            List<BudgetAssignment__c> oAssignments = mapAssignmentsByContingencyName.get(contName);

            if (oAssignments == null) {
                oAssignments = new List<BudgetAssignment__c> ();
                mapAssignmentsByContingencyName.put(contName, oAssignments);
            }

            String uniqueId = contName + uniqueDelim + projectTaskId;
            BudgetAssignment__c ba = mapAssignmentByUniqueId.get(uniqueId);
            if (ba == null) {
                ba = new BudgetAssignment__c();
                ba.EACApprovedTotalCost__c = 0;
                ba.EACForecastTotalCost__c = 0;
                mapAssignmentByUniqueId.put(uniqueId, ba);
                oAssignments.add(ba); // make sure we only the BA once
            }

            ba.BudgetTask__c = budgetTaskId;
            if (status == 'Approved') {
                ba.EACApprovedTotalCost__c  = quantity;
            } else if (status == 'Forecast') {
                ba.EACForecastTotalCost__c  = quantity;
            }

        }



        for (AggregateResult ar : arTotals) {
            String personId = (String)ar.get('PersonId__c');

            if (personId != null) PersonIdsInBudget.add(personId);
        }

        Set<String> personIdsToAdd = new Set<String>();

        List<ProjectTeamMember__c> ptmsToAdd = new List<ProjectTeamMember__c>();

        for (AggregateResult ar : arLaborActuals) {
            String personId = (String)ar.get('PersonId__c');

            if (personId == null) {
                throw new EacException('PersonId is null on Expenditure Item');
            }

            ProjectTeamMember__c ptm = mapPTMByPersonId.get(personId);

            if (ptm == null) {
                mapPTMByPersonId.put(personId, null);
                personIdsToAdd.add(personId);
            } else if (!PersonIdsInBudget.contains(personId)) {
                personIdsToAdd.add(personId);
            }
        }

        if (!personIdsToAdd.isEmpty()) {
            ProjectRole__c prl = [select id from ProjectRole__c where Name = 'Other'];

            for (Contact con : [Select Id, Person_ID__c From Contact Where Person_ID__c in :personIdsToAdd]) {
                ProjectTeamMember__c ptm = new ProjectTeamMember__c();
                ptm.contact__c = con.Id;
                ptm.project__c = sProjectId;
                ptm.ProjectRole__c = prl.id;

                ptmsToAdd.add(ptm);
                mapPTMByPersonId.put(con.Person_ID__c, ptm);
            }

            insert ptmsToAdd;
        }

        for (AggregateResult ar : arLaborActuals) {
            String personId = (String)ar.get('PersonId__c');
            Decimal quantity = (Decimal)ar.get('Quantity__c');
            Decimal totalRawCost = (Decimal)ar.get('totalRawCost');
            Id projectTaskId = (Id)ar.get('ProjectTask__c');
            Id budgetTaskId = mBudgetTask.get(projectTaskId).Id;
            ProjectTeamMember__c ptm =  mapPTMByPersonId.get(personId);
            BudgetResource__c budgetResource;
            String ptmId;

            if (ptm != null) {
                ptmId = ptm.Id;
            } else {
                ptmId = personId;
            }

            budgetResource = mapResourceByPTMId.get(personId);
            if (budgetResource == null) {
                budgetResource = new BudgetResource__c();
                budgetResource.BudgetHeader__c = oBudgetHeader.id;
                budgetResource.OverrideRatesOnLines__c = true;
                budgetResource.ResourceType__c = 'Labor/Person';
                /* if (quantity != 0 && quantity != null) {
                    budgetResource.OverrideRawCost__c = totalRawCost / quantity;
                    }*/
                // TODO: ???
                // budgetResource.OverrideBillRate__c = theProject.DefaultBillRate__c;
                // budgetResource.OverrideUplift__c = theProject.DefaultUpliftLabor__c;

                if (ptm != null) {
                    budgetResource.ProjectTeamMember__c = ptmId;
                } else {
                    budgetResource.JobName__c = 'Error: No contact with Oracle Person ID - ' + personId;
                }

                mapResourceByPTMId.put(ptmId, budgetResource);
            }

            List<BudgetAssignment__c> oAssignments = mapAssignmentsByPTMId.get(ptmId);

            if (oAssignments == null) {
                oAssignments = new List<BudgetAssignment__c> ();
                mapAssignmentsByPTMId.put(ptmID, oAssignments);
            }

            String uniqueId = personId + uniqueDelim + projectTaskId;
            BudgetAssignment__c ba = mapAssignmentByUniqueId.get(uniqueId);
            if (ba == null) {
                ba = new BudgetAssignment__c();
                ba.EACApprovedTotalCost__c = 0;
                ba.EACForecastTotalCost__c = 0;
                ba.EACApprovedQuantity__c = 0;
                ba.EACForecastQuantity__c = 0;
                mapAssignmentByUniqueId.put(uniqueId, ba);
                oAssignments.add(ba); // make sure we only the BA once
            }

            ba.BudgetTask__c = budgetTaskId;

            /* if (quantity != 0 && quantity != null) {
                budgetResource.OverrideRawCost__c = totalRawCost / quantity;
            }
            */
            ba.EACActualQuantity__c = quantity;
            ba.EACActualCost__c = totalRawCost;
        }

        for (AggregateResult ar : arTotals) {
            Id projectTaskId = (Id)ar.get('ProjectTask__c');
            String personId = (String)ar.get('PersonId__c');
            ProjectTeamMember__c ptm = mapPTMByPersonId.get(personId);

            Id ptmId = ptm != null ? ptm.Id : null;

            if (projectTaskId == null) continue;

            if (personId != null) PersonIdsInBudget.add(personId);

            String status = (String)ar.get('Status__c');
            Decimal quantity = (Decimal)ar.get('Quantity__c');
            Decimal totalCost = (Decimal)ar.get('FullyBurdenedCost__c');
            totalCost = totalCost == null ? 0 : totalCost;

            Id budgetTaskId = mBudgetTask.get(projectTaskId).Id;
            BudgetResource__c budgetResource = mapResourceByPTMId.get(ptmId);

            if (budgetResource == null) {
                budgetResource = new BudgetResource__c();
                budgetResource.BudgetHeader__c = oBudgetHeader.id;
                budgetResource.OverrideRatesOnLines__c = true;
                budgetResource.ResourceType__c = 'Labor/Person';
                // TODO: ???
                // budgetResource.OverrideBillRate__c = theProject.DefaultBillRate__c;
                // budgetResource.OverrideUplift__c = theProject.DefaultUpliftLabor__c;
                budgetResource.JobName__c = null;

                budgetResource.ProjectTeamMember__c = ptmId;
                mapResourceByPTMId.put(ptmId, budgetResource);
            }

            List<BudgetAssignment__c> oAssignments = mapAssignmentsByPTMId.get(ptmId);

            if (oAssignments == null) {
                oAssignments = new List<BudgetAssignment__c> ();
                mapAssignmentsByPTMId.put(ptmID, oAssignments);
            }

            String uniqueId = personId + uniqueDelim + projectTaskId;
            BudgetAssignment__c ba = mapAssignmentByUniqueId.get(uniqueId);
            if (ba == null) {
                ba = new BudgetAssignment__c();
                ba.EACApprovedTotalCost__c = 0;
                ba.EACForecastTotalCost__c = 0;
                ba.EACApprovedQuantity__c = 0;
                ba.EACForecastQuantity__c = 0;
                mapAssignmentByUniqueId.put(uniqueId, ba);
                oAssignments.add(ba); // make sure we only the BA once
            }

            ba.BudgetTask__c = budgetTaskId;
            if (status == 'Approved') {
                ba.EACApprovedQuantity__c = quantity;
                ba.EACApprovedTotalCost__c = totalCost;
            } else if (status == 'Forecast') {
                ba.EACForecastQuantity__c = quantity;
                ba.EACForecastTotalCost__c = totalCost;
            }

        }

        // Insert All budgetResources
        List<BudgetResource__c> allBudgets = new List<BudgetResource__c>();
        allBudgets.addAll(mapResourceByPTMId.values());
        allBudgets.addAll(mapResourceByContingencyName.values());
        allBudgets.addAll(mapResourceBySubId.values());
        allBudgets.addAll(mapResourceByExpType.values());
        insert allBudgets;

        //insert mapResourceBySubId.values();
        //insert mapResourceByContingencyName.values();

        for (String contName : mapResourceByContingencyName.keySet()) {
            Id brId = mapResourceByContingencyName.get(contName).Id;

            for (BudgetAssignment__c ba : mapAssignmentsByContingencyName.get(contName)) {
                ba.BudgetResource__c = brId;
            }
        }

        for (String expType : mapResourceByExpType.keySet()) {
            Id brId = mapResourceByExpType.get(expType).Id;

            for (BudgetAssignment__c ba : mapAssignmentsByExpType.get(expType)) {
                ba.BudgetResource__c = brId;
            }
        }

        for (Id subId : mapResourceBySubId.keySet()) {
            Id brId = mapResourceBySubId.get(subId).Id;

            for (BudgetAssignment__c ba : mapAssignmentsBySubId.get(subId)) {
                ba.BudgetResource__c = brId;
            }
        }

        for (String ptmId : mapResourceByPTMId.keySet()) {
            Id brId = mapResourceByPTMId.get(ptmId).Id;

            for (BudgetAssignment__c ba : mapAssignmentsByPTMId.get(ptmId)) {
                ba.BudgetResource__c = brId;
            }
        }

        for (BudgetAssignment__c ba : mapAssignmentByUniqueId.values()) {
            ba.EACForecastTotalCost__c = ifNull(ba.EACApprovedTotalCost__c) + ifNull(ba.EACForecastTotalCost__c);
            ba.EACForecastQuantity__c = ifNull(ba.EACApprovedQuantity__c) + ifNull(ba.EACForecastQuantity__c);
        }

        // Insert All Budget Asssignments
        insert mapAssignmentByUniqueId.values();
        ECO_TriggerSettings.overrideTriggerSetting('PT_CalcEV', true);
        return oBudgetHeader.Id;
    }

    private static Decimal ifNull(Decimal val) {
        return val == null ? 0 : val;
    }
}