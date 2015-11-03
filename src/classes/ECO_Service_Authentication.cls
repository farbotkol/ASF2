public class ECO_Service_Authentication {

	public static boolean authenticateOracleToken(Id userId)
	{
		Datetime timestamp = DateTime.now();
		list<User> users = [select Id, Name, ShaKey__c, NormalTransDateTime__c from User where Id = :UserInfo.getUserId() and NormalTransDateTime__c > :timestamp  and ShaKey__c != null and ShaKey__c != '' limit 1];


		if(!users.isEmpty())
		{
			return true;
		}

		return false;
	}

	private static void storeAuthenticationForUser(PICRequestStatus requestStatus)
	{
		User user = [select Id, ShaKey__c, NormalTransDateTime__c from User where Id = :UserInfo.getUserId()];

		user.NormalTransDateTime__c = requestStatus.NormalTrans;
		user.ShaKey__c = requestStatus.ShaKey;

		update user;

	}

	public static string TestProxy(string url, string body){
		Http h = new Http();

	    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
	    HttpRequest req = new HttpRequest();
	    req.setEndpoint(url);
	    req.setMethod('GET');
        
        req.setCompressed(true);
        req.setTimeout(30000);
        req.setClientCertificateName('ECOProjService');
        
        req.setBody(body);
        String returnResult = '';
        String result = '';
        PICRequestStatus requestStatus;
	    // Send the request, and return a response
	    try{
	    	HttpResponse res = h.send(req);
			result = res.getBody();
			if(!String.isEmpty(result)){
		    	result = result.trim();
		    	
				requestStatus = new PICRequestStatus();
				requestStatus.Status = 'SENT';

				requestStatus = parseXMLResponse(result);
				returnResult = requestStatus.Status + requestStatus.Message;
			}
	    }
	    catch(Exception e)
	    {
	    	return e.getMessage() + result;
	    }

	    if(requestStatus.Status == 'SUCCESS')
	    {
	    	storeAuthenticationForUser(requestStatus);
	    	returnResult = 'SUCCESS';
	    }

	    return returnResult;
	}

    public class PICRequestStatus {
        public String Status {get;set;}
        public String Message {get;set;}
        public String Details {get;set;}
        public DateTime NormalTrans {get;set;}
        public String ShaKey {get; set;}
    } 	

    private static PICRequestStatus parseXMLResponse(String xml){
        //example of response xml
        //<?xml version="1.0" encoding="UTF-8"?> <PICRequestStatus> <Status>SUCCESS</Status> <Message></Message> <Details></Details> </PICRequestStatus>

        Dom.Document doc = new Dom.Document();
        doc.load(xml);

        PICRequestStatus requestStatus = new PICRequestStatus();
        String result = '';

        for(dom.XmlNode node : doc.getRootElement().getChildElements()) {
            String nodeName = node.getName().toLowerCase();
            if(nodeName =='status') {
                requestStatus.Status = node.getText();
            }
            else if(nodeName == 'message') 
            {
                requestStatus.Message = node.getText();
            } 
            else if(nodeName == 'details') 
            {
                requestStatus.Details = node.getText();
            }
            else if(nodeName == 'shakey')
            {
            	requestStatus.ShaKey = node.getText();
            }
            else if(nodeName == 'outputparams')
            {
            	dom.xmlNode node1 = node.getChildElement('NormalTrans', null);
            	//requestStatus.NormalTrans = DateTime.parse(node1.getText());
            	requestStatus.NormalTrans = ECO_Utils_Date.getDateTimeFromPICRequestStatusString(node1.getText());
            	dom.xmlNode node2 = node.getChildElement('ShaKey', null);
            	requestStatus.ShaKey = node2.getText();

            }
			else if(nodeName == 'normaltrans')
			{
				requestStatus.NormalTrans = DateTime.parse(node.getText());
			}            
        } 

        return requestStatus;       
    } 	

}