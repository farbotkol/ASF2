public with sharing class ECO_PMD_LabourHoursDetail_Controller {

	public string locale { get {return UserInfo.getLocale().replace('_', '-');} }

	public string projectName;

	public string getProjectName() {
		return projectName;
	}

	public void setProjectName(string prjId) {
		pse__Proj__c project = [select Name, OracleProjectNumber__c
								from pse__Proj__c where Id = :prjId];
		projectName = project.OracleProjectNumber__c + ' - ' + project.Name;
	}

	public ECO_PMD_LabourHoursDetail_Controller() {}

	@RemoteAction @ReadOnly
    public static List<CostDistLine__c> GetCostDistLines(String projectId, Id offsetId) // projectNum)
    {
        //projectNum like '60214130'
        //String projectId = 'a32e00000002t8x'; //
        String offsetIdSearch = (offsetId==null)?'0':offsetId;

        return [select id
				//, GLDate__c
                //, GLPeriodName__c
                , PADate__c
                , PAPeriodName__c
                , ExpenditureItem__r.Quantity__c
                , Name
                , ExpenditureItem__r.PersonId__c
                , ExpenditureItem__r.ExpenditureType__c, ExpenditureItem__r.Name
                , ExpenditureItem__r.VendorId__c
                , ExpenditureItem__r.UOM__c
                , ExpenditureItem__r.ProjectTask__r.Name
                , ExpenditureItem__r.ProjectTask__r.ProjectTaskNumber__c
                , ExpenditureItem__r.ProjectTask__r.Id
                from CostDistLine__c
                //where ExpenditureItem__r.ProjectTask__r.ProjectNumber__c = :projectNum];
                where ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id = :projectId and
                Id > :offsetIdSearch ORDER BY Id ASC LIMIT 10000];
    }
}