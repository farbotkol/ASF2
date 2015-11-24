global with sharing class ECO_PMD_EarnedValueDetail_Controller {
        
  private final pse__Proj__c oProject ;

  public string locale { get {return UserInfo.getLocale().replace('_', '-');} }
  
  public ECO_PMD_ProjectWrapper wrapper { get; set; }
  
  public ECO_PMD_EarnedValueDetail_Controller(ApexPages.StandardController oStandardController) {
    this.oProject = (pse__Proj__c) oStandardController.getRecord();
    this.wrapper = new ECO_PMD_ProjectWrapper(this.oProject);
  }

    @RemoteAction
    global static List<pse__Project_Task__c> EarnedValueTable(String projectNum)
    {
        
        Id projectId = projectNum;
        
        List<pse__Project_Task__c> ordered_evs = new List<pse__Project_Task__c> ();

        List<pse__Project_Task__c> evs = [SELECT Id, ProjectTaskNumber__c, Name, pse__Order__c
          , pse__Hierarchy_Depth__c, IsChargeable__c, IsBillable__c, IsTopLevelTask__c
          , FinancialTask__c , pse__Parent_Task__r.Name, pse__Parent_Task__r.Id 
          , CostBudgetOriginal__c, CostBudgetVariance__c,TotalApprovedCost__c
          , TotalProjectFunctionalBurdenedCost__c , EarnedValue__c ,PercentComplete__c
          , CPI__c ,ScheduleVariance__c ,CostForecastTrend__c ,CostForecastVariance__c
          , PercentSpent__c,   SPI__c , CostForecast__c , Duration__c, TotalEstimateCost__c
          FROM pse__Project_Task__c 
                WHERE pse__Project__c = :projectId
                order by pse__Hierarchy_Depth__c, pse__Order__c,ProjectTaskNumber__c desc];

        ordered_evs = ECO_PMD_Helpers.sortProjecTasks(evs);


        return ordered_evs;
    }
}