global with sharing class ECO_PMD_AccountsReceivable_Controller {

    public string locale { get {return UserInfo.getLocale().replace('_', '-');} }

    private final pse__Proj__c project;

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public ECO_PMD_AccountsReceivable_Controller(ApexPages.StandardController stdController) {
        //stdController.addFields(new List<string>{'OracleProjectNumber__c', 'Name'});
        this.project = (pse__Proj__c)stdController.getRecord();
    }

    @RemoteAction @ReadOnly
    public static List<Billing> GetBillingData(String projectId) {
        List<Billing__c> billingData = [select DraftInvoiceNumber__c
            , CustomerNumber__c
            , InvoiceDate__c
            , BillThroughDate__c
            , CurrencyIsoCode
            , TaxAmount__c
            , InvoiceAmount__c
            , RetentionAmount__c
            , BalanceDue__c
            , AccountedTaxAmount__c
            , ProjectFunctionalInvoiceAmount__c
            , AccountedBalanceDue__c
            , ProjectFunctionalRetentionAmount__c
            , PreTaxInvoiceAmount__c
            , ProjectFunctionalPreTaxInvoiceAmoun__c
            , AR0to30__c
            , AR31to60__c
            , AR61to90__c
            , AR91to180__c
            , AR181Plus__c

            from Billing__c
            where ProjectNumber__c = :projectId];

        List<AggregateResult> groupedCustomers = [select CustomerNumber__c
            from Billing__c
            where ProjectNumber__c = :projectId
            group by CustomerNumber__c
            limit 500];

        List<string> customerNumbers = new List<string>();
        for (AggregateResult ar : groupedCustomers)
        {
            customerNumbers.add((string)ar.get('CustomerNumber__c'));
        }

        Map<string, Account> customers = new Map<string,Account>();
        for(Account c : [SELECT OracleCustomerNumber__c, name
                    FROM Account WHERE OracleCustomerNumber__c != '' and OracleCustomerNumber__c IN :customerNumbers])
        {
            customers.put(c.OracleCustomerNumber__c, c);
        }

        List<Billing> billings = new List<Billing>();
        for(Billing__c item : billingData) {
            Billing billing = new Billing();

            try
            {
                if (item.CustomerNumber__c <> '')
                   {
                    Account customer = customers.get(item.CustomerNumber__c);
                    billing.CustomerName = customer.Name;
                }
            } catch(Exception ex){}

            billing.DraftInvoiceNumber = item.DraftInvoiceNumber__c;
            billing.CustomerNumber = item.CustomerNumber__c;
            billing.InvoiceDate = item.InvoiceDate__c;
            billing.BillThroughDate = item.BillThroughDate__c;
            billing.CurrencyIsoCode = item.CurrencyIsoCode;
            billing.TaxAmount = item.TaxAmount__c;
            billing.InvoiceAmount = item.InvoiceAmount__c;
            billing.RetentionAmount = item.RetentionAmount__c;
            billing.BalanceDue = item.BalanceDue__c;
            billing.AccountedTaxAmount = item.AccountedTaxAmount__c;
            billing.ProjectFunctionalInvoiceAmount = item.ProjectFunctionalInvoiceAmount__c;
            billing.AccountedBalanceDue = item.AccountedBalanceDue__c;

            //new
            billing.PreTaxInvoiceAmount = item.PreTaxInvoiceAmount__c;
            billing.ProjectFunctionalPreTaxInvoiceAmount = item.ProjectFunctionalRetentionAmount__c;
            billing.ProjectFunctionalRetentionAmount = item.ProjectFunctionalRetentionAmount__c;
            billing.AR0to30 = item.AR0to30__c;
            billing.AR31to60 = item.AR31to60__c;
            billing.AR61to90 = item.AR61to90__c;
            billing.AR91to180 = item.AR91to180__c;
            billing.AR181Plus = item.AR181Plus__c;
            billings.add(billing);
        }

        return billings;
    }

    global class Billing {
        public string DraftInvoiceNumber {get; set;}
        public string CustomerNumber {get; set;}
        public string CustomerName {get; set;}
        public date InvoiceDate {get; set;}
        public date BillThroughDate {get; set;}
        public string CurrencyIsoCode {get; set;}
        public decimal TaxAmount {get; set;}
        public decimal InvoiceAmount {get; set;}
        public decimal RetentionAmount {get; set;}
        public decimal BalanceDue {get; set;}
        public decimal AccountedTaxAmount {get; set;}
        public decimal ProjectFunctionalInvoiceAmount {get; set;}
        public decimal ProjectFunctionalRetentionAmount {get; set;}
        public decimal AccountedBalanceDue {get; set;}

        // new l.f
        public decimal PreTaxInvoiceAmount {get; set;}
        public decimal ProjectFunctionalPreTaxInvoiceAmount {get; set;}
        public decimal AR0to30 {get; set;}
        public decimal AR31to60 {get; set;}
        public decimal AR61to90 {get; set;}
        public decimal AR91to180 {get; set;}
        public decimal AR181Plus {get; set;}

       }
}