public class OpportunityTriggerHandler {
	public OpportunityTriggerHandler() {}

	public static void handleBeforeInsert(List<Opportunity> opps) {
		// OpportunityBeforeInsertBeforeUpdate Before Insert
		// check if we not need to run trigger if data loading operation is performed
	    ExecuteTrigger__c ext = ExecuteTrigger__c.getAll().get('OpportunityBeforeInsertBeforeUpdate');
	    if(ext != null) {
	        if(ext.NotRunTrigger__c) {
	            return;    
	        }
	        
	    }
	    
	    Set<id> setOpp = new Set<id>();
	    Set<String> deptNames = new Set<String>();
	    Set<String> employeeIds = new Set<String>();

	    //User currentuser=TaskOrderRollup.getCurrentUser();
	    for(Opportunity opp : opps)
	    {
	        //--------Added by Radial Web 21 March 2014 Set Oracle Project manager --------
	        if (opp.Oracle_PM_Employee_ID__c != null) employeeIds.add(opp.Oracle_PM_Employee_ID__c);
	        
	        opp.AECOM_Primary_Department_Percent__c = 100;

	        
	        //------------------------------------------------------------//
	        //Added sumit for task -T-12240
	        //if(opp.sub_practice_area_eu__c!=null)
	        //    opp.practice_area__c = opp.sub_practice_area_eu__c;
	        //------------------------------------------------------------------
	        // prepare set of Master Contracts
	        if(opp.Master_Contract_lookup__c!=null)
	        {
	            setOpp.add(opp.Master_Contract_lookup__c);
	        }
	        // prepare set of AECOM Primary Deppts
	        if(opp.AECOM_Primary_Dept_Lookup__c != null)
	        {
	            deptNames.add(opp.AECOM_Primary_Dept_Lookup__c);
	        }         
	    }
	    //Set Master Contract Number
	    if(setOpp.size()>0)
	    {
	        Map<id,Opportunity> mapOpp = new Map<id,Opportunity>([Select id,Client_Solicitation_ID_number__c,Master_Contract_Number__c,RecordTypeId from  Opportunity where id in:setOpp ]);
	        //Code By Sumit related to Task Order Parent Validation...
	        Map<Id,RecordType> mapidRecordType = TaskOrderRollup.getOpportunityRecordtypeMapById();
	     
	        for(Opportunity opp:opps)
	        {
	            if(opp.Master_Contract_lookup__c!=null)
	            {
	                Opportunity OppMaster = mapOpp.get(opp.Master_Contract_lookup__c);
	                if(OppMaster!=null)
	                {
	                    RecordType newOppRT = mapidRecordType.get(opp.RecordTypeId);
	                    RecordType parentOppRT = mapidRecordType.get(OppMaster.RecordTypeId);
	                    if(newOppRT!=null && parentOppRT!=null)
	                    {
	                        if(newOppRT.DeveloperName.toLowerCase().indexof('task')>=0 && 
	                           parentOppRT.DeveloperName.toLowerCase().indexof('program')<0)
	                        {
	                            opp.addError('Please select Opportunity of type Program as a Master Contract'); 
	                        }
	                    }
	                    Opp.Master_Contract_Number_Program__c = OppMaster.Master_Contract_Number__c;
	                    Opp.Master_Contract_Number__c = OppMaster.Master_Contract_Number__c;
	                }
	            }
	        }
	    }
	    Map<string,string> StateCountry= new Map<string,string>();
	    List<ValidState__c> lstStates = TaskOrderRollup.getStateList();
	    
	    
	    for(ValidState__c state:lstStates)
	    {
	        if(state.Country__c!=null)
	            StateCountry.put(state.Name.toLowerCase(),state.Country__c.tolowerCase());
	    }
	    
	    //--------Added by Radial Web 21 March 2014 Set Oracle Project manager --------
	    Map<String, AECOM_Employee__c > hrMap = new Map<String, AECOM_Employee__c >();
	    List<AECOM_Employee__c> hrEmployees = [SELECT ID, Employee_ID__c FROM AECOM_Employee__c WHERE Employee_ID__c IN :employeeIds];
	    for (AECOM_Employee__c emp : hrEmployees) hrMap.put(emp.Employee_ID__c, emp);
	    //--------Added by Radial Web 04 April 2014 Set Record Type Text --------
	    Map<ID, RecordType> rtMap = TaskOrderRollup.getOpportunityRecordtypeMapById(); 
		//--end Radial
		//
	    for(Opportunity opp:opps)
	    {
	        //--------Added by Radial Web 21 March 2014 Set Oracle Project manager --------
	        if (opp.Oracle_PM_Employee_ID__c == null && opp.Oracle_Project_Manager__c != null) {
	            opp.Oracle_Project_Manager__c = null;
	        } else if (opp.Oracle_PM_Employee_ID__c != null) {
	            AECOM_Employee__c hrEmp = hrMap.get(opp.Oracle_PM_Employee_ID__c);
	            if (hrEmp != null) {
	                opp.Oracle_Project_Manager__c = hrEmp.ID;
	            } else {
	                opp.Oracle_Project_Manager__c = null;
	            }         
	        }
	        //--end Radial
	        //--------Added by Radial Web 04 April 2014 Set Record Type Text --------
	        RecordType rt = rtMap.get(opp.RecordTypeId);
	        if (rt != null) {
	            opp.RecordTypeText__c = rt.Name;
	        }
	        //--end Radial
	        
	        Opp.Master_Contract_Number_Program__c = Opp.Master_Contract_Number__c;
	        
	        if(TaskOrderRollup.getOpportunityRecordtypeMapById().get(Opp.RecordTypeId).Name.Indexof('Asia')>=0)
	            continue;
	        
	        if(Opp.Project_State_Province__c !=null)
	        {
	            List<string>states = Opp.Project_State_Province__c.split(';');
	            Set<string> diffCountries = new Set<string>();
	            for(string st:states)
	            {
	                if(st!=null)
	                {
	                    if(StateCountry.get(st.trim().toLowerCase()) != null)
	                         diffCountries.add(StateCountry.get(st.trim().toLowerCase()));       
	                }
	            }
	            // If more than one country selected.. show error message
	            if(diffCountries.size()>1)
	            {
	                opp.addError(System.label.MULTICOUNTRY);
	            }
	            else if(diffCountries.size()==1)
	            {
	                for(string s : diffCountries)
	                {
	                    if(s == 'us')
	                        Opp.ProjectCountry__c = 'United States';
	                    else
	                        Opp.ProjectCountry__c = s;
	                }
	            }
	        }
	    }
	}

