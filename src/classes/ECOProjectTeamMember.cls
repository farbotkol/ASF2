global class ECOProjectTeamMember implements Database.Batchable<sObject>,Database.Stateful,Schedulable{
    
    String query;
    Public list<string> Fiscallist{get;set;}
    global ECOProjectTeamMember() {
        query = 'select Id,name,Department__c,  Contact__c,LaborCost01FiscalMonthAgo__c,LaborCost02FiscalMonthAgo__c,LaborCost03FiscalMonthsAgo__c,LaborCost04FiscalMonthsAgo__c,LaborCost05FiscalMonthsAgo__c,LaborCost06FiscalMonthsAgo__c,LaborCost07FiscalMonthsAgo__c,LaborCost08FiscalMonthsAgo__c,LaborCost09FiscalMonthsAgo__c,LaborCost10FiscalMonthsAgo__c,LaborCost11FiscalMonthsAgo__c,LaborCost12FiscalMonthsAgo__c,LaborHours01FiscalMonthAgo__c,LaborHours02FiscalMonthsAgo__c,LaborHours03FiscalMonthsAgo__c,LaborHours04FiscalMonthsAgo__c,LaborHours05FiscalMonthsAgo__c,LaborHours06FiscalMonthsAgo__c,LaborHours07FiscalMonthsAgo__c,LaborHours08FiscalMonthsAgo__c,LaborHours09FiscalMonthsAgo__c,LaborHours10FiscalMonthsAgo__c,LaborHours11FiscalMonthsAgo__c,LaborHours12FiscalMonthsAgo__c,PersonId__c,Project__c,Project__r.pse__Is_Active__c from ProjectTeamMember__C';
        string currentfiscalperiod = [select id, name, pse__End_Date__c, pse__start_Date__c, TimePeriodCode__c, pse__type__c from pse__Time_Period__c where  pse__type__c = 'Month'  and pse__start_Date__c <=today and pse__end_date__c >= today order by pse__start_date__c desc limit 1].TimePeriodCode__c;
       Fiscallist = new list<string>();
       if(currentfiscalperiod !=null)
       Fiscallist = Fiscalmethod(currentfiscalperiod );
   //ProjectTeamMember__c p =  [select Id,name,LaborCost01FiscalMonthAgo__c,LaborCost02FiscalMonthAgo__c,LaborCost03FiscalMonthsAgo__c,LaborCost04FiscalMonthsAgo__c,LaborCost05FiscalMonthsAgo__c,LaborCost06FiscalMonthsAgo__c,LaborCost07FiscalMonthsAgo__c,LaborCost08FiscalMonthsAgo__c,LaborCost09FiscalMonthsAgo__c,LaborCost10FiscalMonthsAgo__c,LaborCost11FiscalMonthsAgo__c,LaborCost12FiscalMonthsAgo__c,LaborHours01FiscalMonthAgo__c,LaborHours02FiscalMonthsAgo__c,LaborHours03FiscalMonthsAgo__c,LaborHours04FiscalMonthsAgo__c,LaborHours05FiscalMonthsAgo__c,LaborHours06FiscalMonthsAgo__c,LaborHours07FiscalMonthsAgo__c,LaborHours08FiscalMonthsAgo__c,LaborHours09FiscalMonthsAgo__c,LaborHours10FiscalMonthsAgo__c,LaborHours11FiscalMonthsAgo__c,LaborHours12FiscalMonthsAgo__c,PersonId__c,Project__c,Project__r.pse__Is_Active__c from ProjectTeamMember__C];
    }
    public list<string> Fiscalmethod(string str){
        //string str = 'FY2016-01';
        string Year = str.substringAfter('FY').substringBefore('-');
        string Month = str.substringAfter('FY').substringAfter('-');
        List<string> Fiscallist = new list<string>();
        Fiscallist.add(str);
        Integer d =0;
        Integer d1 =0;
        FOR(Integer i=0; i<=13;i++)
        {
           integer Mon = Integer.valueOf(Month)-i;
           if(Mon >=1)
           {
              String ste;
              if(Mon <10)
                  ste = 'FY'+Year+'-0'+Mon;
              else
                  ste = 'FY'+Year+'-'+Mon;
               Fiscallist.add(ste); 
               
           }
           else
           {
               Integer lastyear;
               Integer lastyearmonth;
               if(d !=12)
               {
                   lastyear = integer.valueof(Year)-1;
                    lastyearmonth = 12-d;
                     String ste;
                     if(lastyearmonth <10)
                         ste = 'FY'+lastyear+'-0'+lastyearmonth;
                     else
                         ste = 'FY'+lastyear+'-'+lastyearmonth;
                     
                    Fiscallist.add(ste);
                    d = d+ 1; 
               }
               else{
                   lastyear = integer.valueof(Year)-2;
                    lastyearmonth = 12-d1;            
                     String ste;
                     if(lastyearmonth <10)
                         ste = 'FY'+lastyear+'-0'+lastyearmonth;
                     else
                          ste = 'FY'+lastyear+'-'+lastyearmonth;
                    Fiscallist.add(ste);
                    d1 = d1+1;
               }
           }
          }  
        return Fiscallist;
    }
    
  
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<ProjectTeamMember__c> scope) {
            List<String> Projectidlist = new list<string>();
            list<string> personidlist = new list<string>();
            Map<string,decimal> LabourHoursMap = new map<string,decimal>();
            Map<string,decimal> LabourCostMap = new map<string,decimal>();
            list<ProjectTeamMember__c> TobeupdatedTeammemberlist = new list<ProjectTeamMember__c>();
            for(ProjectTeamMember__c ptm:scope ){
                if(ptm.project__c !=null)
                Projectidlist.add(ptm.project__C);
                if(ptm.personid__c !=null)
                personidlist.add(ptm.personid__c);
            }
           /* Map<string,string> Departmentmap = new map<string,string>();
            if(personidlist.size()>0)
            {
                
            
            }
            */
            
            if(projectidlist.size()>0 || personidlist.size()>0)
            {
                for(ExpendItem__c exp :[select id,Quantity__c,  PersonId__c,project__r.pse__Is_Active__c,Project__c,ExpenditureType__c, ExpenditureItemDate__c,ExpenditureDateFiscalMonth__c from ExpendItem__c  where personid__c !=null  and project__r.pse__Is_Active__c = true and project__c IN:projectidlist and personid__c IN:Personidlist and ExpenditureDateFiscalMonth__c IN:Fiscallist])
                {
                    if(exp.quantity__c !=null)
                    {
                    
                        if(LabourHoursMap.containskey(exp.personid__c+exp.project__c+exp.ExpenditureDateFiscalMonth__C))
                        {
                                Decimal Qty = LabourHoursMap.get(exp.personid__c+exp.project__c+exp.ExpenditureDateFiscalMonth__C) + exp.quantity__c;
                                LabourHoursMap.put(exp.personid__c+exp.project__c+exp.ExpenditureDateFiscalMonth__C,qty);
                            
                        }
                        else
                        {
                            
                                LabourHoursMap.put(exp.personid__c+exp.project__c+exp.ExpenditureDateFiscalMonth__C,exp.quantity__c);
                        }
                    }
                } 
               
               
               for(CostDistLine__c cdl :[select id,ExpenditureItem__r.project__c,ExpenditureItem__r.PersonId__c,ExpenditureItem__c,ProjectNumber__c,ProjectFunctionalBurdenedCost__c,PAFiscalMonth__c,ExpenditureItem__r.project__r.pse__Is_Active__c  from CostDistLine__c where ExpenditureItem__r.PersonId__c !=null and ExpenditureItem__r.project__r.pse__Is_Active__c = true and ExpenditureItem__r.project__c IN:Projectidlist and ExpenditureItem__r.PersonId__c IN:personidlist and PAFiscalMonth__c IN:Fiscallist])
               {
                   if(cdl.ProjectFunctionalBurdenedCost__c !=null)
                    {
                    
                        if(LabourCostMap.containskey(cdl.ExpenditureItem__r.PersonId__c+cdl.ExpenditureItem__r.project__c+cdl.PAFiscalMonth__c))
                        {
                             Decimal Cost = LabourCostMap.get(cdl.ExpenditureItem__r.PersonId__c+cdl.ExpenditureItem__r.project__c+cdl.PAFiscalMonth__c)+ cdl.ProjectFunctionalBurdenedCost__c;
                             LabourCostMap.put((cdl.ExpenditureItem__r.PersonId__c+cdl.ExpenditureItem__r.project__c+cdl.PAFiscalMonth__c),cost);
                             
                        }
                    }
                    else
                    {
                        LabourCostMap.put((cdl.ExpenditureItem__r.PersonId__c+cdl.ExpenditureItem__r.project__c+cdl.PAFiscalMonth__c),cdl.ProjectFunctionalBurdenedCost__c);
                    }
                
                }
                for(ProjectTeamMember__c ptm:scope){
                    if(labourhoursmap.containskey(ptm.personid__c+ptm.project__c+Fiscallist[0]))
                        ptm.LaborHours01FiscalMonthAgo__c = labourhoursmap.get(ptm.personid__c+ptm.project__c+Fiscallist[0]);
                    if(labourhoursmap.containskey(ptm.personid__c+ptm.project__c+Fiscallist[1]))
                        ptm.LaborHours02FiscalMonthsAgo__c = labourhoursmap.get(ptm.personid__c+ptm.project__c+Fiscallist[1]);
                    if(labourhoursmap.containskey(ptm.personid__c+ptm.project__c+Fiscallist[2]))
                        ptm.LaborHours03FiscalMonthsAgo__c = labourhoursmap.get(ptm.personid__c+ptm.project__c+Fiscallist[2]);
                    if(labourhoursmap.containskey(ptm.personid__c+ptm.project__c+Fiscallist[3]))
                        ptm.LaborHours04FiscalMonthsAgo__c = labourhoursmap.get(ptm.personid__c+ptm.project__c+Fiscallist[3]);
                    if(labourhoursmap.containskey(ptm.personid__c+ptm.project__c+Fiscallist[4]))
                        ptm.LaborHours05FiscalMonthsAgo__c = labourhoursmap.get(ptm.personid__c+ptm.project__c+Fiscallist[4]);
                    if(labourhoursmap.containskey(ptm.personid__c+ptm.project__c+Fiscallist[5]))
                        ptm.LaborHours06FiscalMonthsAgo__c = labourhoursmap.get(ptm.personid__c+ptm.project__c+Fiscallist[5]);
                    if(labourhoursmap.containskey(ptm.personid__c+ptm.project__c+Fiscallist[6]))
                        ptm.LaborHours07FiscalMonthsAgo__c = labourhoursmap.get(ptm.personid__c+ptm.project__c+Fiscallist[6]);
                    if(labourhoursmap.containskey(ptm.personid__c+ptm.project__c+Fiscallist[7]))
                        ptm.LaborHours08FiscalMonthsAgo__c = labourhoursmap.get(ptm.personid__c+ptm.project__c+Fiscallist[7]);
                    if(labourhoursmap.containskey(ptm.personid__c+ptm.project__c+Fiscallist[8]))
                        ptm.LaborHours09FiscalMonthsAgo__c = labourhoursmap.get(ptm.personid__c+ptm.project__c+Fiscallist[8]);
                    if(labourhoursmap.containskey(ptm.personid__c+ptm.project__c+Fiscallist[9]))
                        ptm.LaborHours10FiscalMonthsAgo__c = labourhoursmap.get(ptm.personid__c+ptm.project__c+Fiscallist[9]);
                    if(labourhoursmap.containskey(ptm.personid__c+ptm.project__c+Fiscallist[10]))
                        ptm.LaborHours11FiscalMonthsAgo__c = labourhoursmap.get(ptm.personid__c+ptm.project__c+Fiscallist[10]);
                    if(labourhoursmap.containskey(ptm.personid__c+ptm.project__c+Fiscallist[11]))
                        ptm.LaborHours12FiscalMonthsAgo__c = labourhoursmap.get(ptm.personid__c+ptm.project__c+Fiscallist[11]);
                    
                    if(labourcostmap.containskey(ptm.personid__c+ptm.project__c+Fiscallist[0]))
                        ptm.LaborCost01FiscalMonthAgo__c = labourcostmap.get(ptm.personid__c+ptm.project__c+Fiscallist[0]);
                    if(labourcostmap.containskey(ptm.personid__c+ptm.project__c+Fiscallist[1]))
                        ptm.LaborCost02FiscalMonthAgo__c = labourcostmap.get(ptm.personid__c+ptm.project__c+Fiscallist[1]);
                    if(labourcostmap.containskey(ptm.personid__c+ptm.project__c+Fiscallist[2]))
                        ptm.LaborCost03FiscalMonthsAgo__c = labourcostmap.get(ptm.personid__c+ptm.project__c+Fiscallist[2]);
                    if(labourcostmap.containskey(ptm.personid__c+ptm.project__c+Fiscallist[3]))
                        ptm.LaborCost04FiscalMonthsAgo__c = labourcostmap.get(ptm.personid__c+ptm.project__c+Fiscallist[3]);
                    if(labourcostmap.containskey(ptm.personid__c+ptm.project__c+Fiscallist[4]))
                        ptm.LaborCost05FiscalMonthsAgo__c = labourcostmap.get(ptm.personid__c+ptm.project__c+Fiscallist[4]);
                    if(labourcostmap.containskey(ptm.personid__c+ptm.project__c+Fiscallist[5]))
                        ptm.LaborCost06FiscalMonthsAgo__c = labourcostmap.get(ptm.personid__c+ptm.project__c+Fiscallist[5]);
                    if(labourcostmap.containskey(ptm.personid__c+ptm.project__c+Fiscallist[6]))
                        ptm.LaborCost07FiscalMonthsAgo__c = labourcostmap.get(ptm.personid__c+ptm.project__c+Fiscallist[6]);
                    if(labourcostmap.containskey(ptm.personid__c+ptm.project__c+Fiscallist[7]))
                        ptm.LaborCost08FiscalMonthsAgo__c = labourcostmap.get(ptm.personid__c+ptm.project__c+Fiscallist[7]);
                    if(labourcostmap.containskey(ptm.personid__c+ptm.project__c+Fiscallist[8]))
                        ptm.LaborCost09FiscalMonthsAgo__c = labourcostmap.get(ptm.personid__c+ptm.project__c+Fiscallist[8]);
                    if(labourcostmap.containskey(ptm.personid__c+ptm.project__c+Fiscallist[9]))
                        ptm.LaborCost10FiscalMonthsAgo__c = labourcostmap.get(ptm.personid__c+ptm.project__c+Fiscallist[9]);
                    if(labourcostmap.containskey(ptm.personid__c+ptm.project__c+Fiscallist[10]))
                        ptm.LaborCost11FiscalMonthsAgo__c = labourcostmap.get(ptm.personid__c+ptm.project__c+Fiscallist[10]);
                    if(labourcostmap.containskey(ptm.personid__c+ptm.project__c+Fiscallist[11]))
                        ptm.LaborCost12FiscalMonthsAgo__c = labourcostmap.get(ptm.personid__c+ptm.project__c+Fiscallist[11]);
                   TobeupdatedTeammemberlist.add(ptm);
                }         
            
            }
            if(TobeupdatedTeammemberlist.size()>0)
                update TobeupdatedTeammemberlist ;
    }
    
    global void finish(Database.BatchableContext BC) {
    
    }

      global void execute(SchedulableContext sc)
    {
         ECOProjectTeamMember  b = new ECOProjectTeamMember();
          database.executebatch(b);
     }
    
}