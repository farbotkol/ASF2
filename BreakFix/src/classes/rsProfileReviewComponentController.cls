public with sharing class rsProfileReviewComponentController {

    public List<rs_Profile_Part__c> Profiles {get; set;}
    public List<rsPRTeamEmployee> Projects {get; set;}
    public String ViewType {get; set;}
    public String sortDir {get; set;}
    public String sortVal {get; set;}

    private Map <Id,List<rs_Profile_Part__c>> mUserProfilePartMap;
    private Map <Id,List<rsPRTeamEmployee>> mUserProjectMap;

    private Map<Id,String> mRtMap;
    private Map<Id,User> mUserMap;
    //UserIds that only have profile parts or only have projects to review
    private Set<Id> mProfilePartsOnly;
    private Set<Id> mProfileProjectsOnly;

    private Boolean mShowStatus;
    private Boolean mShowCurrentAssignee;
    private Boolean mIsReassign;
    private Boolean mShowAssignAction;
    private Boolean mShowActions;
    private Boolean mShowAssignToMe;


    private Integer counter; // current offset of the searchResults
    private static final Integer RESULT_SIZE = 5; //number of rows shown in the result table

    private static final Map<Id,Schema.RecordTypeInfo> mProfilePartRTInfo;
    static {
        mProfilePartRTInfo = rs_Profile_Part__c.SObjectType.getDescribe().getRecordTypeInfosById();
    }
    private static final Map<Id,Schema.RecordTypeInfo> mPRTeamEmployeeRTInfo;
    static {
        mPRTeamEmployeeRTInfo = PR_Team_Employee__c.SObjectType.getDescribe().getRecordTypeInfosById();
    }
    public rsProfileReviewComponentController() {
        mUserMap = new Map<Id,User>();
        mRtMap = new Map<Id,String>();
        mProfilePartsOnly = new Set<Id>();
        mProfileProjectsOnly = new Set<Id>();
        counter = 0;
    }

    public Map<Id,String> getProfileRtMap() {
        for (rs_Profile_Part__c profile : Profiles){
            mRtMap.put(profile.Id,mProfilePartRTInfo.get(profile.RecordTypeId).getName());
        }
        for (rsPRTeamEmployee project : Projects) {
            mRtMap.put(project.getId(),mPRTeamEmployeeRTInfo.get(project.getRecordTypeId()).getName());
        }
        return mRtMap;
    }

    //List of users used in main apex repeat, is filtered by getViewResults() method for pagination
    public List<rsUserViewModel> getUserList() {
        List<User> tempUserList = getUserMap().values();
        List<rsUserViewModel> mUserList = new List<rsUserViewModel>();
        for (User tempUser : tempUserList) {
            mUserList.add(new rsUserViewModel(tempUser));
        }
        rsUserViewModel.SortField = sortVal;
        rsUserViewModel.SortOrder = sortDir;
        mUserList.sort();
        return mUserList;
    }

    public Map<Id,User> getUserMap() {
        mProfilePartsOnly = new Set<Id>();
        mProfileProjectsOnly = new Set<Id>();
        for (rs_Profile_Part__c profile : Profiles){
            mProfilePartsOnly.add((Id)profile.User__c);
        }

        for (rsPRTeamEmployee project : Projects) {
            mProfileProjectsOnly.add(project.getUser() );
        }

        Set<Id> userIdSet = new Set<Id>(mProfilePartsOnly);
        userIdSet.addAll(mProfileProjectsOnly);

        Set<Id> intersection = mProfilePartsOnly.clone();
        intersection.retainAll(mProfileProjectsOnly);
        mProfilePartsOnly.removeAll(intersection);
        mProfileProjectsOnly.removeAll(intersection);
        Set<String> fieldsSelect = new Set<String>{'Profile_Reviewer__c','Profile_Reviewer__r.Name','Name','FirstName','LastName','Manager.Name',
                                                    'Geography__c','Region__c','Country','Office__c','Email',
                                                    'Business_Line__c','Date_Time_Sent_For_Review__c', 'Is_profile_locked__c','Status__c'};
        mUserMap = rsProfile.find.byUserIdSetMinFields( userIdSet, fieldsSelect );

        return mUserMap;
    }

    //Builds map of key user with value being a list of all that users' profile parts
    public Map <Id,List<rs_Profile_Part__c>> getUserProfilePartMap() {
        getUserMap();
        mUserProfilePartMap = new Map <Id,List<rs_Profile_Part__c>>();
        for (rs_Profile_Part__c profile : Profiles){
            if (mUserProfilePartMap.containsKey(profile.User__c)){
                mUserProfilePartMap.get(profile.User__c).add(profile);
            } else {
                List<rs_Profile_Part__c> newUserList = new List<rs_Profile_Part__c>();
                newUserList.add(profile);
                mUserProfilePartMap.put(profile.User__c, newUserList);
            }
        }

        //add the users that are in the projects only list with null items
        for (Id userId : mProfileProjectsOnly) {
                List<rs_Profile_Part__c> newUserList = new List<rs_Profile_Part__c>();
                mUserProfilePartMap.put(userId, newUserList);
        }
        return mUserProfilePartMap;
    }

    //Builds map of key user with value being a list of all that users' projects
    public Map <Id,List<rsPRTeamEmployee>> getUserProjectMap() {
        getUserMap();
        mUserProjectMap = new Map <Id,List<rsPRTeamEmployee>>();
        for (rsPRTeamEmployee project : Projects){
            if (mUserProjectMap.containsKey(project.getUser())) {
                mUserProjectMap.get(project.getUser()).add(project);
            } else {
                List<rsPRTeamEmployee> newUserList = new List<rsPRTeamEmployee>();
                newUserList.add(project);
                mUserProjectMap.put(project.getUser(), newUserList);
            }
        }

        //add the users that are in the profile part only list with null items
        for (Id userId : mProfilePartsOnly) {
                List<rsPRTeamEmployee> newUserList = new List<rsPRTeamEmployee>();
                mUserProjectMap.put(userId, newUserList);
        }
        return mUserProjectMap;
    }


    public Boolean getShowStatus() {
        mShowStatus = (ViewType != rsProfileReviewsController.REV_COMPLETED);
        return mShowStatus;
    }
    public Boolean getShowCurrentAssignee() {
        mShowCurrentAssignee = (ViewType == rsProfileReviewsController.REV_ASSIGNED);
        return mShowCurrentAssignee;
    }
    public Boolean getIsReassign() {
        mIsReassign = (ViewType == rsProfileReviewsController.REV_ASSIGNED || ViewType == rsProfileReviewsController.REV_ASSIGNEDTOME);
        return mIsReassign;
    }
    public Boolean getShowAssignAction() {
        mShowAssignAction = (ViewType != rsProfileReviewsController.REV_COMPLETED);
        return mShowAssignAction;
    }
    public Boolean getShowActions(){
        mShowActions = (ViewType == rsProfileReviewsController.REV_ASSIGNEDTOME);
        return mShowActions;
    }
    public Boolean getShowAssignToMe() {
        mShowAssignToMe = (ViewType == rsProfileReviewsController.REV_UN_AMERICAS ||
                            ViewType == rsProfileReviewsController.REV_UN_AMERICAS_CS ||
                            ViewType == rsProfileReviewsController.REV_UN_APAC ||
                            ViewType == rsProfileReviewsController.REV_UN_CORPORATE ||
                            ViewType == rsProfileReviewsController.REV_UN_EMEA ||
                            ViewType == rsProfileReviewsController.REV_UN_GLOBAL_IT 
                            );
        return mShowAssignToMe;
    }

    public PageReference assign() {
        PageReference pr = null;
        pr = Page.rsAssignProfileReview;
        pr.getParameters().put('userId', ApexPages.currentPage().getParameters().get('userId') );
        pr.getParameters().put('type', ViewType);
        return pr;
    }

    public PageReference assignToMe() {
        String userId = ApexPages.currentPage().getParameters().get('userId');
        if( !Profile_Info__c.getInstance(UserInfo.getUserId()).Is_Content_Manager__c ) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Not_Content_Manager));
        } else if (userId == UserInfo.getUserId() ) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Cant_Review_Self));
        } else {
            User employee = mUserMap.get(userId);
            employee.Profile_Reviewer__c = UserInfo.getUserId();
            try{
                update employee;
            } catch (DmlException ex) {
                System.debug('!! Exception Assigning to self :' + ex);
                ApexPages.addMessages(ex);
            }
        }
        return null;
    }

    public PageReference viewProfile() {
        PageReference pr = null;
        pr = new PageReference('/' + ApexPages.currentPage().getParameters().get('userId') );
        return pr;
    }

    //A parameterized action used on commandLinks to perform actions on a collection of profile parts
    //ActionTypes available:
    // 'approve' - Will approve all of the profile parts that are in the user's profile part map & unlock profile & clear date/time when review started
    // 'startReview' - Will lock the profile and set profile part statuses to 'in review'
    // 'stopReview' - Opposite of startReview
    public PageReference updatePartsStatus() {
        String userId = ApexPages.currentPage().getParameters().get('userId');
        String actionType = ApexPages.currentPage().getParameters().get('actionType');
        User currUser = mUserMap.get(userId);
        List<rs_Profile_Part__c> userParts = mUserProfilePartMap.get( userId );
        List<rsPRTeamEmployee> userProjects = mUserProjectMap.get( userId );
        rsProfile profile = new rsProfile(currUser);

        if (actionType == 'approve') {
            rsApprovalUtil.approveProfile(profile, userParts, userProjects);
        } else if (actionType == 'startReview') {
            rsApprovalUtil.startReview(profile, userParts, userProjects);
        } else if (actionType == 'stopReview') { 
            rsApprovalUtil.stopReview(profile, userParts, userProjects);
        }
        return null;
    }

    public PageReference approvePart(){
        String userId = ApexPages.currentPage().getParameters().get('userId');
        String partId = ApexPages.currentPage().getParameters().get('partId');
        rsProfile profile = new rsProfile(mUserMap.get(userId));

        List<rs_Profile_Part__c> userParts = mUserProfilePartMap.get( userId );
        
        if(userParts != null) {
            for (rs_Profile_Part__c profilePart : userParts) {
                if(profilePart.Id == partId) {
                    rsApprovalUtil.approvePart(profilePart, profile);
                    break;
                }
            }
        }

        List<rsPRTeamEmployee> userProjects = mUserProjectMap.get( userId );
        
        if(userProjects != null) {
            for (rsPRTeamEmployee profileProject : userProjects) {  
                if(profileProject.getId() == partId) {
                    rsApprovalUtil.approveProjectPart(profileProject, profile);
                    break;
                }
            }
        }
        return null;
    }

    public PageReference navToPart() {
        String userId = ApexPages.currentPage().getParameters().get('userId');
        String partId = ApexPages.currentPage().getParameters().get('partId');
        String recordTypeName = ApexPages.currentPage().getParameters().get('recordTypeName');

        PageReference pr = new PageReference('/' + userId);

        //Find out what page we are taking them to
        if(recordTypeName.equalsIgnoreCase(rsProfilePart.RT_PERSONAL)) {
            pr.getParameters().put('tab', 'Personal');
        } else if(recordTypeName.equalsIgnoreCase(rsPRTeamEmployee.RT_AECOMPROJECT) || recordTypeName.equalsIgnoreCase(rsPRTeamEmployee.RT_NONAECOMPROJECT)) {
            pr.getParameters().put('tab', 'Projects');
            if(recordTypeName.equalsIgnoreCase(rsPRTeamEmployee.RT_AECOMPROJECT)) {
                pr.getParameters().put('tab.Projects.subtab', '0');
            } else if(recordTypeName.equalsIgnoreCase(rsPRTeamEmployee.RT_NONAECOMPROJECT)) {
                pr.getParameters().put('tab.Projects.subtab', '1');
            }
        } else if (recordTypeName.equalsIgnoreCase(rsProfilePart.RT_SF254) ||recordTypeName.equalsIgnoreCase(rsProfilePart.RT_SF330) ||
                    recordTypeName.equalsIgnoreCase(rsProfilePart.RT_AWARD) ||recordTypeName.equalsIgnoreCase(rsProfilePart.RT_CERTIFICATION) ||
                    recordTypeName.equalsIgnoreCase(rsProfilePart.RT_EDUCATION) ||recordTypeName.equalsIgnoreCase(rsProfilePart.RT_PROF_AFFILIATION) ||
                    recordTypeName.equalsIgnoreCase(rsProfilePart.RT_FILE) ||recordTypeName.equalsIgnoreCase(rsProfilePart.RT_LANGUAGES) ||
                    recordTypeName.equalsIgnoreCase(rsProfilePart.RT_PUBLICATION) ||recordTypeName.equalsIgnoreCase(rsProfilePart.RT_REGISTRATION) ||
                    recordTypeName.equalsIgnoreCase(rsProfilePart.RT_SKILL_INDEX) ||recordTypeName.equalsIgnoreCase(rsProfilePart.RT_TRAINING) ||
                    recordTypeName.equalsIgnoreCase(rsProfilePart.RT_TRANSLATIONS) ||recordTypeName.equalsIgnoreCase(rsProfilePart.RT_WORK_HISTORY) ||
                    recordTypeName.equalsIgnoreCase(rsProfilePart.RT_PERSONAL) || recordTypeName.equalsIgnoreCase(rsProfilePart.RT_REFERENCE)) {
            pr.getParameters().put('tab', 'Skills_and_Qualifications');
            if(recordTypeName.equalsIgnoreCase(rsProfilePart.RT_WORK_HISTORY)) {
                pr.getParameters().put('tab.Skills_and_Qualifications.subtab', '0');
            } else if (recordTypeName.equalsIgnoreCase(rsProfilePart.RT_LANGUAGES) || recordTypeName.equalsIgnoreCase(rsProfilePart.RT_TRANSLATIONS)) {
                pr.getParameters().put('tab.Skills_and_Qualifications.subtab', '1');
            } else if (recordTypeName.equalsIgnoreCase(rsProfilePart.RT_EDUCATION) ||
                        recordTypeName.equalsIgnoreCase(rsProfilePart.RT_SF254) ||
                        recordTypeName.equalsIgnoreCase(rsProfilePart.RT_SF330) ||
                        recordTypeName.equalsIgnoreCase(rsProfilePart.RT_CERTIFICATION) ||
                        recordTypeName.equalsIgnoreCase(rsProfilePart.RT_PROF_AFFILIATION) ||
                        recordTypeName.equalsIgnoreCase(rsProfilePart.RT_REGISTRATION) ||
                        recordTypeName.equalsIgnoreCase(rsProfilePart.RT_TRAINING)
                      ) {
                pr.getParameters().put('tab.Skills_and_Qualifications.subtab', '2');
            } else if (recordTypeName.equalsIgnoreCase(rsProfilePart.RT_AWARD) || recordTypeName.equalsIgnoreCase(rsProfilePart.RT_PUBLICATION)) {
                pr.getParameters().put('tab.Skills_and_Qualifications.subtab', '3');
            } else if (recordTypeName.equalsIgnoreCase(rsProfilePart.RT_REFERENCE) ) {
                pr.getParameters().put('tab.Skills_and_Qualifications.subtab', '4');
            }
        }

        return pr;
    }

    //-- Pagination Methods --//
    public PageReference beginning() {
        counter = 0;
        return null;
    }

    public PageReference previous() {
        if((counter - RESULT_SIZE) < 0) {
            counter = 0;
        } else {
            counter -= RESULT_SIZE;
        }
        return null;
    }

    public PageReference next() {
        if((counter + RESULT_SIZE) > getUserMap().size()) {
            counter = getUserMap().size() - Math.mod(getUserMap().size(),RESULT_SIZE);
        } else {
            counter += RESULT_SIZE;
        }
        return null;
    }

    public PageReference end() {
        if(Math.mod(getUserMap().size(),RESULT_SIZE) == 0) {
            counter = getUserMap().size() - RESULT_SIZE;
        } else {
            counter = getUserMap().size() - Math.mod(getUserMap().size(),RESULT_SIZE);
        }
        return null;
    }

    public Boolean getDisabledPrevious() {
        return !(counter > 0); 
    }

    public Boolean getDisabledNext() {
        return !((counter + RESULT_SIZE) < getUserMap().size());
    }

    public Integer getPageNumber() {
        Integer retValue = 0;
        if(getUserMap().size() != 0) {
            retValue = counter/RESULT_SIZE + 1;
        }
        return retValue;
    }

    public Integer getFromResult() {
        Integer retVal = 0;
        if(getUserMap().size() != 0) {
            retVal = counter + 1;
        }
        return retVal;
    }

    public Integer getToResult() {
        Integer retVal = 0;
        if(getUserMap().size() != 0) {
            retVal = (counter + RESULT_SIZE) > getUserMap().size() ? getUserMap().size() : counter + RESULT_SIZE;
        }
        return retVal;
    }

    public Integer getTotalSearchResults() {
        return getUserMap().size();
    }

    public Integer getTotalPages() {
        Integer retValue = 0;
        if(Math.mod(getUserMap().size(),RESULT_SIZE) > 0){
            retValue = getUserMap().size()/RESULT_SIZE + 1;
        } else {
            retValue = getUserMap().size()/RESULT_SIZE;
        }
        return retValue;
    }

    public List<rsUserViewModel> getViewResults() {
        List<rsUserViewModel> allResults = getUserList();
        List<rsUserViewModel> results = new List<rsUserViewModel>();
        for(Integer i = 0; i < RESULT_SIZE; i++) {
            if((i + counter) < getUserMap().size()) {
                results.add(allResults.get(i+counter));
            }
        }
        return results;
    }

    public PageReference resetCounter() {
        counter = 0;
        return null;
    }
    // -- End Pagination Methods -- //
}