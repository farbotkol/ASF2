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
	 			
			    return new PageReference('/' + ctr.getId() + '/e?retURL=%2F' + ctr.getId() );
	 		}
	 		return null;
    	}
    	catch(Exception ex)
    	{
    		return null;	
    	}
    }

}