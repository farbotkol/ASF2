public class CFM_UserManagement {

	// Parameters:
	// List<Id> userIds -- List of user IDs to get/generate contacts for
	// Returns:
	// A Map<Id,Id> of User IDs to Contact IDs
	// API Usage: 3 SOQL, 1 DML
	public static Map<Id, Id> getContactIdsForUsers(List<Id> userIds) {
		Map<Id, Id> userToContactIds = new Map<Id, Id>();

		List<Contact> contactsWithUsers = [Select Id, FirstName, LastName, Email, User__c from Contact where User__c in :userIds];

		List<Id> usersWithoutContacts = new List<Id>();

		for (Id userId : userIds) {
			for (Contact c : contactsWithUsers) {
				if (c.User__c == userId) {
					userToContactIds.put(userId, c.Id);
				}
			}

			if (!userToContactIds.containsKey(userId)) {
				usersWithoutContacts.add(userId);
			}
		}


		if (usersWithoutContacts.size() > 0) {
			Id aecomEmployeeRtId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('AECOM Employee').getRecordTypeId();
			Id aecomAccountRtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('AECOM Internal Account').getRecordTypeId();

			Account aecomAccount = [Select Id from Account where RecordTypeID = :aecomAccountRtId];

			List<Contact> newContacts = new List<Contact>();

			List<User> users = [Select Id, FirstName, LastName, Email, Department, Title, Phone, MobilePhone from User where Id in :usersWithoutContacts];

			for (User u : users) {
				Contact c = new Contact(
					FirstName=u.FirstName, 
					LastName=u.LastName, 
					Email = u.Email, 
					Department=u.Department,
					Title=u.Title,
					Phone=u.Phone,
					MobilePhone=u.MobilePhone,
					User__c=u.Id,
					RecordTypeID = aecomEmployeeRtId,
					AccountId = aecomAccount.Id);

				newContacts.add(c);
			}


			insert newContacts;

			for (Contact c : newContacts) {
				userToContactIds.put(c.User__c, c.Id);
			}
		}


		return userToContactIds;
	}
}