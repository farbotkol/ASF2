public without sharing class ECO_CostDistributionLineTriggers {
	
	public static Boolean run = true;
	
	public static void rollUpCosts (List<CostDistLine__c> tOld, List<CostDistLine__c> tNew) {
		if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('CDL_rollup')) {
			return;
		}
		/*
		Set<Id> projectTaskIds = new Set<Id>();
		if (tOld != null) {
			for (CostDistLine__c cdl : tOld) {
				projectTaskIds.add(cdl.TaskNumber__c);
			}
		}
		
		if (tNew != null) {
			for (CostDistLine__c cdl : tNew) {
				projectTaskIds.add(cdl.TaskNumber__c);
			}
		}
												
		List<pse__Project_Task__c> projectTasksToUpdate = new List<pse__Project_Task__c>();
		
		for (AggregateResult ar : [SELECT TaskNumber__c
										, SUM(ProjectFunctionalBurdenedCost__c) totalActualCostAmount
									FROM CostDistLine__c
									WHERE TaskNumber__c IN :projectTaskIds
										AND TaskNumber__c != null
									GROUP BY TaskNumber__c]) {
										
			system.debug('ar:  '+ar);
			
			pse__Project_Task__c ptToUpdate = new pse__Project_Task__c();
			ptToUpdate.Id = (Id)ar.get('TaskNumber__c');
			ptToUpdate.TotalActualCost__c = (Decimal)ar.get('totalActualCostAmount');
			projectTasksToUpdate.add(ptToUpdate);
		}
		
		if (!projectTasksToUpdate.isEmpty()) {
			update projectTasksToUpdate;
		}
		*/
        set<string> costdistlineset = new set<string>();
        map<string,CostDistLine__c> costdistmap = new map<string,CostDistLine__c>();
		map<string, Decimal> mFunctionalRawCost = new map<string, Decimal>();
		map<string, Decimal> mFunctionalBurdenedCost = new map<string, Decimal>();
        set<string> ExpenditureItemset   = new set<string>();
		if(tNew != null){
			for(CostDistLine__c oCDL : tNew){
               
                costdistlineset.add(ocdl.id);
				string sSnapshotKey = ECO_Service_Snapshots.DateToSnapshotKey(oCDL.PADate__c, oCDL.ProjectNumber__c, oCDL.TaskNumber__c);
                ExpenditureItemset.add(oCDL.ExpenditureItem__c);
				Decimal dFunctionalRawCost = ECO_Utils_String.NullCheck(mFunctionalRawCost.get(sSnapshotKey)) + ECO_Utils_String.NullCheck(oCDL.ProjectFunctionalRawCost__c);
				mFunctionalRawCost.put(sSnapshotKey, dFunctionalRawCost);

				Decimal dFunctionalBurdenedCost = ECO_Utils_String.NullCheck(mFunctionalBurdenedCost.get(sSnapshotKey)) + ECO_Utils_String.NullCheck(oCDL.ProjectFunctionalBurdenedCost__c);
				mFunctionalBurdenedCost.put(sSnapshotKey, dFunctionalBurdenedCost);
			}
		}

		if(tOld != null){
			for(CostDistLine__c oCDL : tOld){
              costdistlineset.add(ocdl.id);
              string projectnumber = (id) oCDL.ProjectNumber__c;
                string tasknumber = (id) oCDL.TaskNumber__c;
                string sSnapshotKey = ECO_Service_Snapshots.DateToSnapshotKey(oCDL.PADate__c, ProjectNumber, tasknumber);
                ExpenditureItemset.add(oCDL.ExpenditureItem__c);
				Decimal dFunctionalRawCost = ECO_Utils_String.NullCheck(mFunctionalRawCost.get(sSnapshotKey)) - ECO_Utils_String.NullCheck(oCDL.ProjectFunctionalRawCost__c);
				mFunctionalRawCost.put(sSnapshotKey, dFunctionalRawCost);

				Decimal dFunctionalBurdenedCost = ECO_Utils_String.NullCheck(mFunctionalBurdenedCost.get(sSnapshotKey)) - ECO_Utils_String.NullCheck(oCDL.ProjectFunctionalBurdenedCost__c);
				mFunctionalBurdenedCost.put(sSnapshotKey, dFunctionalBurdenedCost);
			}
		}
        map<string,string> snapshotkeycategorymap = new map<string,string>();
        map<string,decimal> snapshotqtymap = new map<string,decimal>();
         map<string,Decimal> snapshotresourcetypemap = new map<string,decimal>();
         map<string,decimal> costproductcostmap = new map<string,decimal>();
        if(ExpenditureItemset.size()>0)
        {
            for(CostDistLine__c cd: [select id,ExpenditureItem__c,PADate__c,ProjectFunctionalRawCost__c,ProjectRawCost__c,ProjectNumber__c,TaskNumber__c,ExpenditureItem__r.ExpenditureResourceType__c,ExpenditureItem__r.PLReportCategory__c,ExpenditureItem__r.Quantity__c  from CostDistLine__c where ExpenditureItem__c IN :ExpenditureItemset ]){

                string sSnapshotKey = ECO_Service_Snapshots.DateToSnapshotKey(cd.PADate__c, cd.ProjectNumber__c, cd.TaskNumber__c);
                if(costdistlineset.contains(cd.id))
                {
                    if(cd.ExpenditureItem__r.PLReportCategory__c !=null)
                    {
                       
                    costdistmap.put(sSnapshotKey,cd);
                         string strkey = sSnapshotKey+cd.ExpenditureItem__r.PLReportCategory__c;
                        if(costproductcostmap.containskey(strkey ))
                        {
                            Decimal d = 0;
                            if(cd.ProjectFunctionalRawCost__c !=null)                            {
                                
                                d = costproductcostmap.get(strkey ) + cd.ProjectFunctionalRawCost__c;
                                costproductcostmap.put(strkey ,d);
                            }
                        }
                        else
                        {
                            Decimal d = 0;
                            if(cd.ProjectFunctionalRawCost__c !=null)
                            {
                                d = cd.ProjectFunctionalRawCost__c;
                                costproductcostmap.put(strkey,d);
                            }
                        }
                    }
                }
                if(cd.ExpenditureItem__r.PLReportCategory__c !=null)
                {
                    
                    snapshotkeycategorymap.put(sSnapshotKey,cd.ExpenditureItem__r.PLReportCategory__c);
                }
                
                if(cd.ExpenditureItem__r.ExpenditureResourceType__c !=null)
                {
                     string key;
                     if(cd.ExpenditureItem__r.ExpenditureResourceType__c =='LAB')
                        key = sSnapshotKey+cd.ExpenditureItem__r.ExpenditureResourceType__c;
                    else
                       key = sSnapshotKey+'NonLAB'; 
                     if(snapshotresourcetypemap.containskey(key))
                     {
                         if(cd.ProjectFunctionalRawCost__c !=null)
                         {
                             Decimal d = snapshotresourcetypemap.get(key) + cd.ProjectFunctionalRawCost__c;
                             snapshotresourcetypemap.put(key,d);
                         }
                     }
                     else
                     {
                         Decimal d = 0;
                         if(cd.ProjectFunctionalRawCost__c !=null)
                             d = cd.ProjectFunctionalRawCost__c;
                         snapshotresourcetypemap.put(sSnapshotKey,d);
                     }
               
                }
                snapshotqtymap.put(sSnapshotKey ,cd.ExpenditureItem__r.Quantity__c );
            }
        }
		set<string> lSnapshotKeys = new set<string>();
        system.debug('costproductcostmap----------'+costproductcostmap);
       /* for(string s: costproductcostmap.keyset())
        {
            system.debug('key---------'+s);
            system.debug('value---------'+costproductcostmap.get(s));

        }
        */
		for(string s : mFunctionalRawCost.keySet()){
          // system.debug('107------'+s);
			lSnapshotKeys.add(s);
		}

		for(string s : mFunctionalBurdenedCost.keySet()){
       // system.debug('112------'+s);
			lSnapshotKeys.add(s);
		}

		list<EarnedValueSnapshot__c> lEarnedValueSnapshots = new list<EarnedValueSnapshot__c>([SELECT Id
																								    , SnapshotKey__c
																								    , ProjectFunctionalRawCost__c
																								    , ProjectFunctionalBurdenedCost__c 
                                                                                                    ,ProjectFunctionalRawCostPLFringe__c
                                                                                                    ,ProjectFunctionalRawCostPLLabor__c
                                                                                                    ,ProjectFunctionalRawCostPLODCEXPS__c
                                                                                                    ,ProjectFunctionalRawCostPLODCSUBS__c
                                                                                                    ,ProjectFunctionalRawCostPLOverhead__c
                                                                                                    ,ProjectHours__c
                                                                                                    ,ProjectFunctionalRawCostResourceNonLabor__c
                                                                                                    ,ProjectFunctionalRawCostResourceLabor__c
																							  FROM EarnedValueSnapshot__c 
																							  WHERE SnapshotKey__c in :lSnapshotKeys]);

		list<EarnedValueSnapshot__c> lEarnedValueSnapshotsToUpdate = new list<EarnedValueSnapshot__c>();

		for(EarnedValueSnapshot__c oEarnedValueSnapshot : lEarnedValueSnapshots){
			string sSnapshotKey = oEarnedValueSnapshot.SnapshotKey__c;
			boolean bRecordToAdd = false;

			if(mFunctionalRawCost.containsKey(sSnapshotKey)){
				oEarnedValueSnapshot.ProjectFunctionalRawCost__c = ECO_Utils_String.NullCheck(oEarnedValueSnapshot.ProjectFunctionalRawCost__c) + ECO_Utils_String.NullCheck(mFunctionalRawCost.get(sSnapshotKey));

				bRecordToAdd = true;
			}

			if(mFunctionalBurdenedCost.containsKey(sSnapshotKey)){
				oEarnedValueSnapshot.ProjectFunctionalBurdenedCost__c = ECO_Utils_String.NullCheck(oEarnedValueSnapshot.ProjectFunctionalBurdenedCost__c) + ECO_Utils_String.NullCheck(mFunctionalBurdenedCost.get(sSnapshotKey));

				bRecordToAdd = true;
			}
            if(costdistmap.containsKey(sSnapshotKey)){
                 string strkey = sSnapshotKey+costdistmap.get(sSnapshotKey).ExpenditureItem__r.PLReportCategory__c;
                                
                  string odckey = sSnapshotKey+'ODC - Exps';
                    if(costproductcostmap.containskey(odckey))
                        oEarnedValueSnapshot.ProjectFunctionalRawCostPLODCEXPS__C = costproductcostmap.get(odckey);                      
                   string odcsubkey = sSnapshotKey+'ODC - Subs';                   
                    if(costproductcostmap.containskey(odcsubkey))
                       oEarnedValueSnapshot.ProjectFunctionalRawCostPLODCSUBS__c = costproductcostmap.get(odcsubkey);                   
                    string Laborkey = sSnapshotKey+'Labor';                      
                    if(costproductcostmap.containskey(Laborkey))
                        oEarnedValueSnapshot.ProjectFunctionalRawCostPLLabor__c = costproductcostmap.get(Laborkey);                   
                    string Fringekey = sSnapshotKey+'Fringe';                   
                    if(costproductcostmap.containskey(Fringekey))
                        oEarnedValueSnapshot.ProjectFunctionalRawCostPLFringe__c = costproductcostmap.get(Fringekey);
                    string Overheadkey = sSnapshotKey+'Overhead';                   
                    if(costproductcostmap.containskey(Overheadkey ))
                        oEarnedValueSnapshot.ProjectFunctionalRawCostPLOverhead__c = costproductcostmap.get(Overheadkey);
                      
                   bRecordToAdd = true;              
            }
            if(snapshotqtymap.containsKey(sSnapshotKey)){
                oEarnedValueSnapshot.ProjectHours__c = snapshotqtymap.get(sSnapshotKey);
            }
            
                    if(snapshotresourcetypemap.containskey(sSnapshotKey+'LAB'))
                    oEarnedValueSnapshot.ProjectFunctionalRawCostResourceLabor__c = snapshotresourcetypemap.get(sSnapshotKey+'LAB');
                    if(snapshotresourcetypemap.containskey(sSnapshotKey+'NonLAB'))
                      oEarnedValueSnapshot.ProjectFunctionalRawCostResourcenonLabor__c = snapshotresourcetypemap.get(sSnapshotKey+'NonLAB');
           
			if(bRecordToAdd)
				lEarnedValueSnapshotsToUpdate.add(oEarnedValueSnapshot);
		}

		if (!lEarnedValueSnapshotsToUpdate.isEmpty()) {
           system.debug('lEarnedValueSnapshotsToUpdate----'+lEarnedValueSnapshotsToUpdate[0].id);
			update lEarnedValueSnapshotsToUpdate;
		}
	}
	
    public static void calculateFiscalMonths(list<CostDistLine__c> costDistLines) {
        if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('CDL_calcFiscalMonths')) {
            return;
        }
        
        list<date> enddatelist = new list<date>();
        Set<Date> datesToConvert = new Set<Date>();
        Map<Date, String> mapTimePeriodCodeByDate = new Map<Date, String> ();

        for (CostDistLine__c ba : costDistLines) {
            datesToConvert.add(ba.GLDate__c);
            datesToConvert.add(ba.PADate__c);

            if (ba.GLDate__c != null) {
                enddatelist.add((ba.GLDate__c).addmonths(2));
                enddatelist.add((ba.GLDate__c).addmonths(-3));
            }
        }
        datesToConvert.remove(null);

        system.debug('enddatelist----' + enddatelist);
        List<pse__Time_Period__c> timePeriods  = new  List<pse__Time_Period__c>();
        if (enddatelist.size() > 0) {
            // Time period
            timePeriods = ECO_Utils_Date.calcTimePeriods(enddatelist, 'Month');

            /* Calculate all the timeperiod codes at once and cache the results*/
            pse__Time_Period__c fm = null;
            for (Date dt : datesToConvert) {
                fm = ECO_Utils_Date.getFiscalPeriod(dt, 0, timePeriods);
                if (fm != null) {
                    mapTimePeriodCodeByDate.put(dt, fm.TimePeriodCode__c);
                }
            }

            for (CostDistLine__c cdl : costDistLines) {
                for (Integer i = 0; i < timePeriods.size(); i++) {
                    if (cdl.GLDate__c != null) {
                        cdl.GLFiscalMonth__c = mapTimePeriodCodeByDate.get(cdl.GLDate__c);
                    }

                    if (cdl.PADate__c != null) {
                        cdl.PAFiscalMonth__c = mapTimePeriodCodeByDate.get(cdl.PADate__c);
                    }
                }
            }
        }
    }
}