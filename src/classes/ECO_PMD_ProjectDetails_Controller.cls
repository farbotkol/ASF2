public with sharing class ECO_PMD_ProjectDetails_Controller {
    
    public pse__Proj__c project { get; set; }
 	public Boolean initialized { get; set; }

    public string currentProjectId  {
    	get;
        set {

            currentProjectId = value;
            
            //if (!initialized) {
            	System.debug('lfxxxx' + value);
                initializeProject(currentProjectId);
            //    initialized = true;
            //}
        }
     }
     /**/

    public void initializeProject(string projectId)
    {

    	System.debug('lfxxxxINIT' + projectId);
    	project = [select id, 
					name, 
					OracleProjectnumber__c, 
					clAECOMProjectReviewCategory__c, 
					ContractTypes__c,
					ProjectApprover__r.Name, 
					DefaultTopTaskCustomer__r.Name, 
					PrimaryEndClient__r.Name, 
					BusinessLineOwningOrg__c,
					EndMarketSector__c, 
					pse__Region__r.pse__Region_Name_Chain__c,
					pse__Project_Manager__r.Name,
                    PrimaryBillingClientNameOnly__C
				from pse__Proj__c
				where id = :projectId];

    }

    public ECO_PMD_ProjectDetails_Controller(){}
    //public ECO_PMD_ProjectWrapper wrapper { get;set;}
    


}