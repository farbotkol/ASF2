// --------------------------------------------------------------------------------
// COMPONENT: Utility
// CLASS: rsStringUtil
// PURPOSE: Utility methods for String operations
// CREATED: 03/26/13 Ethos Solutions - www.ethos.com
// Author: Various
//--------------------------------------------------------------------------------
global class rsStringUtil {
	
	public static Boolean isNullOrEmpty(String value) {
        return value == null || value == '' || value.equalsIgnoreCase('null');
    }

    public static String cleanFieldName(String dirtyString,String findChar) {
		String cleanString = dirtyString.substring(dirtyString.indexOf(findChar)+1,dirtyString.length());
		return cleanString;
	}

	public static String quote(String stringToQuote)
	{
		return '\'' + String.escapeSingleQuotes(stringToQuote) + '\'';
	}

	public static String likeQueryQuote(String stringToQuote)
	{
		return '\'%' + String.escapeSingleQuotes(stringToQuote) + '%\'';
	}

	public static String toTitleCase(String phrase) {
	  	String titlePhrase = '';
	 
	 	if(phrase != null && phrase.length() > 0) {
	    	String[] splitPhrase = phrase.trim().normalizeSpace().split(' ');
	             
	    	for(integer i = 0; i < splitPhrase.size(); i++){
        		titlePhrase += (splitPhrase[i].substring(0,1).toUpperCase())+(splitPhrase[i].substring(1).toLowerCase())+' ';
	    	}
	  	}
	    return titlePhrase.trim();
	}
	public static String listJoin(List<String> stringToJoin) {
		return '(\'' + String.join(stringToJoin, '\',\'') + '\')';
	}

}