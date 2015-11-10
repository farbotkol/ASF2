/***
Author: NTT Centerstance
Purpose: To provide extended controller capabilities for the client finder page
1.0 - Tim C - 02/02/2015 - Created
1.1 - Tim C - 02/02/2015 - Seperated out country risk and city
1.2 - Tim C - 04/11/2015 - Added Filter to eliminate dupes in the search
***/
public with sharing virtual class ECO_ClientFinderController{

	public list<Project_Site__c> lstProjectSites {get;set;}
	public list<Site__c> lstSitesSearchResults {get;set;}
	public map<id, Site__c> mapSearchSites {get;set;}
    public map<string, Site__c> mapUniqueSites {get;set;}
	public map<id, Project_Site__c> mapProjectSites {get;set;}
	public map<id, Project_Site__c> mapSitesBilling {get;set;}
    public map<id, Project_Site__c> mapSitesEnd {get;set;}
    public map<id, list<SelectOption>> mapSiteIDtoOptions{get;set;}

	public Site__c oSite {get;set;}

	public pse__Proj__c oProject {get;set;}

	public id idSiteID {get;set;}

	public string strSearchResults {get;set;}
	public string strNoRecords {get;set;}

	public boolean boolShowSiteSearch {get;set;}
	public boolean booDisplaySiteSearchResult {get;set;}
	public boolean booNewProject {get;set;}

    private Project_Site__c oTopTask;
    private Project_Site__c oPrimaryEnd;

    private string sSiteLimit;

    private boolean bSiteMore;

    public boolean bShowMoreButtonSite {get;set;}

    public string showMoreSiteText {get;set;}

    private static string siteLessLIMIT = '50';
    private static string siteMoreLIMIT = '200';


	/* Custom classes to facilitate this controller */
	public class EcoControllerException extends Exception {}


	/* Constructor */
    public ECO_ClientFinderController(ApexPages.StandardController oStandardController) {


        sSiteLimit = siteLessLIMIT;

        bSiteMore = false;

        bShowMoreButtonSite = false;

        showMoreSiteText = 'Show More';

        oSite = new Site__c();
        oSite.account__r = new account();
        this.oProject = (pse__Proj__c)oStandardController.getRecord();

        mapSitesBilling = new map<id, Project_Site__c>();
        mapSitesEnd = new map<id, Project_Site__c>();


		if(ECO_Utils_String.NullCheck(this.oProject.id) == ''){
			ApexPages.Message oPageMessage = new ApexPages.Message(ApexPages.Severity.WARNING,'You have reached this page improperly, please access it from the Project screen.');
            ApexPages.addMessage(oPageMessage);
            mapSiteIDtoOptions = new map<id, list<SelectOption>>();
            return;
        } else {
        	UpdateProjectSites();
        }

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


    public void toggleSiteShow(){
        If(bSiteMore){
            showLessSites();
            SearchSites();
        } else {
            showMoreSites();
            SearchSites();
        }
    }

    public PageReference stub(){
        return null;
    }

	public PageReference SelectSite() {

		if(mapProjectSites.containskey(idSiteID)) {
			return null;
		}

		Site__c SelectedSite = mapSearchSites.get(idSiteID);

        List<SelectOption> contacts = new List<SelectOption>();

        for(contact c:[select id, lastname, firstname, OracleContactID__c from contact where site__c =: idSiteID]){
            contacts.add(new SelectOption(c.OracleContactID__c, c.lastname + ', ' + c.firstname));
        }

        mapSiteIDtoOptions.put(idSiteID, contacts);

        string billingid = null;

        if(contacts.size() > 0){
            billingid = contacts[0].getValue();
        }


		Project_Site__c oProjectSite = new Project_Site__c(BillingContactID__c = billingid,  site__c = idSiteID, Project__c = oProject.id, name = SelectedSite.AccountName__c, Contribution__c = 0 );

        lstProjectSites.add(oProjectSite);

		if(lstProjectSites.size() == 0){
            system.debug('****DEBUG 2');
			oProjectSite.Is_Billing__c = true;
			oProjectSite.Is_Default_Top_Task__c = true;
			oProjectSite.Is_End__c = true;
			oProjectSite.Is_Primary_End__c = true;
            oProjectSite.Contribution__c = 100;

            oPrimaryEnd = oProjectSite;
            oTopTask = oProjectSite;

            oProject.pse__Account__c = SelectedSite.account__c;
            oProject.DefaultTopTaskCustomer__c = SelectedSite.account__c;
            oProject.PrimarySite__c = SelectedSite.id;

            oProject.PrimaryBillingClient__c = SelectedSite.id;
            oProject.PrimaryEndClient__c = SelectedSite.id;
		}

		save();
		UpdateProjectSites();


		return null;
	}

	public void save(){

			Savepoint oSavePoint = Database.setSavepoint();

            try {

                update oProject;
                upsert lstProjectSites;

            } catch (Exception e) {
                ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attmpting to update a Project. Please contact your administrator with the following error: ' + e);
                ApexPages.addMessage(oMsg);
                Database.rollback(oSavePoint);
                return;
            }
	}

    public PageReference stubsave(){
        save();
        return null;
    }


	/* Re-Usable Method for Querying Project Sites */
	public void UpdateProjectSites(){

    	string strSOQL = 'SELECT ';
    	
    	for (Schema.FieldSetMember fsmField: SObjectType.Project_Site__c.FieldSets.pse_ClientFinder_Display_Fieldset.getFields()) {
    		strSOQL += fsmField.getFieldPath() + ', ';
    	}
    	
    	strSOQL += 'BillingContactID__c, ID, SITE__C, Is_Billing__c, Is_Default_Top_Task__c, Is_End__c, Is_Primary_End__c, Site__r.Account__c, Contribution__c  FROM Project_Site__c WHERE Project__c=\'' + oProject.Id + '\'';

    	lstProjectSites = (list<Project_Site__c>)Database.query(strSOQL);


    	mapProjectSites = new map<id, Project_Site__c>();

    	for(Project_Site__c oProjectSite: lstProjectSites){
    		mapProjectSites.put(oProjectSite.site__c, oProjectSite);
    		if(oProjectSite.Is_End__c){
    			mapSitesEnd.put(oProjectSite.id, oProjectSite);
    		}
    		if(oProjectSite.Is_Billing__c){
    			mapSitesBilling.put(oProjectSite.id, oProjectSite);
    		}
    	}

        mapSiteIDtoOptions = new map<id, list<SelectOption>>();


        set<id> sitesid = new set<id>();

        for(Project_Site__c oProjectSite: lstProjectSites){
            sitesid.add(oProjectSite.SITE__C);
            mapSiteIDtoOptions.put(oProjectSite.Site__c, new List<SelectOption>());
        }
        

        for(contact c:[select id, lastname, firstname, OracleContactID__c, Site__c from contact where site__c IN: sitesid]){
            mapSiteIDtoOptions.get(c.Site__c).add(new SelectOption(c.OracleContactID__c, c.lastname + ', ' + c.firstname));
            system.debug('DEBUG****: ' + c.Site__c);
        }


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

	public PageReference ShowSiteSearch() {
		boolShowSiteSearch = true;
		return null;
	}


	/* Executes the request to handle dynamics parameters and query Sites */
	public PageReference SearchSites(){
    	/*string strSOQL = 'SELECT ';
    	//string strWhereClause = ' WHERE '; 
        string strWhereClause = ' WHERE OracleCustomerID__c != null ';  //only search for customers (filter out vendors)
    	boolean boolAtLeastOne = false;
    	   	
    	for (Schema.FieldSetMember fsmField: SObjectType.Site__c.FieldSets.pse_ClientFinder_Search_Result_Fieldset.getFields()) {
    		strSOQL += fsmField.getFieldPath() + ', ';
    	}
    	
    	strSOQL += 'ID FROM Site__c';

    	for (Schema.FieldSetMember fsmField: SObjectType.Site__c.FieldSets.pse_ClientFinder_Search_Fieldset.getFields()) {
    		
    		// Only add parameters to the "WhereClause" string if they contain valid values. 
    		// NOTE: only strings are supported by this code.
    		if ( recursiveGet(oSite,fsmField.getFieldPath()) != null) {
    			//strWhereClause += fsmField.getFieldPath() + ' LIKE \'%' + recursiveGet(oSite,fsmField.getFieldPath()) + '%\' AND ';
                strWhereClause += ' AND ' + fsmField.getFieldPath() + ' LIKE \'%' + recursiveGet(oSite,fsmField.getFieldPath()) + '%\' ';
    			boolAtLeastOne = true;
    		}
    	}    	
    	
    	// Determines if the code found at least one non-null/non-blank search parameter. If so, manipulate the "where string" to strip the last " AND " text
    	// and add it to the SOQL statement.
    	if (boolAtLeastOne) {
    		//strWhereClause = strWhereClause.substring(0,strWhereClause.length() - 5);
    		strSOQL += strWhereClause;
    	}
    	
    	strSOQL += ' LIMIT 50';

    	lstSitesSearchResults = (list<Site__c>)Database.query(strSOQL);
    	
    	if(lstSitesSearchResults.size() > 0){
    		booDisplaySiteSearchResult = true;

    		mapSearchSites = new map<id, Site__c>();

    		for (Site__c oSearchSite: lstSitesSearchResults){
    			mapSearchSites.put(oSearchSite.id, oSearchSite);
    		}
    	}

    	strSearchResults = string.valueof(lstSitesSearchResults.size()) + ' Record(s) Found';
    	
    	return null;		*/


        string strSOQL = 'SELECT ';
        string strWhereClause = ' WHERE '; 
        boolean boolAtLeastOne = false;
            
        for (Schema.FieldSetMember fsmField: SObjectType.Site__c.FieldSets.pse_ClientFinder_Search_Result_Fieldset.getFields()) {
            strSOQL += fsmField.getFieldPath() + ', ';
        }
        
        strSOQL += 'ID, Account__c, OracleCustomerID__c, CustomerSiteUseCode__c FROM Site__c';

        for (Schema.FieldSetMember fsmField: SObjectType.Site__c.FieldSets.pse_ClientFinder_Search_Fieldset.getFields()) {
            
            // Only add parameters to the "WhereClause" string if they contain valid values. 
            // NOTE: only strings are supported by this code.
            if ( recursiveGet(oSite,fsmField.getFieldPath()) != null) {
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
        
        strSOQL += ' LIMIT ' + sSiteLimit;

        lstSitesSearchResults = (list<Site__c>)Database.query(strSOQL);

        IF(lstSitesSearchResults.size() < integer.valueof(siteLessLIMIT)){
            bShowMoreButtonSite = false;
        } else {
            bShowMoreButtonSite = true;
        }

        
        booDisplaySiteSearchResult = true;

        if(lstSitesSearchResults.size() > 0) {
            
            map<string, Site__c> mapUniqueSites = new map<string, Site__c>();
            mapSearchSites = new map<id, Site__c>();

            for (Site__c oSearchSite: lstSitesSearchResults){
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

            lstSitesSearchResults = mapUniqueSites.values();


        }


        return null;         
	}

	public PageReference BillingSelect(){

        for (Project_Site__c oSiteWrapper: lstProjectSites) {
            if(oSiteWrapper.id == idSiteID){
                if (oSiteWrapper.Is_Billing__c) {
                    mapSitesBilling.put(idSiteID, oSiteWrapper);
                } else {
                    mapSitesBilling.remove(idSiteID);
                    oSiteWrapper.Is_Default_Top_Task__c = false;
                    oTopTask = null;
                }
            }
        }

        if(oTopTask == null && mapSitesBilling.size() > 0){
            mapSitesBilling.values()[0].Is_Default_Top_Task__c = true;
            oTopTask = mapSitesBilling.values()[0];
        }

        save();
		UpdateProjectSites();

        return null;
    }

    public PageReference EndSelect(){
        for (Project_Site__c oSiteWrapper: lstProjectSites) {
            if(oSiteWrapper.id == idSiteID){
                if (oSiteWrapper.Is_End__c) {
                    mapSitesEnd.put(idSiteID, oSiteWrapper);
                } else {
                    mapSitesEnd.remove(idSiteID);
                    oSiteWrapper.Is_Primary_End__c = false;
                    oPrimaryEnd = null;
                }
            }
        }

        if(oPrimaryEnd == null && mapSitesEnd.size() > 0){
            mapSitesEnd.values()[0].Is_Primary_End__c = true;
            oPrimaryEnd = mapSitesEnd.values()[0];
            idSiteID = oPrimaryEnd.id;
            //SearchOpportunities();
        }

        if(mapSitesEnd.size() == 0) {
            strSearchResults = null;
        }

        save();
		UpdateProjectSites();

        return null;
    }


    public PageReference DefaultTopSelect(){

        for (Project_Site__c oSiteWrapper: lstProjectSites) {
            if(oSiteWrapper.id == idSiteID){
                oSiteWrapper.Is_Default_Top_Task__c = true;
                oTopTask = oSiteWrapper;
                oProject.DefaultTopTaskCustomer__c = oSiteWrapper.site__r.account__c;

                oProject.PrimaryBillingClient__c = oSiteWrapper.site__c;
            } else {
                oSiteWrapper.Is_Default_Top_Task__c = false;
            }
        }

    

		save();
		UpdateProjectSites();

        return null;
    }


    public PageReference PrimaryEndSelect(){

        for (Project_Site__c oSiteWrapper: lstProjectSites) {
            if(oSiteWrapper.id == idSiteID){
                oSiteWrapper.Is_Primary_End__c = true;
                oPrimaryEnd = oSiteWrapper;
                oProject.pse__Account__c = oSiteWrapper.site__r.account__c;
                oProject.PrimarySite__c = oSiteWrapper.site__c;

                oProject.PrimaryEndClient__c = oSiteWrapper.site__c;
            } else {
                oSiteWrapper.Is_Primary_End__c = false;
            }
        }

		save();
		UpdateProjectSites();

        return null;
    }


}