public without sharing class ECO_Utils_Date {
	
	private static Map<Integer, String> monthNameMap;
	
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
}