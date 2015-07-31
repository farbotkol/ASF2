/* Change Log
Date        Developer           Work Item           Changes Made
----        ---------           ---------           ------------
2/6/15      Gautam Shah         WI-000191           Created "isValid" method, lines 148-163; calls to this methods on lines 50, 166;
*/
public with sharing class ECO_OrganizationFinderController {
    public pse__Proj__c oProject {get; set;}

    public string sOrganizationName {get; set;}
    public string sGeographyName {get; set;}
    public string sRegion {get; set;}
    public string sDistrict {get; set;}
    public string sDepartment {get; set;}

    public list<SelectOption> loGeographies {get; set;}
    public list<SelectOption> loRegions {get; set;}
    public list<SelectOption> loDistricts {get; set;}
    public list<SelectOption> loDepartments {get; set;}

    public list<OrganizationString__c> lOrganizations {get; set;}
    public list<ProjectOrganization__c> lSelectedOrganizations {get; set;}

    public string sSelectedOrganizationId {get; set;}

    public boolean bSearchInProgress {get; set;}
    
    public boolean bUpdateContributionDisabled {get; set;}

    public class EcoControllerException extends Exception {}

    public ECO_OrganizationFinderController(ApexPages.StandardController oStandardController) {
        ProjectOrganization__c oProjectOrganization = (ProjectOrganization__c)oStandardController.getRecord();

        if(ECO_Utils_String.NullCheck(oProjectOrganization.Project__c) == ''){
            ApexPages.Message oPageMessage = new ApexPages.Message(ApexPages.Severity.WARNING,'You have reached this page improperly, please access it from the Project screen.');
            ApexPages.addMessage(oPageMessage);

            return;
        }

        oProject = ECO_Service_Projects.getProjectById(oProjectOrganization.Project__c);
        lSelectedOrganizations = oProject.ProjectOrganizations__r;

        sOrganizationName = '';
        sGeographyName = '';
        sRegion = '';
        sDistrict = '';
        sDepartment = '';

        sSelectedOrganizationId = '';
        bSearchInProgress = false;   
        bUpdateContributionDisabled = false;     
        isValid(false);
        SearchOrganizations();
    }
    
    public PageReference SearchOrganizations(){
        set<string> lGeographies = new set<string>();
        set<string> lRegions = new set<string>();
        set<string> lDistricts = new set<string>();
        set<string> lDepartments = new set<string>();

        bSearchInProgress = false;

        string sQuery = 'SELECT Id, Name, OrganizationName__c, GeographyName__c, Region__c, District__c, Department__c FROM OrganizationString__c WHERE ';
        
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
        
        if(ECO_Utils_String.NullCheck(sDepartment) != ''){
            sQuery += 'Department__c = \'' + sDepartment + '\' and ';
            bSearchInProgress = true;
        }
        
        sQuery += '(InactiveDate__c > TODAY OR InactiveDate__c = null) ORDER BY GeographyName__c, Region__c, District__c, Department__c, Name';
        
        system.debug(sQuery);

        list<OrganizationString__c> lOrganizationsQueried = Database.query(sQuery);

        loGeographies = new list<SelectOption>();
        loRegions = new list<SelectOption>();
        loDistricts = new list<SelectOption>();
        loDepartments = new list<SelectOption>();

        for(OrganizationString__c oOrganizationString : lOrganizationsQueried){
            if(lGeographies.size() < 1000)
            	lGeographies.add(oOrganizationString.GeographyName__c);
            if(lRegions.size() < 1000)
            	lRegions.add(oOrganizationString.Region__c);
           	if(lDistricts.size() < 1000)
            	lDistricts.add(oOrganizationString.District__c);
            if(lDepartments.size() < 1000)
            	lDepartments.add(oOrganizationString.Department__c);
        }

        list<string> olGeographies = new list<string>(lGeographies);
        list<string> olRegions = new list<string>(lRegions);
        list<string> olDistricts = new list<string>(lDistricts);
        list<string> olDepartments = new list<string>(lDepartments);

        olGeographies.sort();
        olRegions.sort();
        olDistricts.sort();
        olDepartments.sort();

        for(string sString : olGeographies){
            loGeographies.add(new SelectOption(sString, sString));
        }

        for(string sString : olRegions){
            loRegions.add(new SelectOption(sString, sString));
        }

        for(string sString : olDistricts){
            loDistricts.add(new SelectOption(sString, sString));
        }

        for(string sString : olDepartments){
            loDepartments.add(new SelectOption(sString, sString));
        }

        if(bSearchInProgress){
            lOrganizations = lOrganizationsQueried;
        }

        return null;
    }

    public PageReference Reset(){
        sOrganizationName = '';
        sGeographyName = '';
        sRegion = '';
        sDistrict = '';
        sDepartment = '';

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
                oProjectOrganization.Type__c = 'Secondary';
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

        //Update project to reflect
        pse__Proj__c oProjectToUpdate = new pse__Proj__c(Id = oProject.Id, PrimaryOrganization__c = sSelectedOrganizationId);

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
        Savepoint oSavePoint = Database.setSavepoint();

        //Check if entry already exists
        list<ProjectOrganization__c> lProjectOrganizationsToMakeSecondary = new list<ProjectOrganization__c>([SELECT Id
                                                            FROM ProjectOrganization__c
                                                            WHERE Project__c = :oProject.Id and OrganizationString__c = :sSelectedOrganizationId]);

        if(lProjectOrganizationsToMakeSecondary.size() > 0){
            for(ProjectOrganization__c oProjectOrganization : lProjectOrganizationsToMakeSecondary){
                oProjectOrganization.Type__c = 'Secondary';
            }

            try{
                update lProjectOrganizationsToMakeSecondary;
            }catch(EcoControllerException oException){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, oException.getMessage()));
                Database.rollback(oSavePoint);

                return null;
            }
        }else{
            ProjectOrganization__c oProjectOrganizationToInsert = new ProjectOrganization__c(Project__c = oProject.Id, OrganizationString__c = sSelectedOrganizationId, Type__c = 'Secondary');

            try{
                insert oProjectOrganizationToInsert;
            }catch(EcoControllerException oException){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, oException.getMessage()));
                Database.rollback(oSavePoint);

                return null;
            }
        }

        //Update project to reflect if organization is currently primary
        if(oProject.PrimaryOrganization__c == sSelectedOrganizationId){
            pse__Proj__c oProjectToUpdate = new pse__Proj__c(Id = oProject.Id, PrimaryOrganization__c = null);

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