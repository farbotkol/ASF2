public with sharing class ECO_SmartSearchController extends ECO_PageControllerBase {
	
    public List<pse__Proj__c> projects					{ get; set; }
	public List<Configuration__c> reports				{ get; set; }
	public List<Configuration__c> applications			{ get; set; }
	public User theUser									{ get; set; }
	public List<ProcessInstanceWorkitem> approvals		{ get; set; }
	public List<Task> tasks								{ get; set; }
	public List<PortalMessage__c> alerts				{ get; set; }
	public List<PortalMessage__c> tickerMessages		{ get; set; }
	public List<SelectOption> projectOutputTypes		{ get; set; }
	public String selectedOutputType					{ get; set; }
	public List<Schema.FieldSetMember> fieldSetFields	{ get; set; }
	public Boolean showClosed							{ get; set; }
	public ProjectTeamMember__c ptmPickListProvider		{ get; set; }
	public String photoUrl								{ get; set; }
	public List<PortalMessage__c> newsFeed				{ get; set; }
	public String awanJSPath							{ get; set; }
    
    public String coveoToken							{get; set;}
    public String endPointURL							{get; set;}
    
    public String collaborationGroups					{get; set;}

    private class ECO_SmartSearchControllerException extends Exception {}    
    private System.LoggingLevel debugLevel = LoggingLevel.INFO;
    
    public ECO_SmartSearchController() {
        
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=10');
		
		projectOutputTypes = new List<SelectOption>();
		projectOutputTypes.add(new SelectOption('ECO_QuickFields', 'Quick View'));
		projectOutputTypes.add(new SelectOption('ECO_GeneralFields', 'General'));
		projectOutputTypes.add(new SelectOption('ECO_FinancialFields', 'Detailed Financial'));
		projectOutputTypes.add(new SelectOption('ECO_BillingFields', 'Billing'));
		projectOutputTypes.add(new SelectOption('ECO_ProgressFields', 'Progress'));
		
		ptmPickListProvider = new ProjectTeamMember__c();
		
		selectedOutputType = 'ECO_GeneralFields';
		
		changeProjectOutputType();
		
		awanJSPath = ECO_PortalSettings__c.getInstance().OnAWANJavascriptPath__c;
		
		showClosed = false;
		
		theUser = ECO_Service_Users.getUserInfoById(UserInfo.getUserId());
		approvals = ECO_Service_Users.getApprovalsForUser(theUser.Id);
		tasks = ECO_Service_Users.getOpenTasksForUser(theUser.Id);
		alerts = ECO_Utils_Alerts.getPortalMessagesForUser(theUser.Id);
		tickerMessages = ECO_Utils_Alerts.getTickerMessages();
		refreshProjects();
		reports = ECO_Service_Reports.getReportsForUser(theUser.Id);
		newsFeed = ECO_Utils_Alerts.getNewsFeedForPortal();
		if (!Test.isRunningTest()) {
			photoUrl = ConnectApi.ChatterUsers.getPhoto(null, theUser.Id).smallPhotoUrl;
		}
        setCollaborationGroups();
    }
    
    public void setCollaborationGroups(){
        List<CollaborationGroupMember> cgmList = [select CollaborationGroupId from CollaborationGroupMember where MemberId=:UserInfo.getUserId()];

		List<Id> cgmIdsList = new List<Id>();
        for (CollaborationGroupMember cgm : cgmList){
        	cgmIdsList.add(cgm.CollaborationGroupId);
        }
		collaborationGroups = String.join(cgmIdsList, ',');
    }
    
    public PageReference getSearchToken() {
        applications = ECO_Service_Applications.getSortedList(theUser);
        ECO_Smart_Search_Settings__c smartSearchSetting = ECO_Smart_Search_Settings__c.getInstance('SmartSearch');
        endPointURL = smartSearchSetting.endPointURL__c;
        String randomKey = smartsearchSetting.Key__c;
        String orgId = UserInfo.getOrganizationId();
        
        // Make endpointURL and key passed to the server configurable.
    	Http http = new Http();
        String orgIdFilter = '(@sforganizationid=('+orgId.substring(0, 15)+') OR NOT @sforganizationid)';//every saleforce document from current org  + everything  that is not Salesforce conent
        String jsonReq = '{"userIds": [{"name":"' + UserInfo.getUserEmail() + '", "provider" : "Email Security Provider", "type" : "User"}],"filter": "'+orgIdFilter+'"}';
        System.debug('jsonReq: ' + jsonReq);
        String endPoint = endPointURL + 'token';
        
        HttpRequest request = new HttpRequest();
        
        request.setMethod('POST');
        
        request.setHeader('content-type', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + randomKey);
        request.setEndpoint(endPoint);
        request.setBody(jsonReq);
        
        HTTPResponse response = http.send(request);
        system.debug('Response: ' + response.getBody());
        
        System.debug('response.getStatusCode(): ' + response.getStatusCode());
		if(response.getStatusCode() == 200) {
            System.debug('parsing record');
            JSONParser parser = JSON.createParser(response.getBody());
            parser.nextToken();
			parser.nextValue();
            coveoToken = parser.getText();
        }
        else {
            coveoToken = null;
        }
        system.debug('coveoToken: ' + coveoToken);
        
        return null;
    }
    
    public PageReference refreshProjects () {
		projects = ECO_Service_Projects.getProdjectsForUser(theUser.Id, showClosed, ptmPickListProvider.Role__c);
		return null;
	}
	
	public PageReference changeProjectOutputType () {
		
		Schema.DescribeSObjectResult d = pse__Proj__c.sObjectType.getDescribe();
		Schema.FieldSet fs = d.fieldSets.getMap().get(selectedOutputType);
		
		fieldSetFields = fs.getFields();
		
		return null;
	}
	
	public PageReference goToApplicationConfiguration () {
		PageReference returnPR = Page.ECO_ApplicationCustomizer;
		returnPR.getParameters().put('retURL', EncodingUtil.urlEncode('/apex/ECO_Portal', 'UTF-8'));
		return returnPR;
	}
 
	public PageReference goToApplicationConfigurationv2 () {
		PageReference returnPR = Page.ECO_ApplicationCustomizer;
		returnPR.getParameters().put('retURL', EncodingUtil.urlEncode('/apex/ECO_Portalv2', 'UTF-8'));
		return returnPR; 
	}
	
	public PageReference goToReportBuilder () {
		PageReference returnPR = Page.ECO_ReportFinder;
		returnPR.getParameters().put('retURL', EncodingUtil.urlEncode('/apex/ECO_Portal', 'UTF-8'));
		return returnPR;
	}

	public PageReference goToReportBuilderv2 () {
		PageReference returnPR = Page.ECO_ReportFinder;
		returnPR.getParameters().put('retURL', EncodingUtil.urlEncode('/apex/ECO_Portalv2', 'UTF-8'));
		return returnPR;
	}
	
	public PageReference goToNewProject () {
		
		//PageReference pageRef = Page.ECO_ProjectSetup;
		PageReference pageRef = new PageReference('/'+pse__Proj__c.sObjectType.getDescribe().getKeyPrefix()+'/e');
		pageRef.getParameters().put('retURL', EncodingUtil.urlEncode('/apex/ECO_Portal', 'UTF-8'));
		return pageRef;
	}
	
	public PageReference goToNewOpportunity () {
		//PageReference pageRef = new PageReference('/setup/ui/recordtypeselect.jsp?ent=Opportunity&retURL=%2F006%2Fo&save_new_url=%2F006%2Fe%3FretURL%3D%252F006%252Fo');
		PageReference pageRef = new PageReference('/'+Opportunity.sObjectType.getDescribe().getKeyPrefix()+'/e');
		return pageRef;
	}

	public PageReference goToHome () {
		PageReference pageRef = new PageReference('/home/');
		return pageRef;
	}
}