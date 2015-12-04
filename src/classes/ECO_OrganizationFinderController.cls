/* Change Log
Date        Developer           Work Item           Changes Made
----        ---------           ---------           ------------
2/6/15      Gautam Shah         WI-000191           Created "isValid" method, lines 148-163; calls to this methods on lines 50, 166;
4/3/15      Brad Furdyk                             Added updating CarryingOutOrganization__c when primary org gets set to support imported projects which don't use PrimaryOrganization__c
*/
public with sharing class ECO_OrganizationFinderController {
    public pse__Proj__c oProject {get; set;}

    public string sOrganizationName {get; set;}
    public string sGeographyName {get; set;}
    public string sRegion {get; set;}
    public string sDistrict {get; set;}
    public string sBusinessLine {get; set;}
    public string sDepartment {get; set;}
    public string sLocation {get; set;}
    public string sProjOwning {get; set;}

    public list<SelectOption> loGeographies {get; set;}
    public list<SelectOption> loRegions {get; set;}
    public list<SelectOption> loDistricts {get; set;}
    public list<SelectOption> loBusinessLines {get; set;}
    public list<SelectOption> loDepartments {get; set;}
    public list<SelectOption> loLocations {get; set;}
    public list<SelectOption> loProjOwnings {get; set;}
    public list<OrganizationString__c> lUserOrganizations {get; set;}

    public list<OrganizationString__c> lOrganizations {get; set;}
    public list<ProjectOrganization__c> lSelectedOrganizations {get; set;}

    public OrganizationString__c userOrg {get;set;}

    public string sSelectedOrganizationId {get; set;}

    public boolean bSearchInProgress {get; set;}
    
    public boolean bUpdateContributionDisabled {get; set;}

    private integer iOrgLimit;

    private boolean bOrgMore;

    public site__c primarySite {get;set;}

    public boolean bShowMoreButtonOrg {get;set;}
    public string showMoreOrgText {get;set;}
    private static integer orgLessLIMIT = 20;
    private static integer orgMoreLIMIT = 200;


    public class EcoControllerException extends Exception {}

    public ECO_OrganizationFinderController(ApexPages.StandardController oStandardController) {
        ProjectOrganization__c oProjectOrganization = (ProjectOrganization__c)oStandardController.getRecord();

        string passedProjectID = ApexPages.currentPage().getParameters().get('passedProjectID');


        if(ECO_Utils_String.NullCheck(oProjectOrganization.Project__c) == '' && passedProjectID==null){
            ApexPages.Message oPageMessage = new ApexPages.Message(ApexPages.Severity.WARNING,'You have reached this page improperly, please access it from the Project screen.');
            ApexPages.addMessage(oPageMessage);

            return;
        } else if (ECO_Utils_String.NullCheck(oProjectOrganization.Project__c) == '' && passedProjectID!=null){
            oProjectOrganization.Project__c = passedProjectID;
        }

        oProject = ECO_Service_Projects.getProjectById(oProjectOrganization.Project__c);
        lSelectedOrganizations = oProject.ProjectOrganizations__r;

        sOrganizationName = '';
        sGeographyName = '';
        sRegion = '';
        sDistrict = '';
        sBusinessLine = '';
        sDepartment = '';
        sLocation = '';
        sProjOwning = '';

        iOrgLimit = orgLessLIMIT;
        bOrgMore = false;
        bShowMoreButtonOrg = false;
        showMoreOrgText = 'Show More';

        sSelectedOrganizationId = '';
        bSearchInProgress = false;   
        bUpdateContributionDisabled = false;     
        isValid(false);

        lUserOrganizations = new list<OrganizationString__c>();

        primarySite = [select id, OUID__c from site__c where id =: oProject.PrimarySite__c];

        SearchOrganizations();
        SearchUserOrganization();
    }
    
    public PageReference cancel()
    {
    	return new PageReference('/' + oProject.Id);
    }

    public void SearchUserOrganization(){

        list<user> lUser = [SELECT ECO_OrganizationName__c FROM User WHERE ID =:UserInfo.getUserId()];

        lUserOrganizations = [SELECT Id, Name, OrganizationName__c, GeographyName__c, Region__c, District__c, Department__c, BusinessLineName__c, LocationName__c, PLManagerContact__c, ProjectOwning__c, FinanceandAccountingManagerContact__c, CFOorDelegateContact__c, OUID__c, CurrencyIsoCode FROM OrganizationString__c WHERE Name =: lUser[0].ECO_OrganizationName__c and ProjectOwning__c=true and (InactiveDate__c > TODAY OR InactiveDate__c = null)];

        if(lUserOrganizations.size() > 0){
            userOrg = lUserOrganizations[0];
        } else {
            userOrg = null;
        }
      
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


    public void toggleOrgShow(){
        If(bOrgMore){
            showLessOrg();
            SearchOrganizations();
        } else {
            showMoreOrg();
            SearchOrganizations();
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

        string sQuery = 'SELECT Id, CurrencyIsoCode, Name, OrganizationName__c, GeographyName__c, Region__c, District__c, Department__c, BusinessLineName__c, Project_Owning_Text__c, ProjectOwning__c, LocationName__c FROM OrganizationString__c WHERE ';
        
        if(ECO_Utils_String.NullCheck(sOrganizationName) != ''){
            sQuery += 'Name LIKE \'%' + sOrganizationName + '%\' and ';
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
        
        sQuery += '(InactiveDate__c > TODAY OR InactiveDate__c = null)  and ProjectOwning__c=true ORDER BY OrganizationName__c, GeographyName__c, Region__c, BusinessLineName__c, Department__c, LocationName__c';
        
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

    public PageReference Reset(){
        sOrganizationName = '';
        sGeographyName = '';
        sRegion = '';
        sDistrict = '';
        sBusinessLine = '';
        sDepartment = '';
        sLocation = '';
        sProjOwning = '';

        SearchOrganizations();

        return null;
    }

    public boolean isValid(boolean allowDML)
    {
        boolean bIsValid = true;
        Decimal dTotal = 0;
        
        if(lSelectedOrganizations.size() == 0)
        	bUpdateContributionDisabled = true;
        else
        	bUpdateContributionDisabled = false;
        
        if(lSelectedOrganizations.size() == 1 && allowDML)
        {
        	if(lSelectedOrganizations[0].ContributionPercent__c != 100)
        	{
        		lSelectedOrganizations[0].ContributionPercent__c = 100;
        		SaveRecords();
        	}
        }
       
        for(ProjectOrganization__c po : lSelectedOrganizations)
        {
            Decimal dPercentage = ECO_Utils_String.NullCheck(po.ContributionPercent__c);
            dTotal += dPercentage;
        }
        if(lSelectedOrganizations.size() > 0 && dTotal != 100)
        {
            ApexPages.Message oPageMessage = new ApexPages.Message(ApexPages.Severity.WARNING,'The Contribution % for the Selected Organizations does not total 100%.');
            ApexPages.addMessage(oPageMessage);
            bIsValid = false;
        }
        
        return bIsValid;
    }
    
    public PageReference SaveRecords(){
        if(isValid(false))
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
    }

    public PageReference RemoveEntry(){
        //Check if entry already exists
        list<ProjectOrganization__c> lProjectOrganizationsToRemove = new list<ProjectOrganization__c>([SELECT Id
                                                            FROM ProjectOrganization__c
                                                            WHERE Project__c = :oProject.Id and OrganizationString__c = :sSelectedOrganizationId]);

        try{
            delete lProjectOrganizationsToRemove;
        }catch(EcoControllerException oException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, oException.getMessage()));
        }

        //Update Project to reflect changes
        oProject = ECO_Service_Projects.getProjectById(oProject.Id);
        lSelectedOrganizations = oProject.ProjectOrganizations__r;

		isValid(true);
		
        return null;
    }

    public PageReference SelectPrimary(){
        Savepoint oSavePoint = Database.setSavepoint();

        //Check if entry already exists
        list<ProjectOrganization__c> lProjectOrganizationsToMakeSecondary = new list<ProjectOrganization__c>([SELECT Id
                                                            FROM ProjectOrganization__c
                                                            WHERE Project__c = :oProject.Id and OrganizationString__c != :sSelectedOrganizationId and Type__c = 'Primary']);

        if(lProjectOrganizationsToMakeSecondary.size() > 0){
            for(ProjectOrganization__c oProjectOrganization : lProjectOrganizationsToMakeSecondary){
                oProjectOrganization.Type__c = 'Supporting';
            }

            try{
                update lProjectOrganizationsToMakeSecondary;
            }catch(EcoControllerException oException){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, oException.getMessage()));
                Database.rollback(oSavePoint);

                return null;
            }
        }

        //Check if entry already exists
        list<ProjectOrganization__c> lProjectOrganizationsToMakePrimary = new list<ProjectOrganization__c>([SELECT Id
                                                                    , Type__c
                                                            FROM ProjectOrganization__c
                                                            WHERE Project__c = :oProject.Id and OrganizationString__c = :sSelectedOrganizationId]);

        if(lProjectOrganizationsToMakePrimary.size() > 0){
            for(ProjectOrganization__c oProjectOrganization : lProjectOrganizationsToMakePrimary){
                oProjectOrganization.Type__c = 'Primary';
            }

            try{
                update lProjectOrganizationsToMakePrimary;
            }catch(EcoControllerException oException){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, oException.getMessage()));
                Database.rollback(oSavePoint);

                return null;
            }
        }else{
            ProjectOrganization__c oProjectOrganizationToInsert = new ProjectOrganization__c(Project__c = oProject.Id, OrganizationString__c = sSelectedOrganizationId, Type__c = 'Primary');

            try{
                insert oProjectOrganizationToInsert;
            }catch(EcoControllerException oException){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, oException.getMessage()));
                Database.rollback(oSavePoint);

                return null;
            }
        }

        OrganizationString__c targetOrg = [select id, CurrencyIsoCode from OrganizationString__c where id=:sSelectedOrganizationId];

        //Update project to reflect
        //pse__Proj__c oProjectToUpdate = new pse__Proj__c(Id = oProject.Id, PrimaryOrganization__c = sSelectedOrganizationId);
        pse__Proj__c oProjectToUpdate = new pse__Proj__c(Id = oProject.Id, CarryingOutOrganization__c = sSelectedOrganizationId, CurrencyIsoCode=targetOrg.CurrencyIsoCode, ProjectFunctionalCurrencyCode__c=targetOrg.CurrencyIsoCode);

        try{
            update oProjectToUpdate;
        }catch(EcoControllerException oException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, oException.getMessage()));
            Database.rollback(oSavePoint);

            return null;
        }

        //Update Project to reflect changes
        oProject = ECO_Service_Projects.getProjectById(oProject.Id);
        lSelectedOrganizations = oProject.ProjectOrganizations__r;

		isValid(true);
        return null;
    }

    public PageReference SelectSecondary(){

        if(oProject.CarryingOutOrganization__c == sSelectedOrganizationId && oProject.OracleSyncStatus__c=='S' ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot set Primary Org as Secondary'));
            return null;
        }


        Savepoint oSavePoint = Database.setSavepoint();

        //Check if entry already exists
        list<ProjectOrganization__c> lProjectOrganizationsToMakeSecondary = new list<ProjectOrganization__c>([SELECT Id
                                                            FROM ProjectOrganization__c
                                                            WHERE Project__c = :oProject.Id and OrganizationString__c = :sSelectedOrganizationId]);

        if(lProjectOrganizationsToMakeSecondary.size() > 0){
            for(ProjectOrganization__c oProjectOrganization : lProjectOrganizationsToMakeSecondary){
                oProjectOrganization.Type__c = 'Supporting';
            }

            try{
                update lProjectOrganizationsToMakeSecondary;
            }catch(EcoControllerException oException){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, oException.getMessage()));
                Database.rollback(oSavePoint);

                return null;
            }
        }else{
            ProjectOrganization__c oProjectOrganizationToInsert = new ProjectOrganization__c(Project__c = oProject.Id, OrganizationString__c = sSelectedOrganizationId, Type__c = 'Supporting');

            try{
                insert oProjectOrganizationToInsert;
            }catch(EcoControllerException oException){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, oException.getMessage()));
                Database.rollback(oSavePoint);

                return null;
            }
        }

        //Update project to reflect if organization is currently primary
        if(oProject.CarryingOutOrganization__c == sSelectedOrganizationId){
            //pse__Proj__c oProjectToUpdate = new pse__Proj__c(Id = oProject.Id, PrimaryOrganization__c = null);
            pse__Proj__c oProjectToUpdate = new pse__Proj__c(Id = oProject.Id, CarryingOutOrganization__c = null);

            try{
                update oProjectToUpdate;
            }catch(EcoControllerException oException){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, oException.getMessage()));
                Database.rollback(oSavePoint);

                return null;
            }
        }

        //Update Project to reflect changes
        oProject = ECO_Service_Projects.getProjectById(oProject.Id);
        lSelectedOrganizations = oProject.ProjectOrganizations__r;

		isValid(true);
        return null;
    }
}