	public static void handleBeforeUpdate(Map<Id,Opportunity> newOpps, Map<Id,Opportunity> oldOpps) {
		// OpportunityBeforeInsertBeforeUpdate Before Update
		// check if we not need to run trigger if data loading operation is performed
	    ExecuteTrigger__c ext = ExecuteTrigger__c.getAll().get('OpportunityBeforeInsertBeforeUpdate');
	    if(ext != null) {
	        if(ext.NotRunTrigger__c) {
	            return;    
	        }
	        
	    }
	    
	    Set<id> setOpp = new Set<id>();
	    Set<String> deptNames = new Set<String>();
	    Set<String> employeeIds = new Set<String>();

	    //User currentuser=TaskOrderRollup.getCurrentUser();
	    for(Opportunity opp : newOpps.values())
	    {
	        //--------Added by Radial Web 21 March 2014 Set Oracle Project manager --------
	        if (opp.Oracle_PM_Employee_ID__c != null) employeeIds.add(opp.Oracle_PM_Employee_ID__c);
	        
	        //------------------------------------------------------------//
	        //Added sumit for task -T-12240
	        //if(opp.sub_practice_area_eu__c!=null)
	        //    opp.practice_area__c = opp.sub_practice_area_eu__c;
	        //------------------------------------------------------------------
	        // prepare set of Master Contracts
	        if(opp.Master_Contract_lookup__c!=null)
	        {
	            if(opp.Master_Contract_lookup__c != oldOpps.get(Opp.Id).Master_Contract_lookup__c)
	                setOpp.add(opp.Master_Contract_lookup__c);
	        }
	        // prepare set of AECOM Primary Deppts
	        if(opp.AECOM_Primary_Dept_Lookup__c != null)
	        {
	            if(opp.AECOM_Primary_Dept_Lookup__c != oldOpps.get(Opp.Id).AECOM_Primary_Dept_Lookup__c)
	                deptNames.add(opp.AECOM_Primary_Dept_Lookup__c);
	        }         
	    }
	    //Set Master Contract Number
	    if(setOpp.size()>0)
	    {
	        Map<id,Opportunity> mapOpp = new Map<id,Opportunity>([Select id,Client_Solicitation_ID_number__c,Master_Contract_Number__c,RecordTypeId from  Opportunity where id in:setOpp ]);
	        //Code By Sumit related to Task Order Parent Validation...
	        Map<Id,RecordType> mapidRecordType = TaskOrderRollup.getOpportunityRecordtypeMapById();
	     
	        for(Opportunity opp:newOpps.values())
	        {
	            if(opp.Master_Contract_lookup__c!=null)
	            {
	                Opportunity OppMaster = mapOpp.get(opp.Master_Contract_lookup__c);
	                if(OppMaster!=null)
	                {
	                    RecordType newOppRT = mapidRecordType.get(opp.RecordTypeId);
	                    RecordType parentOppRT = mapidRecordType.get(OppMaster.RecordTypeId);
	                    if(newOppRT!=null && parentOppRT!=null)
	                    {
	                        if(newOppRT.DeveloperName.toLowerCase().indexof('task')>=0 && 
	                           parentOppRT.DeveloperName.toLowerCase().indexof('program')<0)
	                        {
	                            opp.addError('Please select Opportunity of type Program as a Master Contract'); 
	                        }
	                    }
	                    Opp.Master_Contract_Number_Program__c = OppMaster.Master_Contract_Number__c;
	                    Opp.Master_Contract_Number__c = OppMaster.Master_Contract_Number__c;
	                }
	            }
	        }
	    }
	    Map<string,string> StateCountry= new Map<string,string>();
	    List<ValidState__c> lstStates = TaskOrderRollup.getStateList();
	    
	    
	    for(ValidState__c state:lstStates)
	    {
	        if(state.Country__c!=null)
	            StateCountry.put(state.Name.toLowerCase(),state.Country__c.tolowerCase());
	    }
	    
	    //--------Added by Radial Web 21 March 2014 Set Oracle Project manager --------
	    Map<String, AECOM_Employee__c > hrMap = new Map<String, AECOM_Employee__c >();
	    List<AECOM_Employee__c> hrEmployees = [SELECT ID, Employee_ID__c FROM AECOM_Employee__c WHERE Employee_ID__c IN :employeeIds];
	    for (AECOM_Employee__c emp : hrEmployees) hrMap.put(emp.Employee_ID__c, emp);
	    //--------Added by Radial Web 04 April 2014 Set Record Type Text --------
	    Map<ID, RecordType> rtMap = TaskOrderRollup.getOpportunityRecordtypeMapById(); 
		//--end Radial
		//
	    for(Opportunity opp:newOpps.values())
	    {
	        //--------Added by Radial Web 21 March 2014 Set Oracle Project manager --------
	        if (opp.Oracle_PM_Employee_ID__c == null && opp.Oracle_Project_Manager__c != null) {
	            opp.Oracle_Project_Manager__c = null;
	        } else if (opp.Oracle_PM_Employee_ID__c != null) {
	            AECOM_Employee__c hrEmp = hrMap.get(opp.Oracle_PM_Employee_ID__c);
	            if (hrEmp != null) {
	                opp.Oracle_Project_Manager__c = hrEmp.ID;
	            } else {
	                opp.Oracle_Project_Manager__c = null;
	            }         
	        }
	        //--end Radial
	        //--------Added by Radial Web 04 April 2014 Set Record Type Text --------
	        RecordType rt = rtMap.get(opp.RecordTypeId);
	        if (rt != null) {
	            opp.RecordTypeText__c = rt.Name;
	        }
	        //--end Radial
	        
	        Opp.Master_Contract_Number_Program__c = Opp.Master_Contract_Number__c;
	        
	        if(TaskOrderRollup.getOpportunityRecordtypeMapById().get(Opp.RecordTypeId).Name.Indexof('Asia')>=0)
	            continue;
	        
	        if(Opp.Project_State_Province__c !=null)
	        {
	            List<string>states = Opp.Project_State_Province__c.split(';');
	            Set<string> diffCountries = new Set<string>();
	            for(string st:states)
	            {
	                if(st!=null)
	                {
	                    if(StateCountry.get(st.trim().toLowerCase()) != null)
	                         diffCountries.add(StateCountry.get(st.trim().toLowerCase()));       
	                }
	            }
	            // If more than one country selected.. show error message
	            if(diffCountries.size()>1)
	            {
	                opp.addError(System.label.MULTICOUNTRY);
	            }
	            else if(diffCountries.size()==1)
	            {
	                for(string s : diffCountries)
	                {
	                    if(s == 'us')
	                        Opp.ProjectCountry__c = 'United States';
	                    else
	                        Opp.ProjectCountry__c = s;
	                }
	            }
	        }
	    }
	}

