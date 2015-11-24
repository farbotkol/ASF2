global class ECO_PMD_EarnedValueCPIChart_Controller {

     public ECO_PMD_EarnedValueCPIChart_Controller(){}

    
    @RemoteAction
    global static EarnedValueDetails ProjectSnapshot(String projectNum)
    {

        Id projectId = projectNum;

        EarnedValueDetails earnedValueDetails = new EarnedValueDetails();
        
        List<ProjectSnapshot__c> earnedValueData  =  [SELECT      
                    id, 
                    SnapshotDate__c,
                    EarnedValueCPI__c,
                    EarnedValueActualSpend__c, 
                    EarnedValuePlannedValue__c,
                    NMNSRITD__c,
                    ProjectStartDate__c, ProjectEndDate__c
                FROM            
                    ProjectSnapshot__c
                where 
                    Project__c = :projectId AND SnapshotDate__c = LAST_N_MONTHS:6
                    order by SnapshotDate__c asc];

        Integer listsize = earnedValueData.size();    

        if (listsize > 0)
        {
            earnedValueDetails.earnedValuesData = earnedValueData;
            
            earnedValueDetails.costvar = nullToZero(earnedValueData[listsize-1].EarnedValueActualSpend__c) - nullToZero(earnedValueData[listsize-1].EarnedValuePlannedValue__c);
            earnedValueDetails.cpi = nullToZero(earnedValueData[listsize-1].EarnedValueCPI__c);
            earnedValueDetails.currencyCode = earnedValueData[listsize-1].CurrencyIsoCode; 
        }
        else 
        {
            earnedValueDetails.nodata = true;

        }

        return earnedValueDetails;           
    }


    global static Decimal nullToZero(Decimal num ) {
        if (num == null) num = 0;
            return num;
    }

    global class EarnedValueDetails
    {
        public EarnedValueDetails()
        {
            error = '';
            nodata = false;

            currencyCode = '';
            
            costvar = 0;
            cpi = 0;

            earnedValuesData = null;
        }

        public String error;
        public Boolean nodata;

        public string currencyCode;

        public Decimal  costvar;
        public Decimal  cpi;

        public List<ProjectSnapshot__c> earnedValuesData;
    }
}