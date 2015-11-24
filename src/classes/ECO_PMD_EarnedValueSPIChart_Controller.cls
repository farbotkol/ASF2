global class ECO_PMD_EarnedValueSPIChart_Controller {

     public ECO_PMD_EarnedValueSPIChart_Controller(){}


    @RemoteAction
    global static EarnedValueDetails ProjectSnapshot(String projectNum)
    {

        Id projectId = projectNum;

        EarnedValueDetails earnedValueDetails = new EarnedValueDetails();
        
        List<ProjectSnapshot__c> earnedValueData  =  [SELECT      
        			id, 
				    SnapshotDate__c,
				    EarnedValueSPI__c,
				    ScheduledVarianceValue__c, 
				    ScheduledVarianceDays__c,
        			NMNSRITD__c
	            FROM            
	            	ProjectSnapshot__c
	            where 
	            	Project__c = :projectId AND SnapshotDate__c = LAST_N_MONTHS:6
	            	order by SnapshotDate__c asc];

        Integer listsize = earnedValueData.size();    

        if (listsize > 0)
        {
            earnedValueDetails.earnedValuesData = earnedValueData;
            
            earnedValueDetails.schvar = nullToZero(earnedValueData[listsize-1].ScheduledVarianceValue__c);
            earnedValueDetails.spi = nullToZero(earnedValueData[listsize-1].EarnedValueSPI__c);
            earnedValueDetails.schvardays = nullToZero(earnedValueData[listsize-1].ScheduledVarianceDays__c);
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
            
            schvar = 0;
            spi = 0;
            schvardays = 0;


            earnedValuesData = null;
        }

        public String error;
        public Boolean nodata;

        public string currencyCode;

        public Decimal  schvar;
        public Decimal  spi;
        public Decimal  schvardays;

        public List<ProjectSnapshot__c> earnedValuesData;
    }
}