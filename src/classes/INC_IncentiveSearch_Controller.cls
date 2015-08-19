public without sharing class INC_IncentiveSearch_Controller {
	
	public String projectNumber{get;set;}
	public String projectName {get;set;}
	public String projectManager {get;set;}
	public String customerName {get;set;}
	public String blankValue{get;set;}
	public List<criteriaRow> searchCriteria{get;set;}
	public list<IncentiveProject__c> lResults {get;set;}
	public Integer removeRow {
        get;
        // *** setter is NOT being called ***
        set {
            removeRow = value;
            System.debug('value: '+value);
        }
    }
	private String sProjectName;
	private String sProjectNumber;
	private String sCustomerName;
	private String sProjectManager;

	public INC_IncentiveSearch_Controller() {
		searchCriteria = new list<criteriaRow>();
		addRow();
		
	}

	public PageReference addRow(){
		criteriaRow ocriteriaRow;
		if(searchCriteria != null && searchCriteria.size() > 0){
			/*if(searchCriteria[searchCriteria.size() -1].criteria == 'PM'){
				if(IncProj.ProjectManager__c != null){
		   			searchCriteria[searchCriteria.size() -1].value = IncProj.ProjectManager__c;
				}else{
					searchCriteria[searchCriteria.size() -1].value = '';
		   		}
			} */

			if((searchCriteria[searchCriteria.size() -1].value != null && searchCriteria[searchCriteria.size() -1].value !='') ||
				searchCriteria[searchCriteria.size() -1].IncProj.ProjectManager__c != null){
			  	if(searchCriteria.size() <4){
			  		ocriteriaRow = new criteriaRow(searchCriteria[searchCriteria.size() -1]);
					searchCriteria.add(oCriteriaRow);
				}
			}
		}else{
			ocriteriaRow = new criteriaRow(null);
			searchCriteria.add(ocriteriaRow);
		}

		return null;
	}

	public PageReference removeRow(){
		if(searchCriteria != null && searchCriteria.size() == 1){
			return null;
		}
		Integer iCurrentRow = 0;
		Integer rowToRemove = 0;
		criteriaRow removalrow;
		for(criteriaRow CR: searchCriteria){
			if(CR.Row == removeRow){
				rowToRemove = iCurrentRow;
				removalrow = CR;
			}else{
				if(CR.Row > removeRow){
					CR.Row = CR.Row - 1;
				}
			}
			iCurrentRow ++;
		}
		searchCriteria.remove(rowToRemove);

		return null;
	}

	public PageReference search(){
		if(validateCriteria()){
			String sQuery = buildQuery();
			System.Debug(logginglevel.error,'sQuery: ' + sQuery + ' ' + sProjectManager);
			if(sQuery != null && sQuery.length() > 0){
				lResults = Database.query(sQuery);
			}
			if(lResults.size() > 200){
				apexPages.addMessage(new apexPages.message(apexPages.Severity.Info,'Your search returned more that 200 results.  Only the first 200 are displayed.'));
			}
			if(lResults == null || lResults.size() == 0){
				apexPages.addMessage(new apexPages.message(apexPages.Severity.Info,'Your search returned no results.'));
			}
			System.Debug(logginglevel.error,'lResults: ' + lResults);
		}else{
			apexPages.addMessage(new apexPages.message(apexPages.Severity.Error,'Please review your criteria for duplicates or missing values'));
		}
		return null;
	}

	public boolean validateCriteria(){
		set<String> sCompare = new set<String>();
		boolean bReturn = true;
		for(criteriaRow CR: searchCriteria){
			if(sCompare != null && sCompare.contains(CR.criteria)){
				bReturn = false;
				break;
			}else{
				sCompare.add(Cr.criteria);
			}
			System.Debug(logginglevel.error,'CR: ' + CR);
			if((Cr.value == null || CR.value =='') &&
			   CR.IncProj.ProjectManager__c == null){
				bReturn = false;
				break;
			}

		}

		return bReturn;
	}
/*
    Project Numberx
    Project Namex
    Project Managerx
    Customer Namex
    Aggregated Number
    Aggregated Projects
    Approved NSR Budgetx
    Owner
    Enrollment Statusx
*/

	private String buildQuery(){
		String sQuery = 'Select ID' + 
								+',EnrollmentPlan__c'
								+',EnrollmentStatus__c'
								+',Name'
								+',ProjectID__c'
								+',ProjectManager__c'
								+',CustomerName__c'
								+',ApprovedNSRBudget__c'
								+',OwnerID'
								+' From IncentiveProject__c'
								+' Where ';
		Integer i = 0;
		System.Debug(logginglevel.error,'searchCriteria ' + searchCriteria.size());
		for(criteriaRow CR: searchCriteria){
			boolean blank = false;
			i ++;
			if(CR.criteria == 'PM'){
			 	sProjectManager = cr.Value;
				if(cr.Value == null || cr.Value == ''){
						sProjectManager = Cr.IncProj.ProjectManager__c;
				}
				if(sProjectManager != null || sProjectManager == ''){
					sQuery += 'ProjectManager__c =: sProjectManager';
				}else{
					blank = true;
				}
				
			}
			if(CR.criteria == 'PN')
			{
				if(cr.Value != null && cr.Value != ''){
					sProjectName = '%'+ CR.value + '%';
					sQuery += 'Name LIKE : sProjectName';
				}else{
					blank = true;
				}
			}
			if(CR.criteria == 'CN'){
				if(cr.Value != null && cr.Value != ''){
					sCustomerName = '%'+ CR.Value + '%';
					System.Debug(logginglevel.error,'sCustomerName ' + sCustomerName);
					sQuery += 'CustomerName__c LIKE : sCustomerName';
				}else{
					blank = true;
				}
			}
			if(CR.criteria== 'PNUM'){
				if(cr.Value != null && cr.Value != ''){
					sProjectNumber = CR.Value;
					sQuery += 'ProjectID__c =: sProjectNumber';
				}else{
					blank = true;
				}
			}

			if(i < searchCriteria.size() && !blank){
				sQuery += ' AND ';
			}
		}
		sQuery += ' limit 201';
		return sQuery;
	}

	public boolean isNull(String s){
		boolean bReturn = false;
		if(s == null || s == ''){bReturn = true;}
		return bReturn; 
	}

	public class criteriaRow{
		public Integer row{get;set;}
		public string criteria{get;set;}
		public string value{get;set;}
		public list<SelectOption> criteriaRowlist {get;set;}
		public IncentiveProject__c IncProj{get;set;}
	
		public criteriaRow(criteriaRow previousRow){

			if(previousRow != null){
				System.Debug(logginglevel.error,'Row: ' + previousRow.Row);
				row = previousRow.row + 1;
			}else{
				row = 1;
			}
			IncProj = new IncentiveProject__c();
			criteriaRowlist = new list<SelectOption>();
			buildSelectOptions(previousRow);


		}
	
		private void buildSelectOptions(criteriaRow previousRow){
				criteriaRowList.add(new SelectOption('',''));
				criteriaRowlist.add(new SelectOption('PM','Project Manager'));
				criteriaRowlist.add(new SelectOption('PN','Project Name'));
				criteriaRowlist.add(new SelectOption('PNUM','Project Number'));
				criteriaRowlist.add(new SelectOption('CN','Customer Name'));
		}

	}

}