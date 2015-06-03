public with sharing class ECO_ClassificationEditorController {

	public pse__Proj__c oProject {get; set;}
    public List<FieldSetMember> lClassifications {get; set;}

    public ECO_ClassificationEditorController(ApexPages.StandardController stdController) {
        List<String> lClassificationPathNames = new List<String>();
        lClassificationPathNames.add('PrimaryOrganization__c');
        for (FieldSetMember oFSM : SObjectType.pse__Proj__c.FieldSets.Project_Classifications.getFields()) {
            lClassificationPathNames.add(oFSM.getFieldPath());
        }

        stdController.addFields(lClassificationPathNames);
        
        this.oProject = (pse__Proj__c) stdController.getRecord();
        List<OrganizationString__c> lOrganizationStrings = new List<OrganizationString__c>();
        OrganizationString__c oOrganizationString = new OrganizationString__c();
        
		if (this.oProject.PrimaryOrganization__c != NULL) {
	        String sSOQL = 'SELECT id';
	        for (FieldSetMember oFSM : SObjectType.pse__Proj__c.FieldSets.Project_Classifications.getFields()) {
	            sSOQL += ', ' + oFSM.getFieldPath();
	        }
	        sSOQL += ' FROM OrganizationString__c';
	        sSOQL += ' WHERE Id = \'' + this.oProject.PrimaryOrganization__c + '\''; 
	        System.debug(sSOQL);
	        lOrganizationStrings = Database.query(sSOQL);
		}

        if (lOrganizationStrings.size() > 0) {
            oOrganizationString = lOrganizationStrings.get(0);
        } else {
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Organization String Found!'));
            /*
            ApexPages.addMessages(new ECO_DBExceptionNamespace.NoDataException('Opening Project Classifications Editor', 
            												 '1_1_1',
            												 'No Organization String Found!'));
            */
            return;
        }

        lClassifications = new List<FieldSetMember>();
        for (FieldSetMember oFSM : SObjectType.pse__Proj__c.FieldSets.Project_Classifications.getFields()) {
            String sOrganizationStringValue = (String) oOrganizationString.get(oFSM.getFieldPath());

            if (sOrganizationStringValue == 'Include') {
                lClassifications.add(oFSM);
            } else if (sOrganizationStringValue == 'Required') {
                lClassifications.add(oFSM);
            } else if (sOrganizationStringValue != 'Exclude') {
                lClassifications.add(oFSM);
                if (oProject.get(oFSM.getFieldPath()) == NULL || oProject.get(oFSM.getFieldPath()) == '') {
                    oProject.put(oFSM.getFieldPath(), sOrganizationStringValue);
                }
            }
        } // end of for
    }
}