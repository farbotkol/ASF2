public class ECO_Billingtriggers{


public static void updateCustomername(list<billing__c> billinglist){
    list<string> Accountnumlist = new list<string>();
    map<string,string> Accountmap = new map<string,string>();
    for(Billing__c b:billinglist){
        if(b.customernumber__c !=null)
        {
            Accountnumlist.add(b.customernumber__c);
        }
    }
    if(Accountnumlist.size()>0)
    {
        for(Account acc:[select id,name,OracleCustomerNumber__c from account where  OracleCustomerNumber__c IN:Accountnumlist]){
            Accountmap.put(acc.OracleCustomerNumber__c,acc.name);
        }
        for(Billing__c b:billinglist){
            if(accountmap.containskey(b.customernumber__c))
            {
                b.customername__c = accountmap.get(b.customernumber__c);
            }
        }
    
    }
}



}