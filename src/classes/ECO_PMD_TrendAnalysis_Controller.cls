public with sharing class ECO_PMD_TrendAnalysis_Controller {

	public string locale { get {return UserInfo.getLocale().replace('_', '-');} }
	
	private final pse__Proj__c project;

	public ECO_PMD_TrendAnalysis_Controller(ApexPages.StandardController stdController) {
		//stdController.addFields(new List<string>{'OracleProjectNumber__c', 'Name'});
        this.project = (pse__Proj__c)stdController.getRecord();
	}

	public String getProjectId() {
		return project.Id;
	}

	@RemoteAction @ReadOnly
    public static List<ProjectSnapshot__c> GetSnapshotData(String projectId) {
        return [select
			Id,
			Period_Namee__c,
			SnapshotType__c,
			SnapshotFiscalMonth__c,
		    SnapshotDate__c,
		    GrossRevenueBudgetOriginal__c,
		    CostsODCEXPSBudgetOriginal__c,
		    CostsODCSUBSBudgetOriginal__c,
		    ContingencyBudgetOriginal__c,
		    NetServiceBudgetOriginal__c,
		    LaborBudgetOriginal__c,
		    FringeBudgetOriginal__c,
		    GrossMarginBudgetOriginal__c,
		    OverheadBudgetOriginal__c,
		    NetMarginBudgetOriginal__c,
		    GrossRevenueITD__c,
		    CostsODCEXPSITD__c,
		    CostsODCSUBSITD__c,
		    NetServiceITD__c,
		    LaborITD__c,
		    FringeITD__c,
		    GrossMarginITD__c,
		    OverheadITD__c,
		    NetMarginITD__c,
		    AR0to30__c,
		    AR31to60__c,
		    AR61to90__c,
		    AR0to90__c,
		    AR91to180__c,
		    AR181Plus__c,
		    ARRetention__c,
		    ARTotal__c,
		    ARDaysActual__c,
		    Unbilled0to30__c,
		    Unbilled31to60__c,
		    Unbilled91to180__c,
		    Unbilled181Plus__c,
		    Unbilled0to60__c,
		    Unbilled61to90__c,
		    Unbilled91Plus__c,
		    UnbilledTotal__c,
		    UnbilledDaysActual__c,
		    TotalWorkingCapital__c,
		    DSO__c
		from ProjectSnapshot__c
		where Project__r.Id = :projectId AND SnapshotDate__c = LAST_N_MONTHS:6
		order by SnapshotDate__c desc];
	}
}