	public static void handleBeforeDelete(Map<Id,Opportunity> newOpps, Map<Id,Opportunity> oldOpps) {
		//TaskOrderRollup Before Delete
		taskOrderBeforeDelete(newOpps, oldOpps);

		// Before Delete gng_OppToGNGC
		ExecuteTrigger__c ext = ExecuteTrigger__c.getAll().get('Go/No Go');
		if(ext != null && !ext.NotRunTrigger__c) gng_OppToGNGC.deleteGNGFromOpportunity(oldOpps.keySet());	
	}

	private static void taskOrderBeforeDelete(Map<Id,Opportunity> newOpps, Map<Id,Opportunity> oldOpps) {
		// check if we not need to run trigger if data loading operation is performed
		ExecuteTrigger__c ext = ExecuteTrigger__c.getAll().get('TaskOrderRollup');
		if(ext != null) {
			if(ext.NotRunTrigger__c) {
			  return;  
			}   
		}

		List<Opportunity> taskOrderOpportunityList = new List<Opportunity>(); 

		
		taskOrderOpportunityList  = oldOpps.values();

		Set<Id> parentOppList = new Set<Id>();
		List<id>childOpp = new List<id>();
		for(Opportunity opp:taskOrderOpportunityList) {
			if(opp.Master_Contract_Lookup__c!=null) {
				parentOppList.add(opp.Master_Contract_Lookup__c);
				childOpp.add(opp.id);
			}
			if(parentOppList.size() > 0 )
				TaskOrderRollup.calculateTaskOrderRollupTasks(parentOppList,childOpp);
		}
	}

