public without sharing class ECO_CostDistributionLineTriggers {
    
    public static Boolean run = true;
    
    public static void rollUpCosts (List<CostDistLine__c> tOld, List<CostDistLine__c> tNew) {
        if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('CDL_rollup')) {
            return;
        }
        
        set<string> costdistlineset = new set<string>();
        map<string,CostDistLine__c> costdistmap = new map<string,CostDistLine__c>();
         map<string,CostDistLine__c> oldcostdistmap = new map<string,CostDistLine__c>();
        map<string, Decimal> mFunctionalRawCost = new map<string, Decimal>();
        map<string, Decimal> mFunctionalBurdenedCost = new map<string, Decimal>();
        set<string> ExpenditureItemset   = new set<string>();
        // map<string,string> snapshotkeycategorymap = new map<string,string>();
        map<string,decimal> snapshotqtymap = new map<string,decimal>();
         map<string,Decimal> snapshotresourcetypemap = new map<string,decimal>();
         map<string,Decimal> oldsnapshotresourcetypemap = new map<string,decimal>();
         map<string,decimal> costproductcostmap = new map<string,decimal>();
         map<string,decimal> oldcostproductcostmap = new map<string,decimal>();
         map<string,boolean> RecalculateEVSMetricsmap = new map<string,boolean>();

         
        if(tNew != null){
            for(CostDistLine__c oCDL : tNew){
               
                costdistlineset.add(ocdl.id);
                                  
                string projectnumber = (id) oCDL.ProjectNumber__c;
                string tasknumber = (id) oCDL.TaskNumber__c;
                
                string sSnapshotKey = ECO_Service_Snapshots.DateToSnapshotKey(oCDL.PADate__c,ProjectNumber, tasknumber );
                
                ExpenditureItemset.add(oCDL.ExpenditureItem__c);
                Decimal dFunctionalRawCost = ECO_Utils_String.NullCheck(mFunctionalRawCost.get(sSnapshotKey)) + ECO_Utils_String.NullCheck(oCDL.ProjectFunctionalRawCost__c);
                mFunctionalRawCost.put(sSnapshotKey, dFunctionalRawCost);

                Decimal dFunctionalBurdenedCost = ECO_Utils_String.NullCheck(mFunctionalBurdenedCost.get(sSnapshotKey)) + ECO_Utils_String.NullCheck(oCDL.ProjectFunctionalBurdenedCost__c);
                mFunctionalBurdenedCost.put(sSnapshotKey, dFunctionalBurdenedCost);
                 
                 //newly added
                 system.debug('oCDL.ExpenditureItem__r.PLReportCategory__c--------'+oCDL.PLReportCategory__c);
                   if(oCDL.PLReportCategory__c !=null)
                    {
                       string sSnapshotKey1 = ECO_Service_Snapshots.DateToSnapshotKey(oCDL.PADate__c, oCDL.ProjectNumber__c, oCDL.TaskNumber__c);
                      
                        costdistmap.put(sSnapshotKey1 ,oCDL);
                         string strkey = sSnapshotKey1+oCDL.PLReportCategory__c;
                          RecalculateEVSMetricsmap.put(strkey,ocdl.RecalculateEVSMetrics__c);
                       system.debug('oCDL.ProjectFunctionalRawCost__c-------'+oCDL.ProjectFunctionalRawCost__c);
                        if(costproductcostmap.containskey(strkey ))
                        {
                            Decimal d = 0;
                            if(oCDL.ProjectFunctionalRawCost__c !=null)                            {
                                
                                d = costproductcostmap.get(strkey ) + oCDL.ProjectFunctionalRawCost__c;
                                costproductcostmap.put(strkey ,d);
                            }
                        }
                        else
                        {
                            Decimal d = 0;
                            if(oCDL.ProjectFunctionalRawCost__c !=null)
                            {
                                d = oCDL.ProjectFunctionalRawCost__c;
                                costproductcostmap.put(strkey,d);
                            }
                        }
                    }
               
                 
                   if(oCDL.CostReportCategory__c !=null)
                {
                     string key;
                     if(oCDL.CostReportCategory__c =='LABOR')
                        key = sSnapshotKey+'LAB';
                     else
                       key = sSnapshotKey+'NonLAB';
                       
                     if(snapshotresourcetypemap.containskey(key))
                     {
                         if(oCDL.ProjectFunctionalRawCost__c !=null)
                         {
                             Decimal d = snapshotresourcetypemap.get(key) + oCDL.ProjectFunctionalRawCost__c;
                             System.Debug(System.LoggingLevel.WARN, '___oCDL.ProjectFunctionalRawCost__c='+oCDL.ProjectFunctionalRawCost__c);
                             System.Debug(System.LoggingLevel.WARN, '___key='+key);
                             snapshotresourcetypemap.put(key,d);
                         }
                     }
                     else
                     {
                         Decimal d = 0;
                         if(oCDL.ProjectFunctionalRawCost__c !=null)
                             d = oCDL.ProjectFunctionalRawCost__c;
                         System.Debug(System.LoggingLevel.WARN, '___oCDL.ProjectFunctionalRawCost__c='+oCDL.ProjectFunctionalRawCost__c);
                         System.Debug(System.LoggingLevel.WARN, '___sSnapshotKey='+sSnapshotKey);
                         snapshotresourcetypemap.put(sSnapshotKey,d);
                     }
                     
                }
                 //
            }
        }
    system.debug('67------------'+costproductcostmap);
        if(tOld != null){
            for(CostDistLine__c oCDL : tOld){
              costdistlineset.add(ocdl.id);
              string projectnumber = (id) oCDL.ProjectNumber__c;
                string tasknumber = (id) oCDL.TaskNumber__c;
                string sSnapshotKey = ECO_Service_Snapshots.DateToSnapshotKey(oCDL.PADate__c, ProjectNumber, tasknumber);
                ExpenditureItemset.add(oCDL.ExpenditureItem__c);
                Decimal dFunctionalRawCost = 
                	ECO_Utils_String.NullCheck(mFunctionalRawCost.get(sSnapshotKey)) - ECO_Utils_String.NullCheck(oCDL.ProjectFunctionalRawCost__c);
                mFunctionalRawCost.put(sSnapshotKey, dFunctionalRawCost);

                Decimal dFunctionalBurdenedCost = 
                	ECO_Utils_String.NullCheck(mFunctionalBurdenedCost.get(sSnapshotKey)) - ECO_Utils_String.NullCheck(oCDL.ProjectFunctionalBurdenedCost__c);
                mFunctionalBurdenedCost.put(sSnapshotKey, dFunctionalBurdenedCost);
                 //newly added
                  if(costdistlineset.contains(oCDL.id))
                {
                    if(oCDL.PLReportCategory__c !=null)
                    {
                       string sSnapshotKey1 = ECO_Service_Snapshots.DateToSnapshotKey(oCDL.PADate__c, oCDL.ProjectNumber__c, oCDL.TaskNumber__c);                       
                        oldcostdistmap.put(sSnapshotKey1 ,oCDL);
                         string strkey = sSnapshotKey+oCDL.PLReportCategory__c;
                        if(!RecalculateEVSMetricsmap.containskey(strkey))
                            RecalculateEVSMetricsmap.put(strkey,ocdl.RecalculateEVSMetrics__c);
                        if(oldcostproductcostmap.containskey(strkey ))
                        {
                            Decimal d = 0;
                            if(oCDL.ProjectFunctionalRawCost__c !=null)                            {
                                
                                d = oldcostproductcostmap.get(strkey ) + oCDL.ProjectFunctionalRawCost__c;
                                oldcostproductcostmap.put(strkey ,d);
                            }
                        }
                        else
                        {
                            Decimal d = 0;
                            if(oCDL.ProjectFunctionalRawCost__c !=null)
                            {
                                d = oCDL.ProjectFunctionalRawCost__c;
                                oldcostproductcostmap.put(strkey,d);
                            }
                        }
                    }
                }
                 
                   if(oCDL.CostReportCategory__c !=null)
                {
                     string key;
                     if(oCDL.CostReportCategory__c =='LABOR')
                        key = sSnapshotKey+'LAB';
                     else
                       key = sSnapshotKey+'NonLAB'; 
                       
                     if(snapshotresourcetypemap.containskey(key))
                     {
                         if(oCDL.ProjectFunctionalRawCost__c !=null)
                         {
                             Decimal d = snapshotresourcetypemap.get(key) + oCDL.ProjectFunctionalRawCost__c;
                             System.Debug(System.LoggingLevel.WARN, '___oCDL.ProjectFunctionalRawCost__c='+oCDL.ProjectFunctionalRawCost__c);
                             System.Debug(System.LoggingLevel.WARN, '___key='+key);
                             oldsnapshotresourcetypemap.put(key,d);
                         }
                     }
                     else
                     {
                         Decimal d = 0;
                         System.Debug(System.LoggingLevel.WARN, '___oCDL.ProjectFunctionalRawCost__c='+oCDL.ProjectFunctionalRawCost__c);
                         if(oCDL.ProjectFunctionalRawCost__c !=null)
                             d = oCDL.ProjectFunctionalRawCost__c;
                         System.Debug(System.LoggingLevel.WARN, '___sSnapshotKey='+sSnapshotKey);
                         oldsnapshotresourcetypemap.put(sSnapshotKey,d);
                     }
                     
                }
                 //
            }
        }
       
        if(ExpenditureItemset.size()>0)
        {
            for(CostDistLine__c cd: [select id,ExpenditureItem__c,PADate__c,ProjectFunctionalRawCost__c,ProjectRawCost__c,ProjectNumber__c,TaskNumber__c,
            	CostReportCategory__c, ExpenditureItem__r.PLReportCategory__c, ExpenditureItem__r.Quantity__c  
            	from CostDistLine__c where ExpenditureItem__c IN :ExpenditureItemset ]){
                
                string sSnapshotKey = ECO_Service_Snapshots.DateToSnapshotKey(cd.PADate__c, cd.ProjectNumber__c, cd.TaskNumber__c);
              
                snapshotqtymap.put(sSnapshotKey, cd.ExpenditureItem__r.Quantity__c );
            }
        }
        set<string> lSnapshotKeys = new set<string>();
        system.debug('costproductcostmap----------'+costproductcostmap);
         system.debug('oldcostproductcostmap----------'+oldcostproductcostmap);
       
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
            if(costdistmap.containsKey(sSnapshotKey) || oldcostdistmap.containskey(sSnapshotKey)){
                 
                 //string strkey = sSnapshotKey+costdistmap.get(sSnapshotKey).PLReportCategory__c;
                 /*oEarnedValueSnapshot.ProjectFunctionalRawCostPLODCEXPS__C =0;
                 oEarnedValueSnapshot.ProjectFunctionalRawCostPLODCSUBS__c =0;
                 oEarnedValueSnapshot.ProjectFunctionalRawCostPLLabor__c =0;
                oEarnedValueSnapshot.ProjectFunctionalRawCostPLFringe__c =0;
                 oEarnedValueSnapshot.ProjectFunctionalRawCostPLOverhead__c = 0;
                 */
                 
                 string odckey = sSnapshotKey+'ODC - Exps';
                  system.debug('ProjectFunctionalRawCostPLODCEXPS__c----------'+oEarnedValueSnapshot.ProjectFunctionalRawCostPLODCEXPS__C );
                  system.debug('ProjectFunctionalRawCostPLODCEXPS__c----------'+costproductcostmap.containskey(odckey) );
                  system.debug('costproductcostmap.get(odckey)----------'+costproductcostmap.get(odckey));
                  system.debug('oldcostproductcostmap---------'+oldcostproductcostmap.get(odckey));
                  if(oEarnedValueSnapshot.ProjectFunctionalRawCostPLODCEXPS__C == null)
                      oEarnedValueSnapshot.ProjectFunctionalRawCostPLODCEXPS__C = 0;
                   if(oEarnedValueSnapshot.ProjectFunctionalRawCostPLODCSUBS__C == null)
                      oEarnedValueSnapshot.ProjectFunctionalRawCostPLODCSUBS__C = 0;
                   if(oEarnedValueSnapshot.ProjectFunctionalRawCostPLLabor__C == null)
                      oEarnedValueSnapshot.ProjectFunctionalRawCostPLLabor__C = 0;
                   if(oEarnedValueSnapshot.ProjectFunctionalRawCostPLFringe__C == null)
                      oEarnedValueSnapshot.ProjectFunctionalRawCostPLFringe__C = 0;
                   if(oEarnedValueSnapshot.ProjectFunctionalRawCostPLOverhead__C == null)
                      oEarnedValueSnapshot.ProjectFunctionalRawCostPLOverhead__C = 0;
                 system.debug('RecalculateEVSMetricsmap--------'+RecalculateEVSMetricsmap);     
                     if(oldcostproductcostmap.containskey(odckey))
                        {
                            if(oldcostproductcostmap.get(odckey)!=null && oEarnedValueSnapshot.ProjectFunctionalRawCostPLODCEXPS__C!=null && RecalculateEVSMetricsmap.get(odckey) == false)
                            oEarnedValueSnapshot.ProjectFunctionalRawCostPLODCEXPS__C =  oEarnedValueSnapshot.ProjectFunctionalRawCostPLODCEXPS__C - oldcostproductcostmap.get(odckey);
                        }
                    if(costproductcostmap.containskey(odckey))
                    {   
                       
                        system.debug('251------'+ oEarnedValueSnapshot.ProjectFunctionalRawCostPLODCEXPS__C);
                        if(costproductcostmap.get(odckey)!=null && oEarnedValueSnapshot.ProjectFunctionalRawCostPLODCEXPS__C!=null)
                        oEarnedValueSnapshot.ProjectFunctionalRawCostPLODCEXPS__C = oEarnedValueSnapshot.ProjectFunctionalRawCostPLODCEXPS__C + costproductcostmap.get(odckey);                      
                   }
                   string odcsubkey = sSnapshotKey+'ODC - Subs';                   
                    if(oldcostproductcostmap.containskey(odcsubkey))
                        {
                            if(oldcostproductcostmap.get(odcsubkey)!=null && oEarnedValueSnapshot.ProjectFunctionalRawCostPLODCSUBS__C !=null && RecalculateEVSMetricsmap.get(odcsubkey) == false)
                            oEarnedValueSnapshot.ProjectFunctionalRawCostPLODCSUBS__C =  oEarnedValueSnapshot.ProjectFunctionalRawCostPLODCSUBS__C - oldcostproductcostmap.get(odcsubkey);
                        }
                        system.debug('263-------'+oEarnedValueSnapshot.ProjectFunctionalRawCostPLODCEXPS__C);
                    if(costproductcostmap.containskey(odcsubkey))
                    {
                        
                         if(costproductcostmap.get(odcsubkey)!=null &&  oEarnedValueSnapshot.ProjectFunctionalRawCostPLODCSUBS__c!=null)
                        oEarnedValueSnapshot.ProjectFunctionalRawCostPLODCSUBS__c =  oEarnedValueSnapshot.ProjectFunctionalRawCostPLODCSUBS__c + costproductcostmap.get(odcsubkey);                   
                    system.debug('265-------'+oEarnedValueSnapshot.ProjectFunctionalRawCostPLODCEXPS__C);
                    }
                    string Laborkey = sSnapshotKey+'Labor';                      
                      if(oldcostproductcostmap.containskey(Laborkey))
                        {
                            if(oldcostproductcostmap.get(Laborkey)!=null && oEarnedValueSnapshot.ProjectFunctionalRawCostPLLabor__C  !=null && RecalculateEVSMetricsmap.get(Laborkey) == false)
                            oEarnedValueSnapshot.ProjectFunctionalRawCostPLLabor__C =  oEarnedValueSnapshot.ProjectFunctionalRawCostPLLabor__C - oldcostproductcostmap.get(Laborkey);
                        }
                    if(costproductcostmap.containskey(Laborkey))
                    {
                        if(costproductcostmap.get(Laborkey)!=null && oEarnedValueSnapshot.ProjectFunctionalRawCostPLLabor__c !=null)
                        oEarnedValueSnapshot.ProjectFunctionalRawCostPLLabor__c = oEarnedValueSnapshot.ProjectFunctionalRawCostPLLabor__c +costproductcostmap.get(Laborkey);                   
                    }
                    string Fringekey = sSnapshotKey+'Fringe';                   
                      if(oldcostproductcostmap.containskey(Fringekey))
                        {
                            if(oldcostproductcostmap.get(Fringekey)!=null && oEarnedValueSnapshot.ProjectFunctionalRawCostPLFringe__C !=null && RecalculateEVSMetricsmap.get(Fringekey) == false)
                            oEarnedValueSnapshot.ProjectFunctionalRawCostPLFringe__C =  oEarnedValueSnapshot.ProjectFunctionalRawCostPLFringe__C - oldcostproductcostmap.get(Fringekey);
                        }
                    if(costproductcostmap.containskey(Fringekey))
                    {
                            if(costproductcostmap.get(Fringekey)!=null && oEarnedValueSnapshot.ProjectFunctionalRawCostPLFringe__c !=null)
                           oEarnedValueSnapshot.ProjectFunctionalRawCostPLFringe__c =  oEarnedValueSnapshot.ProjectFunctionalRawCostPLFringe__c + costproductcostmap.get(Fringekey);
                    }
                    string Overheadkey = sSnapshotKey+'Overhead';                   
                    if(oldcostproductcostmap.containskey(Overheadkey ))
                        {
                            if(oldcostproductcostmap.get(Overheadkey )!=null && oEarnedValueSnapshot.ProjectFunctionalRawCostPLOverhead__C !=null && RecalculateEVSMetricsmap.get(Overheadkey ) == false)
                            oEarnedValueSnapshot.ProjectFunctionalRawCostPLOverhead__C =  oEarnedValueSnapshot.ProjectFunctionalRawCostPLOverhead__C - oldcostproductcostmap.get(Overheadkey );
                        }
                    if(costproductcostmap.containskey(Overheadkey ))
                    {
                         if(oldcostproductcostmap.get(Overheadkey)!=null && oEarnedValueSnapshot.ProjectFunctionalRawCostPLOverhead__c !=null)
                            oEarnedValueSnapshot.ProjectFunctionalRawCostPLOverhead__c =  oEarnedValueSnapshot.ProjectFunctionalRawCostPLOverhead__c +costproductcostmap.get(Overheadkey);
                    }  
                   bRecordToAdd = true;              
            }
            if(snapshotqtymap.containsKey(sSnapshotKey)){
                oEarnedValueSnapshot.ProjectHours__c = snapshotqtymap.get(sSnapshotKey);
            }      
                    if(oldsnapshotresourcetypemap.containskey(sSnapshotKey+'LAB'))
                    {
                        if(oldsnapshotresourcetypemap.get(sSnapshotKey+'LAB') !=null)
                        oEarnedValueSnapshot.ProjectFunctionalRawCostResourceLabor__c = 
                        	oEarnedValueSnapshot.ProjectFunctionalRawCostResourceLabor__c - oldsnapshotresourcetypemap.get(sSnapshotKey+'LAB');
                        bRecordToAdd = true;  
                    }
                    if(oldsnapshotresourcetypemap.containskey(sSnapshotKey+'NonLAB'))
                    {
                        if(oldsnapshotresourcetypemap.get(sSnapshotKey+'NonLAB') !=null)
                        oEarnedValueSnapshot.ProjectFunctionalRawCostResourcenonLabor__c = 
                        	oEarnedValueSnapshot.ProjectFunctionalRawCostResourcenonLabor__c - oldsnapshotresourcetypemap.get(sSnapshotKey+'NonLAB');
                        bRecordToAdd = true;  
                    }
            
                    if(snapshotresourcetypemap.containskey(sSnapshotKey+'LAB'))
                    {
                        oEarnedValueSnapshot.ProjectFunctionalRawCostResourceLabor__c = 
                        	oEarnedValueSnapshot.ProjectFunctionalRawCostResourceLabor__c + snapshotresourcetypemap.get(sSnapshotKey+'LAB');
                        bRecordToAdd = true;  
                    }
                    if(snapshotresourcetypemap.containskey(sSnapshotKey+'NonLAB'))
                    {
                      	oEarnedValueSnapshot.ProjectFunctionalRawCostResourcenonLabor__c = 
                      		oEarnedValueSnapshot.ProjectFunctionalRawCostResourcenonLabor__c + snapshotresourcetypemap.get(sSnapshotKey+'NonLAB');
                      	bRecordToAdd = true;  
                   }
                   
                   // If null, set to zero
                   if (oEarnedValueSnapshot.ProjectFunctionalRawCostResourceNonLabor__c == null) {
                        oEarnedValueSnapshot.ProjectFunctionalRawCostResourceNonLabor__c = 0;
                   }
                   // If null, set to zero
                   if (oEarnedValueSnapshot.ProjectFunctionalRawCostResourceLabor__c == null) {
                        oEarnedValueSnapshot.ProjectFunctionalRawCostResourceLabor__c = 0;
                   }
                   
                   oEarnedValueSnapshot.ProjectFunctionalRawCost__c = oEarnedValueSnapshot.ProjectFunctionalRawCostResourcenonLabor__c + 
                        oEarnedValueSnapshot.ProjectFunctionalRawCostResourceLabor__c;
                      
            if(bRecordToAdd)
                lEarnedValueSnapshotsToUpdate.add(oEarnedValueSnapshot);
        }

        if (!lEarnedValueSnapshotsToUpdate.isEmpty()) {
           system.debug('lEarnedValueSnapshotsToUpdate----'+lEarnedValueSnapshotsToUpdate[0].id);
                      system.debug('lEarnedValueSnapshotsToUpdate----'+lEarnedValueSnapshotsToUpdate.size());
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