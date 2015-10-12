/*************************************************************************
*
* PURPOSE: Controller for the project component used on the rsProject.page
*
* CREATED: 2014 Ethos Solutions - www.ethos.com
* AUTHOR: Alex Molina
***************************************************************************/
public with sharing class rsProjectController extends rsSectionController {
    public rsPRTeamEmployee CurrentProject {get; set;}
    public List<rsProjectGroup> AECOMProjectGroups {get; set;}
    public List<rsProjectGroup> NonAECOMProjectGroups {get; set;}
    private rsPRTeamEmployee mOldProject {get; set;}
    public String projectKeyPrefix {get; private set;}
    public String profilePartKeyPrefix {get; private set;}

    private String mProjectGroupsAutoComplete;

    private Boolean mIsExistingAECOMProject;
    private Boolean misNewAECOMProject;
    private Boolean misNonAECOMProject;

    private Boolean mNewAECOMProjectGroupAdded;
    private Boolean mNewNonAECOMProjectGroupAdded;

    //--PAGINATION VARIABLES
    public Map<String, Integer> numProjInAECOMGroup {get; set;} // Tracks number of projects in a group
    // important when a group splits with pagination
    public Map<String, Integer> numProjInNonAECOMGroup {get; set;}
    private Set<Id> AECOMPartIds {get; set;} // Makes sure we don't somehow add the same part twice to the map
    private Set<Id> nonAECOMPartIds {get; set;}
    private List<rsProjectViewModel> allViewModels;
    private Map<String, Integer> projectKeyLocation;

    public List<SelectOption> countryList {get; set;} //Country list taken from Profile Parts

    public rsProjectController() {
        super();
        TotalParts = 0;
        AECOMProjectGroups = new List<rsProjectGroup>();
        NonAECOMProjectGroups = new List<rsProjectGroup>();
        mIsExistingAECOMProject = true;
        mIsNewAECOMProject = false;
        mIsNonAECOMProject = false;
        mNewAECOMProjectGroupAdded = false;
        mNewNonAECOMProjectGroupAdded = false;
        projectKeyPrefix = Project__c.SObjectType.getDescribe().getKeyPrefix();
        profilePartKeyPrefix = rs_Profile_Part__c.SObjectType.getDescribe().getKeyPrefix();
        CurrentProject = new rsPRTeamEmployee();
        mRecordType = rsPRTeamEmployee.RT_AECOMPROJECT;
        AECOMPartIds = new Set<Id>();
        nonAECOMPartIds = new Set<Id>();
        //--Pagination stuff
        if (PageNum == null) {
            PageNum = 1;
        }
        projectKeyLocation = new Map<String, Integer>();
        numProjInAECOMGroup = new Map<String, Integer>();
        numProjInNonAECOMGroup = new Map<String, Integer>();

        //Country List population
        sObject sObj = Schema.getGlobalDescribe().get('rs_Profile_Part__c').newSObject() ;
        countryList = rsDataUtils.getPicklistValues(sObj, 'Country__c');
    }

    public override PageReference newPart() {
        mIsError = false;
        CurrentProject = new rsPRTeamEmployee(profile.getId(), mRecordType);
        CurrentProject.setOutputOnResume(true);
        CurrentProject.setInitialLocale(UserInfo.getLocale() );
        enableEditMode();
        if (ApexPages.currentPage().getParameters().get('cmNewPart') == 'true') {
            newAECOMProjectView();
        }
        return null;
    }

    public override PageReference savePart() {
        savePart(false);
        return null;
    }

    public override PageReference savePart(Boolean saveAndApprove) {
        mIsError = false;
        //First check if their profile has been locked while they were editing this part, unless they are a content manager that locked it, in which case they can save just fine
        User profileRequery = getUser();
        if (profileRequery.Profile_Reviewer__c != UserInfo.getUserId() && profileRequery.Is_Profile_Locked__c ) {
            String lockerUrl = 'https://' + ApexPages.currentPage().getHeaders().get('Host') + '/' + profile.getUser().Profile_Reviewer__c;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, Label.Profile_Locked_By_CM + ' <a target="_blank" href="' + lockerUrl + '">' + profile.getUser().Profile_Reviewer__r.Name + ' </a>'));
            mIsError = true;
            return null;
        }

        if (mIsExistingAECOMProject) {
            String whereStr = ' EmployeeUser__c = ' + rsStringUtil.quote(profile.getId()) + ' AND Project_Id__c = ' + rsStringUtil.quote(CurrentProject.getProjectId()) + ' AND Status__c != ' + rsStringUtil.quote(rsPRTeamEmployee.S_ARCHIVED) + ' AND Next_Project_Part__c = null';
            if (mOldProject != null) {
                whereStr +=  ' AND Id != ' + rsStringUtil.quote(mOldProject.getId());
            }
            if (rsPRTeamEmployee.find.getByWhere(whereStr).size() > 0) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Project_Already_Added));
                CurrentProject.setProjectId(null);
                mIsError = true;
                return null;
            }
        }

        Boolean isExistingProject = false;
        Integer i = -1;
        for (rsPRTeamEmployee project : profile.getProfileProjects()) {
            i++;
            //If it's our current project OR it's our previous project (this case happens when we save and validation fails and our CurrentProject doesn't have an ID yet but is still should be existing project)
            if (project.getId() == CurrentProject.getId() || (CurrentProject.getId() == null && mOldProject != null && project.getId() == mOldProject.getId()) ) {
                isExistingProject = true;
                break;
            }
        }
        //If the status is pending then we'll just save our changes on the old record, no reason to clone
        if (isExistingProject && !mOldProject.getIsPendingOrInReview() ) {
            PR_Team_Employee__c clone = (PR_Team_Employee__c)CurrentProject.getObj().clone(false, true, false, false);
            clone.Previous_Project_Part__c = CurrentProject.getId();
            clone.ChkUniqueEmp__c = null;
            CurrentProject = new rsPRTeamEmployee(clone);
        }
        setFieldsForSave(CurrentProject, profileRequery, saveAndApprove);


        //TODO We might be able to remove this if statement (below) that checks if we auto-approve, since in setFieldsForSave() called above,
        //we call approval util, which should do this kind of checking for us

        //If this project is auto-approved, then we need to archive the old project before we can save Current to keep the ChkUniqueEmp WF rule happy
        if (CurrentProject.getStatus() == rsPRTeamEmployee.S_APPROVED && mOldProject != null) {
            mOldProject.setStatus(rsPRTeamEmployee.S_ARCHIVED);
            mOldProject.setProjectId(null);
            mOldProject.getPRObj().ChkUniqueEmp__c = null;
            mOldProject.save();
        }
        try {
            CurrentProject.save();
        } catch (DmlException ex) {
            ApexPages.addMessages(ex);
            System.debug ('!!Exception on project save. ' + ex + ex.getStackTraceString());
            mIsError = true;
            return null;
        }

        //Requery the part to get the formula fields evaluated
        CurrentProject = new rsPRTeamEmployee((PR_Team_Employee__c)rsPRTeamEmployee.find.byId(CurrentProject.getId()).getObj());

        //Again if the status is pending, we don't need to update the pointer because we aren't cloning to a new object
        if (isExistingProject && !mOldProject.getIsPendingOrInReview() ) {
            profile.getProfileProjects().remove(i);
            if (mOldProject.getId() != CurrentProject.getId()) {
                mOldProject.setNextProjectPart(CurrentProject.getId());
            }
            try {
                mOldProject.save();
            } catch (DmlException ex) {
                ApexPages.addMessages(ex);
                System.debug ('!!Exception on old project save. ' + ex + ex.getStackTraceString());
                mIsError = true;
                return null;
            }
        }

        //If this is a new project, or an existing one that wasn't cloned then we need to add it to the list
        if (!isExistingProject || (isExistingProject && !mOldProject.getIsPendingOrInReview() ) ) {
            profile.getProfileProjects().add(CurrentProject);
        } else { //Else we'll just replace the object in the list with updated object
            profile.getProfileProjects().set(i, CurrentProject);
        }
        reorderGrouping();
        existingAECOMProjectView();
        mOldProject = null;
        enableListMode();

        updateUserProfileTimestamps();
        updateUserSummary();

        return null;
    }

    public override PageReference saveAndApprove() {
        savePart(true);
        return null;
    }

    private void setFieldsForSave(rsPRTeamEmployee projectPart, User currentUser, Boolean saveAndApprove) {
        setTrackingFields();
        projectPart.setAddedByEmployee(true);
        if (isReviewable(mRecordType, currentUser) || (!saveAndApprove && projectPart.getIsPendingOrInReview())) {
            projectPart.setDateTimeSentForReview(Datetime.now());
            if (profile.getDateTimeSentforReview() == null) {
                profile.setDateTimeSentforReview(Datetime.now());
                profile.setStatus(rsProfile.S_PENDING);
                profile.save();
            }
            projectPart.setStatus(rsPRTeamEmployee.S_PENDING);
        } else {
            rsApprovalUtil.approveProjectPart(projectPart, profile);
        }
    }

    public override PageReference cancelPart() {
        mIsError = false;
        CurrentProject = null;
        mOldProject = null;
        existingAECOMProjectView();
        enableListMode();
        return null;
    }

    public override PageReference deletePart() {
        List<rsPRTeamEmployee> projects = profile.getProfileProjects();
        rsPRTeamEmployee project = null;
        Boolean keepUserLocked = false;
        Integer projectIndex = null;
        for (Integer i = 0; i < projects.size(); i++) {
            if (projects[i].getId() == ApexPages.currentPage().getParameters().get('projectId')) {
                projectIndex = i;
                if (profile.getStatus() == rsProfile.S_INREVIEW) {
                    keepUserLocked = profile.shouldProfileStayLocked( projects[i].getId() );
                }
                break;
            }
        }
        project = projects.remove(projectIndex);

        if (!keepUserLocked) {
            profile.setLock(false);
            profile.setDateTimeSentforReview(null);
            profile.setStatus(rsProfile.S_APPROVED);
            profile.setProfileReviewer(null);
            profile.save();
        }

        //If this part is (pending or in review) and it has a previously approved part, before we delete this one, we archive the old one, so neither will show up in the list.
        if ( (project.getStatus() == rsPRTeamEmployee.S_PENDING || project.getStatus() == rsPRTeamEmployee.S_INREVIEW) && (project.getPreviousProjectPart() != null) ) {
            rsPRTeamEmployee previousProject = new rsPRTeamEmployee( (PR_Team_Employee__c)rsPRTeamEmployee.find.byId(project.getPreviousProjectPart()).getObj() );
            previousProject.setStatus(rsPRTeamEmployee.S_ARCHIVED);
            previousProject.save();
        }
        project.destroy();
        reorderGrouping();
        CurrentProject = null;
        enableListMode();
        String recordTypeId = ApexPages.currentPage().getParameters().get('recordType');
        if ( (recordTypeId == rsPRTeamEmployee.getRecordTypeIdByName(rsPRTeamEmployee.RT_AECOMPROJECT)
                && getAECOMProjectViewParts().size() == 0)
                || (recordTypeId == rsPRTeamEmployee.getRecordTypeIdByName(rsPRTeamEmployee.RT_NONAECOMPROJECT)
                    && getNonAECOMProjectViewParts().size() == 0)) {

            getPreviousPage();
        }
        return null;
    }

    public override PageReference editPart() {
        for (rsPRTeamEmployee tempProject : profile.getProfileProjects()) {
            if (tempProject.getId() == ApexPages.currentPage().getParameters().get('projectId')) {
                enableEditMode();
                mOldProject = tempProject;
                CurrentProject = new rsPRTeamEmployee((PR_Team_Employee__c)tempProject.getObj().clone(true, true, false, false));

                if ( (CurrentProject.getRecordTypeId() == rsPRTeamEmployee.getRecordTypeIdByName(rsPRTeamEmployee.RT_AECOMPROJECT) && CurrentProject.getProjectId() != null || (CurrentProject.getPRObj().Previous_Project_Part__c != null && CurrentProject.getPRObj().Previous_Project_Part__r.Project_Id__c != null) ) ) {
                    existingAECOMProjectView();
                } else if ( (CurrentProject.getRecordTypeId() == rsPRTeamEmployee.getRecordTypeIdByName(rsPRTeamEmployee.RT_AECOMPROJECT) && CurrentProject.getProjectId() == null ) ) {
                    newAECOMProjectView();
                } else if ( CurrentProject.getRecordTypeId() == rsPRTeamEmployee.getRecordTypeIdByName(rsPRTeamEmployee.RT_NONAECOMPROJECT) ) {
                    nonAECOMProjectView();
                }
                break;
            }
        }
        System.assert(CurrentProject != null);
        return null;
    }

    public override PageReference viewPart() {
        for (rsPRTeamEmployee tempProject : profile.getProfileProjects()) {
            if (tempProject.getId() == ApexPages.currentPage().getParameters().get('projectId')) {
                enableViewMode();
                CurrentProject = tempProject;
                break;
            }
        }
        return null;
    }

    public override PageReference approvePart() {
        String partId = ApexPages.currentPage().getParameters().get('partId');
        for (rsPRTeamEmployee profileProject : profile.getProfileProjects() ) {
            if (profileProject.getId() == partId) {
                rsApprovalUtil.approveProjectPart(profileProject, profile);
                break;
            }
        }

        updateUserSummary();

        return null;
    }

    public String getProjectGroupsAutoComplete() {
        mProjectGroupsAutoComplete = rsProfile.find.getAutoCompleteProjectGroups(profile.getId());
        return mProjectGroupsAutoComplete;
    }

    // Moves Project Grouping one higher
    public PageReference moveGroupUp() {
        reorderGrouping();
        String projectGroup = ApexPages.currentPage().getParameters().get('projectGroup');
        String recordTypeId = ApexPages.currentPage().getParameters().get('recordType');
        Integer originalPlace = 0;
        rsProjectGroup tempProjGroup;
        if (String.isBlank(projectGroup)) {
            projectGroup = rsPRTeamEmployee.K_UNSPECIFIED;
        }
        List<rsProjectGroup> projectGroups = new List<rsProjectGroup>();
        if (recordTypeId == rsPRTeamEmployee.getRecordTypeIdByName(rsPRTeamEmployee.RT_AECOMPROJECT)) {
            projectGroups = getAECOMProfileProjectGroups();
        } else if (recordTypeId == rsPRTeamEmployee.getRecordTypeIdByName(rsPRTeamEmployee.RT_NONAECOMPROJECT)) {
            projectGroups = getNonAECOMProfileProjectGroups();
        }

        if (projectGroups.size() < 2) {
            return null;
        }

        for (Integer i = 0; i < projectgroups.size(); i++) {
            if (projectgroups.get(i).projectGroup == projectGroup) {
                originalPlace = i;
                tempProjGroup = projectgroups.get(i);
                break;
            }
        }
        if (originalPlace <= 0) {
            originalPlace = 1;
        }
        // Updating Group Sequence for the two groups that are switching
        for (rsPRTeamEmployee project : tempProjGroup.groupProjects) {
            project.setGroupSequence(originalPlace - 1);
            tempProjGroup.order = originalPlace - 1;
        }
        for (rsPRTeamEmployee project : projectGroups.get(originalPlace - 1).groupProjects) {
            project.setGroupSequence(originalPlace);
            tempProjGroup.order = originalPlace;
        }
        projectGroups.set(originalPlace, projectgroups.get(originalPlace - 1));
        projectGroups.set(originalPlace - 1, tempProjGroup);
        if (recordTypeId == rsPRTeamEmployee.getRecordTypeIdByName(rsPRTeamEmployee.RT_AECOMPROJECT)) {
            AECOMProjectGroups.clear();
            AECOMProjectGroups.addAll(projectGroups);
        } else if (recordTypeId == rsPRTeamEmployee.getRecordTypeIdByName(rsPRTeamEmployee.RT_NONAECOMPROJECT)) {
            NonAECOMProjectGroups.clear();
            NonAECOMProjectGroups.addall(projectGroups);
        }
        reorderGrouping();
        try {
            rsModel.save(getProfileProjectParts());
        } catch (DmlException ex) {
            System.debug('!! Exception saving project parts :' + ex);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Past_Record_Exception));
        }
        return null;
    }

    // Moves Project Grouping one lower
    public PageReference moveGroupDown() {
        reorderGrouping();
        String projectGroup = ApexPages.currentPage().getParameters().get('projectGroup');
        String recordTypeId = ApexPages.currentPage().getParameters().get('recordType');
        Integer originalPlace = 0;
        rsProjectGroup tempProjGroup;
        if (String.isBlank(projectGroup)) {
            projectGroup = rsPRTeamEmployee.K_UNSPECIFIED;
        }
        List<rsProjectGroup> projectGroups = new List<rsProjectGroup>();
        if (recordTypeId == rsPRTeamEmployee.getRecordTypeIdByName(rsPRTeamEmployee.RT_AECOMPROJECT)) {
            projectGroups = getAECOMProfileProjectGroups();
        } else if (recordTypeId == rsPRTeamEmployee.getRecordTypeIdByName(rsPRTeamEmployee.RT_NONAECOMPROJECT)) {
            projectGroups = getNonAECOMProfileProjectGroups();
        }

        if (projectGroups.size() < 2) {
            return null;
        }

        for (Integer i = 0; i < projectGroups.size(); i++) {
            if (projectGroups.get(i).projectGroup == projectGroup) {
                originalPlace = i;
                tempProjGroup = projectGroups.get(i);
                break;
            }

        }
        while ((originalPlace + 1) >= projectGroups.size() && originalPlace > 0) {
            originalPlace--;
        }
        // Updating Group Sequence for the two groups that are switching
        for (rsPRTeamEmployee project : tempProjGroup.groupProjects) {
            project.setGroupSequence(originalPlace + 1);
            tempProjGroup.order = originalPlace + 1;
        }
        for (rsPRTeamEmployee project : projectgroups.get(originalPlace + 1).groupProjects) {
            project.setGroupSequence(originalPlace);
            tempProjGroup.order = originalPlace;
        }
        projectgroups.set(originalPlace, projectgroups.get(originalPlace + 1));
        projectgroups.set(originalPlace + 1, tempProjGroup);
        if (recordTypeId == rsPRTeamEmployee.getRecordTypeIdByName(rsPRTeamEmployee.RT_AECOMPROJECT)) {
            AECOMProjectGroups.clear();
            AECOMProjectGroups.addAll(projectGroups);
        } else if (recordTypeId == rsPRTeamEmployee.getRecordTypeIdByName(rsPRTeamEmployee.RT_NONAECOMPROJECT)) {
            NonAECOMProjectGroups.clear();
            NonAECOMProjectGroups.addall(projectGroups);
        }
        reorderGrouping();
        try {
            rsModel.save(getProfileProjectParts());
        } catch (DmlException ex) {
            System.debug('!! Exception saving project parts :' + ex);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Past_Record_Exception));
        }
        return null;
    }

    //Moves a Project within a Project Group one higher
    public PageReference moveProjectUp() {
        reorderGrouping();
        String projectGroup = ApexPages.currentPage().getParameters().get('projectGroup');
        String projectId = ApexPages.currentPage().getParameters().get('projectId');
        String recordTypeId = ApexPages.currentPage().getParameters().get('recordType');
        Integer originalPlace = 0;
        rsPRTeamEmployee tempPREmp;
        if (String.isBlank(projectGroup)) {
            projectGroup = rsPRTeamEmployee.K_UNSPECIFIED;
        }
        List<rsProjectGroup> projectGroups = new List<rsProjectGroup>();
        if (recordTypeId == rsPRTeamEmployee.getRecordTypeIdByName(rsPRTeamEmployee.RT_AECOMPROJECT)) {
            projectGroups = getAECOMProfileProjectGroups();
        } else if (recordTypeId == rsPRTeamEmployee.getRecordTypeIdByName(rsPRTeamEmployee.RT_NONAECOMPROJECT)) {
            projectGroups = getNonAECOMProfileProjectGroups();
        }
        for (Integer i = 0; i < projectGroups.size(); i++) {
            if (projectGroups.get(i).projectGroup == projectGroup) {
                for (Integer j = 0; j < projectGroups.get(i).groupProjects.size(); j++) {
                    rsPRTeamEmployee emp = projectGroups.get(i).groupProjects.get(j);
                    if (emp.getId() == projectId) {
                        originalPlace = j;
                        tempPREmp = emp;
                        break;
                    }
                }
                if (originalPlace <= 0) {
                    originalPlace = 1;
                }
                //Updating Group Sequence
                projectGroups.get(i).groupProjects.get(originalPlace).setProjectSequence(originalPlace - 1);
                projectGroups.get(i).groupProjects.get(originalPlace - 1).setProjectSequence(originalPlace);

                projectGroups.get(i).groupProjects.set(originalPlace, projectGroups.get(i).groupProjects.get(originalPlace - 1));
                projectGroups.get(i).groupProjects.set(originalPlace - 1, tempPREmp);
                break;
            }
        }
        reorderGrouping();
        try {
            rsModel.save(getProfileProjectParts());
        } catch (DmlException ex) {
            System.debug('!! Exception saving project parts :' + ex);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Past_Record_Exception));
        }
        return null;
    }

    //Moves a Project within a Project Group one lower
    public PageReference moveProjectDown() {
        reorderGrouping();
        String projectGroup = ApexPages.currentPage().getParameters().get('projectGroup');
        String projectId = ApexPages.currentPage().getParameters().get('projectId');
        String recordTypeId = ApexPages.currentPage().getParameters().get('recordType');
        Integer originalPlace = 0;
        rsPRTeamEmployee tempPREmp;
        if (String.isBlank(projectGroup)) {
            projectGroup = rsPRTeamEmployee.K_UNSPECIFIED;
        }
        List<rsProjectGroup> projectGroups = new List<rsProjectGroup>();
        if (recordTypeId == rsPRTeamEmployee.getRecordTypeIdByName(rsPRTeamEmployee.RT_AECOMPROJECT)) {
            projectGroups = getAECOMProfileProjectGroups();
        } else if (recordTypeId == rsPRTeamEmployee.getRecordTypeIdByName(rsPRTeamEmployee.RT_NONAECOMPROJECT)) {
            projectGroups = getNonAECOMProfileProjectGroups();
        }
        for (Integer i = 0; i < projectGroups.size(); i++) {
            if (projectGroups.get(i).projectGroup == projectGroup) {
                for (Integer j = 0; j < projectGroups.get(i).groupProjects.size(); j++) {
                    rsPRTeamEmployee emp = projectGroups.get(i).groupProjects.get(j);
                    if (emp.getId() == projectId) {
                        originalPlace = j;
                        tempPREmp = emp;
                        break;
                    }
                }
                while ((originalPlace + 1) >= projectGroups.get(i).groupProjects.size() && originalPlace > 0) {
                    originalPlace--;
                }
                //Updating Group Sequence
                projectGroups.get(i).groupProjects.get(originalPlace).setProjectSequence(originalPlace + 1);
                projectGroups.get(i).groupProjects.get(originalPlace + 1).setProjectSequence(originalPlace);

                projectGroups.get(i).groupProjects.set(originalPlace, projectGroups.get(i).groupProjects.get(originalPlace + 1));
                projectGroups.get(i).groupProjects.set(originalPlace + 1, tempPREmp);
                break;
            }
        }
        reorderGrouping();
        try {
            rsModel.save(getProfileProjectParts());
        } catch (DmlException ex) {
            System.debug('!! Exception saving project parts :' + ex);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Past_Record_Exception));
        }
        return null;
    }

    public List<rsPRTeamEmployee> getProfileProjectParts() {
        return profile.getProfileProjects();
    }

    public List<rsProjectGroup> getAECOMProfileProjectGroups() {
        AECOMProjectGroups = new List<rsProjectGroup>();
        Map<String, List<rsPRTeamEmployee>> groups = new Map<String, List<rsPRTeamEmployee>>();
        for (rsPRTeamEmployee emp : getAECOMProfileProjectParts()) {
            String projectGroup = rsStringUtil.toTitleCase(emp.getProjectGroup());
            System.debug('Project Groups AECOMPG: ' + projectGroup);
            if (String.isNotBlank(projectGroup) && !groups.containsKey(projectGroup)) {
                groups.put(projectGroup, new List<rsPRTeamEmployee> {emp});
            } else if (String.isNotBlank(projectGroup) && groups.containsKey(projectGroup)) {
                groups.get(projectGroup).add(emp);
            } else if (rsStringUtil.isNullOrEmpty(projectGroup) && !groups.containsKey(rsPRTeamEmployee.K_UNSPECIFIED)) {
                groups.put(rsPRTeamEmployee.K_UNSPECIFIED, new List<rsPRTeamEmployee> {emp});
            } else {
                groups.get(rsPRTeamEmployee.K_UNSPECIFIED).add(emp);
            }
        }
        for (String groupKey : groups.keySet()) {
            AECOMProjectGroups.add(new rsProjectGroup(groupKey, groups.get(groupKey)));
            if (groups.get(groupKey).size() == 1 && groups.get(groupKey).get(0).getGroupSequence() == null) {
                mNewAECOMProjectGroupAdded = true;
            }
        }
        AECOMProjectGroups.sort();
        return AECOMProjectGroups;
    }

    public List<rsProjectGroup> getNONAECOMProfileProjectGroups() {
        NonAECOMProjectGroups = new List<rsProjectGroup>();
        Map<String, List<rsPRTeamEmployee>> groups = new Map<String, List<rsPRTeamEmployee>>();
        for (rsPRTeamEmployee emp : getNonAECOMProfileProjectParts()) {
            String projectGroup = rsStringUtil.toTitleCase((String)emp.getObj().get('Project_Group_Editable__c'));
            if (String.isNotBlank(projectGroup) && !groups.containsKey(projectGroup)) {
                groups.put(rsStringUtil.toTitleCase(projectGroup), new List<rsPRTeamEmployee> {emp});
            } else if (String.isNotBlank(projectGroup) && groups.containsKey(projectGroup)) {
                groups.get(projectGroup).add(emp);
            } else if (rsStringUtil.isNullOrEmpty(projectGroup) && !groups.containsKey(rsPRTeamEmployee.K_UNSPECIFIED)) {
                groups.put(rsPRTeamEmployee.K_UNSPECIFIED, new List<rsPRTeamEmployee> {emp});
            } else {
                groups.get(rsPRTeamEmployee.K_UNSPECIFIED).add(emp);
            }
        }
        for (String groupKey : groups.keySet()) {
            NonAECOMProjectGroups.add(new rsProjectGroup(groupKey, groups.get(groupKey)));
            if (groups.get(groupKey).size() == 1 && groups.get(groupKey).get(0).getGroupSequence() == null) {
                mNewNonAECOMProjectGroupAdded = true;
            }
        }
        NonAECOMProjectGroups.sort();
        return NonAECOMProjectGroups;
    }

    public List<rsPRTeamEmployee> getAECOMProfileProjectParts() {
        List<rsPRTeamEmployee> allProjects = getProfileProjectParts();
        List<rsPRTeamEmployee> onlyAECOM = new List<rsPRTeamEmployee>();
        for (rsPRTeamEmployee specificProject : allProjects) {
            if (specificProject.getRecordTypeId() == rsPRTeamEmployee.getRecordTypeIdByName(rsPRTeamEmployee.RT_AECOMPROJECT)
                    && specificProject.getStatus() != rsPRTeamEmployee.S_ARCHIVED) {
                onlyAECOM.add(specificProject);
            }
        }
        return onlyAECOM;
    }
    public List<rsPRTeamEmployee> getNonAECOMProfileProjectParts() {
        List<rsPRTeamEmployee> allProjects = getProfileProjectParts();
        List<rsPRTeamEmployee> onlyNonAECOM = new List<rsPRTeamEmployee>();
        for (rsPRTeamEmployee specificProject : allProjects) {
            if (specificProject.getRecordTypeId() == rsPRTeamEmployee.getRecordTypeIdByName(rsPRTeamEmployee.RT_NONAECOMPROJECT)
                    && specificProject.getStatus() != rsPRTeamEmployee.S_ARCHIVED) {
                onlyNonAECOM.add(specificProject);
            }
        }
        return onlyNonAECOM;
    }

    public rsPRTeamEmployee getOldProject() {
        return mOldProject;
    }

    public Boolean getIsExistingAECOMProject() {
        return mIsExistingAECOMProject;
    }

    public Boolean getIsNewAECOMProject() {
        return mIsNewAECOMProject;
    }

    public Boolean getIsNonAECOMProject() {
        return mIsNonAECOMProject;
    }
    public void setIsNonAECOMProject(Boolean val) {
        mIsNonAECOMProject = val;
    }
    public PageReference existingAECOMProjectView() {
        mRecordType = rsPRTeamEmployee.RT_AECOMPROJECT;
        mIsExistingAECOMProject = true;
        mIsNewAECOMProject = false;
        mIsNonAECOMProject = false;
        return null;
    }

    public PageReference newAECOMProjectView() {
        mRecordType = rsPRTeamEmployee.RT_AECOMPROJECT;
        mIsExistingAECOMProject = false;
        mIsNewAECOMProject = true;
        mIsNonAECOMProject = false;
        return null;
    }

    public PageReference nonAECOMProjectView() {
        mRecordType = rsPRTeamEmployee.RT_NONAECOMPROJECT;
        mIsExistingAECOMProject = false;
        mIsNewAECOMProject = false;
        mIsNonAECOMProject = true;
        return null;
    }

    public PageReference nonAECOMCheckRT() {
        // Set the appropriate project view
        if (mIsNonAECOMProject) {
            mRecordType = rsPRTeamEmployee.RT_NONAECOMPROJECT;
            nonAecomProjectView();
        } else {
            mRecordType = rsPRTeamEmployee.RT_AECOMPROJECT;
            newAECOMProjectView();
        }
        newPart();
        return null;
    }

    public PageReference newNonAECOMPart() {
        mIsNonAECOMProject = true;
        mRecordType = rsPRTeamEmployee.RT_NONAECOMPROJECT;
        nonAecomProjectView();
        newPart();
        return null;
    }

    private void reorderGrouping() {
        List<rsProjectGroup> aecomProjects = getAECOMProfileProjectGroups();
        List<rsProjectGroup> nonAecomProjects = getNonAECOMProfileProjectGroups();
        List<rsPRTeamEmployee> saveList = new List<rsPRTeamEmployee>();
        for (rsProjectGroup proj : aecomProjects) {                              // loop through Project groups
            for (rsPRTeamEmployee emp : proj.groupProjects) {                    // loop through the rsPRTEAMEmployees
                if (emp.getGroupSequence() == null) {                            // check if the Group Sequence is null
                    if (proj.order != null) {                                    // the Project group order has been set
                        emp.setGroupSequence(proj.order);                        // if so just set the sequence
                    } else {
                        emp.setGroupSequence(0);                                 // otherwise set the project group to the beginning
                    }
                } else if (mNewAECOMProjectGroupAdded) {
                    emp.setGroupSequence(emp.getGroupSequence() + 1);
                }
                if (emp.getGroupSequence() > aecomProjects.size() - 1) {         // check if the group sequence is greater than the number of project groups available
                    emp.setGroupSequence(emp.getGroupSequence() - 1);            // deduct it by one, this part is needed for deleted project groups
                }
                if (emp.getProjectSequence() == null) {                          // if the project sequence is not set ( new projects )
                    emp.setProjectSequence(0);                                   // we'll add it to the beginning of the list (AECR-965)
                } else if (proj.isReordered) {
                    emp.setProjectSequence(emp.getProjectSequence() + 1);        // If a project has been added we'll have to increment the sequence for following projects
                }
                if (emp.getProjectSequence() > proj.groupProjects.size() - 1) {  // if the project sequence is greater than the number of projects available
                    emp.setProjectSequence(emp.getProjectSequence() - 1);        // like the previous scenario, for deleted projects
                }
            }
            saveList.addAll(proj.groupProjects);                                 // Save aecom Project regroup and increment place;
        }
        mNewAECOMProjectGroupAdded = false;
        for (rsProjectGroup proj : nonAecomProjects) {
            for (rsPRTeamEmployee emp : proj.groupProjects) {
                if (emp.getGroupSequence() == null) {
                    if (proj.order != null) {
                        emp.setGroupSequence(proj.order);
                    } else {
                        emp.setGroupSequence(0);
                    }
                } else if (mNewNonAECOMProjectGroupAdded) {
                    emp.setGroupSequence(emp.getGroupSequence() + 1);
                }
                if (emp.getGroupSequence() > nonAecomProjects.size() - 1) {
                    emp.setGroupSequence(emp.getGroupSequence() - 1);
                }
                if (emp.getProjectSequence() == null) {
                    emp.setProjectSequence(0);
                } else if (proj.isReordered) {
                    emp.setProjectSequence(emp.getProjectSequence() + 1);
                }
                if (emp.getProjectSequence() > proj.groupProjects.size() - 1) {
                    emp.setProjectSequence(emp.getProjectSequence() - 1);
                }
            }
            saveList.addAll(proj.groupProjects);
        }
        mNewNonAECOMProjectGroupAdded = false;
        try {
            rsModel.save(saveList);
        } catch (DmlException ex) {
            System.debug('!! Exception saving project parts :' + ex);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Past_Record_Exception));
        }

    }

    //--PAGINATION METHODS

    public List<rsProjectViewModel> getAECOMProjectViewParts() {
        String sortField = ApexPages.currentPage().getParameters().get('sortField');
        String pageChange = ApexPages.currentPage().getParameters().get('pageChange');
        projectKeyLocation = new Map<String, Integer>();
        if (sortField == null || pageChange == null) {
            allViewModels = new List<rsProjectViewModel>();
            numProjInAECOMGroup.clear();
            AECOMPartIds.clear();
            for (rsPRTeamEmployee part : getAECOMProfileProjectParts()) {
                String projectGroup = rsStringUtil.toTitleCase((String)part.getObj().get('Project_Group_Editable__c'));
                allViewModels.add(new rsProjectViewModel(new rsProjectGroup(projectGroup, new List<rsPRTeamEmployee> {part})));
                if (numProjInAECOMGroup.containsKey(projectGroup) && !AECOMPartIds.contains(part.getId())) {
                    numProjInAECOMGroup.put(projectGroup, numProjInAECOMGroup.get(projectGroup) + 1);
                } else if (!numProjInAECOMGroup.containsKey(projectGroup)) {
                    numProjInAECOMGroup.put(projectGroup, 1);
                }
                AECOMPartIds.add(part.getId());
            }
            allViewModels.sort();
        }
        if (TotalParts != null && TotalParts < allViewModels.size()) {
            //new record was added, update ViewLimit
            if (TotalParts > 0 && getViewLimit() > 0 && getViewLimit() < getResultLimit() * PageNum) {
                if ( (Math.mod(TotalParts, getViewLimit()) < getResultLimit() && Math.mod(TotalParts, getViewLimit()) > 0) || (PageNum == getNumberOfPages() && Math.mod(TotalParts, getResultLimit()) > 0) ) {
                    setViewLimit(getViewLimit() + 1);
                }
            }
        }

        TotalParts = allViewModels.size();
        if (TotalParts < getViewLimit() || (TotalParts > 0 && getViewLimit() == 0) ) {
            setViewLimit(TotalParts);
        }
        List<rsProjectViewModel> viewParts = new List<rsProjectViewModel>();

        if (allViewModels != null && !allViewModels.isEmpty()) {
            for (Integer i = ViewIndex; i < getViewLimit(); i++) {
                String key = allViewModels[i].getObj().projectGroup;
                if (projectKeyLocation.containsKey(key)) {
                    viewParts.get(projectKeyLocation.get(key)).getObj().groupProjects.addAll(allViewModels[i].getObj().groupProjects);
                } else {
                    viewParts.add(allViewModels[i]);
                    projectKeyLocation.put(key, viewParts.size() - 1);
                }
            }
        }

        return viewParts;
    }

    public List<rsProjectViewModel> getNonAECOMProjectViewParts() {
        String sortField = ApexPages.currentPage().getParameters().get('sortField');
        String pageChange = ApexPages.currentPage().getParameters().get('pageChange');
        projectKeyLocation = new Map<String, Integer>();
        if (sortField == null || pageChange == null) {
            allViewModels = new List<rsProjectViewModel>();
            numProjInNonAECOMGroup.clear();
            nonAECOMPartIds.clear();
            for (rsPRTeamEmployee part : getNonAECOMProfileProjectParts()) {
                String projectGroup = rsStringUtil.toTitleCase((String)part.getObj().get('Project_Group_Editable__c'));
                allViewModels.add(new rsProjectViewModel(new rsProjectGroup(projectGroup, new List<rsPRTeamEmployee> {part})));
                if (numProjInNonAECOMGroup.containsKey(projectGroup) && !nonAECOMPartIds.contains(part.getId())) {
                    numProjInNonAECOMGroup.put(projectGroup, numProjInNonAECOMGroup.get(projectGroup) + 1);
                } else if (!numProjInNonAECOMGroup.containsKey(projectGroup)) {
                    numProjInNonAECOMGroup.put(projectGroup, 1);
                }
                nonAECOMPartIds.add(part.getId());
                System.debug(numProjInNonAECOMGroup.get(projectGroup));
            }
            allViewModels.sort();
        }
        if (TotalParts != null && TotalParts < allViewModels.size()) {
            //new record was added, update ViewLimit
            if (TotalParts > 0 && getViewLimit() > 0 && getViewLimit() < getResultLimit() * PageNum) {
                if ( (Math.mod(TotalParts, getViewLimit()) < getResultLimit() && Math.mod(TotalParts, getViewLimit()) > 0) || (PageNum == getNumberOfPages() && Math.mod(TotalParts, getResultLimit()) > 0) ) {
                    setViewLimit(getViewLimit() + 1);
                }
            }
        }

        TotalParts = allViewModels.size();
        if (TotalParts < getViewLimit() || (TotalParts > 0 && getViewLimit() == 0) ) {
            setViewLimit(TotalParts);
        }
        List<rsProjectViewModel> viewParts = new List<rsProjectViewModel>();

        if (allViewModels != null && !allViewModels.isEmpty()) {
            for (Integer i = ViewIndex; i < getViewLimit(); i++) {
                String key = allViewModels[i].getObj().projectGroup;
                if (projectKeyLocation.containsKey(key)) {
                    viewParts.get(projectKeyLocation.get(key)).getObj().groupProjects.addAll(allViewModels[i].getObj().groupProjects);
                } else {
                    viewParts.add(allViewModels[i]);
                    projectKeyLocation.put(key, viewParts.size() - 1);
                }
            }
        }

        return viewParts;
    }

    //--END PAGINATION METHODS

    private void updateUserSummary() {
        // Map of projectss that will be summarized in user, keys are user Ids
        Map<Id, List<PR_Team_Employee__c>> projects = new Map<Id, List<PR_Team_Employee__c>>();
        Set<Id> alreadyAddedPPIds = new Set<Id>();

        Set<Id> userIds = new Set<Id>();
        userIds.add(profile.getId());

        // Map of Record Types names and their information
        Map<String, Schema.RecordTypeInfo> mRtInfo = PR_Team_Employee__c.SObjectType.getDescribe().getRecordTypeInfosByName();

        //Map of Projects fields, we'll use this for labeling the User summary
        Map<String, Schema.SObjectField> projectFields = Schema.SObjectType.PR_Team_Employee__c.fields.getMap();

        List<User> users = [Select AECOM_Projects_Summary__c, Non_AECOM_Projects_Summary__c
                            from User
                            where Id IN: userIds];


        // Query projects that are approved to recreate the the summary fields
        List<PR_Team_Employee__c> queryPP = (List<PR_Team_Employee__c>)Database.query('Select ' + String.join(new List<String>(projectFields.keySet()), ',') +
                                            ' from PR_Team_Employee__c' +
                                            ' where Id NOT IN: alreadyAddedPPIds' +
                                            ' AND Status__c = ' + rsStringUtil.quote(rsPRTeamEmployee.S_APPROVED) +
                                            ' AND EmployeeUser__c IN: userIds');

        // Add the queried projects to the Map
        for (PR_Team_Employee__c pp : queryPP) {
            if (projects.containsKey(pp.EmployeeUser__c)) {
                projects.get(pp.EmployeeUser__c).add(pp);
            } else projects.put(pp.EmployeeUser__c, new List<PR_Team_Employee__c> {pp});
        }

        Integer aecomLimit = User.AECOM_Projects_Summary__c.getDescribe().getLength();
        Integer nonAecomLimit = User.Non_AECOM_Projects_Summary__c.getDescribe().getLength();

        // For now we'll only add the required fields to the summary
        // In case of data migration where a lot of the required fields will not be
        // filled out, let's only add them if they have a value
        for (User u : users) {

            Boolean aecomLimitReached = false;
            Boolean nonAecomLimitReached = false;

            // We'll clear the projects summary fields
            u.AECOM_Projects_Summary__c = '';
            u.Non_AECOM_Projects_Summary__c = '';

            // For the case the user doesn't have any previous approved projects
            List<PR_Team_Employee__c> userProjects = projects.containsKey(u.Id) ? projects.get(u.Id) : new List<PR_Team_Employee__c>();
            for (PR_Team_Employee__c pp : userProjects) {

                // AECOM Projects Summary
                if (pp.RecordTypeId == mRtInfo.get(rsPRTeamEmployee.RT_AECOMPROJECT).getRecordTypeId() && !aecomLimitReached) {
                    u.AECOM_Projects_Summary__c += String.isNotBlank(pp.Project_Name__c) ? '[' + projectFields.get('Project_ID__c').getDescribe().getLabel() + ']: ' + pp.Project_Name__c + ', ' : '';
                    u.AECOM_Projects_Summary__c += String.isNotBlank(pp.Project_Role__c) ? '[' + projectFields.get('Project_Role__c').getDescribe().getLabel() + ']: ' + pp.Project_Role__c + ', ' : '';
                    u.AECOM_Projects_Summary__c += String.isNotBlank(pp.Client__c) ? '[' + Label.Client_Name + ']: ' + pp.Client__c + ', ' : '';
                    u.AECOM_Projects_Summary__c += String.isNotBlank(pp.Project_Group_Editable__c) ? '[' + Label.Project_Group + ']: ' + pp.Project_Group_Editable__c + ', ' : '';
                    u.AECOM_Projects_Summary__c += String.isNotBlank(pp.Location_Country__c) ? '[' + Label.Location_Country + ']: ' + pp.Location_Country__c + ', ' : '';
                    if (pp.Date_Involvement_Started__c != null) {
                        u.AECOM_Projects_Summary__c += '[' + Label.Date_Involvement_Started + ']: ' + pp.Date_Involvement_Started__c.format() + ', ';
                    }
                    if (pp.Date_Involvement_Ended__c != null) {
                        u.AECOM_Projects_Summary__c += '[' + Label.Date_Involvement_Ended + ']: ' + pp.Date_Involvement_Ended__c.format() + ', ';
                    }
                    u.AECOM_Projects_Summary__c += String.isNotBlank(pp.Description__c) ? '[' + projectFields.get('Description__c').getDescribe().getLabel() + ']: ' + pp.Description__c : '';
                    u.AECOM_Projects_Summary__c += String.isNotBlank(u.AECOM_Projects_Summary__c) ? '\r\n' : '';

                    // set limit reached and add indicator that more data exists but field cannot hold any more
                    if (u.AECOM_Projects_Summary__c.length() >= aecomLimit) {
                        aecomLimitReached = true;
                        u.AECOM_Projects_Summary__c = u.AECOM_Projects_Summary__c.subString(0, aecomLimit - 3) + '...';
                    }
                }

                // Non-AECOM Projects Summary
                else if (pp.RecordTypeId == mRtInfo.get(rsPRTeamEmployee.RT_NONAECOMPROJECT).getRecordTypeId() && !aecomLimitReached) {
                    u.Non_AECOM_Projects_Summary__c += String.isNotBlank(pp.Project_Name__c) ? '[' + projectFields.get('Project_ID__c').getDescribe().getLabel() + ']: ' + pp.Project_Name__c + ', ' : '';
                    u.Non_AECOM_Projects_Summary__c += String.isNotBlank(pp.Project_Role__c) ? '[' + projectFields.get('Project_Role__c').getDescribe().getLabel() + ']: ' + pp.Project_Role__c + ', ' : '';
                    u.Non_AECOM_Projects_Summary__c += String.isNotBlank(pp.Client__c) ? '[' + Label.Client_Name + ']: ' + pp.Client__c + ', ' : '';
                    u.Non_AECOM_Projects_Summary__c += String.isNotBlank(pp.Project_Group_Editable__c) ? '[' + Label.Project_Group + ']: ' + pp.Project_Group_Editable__c + ', ' : '';
                    u.Non_AECOM_Projects_Summary__c += String.isNotBlank(pp.Location_Country__c) ? '[' + Label.Location_Country + ']: ' + pp.Location_Country__c + ', ' : '';
                    if (pp.Date_Involvement_Started__c != null) {
                        u.Non_AECOM_Projects_Summary__c += '[' + Label.Date_Involvement_Started + ']: ' + pp.Date_Involvement_Started__c.format() + ', ';
                    }
                    if (pp.Date_Involvement_Ended__c != null) {
                        u.Non_AECOM_Projects_Summary__c += '[' + Label.Date_Involvement_Ended + ']: ' + pp.Date_Involvement_Ended__c.format() + ', ';
                    }
                    u.Non_AECOM_Projects_Summary__c += String.isNotBlank(pp.Description__c) ? '[' + projectFields.get('Description__c').getDescribe().getLabel() + ']: ' + pp.Description__c : '';
                    u.Non_AECOM_Projects_Summary__c += String.isNotBlank(u.Non_AECOM_Projects_Summary__c) ? '\r\n' : '';

                    // set limit reached and add indicator that more data exists but field cannot hold any more
                    if (u.Non_AECOM_Projects_Summary__c.length() >= nonAecomLimit) {
                        nonAecomLimitReached = true;
                        u.Non_AECOM_Projects_Summary__c = u.Non_AECOM_Projects_Summary__c.subString(0, nonAecomLimit - 3) + '...';
                    }
                }

                //Break out of this loop, no point if we're not adding anything
                if (aecomLimitReached && nonAecomLimitReached) {
                    break;
                }
            }
        }

        update users;
    }

    public Boolean getIsContentManager() {
        return Profile_Info__c.getInstance().Is_Content_Manager__c;
    }
}