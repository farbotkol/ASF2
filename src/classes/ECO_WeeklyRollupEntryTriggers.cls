public class ECO_WeeklyRollupEntryTriggers {

    public static void calculateFiscalMonths(list<WeeklyRollupEntry__c> weeklyrollupentries) {
        list<date> enddatelist = new list<date>();
        Set<Date> datesToConvert = new Set<Date>();
        Map<Date, String> mapTimePeriodCodeByDate = new Map<Date, String> ();

        for (WeeklyRollupEntry__c ba : weeklyrollupentries) {
            datesToConvert.add(ba.PeriodStartDate__c);
            if (ba.PeriodStartDate__c != null) {
                enddatelist.add((ba.PeriodStartDate__c).addmonths(2));
                enddatelist.add((ba.PeriodStartDate__c).addmonths(-3));
            }
        }
        
        datesToConvert.remove(null);

        List<pse__Time_Period__c> timePeriods  = new  List<pse__Time_Period__c>();
        if (enddatelist.size() > 0) {
            // Time period
            timePeriods = ECO_Utils_Date.calcTimePeriods(enddatelist, 'Month');
            pse__Time_Period__c fm = null;

            for (Date dt : datesToConvert) {
                fm = ECO_Utils_Date.getFiscalPeriod(dt, 0, timePeriods);
                if (fm != null) {
                    mapTimePeriodCodeByDate.put(dt, fm.TimePeriodCode__c);
                }
            }

            for (WeeklyRollupEntry__c ba : weeklyrollupentries) {
                if (ba.PeriodStartDate__c != null) {
                    ba.FiscalMonth__c = mapTimePeriodCodeByDate.get(ba.PeriodStartDate__c);
                }
            }
        }

    }
}