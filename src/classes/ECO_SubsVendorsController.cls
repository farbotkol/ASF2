public with sharing class ECO_SubsVendorsController 
{
	public List<VendorSub__c> lVendorSubs {get; set;}
	public List<VendorSub__c> lDelete_VendorSubs {get; set;}
	public ApexPages.StandardController oStandardController {get; set;}
	public pse__Proj__c oProject {get; set;}
	public String recordObjectType {get; set;}
	public String recordObjectId {get; set;}
	public String strSearchResults {get;set;}
	public list<Site__c> lstSitesSearchResults {get;set;}
	public map<id, Site__c> mapSearchSites {get;set;}
	public string strNoRecords {get;set;}
	public boolean boolShowSiteSearch {get;set;}
	public boolean booDisplaySiteSearchResult {get;set;}
	public id idSiteID {get;set;}
	public Site__c oSite {get;set;}
	public map<id, VendorSite__c> mapVendorSites {get;set;}
	public map<id, VendorSite__c> mapSitesBilling {get;set;}
    public map<id, VendorSite__c> mapSitesEnd {get;set;}
    public list<ProjectAgreement__c> lstAgreements {get;set;}
    public list<VendorSite__c> lstVendorSites {get;set;}
    public integer removeSiteVendoRowNum {get;set;}
    public boolean bMore {get;set;}
    public string sLimit;

    private static string siteLessLIMIT = '50';
    private static string siteMoreLIMIT = '200';

    public OrganizationString__c userOrg {get;set;}
    public boolean bSearchOutsideUserOrg {get;set;}


    public string projectFieldID {get;set;}
    public string vendorFieldID {get;set;}

    public siteWrapper oSW{get;set;}

    public id sVendor {get;set;}
    //public list<SiteWrapper> lstSites {get;set;}
    //public map<id, SiteWrapper> mapSites {get;set;}
    private VendorSite__c oTopTask;
    private VendorSite__c oPrimaryEnd;


    public class siteWrapper{
        public site__c oSite {get;set;}
        public string name {get;set;}
        public string city {get;set;}
        public string state {get;set;}
        public string country {get;set;}

        public siteWrapper(site__c oSite){
            this.oSite = oSite;
        }

        public void populatedSite(){
            oSite.account__r.name = name;
            oSite.City__c = city;
            oSite.State__c = state;
            oSite.Country__c = country;
        }

    }

	public ECO_SubsVendorsController(ApexPages.StandardController oStandardController) 
	{
		this.oStandardController = oStandardController;
		oProject = (pse__Proj__c)oStandardController.getRecord();
		mapSitesBilling = new map<id, VendorSite__c>();
        mapSitesEnd = new map<id, VendorSite__c>();
        oSite = new Site__c();
        oSite.account__r = new Account();

        oSW = new siteWrapper(oSite);

        bMore = false;
        sLimit = siteLessLIMIT;
        bSearchOutsideUserOrg = false;

        list<user> lUser = [SELECT ECO_OrganizationName__c FROM User WHERE ID =:UserInfo.getUserId()];

        list<OrganizationString__c> lUserOrganizations = [SELECT Id, Name, OrganizationName__c, GeographyName__c, Region__c, District__c, Department__c, BusinessLineName__c, LocationName__c, PLManagerContact__c, ProjectOwning__c, FinanceandAccountingManagerContact__c, CFOorDelegateContact__c, OUID__c, CurrencyIsoCode, ProjectApprover__c, ProjectAccountant__c, ProjectAccountant2__c, FinanceLead2__c FROM OrganizationString__c WHERE Name =: lUser[0].ECO_OrganizationName__c and ProjectOwning__c=true];

        if(lUserOrganizations.size() > 0){
            userOrg = lUserOrganizations[0];
        } else {
            userOrg = null;
        }

		if(oProject != null)
		{
			lVendorSubs = new List<VendorSub__c>([Select Id, Account__c, ContactName__c, ServicesType__c, VendorName__c, Phone__c, Email__c From VendorSub__c Where Project__c = :oProject.Id]);
			if(lVendorSubs.isEmpty())
			{
				lVendorSubs.add(new VendorSub__c(Project__c = oProject.Id));
			}
			lDelete_VendorSubs = new List<VendorSub__c>();

			//lstSites = new list<SiteWrapper>();
        	//mapSites = new map<id, SiteWrapper>();
			UpdateVendorSites();

            string projID = oProject.Id;
            string strSOQL = 'SELECT ';
            string strWhereClause = ' WHERE '; 
                
            for (Schema.FieldSetMember fsmField: SObjectType.ProjectAgreement__c.FieldSets.SubVendorView.getFields()) {
                strSOQL += fsmField.getFieldPath() + ', ';
            }
            
            strSOQL += 'ID FROM ProjectAgreement__c WHERE Project__c =: projID';

            lstAgreements = (list<ProjectAgreement__c>)Database.query(strSOQL);


		}

        

        /*map<string, string> mNameToID = ECO_Utils_Tooling.getFieldIDMap('POHeader');

        projectFieldID = mNameToID.get('Project__c');
        vendorFieldID = mNameToID.get('VendorSite__c');

        projectFieldID = 'CF' + projectFieldID.substring(0,15);
        vendorFieldID = 'CF' + vendorFieldID.substring(0,15);*/
	}

    public PageReference toggle(){
        if(bMore){
            bMore = false;
            sLimit = siteLessLIMIT;
        } else {
            bMore = true;
            sLimit = siteMoreLIMIT;
        }

        SearchSites();
        return null;
    }

    public PageReference removeSiteVendoRowNum(){

        VendorSite__c vs = lstVendorSites[removeSiteVendoRowNum-1];
        lstVendorSites.remove(removeSiteVendoRowNum-1);
        delete vs;
        return null;
    }

    public PageReference AddPO(){
        POHeader__c po = new POHeader__c();
        po.Project__c = oProject.id;

        insert po;

        PageReference oPR = new PageReference('/' + po.id);
        oPR.getParameters().put('saveURL', '/apex/ECO_SubVendors?Id=' + oProject.id);
        oPR.getParameters().put('retURL', '/apex/ECO_SubVendors?Id=' + oProject.id + '&RecordToDelete='+ po.Id + '&DeleteRecordType=PurchaseOrder');
        return oPR;        
    }

	public PageReference ReturnToProject()
	{
		PageReference oPR = new PageReference('/' + oProject.Id);
		oPR.setRedirect(true);
		return oPR;
	}

    public PageReference CreateUpdateVendor()
    {
        //PageReference oPR = new PageReference('/setup/ui/recordtypeselect.jsp?ent=01Ie00000005dVe&retURL=%2Fa6e%2Fo&save_new_url=%2Fa6e%2Fe%3FretURL%3D%252Fa6e%252Fo');
        
        //return oPR;

        return null;
    }    
/*
	public PageReference SaveAll()
	{
		PageReference oPR;
		for(Integer i=0; i<lVendorSubs.size(); i++)
		{
			if(lVendorSubs[i].Account__c == null)
				lVendorSubs.remove(i);
		}
		try
		{
			upsert lVendorSubs;
			delete lDelete_VendorSubs;
			oPR = ApexPages.currentPage();
			oPR.getParameters().clear();
			oPR.getParameters().put('id', oProject.Id);
			oPR.setRedirect(true);
		}
		catch(DMLException e)
		{
			System.debug('Error: ' + e.getMessage());
			ApexPages.addMessages(e);
		}
		return oPR;
	}
	
	public void addRecord()
	{
		if(recordObjectType == 'VendorSub__c')
		{
			lVendorSubs.add(new VendorSub__c(Project__c = oProject.Id));
		}
	}

	public void removeRecord()
	{
		if(recordObjectType == 'VendorSub__c')
		{
			for(Integer i=0; i<lVendorSubs.size(); i++)
			{
				if(lVendorSubs[i].Id == recordObjectId)
					lDelete_VendorSubs.add(lVendorSubs.remove(i));
			}
		}
	}

	public PageReference SelectSite(){

        if (!mapSites.containskey(idSiteID)) 
        {
            SiteWrapper oSite = new SiteWrapper(mapSearchSites.get(idSiteID));
            mapSites.put(idSiteID, oSite);
            lstSites.add(oSite);
        }
        return null;
    }
*/
    public PageReference SelectSiteAsSub()
    {
    	VendorSite__c oVS = new VendorSite__c();
    	//oVS.Name = mapSearchSites.get(idSiteID).Name;
    	oVS.Project__c = oProject.Id;
    	oVS.Site__c = idSiteID;
    	oVS.Type__c = 'Sub';
    	insert oVS;
    	UpdateVendorSites();
        return null;
    }

    public PageReference SelectSiteAsVendor()
    {
        VendorSite__c oVS = new VendorSite__c();
    	//oVS.Name = mapSearchSites.get(idSiteID).Name;
    	oVS.Project__c = oProject.Id;
    	oVS.Site__c = idSiteID;
    	oVS.Type__c = 'Vendor';
    	insert oVS;
    	UpdateVendorSites();
        return null;
    }
/*
	public void save()
	{

		Savepoint oSavePoint = Database.setSavepoint();

        try {

            update oProject;
            upsert lstVendorSites;

        } catch (Exception e) {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attmpting to update a Project. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            Database.rollback(oSavePoint);
            return;
        }
	}
*/



	public void UpdateVendorSites()
	{
    	string strSOQL = 'SELECT ';
    	
    	for (Schema.FieldSetMember fsmField: SObjectType.VendorSite__c.FieldSets.VendorFinder_Display_Fieldset.getFields()) {
    		strSOQL += fsmField.getFieldPath() + ', ';
    	}
    	
    	strSOQL += 'ID, SITE__c, Site__r.City__c, Site__r.State__c, Site__r.Country__c, Site__r.Account__c, Site__r.AccountName__c, name FROM VendorSite__c WHERE Project__c=\'' + oProject.Id + '\'';


    	lstVendorSites = (list<VendorSite__c>)Database.query(strSOQL);


    	mapVendorSites = new map<id, VendorSite__c>();

    	for(VendorSite__c oVendorSite: lstVendorSites)
    	{
    		mapVendorSites.put(oVendorSite.site__c, oVendorSite);
    	}
	}

	/* Utility Method used for recursively obtaining a field from a multiple object relationship */
  	private Object recursiveGet(sObject record, String field) 
  	{
  		System.debug('recursiveGet: field: ' + field);
		if(field.contains('.')) {
			Integer firstPeriod = field.indexOf('.');
			String nextObjectName = field.subString(0, firstPeriod);
			String remainingfieldName = field.subString(firstPeriod + 1, field.length());
			sObject nextObject = record.getSObject(nextObjectName);
			System.debug('recursiveGet: nextObject: ' + nextObject);
			if(nextObject == null) {
				return null;
			} else {
				return recursiveGet(nextObject, remainingfieldName);
			}
		} else {
			System.debug('recursiveGet: search field value: ' + record.get(field));
			return record.get(field);	
		}
	}
	

	public PageReference SearchSites(){

        oSW.populatedSite();

		System.debug('oSite: ' + oSite);
        ResetValues();

        string strSOQL = 'SELECT ';
        //string strWhereClause = ' WHERE Account__r.Type__c = \'Vendor\' AND'; 
        boolean boolAtLeastOne = false;
            
        for (Schema.FieldSetMember fsmField: SObjectType.Site__c.FieldSets.pse_ClientFinder_Search_Result_Fieldset.getFields()) {
            strSOQL += fsmField.getFieldPath() + ', ';
        }
        
        strSOQL += 'ID, Account__c FROM Site__c WHERE Account__r.Type__c = \'Vendor\' AND ';

        for (Schema.FieldSetMember fsmField: SObjectType.Site__c.FieldSets.pse_ClientFinder_Search_Fieldset.getFields()) 
        {
        	System.debug('field path: ' + fsmField.getFieldPath());
        	if ( recursiveGet(oSite,fsmField.getFieldPath()) != null && recursiveGet(oSite,fsmField.getFieldPath()) != '') 
        	{

                strSOQL += fsmField.getFieldPath() + ' LIKE \'%' + recursiveGet(oSite,fsmField.getFieldPath()) + '%\' AND ';
                boolAtLeastOne = true;
            }
        }       
        strSOQL = strSOQL.substring(0,strSOQL.length() - 5);
        
        if(bSearchOutsideUserOrg){
            strSOQL += ' LIMIT ' + sLimit;
        } else {

            string userOrgID = userOrg.OUID__c;
            System.debug('userOrgID: ' + userOrgID);
            strSOQL += ' AND OUID__c =: userOrgID  LIMIT ' + sLimit;
        }

        System.debug('SubsVendors search query: ' + strSOQL);

        lstSitesSearchResults = (list<Site__c>)Database.query(strSOQL);
        
        booDisplaySiteSearchResult = true;

        if(lstSitesSearchResults.size() > 0)
        {
            
            mapSearchSites = new map<id, Site__c>();

            for (Site__c oSearchSite: lstSitesSearchResults){
                mapSearchSites.put(oSearchSite.id, oSearchSite);
            }
        }

        strSearchResults = string.valueof(lstSitesSearchResults.size()) + ' Record(s) Found';

        //lstSites = new list<SiteWrapper>();
        //mapSites = new map<id, SiteWrapper>();
        //lstSearchOpportunities = new list<Opportunity>();

        return null;        
    }

	private void ResetValues()
	{
        //lstVendorSites = new list<VendorSite__c>();
        boolShowSiteSearch = false;
        booDisplaySiteSearchResult = false;
    }
/*
    public class SiteWrapper {
        public Site__c oSite {get;set;}
        public String strType {get;set;}

        public boolean booIsBilling {get;set;}
        public boolean booIsDefaultTopTask {get;set;}
        public boolean booIsEnd {get;set;}
        public boolean booIsPrimaryEnd {get;set;}

        public SiteWrapper(Site__c oTargetSite){
            this.oSite = oTargetSite;
            booIsBilling = false;
            booIsDefaultTopTask = false;
            booIsEnd = false;
            booIsPrimaryEnd = false;
        }
    }
*/
}