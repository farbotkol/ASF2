public without sharing class INC_ShowEnrollmentMetricsController {
 
	public EnrollmentPlan__c oEnrollmentPlan {get;set;}
    private boolean bEnrollmentPlanEnrolled = false;
    private boolean bNMPlan = true;
    public boolean fromEnrollPart {get;set;}
    public list<metricTableRowWrapper> listApproved {get;set;}
    public list<metricTableRowWrapper> listForecasted {get;set;}
    public list<metricTableRowWrapper> listActuals {get;set;}
    public list<metricTableRowWrapper> listBaseline {get;set;}
    public list<metricTableRowWrapper> listIncValues{get;set;}
    public list<metricTableRowWrapper> listIncValuesTable2{get;set;}
    public string sFirstMessageClass {get;set;}
    public string sSecondMessageClass {get;set;}
    public string sThirdMessageClass {get;set;}
   

    public list<Schema.FieldSetMember> listApprovedFlds{get;set;}
    public String firstColumnHeader {get;set;}
    
    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public INC_ShowEnrollmentMetricsController() {
        //oEnrollmentPlan = (EnrollmentPlan__c)stdController.getRecord();
        System.Debug(logginglevel.error,'oEnrollmentPlan: ' + oEnrollmentPlan);
        sFirstMessageClass = 'gray';
        sSecondMessageClass = 'gray';
        sThirdMessageClass = 'gray';


        if((Apexpages.currentpage().getParameters().get('loc') == null)
            || (Apexpages.currentpage().getParameters().get('loc') != '2')){
            fromEnrollPart = false;
        }else{
            fromEnrollPart = true;
        }
        system.Debug(logginglevel.error,'fromEnrollPart: ' + fromEnrollPart);
        getEnrollmentPlan(); 
        firstColumnHeader = 'At Form Creation';
        if(oEnrollmentPlan.EnrollmentStatus__c == 'Enrolled'){
            bEnrollmentPlanEnrolled = true;
            firstColumnHeader = 'At Enrollment';
        }
        if(oEnrollmentPlan.IncentivePlan__r.ContractSubType__c == 'Gross Margin'){
            bNMPlan = false;
        }
        if(oEnrollmentPlan.EEACGMPerformance__c == 'Above Threshold'){
            sThirdMessageClass = 'green';
        }
        if(oEnrollmentPlan.EEACGMPerformance__c == 'Below Threshold'){
            sSecondMessageClass = 'yellow';
        }
        if(oEnrollmentPlan.EEACGMPerformance__c == 'Below Baseline'){
            sFirstMessageClass = 'red';
        }
        //buildtheDisplayMaps();
        buildApprovedList();
        buildForcastList();
        buildAtualsList();
        buildBaselineList();
        buildIncVals();
    }

    private void getEnrollmentPlan() {
        String sID;// = oEnrollmentPlan.ID;
        if(sID == null){
            sID = ApexPages.currentPage().getParameters().get('id');
        }
        list<Schema.FieldSetMember> listFields = SObjectType.EnrollmentPlan__c.FieldSets.ActualBudgetMetrics.getFields();
        listFields.addAll(SObjectType.EnrollmentPlan__c.FieldSets.ApprovedBudgetMetrics.getFields());
        listFields.addAll(SObjectType.EnrollmentPlan__c.FieldSets.ForcastedBudgetMetrics.getFields());
        listFields.addAll(sObjectType.EnrollmentPlan__c.FieldSets.BaselineMetrics.getFields());
        String strSOQL = 'Select ';
        for (Schema.FieldSetMember fsmField: listFields) {
           strSOQL += fsmField.getFieldPath() + ', ';
        }

        strSOQL += 'ID, MetricWarningActive__c, EnrollmentStatus__c,IPProjectManager__c';
        strSOQL += ',ContractType__c,ScheduledFinishDate__c,ProjectStartDate__c';
        strSOQL += ',IncentivePlan__r.ContractSubType__c, IncentivePlan__r.Name';
        strSOQL += ',IncentivePlan__r.ContractType__c';
        strSOQL += ',IncentivePlan__r.HelpText__c,IncentiveProject__r.CustomerName__c';
        strSOQL += ',IncentiveProject__r.ForecastGrossMarginofNSR__c,IncentiveProject__r.ForecastNMofNSR__c';
        strSOQL += ',ThresholdGM__c,ThresholdNM__c';
        strSOQL += ',AlertBaselineGMNSR__c,AlertBudgetedGMofNSR__c,AlertDirectPersonnelExpense__c';
        strSOQL += ',AlertGMBudget__c,AlertNSRBudget__c,AlertProjectComplete__c';
        strSOQL += ',AlertBaselineNMNSR__c,AlertBudgetedNMofNSR__c,AlertNMBudget__c';
        strSOQL += ',EstimatedIncentivePoolEAC__c,MaxIncentivePool__c,NumberofParticipants__c';
        strSOQL += ',IncentiveProject__r.DataRefreshDate__c, EEACGMPerformance__c';
        strSOQL += ',IncentivePlan__r.PlanCriteria__c, Name From EnrollmentPlan__c where Id =: sID';
        list<EnrollmentPlan__c> lstEnrollSearchResults = (list<EnrollmentPlan__c>)Database.query(strSOQL);

        oEnrollmentPlan = lstEnrollSearchResults[0];
    }
 
    public pageReference close(){
        String sID = Apexpages.currentpage().getParameters().get('pr');
        if(sID == null){
            sID = oEnrollmentPlan.ID;
        }
        pageReference returnPage = new pageReference('/apex/INC_EnrollmentApp?id=' + sID);
        returnPage.setRedirect(True);
        return returnPage;
    }
    public pageReference UpdateFlag(){
      

        oEnrollmentPlan.MetricWarningActive__c = 'No';
        if(INC_Service_EnrollmentPlan.updateEnrollmentApplications(new list<EnrollmentPlan__c>{oEnrollmentPlan})){
            return close();
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'There was a error updating the flag.'));
        return null;
    }

    private void buildIncVals(){
        listIncValues = new list<metricTableRowWrapper>();
        listIncValuesTable2 = new list<metricTableRowWrapper>();
        metricTableRowWrapper mtw = new metricTableRowWrapper();
        mtw.label = 'Current EAC Margin % of NSR';
        mtw.column1Val = (oEnrollmentPlan.IncentivePlan__r.ContractSubType__c == 'Gross Margin' ? oEnrollmentPlan.IncentiveProject__r.ForecastGrossMarginofNSR__c.format() 
            :oEnrollmentPlan.IncentiveProject__r.ForecastNMofNSR__c.format() );
        mtw.labelClass = 'aslabel';
        mtw.tdclass = '';
        listIncValues.add(mtw);
       
        mtw = new metricTableRowWrapper();
        mtw.label = 'Threshold Margin % of NSR';
        mtw.column1Val = (oEnrollmentPlan.IncentivePlan__r.ContractSubType__c == 'Gross Margin' ? oEnrollmentPlan.ThresholdGM__c.format() 
                          :oEnrollmentPlan.ThresholdNM__c.format() );
        mtw.labelClass = 'aslabel';
         mtw.tdclass = '';
        listIncValues.add(mtw);
       
        mtw = new metricTableRowWrapper();
        mtw.label = 'Current EAC Margin % of NSR';
        mtw.column1Val = (oEnrollmentPlan.IncentivePlan__r.ContractSubType__c == 'Gross Margin' ? oEnrollmentPlan.BaselineGMofNSR__C.format() 
                          :oEnrollmentPlan.BaselineNMofNSR__c.format() );
        mtw.labelClass = 'aslabel';
        mtw.tdclass = '';
        listIncValues.add(mtw);  
        
        double forcastMargin = oEnrollmentPlan.IncentivePlan__r.ContractSubType__c == 'Gross Margin' ? oEnrollmentPlan.IncentiveProject__r.ForecastGrossMarginofNSR__c
                          :oEnrollmentPlan.IncentiveProject__r.ForecastNMofNSR__c;
        double baselineMargin = oEnrollmentPlan.IncentivePlan__r.ContractSubType__c == 'Gross Margin' ? oEnrollmentPlan.BaselineGMofNSR__c 
                          :oEnrollmentPlan.BaselineNMofNSR__c;

        double value = forcastMargin - baselineMargin;

        mtw = new metricTableRowWrapper();
        mtw.label = 'EAC Margin vs. Baseline';
        mtw.column1Val = value.format();
        mtw.labelClass = 'aslabel';
        mtw.tdclass = '';
        listIncValues.add(mtw);   

        mtw = new metricTableRowWrapper();
        mtw.label = 'Is Project Forecasting an Incentive';
        mtw.column1Val = oEnrollmentPlan.EEACGMPerformance__c == 'Above Threshold' ? 'Yes':'No';//need to set this value
        mtw.labelClass = 'aslabel';
        mtw.tdclass = '';
        listIncValues.add(mtw);

        mtw = new metricTableRowWrapper();
        mtw.label = 'Estimated Incentive Pool @ EAC';
        mtw.tdclass = 'raised1';
        mtw.column1Val = oEnrollmentPlan.EstimatedIncentivePoolEAC__c.format();
        mtw.labelClass = 'aslabel';
        listIncValuesTable2.add(mtw);

        mtw = new metricTableRowWrapper();
        mtw.label = 'Maximum Incentive Pool @ EAC';
        mtw.tdclass = 'raised1';
        mtw.column1Val = oEnrollmentPlan.MaxIncentivePool__c.format();
        mtw.labelClass = 'aslabel';
        listIncValuesTable2.add(mtw);

        mtw = new metricTableRowWrapper();
        mtw.label = 'Current Active Participant Count';
        mtw.column1Val = oEnrollmentPlan.NumberofParticipants__c.format();
        mtw.labelClass = 'aslabel';
        listIncValuesTable2.add(mtw);

        mtw = new metricTableRowWrapper();
        mtw.label = 'Data Refresh Date';
        mtw.column1Val = String.ValueOf(oEnrollmentPlan.IncentiveProject__r.DataRefreshDate__c);
        mtw.labelClass = 'aslabel';
        mtw.tdclass = '';
        listIncValuesTable2.add(mtw);
    }

    private void buildBaselineList(){
        listBaseline = new list<metricTableRowWrapper>();
        metricTableRowWrapper mtw = new metricTableRowWrapper();
        mtw.label = 'Baseline NSR';
        mtw.column1Val = (oEnrollmentPlan.BaselineNSRatSnapshot__c != null ? oEnrollmentPlan.BaselineNSRatSnapshot__c.format() : '');
        mtw.currentVal = (oEnrollmentPlan.BaselineNSR__c != null ? oEnrollmentPlan.BaselineNSR__c.format():'');
        mtw.Variance = (oEnrollmentPlan.BaselineNSRVariance__c != null ? oEnrollmentPlan.BaselineNSRVariance__c.format(): '');
        mtw.labelClass = 'aslabel';
        listBaseline.add(mtw);
        mtw = new metricTableRowWrapper();
        mtw.label = 'Baseline DPE';
        mtw.column1Val = (oEnrollmentPlan.BaselineDPEatSnapshot__c != null ? oEnrollmentPlan.BaselineDPEatSnapshot__c.format() : '');
        mtw.currentVal = (oEnrollmentPlan.BaselineDPE__c != null ? oEnrollmentPlan.BaselineDPE__c.format():'');
        mtw.Variance = (oEnrollmentPlan.BaselineDPEVariance__c != null ? oEnrollmentPlan.BaselineDPEVariance__c.format(): '');
        mtw.labelClass = 'aslabel';
        listBaseline.add(mtw);
        if(!bNMPlan){
            mtw = new metricTableRowWrapper();
            mtw.label = 'Baseline Gross Margin';
            mtw.column1Val = (oEnrollmentPlan.BaselineGrossMarginatSnapshot__c != null ? oEnrollmentPlan.BaselineGrossMarginatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.BaselineGrossMargin__c != null ? oEnrollmentPlan.BaselineGrossMargin__c.format():'');
            mtw.Variance = (oEnrollmentPlan.BaselineGrossMarginVariance__c != null ? oEnrollmentPlan.BaselineGrossMarginVariance__c.format(): '');
            mtw.labelClass = 'aslabel';
            listBaseline.add(mtw);
        }
        if(bNMPlan){
            mtw = new metricTableRowWrapper();
            mtw.label = 'Baseline Net Margin';
            mtw.column1Val = (oEnrollmentPlan.BaselineNetMarginatSnapshot__c != null ? oEnrollmentPlan.BaselineNetMarginatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.BaselineNetMargin__c != null ? oEnrollmentPlan.BaselineNetMargin__c.format():'');
            mtw.Variance = (oEnrollmentPlan.BaselineNetMarginVariance__c != null ? oEnrollmentPlan.BaselineNetMarginVariance__c.format(): '');
            mtw.labelClass = 'aslabel';
            listBaseline.add(mtw);
        }
        if(!bNMPlan){
            mtw = new metricTableRowWrapper();
            mtw.label = 'Baseline GM% NSR';
            mtw.column1Val = (oEnrollmentPlan.BaselineGMofNSRatSnapshot__c != null ? oEnrollmentPlan.BaselineGMofNSRatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.BaselineGMofNSR__c != null ? oEnrollmentPlan.BaselineGMofNSR__c.format():'');
            mtw.Variance = (oEnrollmentPlan.BaselineGMofNSRVariance__c != null ? oEnrollmentPlan.ForecastNSRBudgetVariance__c.format(): '');
            mtw.labelClass = 'aslabel';
            mtw.imageCol2 = oEnrollmentPlan.AlertBaselineGMNSR__c;
            listBaseline.add(mtw);
        }
        if(bNMPlan){
            mtw = new metricTableRowWrapper();
            mtw.label = 'Baseline NM% NSR';
            mtw.column1Val = (oEnrollmentPlan.BaselineNMofNSRatSnapshot__c != null ? oEnrollmentPlan.BaselineNMofNSRatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.BaselineNMofNSR__c != null ? oEnrollmentPlan.BaselineNMofNSR__c.format():'');
            mtw.Variance = (oEnrollmentPlan.BaselineNMofNSRVariance__c != null ? oEnrollmentPlan.BaselineNMofNSRVariance__c.format(): '');
            mtw.labelClass = 'aslabel';
            mtw.imageCol2 = oEnrollmentPlan.AlertBaselineNMNSR__c;
           listBaseline.add(mtw);
        }
        mtw = new metricTableRowWrapper();
        mtw.label='Project % Complete';
        mtw.column1Val = (oEnrollmentPlan.ITDCostCompleteatSnapshot__c != null ? oEnrollmentPlan.ITDCostCompleteatSnapshot__c.format() : '');
        mtw.currentVal = (oEnrollmentPlan.PercentCompleteCostITD__c != null ? oEnrollmentPlan.PercentCompleteCostITD__c.format():'');
        mtw.Variance = (oEnrollmentPlan.ActualProjectPercentCompleteVariance__c != null ? oEnrollmentPlan.ActualProjectPercentCompleteVariance__c.format(): '');
        mtw.tdclass = 'percent';
        mtw.imageCol2 = oEnrollmentPlan.AlertProjectComplete__c;
        listBaseline.add(mtw);
        mtw = new metricTableRowWrapper();
        mtw.label = 'DTW % Complete @ Enrollment, Adjusted for Change Orders';
        mtw.column1Val = (oEnrollmentPlan.ForecastDPEBudgetatSnapshot__c != null ? oEnrollmentPlan.ForecastDPEBudgetatSnapshot__c.format() : '');
        mtw.currentVal = (oEnrollmentPlan.ForecastDPEBudget__c != null ? oEnrollmentPlan.ForecastDPEBudget__c.format():'');
        mtw.Variance = (oEnrollmentPlan.ForecastDPEBudgetVariance__c != null ? oEnrollmentPlan.ForecastDPEBudgetVariance__c.format(): '');
        mtw.tdClass='2row';
        listBaseline.add(mtw);
        
    }
    private void buildApprovedList(){
        listApproved = new list<metricTableRowWrapper>();
        metricTableRowWrapper mtw = new metricTableRowWrapper();
        mtw.label = 'Gross Revenue Budget';
        mtw.column1Val = (oEnrollmentPlan.ApprovedRevenueBudgetatSnapshot__c != null ? oEnrollmentPlan.ApprovedRevenueBudgetatSnapshot__c.format() : '');
        mtw.currentVal = (oEnrollmentPlan.ApprovedRevenueBudget__c != null ? oEnrollmentPlan.ApprovedRevenueBudget__c.format():'');
        mtw.Variance = (oEnrollmentPlan.ApprovedRevenueBudgetVariance__c != null ? oEnrollmentPlan.ApprovedRevenueBudgetVariance__c.format(): '');
        mtw.sClass = 'importantrow';
        listApproved.add(mtw);
        if(!fromEnrollPart){
            mtw = new metricTableRowWrapper();
            mtw.label = 'Contingency Budget';
            mtw.column1Val = (oEnrollmentPlan.ApprovedContingencyBudgetatSnapshot__c != null ? oEnrollmentPlan.ApprovedContingencyBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ApprovedContingencyBudget__c != null ? oEnrollmentPlan.ApprovedContingencyBudget__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ApprovedContingencyBudgetVariance__c != null ? oEnrollmentPlan.ApprovedContingencyBudgetVariance__c.format(): '');
            mtw.sClass = 'importantrow';
            listApproved.add(mtw);
            mtw = new metricTableRowWrapper();
            mtw.label = 'ODC Budget (excl Subs)';
            mtw.column1Val = (oEnrollmentPlan.ApprovedODCBudgetatSnapshot__c != null ? oEnrollmentPlan.ApprovedODCBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ApprovedODCBudget__c != null ? oEnrollmentPlan.ApprovedODCBudget__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ApprovedODCBudgetVariance__c != null ? oEnrollmentPlan.ApprovedODCBudgetVariance__c.format(): '');
            listApproved.add(mtw);
            mtw = new metricTableRowWrapper();
            mtw.label = 'Subconsultants Budget';
            mtw.column1Val = (oEnrollmentPlan.ApprovedSubsBudgetatSnapshot__c != null ? oEnrollmentPlan.ApprovedSubsBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ApprovedSubsBudget__c != null ? oEnrollmentPlan.ApprovedSubsBudget__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ActualSubsBudgetVariance__c != null ? oEnrollmentPlan.ActualSubsBudgetVariance__c.format(): '');
            listApproved.add(mtw);
        }
        mtw = new metricTableRowWrapper();
        mtw.label = 'NSR Budget';
        mtw.column1Val = (oEnrollmentPlan.ApprovedNSRBudgetatSnapshot__c != null ? oEnrollmentPlan.ApprovedNSRBudgetatSnapshot__c.format() : '');
        mtw.currentVal = (oEnrollmentPlan.ApprovedNSRBudget__c != null ? oEnrollmentPlan.ApprovedNSRBudget__c.format():'');
        mtw.Variance = (oEnrollmentPlan.ApprovedNSRBudgetVariance__c != null ? oEnrollmentPlan.ApprovedNSRBudgetVariance__c.format(): '');
        mtw.sClass = 'importantrow';
        mtw.imageCol2 = oEnrollmentPlan.AlertNSRBudget__c;
        listApproved.add(mtw);
        if(!fromEnrollPart){
            mtw = new metricTableRowWrapper();
            mtw.label = 'Labor Budget';
            mtw.column1Val = (oEnrollmentPlan.ApprovedDirectLaborBudgetatSnapshot__c != null ? oEnrollmentPlan.ApprovedDirectLaborBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ApprovedDirectLaborBudget__c != null ? oEnrollmentPlan.ApprovedDirectLaborBudget__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ApprovedDirectLaborBudgetVariance__c != null ? oEnrollmentPlan.ApprovedDirectLaborBudgetVariance__c.format(): '');
            listApproved.add(mtw);
            mtw = new metricTableRowWrapper();
            mtw.label = 'Fringe Budget';
            mtw.column1Val = (oEnrollmentPlan.ApprovedFringeBudgetatSnapshot__c != null ? oEnrollmentPlan.ApprovedFringeBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ApprovedFringeBudget__c != null ? oEnrollmentPlan.ApprovedFringeBudget__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ApprovedFringeBudgetVariance__c != null ? oEnrollmentPlan.ApprovedFringeBudgetVariance__c.format(): '');
            listApproved.add(mtw);
            mtw = new metricTableRowWrapper();
            mtw.label = 'Direct Personnel Expense (DPE) Budget';
            mtw.column1Val = (oEnrollmentPlan.ApprovedDPEBudgetatSnapshot__c != null ? oEnrollmentPlan.ApprovedDPEBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ApprovedDPEBudget__c != null ? oEnrollmentPlan.ApprovedDPEBudget__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ApprovedDPEBudgetVariance__c != null ? oEnrollmentPlan.ApprovedDPEBudgetVariance__c.format(): '');
            mtw.sClass = 'importantrow';
            mtw.imageCol2 = oEnrollmentPlan.AlertDirectPersonnelExpense__c;
            listApproved.add(mtw);
        }
        if(!bNMPlan){
            mtw = new metricTableRowWrapper();
            mtw.label = 'GM Budget';
            mtw.column1Val = (oEnrollmentPlan.ApprovedGrossMarginBudgetatSnapshot__c != null ? oEnrollmentPlan.ApprovedGrossMarginBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ApprovedGrossMarginBudget__c != null ? oEnrollmentPlan.ApprovedGrossMarginBudget__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ApprovedGrossMarginBudgetVariance__c != null ? oEnrollmentPlan.ApprovedGrossMarginBudgetVariance__c.format(): '');
            mtw.sClass = 'importantrow';
            mtw.imageCol2 = oEnrollmentPlan.AlertGMBudget__c;
            listApproved.add(mtw);
        }
        mtw = new metricTableRowWrapper();
        mtw.label = 'Overhead Budget';
        mtw.column1Val = (oEnrollmentPlan.ApprovedOverheadBudgetatSnapshot__c != null ? oEnrollmentPlan.ApprovedOverheadBudgetatSnapshot__c.format() : '');
        mtw.currentVal = (oEnrollmentPlan.ApprovedOverheadBudget__c != null ? oEnrollmentPlan.ApprovedOverheadBudget__c.format():'');
        mtw.Variance = (oEnrollmentPlan.ApprovedOverheadBudgetVariance__c != null ? oEnrollmentPlan.ApprovedOverheadBudgetVariance__c.format(): '');
        listApproved.add(mtw);
        if(bNMPlan){
            mtw = new metricTableRowWrapper();
            mtw.label = 'Net Margin Budget';
            mtw.column1Val = (oEnrollmentPlan.ApprovedNetMarginBudgetatSnapshot__c != null ? oEnrollmentPlan.ApprovedNetMarginBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ApprovedNetMarginBudget__c != null ? oEnrollmentPlan.ApprovedNetMarginBudget__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ApprovedNetMarginBudgetVariance__c != null ? oEnrollmentPlan.ApprovedNetMarginBudgetVariance__c.format(): '');
            mtw.sClass = 'importantrow';
            mtw.imageCol2 = oEnrollmentPlan.AlertNMBudget__c;
            listApproved.add(mtw);
        }
        if(!bNMPlan){
            mtw = new metricTableRowWrapper();
            mtw.label = 'Budgeted GM% of NSR';
            mtw.column1Val = (oEnrollmentPlan.ApprovedGrossMarginofNSRatSnapshot__c != null ? oEnrollmentPlan.ApprovedGrossMarginofNSRatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ApprovedGrossMarginofNSR__c != null ? oEnrollmentPlan.ApprovedGrossMarginofNSR__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ApprovedGrossMarginofNSRVariance__c != null ? oEnrollmentPlan.ApprovedGrossMarginofNSRVariance__c.format(): '');
            mtw.tdclass='percent';
            mtw.imageCol2 = oEnrollmentPlan.AlertBudgetedGMofNSR__c;
            listApproved.add(mtw);
        }
        if(bNMPlan){
            mtw = new metricTableRowWrapper();
            mtw.label = 'Budgeted NM% of NSR';
            mtw.column1Val = (oEnrollmentPlan.ApprovedNetMarginofNSRatSnapshot__c != null ? oEnrollmentPlan.ApprovedNetMarginofNSRatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ApprovedNetMarginofNSR__c != null ? oEnrollmentPlan.ApprovedNetMarginofNSR__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ApprovedNetMarginofNSRVariance__c != null ? oEnrollmentPlan.ApprovedNetMarginofNSRVariance__c.format(): '');
            mtw.tdclass='percent';
            listApproved.add(mtw);
        }
        if(!fromEnrollPart){
            mtw = new metricTableRowWrapper();
            mtw.label = 'Budgeted Salary Cost Multiplier';
            mtw.column1Val = (oEnrollmentPlan.ApprovedSalaryCMatSnapshot__c != null ? oEnrollmentPlan.ApprovedSalaryCMatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ApprovedSalaryCostMultiplier__c != null ? oEnrollmentPlan.ApprovedSalaryCostMultiplier__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ApprovedSalaryCostMultiplierVariance__c != null ? oEnrollmentPlan.ApprovedSalaryCostMultiplierVariance__c.format(): '');
            listApproved.add(mtw);
            mtw = new metricTableRowWrapper();
            mtw.label = 'Budgeted Labor Cost Multiplier';
            mtw.column1Val = (oEnrollmentPlan.ApprovedDirectLMatSnapshot__c != null ? oEnrollmentPlan.ApprovedDirectLMatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ApprovedDirectLaborMultiplier__c != null ? oEnrollmentPlan.ApprovedDirectLaborMultiplier__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ApprovedDirectLaborMultiplierVariance__c != null ? oEnrollmentPlan.ApprovedDirectLaborMultiplierVariance__c.format(): '');
            listApproved.add(mtw);
            mtw = new metricTableRowWrapper();
            mtw.label = 'Total Cost Budget';
            mtw.column1Val = (oEnrollmentPlan.ApprovedCostBudget__c != null ? oEnrollmentPlan.ApprovedCostBudget__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ApprovedCostBudget__c != null ? oEnrollmentPlan.ApprovedCostBudget__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ApprovedCostBudgetVariance__c != null ? oEnrollmentPlan.ApprovedCostBudgetVariance__c.format(): '');
            listApproved.add(mtw);
            mtw.sClass = 'importantrow';
        }
        System.Debug(logginglevel.error,'listApproved.size ' + listApproved);
    }

    private void buildForcastList(){
        listForecasted = new list<metricTableRowWrapper>();
        metricTableRowWrapper mtw = new metricTableRowWrapper();
        mtw.label = 'Gross Revenue Forecast';
        mtw.column1Val = (oEnrollmentPlan.ForecastRevenueBudgetatSnapshot__c != null ? oEnrollmentPlan.ForecastRevenueBudgetatSnapshot__c.format() : '');
        mtw.currentVal = (oEnrollmentPlan.ForecastRevenueBudget__c != null ? oEnrollmentPlan.ForecastRevenueBudget__c.format():'');
        mtw.Variance = (oEnrollmentPlan.ForecastRevenueBudgetVariance__c != null ? oEnrollmentPlan.ForecastRevenueBudgetVariance__c.format(): '');
        mtw.sClass = 'importantrow';
        listForecasted.add(mtw);
        if(!fromEnrollPart){
            mtw = new metricTableRowWrapper();
            mtw.label = 'Contingency Forecast';
            mtw.column1Val = (oEnrollmentPlan.ForecastContingencyBudgetatSnapshot__c != null ? oEnrollmentPlan.ForecastContingencyBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ForecastContingencyBudget__c != null ? oEnrollmentPlan.ForecastContingencyBudget__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ForecastContingencyBudgetVariance__c != null ? oEnrollmentPlan.ForecastContingencyBudgetVariance__c.format(): '');
            listForecasted.add(mtw);
            mtw = new metricTableRowWrapper();
            mtw.label = 'ODC Forecast (excl Subs)';
            mtw.column1Val = (oEnrollmentPlan.ForecastODCBudgetatSnapshot__c != null ? oEnrollmentPlan.ForecastODCBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ForecastODCBudget__c != null ? oEnrollmentPlan.ForecastODCBudget__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ForecastODCBudgetVariance__c != null ? oEnrollmentPlan.ForecastODCBudgetVariance__c.format(): '');
            listForecasted.add(mtw);
            mtw = new metricTableRowWrapper();
            mtw.label = 'Subconsultants Forecast';
            mtw.column1Val = (oEnrollmentPlan.ForecastSubsBudgetatSnapshot__c != null ? oEnrollmentPlan.ForecastSubsBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ForecastSubsBudget__c != null ? oEnrollmentPlan.ForecastSubsBudget__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ForecastSubsBudgetVariance__c != null ? oEnrollmentPlan.ForecastSubsBudgetVariance__c.format(): '');
            listForecasted.add(mtw);
        }
        mtw = new metricTableRowWrapper();
        mtw.label = 'NSR Forecast';
        mtw.column1Val = (oEnrollmentPlan.ForecastNSRBudgetatSnapshot__c != null ? oEnrollmentPlan.ForecastNSRBudgetatSnapshot__c.format() : '');
        mtw.currentVal = (oEnrollmentPlan.ForecastNSRBudget__c != null ? oEnrollmentPlan.ForecastNSRBudget__c.format():'');
        mtw.Variance = (oEnrollmentPlan.ForecastNSRBudgetVariance__c != null ? oEnrollmentPlan.ForecastNSRBudgetVariance__c.format(): '');
        mtw.sClass = 'importantrow';
        listForecasted.add(mtw);
        if(!fromEnrollPart){
            mtw = new metricTableRowWrapper();
            mtw.label = 'Labor Forecast';
            mtw.column1Val = (oEnrollmentPlan.ForecastLaborBudgetatSnapshot__c != null ? oEnrollmentPlan.ForecastLaborBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ForecastDirectLaborBudget__c != null ? oEnrollmentPlan.ForecastDirectLaborBudget__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ForecastLaborBudgetVariance__c != null ? oEnrollmentPlan.ForecastLaborBudgetVariance__c.format(): '');
            listForecasted.add(mtw);
            mtw = new metricTableRowWrapper();
            mtw.label = 'Fringe Forecast';
            mtw.column1Val = (oEnrollmentPlan.ForecastFringeBudgetatSnapshot__c != null ? oEnrollmentPlan.ForecastFringeBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ForecastFringeBudget__c != null ? oEnrollmentPlan.ForecastFringeBudget__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ForecastFringeBudgetVariance__c != null ? oEnrollmentPlan.ForecastFringeBudgetVariance__c.format(): '');
            listForecasted.add(mtw);
            mtw = new metricTableRowWrapper();
            mtw.label = 'Direct Personnel Expense (DPE) Forecast';
            mtw.column1Val = (oEnrollmentPlan.ForecastDPEBudgetatSnapshot__c != null ? oEnrollmentPlan.ForecastDPEBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ForecastDPEBudget__c != null ? oEnrollmentPlan.ForecastDPEBudget__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ForecastDPEBudgetVariance__c != null ? oEnrollmentPlan.ForecastDPEBudgetVariance__c.format(): '');
            mtw.sClass = 'importantrow';
            listForecasted.add(mtw);
        }
        if(!bNMPlan){
            mtw = new metricTableRowWrapper();
            mtw.label = 'GM Forecast';
            mtw.column1Val = (oEnrollmentPlan.ForecastGMBudgetatSnapshot__c != null ? oEnrollmentPlan.ForecastGMBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ForecastGrossMarginBudget__c != null ? oEnrollmentPlan.ForecastGrossMarginBudget__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ForecastGMBudgetVariance__c != null ? oEnrollmentPlan.ForecastGMBudgetVariance__c.format(): '');
            mtw.sClass = 'importantrow';
            listForecasted.add(mtw);
        }
        if(!fromEnrollPart){
            mtw = new metricTableRowWrapper();
            mtw.label = 'Overhead Forecast';
            mtw.column1Val = (oEnrollmentPlan.ForecastOverheadBudgetatSnapshot__c != null ? oEnrollmentPlan.ForecastOverheadBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ForecastOverheadBudget__c != null ? oEnrollmentPlan.ForecastOverheadBudget__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ForecastOverheadBudgetVariance__c != null ? oEnrollmentPlan.ForecastOverheadBudgetVariance__c.format(): '');
            listForecasted.add(mtw);
        }
        if(bNMPlan){
            mtw = new metricTableRowWrapper();
            mtw.label = 'NM Forecast';
            mtw.column1Val = (oEnrollmentPlan.ForecastNMBudgetatSnapshot__c != null ? oEnrollmentPlan.ForecastNMBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ForecastNetMarginBudget__c != null ? oEnrollmentPlan.ForecastNetMarginBudget__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ForecastNMBudgetVariance__c != null ? oEnrollmentPlan.ForecastNMBudgetVariance__c.format(): '');
            mtw.sClass = 'importantrow';
            listForecasted.add(mtw);
        }
        if(!bNMPlan){
            mtw = new metricTableRowWrapper();
            mtw.label = 'Forecast GM% of NSR';
            mtw.column1Val = (oEnrollmentPlan.ForecastGMofNSRatSnapshot__c != null ? oEnrollmentPlan.ForecastGMofNSRatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ForecastGrossMarginofNSR__c != null ? oEnrollmentPlan.ForecastGrossMarginofNSR__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ForecastGMofNSRVariance__c != null ? oEnrollmentPlan.ForecastGMofNSRVariance__c.format(): '');
            mtw.tdclass='percent';
            listForecasted.add(mtw);
        }
        if(bNMPlan){
            mtw = new metricTableRowWrapper();
            mtw.label = 'Forecast NM% of NSR';
            mtw.column1Val = (oEnrollmentPlan.ForecastNMofNSRatSnapshot__c != null ? oEnrollmentPlan.ForecastNMofNSRatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ForecastNetMarginofNSR__c != null ? oEnrollmentPlan.ForecastNetMarginofNSR__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ForecastNMofNSRVariance__c != null ? oEnrollmentPlan.ForecastNMofNSRVariance__c.format(): '');
            mtw.tdclass='percent';
            listForecasted.add(mtw);
        }
        if(!fromEnrollPart){
            mtw = new metricTableRowWrapper();
            mtw.label = 'Forecast Salary Cost Multiplier';
            mtw.column1Val = (oEnrollmentPlan.ForecastSalaryCMatSnapshot__c != null ? oEnrollmentPlan.ForecastSalaryCMatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ForecastSalaryCostMultiplier__c != null ? oEnrollmentPlan.ForecastSalaryCostMultiplier__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ForecastSalaryCMVariance__c != null ? oEnrollmentPlan.ForecastSalaryCMVariance__c.format(): '');
            listForecasted.add(mtw);
            mtw = new metricTableRowWrapper();
            mtw.label = 'Forecast Labor Cost Multiplier';
            mtw.column1Val = (oEnrollmentPlan.ForecastDirectLMatSnapshot__c != null ? oEnrollmentPlan.ForecastDirectLMatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ForecastDirectLaborMultiplier__c != null ? oEnrollmentPlan.ForecastDirectLaborMultiplier__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ForecastDirectLaborMultiplierVariance__c != null ? oEnrollmentPlan.ForecastDirectLaborMultiplierVariance__c.format(): '');
            listForecasted.add(mtw);
            mtw = new metricTableRowWrapper();
            mtw.label = 'Total Cost Forecast';
            mtw.column1Val = (oEnrollmentPlan.ForecastCostBudgetatSnapshot__c != null ? oEnrollmentPlan.ForecastCostBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ForecastCostBudget__c != null ? oEnrollmentPlan.ForecastCostBudget__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ForecastCostBudgetVariance__c != null ? oEnrollmentPlan.ForecastCostBudgetVariance__c.format(): '');
            mtw.sClass = 'importantrow';
            listForecasted.add(mtw);
        }
    }   

    private void buildAtualsList(){
        listActuals = new list<metricTableRowWrapper>();
        metricTableRowWrapper mtw = new metricTableRowWrapper();
        mtw.label = 'Gross Revenue';
        mtw.column1Val = (oEnrollmentPlan.ActualGrossRevenueatSnapshot__c != null ? oEnrollmentPlan.ActualGrossRevenueatSnapshot__c.format() : '');
        mtw.currentVal = (oEnrollmentPlan.ActualGrossRevenueITD__c != null ? oEnrollmentPlan.ActualGrossRevenueITD__c.format():'');
        mtw.Variance = (oEnrollmentPlan.ActualGrossRevenueVariance__c != null ? oEnrollmentPlan.ActualGrossRevenueVariance__c.format(): '');
        mtw.sClass = 'importantrow';
        listActuals.add(mtw);
        if(!fromEnrollPart){
            mtw = new metricTableRowWrapper();
            mtw.label = 'Contingency';
            mtw.column1Val = (oEnrollmentPlan.ActualContingencyBudgetatSnapshot__c != null ? oEnrollmentPlan.ActualContingencyBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ActualContingencyBudgetITD__c != null ? oEnrollmentPlan.ActualContingencyBudgetITD__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ActualContingencyBudgetVariance__c != null ? oEnrollmentPlan.ActualContingencyBudgetVariance__c.format(): '');
            listActuals.add(mtw);
            mtw = new metricTableRowWrapper();
            mtw.label = 'ODC (excl Subs)';
            mtw.column1Val = (oEnrollmentPlan.ActualODCBudgetatSnapshot__c != null ? oEnrollmentPlan.ActualODCBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ActualODCBudgetITD__c != null ? oEnrollmentPlan.ActualODCBudgetITD__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ActualODCBudgetVariance__c != null ? oEnrollmentPlan.ActualODCBudgetVariance__c.format(): '');
            listActuals.add(mtw);
            mtw = new metricTableRowWrapper();
            mtw.label = 'Subconsultants';
            mtw.column1Val = (oEnrollmentPlan.ActualSubsBudgetatSnapshot__c != null ? oEnrollmentPlan.ActualSubsBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ActualSubsBudgetITD__c != null ? oEnrollmentPlan.ActualSubsBudgetITD__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ActualSubsBudgetVariance__c != null ? oEnrollmentPlan.ActualSubsBudgetVariance__c.format(): '');
            listActuals.add(mtw);
        }
        mtw = new metricTableRowWrapper();
        mtw.label = 'Net Service Revenue';
        mtw.column1Val = (oEnrollmentPlan.ActualNSRBudgetatSnapshot__c != null ? oEnrollmentPlan.ActualNSRBudgetatSnapshot__c.format() : '');
        mtw.currentVal = (oEnrollmentPlan.NSRBudget__c != null ? oEnrollmentPlan.NSRBudget__c.format():'');
        mtw.Variance = (oEnrollmentPlan.ActualNSRBudgetVariance__c != null ? oEnrollmentPlan.ActualNSRBudgetVariance__c.format(): '');
        mtw.sClass = 'importantrow';
        listActuals.add(mtw);
        if(!fromEnrollPart){
            mtw = new metricTableRowWrapper();
            mtw.label = 'Labor';
            mtw.column1Val = (oEnrollmentPlan.ActualDirectLaboratSnapshot__c != null ? oEnrollmentPlan.ActualDirectLaboratSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ActualDirectLaborITD__c != null ? oEnrollmentPlan.ActualDirectLaborITD__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ActualDirectLaborVariance__c != null ? oEnrollmentPlan.ActualDirectLaborVariance__c.format(): '');
            listActuals.add(mtw);
            mtw = new metricTableRowWrapper();
            mtw.label = 'Fringe';
            mtw.column1Val = (oEnrollmentPlan.ActualFringeBudgetatSnapshot__c != null ? oEnrollmentPlan.ActualFringeBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ActualFringeBudgetITD__c != null ? oEnrollmentPlan.ActualFringeBudgetITD__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ActualFringeBudgetVariance__c != null ? oEnrollmentPlan.ActualFringeBudgetVariance__c.format(): '');
            listActuals.add(mtw);
            mtw = new metricTableRowWrapper();
            mtw.label = 'Direct Personnel Expense (DPE)';
            mtw.column1Val = (oEnrollmentPlan.ActualDPEBudgetatSnapshot__c != null ? oEnrollmentPlan.ActualDPEBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ActualDPEBudgetITD__c != null ? oEnrollmentPlan.ActualDPEBudgetITD__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ActualDPEBudgetVariance__c != null ? oEnrollmentPlan.ActualDPEBudgetVariance__c.format(): '');
            mtw.sClass = 'importantrow';
            listActuals.add(mtw);
        }
        if(!bNMPlan){
            mtw = new metricTableRowWrapper();
            mtw.label = 'Gross Margin';
            mtw.column1Val = (oEnrollmentPlan.ActualGMBudgetatSnapshot__c != null ? oEnrollmentPlan.ActualGMBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ActualGrossMarginITD__c != null ? oEnrollmentPlan.ActualGrossMarginITD__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ActualGMBudgetVariance__c != null ? oEnrollmentPlan.ActualGMBudgetVariance__c.format(): '');
            mtw.sClass = 'importantrow';
            listActuals.add(mtw);
        }
        if(!fromEnrollPart){
            mtw = new metricTableRowWrapper();
            mtw.label = 'Overhead';
            mtw.column1Val = (oEnrollmentPlan.ActualOverheadITDatSnapshot__c != null ? oEnrollmentPlan.ActualOverheadITDatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ActualOverheadITD__c != null ? oEnrollmentPlan.ActualOverheadITD__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ActualOverheadBudgetVariance__c != null ? oEnrollmentPlan.ActualOverheadBudgetVariance__c.format(): '');
            listActuals.add(mtw);
        }
        if(bNMPlan){
            mtw = new metricTableRowWrapper();
            mtw.label = 'Net Margin';
            mtw.column1Val = (oEnrollmentPlan.ActualNetMarginatSnapshot__c != null ? oEnrollmentPlan.ActualNetMarginatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ActualNetMarginITD__c != null ? oEnrollmentPlan.ActualNetMarginITD__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ActualNetMarginVariance__c != null ? oEnrollmentPlan.ActualNetMarginVariance__c.format(): '');
            mtw.sClass = 'importantrow';
            listActuals.add(mtw);
        }
        if(!bNMPlan){
            mtw = new metricTableRowWrapper();
            mtw.label = 'GM% of NSR';
            mtw.column1Val = (oEnrollmentPlan.ActualGMofNSRatSnapshot__c != null ? oEnrollmentPlan.ActualGMofNSRatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.AcutalGMofNSRITD__c != null ? oEnrollmentPlan.AcutalGMofNSRITD__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ActualGMofNSRVariance__c != null ? oEnrollmentPlan.ActualGMofNSRVariance__c.format(): '');
            mtw.tdclass='percent';
            listActuals.add(mtw);
        }
        if(bNMPlan){
            mtw = new metricTableRowWrapper();
            mtw.label = 'NM% of NSR';
            mtw.column1Val = (oEnrollmentPlan.ActualNMofNSRatSnapshot__c != null ? oEnrollmentPlan.ActualNMofNSRatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ActualNMofNSRITD__c != null ? oEnrollmentPlan.ActualNMofNSRITD__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ActualNMofNSRVariance__c != null ? oEnrollmentPlan.ActualNMofNSRVariance__c.format(): '');
            mtw.tdclass='percent';
            listActuals.add(mtw);
        }
        if(!fromEnrollPart){
            mtw = new metricTableRowWrapper();
            mtw.label = 'Salary Cost Multiplier';
            mtw.column1Val = (oEnrollmentPlan.ActualSalaryCostMultiplieratSnapshot__c != null ? oEnrollmentPlan.ActualSalaryCostMultiplieratSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ActualSalaryCostMultiplier__c != null ? oEnrollmentPlan.ActualSalaryCostMultiplier__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ActualSalaryCostMultiplierVariance__c != null ? oEnrollmentPlan.ActualSalaryCostMultiplierVariance__c.format(): '');
            listActuals.add(mtw);
            mtw = new metricTableRowWrapper();
            mtw.label = 'Labor Cost Multiplier';
            mtw.column1Val = (oEnrollmentPlan.ActualLaborCMatSnapshot__c != null ? oEnrollmentPlan.ActualLaborCMatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ActualLaborCostMultiplier__c != null ? oEnrollmentPlan.ActualLaborCostMultiplier__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ActualLaborCostMultiplier_Variance__c != null ? oEnrollmentPlan.ActualLaborCostMultiplier_Variance__c.format(): '');
            listActuals.add(mtw);
            mtw = new metricTableRowWrapper();
            mtw.label = 'Total Cost';
            mtw.column1Val = (oEnrollmentPlan.ActualTotalCostBudgetatSnapshot__c != null ? oEnrollmentPlan.ActualTotalCostBudgetatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.ActualTotalCostITD__c != null ? oEnrollmentPlan.ActualTotalCostITD__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ActualTotalCostBudgetVariance__c != null ? oEnrollmentPlan.ActualTotalCostBudgetVariance__c.format(): '');
            mtw.sClass = 'importantrow';
            listActuals.add(mtw);
            mtw = new metricTableRowWrapper();
            mtw.label = 'Project % Complete';
            mtw.column1Val = (oEnrollmentPlan.ITDCostCompleteatSnapshot__c != null ? oEnrollmentPlan.ITDCostCompleteatSnapshot__c.format() : '');
            mtw.currentVal = (oEnrollmentPlan.PercentCompleteCostITD__c != null ? oEnrollmentPlan.PercentCompleteCostITD__c.format():'');
            mtw.Variance = (oEnrollmentPlan.ActualProjectPercentCompleteVariance__c != null ? oEnrollmentPlan.ActualProjectPercentCompleteVariance__c.format(): '');
            mtw.sClass = 'importantrow';
            mtw.tdclass = 'percent';
            listActuals.add(mtw);
        }
        System.Debug(logginglevel.error,'listActuals.size() ' + listActuals.size());
    }        

    private class metricTableRowWrapper{
        public String label {get;set;}
        public String column1Val {get;set;}
        public String currentVal {get;set;}
        public String Variance {get;set;}
        public String imageCol1{get;set;}
        public String imageCol2{get;set;}
        public String sClass{get;set;}
        public String tdclass{get;set;}
        public String labelClass{get;set;}
        public String column2Class{get;set;}
        public metricTableRowWrapper(){
            imageCol1 = '';
            imageCol2 = '';
            sClass='normalRow';
            tdclass='currency';
        }
        
    }
    
}