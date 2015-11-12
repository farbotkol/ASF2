public without sharing class ECO_Utils_Date {
	
	private static Map<Integer, String> monthNameMap;
	private static map<String, Integer> monthNumberMap;
	
	public static String getMonthPrefixFromDate (Date theDate) {
		if (monthNameMap == null) {
			monthNameMap = new Map<Integer, String>();
			monthNameMap.put(1, 'JAN');
			monthNameMap.put(2, 'FEB');
			monthNameMap.put(3, 'MAR');
			monthNameMap.put(4, 'APR');
			monthNameMap.put(5, 'MAY');
			monthNameMap.put(6, 'JUN');
			monthNameMap.put(7, 'JUL');
			monthNameMap.put(8, 'AUG');
			monthNameMap.put(9, 'SEP');
			monthNameMap.put(10, 'OCT');
			monthNameMap.put(11, 'NOV');
			monthNameMap.put(12, 'DEC');
		}
		
		return monthNameMap.get(theDate.month());
	}
	
	public static Integer getMonthNumberFromPrefix (String monthPrefix) {
		if (monthNumberMap == null) {
			monthNumberMap = new Map<String, Integer>();
			monthNumberMap.put('JAN', 1);
			monthNumberMap.put('FEB', 2);
			monthNumberMap.put('MAR', 3);
			monthNumberMap.put('APR', 4);
			monthNumberMap.put('MAY', 5);
			monthNumberMap.put('JUN', 6);
			monthNumberMap.put('JUL', 7);
			monthNumberMap.put('AUG', 8);
			monthNumberMap.put('SEP', 9);
			monthNumberMap.put('OCT', 10);
			monthNumberMap.put('NOV', 11);
			monthNumberMap.put('DEC', 12);
		}
		
		return monthNumberMap.get(monthPrefix);
	}

	public static DateTime getDateTimeFromPICRequestStatusString(String dateTimeString)
	{
		//01-OCT-15 10.32.42.000000 PM UTC
		String dd=dateTimeString.subString(0,2);
		String mm=string.valueOf(getMonthNumberFromPrefix(dateTimeString.subString(3,6)));
		String yy=dateTimeString.subString(7,9);
		String hh=dateTimeString.subString(10, 12);
		String mn=dateTimeString.subString(13, 15);
		String ss=dateTimeString.subString(16, 18);
		String period=dateTimeString.subString(26, 28); 

		if(period == 'PM' && integer.valueOf(hh) < 12)
			hh = string.valueOf(integer.valueOf(hh) + 12);

		return DateTime.newInstanceGMT(2000 + integer.valueOf(yy), integer.valueOf(mm), integer.valueOf(dd), integer.valueOf(hh), integer.valueOf(mn), integer.valueOf(ss));
	}

	public static Integer getTwoDigitYearFromDate (Date theDate) {
		Integer returnInteger;
		
		String yearAsString = theDate.year().format();
		
		returnInteger = Integer.valueOf(yearAsString.right(2));
		
		return returnInteger;
	}
	
	public static String getPeriodNameFromDate (Date theDate) {
		String returnString = '';
		
		returnString += getMonthPrefixFromDate(theDate);
		returnString += '-';
		returnString += getTwoDigitYearFromDate(theDate).format();
		
		return returnString;
	}
	
	public static String formatDateAsYYYYDashMMDashdd(Date givenDate){
    	DateTime givenDateTime = DateTime.newInstance(givenDate, Time.newInstance(0,0,0,0));
    	return givenDateTime.format('YYYY-MM-dd');
    }
    
    public static String formatDateAsMMSlashDDSlashYYYY(Date givenDate){
    	DateTime givenDateTime = DateTime.newInstance(givenDate, Time.newInstance(0,0,0,0));
    	return givenDateTime.format('MM/dd/YYYY');
    }
    
   	/*
	 *  Returns the start of week dates between 2 dates
	 */
	public static List<String> getStartOfWeekDatesBetweenTwoDates(Date startDate, Date endDate) {
		// System.debug('In getStartOfWeekDatesBetweenTwoDates');
		Date firstWeekStartDate = startDate.toStartofWeek();
		Date lastWeekStartDate = endDate.toStartofWeek();
		
		List<String> listOfStartOfWeekDatesBetweenDates = new List<String>();
		Date currentWeekStartDate = firstWeekStartDate;
		while (currentWeekStartDate <= lastWeekStartDate) {
			// System.debug('In getStartOfWeekDatesBetweenTwoDates, inside loop');
			String dateAsMMSlashDDSlashYYYY = ECO_Utils_Date.formatDateAsMMSlashDDSlashYYYY(currentWeekStartDate);
			listOfStartOfWeekDatesBetweenDates.add(dateAsMMSlashDDSlashYYYY);	 
			currentWeekStartDate = currentWeekStartDate.addDays(7);
		}

		System.debug('All start of week dates: ' + listOfStartOfWeekDatesBetweenDates);
		return listOfStartOfWeekDatesBetweenDates;
	}
	
	
	public static pse__Time_Period__c getFiscalPeriod(Date dateUsed, Integer periodsBack, List<pse__Time_Period__c> timePeriods) {
		
		for (Integer i = 0; i < timePeriods.size(); i++){
            	if (dateUsed <= timePeriods[i].pse__End_Date__c  &&
                    dateUsed >= timePeriods[i].pse__Start_Date__c){ 
                    if (i > 0 && (i-periodsBack >= 0)){
                        return timePeriods[i-periodsBack];
                    } 
                } 
         }
         
         return null;
		
	}
}