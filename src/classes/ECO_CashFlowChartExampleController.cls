public with sharing class ECO_CashFlowChartExampleController {
	
	public String chartDataJSON {get;set;}
	
	private Id projectId {get;set;}
	
	public ECO_CashFlowChartExampleController () {
		projectId = ApexPages.currentPage().getParameters().get('id');
		
		Decimal amountSoFar = 0;
		
		chartDataJSON = '[';
		chartDataJSON += '["Week", "This Week Cost Amount", "Total Cost Amount"],';
		for (ECO_Service_EarnedValue.EVPoint evPoint : ECO_Service_EarnedValue.getAllEVPointsForProject(projectId)) {
			
			amountSoFar += evPoint.amountThisWeek;
			
			chartDataJSON += '["' + evPoint.weekStartDate.format() + '",  ' + evPoint.amountThisWeek + ', ' + amountSoFar + '],';
		}
		
		chartDataJSON = chartDataJSON.subString(0, chartDataJSON.length()-1);
		
		chartDataJSON += ']';
		
	}

}