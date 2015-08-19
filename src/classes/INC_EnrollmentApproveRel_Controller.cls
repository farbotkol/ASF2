public with sharing class INC_EnrollmentApproveRel_Controller {

	private final EnrollmentPlan__c oEnrollmentPlan;
    public String EnrollmentID {get;set;}
    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public INC_EnrollmentApproveRel_Controller(ApexPages.StandardController stdController) {
        this.oEnrollmentPlan = (EnrollmentPlan__c)stdController.getRecord();
        EnrollmentID = oEnrollmentPlan.id;
    }

}