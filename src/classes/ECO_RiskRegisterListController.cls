public class ECO_RiskRegisterListController {
    public pse__Proj__c thisProject {get; set;}
    public ApexPages.StandardController oStandardController {get; set;}
    public ECO_RiskRegisterListController(ApexPages.StandardController oStandardController){
        this.oStandardController = oStandardController; 
        thisProject = (pse__Proj__c)oStandardController.getRecord();
        
    }
    public PageReference returnProj(){
        return new PageReference('/' + thisProject.Id);
    }
    public PageReference newRisk(){
        Id riskId;
        Risk__C oRisk = new Risk__c();
        oRisk.Project__c = thisProject.id;
        oRisk.Name = 'New Risk';
        try{
            Insert oRisk;
        }catch (DmlException e){
            System.debug('Exception: '+e);
        }
        System.debug('oRisk id:  '+oRisk.Id);
        System.debug('oRisk project id:  '+oRisk.Project__c);
        //return new PageReference('/a4f/e?CF00Ne00000016atX='+thisProject.Name+'&CF00Ne00000016atX_lkid='+thisProject.id);
        return new PageReference('/'+oRisk.Id+'/e?retURL=/apex/ECO_RiskRegisterList?id='+thisProject.id);
    }
    public List<Risk__c> getRisks(){
        List <Risk__c> riskList = new List<Risk__c>([Select id, Name, CurrentStatus__c, EventPhase__c, RiskOwner__c, Premitigationrating__c, ContingencyDollars__c, RiskMitigation__c, MitigationCostTotal__c, Postmitigationrating__c, PostmitigationContingencyTotal__c From Risk__c Where Project__c = :thisProject.Id]);
        System.debug('riskList.size:  '+riskList.size());
        System.debug('thisProject.Id:  '+thisProject.Id);
        return riskList;
        
    }
    public PageReference deleteRisk(){
        Id riskId = ApexPages.currentPage().getParameters().get('recid');
        Risk__c riskRecord = [Select id From Risk__c where id = :riskId];
        System.debug('riskRecord id:  '+riskRecord.Id);
        if(riskRecord != null)
            delete riskRecord;
        return null;
    }
    public PageReference exportCSV(){
        String reportId = ReportDetails__c.getInstance('Project Risks').Report_Id__c;
        String projectId = thisProject.id;
        projectId = projectId.substring(0, 15);
        System.debug('reportId:  '+reportId);
        return new PageReference('/'+reportId+'?pv0='+projectId);
    }
}