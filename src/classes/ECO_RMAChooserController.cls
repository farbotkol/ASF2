public with sharing class ECO_RMAChooserController {

	private pse__Proj__c oProject {get; set;}
    private String ProjID {get; set;}
    private String QSId {get; set;}
    private Boolean createNew {get; set;}

    public ECO_RMAChooserController(ApexPages.StandardController stdController)
    {
        this.oProject = (pse__Proj__c)stdController.getRecord();
        this.ProjID = oProject.Id;
        this.createNew = false;
    }

    public PageReference doRedirect() 
    {
        System.debug('ProjID: ' + ProjID);
        if(ProjID != null)
        {
            List<QuestionnaireSet__c> lQS = [Select Id From QuestionnaireSet__c Where Project__c = :ProjID Order By LastModifiedDate DESC Limit 1];
            if(lQS.isEmpty())
            {
                //create new R&M Assessment
                System.debug('ECO_RMAChooserController: create new R&M Assessment');
                QuestionnaireSet__c oQS = new QuestionnaireSet__c();
                oQS.Name = 'Initial Assessment';
                oQS.Project__c = ProjID;
                insert oQS;
                this.QSId = oQS.Id;
                this.createNew = true;
            }
            else
            {
                this.QSId = lQS[0].Id;
            }
        }

        PageReference oPR = Page.ECO_RMASummary;
        System.debug('doRedirect: QSId: ' + QSId);
        if(this.createNew)
        {
            System.debug('ECO_RMAChooserController: go to new R&M Assessment');
            oPR.getParameters().put('begin', 'true');
        }
        else
        {
            System.debug('ECO_RMAChooserController: go to existing R&M Assessment');
        }
        oPR.getParameters().put('Id', QSId);
        oPR.setRedirect(true);
        return oPR;
    }
}