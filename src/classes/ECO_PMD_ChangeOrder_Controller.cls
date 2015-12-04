global with sharing class ECO_PMD_ChangeOrder_Controller {
	public ECO_PMD_ChangeOrder_Controller() {
		
	}


  @RemoteAction
    global static ChangeOrderDetails getChangeOrderDetails(String projectNum)
    {
        Id projectId = projectNum;

        ChangeOrderDetails codetails = new ChangeOrderDetails();
        
        try
        {
            // GET THE LATEST TWO SNAPSHOTS FOR THE PROJECT
            AggregateResult[] groupedResults = [SELECT count(Id) CNT, ApprovalStatus__c
					FROM ChangeManager__c
					where  Project__c  = :projectId
					Group BY ApprovalStatus__c];

			System.debug('lfxxxx' +  groupedResults);		
			for (AggregateResult result : groupedResults)
			{

				System.debug('lfxxxx' +  result);

				if ((string)result.get('ApprovalStatus__c') == null)	
				{
					codetails.draftCount += (Integer)result.get('CNT');
				}
				else if  (((string)result.get('ApprovalStatus__c')).contains('Submitted') )
				{
					codetails.submitedCount += (Integer)result.get('CNT');
				}
				else if  (((string)result.get('ApprovalStatus__c')).contains('Approved') )
				{
					codetails.approvedCount += (Integer)result.get('CNT');
				}
				else if  (((string)result.get('ApprovalStatus__c')).contains('Rejected') || ((string)result.get('ApprovalStatus__c')).contains('Cancelled'))
				{
					codetails.notApprovedCount += (Integer)result.get('CNT');
				}
			}

       		List<ChangeOrderData> codata = new List<ChangeOrderData>();
            codata.add(new ChangeOrderData('Original Budget', 1293.97));
            codata.add(new ChangeOrderData('Submitted', -200));
            codata.add(new ChangeOrderData('Approved', 400));
            codata.add(new ChangeOrderData('Total1', 'Anticipated Budget'));

            codetails.codata = codata;
       
        }
        catch (Exception ex){

            codetails.error = ex.getMessage() + ' ' + ex.getLineNumber();
            codetails.nodata = true;
        }

        return codetails;
    }

    global class ChangeOrderData
    {
    	public ChangeOrderData(string lname , decimal lvalue )
    	{
    		name = lname;
    		value = lvalue;
    	}

    	public ChangeOrderData(string lname , string lsummary )
    	{
    		name = lname;
    		summary = lsummary;
    	}

    	public String name;
    	public decimal value;
    	public String summary;
    }

	global class ChangeOrderDetails
    {
        public ChangeOrderDetails()
        {
          
            error = '';
            nodata = false;

            draftCount = 0;
            submitedCount = 0;
            approvedCount = 0;
            notApprovedCount = 0;

            codata = null;

        }

        public String error;
        public Boolean nodata;

        public Integer  draftCount;
        public Integer  submitedCount;
        public Integer  approvedCount;
        public Integer  notApprovedCount;

        public List<ChangeOrderData> codata;



    }
}