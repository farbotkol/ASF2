global with sharing class ECO_PMD_CostDetail_Controller {
   
	public ECO_PMD_CostDetail_Controller() {
    }

    private final pse__Proj__c oProject ;
    
    public string locale { get {return UserInfo.getLocale().replace('_', '-');} }
  
    public ECO_PMD_ProjectWrapper wrapper { get; set; }

    public string projectName;

    public string getProjectName() {
        return projectName;
    }

    public void setProjectName(string prjId) {
        pse__Proj__c project = [select Name, OracleProjectNumber__c
                                from pse__Proj__c where Id = :prjId];
        projectName = project.OracleProjectNumber__c + ' - ' + project.Name;
    }

    @RemoteAction @ReadOnly
    global static List<CostDist> GetCostDistLines(String projectId, Id offsetId, String layout) // projectNum)
    {
        //projectNum like '60214130'
        //String projectId = 'a32e00000002t8x'; //
        String offsetIdSearch = (offsetId==null)?'0':offsetId;

        String layoutClause;

        if (layout == 'LabourHours' || layout == 'LabourCost') {
            layoutClause = ' and ExpenditureItem__r.ExpenditureType__c like \'LAB%\'';
        } else if (layout == 'ODCExpenses') {
            layoutClause = ' and (not ExpenditureItem__r.ExpenditureType__c like \'LAB%\')'
                + ' and (not ExpenditureItem__r.ExpenditureType__c like \'CON%\')'
                + ' and (not ExpenditureItem__r.ExpenditureType__c like \'SUBC%\')';
        } else if (layout == 'ODCSubs') {
            layoutClause = ' and (ExpenditureItem__r.ExpenditureType__c like \'CON%\''
                + ' or ExpenditureItem__r.ExpenditureType__c like \'SUBC%\')';
        } else { 
            layoutClause = '';
        }

        List<CostDistLine__c> costDistLines = Database.query('select Id, PAPeriodName__c'
                + ',PADate__c'
                + ',GLPeriodName__c'
                + ',ProjectFunctionalCurrencyCode__c'
                + ',ProjectFunctionalBurdenedCost__c'
                + ',ProjectCurrencyCode__c'
                + ',ProjectBurdenedCost__c'
                + ', ExpenditureItem__r.PersonId__c'
                + ', ExpenditureItem__r.ExpenditureType__c'
                + ', ExpenditureItem__r.ExpenditureItemDate__c'
                + ', ExpenditureItem__r.VendorId__c'
                + ', ExpenditureItem__r.ExpenditureOrgId__c'
                + ', ExpenditureItem__r.Quantity__c'
                + ', ExpenditureItem__r.BillRate__c'
                + ', ExpenditureItem__r.BillAmount__c'
                + ', ExpenditureItem__r.BillableFlag__c'
                + ', ExpenditureItem__r.AP_InvoiceImageFileURL__c'
                + ', ExpenditureItem__r.InvoiceNumber__c'
                + ', ExpenditureItem__r.VoucherNumber__c'
                + ', ExpenditureItem__r.ProjectTask__r.Name'
                + ', ExpenditureItem__r.ProjectTask__r.ProjectTaskNumber__c'
                + ' from CostDistLine__c'
                + ' where ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id = :projectId'
                + layoutClause
                + ' and Id > :offsetIdSearch ORDER BY Id ASC LIMIT '+'2500');


        //EMPLOYEE DETAILS
        List<AggregateResult> groupedPeople = [select ExpenditureItem__r.PersonId__c
                from CostDistLine__c
                where ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id = :projectId
                group by ExpenditureItem__r.PersonId__c
                limit 500];

        List<string> personIds = new List<string>();
        for (AggregateResult ar : groupedPeople)
        {
            personIds.add((string)ar.get('PersonId__c'));
        }
        System.debug(personIds);

        Map<string, Contact> employees = new Map<string,Contact>();
        for(Contact e : [SELECT Person_ID__c, psa_report__Resource_Name__c, JobName__c , OracleContactID__c
                    FROM Contact WHERE Person_ID__c != '' and Person_ID__c IN :personIds])
        {
            employees.put(e.Person_ID__c, e);
        }
        System.debug('lfxxxx' +  employees);


        //VENDER/ACCOUNT DETAILS
        List<AggregateResult> groupedVendors = [select ExpenditureItem__r.VendorId__c
                from CostDistLine__c
                where ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id = :projectId
                group by ExpenditureItem__r.VendorId__c
                limit 500];

        List<string> vendorIds = new List<string>();
        for (AggregateResult ar : groupedVendors)
        {
            vendorIds.add((string)ar.get('VendorId__c'));
        }
        System.debug(vendorIds);

        Map<string, Account> vendors = new Map<string,Account>();
        for(Account c : [SELECT OracleVendorID__c, name
                    FROM Account WHERE OracleVendorID__c != '' and OracleVendorID__c IN :vendorIds])
        {
            vendors.put(c.OracleVendorID__c, c);
        }
        System.debug('lfxxxx' +  vendors);

        // ORGANISATION DETAILS
         List<AggregateResult> groupedOrgs = [select ExpenditureItem__r.ExpenditureOrgId__c
                from CostDistLine__c
                where ExpenditureItem__r.ProjectTask__r.pse__Project__r.Id = :projectId
                group by ExpenditureItem__r.ExpenditureOrgId__c
                limit 500];

        List<string> orgIds = new List<string>();
        for (AggregateResult ar : groupedOrgs)
        {
            orgIds.add((string)ar.get('ExpenditureOrgId__c'));
        }
        System.debug(orgIds);

        Map<string, OrganizationString__c> orgs = new Map<string,OrganizationString__c>();
        for(OrganizationString__c o : [SELECT OperatingGroup__c, OrgID__c, GeographyName__c, Region__c
                        , District__c, BusinessLineName__c, SubBusinessLineName__c
                        FROM OrganizationString__c WHERE OrgID__c IN :orgIds])
        {
            orgs.put(o.OrgID__c, o);
        }
        System.debug('lfxxxx' +  orgs);



        // Assemble the joins

        List<CostDist> costdists = new List<CostDist>();
        for(CostDistLine__c item : costDistLines) {
            System.debug('lfxxxx2' +  item);

            CostDist costdist = new CostDist();
            //System.debug('lfxxxx3' +  users.get(item.PersonId__c));

            try
            {
                if (item.ExpenditureItem__r.PersonId__c <> '')
                {
                    Contact employee = employees.get(item.ExpenditureItem__r.PersonId__c);
                    costdist.EmployeeNumber = employee.OracleContactID__c ;
                    costdist.EmployeeName = employee.psa_report__Resource_Name__c;
                    costdist.EmployeeClassification = employee.JobName__c;
                 }
            }catch(Exception ex){}

            try
            {
                if (item.ExpenditureItem__r.VendorId__c <> '')
                {
                    Account vendor = vendors.get(item.ExpenditureItem__r.VendorId__c);
                    costdist.VenderName = vendor.Name ;
                 }
            }catch(Exception ex){}

            try
            {
                if (item.ExpenditureItem__r.ExpenditureOrgId__c <> '')
                {
                    OrganizationString__c orgstr = orgs.get(item.ExpenditureItem__r.ExpenditureOrgId__c);
                    costdist.OperatingGroup = orgstr.OperatingGroup__c ;
                    costdist.GeographyName = orgstr.GeographyName__c ;
                    costdist.Region = orgstr.Region__c ;
                    costdist.District = orgstr.District__c ;
                    costdist.BusinessLineName = orgstr.BusinessLineName__c ;
                    costdist.SubBusinessLineName = orgstr.SubBusinessLineName__c ;
                 }
            }catch(Exception ex){}


            costdist.CostDistLine_Id = item.Id;
            costdist.CostDistLine_PAPeriodName =item.PAPeriodName__c;
            costdist.CostDistLine_PADate = item.PADate__c;
            costdist.CostDistLine_GLPeriodName =item.GLPeriodName__c;
            costdist.CostDistLine_ProjectFunctionalCurrencyCode =item.ProjectFunctionalCurrencyCode__c;
            costdist.CostDistLine_ProjectFunctionalBurdenedCost =item.ProjectFunctionalBurdenedCost__c;
            costdist.CostDistLine_ProjectCurrencyCode =item.ProjectCurrencyCode__c;
            costdist.CostDistLine_ProjectBurdenedCost =item.ProjectBurdenedCost__c;

            costdist.ExpenditureItem_PersonId =item.ExpenditureItem__r.PersonId__c;
            costdist.ExpenditureItem_ExpenditureType =item.ExpenditureItem__r.ExpenditureType__c;
            costdist.ExpenditureItem_ExpenditureItemDate  =item.ExpenditureItem__r.ExpenditureItemDate__c;
            costdist.ExpenditureItem_VendorId  =item.ExpenditureItem__r.VendorId__c;
            costdist.ExpenditureItem_ExpenditureOrgId  =item.ExpenditureItem__r.ExpenditureOrgId__c;
            costdist.ExpenditureItem_Quantity  =item.ExpenditureItem__r.Quantity__c;
            costdist.ExpenditureItem_BillRate  =item.ExpenditureItem__r.BillRate__c;
            costdist.ExpenditureItem_BillAmount  =item.ExpenditureItem__r.BillAmount__c;
            costdist.ExpenditureItem_BillableFlag  =item.ExpenditureItem__r.BillableFlag__c;
            costdist.ExpenditureItem_AP_InvoiceImageFileURL  =item.ExpenditureItem__r.AP_InvoiceImageFileURL__c;
            costdist.ExpenditureItem_InvoiceNumber  =item.ExpenditureItem__r.InvoiceNumber__c;
            costdist.ExpenditureItem_VoucherNumber  =item.ExpenditureItem__r.VoucherNumber__c;
            costdist.ExpenditureItem_ProjectTaskName  =item.ExpenditureItem__r.ProjectTask__r.Name;
            costdist.ExpenditureItem_ProjectTaskNumber  =item.ExpenditureItem__r.ProjectTask__r.ProjectTaskNumber__c;
            costdists.add(costdist);
        }

        return costdists;
    }



     global class CostDist{

        public id CostDistLine_Id {get; set;}
        public string CostDistLine_PAPeriodName {get; set;}
        public date CostDistLine_PADate {get; set;}
        public string CostDistLine_GLPeriodName {get; set;}
        public string  CostDistLine_ProjectFunctionalCurrencyCode {get; set;}
        public decimal CostDistLine_ProjectFunctionalBurdenedCost {get; set;}
        public string CostDistLine_ProjectCurrencyCode {get; set;}
        public decimal CostDistLine_ProjectBurdenedCost {get; set;}


        public string ExpenditureItem_PersonId {get; set;}
        public string ExpenditureItem_ExpenditureType  {get; set;}
        public date ExpenditureItem_ExpenditureItemDate  {get; set;}
        public string ExpenditureItem_VendorId  {get; set;}
        public string ExpenditureItem_ExpenditureOrgId  {get; set;}
        public decimal ExpenditureItem_Quantity  {get; set;}
        public decimal ExpenditureItem_BillRate  {get; set;}
        public decimal ExpenditureItem_BillAmount  {get; set;}
        public string ExpenditureItem_BillableFlag  {get; set;}
        public string ExpenditureItem_AP_InvoiceImageFileURL  {get; set;}
        public string ExpenditureItem_InvoiceNumber  {get; set;}
        public string ExpenditureItem_VoucherNumber  {get; set;}
        public string ExpenditureItem_ProjectTaskName  {get; set;}
        public string ExpenditureItem_ProjectTaskNumber  {get; set;}

        public string EmployeeNumber {get; set;}
        public string EmployeeName {get; set;}
        public string EmployeeClassification {get; set;}

        public string VenderName  {get; set;}

        public string OperatingGroup {get; set;}
        public string GeographyName {get; set;}
        public string Region {get; set;}
        public string District {get; set;}
        public string BusinessLineName {get; set;}
        public string SubBusinessLineName {get; set;}

        /*public id userId {get; set;}
        public string userName {get; set;}
        public string personId {get; set;}
        public id expendItemId {get; set;}
        public string expendItemName {get; set;}
        */

    }

}