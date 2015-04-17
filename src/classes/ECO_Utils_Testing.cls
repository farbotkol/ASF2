public without sharing class ECO_Utils_Testing {
	
	public static User createTestUser (String profileName) {

		Id profileId = ECO_Utils_Meta.getProfileId(profileName);
		
		Integer randomNumber = Integer.valueOf(Math.random()*1000);
		
		User u = new User();
		u.FirstName = randomNumber + 'tuser';
		u.LastName = randomNumber + 'tuser';
	    u.Email = randomNumber + 'tuser' + '.' +randomNumber + 'tuser' + '@davislangdon.co.nz';
	    u.Username =  randomNumber + 'tuser' + '.' +randomNumber + 'tuser' + '@davislangdon.co.nz';
	    u.CommunityNickname = randomNumber + 'tuser';
	    u.Alias = randomNumber + 'tuser';
	    u.TimeZoneSidKey = 'America/Los_Angeles';
	    u.LocaleSidKey = 'en_US';
	    u.EmailEncodingKey = 'ISO-8859-1';
	    u.ProfileId = profileId;
	    u.LanguageLocaleKey = 'en_US';
	    u.ECO_BusinessLine__c = 'Construction';
	    u.ECO_Geography__c = 'United States';
	    u.ECO_Region__c = '3';
    	
    	return u;
    }
}