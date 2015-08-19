public with sharing class ECO_CashFlowDto {
	public Date periodStartDate {get; set;}

	public Decimal plannedCost {get; set;}
	public Decimal plannedCostCumulative {get; set;}
	public Decimal billing {get; set;}
	public Decimal cashIn {get; set;}
	public Decimal cashInCumulative {get; set;}
	public Decimal netCashPosition {get; set;}
	public Decimal cashFlowCumulative {get; set;}

	public ECO_CashFlowDto() {
		
	}
}