	public static void handleAfterInsert(List<Opportunity> opps) {
		//ANZNotifyAccountManagers After Insert
		//TaskrelatedtoPrimaryDepartment After Insert
		//TaskOrderRollup After Insert
		//Adding After Insert for gng_OppToGNGC per AEGNG-192 
		List<Id> oppAcctIds = new List<Id>();
		List<Opportunity_Department__c> lstDept = new list<Opportunity_Department__c>();
		Set<Id> parentOppList = new Set<Id>();
		Map<String, List<Opportunity>> oppMap = new Map<String, List<Opportunity>>();
		try
	    {
	        String geography = [select Geography_Allocation__c from User where id = :UserInfo.getUserId()].Geography_Allocation__c;
	        for(Opportunity opp : opps) {
	        	oppAcctIds.add(opp.AccountId);
	        	if(opp.AECOM_Primary_Dept_Lookup__c!=null)
	           	{
		           	Opportunity_Department__c od = new Opportunity_Department__c(Opportunity__c = opp.Id,Split__c=100);
		           	od.AECOM_Department__c = opp.AECOM_Primary_Dept_Lookup__c;
		           	od.Primary__c = true;
		           	od.CurrencyISOCode = opp.CurrencyISOCode;
		           	lstDept.add(od);
		           	//GNG insert logic
		           	if(!oppMap.containsKey(opp.Geography_Formula__c)) oppMap.get(opp.Geography_Formula__c).add(opp);
               		else oppMap.put(opp.Geography_Formula__c, new List<Opportunity>{opp});
	           	}
	           	if(opp.Master_Contract_Lookup__c != null) parentOppList.add(opp.Master_Contract_Lookup__c);
	           	if(parentOppList.size() > 0) TaskOrderRollup.calculateTaskOrderRollupTasks(parentOppList,new List<Id>());
	        }
	        if(lstDept.size()>0) insert lstDept;
	        if(geography == 'ANZ')
	        {
                //get account managers, client directors and client managers  from account team
                List<AECOM_team__c> team = [SELECT Account__c, Email__c, IsDeleted, Role__c, Employee_User__r.Country FROM AECOM_team__c
                                            WHERE  Account__c IN: oppAcctIds 
                                            AND (Role__c = 'Client Manager' OR Role__c =  'Account Manager' OR Role__c =  'Client Director')
                                            AND IsDeleted = false
                                            AND Employee_User__r.Country in ('Australia', 'New Zealand')];
           
                //add team to list
                List<String> toAddresses = new List<String>();
                for(AECOM_team__c member : team)
                {
                    toAddresses.add(member.Email__c);
                }
                
                for(Opportunity opp : opps)
                {
	               	//Opportunity o = [select id from Opportunity where id = '006e0000005QhNz' limit 1];
	               	HelperMethods.sendTemplatedEmail(toAddresses, null, 'ANZ_Client_Bid_Activity_Template', null, opp.id, null, false, null);
	               	
	            }
	        }
	    }
    	catch (Exception e){System.debug(e);}
	}

