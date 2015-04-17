public without sharing class ECO_Utils_Alerts {
	private System.LoggingLevel debugLevel = LoggingLevel.INFO;
	
	public static List<PortalMessage__c> getPortalMessagesForUser (Id userId, Date theDate) {
		List<PortalMessage__c> returnMessages = [SELECT Id 
														, EndDate__c
														, LinkToRecord__c
														, LongDescription__c
														, StartDate__c
														, User__c
														, Name
														, RecordTypeId
														, RecordType.Name
														, Subject__c 
												FROM PortalMessage__c 
												WHERE EndDate__c >= :theDate
													AND StartDate__c <= :theDate
													AND User__c = :userId
													AND RecordType.Name = :ECO_Constants.PortalMessage_AlertRecordTypeName
												ORDER BY CreatedDate DESC];
		
		return returnMessages;
	}
	
	public static List<PortalMessage__c> getNewsFeedForPortal () {
		Date theDate = Date.today();
		
		return [SELECT Id
						, User__c
						, User__r.Name
						, Subject__c
						, StartDate__c
						, LongDescription__c
						, LinkToRecord__c
						, FullImageUrl__c
						, EndDate__c
				FROM PortalMessage__c
				WHERE RecordType.Name = :ECO_Constants.PortalMessage_FeedItemRecordTypeName
					AND (EndDate__c >= :theDate OR EndDate__c = null)
					AND StartDate__c <= :theDate
				ORDER BY StartDate__c DESC, CreatedDate DESC];
	}
	
	public static List<PortalMessage__c> getPortalMessagesForUser (Id userId) {
		return getPortalMessagesForUser(userId, Date.today());
	}
	
	public static List<PortalMessage__c> getTickerMessages (Date theDate) {
		List<PortalMessage__c> returnMessages = [SELECT Id 
														, EndDate__c
														, LinkToRecord__c
														, LongDescription__c
														, StartDate__c
														, User__c
														, Name
														, RecordTypeId
														, RecordType.Name
														, Subject__c 
												FROM PortalMessage__c 
												WHERE EndDate__c >= :theDate
													AND StartDate__c <= :theDate
													AND RecordType.Name = :ECO_Constants.PortalMessage_NewsTickerRecordTypeName
												ORDER BY CreatedDate DESC];
		
		return returnMessages;
	}
	
	public static List<PortalMessage__c> getTickerMessages () {
		return getTickerMessages(Date.today());
	}
}