public with sharing class ECO_Service_Delegation {

    static map<id, contact> contactMap;

    public ECO_Service_Delegation() {
        
    }

    private class change{
        public SObject oSObject {get;set;}
        public AECOM_Delegation__c oAD {get;set;}
        public string userChange {get;set;}
        public Delegate__c userDelegate {get;set;}
        public pse__Proj__c relProj {get;set;}
        public string limitChangeReason {get;set;}
        public BudgetHeader__c oBudget {get;set;}
        public integer sobjectIndex {get;set;}

        public change(SObject oSObject, AECOM_Delegation__c oAD, Delegate__c userDelegate, pse__Proj__c relProj, integer index){
            this.oSObject = oSObject;
            this.oAD = oAD;
            this.userDelegate = userDelegate;
            this.relProj = relProj;

            this.userChange = (string)this.oSObject.get(oAD.Field_API_Name__c);
            this.limitChangeReason = '';
            this.oBudget = null;
            this.sobjectIndex = index;
        }
    }
    

    public static void insertDelegations(list<SObject> lstTargets){

        system.debug('DEBUG**: lstofDelegationstoInsertL' + ECO_Service_Delegation_Helper.lstofDelegationstoInsert);
        system.debug('DEBUG**: lstofDelegationstoInsertL' + ECO_Service_Delegation_Helper.lstDelegationToRecord);
        system.debug('DEBUG**: test' + ECO_Service_Delegation_Helper.test);

        integer index = 0;

        for(SObject s : lstTargets){
            for(Delegation__c d: ECO_Service_Delegation_Helper.lstofDelegationstoInsert[index]){
                d.Record__c = s.id;
            }

            index++;
        }

        if(ECO_Service_Delegation_Helper.lstDelegationToRecord.size() > 0){
            insert ECO_Service_Delegation_Helper.lstDelegationToRecord;
        }
    }


    private static map<id, pse__Proj__c> getProjectMap(list<SObject> lstTargets){

        map<id, pse__Proj__c> mapProj;



            set<string> sProjectIds = new set<string>();

            for(SObject s : lstTargets){
                sProjectIds.add((string)s.get('delegateProject__c'));
            }

            mapProj = new map<id, pse__Proj__c>([select id, PnLManager__c, FAManager__c, CurrentApprovedRevenueBudget__c, clAECOMProjectReviewCategory__c from pse__Proj__c where id in: sProjectIds]);


        SYSTEM.debug('DEBUG*** mapProj: ' + mapProj );
        return mapProj;

    }

    private static map<id, contact> getContactMap(map<id, pse__Proj__c> mapProj){
        
        set<id> sid = new set<id>();

        for(pse__Proj__c p: mapProj.values()){
            if(p.PnLManager__c != null){
                sid.add(p.PnLManager__c);
            }

            if(p.FAManager__c != null){
                sid.add(p.FAManager__c);
            }            
        }

        map<id, contact> mapContact = new map<id, contact>([select id, pse__Salesforce_User__c from contact where id IN: sid]);

        SYSTEM.debug('DEBUG*** mapContact: ' + mapContact );
        return mapContact;
    }

    private static string getObjectLabel(Sobject oTarget){
        if(oTarget != null){
            Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
            Schema.SObjectType sobjType = gd.get(getObjectName(oTarget)); 
            return sobjType.getDescribe().getLabel();
        } else {
            return null;
        }       
    }

    private static string getObjectName(Sobject oTarget){
        if(oTarget != null){
            system.debug('DEBUG***** :' + oTarget.getSObjectType().getDescribe().getName());
            return oTarget.getSObjectType().getDescribe().getName();
        } else {
            return null;
        }
    }

    private static list<AECOM_Delegation__c> getCustomSettings(Sobject oTarget){
        string objectTypeName = getObjectName(oTarget);

        list<AECOM_Delegation__c> lstAD = [select id,Object_Name__c,Field_API_Name__c, Process__c, Role__c, Escalation__c from AECOM_Delegation__c where Object_Name__c=: objectTypeName ];

        return lstAD;
    }


    private static map<string, Delegate__c> getDelegates(list<SObject> lstTargets, map<id, pse__Proj__c> projectMap){

        set<id> setUsers = new set<id>();
        set<id> delegators = new set<id>();

        list<AECOM_Delegation__c> lstAD = getCustomSettings(lstTargets[0]);
        id rtKM = Schema.Sobjecttype.Delegate__c.getRecordTypeInfosByName().get('Key Roles').getRecordTypeId();

        // Get users
        for(SObject s: lstTargets){
            for(AECOM_Delegation__c ad: lstAD){
                if(s.get(ad.Field_API_Name__c) != null){
                    setUsers.add((id)s.get(ad.Field_API_Name__c));
                    //delegators.add((string)s.get('PnLManager__c'));


                    system.debug('DEBUG*** CHECK DP: ' + (id)s.get('delegateProject__c'));
                    system.debug('DEBUG*** CHECK PNL: ' + projectMap.get((id)s.get('delegateProject__c')).PnLManager__c);
                    system.debug('DEBUG*** CHECK Contact: ' + contactMap.get(projectMap.get((id)s.get('delegateProject__c')).PnLManager__c).pse__Salesforce_User__c);

                    delegators.add(contactMap.get(projectMap.get((id)s.get('delegateProject__c')).PnLManager__c).pse__Salesforce_User__c);
                    
                }
            }
        }  


        system.debug('DEBUG****: DELEGATE SETUSERS: ' + setUsers);
        system.debug('DEBUG****: DELEGATE SETDELEGATORS: ' + delegators);
        system.debug('DEBUG****: RT: ' + rtKM);


        list<Delegate__c> lstDelegates = [select id
                                                , Delegate__c, Delegate__r.pse__Salesforce_User__c
                                                , Delegator__c, Delegator__r.pse__Salesforce_User__c 
                                                , Agreement_Amount_estimated__c
                                                , Project_Revenue_Budget__c
                                                , Project_Net_Margin_Value__c
                                                , Project_Net_Margin_age_of_NSR__c
                                                , age_Change_in_Forecast_Net_Margin__c
                                                , Value_change_in_Forecast_Net_Margin__c
                                                , Agreement_Amount_estimated_Bypass__c
                                                , Project_Revenue_Budget_Bypass__c
                                                , Project_Revenue_Budget_Bypass_lt__c
                                                , Project_Revenue_Budget_lt__c
                                                , Project_Net_Margin_Value_Bypass__c
                                                , Project_Net_Margin_Value_lt__c
                                                , Project_Net_Margin_Value_Bypass_lt__c
                                                , Project_Net_Margin_age_of_NSR_lt__c
                                                , Project_Net_Margin_of_NSR_Bypass_lt__c
                                                , age_Change_in_Forecast_Net_Margin_lt__c
                                                , age_Change_in_Forecast_Net_Margin_Bypass__c
                                                , age_Change_in_Forecast_Net_Margin_Byp_lt__c
                                                , Value_change_in_Forecast_Net_Margin_lt__c
                                                , Value_change_Forecast_Nt_Margn_Byps_lt__c
                                                , Value_change_in_Forecast_Net_Margin_Byps__c
                                                , Project_Review_Category_C_0__c
                                                , Project_Review_Category_C_1__c
                                                , Project_Review_Category_C_2__c
                                                , Project_Review_Category_C_3__c
                                                , Project_Review_Category_C_4__c
                                                , Backlog_Value_Bypass__c
                                                , Backlog_Value__c
                                                , Backlog_Value_lt__c
                                                , Backlog_Value_Bypass_lt__c
                                                ,Project_Review_Category_C_0_Bypass__c
                                                ,Project_Review_Category_C_1_Bypass__c
                                                ,Project_Review_Category_C_2_Bypass__c
                                                ,Project_Review_Category_C_3_Bypass__c
                                                ,Project_Review_Category_C_4_Bypass__c

                                            from Delegate__c 
                                            where Delegate__r.pse__Salesforce_User__c IN: setUsers 
                                                and Delegator__r.pse__Salesforce_User__c IN: delegators 
                                                and RecordTypeid =: rtKM];

        system.debug('DEBUG****: DELEGATE SEARCH: ' + lstDelegates);

        map<string, Delegate__c> mapProjectMapToDelegate = new map<string, Delegate__c>();

        for(Delegate__c d:lstDelegates){
            string skey = (id)d.Delegator__c + (string)d.Delegate__r.pse__Salesforce_User__c;
            mapProjectMapToDelegate.put( skey, d);
        }

        system.debug('DEBUG****: ' + mapProjectMapToDelegate);
        return mapProjectMapToDelegate;
    }

    private static list<change> checkLimits(list<change> lstChanges){

        ECO_Delegate_Limits__c delLimits = ECO_Delegate_Limits__c.getOrgDefaults();
        list<change> lstCheckableChanges = new  list<change>();
        list<change> lstNeedsEscalaction = new list<change>();

        set<id> setProjIds = new set<id>();

        for(change c: lstChanges){
            if(c.userDelegate != null){
                setProjIds.add(c.relProj.id);
                lstCheckableChanges.add(c);
            }
        }


        system.debug('DEBUG**** checkLimits: ' + setProjIds);

        if(setProjIds.size() == 0){
            return new list<change>();
        }

        // Get agreement data
        AggregateResult[] groupedResults = [SELECT Project__c, SUM(Agreement__r.AgreementAmountEstimated__c)amount FROM ProjectAgreement__c WHERE Project__c IN:setProjIds GROUP BY Project__c];
        system.debug('DEBUG**** checkLimits grouped results: ' + groupedResults);

        map<id, decimal> mProjToAgreementAmount = new  map<id, decimal>();

        for (AggregateResult ar : groupedResults)  {
            mProjToAgreementAmount.put((id)ar.get('Project__c'), (decimal)ar.get('amount'));
        }

        // Get budget data
        AggregateResult[] groupedResultsBudget = [SELECT Project__c, SUM(NetMargin__c)NetMargin, SUM(NetServicesRevenue__c)NetServicesRevenue FROM BudgetHeader__c WHERE Project__c IN:setProjIds AND Status__c = 'Approved' GROUP BY Project__c];

        map<id, decimal> mProjToBudgetNM = new  map<id, decimal>();
        map<id, decimal> mProjToBudgetNSR = new  map<id, decimal>();

        for (AggregateResult ar : groupedResultsBudget)  {
            mProjToBudgetNM.put((id)ar.get('Project__c'), (decimal)ar.get('NetMargin'));
            mProjToBudgetNSR.put((id)ar.get('Project__c'), (decimal)ar.get('NetMargin')/(decimal)ar.get('NetServicesRevenue'));
        }

        // Get Backlog Value
        AggregateResult[] groupedResultsITD = [select ProjectNumber__c  , sum(Amount__c) totalRevenue from Revenue__c where ProjectNumber__c in :setProjIds and GLDate__c <= TODAY GROUP BY ProjectNumber__c];

        map<id, decimal> mProjToITD = new  map<id, decimal>();

        for (AggregateResult ar : groupedResultsITD)  {
            mProjToITD.put((id)ar.get('ProjectNumber__c'), (decimal)ar.get('totalRevenue'));
        }



        map<id, decimal> mProjToCMtoForecastBudgetNM = new  map<id, decimal>();
        map<id, decimal> mProjCMtoToForecastBudgetNSR = new  map<id, decimal>();  
        map<id, decimal> mProjToForecastBudgetNM = new  map<id, decimal>();
        map<id, decimal> mProjToForecastBudgetNSR = new  map<id, decimal>();

        boolean isChangeManager = false;

        if(getObjectName(lstChanges[0].oSObject) == 'ChangeManager__c'){
            isChangeManager = true;
        }

        if(isChangeManager){

            set<id> sBudgetIds = new set<id>();

            // get budget data based on change managers
            for(change c: lstChanges){
                if((id)c.oSObject.get('BudgetHeader__c') != null){
                    sBudgetIds.add((id)c.oSObject.get('BudgetHeader__c'));
                }
            }

            list<BudgetHeader__c> lstBudget = [select id, Project__c, NetMargin__c, NetServicesRevenue__c from BudgetHeader__c where id in: sBudgetIds];


            for(BudgetHeader__c b: lstBudget){
                mProjToCMtoForecastBudgetNM.put(b.id, b.NetMargin__c);
                mProjCMtoToForecastBudgetNSR.put(b.id, b.NetServicesRevenue__c);
            }

            // Get forecast budget data
            AggregateResult[] groupedResultsForecastBudget = [SELECT Project__c, SUM(NetMargin__c)NetMargin, SUM(NetServicesRevenue__c)NetServicesRevenue FROM BudgetHeader__c WHERE Project__c IN:setProjIds AND Status__c = 'Forecast' GROUP BY Project__c];


            for (AggregateResult ar : groupedResultsForecastBudget)  {
                mProjToForecastBudgetNM.put((id)ar.get('Project__c'), (decimal)ar.get('NetMargin'));
                mProjToForecastBudgetNSR.put((id)ar.get('Project__c'), (decimal)ar.get('NetMargin')/(decimal)ar.get('NetServicesRevenue'));
            }

        }



        for(change c: lstCheckableChanges){

            boolean needEscalation = false;


            // check Agreement Amount
            if(mProjToAgreementAmount.containskey(c.relProj.id) && mProjToAgreementAmount.get(c.relProj.id) > c.userDelegate.Agreement_Amount_estimated__c && c.userDelegate.Agreement_Amount_estimated_Bypass__c){
                c.limitChangeReason += ' Agreement Amount: ' + mProjToAgreementAmount.get(c.relProj.id) + ' > than limit ' + c.userDelegate.Agreement_Amount_estimated__c;
                needEscalation = true;
            }

            // check Revenue Budget >
            if(c.relProj.CurrentApprovedRevenueBudget__c > c.userDelegate.Project_Revenue_Budget__c & c.userDelegate.Project_Revenue_Budget_Bypass__c ){
                c.limitChangeReason += ' Project Revenue Budget: ' + c.relProj.CurrentApprovedRevenueBudget__c + ' > than limit ' + c.userDelegate.Project_Revenue_Budget__c;
                needEscalation = true;                
            }

            // check Revenue Budget <
            if(c.relProj.CurrentApprovedRevenueBudget__c < c.userDelegate.Project_Revenue_Budget_lt__c & c.userDelegate.Project_Revenue_Budget_Bypass_lt__c ){
                c.limitChangeReason += ' Project Revenue Budget: ' + c.relProj.CurrentApprovedRevenueBudget__c + ' < than limit ' + c.userDelegate.Project_Revenue_Budget_lt__c;
                needEscalation = true;                
            }

            // check net margin limit >
            if(mProjToBudgetNM.containskey(c.relProj.id) && mProjToBudgetNM.get(c.relProj.id) > c.userDelegate.Project_Net_Margin_Value__c && c.userDelegate.Project_Net_Margin_Value_Bypass__c){
                c.limitChangeReason += ' Project Net Margin: ' + mProjToBudgetNM.get(c.relProj.id) + ' > than limit ' + c.userDelegate.Project_Net_Margin_Value__c;
                needEscalation = true;                
            }          

            // check net margin limit <
            if(mProjToBudgetNM.containskey(c.relProj.id) && mProjToBudgetNM.get(c.relProj.id) < c.userDelegate.Project_Net_Margin_Value_lt__c && c.userDelegate.Project_Net_Margin_Value_Bypass_lt__c){
                c.limitChangeReason += ' Project Net Margin: ' + mProjToBudgetNM.get(c.relProj.id) + ' < than limit ' + c.userDelegate.Project_Net_Margin_Value_lt__c;
                needEscalation = true;                
            } 

            // check net margin NSR % >
            if(mProjToBudgetNSR.containskey(c.relProj.id) && mProjToBudgetNSR.get(c.relProj.id) > c.userDelegate.Project_Net_Margin_age_of_NSR__c && c.userDelegate.Project_Net_Margin_age_of_NSR_Bypass__c){
                c.limitChangeReason += ' Project Net Margin: ' + mProjToBudgetNSR.get(c.relProj.id) + ' > than limit ' + c.userDelegate.Project_Net_Margin_age_of_NSR__c;
                needEscalation = true;                
            }         

            // check net margin NSR % <
            if(mProjToBudgetNSR.containskey(c.relProj.id) && mProjToBudgetNSR.get(c.relProj.id) > c.userDelegate.Project_Net_Margin_age_of_NSR_lt__c && c.userDelegate.Project_Net_Margin_of_NSR_Bypass_lt__c){
                c.limitChangeReason += ' Project Net Margin: ' + mProjToBudgetNSR.get(c.relProj.id) + ' > than limit ' + c.userDelegate.Project_Net_Margin_age_of_NSR_lt__c;
                needEscalation = true;                
            }         

            if(isChangeManager){

                if((id)c.oSObject.get('BudgetHeader__c') != null){

                    // check % change in forecast Net Margin
                    decimal changeInForecastNM;

                    if(mProjToForecastBudgetNM.containskey(c.relProj.id) && mProjToCMtoForecastBudgetNM.containskey((id)c.oSObject.get('BudgetHeader__c'))){
                        changeInForecastNM = mProjToCMtoForecastBudgetNM.get((id)c.oSObject.get('BudgetHeader__c'))/mProjToForecastBudgetNM.get(c.relProj.id);
                    } else if(!mProjToForecastBudgetNM.containskey(c.relProj.id)) {
                        changeInForecastNM = 1;
                    } else if(!mProjToCMtoForecastBudgetNM.containskey((id)c.oSObject.get('BudgetHeader__c'))){
                        changeInForecastNM = 0;
                    }

                    // check % change in Forecast Net Margin >
                    if(changeInForecastNM > c.userDelegate.age_Change_in_Forecast_Net_Margin__c && c.userDelegate.age_Change_in_Forecast_Net_Margin_Bypass__c){
                        c.limitChangeReason += ' Project % Change in Forecast Net Margin: ' + changeInForecastNM + ' > than limit ' + c.userDelegate.age_Change_in_Forecast_Net_Margin__c;
                        needEscalation = true;                
                    }                  

                    // check % change in Forecast Net Margin <
                    if(changeInForecastNM < c.userDelegate.age_Change_in_Forecast_Net_Margin_lt__c  && c.userDelegate.age_Change_in_Forecast_Net_Margin_Byp_lt__c){
                        c.limitChangeReason += ' Project % Change in Forecast Net Margin: ' + changeInForecastNM + ' < than limit ' + c.userDelegate.age_Change_in_Forecast_Net_Margin_lt__c;
                        needEscalation = true;                
                    }    

                    // check value change in Forecast Net Margin >=
                    if(mProjToCMtoForecastBudgetNM.containskey((id)c.oSObject.get('BudgetHeader__c')) && mProjToCMtoForecastBudgetNM.get((id)c.oSObject.get('BudgetHeader__c')) > c.userDelegate.Value_change_in_Forecast_Net_Margin__c && c.userDelegate.Value_change_in_Forecast_Net_Margin_Byps__c){
                        c.limitChangeReason += ' Project Value Change in Forecast Net Margin: ' + mProjToCMtoForecastBudgetNM.get((id)c.oSObject.get('BudgetHeader__c')) + ' > than limit ' + c.userDelegate.Value_change_in_Forecast_Net_Margin__c;
                        needEscalation = true;                
                    }    

                    // check value change in Forecast Net Margin <=
                    if(mProjToCMtoForecastBudgetNM.containskey((id)c.oSObject.get('BudgetHeader__c')) && mProjToCMtoForecastBudgetNM.get((id)c.oSObject.get('BudgetHeader__c')) < c.userDelegate.Value_change_in_Forecast_Net_Margin_lt__c && c.userDelegate.Value_change_Forecast_Nt_Margn_Byps_lt__c){
                        c.limitChangeReason += ' Project Value Change in Forecast Net Margin: ' + mProjToCMtoForecastBudgetNM.get((id)c.oSObject.get('BudgetHeader__c')) + ' < than limit ' + c.userDelegate.Value_change_in_Forecast_Net_Margin_lt__c;
                        needEscalation = true;                
                    }     
                }

            }

            // Check Project Review Category
            if(c.relProj.clAECOMProjectReviewCategory__c == 'C-0' && !c.userDelegate.Project_Review_Category_C_0__c && c.userDelegate.Project_Review_Category_C_0_Bypass__c){
                c.limitChangeReason += ' Review Category C-0 is not allowed for delegate ';
                needEscalation = true;   
            } else if (c.relProj.clAECOMProjectReviewCategory__c == 'C-1'  && !c.userDelegate.Project_Review_Category_C_1__c && c.userDelegate.Project_Review_Category_C_1_Bypass__c){
                c.limitChangeReason += ' Review Category C-1 is not allowed for delegate ';
                needEscalation = true;   
            } else if (c.relProj.clAECOMProjectReviewCategory__c == 'C-2'  && !c.userDelegate.Project_Review_Category_C_2__c && c.userDelegate.Project_Review_Category_C_2_Bypass__c){
                c.limitChangeReason += ' Review Category C-2 is not allowed for delegate ';
                needEscalation = true;   
            } else if (c.relProj.clAECOMProjectReviewCategory__c == 'C-3'  && !c.userDelegate.Project_Review_Category_C_3__c && c.userDelegate.Project_Review_Category_C_3_Bypass__c){
                c.limitChangeReason += ' Review Category C-3 is not allowed for delegate ';
                needEscalation = true;   
            } else if (c.relProj.clAECOMProjectReviewCategory__c == 'C-4'  && !c.userDelegate.Project_Review_Category_C_4__c && c.userDelegate.Project_Review_Category_C_4_Bypass__c){
                c.limitChangeReason += ' Review Category C-4 is not allowed for delegate ';
                needEscalation = true;   
            }

            // Check Backlog Value
            if(mProjToAgreementAmount.containskey(c.relProj.id) && mProjToITD.containskey(c.relProj.id)){

                decimal backlog = mProjToAgreementAmount.get(c.relProj.id) - mProjToITD.get(c.relProj.id);

                if(backlog > c.userDelegate.Backlog_Value__c && c.userDelegate.Backlog_Value_Bypass__c){
                    c.limitChangeReason += ' Backlog Amount: ' + backlog + ' > than limit ' + c.userDelegate.Backlog_Value__c;
                    needEscalation = true;
                }

                if(backlog < c.userDelegate.Backlog_Value_lt__c && c.userDelegate.Backlog_Value_Bypass_lt__c){
                    c.limitChangeReason += ' Backlog Amount: ' + backlog + ' < than limit ' + c.userDelegate.Backlog_Value_lt__c;
                    needEscalation = true;
                }

            }


            if(needEscalation){
                lstNeedsEscalaction.add(c);
            }

        }

        





        system.debug('DEBUG**** checkLimits needs escalation: ' + lstNeedsEscalaction);

        return lstNeedsEscalaction;
    }



    private static void evalulateEscalation(list<change> lstChanges, list<Delegation__c> lstDelegationToRecord1, string objectLabel){
         
        list<change> lstChangeViolateLimit = checkLimits(lstChanges);

         if(lstChangeViolateLimit.size() > 0){


            boolean isProj = false;
            if(getObjectName(lstChangeViolateLimit[0].oSObject)== 'pse__Proj__c'){
                isProj = true;
            }


            // replace the changes with the corresponding override
             for(change c: lstChangeViolateLimit){

                if(c.relProj.PnLManager__c != null && c.oAD.Escalation__c == 'PNL'){

                    c.oSObject.put(c.oAD.Field_API_Name__c, contactMap.get(c.relProj.PnLManager__c).pse__Salesforce_User__c );

                    if(isProj){
                        c.oSObject.put('ProjectApprover__c', c.relProj.PnLManager__c);

                    }

                    c.userChange = contactMap.get(c.relProj.PnLManager__c).pse__Salesforce_User__c;




                    Delegation__c oDelegation = new Delegation__c(DelegateUser__c = contactMap.get(c.relProj.PnLManager__c).pse__Salesforce_User__c
                                                                , Record__c = (id)c.oSObject.get('id')
                                                                , Process__c = c.oAD.Process__c
                                                                , Object_Name__c = objectLabel
                                                                , Delegation_Reason__c = 'Limit Escalation: ' + c.limitChangeReason
                                                                , Delegate__c = null
                                                                );

                    lstDelegationToRecord1.add(oDelegation);
                    ECO_Service_Delegation_Helper.lstofDelegationstoInsert[c.sobjectIndex].add(oDelegation);
                } else if (c.relProj.FAManager__c != null && c.oAD.Escalation__c == 'FA'){

                    c.oSObject.put(c.oAD.Field_API_Name__c, contactMap.get(c.relProj.FAManager__c).pse__Salesforce_User__c );
                    c.userChange = contactMap.get(c.relProj.FAManager__c).pse__Salesforce_User__c;

                    if(isProj){
                        c.oSObject.put('ProjectApprover__c', c.relProj.FAManager__c);

                    }


                    Delegation__c oDelegation = new Delegation__c(DelegateUser__c = contactMap.get(c.relProj.FAManager__c).pse__Salesforce_User__c
                                                                , Record__c = (id)c.oSObject.get('id')
                                                                , Process__c = c.oAD.Process__c
                                                                , Object_Name__c = objectLabel
                                                                , Delegation_Reason__c = 'Limit Escalation: ' + c.limitChangeReason
                                                                , Delegate__c = null
                                                                );

                    lstDelegationToRecord1.add(oDelegation);
                    ECO_Service_Delegation_Helper.lstofDelegationstoInsert[c.sobjectIndex].add(oDelegation);                    
                }
             }

         }

    }     

    public static list<Delegation__c> recordDelegation(list<SObject> lstTargets){
        

        //list<AECOM_Delegation__c> lstAD = getCustomSettings(lstTargets[0]);
        //list<Delegation__c> lstDelegationToRecord = new list<Delegation__c>();
        /*string objectLabel = getObjectLabel(lstTargets[0]);
        
        map<id, pse__Proj__c> projectMap = getProjectMap(lstTargets);
        map<string, Delegate__c> delegateMap = getDelegates(lstTargets, projectMap);

        for(SObject s: lstTargets){
            for(AECOM_Delegation__c ad: lstAD){
                if(s.get(ad.Field_API_Name__c) !=null){

                    Delegate__c dDelegate = null;
                    string searchKey = projectMap.get((id)s.get('delegateProject__c')).PnLManager__r.pse__Salesforce_User__c + (string)s.get(ad.Field_API_Name__c);

                    system.debug('DEBUG****: KEY : ' + searchKey);

                    if(delegateMap.containskey(searchKey)){
                        dDelegate = delegateMap.get(searchKey);
                        system.debug('DEBUG****: FOUND : ' + searchKey);
                    }

                    id iDelegate = null;
                    if(dDelegate != null){
                        iDelegate = dDelegate.id;
                    }

                    lstDelegationToRecord.add(new Delegation__c(DelegateUser__c = (id)s.get(ad.Field_API_Name__c)
                                                                , Record__c = (id)s.get('id')
                                                                , Process__c = ad.Process__c
                                                                , Object_Name__c = objectLabel
                                                                , Delegation_Reason__c = 'Record Creation'
                                                                , Delegate__c = iDelegate
                                                                ));
                }
            }
        } 
        insert lstDelegationToRecord;*/
        return new list<Delegation__c>();
        
    }   

    public static list<Delegation__c> delegateReplace(list<change> lstChanges, map<id, Delegate__c> mapDelegates, string sReason){

        string objectLabel = getObjectLabel(lstChanges[0].oSObject);

        list<Delegation__c> lstDelegationToRecord1 = new list<Delegation__c>();

        for(change c: lstChanges){
            if(mapDelegates.containskey(c.userChange)){
                id changeUser = mapDelegates.get(c.userChange).Delegate__r.pse__Salesforce_User__c;
                c.oSObject.put(c.oAD.Field_API_Name__c, changeUser);

                string reason = sReason;

                Delegation__c oDelegation = new Delegation__c(DelegateUser__c = changeUser
                                                            , Record__c = (id)c.oSObject.get('id')
                                                            , Process__c = c.oAD.Process__c
                                                            , Object_Name__c = objectLabel
                                                            , Delegation_Reason__c = reason
                                                            , Delegate__c = mapDelegates.get(c.userChange).id
                                                            );

                lstDelegationToRecord1.add(oDelegation);
                ECO_Service_Delegation_Helper.lstofDelegationstoInsert[c.sobjectIndex].add(oDelegation);
            }
        }

        return lstDelegationToRecord1;
    }   

    public static void evaluateDelegation(list<SObject> lstTargets, map<id, SObject> oldMap){

        system.debug('I GOT HERE!!!!' );

        list<SObject> lstChanged = new list<SObject>();
        list<SObject> lstForVacation = new list<SObject>();
        list<SObject> lstForOverride = new list<SObject>();
        list<change> lstChanges = new list<change>();
        set<id> setUsers = new set<id>();
        map<id,Delegate__c> mapAdminDelegates = new map<id,Delegate__c>();
        map<id,Delegate__c> mapVacaDelegates = new map<id,Delegate__c>();

        id rtVacation = Schema.Sobjecttype.Delegate__c.getRecordTypeInfosByName().get('Vacation').getRecordTypeId();
        id rtOverride = Schema.Sobjecttype.Delegate__c.getRecordTypeInfosByName().get('Administrator Override').getRecordTypeId();

        list<AECOM_Delegation__c> lstAD = getCustomSettings(lstTargets[0]);

        

        string objectLabel = getObjectLabel(lstTargets[0]);

        map<id, pse__Proj__c> projectMap = getProjectMap(lstTargets);
        contactMap =  getContactMap(projectMap);
        map<string, Delegate__c> delegateMap = getDelegates(lstTargets, projectMap);

        integer index = 0;
        
        ECO_Service_Delegation_Helper.lstDelegationToRecord = new list<Delegation__c>();
        ECO_Service_Delegation_Helper.lstofDelegationstoInsert = new list<list<Delegation__c>>();  

        ECO_Service_Delegation_Helper.test = true;      

        // Detect all the changes bassed on the custom settings criteria
        for(SObject s: lstTargets){

            ECO_Service_Delegation_Helper.lstofDelegationstoInsert.add(new list<Delegation__c>());

            for(AECOM_Delegation__c ad: lstAD){
                if(s.get(ad.Field_API_Name__c) != null && (oldMap==null || (s.get(ad.Field_API_Name__c) !=  oldMap.get((id)s.get('id')).get(ad.Field_API_Name__c)))){


                    setUsers.add((id)s.get(ad.Field_API_Name__c));  

                    string reason = 'User Changed';

                    if(oldMap==null){
                        reason = 'Record Created/Submitted';
                    }

                    system.debug('DEBUG****: FORMULA : ' + (id)s.get('delegateProject__c'));

                    string searchKey = projectMap.get((id)s.get('delegateProject__c')).PnLManager__c + (string)s.get(ad.Field_API_Name__c);

                    system.debug('DEBUG****: KEY : ' + searchKey);

                    Delegate__c dDelegate = null;

                    if(delegateMap.containskey(searchKey)){
                        dDelegate = delegateMap.get(searchKey);
                        system.debug('DEBUG****: FOUND : ' + searchKey);
                    }

                    pse__Proj__c proj = null;
                    if(projectMap.containskey((id)s.get('delegateProject__c'))){
                        proj = projectMap.get((id)s.get('delegateProject__c'));
                    }

                    lstChanges.add(new change(s, ad, dDelegate, proj, index));

                    id iDelegate = null;
                    if(dDelegate != null){
                        iDelegate = dDelegate.id;
                    }

                    Delegation__c oDelegation = new Delegation__c(DelegateUser__c = (id)s.get(ad.Field_API_Name__c)
                                                                , Record__c = (id)s.get('id')
                                                                , Process__c = ad.Process__c
                                                                , Object_Name__c = objectLabel
                                                                , Delegation_Reason__c = reason
                                                                , Delegate__c = iDelegate
                                                                );


                    ECO_Service_Delegation_Helper.lstDelegationToRecord.add(oDelegation);
                    system.debug('DEBUG****: TO RECORD : ' + ECO_Service_Delegation_Helper.lstDelegationToRecord);

                    ECO_Service_Delegation_Helper.lstofDelegationstoInsert[index].add(oDelegation);
                }
            }

            index++;
        }   

        // Evaluate escalation

        //if(!(getObjectName(lstTargets[0]) == 'pse__Proj__c' && oldMap==null)){
            evalulateEscalation(lstChanges, ECO_Service_Delegation_Helper.lstDelegationToRecord, objectLabel);
        //}

        for(change c:lstChanges){
            setUsers.add(c.userChange);
        }


        // get all the override and vacation delegates based on the users found
        list<Delegate__c> lstDelegates = [select id, Delegate__c, Delegate__r.pse__Salesforce_User__c, Delegator__r.pse__Salesforce_User__c, RecordTypeId 
                                            from Delegate__c where Delegator__r.pse__Salesforce_User__c IN: setUsers 
                                                                AND (recordtypeid=:rtVacation or recordtypeid=:rtOverride) 
                                                                AND Start_Date__c <=: Date.today()
                                                                AND (End_Date__c >=: Date.today() OR End_Date__c =null)];

        for(Delegate__c d: lstDelegates){
            if(d.recordtypeid == rtVacation){
                mapVacaDelegates.put(d.Delegator__r.pse__Salesforce_User__c , d);
            } else if (d.recordtypeid == rtOverride) {
                mapAdminDelegates.put(d.Delegator__r.pse__Salesforce_User__c , d);
            }
        }
        
        if (lstChanges.size() > 0) {
            ECO_Service_Delegation_Helper.lstDelegationToRecord.addall(delegateReplace(lstChanges, mapVacaDelegates, 'Vacation Delegation'));
            ECO_Service_Delegation_Helper.lstDelegationToRecord.addall(delegateReplace(lstChanges, mapAdminDelegates, 'Administrative Override Delegation'));
        }
        
        //insert lstDelegationToRecord;

    }      

}