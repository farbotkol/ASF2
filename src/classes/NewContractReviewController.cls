public with sharing class NewContractReviewController {

	ApexPages.StandardController ctr;

    public NewContractReviewController(ApexPages.StandardController controller)
    {
    	
    	ctr = controller;
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