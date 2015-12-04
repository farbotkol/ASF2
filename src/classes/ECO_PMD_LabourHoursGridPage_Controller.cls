global with sharing class ECO_PMD_LabourHoursGridPage_Controller {

    private final pse__Proj__c oProject ;
    
    public ECO_PMD_ProjectWrapper wrapper { get; set; }
    
    public ECO_PMD_LabourHoursGridPage_Controller(ApexPages.StandardController oStandardController) {
	 	this.oProject = (pse__Proj__c)oStandardController.getRecord();
        this.wrapper = new ECO_PMD_ProjectWrapper(this.oProject);
        
	}

}