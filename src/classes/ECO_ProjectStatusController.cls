public with sharing class ECO_ProjectStatusController {

    public pse__Proj__c currentProject{get;set;}
    public String currentRecordId {get;set;}
	public Boolean hasRecords;
    public String locationsResilienceStatus{
        get {
                
                list<ProjectCity__c> lProjectCities = new list<ProjectCity__c>([SELECT id FROM ProjectCity__c WHERE Project__c = :currentRecordId]);
    			if(lProjectCities.size() > 0){
                     return 'Complete';
                     hasRecords = true;	
                }
                return 'NotStarted';
            }
        set;
    }

    public String rmAssessStatus{
        get {
                list<QuestionnaireSet__c> lRMAs = new list<QuestionnaireSet__c>([SELECT id, IsComplete__c FROM QuestionnaireSet__c WHERE Project__c = :currentRecordId ORDER BY GoNoGoDate__c DESC]);

                if(lRMAs.size() == 0)
                    return 'NotStarted';

                for(QuestionnaireSet__c oRMA : lRMAs){
                    if(oRMA.IsComplete__c){
                        return 'Complete';
                    }
                }

                return 'Started';
            }

        set;
    }

    public String goNoGoStatus{
        get{
            String goNoGoStatus = 'Not Started';
            String rmStatus = rmAssessStatus;
            Integer rmCount;
            String locStatus = locationsResilienceStatus;
            Integer locCount;
            //TODO: Assign value to NotStarted = 1, Started  = 2, Completed = 3, Rejected = 0
            //Determine lowest value amongst below and then return as string
            //locationsResilienceStatus
            //rmAssessStatus
            if(rmStatus == 'NotStarted')
                rmCount =1;
            else if(rmStatus == 'Started')
                rmCount = 2;
            else if(rmStatus == 'Complete')
                rmCount = 3;
            else
                rmCount = 0;
            
            if(locStatus == 'NotStarted')
                locCount =1;
            else 
                locCount = 3;
            
            if(locCount < rmCount)
                goNoGoStatus = locStatus;
            else
                goNoGoStatus = rmStatus;
            
            return goNoGoStatus;
        }

        set;
    }

    public String rmAssessDecisionStatus{
        get {
                list<QuestionnaireSet__c> lRMAs = new list<QuestionnaireSet__c>([SELECT id, GoNoGoRecommendation__c, ApprovalStatus__c FROM QuestionnaireSet__c WHERE Project__c = :currentRecordId ORDER BY GoNoGoDate__c DESC, LastModifiedDate DESC]);

                if(lRMAs.size() == 0)
                    return 'NotStarted';

                for(QuestionnaireSet__c oRMA : lRMAs){
                    if(oRMA.ApprovalStatus__c == 'Approved'){

                        if(oRMA.GoNoGoRecommendation__c == 'Go'){
                            return 'Complete';
                        }

                        if(oRMA.GoNoGoRecommendation__c == 'No Go'){
                            return 'Rejected';
                        }
                    }

                    if(oRMA.ApprovalStatus__c == 'Rejected'){
                        return 'Rejected';
                    }

                    if(oRMA.ApprovalStatus__c == 'Pending Approval'){
                        return 'Started';
                    }
                }

                return 'NotStarted';
            }

        set;
    }
    public String contractReviewStatus{
        get{
            List<Agreement__c> lagreements = new List<Agreement__c>([Select id, AgreementStatus__c From Agreement__c where Project__c = :currentRecordId AND RecordType.Name = 'Prime (MSA)']);
            if(lagreements.size()==0)
                return 'Rejected';
            for(Agreement__c oAgreement : lagreements){
                if(oAgreement.AgreementStatus__c == 'Executed')
                    return 'Complete';
                if(oAgreement.AgreementStatus__c == 'In Review' || oAgreement.AgreementStatus__c == 'Under Negotiation')
                    return 'Started';
            }
            return 'Not Started';
        }
        set;
    }
    public String doaManagerStatus{
        get{
            List<DOARegister__c> lRegister = new List<DOARegister__c> ([Select id, DOA_Request_Status__c From DOARegister__c Where Project__c = :currentRecordId]);
			if(lRegister.size()==0)
                return 'Not Started';
            for(DOARegister__c oRegister : lRegister){
                //if(oRegister.DOA_Request_Status__c == 'Not Started')
                //    return 'Not Started';
                if(oRegister.DOA_Request_Status__c == 'Approved')
                    return 'Complete';
                if(oRegister.DOA_Request_Status__c == 'Rejected' || oRegister.DOA_Request_Status__c == 'Cancelled')
                    return 'Rejected';
            }
            return 'Started';
        }
        set;
    }
    public String negotiationProjectPlan{
        get{
            if(currentProject.ProgBarPrelimPlanApproval__c != 'Approved')
                return 'NotStarted';

            if(scheduleWBSStatus == 'Complete' && budgetStatus == 'Complete' && classificationStatus == 'Complete')
                return 'Complete';

            return 'Started';
        }
        set;
    }

    public String projectCreatedInOracle{
        get{
            if(currentProject.pse__Stage__c != 'Pending Go/No Go' && currentProject.pse__Stage__c != 'Planning'){
                return 'Complete';
            }

            if(negotiationProjectPlan == 'Complete'){
                return 'Started';
            }

            return 'NotStarted';
        }
        set;
    }

    public String preliminaryProjectPlan{
        get{
            list<QuestionnaireSet__c> lRMAs = new list<QuestionnaireSet__c>([SELECT id, GoNoGoRecommendation__c, ApprovalStatus__c FROM QuestionnaireSet__c WHERE Project__c = :currentRecordId and ApprovalStatus__c = 'Approved' ORDER BY GoNoGoDate__c DESC, LastModifiedDate DESC]);

            if(lRMAs.size() == 0)
                return 'NotStarted';

            if(scheduleWBSStatus == 'Complete' && budgetStatus == 'Complete' && classificationStatus == 'Complete')
                return 'Complete';

            return 'Started';
        }
        set;
    }
	public String planApprovalStatus {
        get {
            List<pse__Proj__c> lProjects = new List<pse__Proj__c>([Select id, ProgBarPrelimPlanApproval__c From pse__Proj__c Where id = :currentRecordId]);
            String retStatus;
            for(pse__Proj__c oProj :lProjects){
                retStatus = oProj.ProgBarPrelimPlanApproval__c;

                return retStatus;
            }
            return 'NotStarted';
        }
        set;
    }
    public String executeApprovalStatus {
        get {
            List<pse__Proj__c> lProjects = new List<pse__Proj__c>([Select id, ProgressBarExecutionApproval__c From pse__Proj__c Where id = :currentRecordId]);
            String retStatus;
            for(pse__Proj__c oProj :lProjects){
                retStatus = oProj.ProgressBarExecutionApproval__c;

                return retStatus;
            }
            return 'NotStarted';
        }
        set;
    }
    public String preliminaryProjectPlanApprovalStatus{
        get{
            if(currentProject.ProgBarPrelimPlanApproval__c == 'Not Started'){
                return 'NotStarted';
            }else if(currentProject.ProgBarPrelimPlanApproval__c == 'Submitted'){
                return 'Started';
            }else if(currentProject.ProgBarPrelimPlanApproval__c == 'Approved'){
                return 'Complete';
            }else if(currentProject.ProgBarPrelimPlanApproval__c == 'Rejected'){
                return 'Rejected';
            }

            return 'NotStarted';
        }

        set;
    }

    public String scopeApproachStatus {
        get {
            list<Packages__c> lPackages = new list<Packages__c>([SELECT id FROM Packages__c WHERE Scope__c = :currentRecordId]);

            if(lPackages.size() > 0)
                return 'Complete';

            return 'NotStarted';
            }
        set;
    }

    //Not Started = no rows
    //Completed = any rows
    public String riskRegisterStatus {
        get {
            list<Risk__c> lRisk = new List<Risk__c>([SELECT id FROM Risk__c WHERE Project__c = :currentRecordId]);
            if(lRisk.size()>0)
                return 'Complete';
            return 'NotStarted';
        }
        set;
    }

    //Not Started = no rows
    //Started = Any Reviews that are not status complete
    //Completed =  All Reviews complete
    public String reviewMeetingStatus {
        get {
            List<ProjectReview__c> lreviews = new List<ProjectReview__c>([Select id, Status__c From ProjectReview__c where Project__c = :currentRecordId]); 
            if(lreviews.size()==0)
                return 'NotStarted';
            for(ProjectReview__c pReviews : lreviews){
                if(pReviews.Status__c != 'Approved')
                    return 'Started';
            }
            return 'Complete';
        }
        set;
    }

    //Not Started = no rows
    //Completed = any rows
    public String scheduleWBSStatus {
        get {
            List<pse__Project_Task__c> lProjectTask = new List<pse__Project_Task__c>([Select id From pse__Project_Task__c where pse__Project__c = :currentRecordId]);
            if(lProjectTask.size()==0)
                return 'NotStarted';
            else
                return 'Complete';
        }
        set;
    }

    //Not Started = no rows
    //Started = Any Deliverables that are not status complete
    //Completed =  All Deliverables complete
    public String deliverableStatus {
        get {
            List<Deliverable__c> lDeliverables = new List<Deliverable__c>([Select id, Status__c From Deliverable__c where Project__c = :currentRecordId]);
            if(lDeliverables.size()==0)
                return 'NotStarted';
            for(Deliverable__c oDelivs : lDeliverables){
                if(oDelivs.Status__c != 'Review Complete')
                    return 'Started';
            }
            return 'Complete';
        }
        set;
    } 

    //Not Started = no rows
    //Started = No one budget row is equal to approved
    //Completed =  At least one budget row is equal to approved
    public String budgetStatus {
        get {
            List<BudgetHeader__c> lBudgets = new List<BudgetHeader__c>([Select id, Status__c FROM BudgetHeader__c where Project__c = :currentRecordId]);
            if(lBudgets.size()==0)
                return 'NotStarted';
            for(BudgetHeader__c pBudget : lBudgets){
                if(pBudget.Status__c != 'Approved')
                    return 'Started';
            }
            return 'Complete';
        }
        set;
    }

    //Return Document Management Status field 
    // project object, field: DocManagementCompleted__c
    public String documentMgmtStatus { 

        get {
            List<pse__Proj__c> lProjects = new List<pse__Proj__c>([Select id, DocManagementCompleted__c From pse__Proj__c Where id = :currentRecordId]);
            String retStatus;
            for(pse__Proj__c oProj :lProjects){
                retStatus = oProj.DocManagementCompleted__c;
            }
            return retStatus;
        }
        set;
    }

    //Not Started = no rows
    //Completed = any rows
    public String agreementStatus {
        get {
            List<Agreement__c> lagreements = new List<Agreement__c>([Select id From Agreement__c where Project__c = :currentRecordId]);
            if(lagreements.size()==0)
                return 'NotStarted';
            else 
                return 'Complete';
        }
        set;
    }
	
    //Return HealthEnv Status field
    public String safeHealthEnvStatus {
        get {
            List<pse__Proj__c> lProjects = new List<pse__Proj__c>([Select id, SafetyHealthCompleted__c From pse__Proj__c Where id = :currentRecordId]);
            String retStatus;
            for(pse__Proj__c oProj :lProjects){
                retStatus = oProj.SafetyHealthCompleted__c;

                return retStatus;
            }
            return 'NotStarted';
        }
        set;
    }
	public String healthyStartStatus {
        get {
            List<ProjectReview__c> lProjReview = new List<ProjectReview__c>([Select id, Status__c From ProjectReview__c Where Project__c = :currentRecordId AND RecordType.Name = 'Healthy Start/Restart']);
            if(lProjReview.size()==0)
            	return 'NotStarted';
            for(ProjectReview__c oProjReview : lProjReview){
                if(oProjReview.Status__c=='Assessing' || oProjReview.Status__c=='In Progress' || oProjReview.Status__c=='Submitted')
                    return 'Started';
                if(oProjReview.Status__c == 'Approved')
                    return 'Complete';
                if(oProjReview.Status__c == 'Rejected')
                    return 'Rejected';
            }
            return 'Not Started';
        }
        set;
    }
    //Not Started = no required fields entered
    //Started = Any but all required fields entered
    //Completed =  All required fields entered
    //To determine required fields use field set reference ECO_ClassificationEditor page and controller
    public String classificationStatus {
        get {
            pse__Proj__c oProject = currentProject;
            List<OrganizationString__c> lOrganizationStrings = new List<OrganizationString__c>();
            OrganizationString__c oOrganizationString = new OrganizationString__c();
            
            if (oProject.CarryingOutOrganization__c != NULL) {
                String sSOQL = 'SELECT id';
                for (FieldSetMember oFSM : SObjectType.pse__Proj__c.FieldSets.Project_Classifications.getFields()) {
                    sSOQL += ', ' + oFSM.getFieldPath();
                }
                sSOQL += ' FROM OrganizationString__c';
                sSOQL += ' WHERE Id = \'' + oProject.CarryingOutOrganization__c + '\''; 
                System.debug(sSOQL);
                lOrganizationStrings = Database.query(sSOQL);
            }

            if (lOrganizationStrings.size() > 0) {
                system.debug('Has Classification');

                oOrganizationString = lOrganizationStrings.get(0);
            } else {
                return 'NotStarted';
            }

            boolean bHasAllValue = true;
            boolean bHasOneValue = false;
            for (FieldSetMember oFSM : SObjectType.pse__Proj__c.FieldSets.Project_Classifications.getFields()) {
                String sOrganizationStringValue = (String) oOrganizationString.get(oFSM.getFieldPath());

                system.debug('Checking Field ' + oFSM.getFieldPath() + ' with value ' + sOrganizationStringValue);

                if (sOrganizationStringValue == 'Require') {
                    string sValue = ECO_Utils_String.NullCheck((string)currentProject.get(oFSM.getFieldPath()));

                    if(sValue == ''){
                        bHasAllValue = false;
                    }
                    else{
                        bHasOneValue = true;
                    }
                }
            }

            if(bHasAllValue){
                return 'Complete';
            }

            if(bHasOneValue){
                return 'Started';
            }

            return 'NotStarted';
        }
        set;
    }

    //Not Started = No Key Members
    //Started = Any but not all key members active
    //Complated = All Key Members Active
    public String projTeamStakeStatus {
        get {
            List<ProjectTeamMember__c> lKeyMember = new List<ProjectTeamMember__c>([Select id, Active__c, ProjectRole__r.Type__c, ProjectRole__r.Name From ProjectTeamMember__c Where ProjectRole__r.Type__c = 'Key Member' And Project__c = :currentRecordId And Active__c = true ORDER BY ProjectRole__r.Type__c ASC]);
            Map<String,String> roleMap = new Map<String, String>();
            Map<String,String> teamMap = new Map<String,String>();
            for(ProjectRole__c oRole: [Select Name,Type__c From ProjectRole__c Where Type__c = 'Key Member' ORDER BY Name ASC]){
                roleMap.put(oRole.Name, oRole.Type__c);
            }
            for(ProjectTeamMember__c oTeam : lKeyMember){
                teamMap.put(oTeam.ProjectRole__r.Name, oTeam.ProjectRole__r.Type__c);
            }
            if(lKeyMember.size()==0)
                return 'NotStarted';
            if(teamMap.size()==roleMap.size())
                return 'Complete';
            return 'Started';
        }
        set;
    }

    //Not Started = no rows
    //Completed = any rows
    public String subsVendorStatus {
        get {
            List<VendorSite__c> lVendor = new List<VendorSite__c>([Select id From VendorSite__c Where Project__c = :currentRecordId]);
            if(lVendor.size()==0)
                return 'NotStarted';
            else
                return 'Complete';
        }
        set;
    }

    //Not Started = no changes detected and no change manager rows. 
    //Rejected = change detected but no records submitted.  check Michael
    //Started = Change manager submitted but not yet approved -- Change__c, field: ApprovalStatus__c
    //Completed = No changes detected and more then one change manager entry -- atleast one change manager row
    //Object: Change__c, field: ApprovalStatus__c
    public String changeMgmtStatus {
        get {
            Boolean retStatus;
            List<ChangeManager__c> lChanges = new List<ChangeManager__c>([Select id, ApprovalStatus__c From ChangeManager__c Where Project__c = :currentRecordId]);
            if(lChanges.size()==0)
                return 'NotStarted';
            for(ChangeManager__c oChanges :lChanges){
                if(oChanges.ApprovalStatus__c != 'Approved' || oChanges.ApprovalStatus__c!='Auto Approved')
                    return 'Started';
                
                retStatus = ECO_ChangeManager_Service.hasUnsubmittedProjectChanges(currentRecordId);
            if(retStatus == false)
                return 'Complete';
            
            }
            return 'Rejected';
        }
        set;
    }  

    //Check : Michael
    //Not Started = current weeks earned value does not exist
    //Started = current weeks earned value is created but not committed
    //Completed = current weeks earned value is set to committed
    public String earnedValueStatus {
        get {
            Date todayDate = date.today();
            Date startDate = todayDate.toStartOfWeek();
            List<EarnedValueHeader__c> lEarnedVal = new List<EarnedValueHeader__c>([Select id, SnapshotDate__c, Committed__c From EarnedValueHeader__c Where SnapshotDate__c =:startDate AND Project__c =:currentProject.id]);
            if(lEarnedVal.size() == 0)
                return 'NotStarted';
            for(EarnedValueHeader__c oEarnedVal : lEarnedVal){
                if(oEarnedVal.Committed__c == false)
                    return 'Started';
            }
            return 'Complete';
        }
        set;
    }
    public String monthlyReviewStatus {
        get {
            Date todayDate = date.today();
            Date startDate = todayDate.toStartOfMonth();
            String monthStatus  = '';
            String performanceStatus = '';
            Boolean startofMonth;
            if(todayDate==startDate)
                startofMonth = true;
            List<ProjectReview__c> lMonthReview = new List<ProjectReview__c>(
                								[Select id, Status__c 
                                                 From ProjectReview__c 
                                                 Where Project__c = :currentRecordId 
                                                 AND RecordType.Name = 'Monthly Project Review']);
            List<ProjectReview__c> lPerformanceReview = new List<ProjectReview__c>(
                								[Select id, Status__c 
                                                 From ProjectReview__c 
                                                 Where Project__c = :currentRecordId 
                                                 AND RecordType.Name = 'Project Performance Review']);
            for(ProjectReview__c oProjReview : lMonthReview){
                if(oProjReview.Status__c == 'Not Started')
					monthStatus = monthStatus + 'N';  
                if(oProjReview.Status__c == 'Assessing' || oProjReview.Status__c == 'In Progress' || oProjReview.Status__c == 'Submitted')
					monthStatus = monthStatus + 'S';  
                if(oProjReview.Status__c == 'Approved')
					monthStatus = monthStatus + 'C'; 
                if(oProjReview.Status__c == 'Rejected')
					monthStatus = monthStatus + 'R'; 
            }
            System.debug('Month Status :' +monthStatus);
            for(ProjectReview__c oProjReview : lPerformanceReview){
                if(oProjReview.Status__c == 'Not Started')
					performanceStatus = performanceStatus + 'N';  
                if(oProjReview.Status__c == 'Assessing' || oProjReview.Status__c == 'In Progress' || oProjReview.Status__c == 'Submitted')
					performanceStatus = performanceStatus + 'S';  
                if(oProjReview.Status__c == 'Approved')
					performanceStatus = performanceStatus + 'C'; 
                if(oProjReview.Status__c == 'Rejected')
					performanceStatus = performanceStatus + 'R'; 
            }
            System.debug('Performance Status :' +performanceStatus);
            if((monthStatus == '' && performanceStatus == '')||
               ( String.isblank(monthStatus.remove('N')) && String.isblank(performanceStatus.remove('N'))) )
            	return 'NotStarted';
            else if(monthStatus.contains('R') || performanceStatus.contains('R'))
                return 'Rejected';
            else if (String.isblank(monthStatus.remove('C')) && String.isblank(performanceStatus.remove('C')))
                return 'Complete';
            else
                return 'Started';
            
        }
        set;
    }
    
    public String performanceDashboardStatus {get {return 'NotStarted';}set;}
    
    //Confirm with Michael: Proj__C object, field: RequestedProjectStatus__c,  change manager obj, field: IntExtProjectOnHold__c. Approved
    public String projectCloseHoldStatus {get {return 'NotStarted';}set;}
    
    
    public ECO_ProjectStatusController(ApexPages.StandardController controller){
        List<String> lClassificationPathNames = new List<String>();
        lClassificationPathNames.add('CarryingOutOrganization__c');
        for (FieldSetMember oFSM : SObjectType.pse__Proj__c.FieldSets.Project_Classifications.getFields()) {
            lClassificationPathNames.add(oFSM.getFieldPath());
        }

        lClassificationPathNames.add('ProgBarPrelimPlanApproval__c');
        lClassificationPathNames.add('pse__Stage__c');

        controller.addFields(lClassificationPathNames);

        currentProject = (pse__Proj__c)controller.getRecord();
        currentRecordId = currentProject.Id;
    }
    public PageReference healthyStartClicked() 
    {
        PageReference redirect;
        String pageRefNew='';
        String pageRefExist = '';
        Id recId;
        List<ProjectReview__c> lHeathyStart = new List<ProjectReview__c>(
                								[Select id, RecordTypeId, IsOpen__c 
                                                 From ProjectReview__c 
                                                 Where Project__c = :currentRecordId 
                                                 AND RecordType.Name = 'Healthy Start/Restart']);
        //Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Development').getRecordTypeId();
        Id recTypeId = Schema.SObjectType.ProjectReview__c.getRecordTypeInfosByName().get('Healthy Start/Restart').getRecordTypeId();
        for(ProjectReview__c oProjReview :lHeathyStart ){
            if(oProjReview.IsOpen__c == true)
                recId = oProjReview.Id;
        }
        pageRefNew = 'apex/ECO_ProjectReviews?ProjectId='+currentRecordId+'&RecordTypeId='+recTypeId;
        pageRefExist = 'apex/ECO_ProjectReviews?id='+recId+'&sfdc.override=1';
        if(recId != null)
            redirect = new PageReference(pageRefExist);
        else
            redirect = new PageReference(pageRefNew);
        System.debug('lHeathyStart.size():   '+lHeathyStart.size());
        System.debug('recTypeId :'+recTypeId);
        return redirect;
        
    }
    public PageReference locationClicked() 
    {
            PageReference redirect = new PageReference('/apex/ECO_Resilience?scontrolCaching=1&id='+currentProject.id); 
            return redirect;
    }
    public PageReference rmAssessClicked() 
    {
            PageReference redirect = new PageReference('/apex/ECO_RMAChooser?id='+currentProject.id); 
            return redirect;
    }
    public PageReference scopeApproach() 
    {
            PageReference redirect = new PageReference('/apex/ECO_ProjectScope?projectId='+currentProject.id); 
            return redirect;
    }
    public PageReference riskRegister() 
    {
            PageReference redirect = new PageReference('/apex/ECO_RiskRegister?projectId='+currentProject.id); 
            return redirect;
    }
    public PageReference reviewRegister() 
    {
            PageReference redirect = new PageReference('/apex/ECO_ProjectReviewRecordType?ProjectId='+currentProject.id); 
            return redirect;
    }
    
    public PageReference scheduleWBS() 
    {
            PageReference redirect = new PageReference('/apex/psa__psatasks?id='+currentProject.id); 
            return redirect;
    }
    public PageReference budget() 
    {
            PageReference redirect = new PageReference('/apex/ECO_BudgetGrid2?id='+currentProject.id); 
            return redirect;
    }
    
    public PageReference docMgmt() 
    {
            PageReference redirect = new PageReference('/apex/ECO_DocumentManagement?scontrolCaching=1&id='+currentProject.id); 
            return redirect;
    }
    public PageReference safetyHealthEnv() 
    {
            PageReference redirect = new PageReference('/apex/ECO_SafetyHealthEnvironment?scontrolCaching=1&id='+currentProject.id); 
            return redirect;
    }
    public PageReference classifications() 
    {
            PageReference redirect = new PageReference('/apex/ECO_ClassificationEditor?scontrolCaching=1&id='+currentProject.id); 
            return redirect;
    }
    public PageReference projectStake() 
    {
            PageReference redirect = new PageReference('/apex/ECO_Stakeholders?scontrolCaching=1&id='+currentProject.id); 
            return redirect;
    }
    public PageReference subsVendors() 
    {
            PageReference redirect = new PageReference('/apex/ECO_SubsVendors?scontrolCaching=1&id='+currentProject.id); 
            return redirect;
    }
    public PageReference changeMgmt() 
    {
            PageReference redirect = new PageReference('/apex/ECO_ProjectChangeManager?scontrolCaching=1&id='+currentProject.id); 
            return redirect;
    }   
    public PageReference earnedValue() 
    {
            PageReference redirect = new PageReference('/apex/ECO_EarnedValueReport2?scontrolCaching=1&id='+currentProject.id); 
            return redirect;
    }
    public PageReference projCloseHold() 
    {
            PageReference redirect = new PageReference('/apex/ECO_CloseoutProjectApprovalPhase?scontrolCaching=1&id='+currentProject.id); 
            return redirect;
    }
}