	public static void handleAfterUpdate(Map<Id,Opportunity> newOpps, Map<Id,Opportunity> oldOpps) {
		// CurrencyChangereflect After Update
		// TaskOrderRollup After Update
		// TaskrelatedtoPrimaryDepartment After update
		// gng_OppToGNGC After update
		Set<id> oppSet = new Set<id>();
		List<Opportunity_Department__c> lstDept = new list<Opportunity_Department__c>();
        Map<id,Id> OppDeptNew = new Map<id,Id>();
        Map<id,Id> OppDeptOld = new Map<id,Id>();
        Map<id,Opportunity_Department__c> OppDeptNew1 = new Map<id,Opportunity_Department__c>();
        Set<Id> parentOppList = new Set<Id>();
        List<Go_No_Go_Conversation__c> existingGNGs = [select Opportunity__c from Go_No_Go_Conversation__c where Opportunity__c in: newOpps.keyset()];
        Set<Id> existingGNGOppIds = new Set<Id>();
        for(Go_No_Go_Conversation__c g : existingGNGs) {
        	existingGNGOppIds.add(g.Opportunity__c);
        }

        //Map<Id, RecordType> recordTypeMap = new Map<Id, RecordType>([select Id, Name from RecordType where sObjectType = 'Opportunity']);

		List<Opportunity> needToCreateGNG = new List<Opportunity>();
		List<Opportunity> needToUpdateGNG = new List<Opportunity>();

	    for(Opportunity opp : newOpps.values())
	    {
	        if(opp.CurrencyIsoCode != oldOpps.get(opp.id).CurrencyIsoCode)
	            oppSet.add(opp.Id);
	        if(opp.AECOM_Primary_Dept_Lookup__c != oldOpps.get(opp.Id).AECOM_Primary_Dept_Lookup__c && 
	        	!ModifyDepartmentController.NotRunOpportunityUpdateTrigger)
            {
                OppDeptNew.put(opp.id,opp.AECOM_Primary_Dept_Lookup__c);
                OppDeptOld.put(opp.id,oldOpps.get(opp.Id).AECOM_Primary_Dept_Lookup__c);
                OppDeptNew1.put(opp.Id,new Opportunity_Department__c(CurrencyISOCode = opp.CurrencyISOCode,Opportunity__c = opp.Id,Split__c=0,AECOM_Department__c=opp.AECOM_Primary_Dept_Lookup__c,Primary__c = true));
            }
            if(!existingGNGOppIds.contains(opp.Id)) needToCreateGNG.add(opp);
			else needToUpdateGNG.add(opp);

			if(opp.Master_Contract_Lookup__c!=null) parentOppList.add(opp.Master_Contract_Lookup__c);
			String oldparent = oldOpps.get(opp.Id).Master_Contract_Lookup__c;
			if(oldparent != null && oldParent !='' && opp.Master_Contract_Lookup__c!=oldparent) parentOppList.add(oldparent);
	    }

	    if(parentOppList.size() > 0) TaskOrderRollup.calculateTaskOrderRollupTasks(parentOppList,new List<id>());
	    if(oppSet.size()>0)
	    {
	        for(List<Opportunity_Department__c> lst:[Select id,Opportunity__c, CurrencyISOCode from 
	                                            Opportunity_Department__c where Opportunity__c in : oppSet])
	        {
	            for(Opportunity_Department__c od:lst)
	                od.CurrencyISOCode = newOpps.get(od.Opportunity__c).CurrencyISOCode;
	            update lst;
	        }
	    }

        if(OppDeptNew.keyset().size()>0)
        {
            for(Opportunity_Department__c opd:[Select id,Primary__c, AECOM_Department__c,Opportunity__c 
                                               from Opportunity_Department__c 
                                               Where Opportunity__c in :OppDeptNew.Keyset() and 
                                               (AECOM_Department__c in :OppDeptNew.Values() OR AECOM_Department__c in :OppDeptOld.Values())])
            {
                if(OppDeptNew.get(opd.Opportunity__c) == opd.AECOM_Department__c)
                {
                    opd.Primary__c = true;
                    OppDeptNew1.put(opd.Opportunity__c,opd);
                }
                if(OppDeptold.get(opd.Opportunity__c) == opd.AECOM_Department__c)
                {
                    opd.Primary__c = false;
                    lstDept.add(opd);
                }
            }
            for(id id1:OppDeptNew1.keyset())
            {
               lstDept.add(OppDeptNew1.get(id1)); 
            }
            upsert lstDept;
       	}

       	ExecuteTrigger__c ext = ExecuteTrigger__c.getAll().get('Go/No Go');

       	//Create GNG records
		if(needToCreateGNG.size() > 0 && ext != null && !ext.NotRunTrigger__c) {
			Map<String, List<Opportunity>> regionOppMap = new Map<String, List<Opportunity>>();

			for(Opportunity o : needToCreateGNG) {
				if(String.isNotBlank(o.Geography_Formula__c)) {
					if(!regionOppMap.keySet().contains(o.Geography_Formula__c)) regionOppMap.put(o.Geography_Formula__c, new List<Opportunity>{o});
					else regionOppMap.get(o.Geography_Formula__c).add(o);
				}
			}
			gng_OppToGNGC.createGNGFromOpportunity(regionOppMap);
		}
		//Update GNG records
		else if(needToUpdateGNG.size() > 0  && ext != null && !ext.NotRunTrigger__c) {
			Map<String, Opportunity> oppMap = new Map<String, Opportunity>();
			for(Opportunity o : needToUpdateGNG) {
				if(String.isNotBlank(o.Geography_Formula__c)) oppMap.put(o.Id, o);
			}
			gng_OppToGNGC.updateGNGFromOpportunity(oppMap);
		}

	}

	public static void handleAfterDelete(Map<Id,Opportunity> newOpps, Map<Id,Opportunity> oldOpps) {}	

	public static void handleAfterUndelete(List<Opportunity> opps) {}
}