public  class ECO_Service_ExchangeRate {


	private static map<Id, DatedConversionRate> dcrIdToDcrMap;

	public static Decimal getExchangeRate(String orginCurrencyCode, String destCurrencyCode, Date conversionDate)
	{
		if(orginCurrencyCode == destCurrencyCode)
			return 1;
		
		Decimal rateOrginCurrencyToOrgCurrency = convertToOrgCurrency(orginCurrencyCode, 1, conversionDate);
		Decimal rateOrgCurrencyToDestCurrency  = convertFromOrgCurrency(destCurrencyCode, rateOrginCurrencyToOrgCurrency, conversionDate);
		return rateOrgCurrencyToDestCurrency;
	}

	public static Decimal convertToOrgCurrencyByCurrencyCode(String currencyIso, Decimal currencyVal, Date currencyDate) {
		
	    Decimal res;
	    //dcrIdToDcrMap = new Map<ID,DatedConversionRate>();
	    
	    if (currencyIso == null || currencyVal == null) {
	    	return 0;
	    }
	    else {
             // build the map only once for life of the transaoction
	       	//dcrIdToDcrMap = new Map<ID,DatedConversionRate> ([select id, isoCode, conversionrate, nextStartDate, startDate from DatedConversionRate]);
	        dcrIdToDcrMap = new map<ID,DatedConversionRate> ([select id, isoCode, conversionrate, nextStartDate, startDate from DatedConversionRate where isoCode = :currencyIso]);
	        for (DatedConversionRate dcr: dcrIdToDcrMap.values()) {
	            if (dcr.isoCode != currencyIso)                                         
	            	continue;   // look for a match in table against input currency
	            if (currencyDate < dcr.startDate || currencyDate >= dcr.nextStartDate)  
	            	continue;   // not in the range of effective dates
	            System.debug(LoggingLevel.INFO,'Converting using dcr: ' + dcr);
	            res =  currencyVal / dcr.conversionRate;
	            break;  
	        }
	    }
	    return res;	
	}

	public static Decimal convertToOrgCurrency(String currencyIso, Decimal currencyVal, Date currencyDate) {
		
	    Decimal res;
	    //dcrIdToDcrMap = new Map<ID,DatedConversionRate>();
	    
	    if (currencyIso == null || currencyVal == null) {
	    	return 0;
	    }
	    else {
	        if (dcrIdToDcrMap == null)              // build the map only once for life of the transaoction
	        	//dcrIdToDcrMap = new Map<ID,DatedConversionRate> ([select id, isoCode, conversionrate, nextStartDate, startDate from DatedConversionRate]);
	            dcrIdToDcrMap = new map<ID,DatedConversionRate> ([select id, isoCode, conversionrate, nextStartDate, startDate from DatedConversionRate]);
	        for (DatedConversionRate dcr: dcrIdToDcrMap.values()) {
	            if (dcr.isoCode != currencyIso)                                         
	            	continue;   // look for a match in table against input currency
	            if (currencyDate < dcr.startDate || currencyDate >= dcr.nextStartDate)  
	            	continue;   // not in the range of effective dates
	            System.debug(LoggingLevel.INFO,'Converting using dcr: ' + dcr);
	            res =  currencyVal / dcr.conversionRate;
	            break;  
	        }
	    }
	    return res;
	}	
	
	//  ----------------------------------------
	//  convertFromOrgCurrency - convert value in org currency to some iso currency as of given date 
	//  ----------------------------------------
	private static Decimal convertFromOrgCurrency(String currencyIso, Decimal currencyVal, Date currencyDate) {
    	Decimal res;
    	//Map<Id,DatedConversionRate> dcrIdToDcrMap;
    	if (currencyIso == null || currencyVal == null) {
    		return 0;
    	}
    	else {
        	if (dcrIdToDcrMap == null)              // build the map only once for life of the transaoction
            	//dcrIdToDcrMap = new Map<ID,DatedConversionRate> ([select id, isoCode, conversionrate, nextStartDate, startDate from DatedConversionRate]);
            	dcrIdToDcrMap = new map<ID,DatedConversionRate> ([select id, isoCode, conversionrate, nextStartDate, startDate from DatedConversionRate]);
        	for (DatedConversionRate dcr: dcrIdToDcrMap.values()) {
            	if (dcr.isoCode != currencyIso)                                         
            		continue;   // look for a match in table against input currency
            	if (currencyDate < dcr.startDate || currencyDate >= dcr.nextStartDate)  
            		continue;   // not in the range of effective dates
            	System.debug(LoggingLevel.INFO,'Converting using dcr: ' + dcr);
            	res =  currencyVal * dcr.conversionRate;
            	break;  
        	}
    	}
    	return res;
	}	

}