public class CFM_StringUtil {

	public static String quote(String stringToQuote) {
		return '\'' + String.escapeSingleQuotes(stringToQuote) + '\'';
	}

	public static Boolean isEmpty(String str) {
		return str == null || str.length() == 0 || str.trim().length() == 0;
	}

	public static String parseAndCleanMultiVal(String inputStr) {
        String[] vals;
 
        if (inputStr.contains(',')) vals = inputStr.split(',');
        else vals = inputStr.split(';');

        for (Integer i = 0; i < vals.size(); i++) {
            vals[i] = vals[i].trim();
        }

        return String.join(vals, ';');
    }

    // This method takes in a date string in either MM/DD/YYYY or YYYY-MM-DD and returns a string that is usable as a soql date literal (e.g. 2015-07-08)
	// Throws: InvalidDateFormatException if the input is in an invalid format
	public static String convertDateStringToSoqlFormat(String sVal) {
		Date dateValue = getDateFromString(sVal);
		return DateTime.newInstance(dateValue.year(), dateValue.month(), dateValue.day()).format('yyyy-MM-dd'); // Must convert to DateTime first as Date does not have format(String)
	}

	// This method takes in a date in either MM/DD/YYYY or YYYY-MM-DD and returns a date object.
	// Throws: InvalidDateFormatException if the input is in an invalid format
	public static Date getDateFromString(String sVal) {
		Date result;

		if (sVal == null) throw new InvalidDateFormatException();

		sVal = sVal.trim();

		try {
			result = Date.parse(sVal); // DateTime.parse checks for MM/DD/YYYY, or whatever the user's local format is
		}
		catch (Exception e) { } // Non-MM/DD/YYYY format

		if (result == null) {
			try {
				result = Date.valueOf(sVal); // DateTime.valueOf checks for YYYY-MM-DD
			} 
			catch (Exception e) {
				// We've exhausted our format options, so an invalid format was passed in.
				throw new InvalidDateFormatException();
			}
		}

		return result;
	}


	public class InvalidDateFormatException extends Exception { } 
}