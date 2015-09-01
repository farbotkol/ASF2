public class CFM_SurveyCase extends CFM_BaseModel {
    public static Finder find = new Finder('CFM_Survey_Case__c');

    public static final String SEVERITYLEVEL_1 = 'Severity Level 1';
    public static final String SEVERITYLEVEL_2 = 'Severity Level 2';
    public static final String SEVERITYLEVEL_3 = 'Severity Level 3';
    public static final String SEVERITYLEVEL_4 = 'Severity Level 4';

    public static final String ESCALATION_1 = 'Level 1';
    public static final String ESCALATION_2 = 'Level 2';
    public static final String ESCALATION_3 = 'Level 3';

    public static final String STATUS_OPEN = 'Open';
    public static final String STATUS_FUO = 'FUO - In Progress';
    public static final String STATUS_EO = 'EO - In Progress';
    public static final String STATUS_PM = 'PM - In Progress';
    public static final String STATUS_ES = 'ES/Client Care - In Progress';
    public static final String STATUS_CLOSED = 'Closed';

    public CFM_SurveyCase(CFM_Survey_Case__c surveyCase) {
        super(surveyCase);
    }


    public static void handleSurveyResponseInsert(List<CFM_Survey_Response__c> newResponses, Map<Id, CFM_Survey_Response__c> newResponseMap) {
        List<CFM_Survey_Case__c> newCases = new List<CFM_Survey_Case__c>();

        Set<Id> projectIds = new Set<Id>();

        for (CFM_Survey_Response__c newResponse : newResponses) {
            if (newResponse.Project__c != null) projectIds.add(newResponse.Project__c);
        }

        //CFM_Department__r.Operating_Group__c, 
        //CFM_Department__r.Lead_District__c

        // Get the project area/operating group/business line information
        Map<Id, Project__c> projects = new Map<Id, Project__c>([Select Id, 
                                                                Oracle_Project_Manager_lookup__c, 
                                                                Oracle_Project_Director__c, 
                                                                OracleDepartment__c
                                                                from Project__c where Id in :projectIds]);

        Set<String> departmentNames = new Set<String>();

        for (Project__c project : projects.values()) {
            if (!String.isBlank(project.OracleDepartment__c)) departmentNames.add(project.OracleDepartment__c);
        }

        List<AECOM_Primary_Department__c> departments = [Select Id, Name, 
                                                            Business_Line_Lookup__c, 
                                                            Operating_Group__c, 
                                                            Lead_District__c,
                                                            Quality_Manager__c,
                                                            Risk_Manager__c
                                                            from AECOM_Primary_Department__c
                                                            where Name in :departmentNames];

        Map<String, AECOM_Primary_Department__c> departmentNameToDepartment = new Map<String, AECOM_Primary_Department__c>();
        for (AECOM_Primary_Department__c row : departments) {
            departmentNameToDepartment.put(row.Name, row);
        }

        Map<Id, AECOM_Primary_Department__c> departmentIdToDepartment = new Map<Id, AECOM_Primary_Department__c>(departments);

        for (CFM_Survey_Response__c newResponse : newResponses) {

            Boolean shouldCreateCase = false;
            String severityLevel = null;
            String severityType = null;

            if (newResponse.Likelihood_to_Recommend__c != null && newResponse.Likelihood_to_Recommend__c <= 6) {
                // Client is a detractor
                shouldCreateCase = true;
                severityLevel = SEVERITYLEVEL_1;
                severityType = 'Detractor';
            }
            else if (newResponse.Satisfaction_Health_Safety__c != null && newResponse.Satisfaction_Health_Safety__c <= 6) {
                // Health and safety problem    
                shouldCreateCase = true;
                severityLevel = SEVERITYLEVEL_2;
                severityType = 'Non-Detractor & H&S Issue';
            }
            else if (newResponse.Request_for_Contact__c != null && newResponse.Request_for_Contact__c.startsWithIgnoreCase('yes')) {
                // Client requested contact
                shouldCreateCase = true;
                severityLevel = SEVERITYLEVEL_3;
                severityType = 'Non-Detractor & Contact Request';
            }
            else if (newResponse.Likelihood_to_Recommend__c != null && newResponse.Likelihood_to_Recommend__c >= 9) {
                // Client is a promoter
                shouldCreateCase = true;
                severityLevel = SEVERITYLEVEL_4;
                severityType =  'Promoter, No H&S, & No Contact';
            }

            if (shouldCreateCase) {
                CFM_Survey_Case__c newCase = new CFM_Survey_Case__c();
                newCase.Customer_Survey_Response__c = newResponse.Id;
                newCase.Survey_Batch_Project__c = newResponse.Survey_Batch_Project__c;
                newCase.Date_Time_Opened__c = DateTime.now();
                newCase.Escalation__c = ESCALATION_1;
                newCase.Status__c = 'Open';
                newCase.Survey_Received_Date__c = Date.today();
                newCase.Severity_Level__c = severityLevel;
                newCase.Severity_Type__c = severityType;
                newCases.add(newCase);
            }
        }

        if (newCases.size() > 0) {
            Map<Id, CFM_SurveyCaseHierarchy> routingMap = new Map<Id, CFM_SurveyCaseHierarchy>();

            Map<String, CFM_SurveyCaseHierarchy> caseRoutings = CFM_SurveyCaseHierarchy.find.forDepartments(departments);

            for (CFM_Survey_Case__c newCase : newCases) {
                CFM_Survey_Response__c response = newResponseMap.get(newCase.Customer_Survey_Response__c);
                if (response.Project__c != null) {
                    Project__c project = projects.get(response.Project__c);

                    if (project.OracleDepartment__c != null && departmentNameToDepartment.containsKey(project.OracleDepartment__c)) {
                        AECOM_Primary_Department__c department = departmentNameToDepartment.get(project.OracleDepartment__c);
                        newCase.Department__c = department.Id;
                    }

                    CFM_SurveyCaseHierarchy routing = CFM_SurveyCaseHierarchy.findRoutingForProject(caseRoutings, departmentNameToDepartment, project);
                    if (routing != null) {
                        routingMap.put(routing.getId(), routing);
                        newCase.Survey_Case_Hierarchy__c = routing.obj.Id;
                        newCase.Assignee__c = routing.obj.Step_1_Assign_To__c;                        
                        newCase.OwnerId = routing.obj.Step_1_Assign_To__c;  
                        newCase.Last_Reminder_Date__c = DateTime.now();
                        newCase.Next_Reminder_Date__c = addDaysSkippingWeekends(DateTime.now(), 2);
                        newCase.Next_Escalation_Date__c = addDaysSkippingWeekends(DateTime.now(), (Integer)routing.obj.Step_1_Days__c);
                    }
                }
            }


            insert newCases;

            sendEmailsForCases(newCases, routingMap, departmentIdToDepartment);
        }

        
    }

    private static void sendEmailsForCases(List<CFM_Survey_Case__c> newCases, Map<Id, CFM_SurveyCaseHierarchy> routingMap, Map<Id, AECOM_Primary_Department__c> departmentIdToDepartment) {

        List<Id> usersNeedingNotification = new List<Id>();

        Map<String, List<CFM_Survey_Case__c>> emailTemplateToCases = new Map<String, List<CFM_Survey_Case__c>>();
        List<CFM_Survey_Case__c> lowReccommendNotifyCases = new List<CFM_Survey_Case__c>();

        String lowReccomendEmailTemplateName = 'Initial_E_mail_for_Low_Recommend_Score';

        for (CFM_Survey_Case__c newCase : newCases) {
            if (newCase.Survey_Case_Hierarchy__c != null && routingMap.containsKey(newCase.Survey_Case_Hierarchy__c)) {
                CFM_SurveyCaseHierarchy routing = routingMap.get(newCase.Survey_Case_Hierarchy__c);

                if (routing.obj.Step_1_Assign_To__c != null) {
                
                    String emailTemplateName = routing.getStep1EmailTemplate();

                    if (emailTemplateName != null) {
                        if (!emailTemplateToCases.containsKey(emailTemplateName)) {
                            emailTemplateToCases.put(emailTemplateName, new List<CFM_Survey_Case__c>());
                        }

                        usersNeedingNotification.add(routing.obj.Step_1_Assign_To__c);

                        emailTemplateToCases.get(emailTemplateName).add(newCase);
                    }
                }
            }

            if (newCase.Severity_Level__c == SEVERITYLEVEL_1 && newCase.Department__c != null && departmentIdToDepartment.containsKey(newCase.Department__c)) {
                // Send email to RRM, RQM
                
                AECOM_Primary_Department__c department = departmentIdToDepartment.get(newCase.Department__c);
                if (department.Quality_Manager__c != null)  usersNeedingNotification.add(department.Quality_Manager__c);
                if (department.Risk_Manager__c != null)     usersNeedingNotification.add(department.Risk_Manager__c);

               lowReccommendNotifyCases.add(newCase);
            }
        }

        Map<Id, Id> userIdsToContactIds = CFM_UserManagement.getContactIdsForUsers(usersNeedingNotification);

        Set<String> emailTemplatesNames = new Set<String>();
        emailTemplatesNames.addAll(emailTemplateToCases.keySet());
        emailTemplatesNames.add(lowReccomendEmailTemplateName);

        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        List<EmailTemplate> emailTemplates = [Select Id, DeveloperName from EmailTemplate where DeveloperName in :emailTemplatesNames];

        for (String emailTemplateName : emailTemplateToCases.keySet()) {
            EmailTemplate template = null;
            for (EmailTemplate row : emailTemplates) if (row.DeveloperName == emailTemplateName) template = row;

            if (template != null) {
                for (CFM_Survey_Case__c caseRow : emailTemplateToCases.get(emailTemplateName)) {
                    if (caseRow.Survey_Case_Hierarchy__c != null && routingMap.containsKey(caseRow.Survey_Case_Hierarchy__c)) {
                        CFM_SurveyCaseHierarchy routing = routingMap.get(caseRow.Survey_Case_Hierarchy__c);

                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        message.setTemplateId(template.Id);
                        message.setSaveAsActivity(false);
                        message.setTargetObjectId(userIdsToContactIds.get(routing.obj.Step_1_Assign_To__c));
                        message.setWhatId(caseRow.Id);
                        messages.add(message);
                    }
                }
            }

        }

        for (CFM_Survey_Case__c caseRow : lowReccommendNotifyCases) {
            EmailTemplate template = null;
            for (EmailTemplate row : emailTemplates) if (row.DeveloperName == lowReccomendEmailTemplateName) template = row;

            if (template != null) {
                List<Id> userIds = new List<Id>();

                AECOM_Primary_Department__c department = departmentIdToDepartment.get(caseRow.Department__c);
                if (department.Quality_Manager__c != null)  userIds.add(department.Quality_Manager__c);
                if (department.Risk_Manager__c != null)     userIds.add(department.Risk_Manager__c);

                for (Id userId : userIds) {
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    message.setTemplateId(template.Id);
                    message.setSaveAsActivity(false);
                    message.setTargetObjectId(userIdsToContactIds.get(userId));
                    message.setWhatId(caseRow.Id);
                    messages.add(message);
                }
                
            }
        }

        if (messages.size() > 0) {
            Messaging.sendEmail(messages);
        }
    }
 
    public class Finder extends CFM_BaseFinder {
        public Finder(String sObjectName) {
            super(sObjectName);
        }
    }

    public static DateTime addDaysSkippingWeekends(DateTime dt, Integer daysToAdd) {
        DateTime result = dt;

        Integer count = 0;
        while (count < daysToAdd) {
            result = result.addDays(1);
            if (!isWeekend(result)) count++;
        }

        return result;
    }

    public static Boolean isWeekend(DateTime dt) {
        String dayOfWeek = dt.format('EEEE');
        return dayOfWeek == 'Sunday' || dayOfWeek == 'Saturday';
    }
}