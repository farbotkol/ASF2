trigger INC_EnrollmentPlan_BIU on EnrollmentPlan__c (before insert, before update) {
	system.debug('Enrollment Plan Calculation');
    
    list<Id> lEnrollmentPlansToFetch = new list<Id>();
    
    for(EnrollmentPlan__c oEnrollmentPlan : trigger.new){
        lEnrollmentPlansToFetch.add(oEnrollmentPlan.Id);
    }

    list<EnrollmentPlan__c> lEnrollmentPlans = new list<EnrollmentPlan__c>([SELECT id
                                                                            , IncentiveProject__r.ForecastGrossMarginofNSR__c
                                                                            , ThresholdGM__c
                                                                            , IncentiveProject__r.ForecastNSRBudget__c
                                                                            , IncentivePlan__r.ContractType__c
                                                                            , IncentivePlan__r.ContractSubType__c
                                                                            , IncentiveProject__r.ForecastNMofNSR__c
                                                                            , BaselineGMofNSR__c
                                                                            , ForecastGrossMarginBudget__c
                                                                            , BaselineGrossMargin__c
                                                                            , IncentivePlan__r.ProfitSharingPercent__c
                                                                            , MaxIncentivePool__c
                                                                            , AdjustedComplete__c
                                                                            , AcutalGMofNSRITD__c
                                                                            , IncentiveProject__r.ActualNSRITD__c
                                                                            , IncentiveProject__r.ActualGrossMarginITD__c
                                                                            , NSRBudget__c
                                                                            FROM EnrollmentPlan__c
                                                                            WHERE Id in : lEnrollmentPlansToFetch]);
    
    for(EnrollmentPlan__c oEnrollmentPlan : lEnrollmentPlans){
        system.debug('Enrollment Plan Id : ' + oEnrollmentPlan.Id);
        system.debug('Contract Type : ' + oEnrollmentPlan.IncentivePlan__r.ContractType__c);
        
        decimal dEstimatedIncPoolEAC = 0;
        decimal dMarginToUse = 0;
        
        if(oEnrollmentPlan.IncentivePlan__r.ContractSubType__c == 'Gross Margin'){
            dMarginToUse = oEnrollmentPlan.IncentiveProject__r.ForecastGrossMarginofNSR__c;
        }else{
            dMarginToUse = oEnrollmentPlan.IncentiveProject__r.ForecastNMofNSR__c;
        }
        
        if(oEnrollmentPlan.IncentivePlan__r.ContractType__c == 'Fixed Price'){
            Decimal dThresholdGM = oEnrollmentPlan.ThresholdGM__c == null?0:oEnrollmentPlan.ThresholdGM__c;
            if((dMarginToUse/100) > (dThresholdGM/100)){
                decimal dCalculatedIncentivePool = ((oEnrollmentPlan.IncentiveProject__r.ForecastNSRBudget__c) * ((dMarginToUse/100) - (oEnrollmentPlan.BaselineGMofNSR__c/100)))
            	* 0.5 *(1- oEnrollmentPlan.AdjustedComplete__c/100 );

                if(dCalculatedIncentivePool > oEnrollmentPlan.MaxIncentivePool__c){
                    dEstimatedIncPoolEAC = oEnrollmentPlan.MaxIncentivePool__c;
                }else{
                    dEstimatedIncPoolEAC = dCalculatedIncentivePool;
                }
            }else{
    			dEstimatedIncPoolEAC = 0;
            }
        }else if(oEnrollmentPlan.IncentivePlan__r.ContractType__c == 'Time & Material'){
            //dEstimatedIncPoolEAC = ((dMarginToUse/100) - (oEnrollmentPlan.BaselineGMofNSR__c/100)) * oEnrollmentPlan.MaxIncentivePool__c;
            Decimal dForecastGrossMarginBudget = oEnrollmentPlan.ForecastGrossMarginBudget__c == null?0:oEnrollmentPlan.ForecastGrossMarginBudget__c;
            Decimal dBaselineGrossMargin = oEnrollmentPlan.BaselineGrossMargin__c == null?0:oEnrollmentPlan.BaselineGrossMargin__c;
            Decimal dProfitSharingPercent = oEnrollmentPlan.IncentivePlan__r.ProfitSharingPercent__c == null?0:oEnrollmentPlan.IncentivePlan__r.ProfitSharingPercent__c;
           // dEstimatedIncPoolEAC = (oEnrollmentPlan.ForecastGrossMarginBudget__c - oEnrollmentPlan.BaselineGrossMargin__c) * (oEnrollmentPlan.IncentivePlan__r.ProfitSharingPercent__c/100);
            dEstimatedIncPoolEAC = (dForecastGrossMarginBudget - dBaselineGrossMargin) * (dProfitSharingPercent/100);
            
            if(dEstimatedIncPoolEAC < 0)
                dEstimatedIncPoolEAC = 0;
        }
        
        system.debug(dEstimatedIncPoolEAC);
        
        EnrollmentPlan__c oEnrollmentPlanContext = trigger.newMap.get(oEnrollmentPlan.Id);
            
        oEnrollmentPlanContext.EstimatedIncPoolEAC__c = dEstimatedIncPoolEAC;
    }
    
    for(EnrollmentPlan__c oEnrollmentPlan : lEnrollmentPlans){
        decimal dCalculatedEstimatedIncPoolITD = 0;
        
        if(oEnrollmentPlan.AcutalGMofNSRITD__c > oEnrollmentPlan.ThresholdGM__c){
            decimal dCalculatedEstimatedPool = ((oEnrollmentPlan.IncentiveProject__r.ActualNSRITD__c *((oEnrollmentPlan.IncentiveProject__r.ActualGrossMarginITD__c/oEnrollmentPlan.NSRBudget__c) - oEnrollmentPlan.BaselineGMofNSR__c/100))*0.5 *(1-oEnrollmentPlan.AdjustedComplete__c/100 ));
            if(dCalculatedEstimatedPool > oEnrollmentPlan.MaxIncentivePool__c){
                dCalculatedEstimatedIncPoolITD = oEnrollmentPlan.MaxIncentivePool__c;
            }else{
                dCalculatedEstimatedIncPoolITD = dCalculatedEstimatedPool;
            }
        }
       	else{
            dCalculatedEstimatedIncPoolITD = 0;   
        }
        
        EnrollmentPlan__c oEnrollmentPlanContext = trigger.newMap.get(oEnrollmentPlan.Id);
            
        oEnrollmentPlanContext.EstimatedIncPoolITD__c = dCalculatedEstimatedIncPoolITD;
    }
}

/*

*/