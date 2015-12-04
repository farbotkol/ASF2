public with sharing class NewContractReviewController {

	ApexPages.StandardController ctr;
    private Contract_Review__c contractReview;

    public NewContractReviewController(ApexPages.StandardController controller)
    {
    	
    	ctr = controller;
    
        // Add the agreement to the form request. If an agreement is added then the trigger 
        // for a new contract review request will gather its details from ECO_ContractReviewDTO 
        Id agreementId = ApexPages.currentPage().getParameters().get('AgreementId');
        if (agreementId != null)
        {
            contractReview = (Contract_Review__c) controller.getRecord();
            contractReview.Agreement__c = agreementId;
        }
    }
    
    public Pagereference Next()
    {
    	try
    	{
	 		if(ctr.save() != null) {
	 			
			    //return new PageReference('/' + ctr.getId() + '/e?retURL=%2F' + ctr.getId() );
                return new PageReference('/apex/ContractReview_Edit?id=' + ctr.getId() + '&retURL=%2F' + ctr.getId() + '&sfdc.override=1'  );
                //PageReference edit =  new PageReference( '/apex/ContractReview_Edit?id=a1se0000001iXSc');
                //return edit;
	 		}
	 		return null;
    	}
    	catch(Exception ex)
    	{
    		return null;	 
    	}
    }

}