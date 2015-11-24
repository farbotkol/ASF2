global class ECO_PMD_EarnedValueChart_xmpl_Controller {

     public ECO_PMD_EarnedValueChart_xmpl_Controller(){}

    
    @RemoteAction
    //global static List<EarnedValueResults> ProjectSnapshot(String projectNum)
    global static EarnedValueDetails ProjectSnapshot(String projectNum)
    {
        
        Id projectId = projectNum;


        EarnedValueDetails earnedValueDetails = new EarnedValueDetails();

        List<EarnedValueSnapshot__c> earnedvaluesnapshotdata = [SELECT WeekStartDate__c,ThisWeekRunningTotalAmount__c, WeeklyRollupEntry__r.PeriodStartDate__c, WeeklyRollupEntry__r.ProjectFunctionalBurdenedCost__c, 
                                                                       WeeklyRollupEntry__r.OverrideApprovedCost__c, WeeklyRollupEntry__r.EstimatedCost__c, WeeklyRollupEntry__r.CurrencyIsoCode 
                                                                FROM EarnedValueSnapshot__c where ThisWeekRunningTotalAmount__c >0 and WeeklyRollupEntry__r.Project__c = :projectId 
                                                                AND WeeklyRollupEntry__r.PeriodStartDate__c = LAST_N_MONTHS:12
                                                                order by WeeklyRollupEntry__r.PeriodStartDate__c asc];

        Integer listsize = earnedvaluesnapshotdata.size();

        if (listsize > 0)
        {
            earnedValueDetails.planned = earnedvaluesnapshotdata[earnedvaluesnapshotdata.size()-1].WeeklyRollupEntry__r.EstimatedCost__c;
            earnedValueDetails.actual = earnedvaluesnapshotdata[earnedvaluesnapshotdata.size()-1].WeeklyRollupEntry__r.ProjectFunctionalBurdenedCost__c;
            earnedValueDetails.earned= earnedvaluesnapshotdata[earnedvaluesnapshotdata.size()-1].ThisWeekRunningTotalAmount__c;
            earnedValueDetails.currencyCode = earnedvaluesnapshotdata[earnedvaluesnapshotdata.size()-1].WeeklyRollupEntry__r.CurrencyIsoCode;

            List<EarnedValueResults> earnedValueResults = new List<EarnedValueResults>();
            String period;
            String lastPeriod;
            for(EarnedValueSnapshot__c earnedvaluesnapshot : earnedvaluesnapshotdata) 
            {
                getFiscal f = new getFiscal();
                period = f.retVal(earnedvaluesnapshot.WeeklyRollupEntry__r.PeriodStartDate__c);
                EarnedValueResults earnedvalueresult = new EarnedValueResults();                
                earnedvalueresult.FYDate = period;
                earnedvalueresult.Actual = earnedvaluesnapshot.WeeklyRollupEntry__r.ProjectFunctionalBurdenedCost__c;
                earnedvalueresult.Planned = earnedvaluesnapshot.WeeklyRollupEntry__r.EstimatedCost__c;
                earnedvalueresult.Earned = earnedvaluesnapshot.ThisWeekRunningTotalAmount__c;
                earnedValueResults.add(earnedvalueresult);
            }
            earnedValueDetails.earnedValueData = earnedValueResults;
        }

        return earnedValueDetails;
    }

    public class getFiscal{
        String result; 
        public String retVal(Date d){
            result = String.valueOf(d.month() + 1);
            Integer m = d.month() + 1;
            if(m < 10){
                result ='0' + string.valueof(m);
            }
            return 'FY' + String.valueOf(d.year()) + result;
        }
    }

    global class EarnedValueDetails{ 
        public EarnedValueDetails()
        {
            error = '';
            nodata = false;
            currencyCode = '';
            planned=0;
            actual=0;
            earned=0;
            earnedValueData = null;
        }     
        public String error;
        public Boolean nodata;
        public string currencyCode;
        public List<EarnedValueResults>  earnedValueData;
        public Decimal planned;
        public Decimal actual;
        public Decimal earned;
        public Decimal ProjectFunctionalBurdenedCost;
    }

     global class EarnedValueResults{
        
        public Date PeriodStartDate {get; set;}
        public Decimal Actual {get; set;}
        public Decimal OverrideApprovedCost {get; set;}
        public Decimal Planned {get; set;}
        public Date WeekStartDate {get; set;}
        public Decimal Earned {get; set;}   
        public String FYDate {get; set;}
        
    }
}