global with sharing class ECO_PMD_Commitment_Controller {

  private final pse__Proj__c oProject ;

  public string locale { get {return UserInfo.getLocale().replace('_', '-');} }
  
  public ECO_PMD_ProjectWrapper wrapper { get; set; }
  
  public ECO_PMD_Commitment_Controller (ApexPages.StandardController oStandardController) {
        this.oProject = (pse__Proj__c)oStandardController.getRecord();
    this.wrapper = new ECO_PMD_ProjectWrapper(this.oProject);
  }

        @RemoteAction
    global static List<POcommitment__c> ProjectScheduleTasks(String projectNum)
    {
        Id projectId = projectNum;

        List<POcommitment__c>  commitments;
        
        try
        {
           //note  POLineAmount__c, POAmountBilled__c added just too have some $ values, these are not official 
            commitments = [SELECT PONumber__c, POLine__c, ExpenditureType__c, CurrencyIsoCode
                                                , POCurrency__c, FunctionalCurrency__c, POExchangeRate__c, POHeader__r.VendorName__c
                                                , POHeader__r.VendorSite__r.name, ProjectTaskNumber__r.Name, ProjectTaskNumber__r.ProjectTaskNumber__c
                                                , POLineAmount__c, POAmountBilled__c 
                                                FROM POcommitment__c
                                                WHERE ProjectNumber__c = :projectId];
                
        }
        catch (Exception ex){

            // HMMM
        }

        return commitments;
    }
}