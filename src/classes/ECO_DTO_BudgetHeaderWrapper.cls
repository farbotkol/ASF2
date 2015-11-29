public class ECO_DTO_BudgetHeaderWrapper {
	public List<ECO_DTO_BudgetHeader> dtoBudgetHeaders{get; set;}
    
    public Decimal getBudgetTotalRawLabour {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED, 'TotalRawCost__c');}
    }
    
    public Decimal getForecastTotalRawLabour {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED + ',' + ECO_DTO_BudgetHeader.STATUS_FORECAST, 'TotalRawCost__c');}
    }
    
    public Decimal getWorkAtRiskTotalRawLabour {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_WORKATRISK, 'TotalRawCost__c');}
    }
    
    public Decimal getBudgetTotalFringe {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED, 'TotalFringe__c');}
    }

    public Decimal getForecastTotalFringe {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED + ',' + ECO_DTO_BudgetHeader.STATUS_FORECAST, 'TotalFringe__c');}
    }

    public Decimal getWorkAtRiskTotalFringe {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_WORKATRISK, 'TotalFringe__c');}
    } 
    
    public Decimal getBudgetTotalOverhead {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED, 'TotalOverhead__c');}
    }

    public Decimal getForecastTotalOverhead {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED + ',' + ECO_DTO_BudgetHeader.STATUS_FORECAST, 'TotalOverhead__c');}
    }

    public Decimal getWorkAtRiskTotalOverhead {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_WORKATRISK, 'TotalOverhead__c');}
    }
    
    public Decimal getBudgetTotalSubAmount {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED, 'TotalSubAmount__c');}
    }

    public Decimal getForecastTotalSubAmount {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED + ',' + ECO_DTO_BudgetHeader.STATUS_FORECAST, 'TotalSubAmount__c');}
    }

    public Decimal getWorkAtRiskTotalSubAmount {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_WORKATRISK, 'TotalSubAmount__c');}
    }
    
    public Decimal getBudgetTotalFeeAmount {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED, 'TotalFeeAmount__c');}
    }

    public Decimal getForecastTotalFeeAmount {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED + ',' + ECO_DTO_BudgetHeader.STATUS_FORECAST, 'TotalFeeAmount__c');}
    }

    public Decimal getWorkAtRiskTotalFeeAmount {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_WORKATRISK, 'TotalFeeAmount__c');}
    }
    
    public Decimal getBudgetTotalContingencyAmount {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED, 'TotalContingencyAmount__c');}
    }

    public Decimal getForecastTotalContingencyAmount {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED + ',' + ECO_DTO_BudgetHeader.STATUS_FORECAST, 'TotalContingencyAmount__c');}
    }

    public Decimal getWorkAtRiskTotalContingencyAmount {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_WORKATRISK, 'TotalContingencyAmount__c');}
    }

    public Decimal getBudgetTotalCost {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED, 'TotalCost__c');}
    }

    public Decimal getForecastTotalCost {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED + ',' + ECO_DTO_BudgetHeader.STATUS_FORECAST, 'TotalCost__c');}
    }

    public Decimal getWorkAtRiskTotalCost {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_WORKATRISK, 'TotalCost__c');}
    }
    
    public Decimal getBudgetTotalRevenue {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED, 'TotalRevenue__c');}
    }

    public Decimal getForecastTotalRevenue {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED + ',' + ECO_DTO_BudgetHeader.STATUS_FORECAST, 'TotalRevenue__c');}
    }

    public Decimal getWorkAtRiskTotalRevenue {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_WORKATRISK, 'TotalRevenue__c');}
    }
    
    public Decimal getBudgetTotalNetServiceRevenue {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED, 'NetServicesRevenue__c');}
    }

    public Decimal getForecastTotalNetServiceRevenue {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED + ',' + ECO_DTO_BudgetHeader.STATUS_FORECAST, 'NetServicesRevenue__c');}
    }

    public Decimal getWorkAtRiskTotalNetServiceRevenue {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_WORKATRISK, 'NetServicesRevenue__c');}
    }
    
    public Decimal getBudgetTotalGrossMargin {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED, 'GrossMargin__c');}
    }

    public Decimal getForecastTotalGrossMargin {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED + ',' + ECO_DTO_BudgetHeader.STATUS_FORECAST, 'GrossMargin__c');}
    }

    public Decimal getWorkAtRiskTotalGrossMargin {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_WORKATRISK, 'GrossMargin__c');}
    }
    
    public Decimal getBudgetTotalNetMargin {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED, 'NetMargin__c');}
    }

    public Decimal getForecastTotalNetMargin {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED + ',' + ECO_DTO_BudgetHeader.STATUS_FORECAST, 'NetMargin__c');}
    }

    public Decimal getWorkAtRiskTotalNetMargin {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_WORKATRISK, 'NetMargin__c');}
    }
    
    public Decimal getBudgetTotalGMNSR {
        get{
            Integer recCount = calculateRecordsWithStatus(ECO_DTO_BudgetHeader.STATUS_APPROVED);
            if(recCount > 0)
                return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED, 'GMNSR__c')/recCount;
        	return 0.0;
        }
    }

    public Decimal getForecastTotalGMNSR {
        get{
            Integer recCount = calculateRecordsWithStatus(ECO_DTO_BudgetHeader.STATUS_APPROVED + ',' + ECO_DTO_BudgetHeader.STATUS_FORECAST);
            if(recCount > 0)
                return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED + ',' + ECO_DTO_BudgetHeader.STATUS_FORECAST, 'GMNSR__c')/recCount;
        	return 0.0;
        }
    }

    public Decimal getWorkAtRiskTotalGMNSR {
        get{
            Integer recCount = calculateRecordsWithStatus(ECO_DTO_BudgetHeader.STATUS_WORKATRISK);
            if(recCount > 0)
            	return calculateTotal(ECO_DTO_BudgetHeader.STATUS_WORKATRISK, 'GMNSR__c')/recCount;
        	return 0.0;
        }
    }
    
    public Decimal getBudgetTotalNMNSR {
        get{
            Integer recCount = calculateRecordsWithStatus(ECO_DTO_BudgetHeader.STATUS_APPROVED);
            if(recCount > 0)
                return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED, 'NMNSR__c')/recCount;
        	return 0.0;
        }
    }

    public Decimal getForecastTotalNMNSR {
        get{
            Integer recCount = calculateRecordsWithStatus(ECO_DTO_BudgetHeader.STATUS_APPROVED + ',' + ECO_DTO_BudgetHeader.STATUS_FORECAST);
            if(recCount > 0)
                return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED + ',' + ECO_DTO_BudgetHeader.STATUS_FORECAST, 'NMNSR__c')/recCount;
        	return 0.0;
        }
    }

    public Decimal getWorkAtRiskTotalNMNSR {
        get{
            Integer recCount = calculateRecordsWithStatus(ECO_DTO_BudgetHeader.STATUS_WORKATRISK);
            if(recCount > 0)
            	return calculateTotal(ECO_DTO_BudgetHeader.STATUS_WORKATRISK, 'NMNSR__c')/recCount;
        	return 0.0;
        }
    }
    
    public Decimal calculateTotal(String Statuses, String field) {
        Set<String> statusList = new Set<String>(Statuses.split(','));
        
        Decimal total = 0.0;
        for(ECO_DTO_BudgetHeader budgetHeader : dtoBudgetHeaders) {
            if(statusList.contains(budgetHeader.status)) {
                total = total + (Decimal)budgetHeader.oBudgetHeader.get(field);
            }
        }
        
        return total;
    }
    
    public Integer calculateRecordsWithStatus(String Statuses) {
        Set<String> statusList = new Set<String>(Statuses.split(','));
        Integer total = 0;
        for(ECO_DTO_BudgetHeader budgetHeader : dtoBudgetHeaders) {
            if(statusList.contains(budgetHeader.status)) {
                total = total + 1;
            }
        }
        
        return total;
    }
    
    public ECO_DTO_BudgetHeaderWrapper(Id projectId) {
        dtoBudgetHeaders = new List<ECO_DTO_BudgetHeader>();
        
        List<BudgetHeader__c> budgetHeaders = [SELECT 
                                               		Id, 
                                               		BudgetName__c, 
                                               		TotalCost__c, 
                                               		TotalRevenue__c, 
                                               		TotalFeeAmount__c, 
                                               		TotalLaborAmount__c, 
                                               		TotalSubAmount__c, 
                                               		TotalContingencyAmount__c, 
                                               		TotalResourceAmount__c,
                                               		TotalRawCost__c,
                                               		TotalFringe__c,
                                               		TotalOverhead__c,
                                               	    NetServicesRevenue__c,
                                               	    GrossMargin__c,
                                               		NetMargin__c,
                                               		GMNSR__c,
                                               		NMNSR__c,
                                               		Status__c, 
                                               		CreatedDate,
                                               		(SELECT Id, RecordType.Name FROM Change_Manager__r)
												FROM 
                                               		BudgetHeader__c
												WHERE 
                                               		Project__c = :projectId
												ORDER BY 
                                               		CreatedDate ASC];
        for(BudgetHeader__c budgetHeader : budgetHeaders) {
            ECO_DTO_BudgetHeader dtoBudgetHeader = new ECO_DTO_BudgetHeader(budgetHeader);
            dtoBudgetHeaders.add(dtoBudgetHeader);
        }
    }
    
    public ECO_DTO_BudgetHeader findBudgetHeaderDTOById(Id budgetHeaderId) {
        
        for(ECO_DTO_BudgetHeader dtoBudgetHeader : dtoBudgetHeaders) {
            if(dtoBudgetHeader.oBudgetHeader.Id == budgetHeaderId) {
        		return dtoBudgetHeader;        
            }
        }
        
        return null;
    }
}