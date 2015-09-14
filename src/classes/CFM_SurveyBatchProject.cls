public with sharing class CFM_SurveyBatchProject extends CFM_BaseModel {
	public static Finder find = new Finder();

	public static final String STATUS_NEW = 'New';
	public static final String STATUS_PENDING_REVIEW = 'Pending PM Review';
	public static final String STATUS_REVIEWED = 'PM Reviewed';
	public static final String STATUS_PENDING_QSUBMIT = 'Pending Qualtrics Submittal';
	public static final String STATUS_SENT = 'Sent to Qualtrics';

    public static final String PM_STATUS_CONFIRM = 'Confirmed';
    public static final String PM_STATUS_REJECT  = 'Rejected';

	public CFM_Survey_Batch_Project__c obj { 
        get { 
            return (CFM_Survey_Batch_Project__c)mObj; 
        } 
    }

	public CFM_SurveyBatchProject(CFM_Survey_Batch_Project__c sObj) {
		super(sObj);
	}

    public String getSurveyBatchName() {
        return obj.Survey_Batch__r.Name;
    }

    public Id getContactId() {
        return obj.Project__r.CFM_Survey_Contact__c;
    }

    public Id getProjectId() {
        return obj.Project__c;
    }

    public Id getAccountId() {
        return obj.Project__r.Owner__c;
    }

    public Id getSurveyBatchId() {
        return obj.Survey_Batch__c;
    }
    public void setSurveyBatchId(Id surveyBatchId) {
        obj.Survey_Batch__c = surveyBatchId;
    }

    public String getOracleDepartment() {
        return obj.Project__r.OracleDepartment__c;
    }

    public Boolean getDoNotSurvey() {
        return obj.Project__r.CFM_Do_Not_Survey__c          //---Project
            || obj.Do_Not_Survey__c                         //---Formula field for contact
            || obj.Project__r.CFM_Account_Do_Not_Survey__c; //---Account
    }

    public Boolean getProjectHasContact() {
        return String.isNotBlank(obj.Survey_Contact__c);
    }

    public Boolean getIsProjectConfirmed() {
        return obj.PM_Status__c == PM_STATUS_CONFIRM;
    }

    
	public static List<CFM_SurveyBatchProject> decorate(List<CFM_Survey_Batch_Project__c> sList) {
		List<CFM_SurveyBatchProject> result = new List<CFM_SurveyBatchProject>();
		for (CFM_Survey_Batch_Project__c row : sList) result.add(new CFM_SurveyBatchProject(row));
		return result;
	}

    //---TODO - what is the exact criteria for determinig duplicates?
    public static List<CFM_SurveyBatchProject> removeDuplicatesAndDoNotSurvey(List<CFM_SurveyBatchProject> projects) {
        List<CFM_SurveyBatchProject> uniques = new List<CFM_SurveyBatchProject>();
        Map<String, CFM_SurveyBatchProject> projectsByAccountId = new Map<String, CFM_SurveyBatchProject>();
        
        //---Get unique batch projects using lookup to project
        for (CFM_SurveyBatchProject project : projects) {
            //---Make sure project was confirmed, project has contact selected,
            //---And none of the Do Not Survey flags are set
            Boolean shouldAdd = project.getIsProjectConfirmed() 
                             && project.getProjectHasContact()
                             && !project.getDoNotSurvey();
            if (shouldAdd) {
                projectsByAccountId.put(project.obj.Project__c, project);
            }
        }

        return projectsByAccountId.values();
    }

	public class Finder extends CFM_BaseFinder {
		public Finder() {
			super('CFM_Survey_Batch_Project__c');
		}

        public List<CFM_SurveyBatchProject> findProjectsPendingSubmit(Id surveyBatchId) {
            Set<String> newFields = new Set<String>();
            for (String newField : CFM_SurveyBatchProjectCSVGenerator.getAllFields()) {
                newFields.add(newField.toLowerCase());
            }
            newFields.add('project__r.cfm_account_do_not_survey__c');
            newFields.add('project__r.cfm_do_not_survey__c');
            newFields.add('project__r.oracledepartment__c');
            newFields.add('project__r.cfm_survey_contact__c');
            newFields.add('project__r.owner__c');
            addFields(newFields);

			String status = CFM_SurveyBatchProject.STATUS_PENDING_QSUBMIT;
			List<CFM_Survey_Batch_Project__c> result = Database.query(getSelect() + ' where Survey_Batch__c = :surveyBatchId and Status__c = :status ');
			return CFM_SurveyBatchProject.decorate(result);
		}

		public List<CFM_SurveyBatchProject> findConfirmedProjects(Id surveyBatchId) {
			List<CFM_Survey_Batch_Project__c> result = Database.query(getSelect() + ' where Survey_Batch__c = :surveyBatchId and PM_Status__c != null and PM_Status__c = \'Confirmed\' ');
			return CFM_SurveyBatchProject.decorate(result);
		}

		public List<CFM_SurveyBatchProject> findByPm(Id surveyBatchId, Id userId) {
			addField('project__r.name');
            addField('project__r.cfm_survey_contact__c');
			List<CFM_Survey_Batch_Project__c> result = Database.query(getSelect() + ' where Survey_Batch__c = :surveyBatchId and Project__r.Oracle_Project_Manager_lookup__c = :userId');
			return CFM_SurveyBatchProject.decorate(result);
		}

		public List<CFM_Survey_Batch_Project__c> findSurveyProjectsForNotification(Id surveyBatchId) {
			List<CFM_Survey_Batch_Project__c> surveyProjects = [Select 
								Id, 
								Project__r.Oracle_Project_Manager_lookup__c 
								from CFM_Survey_Batch_Project__c 
								where 
								Survey_Batch__c = :surveyBatchId
								and Status__c = :CFM_SurveyBatchProject.STATUS_NEW];
								
			return surveyProjects;
		}
	}
}