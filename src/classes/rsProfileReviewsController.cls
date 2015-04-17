public with sharing class rsProfileReviewsController {

	public String ProfileReviewViewType {get; set;}
	
	public String SortDir {get; set;}
	public String SortVal {get; set;}

	private List<SelectOption> mProfileReviewView;
	private List<rs_Profile_Part__c> mReviewProfiles;
	private List<rsPRTeamEmployee> mReviewProjects;
	private Boolean mShowAssignee;

	public User dummyUser {get; set;} //Used for input fields formatting on datetime start field 
	public User dummyUser2 {get; set;} //Used for input fields formatting on datetime stop field
	public String SearchLastName {get; set;}
	public String SearchFirstName {get; set;}
	public String SearchGeography {get; set;}
	public String SearchCountry {get; set;}
	public String SearchAssignee {get; set;}

	public rsProfileReviewsController() {
		dummyUser = new User();
		dummyUser2 = new User();
		SortDir = 'desc';
		SortVal = 'Date_Time_Sent_for_Review__c';
		ProfileReviewViewType = REV_ASSIGNEDTOME;
	}

	public List<SelectOption> getprofileReviewView() {
		mProfileReviewView = new List<SelectOption>();
	    mProfileReviewView.add(new SelectOption(REV_UN_AMERICAS, REV_UNASSIGNED + ' - ' + REV_UN_AMERICAS));
	    mProfileReviewView.add(new SelectOption(REV_UN_AMERICAS_CS, REV_UNASSIGNED + ' - ' + REV_UN_AMERICAS_CS));
	    mProfileReviewView.add(new SelectOption(REV_UN_APAC, REV_UNASSIGNED + ' - ' + REV_UN_APAC));
	    mProfileReviewView.add(new SelectOption(REV_UN_CORPORATE, REV_UNASSIGNED + ' - ' + REV_UN_CORPORATE));
	    mProfileReviewView.add(new SelectOption(REV_UN_EMEA, REV_UNASSIGNED + ' - ' + REV_UN_EMEA));
	    mProfileReviewView.add(new SelectOption(REV_UN_GLOBAL_IT, REV_UNASSIGNED + ' - ' + REV_UN_GLOBAL_IT));
	    mProfileReviewView.add(new SelectOption(REV_ASSIGNED, REV_ASSIGNED));
	    mProfileReviewView.add(new SelectOption(REV_ASSIGNEDTOME, REV_ASSIGNEDTOME));
	    mProfileReviewView.add(new SelectOption(REV_COMPLETED, REV_COMPLETED));
	return mProfileReviewView;
	}

	public List<rs_Profile_Part__c> getReviewProfiles() {
		if (ProfileReviewViewType == REV_UN_AMERICAS || ProfileReviewViewType == REV_UN_AMERICAS_CS
			|| ProfileReviewViewType == REV_UN_APAC || ProfileReviewViewType == REV_UN_CORPORATE || ProfileReviewViewType == REV_UN_EMEA|| 
			ProfileReviewViewType == REV_UN_GLOBAL_IT) {
			mReviewProfiles = rsProfilePart.find.reviewUnassigned(dummyUser.Date_Time_Sent_for_Review__c, dummyUser2.Date_Time_Sent_for_Review__c, SearchLastName, SearchFirstName, SearchGeography, SearchCountry, SearchAssignee, ProfileReviewViewType);
		} 
		else if (ProfileReviewViewType == REV_ASSIGNED) {
			mReviewProfiles = rsProfilePart.find.reviewAssigned(dummyUser.Date_Time_Sent_for_Review__c, dummyUser2.Date_Time_Sent_for_Review__c, SearchLastName, SearchFirstName, SearchGeography, SearchCountry, SearchAssignee);
		} else if (ProfileReviewViewType == REV_COMPLETED) {
			mReviewProfiles = rsProfilePart.find.reviewCompleted(dummyUser.Date_Time_Sent_for_Review__c, dummyUser2.Date_Time_Sent_for_Review__c, SearchLastName, SearchFirstName, SearchGeography, SearchCountry, SearchAssignee);
		} else {
			ProfileReviewViewType = REV_ASSIGNEDTOME;
			mReviewProfiles = rsProfilePart.find.reviewAssignedToMe(UserInfo.getUserId(),dummyUser.Date_Time_Sent_for_Review__c, dummyUser2.Date_Time_Sent_for_Review__c, SearchLastName, SearchFirstName, SearchGeography, SearchCountry, SearchAssignee);
		}
		return mReviewProfiles;
	}

	public List<rsPRTeamEmployee> getReviewProjects() {
		if (ProfileReviewViewType == REV_UN_AMERICAS || ProfileReviewViewType == REV_UN_AMERICAS_CS
			|| ProfileReviewViewType == REV_UN_APAC || ProfileReviewViewType == REV_UN_CORPORATE || ProfileReviewViewType == REV_UN_EMEA|| 
			ProfileReviewViewType == REV_UN_GLOBAL_IT) {
			mReviewProjects = rsPRTeamEmployee.find.reviewUnassigned(dummyUser.Date_Time_Sent_for_Review__c, dummyUser2.Date_Time_Sent_for_Review__c, SearchLastName, SearchFirstName, SearchGeography, SearchCountry, SearchAssignee, ProfileReviewViewType);
		} else if (ProfileReviewViewType == REV_ASSIGNED) {
			mReviewProjects = rsPRTeamEmployee.find.reviewAssigned(dummyUser.Date_Time_Sent_for_Review__c, dummyUser2.Date_Time_Sent_for_Review__c, SearchLastName, SearchFirstName, SearchGeography, SearchCountry, SearchAssignee);
		} else if (ProfileReviewViewType == REV_COMPLETED) {
			mReviewProjects = rsPRTeamEmployee.find.reviewCompleted(dummyUser.Date_Time_Sent_for_Review__c, dummyUser2.Date_Time_Sent_for_Review__c, SearchLastName, SearchFirstName, SearchGeography, SearchCountry, SearchAssignee);
		} else {
			ProfileReviewViewType = REV_ASSIGNEDTOME;
			mReviewProjects = rsPRTeamEmployee.find.reviewAssignedToMe(UserInfo.getUserId(),dummyUser.Date_Time_Sent_for_Review__c, dummyUser2.Date_Time_Sent_for_Review__c, SearchLastName, SearchFirstName, SearchGeography, SearchCountry, SearchAssignee);
		}
		return mReviewProjects;
	}
	public Boolean getShowAssignee() {
		mShowAssignee = ProfileReviewViewType == REV_ASSIGNED;
		return mShowAssignee;
	}

	public PageReference resetSearch() {
		SearchLastName = null;
		SearchFirstName = null;
		SearchGeography = null;
		SearchCountry = null;
		SearchAssignee = null;
		dummyUser.Date_Time_Sent_for_Review__c = null;
		dummyUser2.Date_Time_Sent_for_Review__c = null;
		return null;
	}

	public static final String REV_UNASSIGNED = Label.Unassigned_Profiles;
   	public static final String REV_UN_AMERICAS = Label.Unassigned_Profiles_Americas;
	public static final String REV_UN_AMERICAS_CS = Label.Unassigned_Profiles_Americas_CS;
	public static final String REV_UN_APAC = Label.Unassigned_Profiles_APAC;
	public static final String REV_UN_CORPORATE = Label.Unassigned_Profiles_Corporate;
	public static final String REV_UN_EMEA = Label.Unassigned_Profiles_EMEA;
	public static final String REV_UN_GLOBAL_IT = Label.Unassigned_Profiles_Global_IT;

    public static final String REV_ASSIGNED = Label.Assigned_Profiles;
    public static final String REV_ASSIGNEDTOME = Label.Assigned_to_Me;
    public static final String REV_COMPLETED = Label.Completed_Profiles;


}