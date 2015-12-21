public with sharing class ECO_ProjectSetupController {

    public list<Project_Site__c> lstProjectSites {get;set;}
    public list<SiteWrapper> lstSites {get;set;}
    public list<Site__c> lstSitesSearchResults {get;set;}
    public list<pse__Proj__c> listSimilarProjects {get;set;}
    public list<opportunity> lstSearchOpportunities {get;set;}
    public list<OrganizationString__c> lOrganizations {get; set;}
    public list<OrganizationString__c> lUserOrganizations {get; set;}
    public list<OrganizationWrapper> lSelectedOrganizations {get; set;}
    public list<SelectOption> loGeographies {get; set;}
    public list<SelectOption> loRegions {get; set;}
    public list<SelectOption> loDistricts {get; set;}
    public list<SelectOption> loBusinessLines {get; set;}
    public list<SelectOption> loDepartments {get; set;}
    public list<SelectOption> loLocations {get; set;}
    public list<SelectOption> loProjOwnings {get; set;}
    public list<oppClone> lstOppClone {get; set;}

    public map<id, SiteWrapper> mapSites {get;set;}
    public map<id, SiteWrapper> mapSitesBilling {get;set;}
    public map<id, SiteWrapper> mapSitesEnd {get;set;}
    public map<id, Site__c> mapSearchSites {get;set;}
    public map<string, Site__c> mapUniqueSites {get;set;}
    public map<id, opportunity> mapOpportunitySearch {get;set;}
    public map<id, OrganizationWrapper> mapOrganizationIdToProjectOrganization {get;set;}
    public map<id, OrganizationString__c> mapOrganizationString {get;set;}

    public pse__Proj__c oProject {get;set;} 
    public Site__c oSite {get;set;}
    public siteSearchWrapper oSiteSearch {get;set;}
    public ProjectOrganization__c oProjectOrganization {get; set;}
    public OrganizationString__c oPrimaryOrganization {get; set;}

    public id idSiteID {get;set;}
    public integer iSiteRowDelete {get;set;}
    public id sSelectedOpportunityId {get;set;}
    public string strSearchResults {get;set;}
    public string sOrganizationName {get; set;}
    public string sGeographyName {get; set;}
    public string sRegion {get; set;}
    public string sDistrict {get; set;}
    public string sBusinessLine {get; set;}
    public string sDepartment {get; set;}
    public string sLocation {get; set;}
    public string sProjOwning {get; set;}
    public string sSelectedOrganizationId {get; set;}
    public string tabState {get;set;}

    public OrganizationString__c userOrg {get;set;}

    public boolean boolShowSiteSearch {get;set;}
    public boolean booDisplaySiteSearchResult {get;set;}
    public boolean booDisplayOpportunitySearch {get;set;}
    public boolean booShowProjectInput {get;set;}
    public boolean boolNameAttempted{get;set;}
    public boolean bSearchInProgress {get; set;}
    public boolean bProjectFilled {get; set;}
    public boolean bOppSelected {get; set;}
    public boolean bSearchOutsideUserOrg {get;set;}

    public string oppName {get;set;}

    public Integer intNumIsBilling;
    public Integer intNumIsEnd;

    private SiteWrapper oTopTask;
    public SiteWrapper oPrimaryEnd {get;set;}
    public SiteWrapper oPrimaryEnd1 {get;set;}

    private string lastSaveAttemptName;
    
    private string sSiteLimit;
    private integer iOrgLimit;

    private boolean bSiteMore;
    private boolean bOrgMore;

    public boolean bShowMoreButtonSite {get;set;}
    public boolean bShowMoreButtonOrg {get;set;}

    public string showMoreSiteText {get;set;}
    public string showMoreOrgText {get;set;}

    private static string siteLessLIMIT = '50';
    private static string siteMoreLIMIT = '200';

    private static integer orgLessLIMIT = 20;
    private static integer orgMoreLIMIT = 200;

    public boolean tab2enabled {get;set;}

    public List<SelectOption> opportunityRecType {get;set;}
    public string idSelectedOppRecType {get;set;}


    /* Custom classes to facilitate this controller */
    public class EcoControllerException extends Exception {}

    /* Custom Class used to add more options for the sites object */
    public class SiteWrapper {
        public Site__c oSite {get;set;}
        public String strType {get;set;}
        public string billingContact {get;set;}
        public integer contributions {get;set;}

        public boolean booIsBilling {get;set;}
        public boolean booIsDefaultTopTask {get;set;}
        public boolean booIsEnd {get;set;}
        public boolean booIsPrimaryEnd {get;set;}
        public map<string, string> oidmap {get;set;}

        public  list<SelectOption> contacts { get; set; }

        public SiteWrapper(Site__c oTargetSite){
            this.oSite = oTargetSite;
            booIsBilling = false;
            booIsDefaultTopTask = false;
            booIsEnd = false;
            booIsPrimaryEnd = false;

            contacts = new List<SelectOption>();

            oidmap = new map<string, string>();

            for(contact c:[select id, lastname, firstname, Oracle_ID__c from contact where site__c =: oTargetSite.id]){
                contacts.add(new SelectOption(c.Oracle_ID__c, c.lastname + ', ' + c.firstname));
                oidmap.put(c.Oracle_ID__c, c.id);
            }

            contributions = 0;

        }
    }

    /* Custom Class used to add more options for the organization object */
    public class OrganizationWrapper {
        public OrganizationString__c oOrganization {get;set;}
        public ProjectOrganization__c oProjectOrganization {get;set;}
        public String strType {get;set;}
        public integer ContributionPercent {get;set;}
        

        public OrganizationWrapper(OrganizationString__c oTargetOrganization){
            this.oOrganization = oTargetOrganization;
            oProjectOrganization = new ProjectOrganization__c();
        }
    }

    public class oppClone {
        public string id {get;set;}
        public string acctName {get;set;}
        public string oppName {get;set;}
        public string oppNumber {get;set;}
        public string stage {get;set;}
        public string type {get;set;}
        public string value {get;set;}
        public string capManager {get;set;}
        public string createdDate {get;set;}
    }


    private void showMoreSites(){
        showMoreSiteText = 'Show Less';
        sSiteLimit = siteMoreLIMIT;
        bSiteMore = true;
    }

    private void showLessSites(){
        showMoreSiteText = 'Show More';
        sSiteLimit = siteLessLIMIT;
        bSiteMore = false;
    }

    private void showMoreOrg(){
        showMoreOrgText = 'Show Less';
        iOrgLimit = orgMoreLIMIT;
        bOrgMore = true;
    }

    private void showLessOrg(){
        showMoreOrgText = 'Show More';
        iOrgLimit = orgLessLIMIT;
        bOrgMore = false;
    }

    public void toggleSiteShow(){
        If(bSiteMore){
            showLessSites();
            SearchSites();
        } else {
            showMoreSites();
            SearchSites();
        }
    }

    public void toggleOrgShow(){
        If(bOrgMore){
            showLessOrg();
            SearchOrganizations();
        } else {
            showMoreOrg();
            SearchOrganizations();
        }
    }

    public class siteSearchWrapper{
        public string name {get;set;}
        public string city {get;set;}
        public string country {get;set;}
        public string province {get;set;}

        public siteSearchWrapper(){
            name = null;
            city = null;
            country = null;
            province = null;
        }

    }

    /* Constructor */
    public ECO_ProjectSetupController(ApexPages.StandardController oStandardController) {
        oSite = new Site__c();
        oSite.account__r = new account();
        oSiteSearch = new siteSearchWrapper();


        oProjectOrganization = new ProjectOrganization__c();

        this.oProject = (pse__Proj__c)oStandardController.getRecord();


        oTopTask = null;
        oPrimaryEnd = null;

        ResetValues();

        //lSelectedOrganizations = oProject.ProjectOrganizations__r;

        sOrganizationName = '';
        sGeographyName = '';
        sRegion = '';
        sDistrict = '';
        sBusinessLine = '';
        sDepartment = '';
        sLocation = '';
        sProjOwning = '';

        sSelectedOrganizationId = '';
        bSearchInProgress = false;
        bSearchOutsideUserOrg = false;
        tab2enabled = false;
        //isValid();
        //SearchOrganizations();

        lSelectedOrganizations = new list<OrganizationWrapper>();
        lUserOrganizations = new list<OrganizationString__c>();
        mapOrganizationString = new map<id, OrganizationString__c>();
        mapOrganizationIdToProjectOrganization = new map<id, OrganizationWrapper>();
        lstSites = new list<SiteWrapper>();
        mapSites = new map<id, SiteWrapper>();
        mapSitesBilling = new map<id, SiteWrapper>();
        mapSitesEnd = new map<id, SiteWrapper>();
        mapSearchSites = new map<id, Site__c>();
        lstOppClone = new list<oppClone>();
        tabState = 'name1';
        bProjectFilled = false;
        bOppSelected = false;

        sSiteLimit = siteLessLIMIT;
        iOrgLimit = orgLessLIMIT;

        bSiteMore = false;
        bOrgMore = false;

        bShowMoreButtonSite = false;
        bShowMoreButtonOrg = false;

        showMoreSiteText = 'Show More';
        showMoreOrgText = 'Show More';

        oppName = null;

        opportunityRecType = new List<SelectOption>();

        opportunityRecType.add(new SelectOption('', 'None'));
        for(recordtype r:[select id, name from recordtype where SobjectType = 'Opportunity']){
            opportunityRecType.add(new SelectOption(r.id, r.name));
        }        

        idSelectedOppRecType = null;

        SearchOrganizations();
        SearchUserOrganization();
    }

    public void SearchUserOrganization(){

        list<user> lUser = [SELECT ECO_OrganizationName__c FROM User WHERE ID =:UserInfo.getUserId()];

        lUserOrganizations = [SELECT Id, Name, OrganizationName__c, GeographyName__c, Region__c, District__c, Department__c, BusinessLineName__c, LocationName__c, PLManagerContact__c, ProjectOwning__c, FinanceandAccountingManagerContact__c, CFOorDelegateContact__c, OUID__c, CurrencyIsoCode, ProjectApprover__c, ProjectAccountant__c, ProjectAccountant2__c, FinanceLead2__c FROM OrganizationString__c WHERE Name =: lUser[0].ECO_OrganizationName__c and ProjectOwning__c=true and (InactiveDate__c > TODAY OR InactiveDate__c = null)];

        if(lUserOrganizations.size() > 0){
            userOrg = lUserOrganizations[0];
        } else {
            userOrg = null;
        }

        for(OrganizationString__c SearchOrganiation: lUserOrganizations){
            mapOrganizationString.put(SearchOrganiation.id, SearchOrganiation);
        }        
    }


    /* Executes the request to handle dynamics parameters and query Sites */
    public PageReference SearchSites(){

        ResetValues();

        if((userOrg == null || userOrg.OUID__c == null) && bSearchOutsideUserOrg == false){
            return null;
        }

        system.debug('** GOT HERE: ' + userOrg);

        oSite.Account__r.name = oSiteSearch.name; 
        oSite.City__c = oSiteSearch.city;
        oSite.Country__c = oSiteSearch.country;       
        oSite.State__c = oSiteSearch.province;

        string oracleRTFilter = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Oracle Only').getRecordTypeId();
        string strSOQL = 'SELECT ';
        string strWhereClause = ' WHERE '; 
        boolean boolAtLeastOne = false;
            
        for (Schema.FieldSetMember fsmField: SObjectType.Site__c.FieldSets.pse_ClientFinder_Search_Result_Fieldset.getFields()) {
            strSOQL += fsmField.getFieldPath() + ', ';
        }
        
        strSOQL += 'ID, Account__c, OracleCustomerID__c, CustomerSiteUseCode__c, OUID__c, name, Account__r.Account_Manager__r.Employee_ID__c FROM Site__c';

        for (Schema.FieldSetMember fsmField: SObjectType.Site__c.FieldSets.pse_ClientFinder_Search_Fieldset.getFields()) {
            
            // Only add parameters to the "WhereClause" string if they contain valid values. 
            // NOTE: only strings are supported by this code.
            if ( recursiveGet(oSite,fsmField.getFieldPath()) != null && recursiveGet(oSite,fsmField.getFieldPath()) != '') {
                strWhereClause += fsmField.getFieldPath() + ' LIKE \'%' + recursiveGet(oSite,fsmField.getFieldPath()) + '%\' AND ';
                boolAtLeastOne = true;
            }
        }       
        
        // Determines if the code found at least one non-null/non-blank search parameter. If so, manipulate the "where string" to strip the last " AND " text
        // and add it to the SOQL statement.
        if (boolAtLeastOne) {
            strWhereClause = strWhereClause.substring(0,strWhereClause.length() - 5);
            strSOQL += strWhereClause;
        }
        
        if(bSearchOutsideUserOrg){
            if(boolAtLeastOne){
                strSOQL += ' and Account__r.recordtypeid !=: oracleRTFilter and VendorSiteID__c = null ORDER BY Account__r.name ASC  LIMIT ' + sSiteLimit;
            } else {
                strSOQL += ' WHERE Account__r.recordtypeid !=: oracleRTFilter and VendorSiteID__c = null  ORDER BY Account__r.name ASC  LIMIT ' + sSiteLimit;
            }
        } else {

            string userOrgID = userOrg.OUID__c;

            if(boolAtLeastOne){
                strSOQL += ' AND OUID__c =: userOrgID and Account__r.recordtypeid !=: oracleRTFilter and VendorSiteID__c = null  ORDER BY Account__r.name ASC  LIMIT ' + sSiteLimit;
            } else {
                strSOQL += ' WHERE OUID__c =: userOrgID and Account__r.recordtypeid !=: oracleRTFilter and VendorSiteID__c = null  ORDER BY Account__r.name ASC  LIMIT ' + sSiteLimit;
            }
        }

        system.debug('** GOT HERE: ' + strSOQL);

        lstSitesSearchResults = (list<Site__c>)Database.query(strSOQL);
        
        system.debug('** GOT HERE: ' + lstSitesSearchResults.size());


        IF(lstSitesSearchResults.size() < integer.valueof(siteLessLIMIT)){
            bShowMoreButtonSite = false;
        } else {
            bShowMoreButtonSite = true;
        }

        booDisplaySiteSearchResult = true;

        if(lstSitesSearchResults.size() > 0) {
            
            map<string, Site__c> mapUniqueSites = new map<string, Site__c>();
            mapSearchSites = new map<id, Site__c>();
            list<Site__c> nullSearchSites = new list<site__c>();

            for (Site__c oSearchSite: lstSitesSearchResults){
                if(oSearchSite.OracleCustomerID__c == null){
                    mapSearchSites.put(oSearchSite.id, oSearchSite);
                    nullSearchSites.add(oSearchSite);
                } else {
                    if(mapUniqueSites.containskey(oSearchSite.OracleCustomerID__c)){
                        if(oSearchSite.CustomerSiteUseCode__c == 'BILL_TO') {
                            mapSearchSites.put(oSearchSite.id, oSearchSite);
                            mapUniqueSites.put(oSearchSite.OracleCustomerID__c, oSearchSite);
                        }
                    } else {
                        mapSearchSites.put(oSearchSite.id, oSearchSite);
                        mapUniqueSites.put(oSearchSite.OracleCustomerID__c, oSearchSite);
                    }
                }
            }

            lstSitesSearchResults = mapUniqueSites.values();

            if(nullSearchSites.size() >0){
                lstSitesSearchResults.addall(nullSearchSites);
            }


        }


        /*if(lstSitesSearchResults.size() > 0){
            
            mapSearchSites = new map<id, Site__c>();

            for (Site__c oSearchSite: lstSitesSearchResults){
                mapSearchSites.put(oSearchSite.id, oSearchSite);
            }
        }*/

        //strSearchResults = string.valueof(lstSitesSearchResults.size()) + ' Record(s) Found';

        //lstSites = new list<SiteWrapper>();
        //mapSites = new map<id, SiteWrapper>();
        lstSearchOpportunities = new list<Opportunity>();




        

        return null;        
    }

    public PageReference RemoveSite(){
        lstSites.remove(iSiteRowDelete);
        return null;
    }


    public PageReference SelectSite(){

        if (!mapSites.containskey(idSiteID)) {
            SiteWrapper oSite = new SiteWrapper(mapSearchSites.get(idSiteID));
            mapSites.put(idSiteID, oSite);

            lstSites.add(oSite);
        }

        if(lstSites.size() == 1){
            lstSites[0].booIsPrimaryEnd = true;
            lstSites[0].booIsBilling = true;
            lstSites[0].booIsEnd = true;
            lstSites[0].booIsDefaultTopTask = true;
            lstSites[0].contributions = 100;

            oPrimaryEnd = lstSites[0];
            oPrimaryEnd1 = lstSites[0];
            oTopTask = lstSites[0];

            mapSitesEnd.put(idSiteID, lstSites[0]);
            mapSitesBilling.put(idSiteID, lstSites[0]);

            //SearchOpportunities();

        }

        SearchOpportunities();
        tabState='name1';
        return null;
    }


    public PageReference BillingSelect(){

        for (SiteWrapper oSiteWrapper: lstSites) {
            if(oSiteWrapper.oSite.id == idSiteID){
                if (oSiteWrapper.booIsBilling) {
                    mapSitesBilling.put(idSiteID, oSiteWrapper);
                } else {
                    mapSitesBilling.remove(idSiteID);
                    oSiteWrapper.booIsDefaultTopTask = false;
                    oTopTask = null;
                }
            }
        }

        if(oTopTask == null && mapSitesBilling.size() > 0){
            mapSitesBilling.values()[0].booIsDefaultTopTask = true;
            oTopTask = mapSitesBilling.values()[0];
        }

        return null;
    }

    public PageReference EndSelect(){
        for (SiteWrapper oSiteWrapper: lstSites) {
            if(oSiteWrapper.oSite.id == idSiteID){
                if (oSiteWrapper.booIsEnd) {
                    mapSitesEnd.put(idSiteID, oSiteWrapper);
                } else {
                    mapSitesEnd.remove(idSiteID);
                    oSiteWrapper.booIsPrimaryEnd = false;
                    oPrimaryEnd = null;
                }
            }
        }

        if(oPrimaryEnd == null && mapSitesEnd.size() > 0){
            mapSitesEnd.values()[0].booIsPrimaryEnd = true;
            oPrimaryEnd = mapSitesEnd.values()[0];
            oPrimaryEnd1 = mapSitesEnd.values()[0];
            idSiteID = oPrimaryEnd.oSite.id;
            //SearchOpportunities();
        }

        if(mapSitesEnd.size() == 0) {
            lstSearchOpportunities = null;
            strSearchResults = null;
            booDisplayOpportunitySearch = false;
        }

        return null;
    }


    public PageReference DefaultTopSelect(){

        for (SiteWrapper oSiteWrapper: lstSites) {
            if(oSiteWrapper.oSite.id == idSiteID){
                oSiteWrapper.booIsDefaultTopTask = true;
                oTopTask = oSiteWrapper;
            } else {
                oSiteWrapper.booIsDefaultTopTask = false;
            }
        }

        return null;
    }


    public PageReference PrimaryEndSelect(){

        for (SiteWrapper oSiteWrapper: lstSites) {
            if(oSiteWrapper.oSite.id == idSiteID){
                oSiteWrapper.booIsPrimaryEnd = true;
                oPrimaryEnd = oSiteWrapper;
                oPrimaryEnd1 = oSiteWrapper;
            } else {
                oSiteWrapper.booIsPrimaryEnd = false;
            }
        }

        //SearchOpportunities();

        return null;
    }

    public PageReference SelectOpportunity(){

        booShowProjectInput = true;
        oProject.pse__Opportunity__c = sSelectedOpportunityId;
        oProject.name = mapOpportunitySearch.get(sSelectedOpportunityId).name;
        oppName = mapOpportunitySearch.get(sSelectedOpportunityId).name;
        lastSaveAttemptName = null;
        boolNameAttempted = false;
        tabState = 'name3';
        bOppSelected = true;
        return null;
    }

    public PageReference SkipOpportunity(){

        if(idSelectedOppRecType == '' ||idSelectedOppRecType == null ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You must select recordtype for automatic opportunity creation.'));

            return null;             
        }

        oProject.pse__Opportunity__c = null;
        oProject.name = null;
        oppName = null;
        tabState = 'name3';
        bOppSelected = true;    
        return null;    
    }


    public PageReference Step2(){

        if(canContinue()){
                tab2enabled = true;
                tabState = 'name2';    
                return null;   
        } else {
                return null;
        }

 
    }    


    /** Method defined for saving the project form. Cannot use the standard controller because the clear method is defined in the extension **/
    public PageReference CreateProject () {

        if(isValid()){

            if (lastSaveAttemptName != oProject.name) {
                boolNameAttempted = false;
            }


            if (!boolNameAttempted) {

                // Perform Validation
                string projName = '%' + oProject.name + '%';
                //list<pse__Proj__c> listSearchProjects = [select id, name from pse__Proj__c where name LIKE : projName LIMIT 50];

                string strSOQL = 'SELECT ';
                    
                for (Schema.FieldSetMember fsmField: SObjectType.pse__Proj__c.FieldSets.pse_ProjectFieldsforCustomProjectSetup.getFields()) {
                    strSOQL += fsmField.getFieldPath() + ', ';
                }
                
                strSOQL += 'ID FROM pse__Proj__c where name LIKE : projName LIMIT 50';

                listSimilarProjects = (list<pse__Proj__c>)Database.query(strSOQL);



                if(listSimilarProjects.size() > 0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Attention: A duplicate project might already exist! Please confirm that you do want to create this project.'));   
                    boolNameAttempted = true;
                    lastSaveAttemptName = oProject.name;
                    return null;        
                }

            }

            list<pse__Proj__c> lstExactMatch = [select id from pse__Proj__c where name =: oProject.name];

            if(lstExactMatch.size() > 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Attention: The project name you specified already exists! please update the project name.'));  
                return null;                        
            }


            Savepoint oSavePoint = Database.setSavepoint();

        
            try {
                id oppID = null;

                if (oProject.pse__Opportunity__c == null) {
                    oProject.pse__Opportunity__c = CreateOpportunity();
                }

            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to create an Opportunity. Please contact your administrator with the following error: ' + e));
                Database.rollback(oSavePoint);
                oProject.pse__Opportunity__c = null;
                return null;
            }

            
            oProject.pse__Account__c = oPrimaryEnd.osite.account__c;
            oProject.DefaultTopTaskCustomer__c = oTopTask.osite.account__c;
            oProject.PrimarySite__c = oPrimaryEnd.osite.id;

            oProject.PrimaryBillingClient__c = oTopTask.osite.id;
            oProject.PrimaryEndClient__c = oPrimaryEnd.osite.id;

            list<recordtype> lrt = [Select ID, Name From RecordType Where sObjectType = 'pse__Proj__c' and developername='CustomerProjectUnapproved'];

            oProject.recordtypeid = lrt[0].id;


            try {    
                insert oProject;
            
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to create a Project. Please contact your administrator with the following error: ' + e));
                Database.rollback(oSavePoint);
                oProject.pse__Opportunity__c = null;
                return null;
            }
            
            try {    
                CreateProjectSites();
            
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to creating project sites. Please contact your administrator with the following error: ' + e));
                Database.rollback(oSavePoint);
                oProject.pse__Opportunity__c = null;
                return null;
            }

            try {    
                CreateProjectOrganizations();
            
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to creating project organizations. Please contact your administrator with the following error: ' + e));
                Database.rollback(oSavePoint);
                oProject.pse__Opportunity__c = null;
                return null;
            }

            try {    

                update oProject;
            
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to update Project. Please contact your administrator with the following error: ' + e));
                Database.rollback(oSavePoint);
                oProject.pse__Opportunity__c = null;
                return null;
            }           

            // redirect the user to the project detail page if successful
            PageReference pageRef = new PageReference('/' + oProject.id + '/e?retURL=/' + oProject.id);
            return pageRef;
        } else {
            return null;
        }
    }

    public PageReference SearchOrganizations(){
        set<string> lGeographies = new set<string>();
        set<string> lRegions = new set<string>();
        set<string> lDistricts = new set<string>();
        set<string> lBusinessLines = new set<string>();
        set<string> lDepartments = new set<string>();
        set<string> lLocations = new set<string>();
        set<string> lProjOwning = new set<string>();

        bSearchInProgress = false;

        string sQuery = 'SELECT Id, Name, OrganizationName__c, CurrencyIsoCode, GeographyName__c, Region__c, District__c, Department__c, BusinessLineName__c, LocationName__c, PLManagerContact__c, Project_Owning_Text__c, ProjectOwning__c, FinanceandAccountingManagerContact__c, CFOorDelegateContact__c, OUID__c, ProjectApprover__c, ProjectAccountant__c, ProjectAccountant2__c, FinanceLead2__c FROM OrganizationString__c WHERE ';
        
        if(ECO_Utils_String.NullCheck(sOrganizationName) != ''){
            sQuery += 'OrganizationName__c LIKE \'%' + sOrganizationName + '%\' and ';
            bSearchInProgress = true;
        }

        if(ECO_Utils_String.NullCheck(sGeographyName) != ''){
            sQuery += 'GeographyName__c = \'' + sGeographyName + '\' and ';
            bSearchInProgress = true;
        }
        
        if(ECO_Utils_String.NullCheck(sRegion) != ''){
            sQuery += 'Region__c = \'' + sRegion + '\' and ';
            bSearchInProgress = true;
        }
        
        if(ECO_Utils_String.NullCheck(sDistrict) != ''){
            sQuery += 'District__c = \'' + sDistrict + '\' and ';
            bSearchInProgress = true;
        }

        if(ECO_Utils_String.NullCheck(sBusinessLine) != ''){
            sQuery += 'BusinessLineName__c = \'' + sBusinessLine + '\' and ';
            bSearchInProgress = true;
        }
        
        if(ECO_Utils_String.NullCheck(sDepartment) != ''){
            sQuery += 'Department__c = \'' + sDepartment + '\' and ';
            bSearchInProgress = true;
        }

        if(ECO_Utils_String.NullCheck(sLocation) != ''){
            sQuery += 'LocationName__c = \'' + sLocation + '\' and ';
            bSearchInProgress = true;
        }

        if(ECO_Utils_String.NullCheck(sProjOwning) != ''){
            sQuery += 'Project_Owning_Text__c = \'' + sProjOwning + '\' and ';
            bSearchInProgress = true;
        }

        
        sQuery += '(InactiveDate__c > TODAY OR InactiveDate__c = null) and ProjectOwning__c=true ORDER BY OrganizationName__c, GeographyName__c, Region__c, BusinessLineName__c, Department__c, LocationName__c';
        
        system.debug(sQuery);

        list<OrganizationString__c> lOrganizationsQueried = Database.query(sQuery);

        loGeographies = new list<SelectOption>();
        loRegions = new list<SelectOption>();
        loDistricts = new list<SelectOption>();
        loBusinessLines = new list<SelectOption>();
        loDepartments = new list<SelectOption>();
        loLocations  = new list<SelectOption>();
        loProjOwnings  = new list<SelectOption>();

        for(OrganizationString__c oOrganizationString : lOrganizationsQueried){
            if(lGeographies.size() < 1000)
                lGeographies.add(oOrganizationString.GeographyName__c);
            if(lRegions.size() < 1000)
                lRegions.add(oOrganizationString.Region__c);
            if(lDistricts.size() < 1000)
                lDistricts.add(oOrganizationString.District__c);
            if(lBusinessLines.size() < 1000)
                lBusinessLines.add(oOrganizationString.BusinessLineName__c);
            if(lDepartments.size() < 1000)
                lDepartments.add(oOrganizationString.Department__c);
            if(lLocations.size() < 1000)
                if(oOrganizationString.LocationName__c != null){
                    lLocations.add(oOrganizationString.LocationName__c);
                }
            if(lProjOwning.size() < 1000)
                if(oOrganizationString.Project_Owning_Text__c != null){
                    lProjOwning.add(oOrganizationString.Project_Owning_Text__c);
                }
        }

        list<string> olGeographies = new list<string>(lGeographies);
        list<string> olRegions = new list<string>(lRegions);
        list<string> olDistricts = new list<string>(lDistricts);
        list<string> olBusinessLines = new list<string>(lBusinessLines);
        list<string> olDepartments = new list<string>(lDepartments);
        list<string> olLocations = new list<string>(lLocations);
        list<string> olProjOwnings = new list<string>(lProjOwning);


        olGeographies.sort();
        olRegions.sort();
        olDistricts.sort();
        olBusinessLines.sort();
        olDepartments.sort();
        olLocations.sort();
        olProjOwnings.sort();

        for(string sString : olGeographies){
            loGeographies.add(new SelectOption(sString, sString));
        }

        for(string sString : olRegions){
            loRegions.add(new SelectOption(sString, sString));
        }

        for(string sString : olDistricts){
            loDistricts.add(new SelectOption(sString, sString));
        }

        for(string sString : olBusinessLines){
            loBusinessLines.add(new SelectOption(sString, sString));
        }

        for(string sString : olDepartments){
            loDepartments.add(new SelectOption(sString, sString));
        }

        for(string sString : olLocations){
            loLocations.add(new SelectOption(sString, sString));
        }

        for(string sString : olProjOwnings){
            loProjOwnings.add(new SelectOption(sString, sString));
        }
        
        if(bSearchInProgress){

            lOrganizations = new list<OrganizationString__c>();

            for(OrganizationString__c SearchOrganiation: lOrganizationsQueried){
                
                
                if(lOrganizations.size() < iOrgLimit){
                    mapOrganizationString.put(SearchOrganiation.id, SearchOrganiation);
                    lOrganizations.add(SearchOrganiation);
                } 

                if(lOrganizations.size() < orgLessLIMIT){
                    bShowMoreButtonOrg = false;
                } else {
                    bShowMoreButtonOrg = true;
                }

            }


            
        }

        return null;
    }

    /*public PageReference Reset(){
        sOrganizationName = '';
        sGeographyName = '';
        sRegion = '';
        sDistrict = '';
        sBusinessLine = '';
        sDepartment = '';
        sLocation = '';
        sProjOwning = '';

        SearchOrganizations();
        SearchUserOrganization();

        return null;
    }*/

    public boolean canContinue()
    {
        boolean bIsValid = true;
        boolean noEmptyCB = true;
        Decimal dSiteTotal = 0;

        for (SiteWrapper oSiteWrapper:lstSites)
        {
            Decimal dPercentage = ECO_Utils_String.NullCheck(oSiteWrapper.contributions); 
            dSiteTotal += dPercentage;

            if(oSiteWrapper.booIsBilling && oSiteWrapper.billingContact == null){
                noEmptyCB = false;
            }
        }

        if(!noEmptyCB)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You must select a contact for each billing client.'));
            bIsValid = false;
        }

        if(dSiteTotal != 100)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The Contribution % for the Selected Sites does not total 100%.'));
            bIsValid = false;
        }       
        
        return bIsValid;          
    }

    public boolean isValid()
    {
        boolean bIsValid = true;
        boolean noEmptyCB = true;
        Decimal dTotal = 0;
        Decimal dSiteTotal = 0;

        for (SiteWrapper oSiteWrapper:lstSites)
        {
            Decimal dPercentage = ECO_Utils_String.NullCheck(oSiteWrapper.contributions); 
            dSiteTotal += dPercentage;

            if(oSiteWrapper.booIsBilling && oSiteWrapper.billingContact == null){
                noEmptyCB = false;
            }
        }

        for(OrganizationWrapper po : lSelectedOrganizations)
        {
            Decimal dPercentage = ECO_Utils_String.NullCheck(po.oProjectOrganization.ContributionPercent__c);
            dTotal += dPercentage;
        }

        if(!noEmptyCB)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'All selected sites must have a billing contact'));
            bIsValid = false;
        }

        if(dSiteTotal != 100)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The Contribution % for the Selected Sites does not total 100%.'));
            bIsValid = false;
        } 

        if(dTotal != 100)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The Contribution % for the Selected Organizations does not total 100%.'));
            bIsValid = false;
        }
        
        if(oPrimaryOrganization == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Primary Organization has not been selected.'));    
            bIsValid = false;        
        }

        return bIsValid;

    }
    
    public PageReference ProjectDetailNext(){
        bProjectFilled = true;
        tabState='name4';
        return null;
    }

    /*public PageReference SaveRecords(){
        if(isValid())
        {
            try{
                update lSelectedOrganizations;
            }catch(EcoControllerException oException){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, oException.getMessage()));
            }
    
            //Update Project to reflect changes
            oProject = ECO_Service_Projects.getProjectById(oProject.Id);
            lSelectedOrganizations = oProject.ProjectOrganizations__r;
        }
        return null;
    }*/

    public PageReference RemoveEntry(){
        list<OrganizationWrapper> lNewSelectedOrganizations = new list<OrganizationWrapper>();

        for(OrganizationWrapper oSelectedProjectOrganization: lSelectedOrganizations){
            if(oSelectedProjectOrganization.oOrganization.id != sSelectedOrganizationId){
                lNewSelectedOrganizations.add(oSelectedProjectOrganization);
            }

            lSelectedOrganizations = lNewSelectedOrganizations;

            mapOrganizationIdToProjectOrganization.remove(sSelectedOrganizationId);
        }


        return null;
    }

    public PageReference SelectPrimary(){
        for(OrganizationWrapper oSelectedProjectOrganization: lSelectedOrganizations){
            oSelectedProjectOrganization.strType = 'Supporting';
        }

        if (mapOrganizationIdToProjectOrganization.containskey(sSelectedOrganizationId)) {
            mapOrganizationIdToProjectOrganization.get(sSelectedOrganizationId).strType = 'Primary';
        } else {
            OrganizationWrapper oNewProjectOrganization = new OrganizationWrapper(mapOrganizationString.get(sSelectedOrganizationId));
            oNewProjectOrganization.strtype = 'Primary';

            if(lSelectedOrganizations.size() == 0){
                oNewProjectOrganization.oProjectOrganization.ContributionPercent__c = 100;
            }else{
                oNewProjectOrganization.oProjectOrganization.ContributionPercent__c = 0;
            }
            
            lSelectedOrganizations.add(oNewProjectOrganization);
            mapOrganizationIdToProjectOrganization.put(sSelectedOrganizationId, oNewProjectOrganization);
        }

        for(string sString : mapOrganizationIdToProjectOrganization.keySet()){
            OrganizationWrapper oOrganization = mapOrganizationIdToProjectOrganization.get(sString);

            if(oOrganization.strType == 'Primary'){
                oProject.CarryingOutOrganization__c = sString;
                oProject.CurrencyIsoCode = oOrganization.oOrganization.CurrencyIsoCode;
                oProject.ProjectCurrencyCode__c = oOrganization.oOrganization.CurrencyIsoCode;
                oProject.ProjectFunctionalCurrencyCode__c = oOrganization.oOrganization.CurrencyIsoCode;
                //oProject.PrimaryOrganization__c = sString;
                oPrimaryOrganization = oOrganization.oOrganization;
            }
        }

        return null;
    }

    public PageReference SelectSecondary(){

        if (mapOrganizationIdToProjectOrganization.containskey(sSelectedOrganizationId)) {
            mapOrganizationIdToProjectOrganization.get(sSelectedOrganizationId).strType = 'Supporting';
        } else {
            OrganizationWrapper oNewProjectOrganization = new OrganizationWrapper(mapOrganizationString.get(sSelectedOrganizationId));
            oNewProjectOrganization.strtype = 'Supporting';

            if(lSelectedOrganizations.size() == 0){
                oNewProjectOrganization.oProjectOrganization.ContributionPercent__c = 100;
            }else{
                oNewProjectOrganization.oProjectOrganization.ContributionPercent__c = 0;
            }
            
            lSelectedOrganizations.add(oNewProjectOrganization);
            mapOrganizationIdToProjectOrganization.put(sSelectedOrganizationId, oNewProjectOrganization);
        }      

        oProject.CarryingOutOrganization__c = null;
        //oProject.PrimaryOrganization__c = null;
        oPrimaryOrganization = null;

        for(string sString : mapOrganizationIdToProjectOrganization.keySet()){

            OrganizationWrapper oOrganization = mapOrganizationIdToProjectOrganization.get(sString);

            if(oOrganization.strType == 'Primary'){
                oProject.CarryingOutOrganization__c = sString;
                oProject.CurrencyIsoCode = oOrganization.oOrganization.CurrencyIsoCode;
                oProject.ProjectCurrencyCode__c = oOrganization.oOrganization.CurrencyIsoCode;
                oProject.ProjectFunctionalCurrencyCode__c = oOrganization.oOrganization.CurrencyIsoCode;
                //oProject.PrimaryOrganization__c = sString;
                oPrimaryOrganization = oOrganization.oOrganization;
            }
        }        


        return null;
    }


    private void ResetValues(){
        this.lstSearchOpportunities = new list<opportunity>();
        lstProjectSites = new list<Project_Site__c>();
        //lstSites = new list<SiteWrapper>();
        //mapSites = new map<id, SiteWrapper>();
        //mapSitesBilling = new map<id, SiteWrapper>();
        //mapSitesEnd = new map<id, SiteWrapper>();
        //mapSearchSites = new map<id, Site__c>();

        boolShowSiteSearch = false;
        booDisplaySiteSearchResult = false;
        booDisplayOpportunitySearch = false;
        booShowProjectInput = false;
        //oProject = new pse__Proj__c();
    }

    /* Used for creating the Project Site junction objects AFTER the project has been saved. */
    private void CreateProjectSites(){
        list<Project_Site__c> lstProjectSitesToInsert = new list<Project_Site__c>();

        for (SiteWrapper oSiteWrapper:lstSites){
            lstProjectSitesToInsert.add(new Project_Site__c(Contribution__c=oSiteWrapper.contributions, BillingContactID__c = oSiteWrapper.billingContact, BillingContact__c = oSiteWrapper.oidmap.get(oSiteWrapper.billingContact), Project__c = oProject.Id, name=oSiteWrapper.oSite.AccountName__c, Site__c = oSiteWrapper.oSite.id, Is_Billing__c = oSiteWrapper.booIsBilling, Is_Default_Top_Task__c = oSiteWrapper.booIsDefaultTopTask, Is_End__c = oSiteWrapper.booIsEnd, Is_Primary_End__c = oSiteWrapper.booIsPrimaryEnd));
        }

        insert lstProjectSitesToInsert;
    
    }

    /* Used for creating the Project Organization junction objects AFTER the project has been saved.  */
    private void CreateProjectOrganizations(){
        list<ProjectOrganization__c> lstProjectOrganizationsToInsert = new list<ProjectOrganization__c>();
        list<ProjectTeamMember__c> listProjectTeamMemberToInsert = new list<ProjectTeamMember__c>();

        map<string, ProjectRole__c> mapProjectRole = new map<string, ProjectRole__c>();
        List<ProjectRole__c> lProjectRoles = new List<ProjectRole__c>([Select Id, Name, Type__c From ProjectRole__c Where Active__c = true]);

        for(ProjectRole__c pr: lProjectRoles){
            mapProjectRole.put(pr.Name, pr);
        }

        
        list<contact> lstSearchContact = [select id, pse__Salesforce_User__c from contact where pse__Salesforce_User__c  =: UserInfo.getUserId()];
        if(mapProjectRole.containskey('Project Manager') && lstSearchContact.size() > 0){
            id auth2IDa = mapProjectRole.get('Project Manager').id;
            id contactIDa = lstSearchContact[0].id;

            listProjectTeamMemberToInsert.add(new ProjectTeamMember__c(Contact__c = contactIDa, ProjectRole__c = auth2IDa, Project__c = oProject.Id, StartDate__c = oProject.EstimatedStartDate__c));
            oProject.pse__Project_Manager__c = contactIDa;
            
        } else {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Unable to populate Project Manager based on current user. ');
            ApexPages.addMessage(oMsg);
        }       


        for (OrganizationWrapper oOrganizationWrapper:lSelectedOrganizations){
            lstProjectOrganizationsToInsert.add(new ProjectOrganization__c(Project__c = oProject.Id, OrganizationString__c = oOrganizationWrapper.oOrganization.id , Type__c = oOrganizationWrapper.strType, ContributionPercent__c = oOrganizationWrapper.oProjectOrganization.ContributionPercent__c));

            if((oOrganizationWrapper.oOrganization.PLManagerContact__c != null || 
                oOrganizationWrapper.oOrganization.FinanceandAccountingManagerContact__c != null || 
                oOrganizationWrapper.oOrganization.CFOorDelegateContact__c != null ||
                oOrganizationWrapper.oOrganization.ProjectApprover__c != null ||
                oOrganizationWrapper.oOrganization.ProjectAccountant__c != null ||
                oOrganizationWrapper.oOrganization.ProjectAccountant2__c != null ||
                oOrganizationWrapper.oOrganization.FinanceLead2__c != null

                )  
                && oOrganizationWrapper.strType == 'Primary'){
                
                /*list<contact> lstSearchContact = [select id, User__c from contact where (User__c =: oOrganizationWrapper.oOrganization.PLManagerContact__c or User__c =: oOrganizationWrapper.oOrganization.FinanceandAccountingManagerContact__c) and User__c !=null];
                
                map<id, contact> mapContact = new map<id, contact>();
                for(contact c:lstSearchContact){
                    mapContact.put(c.User__c, c);
                }*/

         

                if(mapProjectRole.containskey('Project Approver 2') && oOrganizationWrapper.oOrganization.PLManagerContact__c != null){
                    id auth2ID = mapProjectRole.get('Project Approver 2').id;
                    id contactID = oOrganizationWrapper.oOrganization.PLManagerContact__c;

                    listProjectTeamMemberToInsert.add(new ProjectTeamMember__c(Contact__c = contactID, ProjectRole__c = auth2ID, Project__c = oProject.Id, StartDate__c = oProject.EstimatedStartDate__c));

                    oProject.PnLManager__c = contactID;

                /*} else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Unable to populate Project Approver 2 based on PL Owner on Primary Org: ' + oOrganizationWrapper.oOrganization.name));*/
                }

                if(mapProjectRole.containskey('Finance Lead') && oOrganizationWrapper.oOrganization.FinanceandAccountingManagerContact__c != null){
                    id auth2ID = mapProjectRole.get('Finance Lead').id;
                    id contactID = oOrganizationWrapper.oOrganization.FinanceandAccountingManagerContact__c;

                    listProjectTeamMemberToInsert.add(new ProjectTeamMember__c(Contact__c = contactID, ProjectRole__c = auth2ID, Project__c = oProject.Id, StartDate__c = oProject.EstimatedStartDate__c));
                /*} else {
                    ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Unable to populate Finance Lead based on Finance and Accounting Manager on Primary Org: ' + oOrganizationWrapper.oOrganization.name);
                    ApexPages.addMessage(oMsg);*/
                }

                if(mapProjectRole.containskey('CFO or Delegate') && oOrganizationWrapper.oOrganization.CFOorDelegateContact__c != null){
                    id auth2ID = mapProjectRole.get('CFO or Delegate').id;
                    id contactID = oOrganizationWrapper.oOrganization.CFOorDelegateContact__c;

                    listProjectTeamMemberToInsert.add(new ProjectTeamMember__c(Contact__c = contactID, ProjectRole__c = auth2ID, Project__c = oProject.Id, StartDate__c = oProject.EstimatedStartDate__c));
               /* } else {
                    ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Unable to populate CFO or Delegate based on CFO or Delegate on Primary Org: ' + oOrganizationWrapper.oOrganization.name);
                    ApexPages.addMessage(oMsg);*/
                }

                if(mapProjectRole.containskey('Project Approver') && oOrganizationWrapper.oOrganization.ProjectApprover__c != null){
                    id auth2ID = mapProjectRole.get('Project Approver').id;
                    id contactID = oOrganizationWrapper.oOrganization.ProjectApprover__c;

                    listProjectTeamMemberToInsert.add(new ProjectTeamMember__c(Contact__c = contactID, ProjectRole__c = auth2ID, Project__c = oProject.Id, StartDate__c = oProject.EstimatedStartDate__c));

                    oProject.ProjectApprover__c = contactID;
               /* } else {
                    ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Unable to populate Project Approver based on Project Approver on Primary Org: ' + oOrganizationWrapper.oOrganization.name);
                    ApexPages.addMessage(oMsg);*/
                }

                if(mapProjectRole.containskey('Project Accountant') && oOrganizationWrapper.oOrganization.ProjectAccountant__c != null){
                    id auth2ID = mapProjectRole.get('Project Accountant').id;
                    id contactID = oOrganizationWrapper.oOrganization.ProjectAccountant__c;

                    listProjectTeamMemberToInsert.add(new ProjectTeamMember__c(Contact__c = contactID, ProjectRole__c = auth2ID, Project__c = oProject.Id, StartDate__c = oProject.EstimatedStartDate__c));
                /*} else {
                    ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Unable to populate Project Accountant based on Project Accountant on Primary Org: ' + oOrganizationWrapper.oOrganization.name);
                    ApexPages.addMessage(oMsg);*/
                }

                if(mapProjectRole.containskey('Project Accountant 2') && oOrganizationWrapper.oOrganization.ProjectAccountant2__c != null){
                    id auth2ID = mapProjectRole.get('Project Accountant 2').id;
                    id contactID = oOrganizationWrapper.oOrganization.ProjectAccountant2__c;

                    listProjectTeamMemberToInsert.add(new ProjectTeamMember__c(Contact__c = contactID, ProjectRole__c = auth2ID, Project__c = oProject.Id, StartDate__c = oProject.EstimatedStartDate__c));
                /*} else {
                    ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Unable to populate Project Accountant 2 based on Project Accountant 2 on Primary Org: ' + oOrganizationWrapper.oOrganization.name);
                    ApexPages.addMessage(oMsg);*/
                }

                if(mapProjectRole.containskey('Finance Lead 2') && oOrganizationWrapper.oOrganization.FinanceLead2__c != null){
                    id auth2ID = mapProjectRole.get('Finance Lead 2').id;
                    id contactID = oOrganizationWrapper.oOrganization.FinanceLead2__c;

                    listProjectTeamMemberToInsert.add(new ProjectTeamMember__c(Contact__c = contactID, ProjectRole__c = auth2ID, Project__c = oProject.Id, StartDate__c = oProject.EstimatedStartDate__c));
                /*} else {
                    ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Unable to populate Finance Lead 2 based on Finance Lead 2 on Primary Org: ' + oOrganizationWrapper.oOrganization.name);
                    ApexPages.addMessage(oMsg);*/
                }

            }
            
        }

        // Create a client account manager for each of the sites that are related

        set<string> empID = new set<string>();

        for(SiteWrapper s:lstSites){
            if(s.oSite.Account__r.Account_Manager__r.Employee_ID__c != null){
                empID.add(s.oSite.Account__r.Account_Manager__r.Employee_ID__c);
            }
        }

        list<contact> listCAM = [select id from contact where pse__Salesforce_User__r.EmployeeNumber IN: empID];

        if(listCAM.size() > 0 && mapProjectRole.containskey('Client Account Manager')){

            id CAMid = mapProjectRole.get('Client Account Manager').id;

            for(contact c:listCAM){
                listProjectTeamMemberToInsert.add(new ProjectTeamMember__c(Contact__c = c.id, ProjectRole__c = CAMid, Project__c = oProject.Id, StartDate__c = oProject.EstimatedStartDate__c));
            }
        }

        insert lstProjectOrganizationsToInsert;

        if(listProjectTeamMemberToInsert.size() > 0){
            insert listProjectTeamMemberToInsert;
        }

    }

    private id CreateOpportunity(){

        opportunity oOpportunityToInsert = new opportunity();
        oOpportunityToInsert.name = oProject.name;
        oOpportunityToInsert.closeDate = date.today();
        oOpportunityToInsert.Stagename = '1 Lead';
        oOpportunityToInsert.probability = 100;
        oOpportunityToInsert.accountid = oPrimaryEnd.osite.Account__c;
        oOpportunityToInsert.TO_Procurement_Method__c = 'Competitive Task Orders';
        oOpportunityToInsert.Capture_Manager_User__c = UserInfo.getUserId();
        oOpportunityToInsert.recordtypeid = idSelectedOppRecType;

        insert oOpportunityToInsert;

        return oOpportunityToInsert.id;
    }

    private void SearchOpportunities(){
        list<Site__c> listSearchSites = new list<Site__c>();
        set<id> setSitesToSearch = new set<id>();
        set<id> setAccountsToSearch = new set<id>();

        for(sitewrapper oSiteWrapper: lstSites){
            setSitesToSearch.add(oSiteWrapper.oSite.id);
        }


        if (setSitesToSearch.size() > 0) {
            listSearchSites = [SELECT ID, Account__c FROM SITE__C WHERE ID IN:setSitesToSearch];
        }

        for(site__c oSite:listSearchSites){
            setAccountsToSearch.add(oSite.Account__c);
        }

        if (listSearchSites.size()>0) {
            string strSOQL = 'SELECT ';
            boolean boolAtLeastOne = false;
                
            for (Schema.FieldSetMember fsmField: SObjectType.opportunity.FieldSets.pse_OpportunityFieldsForSearchResult.getFields()) {
                strSOQL += fsmField.getFieldPath() + ', ';
            }
            
            strSOQL += 'ID, Name, AcctName__c FROM OPPORTUNITY WHERE Accountid IN: setAccountsToSearch ORDER BY CreatedDate DESC LIMIT 50';
            
            lstSearchOpportunities = (list<opportunity>)Database.query(strSOQL);
            
            booDisplayOpportunitySearch = true;            
        }   

        strSearchResults = string.valueof(lstSearchOpportunities.size()) + ' Record(s) Found';

        mapOpportunitySearch = new map<id, opportunity>();
        lstOppClone = new list<oppClone>();

        for (opportunity oOpportunity: lstSearchOpportunities) {
            mapOpportunitySearch.put(oOpportunity.id, oOpportunity);

            oppClone oClone  = new oppClone();
            oClone.id=oOpportunity.id;
            oClone.acctName=oOpportunity.AcctName__c;
            oClone.oppName=oOpportunity.name;
            oClone.capManager= oOpportunity.CaptureManager__c;
            oClone.createdDate = oOpportunity.createdDate.format();

            lstOppClone.add(oClone);
        }

        //oProject = new pse__Proj__c();
    }



    /* Utility Method used for recursively obtaining a field from a multiple object relationship */
    private Object recursiveGet(sObject record, String field) {
        if(field.contains('.')) {
            Integer firstPeriod = field.indexOf('.');
            String nextObjectName = field.subString(0, firstPeriod);
            String remainingfieldName = field.subString(firstPeriod + 1, field.length());
            sObject nextObject = record.getSObject(nextObjectName);
            if(nextObject == null) {
                return null;
            } else {
                return recursiveGet(nextObject, remainingfieldName);
            }
        } else {
            return record.get(field);   
        }
    }


    
}