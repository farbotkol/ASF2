trigger INC_EnrollmentPlan_BIU on EnrollmentPlan__c (before insert, before update) {
	system.debug('Enrollment Plan Calculation');
    
    list<Id> lEnrollmentPlansToFetch = new list<Id>();
    
    for(EnrollmentPlan__c oEnrollmentPlan : trigger.new){
        lEnrollmentPlansToFetch.add(oEnrollmentPlan.Id);
    }

    list<EnrollmentPlan__c> lEnrollmentPlans = new list<EnrollmentPlan__c>([SELECT id
                                                                            , IncentiveProject__r.ForecastGrossMarginofNSR__c
                                                                            , ThresholdGM__c
                                                                            , ActualMarginITD__c
                                                                            , IncentiveProject__r.ForecastNSRBudget__c
                                                                            , IncentivePlan__r.ContractType__c
                                                                            , IncentivePlan__r.ContractSubType__c
                                                                            , IncentiveProject__r.ForecastNMofNSR__c
                                                                            , BaselineGMofNSR__c
                                                                            , ForecastGrossMarginBudget__c
                                                                            , BaselineGrossMargin__c
                                                                            , IncentivePlan__r.ProfitSharingPercent__c
                                                                            , MaxIncentivePool__c
                                                                            , MaximumIncentivePoolITD__c
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
            dMarginToUse = ECO_Utils_String.NullCheck(oEnrollmentPlan.IncentiveProject__r.ForecastGrossMarginofNSR__c);
        }else{
            dMarginToUse = ECO_Utils_String.NullCheck(oEnrollmentPlan.IncentiveProject__r.ForecastNMofNSR__c);
        }
        
        if(oEnrollmentPlan.IncentivePlan__r.ContractType__c == 'Fixed Price'){
            Decimal dThresholdGM = ECO_Utils_String.NullCheck(oEnrollmentPlan.ThresholdGM__c);
            if((dMarginToUse/100) > (dThresholdGM/100)){
                decimal dCalculatedIncentivePool = ((ECO_Utils_String.NullCheck(oEnrollmentPlan.IncentiveProject__r.ForecastNSRBudget__c)) * ((dMarginToUse/100) - (ECO_Utils_String.NullCheck(oEnrollmentPlan.BaselineGMofNSR__c)/100))
            	* 0.5 *(1- ECO_Utils_String.NullCheck(oEnrollmentPlan.AdjustedComplete__c)/100 ));

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
            Decimal dForecastGrossMarginBudget = ECO_Utils_String.NullCheck(oEnrollmentPlan.ForecastGrossMarginBudget__c);
            Decimal dBaselineGrossMargin = ECO_Utils_String.NullCheck(oEnrollmentPlan.BaselineGrossMargin__c);
            Decimal dProfitSharingPercent = ECO_Utils_String.NullCheck(oEnrollmentPlan.IncentivePlan__r.ProfitSharingPercent__c);
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
        if(oEnrollmentPlan.IncentivePlan__r.ContractType__c =='Fixed Price'){
            if(oEnrollmentPlan.AcutalGMofNSRITD__c > oEnrollmentPlan.ThresholdGM__c){
                decimal dCalculatedEstimatedPool = ((ECO_Utils_String.NullCheck(oEnrollmentPlan.IncentiveProject__r.ActualNSRITD__c) *((ECO_Utils_String.NullCheck(oEnrollmentPlan.IncentiveProject__r.ActualGrossMarginITD__c)/ECO_Utils_String.NullCheck(oEnrollmentPlan.NSRBudget__c)) - ECO_Utils_String.NullCheck(oEnrollmentPlan.BaselineGMofNSR__c)/100))*0.5 *(1-ECO_Utils_String.NullCheck(oEnrollmentPlan.AdjustedComplete__c)/100));
                if(dCalculatedEstimatedPool > oEnrollmentPlan.MaximumIncentivePoolITD__c){
                    dCalculatedEstimatedIncPoolITD = ECO_Utils_String.NullCheck(oEnrollmentPlan.MaximumIncentivePoolITD__c);
                }else{
                    dCalculatedEstimatedIncPoolITD = dCalculatedEstimatedPool;
                }
            }
           	else{
                dCalculatedEstimatedIncPoolITD = 0;   
            }
        }

        if(oEnrollmentPlan.IncentivePlan__r.ContractType__c == 'Time & Material'){
            /*
            MAX(((ActualMarginITD__c - BaselineGrossMargin__c) * IncentivePlan__r.ProfitSharingPercent__c) ,0)
            */
            Decimal dActualMaginITD = ECO_Utils_String.NullCheck(oEnrollmentPlan.ActualMarginITD__c);
            Decimal dBaselineGrossMargin = ECO_Utils_String.NullCheck(oEnrollmentPlan.BaselineGrossMargin__c);
            Decimal dProfitSharingPercent = ECO_Utils_String.NullCheck(oEnrollmentPlan.IncentivePlan__r.ProfitSharingPercent__c);

            dCalculatedEstimatedIncPoolITD = (dActualMaginITD - dBaselineGrossMargin) * dProfitSharingPercent;

            if(dCalculatedEstimatedIncPoolITD > oEnrollmentPlan.MaximumIncentivePoolITD__c){
                dCalculatedEstimatedIncPoolITD = oEnrollmentPlan.MaximumIncentivePoolITD__c;
            }else{
                if(dCalculatedEstimatedIncPoolITD < 0){
                    dCalculatedEstimatedIncPoolITD = 0;
                }
            }
        }
        
        EnrollmentPlan__c oEnrollmentPlanContext = trigger.newMap.get(oEnrollmentPlan.Id);
            
        oEnrollmentPlanContext.EstimatedIncPoolITD__c = dCalculatedEstimatedIncPoolITD;
    }
}

/*

*/