public class ECO_WeeklyRollupEntryTriggers{

public static void calculateFiscalMonths(list<WeeklyRollupEntry__c> weeklyrollupentries){
     list<date> enddatelist = new list<date>();
        for (WeeklyRollupEntry__c ba : weeklyrollupentries){
             if (ba.PeriodStartDate__c != null){ 
                 
                 enddatelist.add((ba.PeriodStartDate__c).addmonths(2));
                 enddatelist.add((ba.PeriodStartDate__c).addmonths(-3));
             }
        }
         List<pse__Time_Period__c> timePeriods  = new  List<pse__Time_Period__c>();
        if(enddatelist.size()>0)
        {
            // Time period
          timePeriods = ECO_Utils_Date.calcTimePeriods(enddatelist,'Month');
           pse__Time_Period__c fm = null;
            for (WeeklyRollupEntry__c ba : weeklyrollupentries){
                if (ba.PeriodStartDate__c != null){ 
                    fm = ECO_Utils_Date.getFiscalPeriod(ba.PeriodStartDate__c, 0, timePeriods);                     
                    if (fm != null){
                        ba.FiscalMonth__c = fm.TimePeriodCode__c;
                    }
                    
                    
                }
            }
        }

}



}