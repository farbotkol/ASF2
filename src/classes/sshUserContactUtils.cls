/*************************************************************************
*
* PURPOSE: Util class containing methods used by User and Contact related
* triggers
*
* CREATED: 2014 Ethos Solutions - www.ethos.com
* AUTHOR: Kyle Johnson
***************************************************************************/
global class sshUserContactUtils {

    static final String UNKNOWN = 'UNKNOWN';

    /**
    * @Description This method will update the "copy" Contact records for the associated User records changes. Since this is called from a trigger
    *                 on a setup object (User) the method must be a future method.
    * @param userIdList - Set list of user Id's that were changed.
    */    
    public static void updateContactUsers(Set<ID> userIdList)
    {
        if(System.isFuture() || System.isBatch() || System.isScheduled()){
            doUpdateContactUsers(userIdList);
        }else{
            doUpdateContactUsersFuture(userIdList);   
        }
    }

    //for executing the User -> Contact update if we are already in the future context
    private static void doUpdateContactUsers(Set<Id> userIdList){
        Map<String, User> userEmailMap = new Map<String, User>();
        for (User user : [select Email, FirstName, LastName, Department, Title, Phone, MobilePhone, LanguageLocaleKey, Shared_Services_Is_Executive__c FROM User where Id IN :userIdList AND IsActive = true]) 
        {
            userEmailMap.put(user.Id, User);
        }

        List<Contact> contactList = [select User__c from Contact where User__c in :userEmailMap.keySet()];
        if(!contactList.isEmpty())
        {

            for(Contact contact : contactList)
            {
                if(userEmailMap.keySet().contains(contact.User__c))
                {
                    User updateUser = userEmailMap.get(contact.User__c);
                    contact.FirstName = updateUser.FirstName;
                    contact.LastName = updateUser.LastName;
                    contact.Email = (updateUser.Email).toLowerCase();
                    contact.Department = updateUser.Department;
                    contact.Title = updateUser.Title;
                    contact.Phone = updateUser.Phone;
                    contact.MobilePhone = updateUser.MobilePhone;
                    contact.SS_Language__c = getLanguageByLocaleKey(updateUser.LanguageLocaleKey); 
                    contact.RecordTypeID        = getRecordTypeIdByName(RT_NAME_EMPLOYEE);
                    contact.Shared_Services_Is_Executive__c = updateUser.Shared_Services_Is_Executive__c;
                }
            }

            update contactList;
        }
    }

    //for executing the User -> Contact update if not already in future context
    @future
    private static void doUpdateContactUsersFuture(Set<Id> userIdList){
        doUpdateContactUsers(userIdList);
    }

    // get set of user ids that already have an associated contact record
    public static void loadUserIdsWithContact(Set<String> emailAddresses, Set<Id> userIdsWithContact, List<Contact> contactList){
        List<User> userList = [select Id, Email from User where Email in :emailAddresses AND IsActive = true];
        contactList = [select Id, Email from Contact where Email in :emailAddresses];

        Map<String, Id> userEmails = new Map<String, Id>();

        if(!userList.isEmpty() && !contactList.isEmpty()){

            for(User user : userList){
                if(!userEmails.keySet().contains( (user.Email).toLowerCase() )){
                    userEmails.put( (user.Email).toLowerCase(), user.Id);
                }
            }

            for(Contact contact : contactList){
                if(userEmails.keySet().contains( (contact.Email).toLowerCase() )){
                    userIdsWithContact.add(userEmails.get( (contact.Email).toLowerCase() ));
                }
            }
        }
    }

    public static Id getRecordTypeIdByName(String name){

        Id rtId = null;
        List<RecordType> recordTypes = [select Id from RecordType where Name = :name];

        if(!recordTypes.isEmpty()) rtId = recordTypes[0].Id;

        return rtId;
    }

    //pass in a list of emails and return a list of emails that do have a contact
    public static Set<String> getEmailsWithContact(Set<String> emails){
        List<Contact> contacts = [select Email from Contact where Email in :emails];
        Set<String> emailsWithContact = new Set<String>();
        if(!contacts.isEmpty()){
            for(Contact contact : contacts){
                if(emails.contains( (contact.Email).toLowerCase() )){
                    emailsWithContact.add( (contact.Email).toLowerCase() );
                }
            }
        }

        return emailsWithContact;
    }

    //get set of internal user email addresses based on list of email addresses
    //this is used to see which addresses in the email to case list are internal vs vendor
    public static Set<String> getUserEmailsByEmail(Set<String> emails){
        List<User> users = [select Email from User where Email in :emails AND IsActive = true];
        Set<String> userEmails = new Set<String>();
        for(User user : users) userEmails.add( (user.Email).toLowerCase() );

        return userEmails;
    }

    public static String getLanguageByLocaleKey(String localeKey){
        Map<String,String> keyMapping = new Map<String,String>{
            'en_US' => 'English',
            'fr' => 'French'        
        };
        String language = 'English';
        if(keyMapping.keySet().contains(localeKey)){
            language = keyMapping.get(localeKey);
        }

        return language;
    }

    //accept list of User records that have existing Contact records
    //then check to make sure that the emails match. Update if not.
    public static void updateContactEmails(Set<String> emails, Set<Id> usersWithContact, List<Contact> contactList){
        List<User> users = [select Id, Email from User where Email in :emails AND IsActive = true];
        List<Contact> contacts = [select User__c, Email from Contact where User__c in :users];
        Map<Id, Contact> contactRefs = new Map<Id, Contact>();
        if(!contacts.isEmpty()){            
            for(Contact ct : contacts) contactRefs.put(ct.User__c, ct);
            for(User user : users){
                if(contactRefs.keySet().contains(user.Id)){  
                    usersWithContact.add(user.Id);                  
                    if( (user.Email).toLowerCase() != (contactRefs.get(user.Id).Email).toLowerCase() ){
                        Contact tempCt = contactRefs.get(user.Id);
                        tempCt.Email = (user.Email).toLowerCase();
                        contactList.add(tempCt);
                    }
                }
            }
            if(!contactList.isEmpty()) update contactList;
        }
    }

    //method for parsing a SuppliedName into Contact from Case
    public static Contact parseContact(String nameString){        
        String [] nameParts;
        String spaceNormalizedNameString;
        String firstName;
        String lastName;

        if(String.isNotBlank(nameString)){

            spaceNormalizedNameString = nameString.normalizeSpace();
            Boolean hasCommas = false;
            //contains commas, split on that first
            if(nameString.contains(',')){
                hasCommas = true;
                nameParts = spaceNormalizedNameString.split(','); //do the split into array
            }else if(spaceNormalizedNameString.containsWhitespace()){
                nameParts = spaceNormalizedNameString.split(' '); //split on space
            }

            if(nameParts == null){
                if(String.isNotBlank(spaceNormalizedNameString)){
                    firstName = spaceNormalizedNameString;
                }else{
                    firstName = UNKNOWN;
                }
                lastName = UNKNOWN; //put unknown since we don't know last name
            }else if(nameParts.size() == 1){ //probably just a first name or first (space) last
                firstName = nameParts[0];
                lastName = UNKNOWN; //put unknown since we don't know last name
            }else if(nameParts.size() == 2){

                lastName = hasCommas ? nameParts[0] : nameParts[1];
                firstName = hasCommas ? nameParts[1] : nameParts[0];

            }else if(nameParts.size() > 2){
                if(hasCommas){//last name is 0th, append additional positions together for FirstName
                    lastName = nameParts[0];
                    String tmpStr;
                    for(String namePart : nameParts){
                        if(namePart != lastName){
                            if(tmpStr == null){
                                tmpStr = namePart;
                            }else{
                                tmpStr += (' '+namePart);
                            }
                        }
                    }
                    firstName = tmpStr;
                }else{//first name is 0th, append additional positions together for LastName
                    firstName = nameParts[0] + ' ' + nameParts[1]; //>3 means they probably have a middle name/initial listed
                    String tmpStr;
                    for(String namePart : nameParts){
                        if(!firstName.contains(namePart)){
                            if(tmpStr == null){
                                tmpStr = namePart;
                            }else{
                                tmpStr += (' '+namePart);
                            }
                        }
                    }
                    lastName = tmpStr;
                }
            }

        }

        Contact tempContact = new Contact();   
        tempContact.FirstName = String.isNotBlank(firstName) ? firstName : UNKNOWN;
        tempContact.LastName = String.isNotBlank(lastName) ? lastName : UNKNOWN;
        tempContact.Case_Web_Name__c = String.isBlank(spaceNormalizedNameString) ? null : spaceNormalizedNameString;

        if(tempContact.FirstName != null){
            tempContact.FirstName = tempContact.FirstName.abbreviate(40);
        }

        if(tempContact.LastName != null){
            tempContact.LastName = tempContact.LastName.abbreviate(80);
        }

        if(tempContact.Case_Web_Name__c != null){
            tempContact.Case_Web_Name__c = tempContact.Case_Web_Name__c.abbreviate(255);
        }

        return tempContact;
    }

    public static final String RT_NAME_EMPLOYEE = 'AECOM Employee';
    public static final String RT_NAME_VENDOR = 'Vendor';

}