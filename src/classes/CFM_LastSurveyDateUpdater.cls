public without sharing class CFM_LastSurveyDateUpdater {
    public static void updateLastSurveyDates(List<CFM_SurveyBatchProject> batchProjects) {
        Map<Id, Contact>    contacts = new Map<Id, Contact>();
        Map<Id, Project__c> projects = new Map<Id, Project__c>();
        Map<Id, Account>    accounts = new Map<Id, Account>();

        //---Declare outside loop for performance
        Date today = Date.today();
        Contact c;
        Project__c p;
        Account a;
        for (CFM_SurveyBatchProject row : batchProjects) { 
<<<<<<< HEAD
            c = new Contact();
            c.Id = row.getContactId();
            c.CFM_Last_Survey_Date_Sent__c = today;
            contacts.put(c.Id, c);

            p = new Project__c();
            p.Id = row.getProjectId();
            p.CFM_Last_Survey_Date__c = today;
            projects.put(p.Id, p);

            a = new Account();
            a.Id = row.getAccountId();
            a.CFM_Last_Survey_Date__c = today;
            accounts.put(a.Id, a);
=======
            if (!String.isBlank(row.getContactId())) {
                c = new Contact();
                c.Id = row.getContactId();
                c.CFM_Last_Survey_Date_Sent__c = today;
                contacts.put(c.Id, c);
            }
            
            if (!String.isBlank(row.getProjectId())) {
                p = new Project__c();
                p.Id = row.getProjectId();
                p.CFM_Last_Survey_Date__c = today;
                projects.put(p.Id, p);
            }
            
            if (!String.isBlank(row.getAccountId())) {
                a = new Account();
                a.Id = row.getAccountId();
                a.CFM_Last_Survey_Date__c = today;
                accounts.put(a.Id, a);
            }
>>>>>>> INT
        }

        List<sObject> updateList = new List<sObject>();
        updateList.addAll((List<sObject>)contacts.values());
        updateList.addAll((List<sObject>)projects.values());
        updateList.addAll((List<sObject>)accounts.values());

        if (!updateList.isEmpty()) {
            update updateList;
        }
    }
}