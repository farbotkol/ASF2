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
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED, 'AppliedTotalRevenue__c');}
    }

    public Decimal getForecastTotalRevenue {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED + ',' + ECO_DTO_BudgetHeader.STATUS_FORECAST, 'AppliedTotalRevenue__c');}
    }

    public Decimal getWorkAtRiskTotalRevenue {
        get{return calculateTotal(ECO_DTO_BudgetHeader.STATUS_WORKATRISK, 'AppliedTotalRevenue__c');}
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
            Decimal NSR = calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED, 'NetServicesRevenue__c');
            
            if(NSR != 0) {
                Decimal GM = calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED, 'GrossMargin__c');    
                return (100*GM/NSR).setScale(2);
            }
        	return 0.0;
        }
    }

    public Decimal getForecastTotalGMNSR {
        get{
            Decimal NSR = calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED + ',' + ECO_DTO_BudgetHeader.STATUS_FORECAST, 'NetServicesRevenue__c');
            
            if(NSR != 0) {
                Decimal GM = calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED + ',' + ECO_DTO_BudgetHeader.STATUS_FORECAST, 'GrossMargin__c');    
                return (100*GM/NSR).setScale(2);
            }
        	return 0.0;
        }
    }

    public Decimal getWorkAtRiskTotalGMNSR {
        get{
            Decimal NSR = calculateTotal(ECO_DTO_BudgetHeader.STATUS_WORKATRISK, 'NetServicesRevenue__c');
            
            if(NSR != 0) {
                Decimal GM = calculateTotal(ECO_DTO_BudgetHeader.STATUS_WORKATRISK, 'GrossMargin__c');    
                return (100*GM/NSR).setScale(2);
            }            
        	return 0.0;
        }
    }
    
    public Decimal getBudgetTotalNMNSR {
        get{
            Decimal NSR = calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED, 'NetServicesRevenue__c');
            
            if(NSR != 0) {
                Decimal NM = calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED, 'NetMargin__c');    
                return (100*NM/NSR).setScale(2);
            }
        	return 0.0;
        }
    }

    public Decimal getForecastTotalNMNSR {
        get{
            Decimal NSR = calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED + ',' + ECO_DTO_BudgetHeader.STATUS_FORECAST, 'NetServicesRevenue__c');
            
            if(NSR != 0) {
                Decimal NM = calculateTotal(ECO_DTO_BudgetHeader.STATUS_APPROVED + ',' + ECO_DTO_BudgetHeader.STATUS_FORECAST, 'NetMargin__c');    
                return (100*NM/NSR).setScale(2);
            }
        	return 0.0;
        }
    }

    public Decimal getWorkAtRiskTotalNMNSR {
        get{
            Decimal NSR = calculateTotal(ECO_DTO_BudgetHeader.STATUS_WORKATRISK, 'NetServicesRevenue__c');
            
            if(NSR != 0) {
                Decimal NM = calculateTotal(ECO_DTO_BudgetHeader.STATUS_WORKATRISK, 'NetMargin__c');    
                return (100*NM/NSR).setScale(2);
            }

        	return 0.0;
        }
    }
    
    public Decimal getBudgetTotalsalaryCostMultiplier {
        get{
            return calculateTotalDTOproperty(ECO_DTO_BudgetHeader.STATUS_APPROVED, 'salaryCostMultiplier').setScale(1);
        }
    }
    
    public Decimal getForecastTotalsalaryCostMultiplier {
        get{
            return calculateTotalDTOproperty(ECO_DTO_BudgetHeader.STATUS_APPROVED + ',' + ECO_DTO_BudgetHeader.STATUS_FORECAST, 'salaryCostMultiplier').setScale(1);
        }
    }
    
    public Decimal getWorkAtRiskTotalsalaryCostMultiplier {
        get{
            return calculateTotalDTOproperty(ECO_DTO_BudgetHeader.STATUS_WORKATRISK, 'salaryCostMultiplier').setScale(1);
        }
    }
    
    public Decimal getBudgetTotalaverageLabourRatePerHour {
        get{
            return calculateTotalDTOproperty(ECO_DTO_BudgetHeader.STATUS_APPROVED, 'averageLabourRatePerHour').setScale(1);
        }
    }
    
    public Decimal getForecastTotalaverageLabourRatePerHour {
        get{
            return calculateTotalDTOproperty(ECO_DTO_BudgetHeader.STATUS_APPROVED + ',' + ECO_DTO_BudgetHeader.STATUS_FORECAST, 'averageLabourRatePerHour').setScale(1);
        }
    }
    
    public Decimal getWorkAtRiskTotalaverageLabourRatePerHour {
        get{
            return calculateTotalDTOproperty(ECO_DTO_BudgetHeader.STATUS_WORKATRISK, 'averageLabourRatePerHour').setScale(1);
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
    
    public Decimal calculateTotalDTOproperty(String Statuses, String property) {
		Set<String> statusList = new Set<String>(Statuses.split(','));
        
        Decimal totalNum = 0.0;
        Decimal totalDen = 0.0;

        for(ECO_DTO_BudgetHeader budgetHeader : dtoBudgetHeaders) {
            if(statusList.contains(budgetHeader.status)) {
                totalNum = totalNum + budgetHeader.oBudgetHeader.NetServicesRevenue__c;
                if(property == 'salaryCostMultiplier'){
                    totalDen = totalDen + budgetHeader.directPersonnelExpenses;
                }
                else if(property == 'averageLabourRatePerHour') {
                    totalDen = totalDen + budgetHeader.oBudgetHeader.TotalLaborHours__c;
                }                
            }
        }
        
        if (totalDen != 0.0) {
            return totalNum/totalDen;
        }
        return 0.0;        
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
                                                    AppliedTotalRevenue__c, 
                                                    TotalLaborHours__c,
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