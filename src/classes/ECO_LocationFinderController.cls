public with sharing class ECO_LocationFinderController extends ECO_PageControllerBase {
	
	public String searchLocationName								{ get; set; }
	public Map<Id, ConfigItemWrapper> configItemsOnPage			{ get; set; }
	public Map<Id, Configuration__c> selectedConfigItems		{ get; set; }
	public Id selectedLocationId									{ get; set; }
	public User theUser											{ get; set; }
	public List<Configuration__c> configItemsFromReportQuery	{ get; set; }
	
	private Date fromDate;
	private class ECO_ReportFinderControllerException extends Exception {}
	private System.LoggingLevel debugLevel = LoggingLevel.INFO;
	private String retURL;
	
	public ECO_LocationFinderController () {
		this.configItemsOnPage = new Map<Id, ConfigItemWrapper>();
		this.selectedConfigItems = new Map<Id, Configuration__c>();
		this.theUser = new User();
		this.theUser.Date_of_Birth__c = Date.today().addYears(-1);
		
		this.searchLocationName = '';
		
		this.retURL = '';
		
		// perform the first search
		doSearch();
	}
	
	public PageReference doSearch () {
		if (searchLocationName != '' && searchLocationName.length() < 3) {
			ApexPages.AddMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Search term must contain at least 3 characters.'));
			return null;
		}
		
		// This only performs the search, then terms are changed or if they want to reset
		configItemsFromReportQuery = new List<Configuration__c>();
		for (Report r : Database.query(buildQueryString())) {
			Configuration__c config = new Configuration__c();
			config.ReportId__c = r.Id;
			config.ReportName__c = r.Name;
			config.User__c = theUser.Id;
			configItemsFromReportQuery.add(config);
		}
		
		populateCurrentRecords();
		
		return null;
	}
	
	public PageReference clearSearchTerms () {
		this.theUser.Date_of_Birth__c = null;
		this.searchLocationName = '';
		doSearch();
		return null;
	}
	
	public PageReference selectItem () {
		if (selectedConfigItems.size() == 5) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'You may not select more than 5 reports.'));
			return null;
		}
		
		system.debug(debugLevel, 'selectedLocationId:  '+selectedLocationId);
		system.debug(debugLevel, 'configItemsOnPage:  '+this.configItemsOnPage);
		
		if (selectedLocationId == null) {
			ApexPages.AddMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'No report found with Id:  '+selectedLocationId));
			return null;
		}
		
		selectedConfigItems.put(selectedLocationId, this.configItemsOnPage.get(selectedLocationId).theConfigItem);
		
		system.debug(debugLevel, 'selectedConfigItems:  '+this.selectedConfigItems);
		
		markSelectedRecords();
		
		return null;
	}
	
	public PageReference removeItem () {
		selectedConfigItems.remove(selectedLocationId);
		markSelectedRecords();
		return null;
	}

	public PageReference cancel () {
		return new PageReference('/'+retURL);
	}
	
	public PageReference save () {
		System.savePoint sp = Database.setSavePoint();
		
		try {
			delete [SELECT Id 
					FROM Configuration__c 
					WHERE RecordType.Name = :ECO_Constants.Configuration_ApplicationReportRecordTypeName
						AND User__c = :theUser.Id];
						
			if (!selectedConfigItems.isEmpty()) {
				insert selectedConfigItems.values();
			}
			
			return new PageReference('/'+retURL);
		} catch (Exception e) {
			ApexPages.addMessages(e);
		}
		return null;
	}
	
	public String buildQueryString () {
		fromDate = theUser.Date_of_Birth__c;  // Again, just using the user to provide the date field
		
		String queryString	= 'SELECT Id';
		queryString			+= ' , Name';
		queryString			+= ' , Description';
		queryString			+= ' , Format';
		queryString			+= ' FROM Report';
		queryString			+= ' WHERE Id != null'; // Why get fancy over whether I need a where clause... 
		if (fromDate != null) {
			queryString			+= ' AND CreatedDate >= :fromDate'; 
		}
		if (searchLocationName != '') {
			queryString			+= ' AND Name LIKE \'%'+searchLocationName+'%\'';
		}
		queryString			+= ' ORDER BY Name ASC';
		queryString			+= ' LIMIT 100';
		
		return queryString;
	}
	
	private void populateCurrentRecords () {
		
		this.configItemsOnPage.clear();
		
		//for (Configuration__c ci : (List<Configuration__c>)this.allConfigItems.getRecords()) {
		for (Configuration__c ci : configItemsFromReportQuery) {
			ConfigItemWrapper ciw = new ConfigItemWrapper(ci);
			
			this.configItemsOnPage.put(ciw.theConfigItem.ReportId__c, ciw);
		}
		
		markSelectedRecords();
	}
	
	private void markSelectedRecords () {
		for (ConfigItemWrapper ciw : this.configItemsOnPage.values()) {
			if (selectedConfigItems.keySet().contains(ciw.theConfigItem.ReportId__c)) {
				ciw.selected = true;
			} else {
				ciw.selected = false;
			}
		}
	}
	
	public class ConfigItemWrapper {
		public Boolean selected {get;set;}
		public Configuration__c theConfigItem {get;set;}
		
		public ConfigItemWrapper (Configuration__c ci) {
			this.theConfigItem = ci;
			this.selected = false;
		}
	}
	
}