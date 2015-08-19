public class ECO_BillRateManagement {
	
	String agreementId = '';
	public list<BillRate__c> billRates {get;set;}
	public BillRate__c newBillRate {get; set;}
	public BillRatePeriod__c newBillRatePeriod {get; set;}
	public Boolean creatingNewBillRatePeriod {get; set;}
	public Boolean creatingNewBillRate {get; set;}
	public Agreement__c agreement {get;set;}
	public map<String, list<BillRatePeriod__c>> laborCategoryToBillRatePeriodMap;
	public map<Id,BillRatePeriod__c> billRatePeriodMap;
	//public map<String, list<BillRate__c>> laborCategoryBillRateMap {get; set;}
	public map<String, BillRate__c> billRatePeriodCategoryRateMap {get; set;}
	public String updatedKey {get; set;}
	public Decimal updatedValue {get; set;}
	
	public ECO_BillRateManagement()
	{
		laborCategoryToBillRatePeriodMap = new map<String, list<BillRatePeriod__c>>();
		
		agreementId = ApexPages.currentPage().getParameters().get('AgreementId');
		agreement = [select Id, Name, FundingCurrencyCode__c, AgreementNumber__c from Agreement__c where Id = :agreementId];
		billRates = [select Id, Name, BillRatePeriod__c, LaborCategory__c, BillRate__c from BillRate__c where Agreement__c = :agreementId];
		billRatePeriodMap = new map<Id,BillRatePeriod__c>([select Id, BillRateStart__c, BillRateEnd__c from BillRatePeriod__c where Agreement__c = :agreementId]);
		//laborCategoryBillRateMap = new map<String, list<BillRate__c>>();
		billRatePeriodCategoryRateMap = new map<String, BillRate__c>();
		for(BillRate__c billRate:billRates)
		{
			if(billRatePeriodCategoryRateMap.get(billRate.BillRatePeriod__c + '-' + billRate.LaborCategory__c) == null)
				billRatePeriodCategoryRateMap.put(billRate.BillRatePeriod__c + '-' + billRate.LaborCategory__c, billRate);
			
			if(laborCategoryToBillRatePeriodMap.get(billRate.LaborCategory__c) == null)
				laborCategoryToBillRatePeriodMap.put(billRate.LaborCategory__c, new list<BillRatePeriod__c>());	
			if(billRate.BillRatePeriod__c != null)
				laborCategoryToBillRatePeriodMap.get(billRate.LaborCategory__c).add(billRatePeriodMap.get(billRate.BillRatePeriod__c));				
		}
	}

	public void createNewBillRate()
	{
		creatingNewBillRate = true;
		newBillRate = new BillRate__c(Agreement__c = agreementId);		
	}
	
	public void createNewBillRatePeriod()
	{
		creatingNewBillRatePeriod = true;
		newBillRatePeriod = new BillRatePeriod__c(Agreement__c = agreementId);	
	}	
	
	public PageReference returnToAgreement()
	{
		return new PageReference('/apex/ECO_AgreementView?Id=' + agreement.Id);
	}
	
	public void updateBillRateApex()
	{
		if(billRatePeriodCategoryRateMap.get(updatedKey) != null)
			billRatePeriodCategoryRateMap.get(updatedKey).BillRate__c = updatedValue;
	}
	
	public void cancelNewBillRate()
	{
		creatingNewBillRate = false;
	}
	
	public void saveNewBillRate()
	{
		if(billRatePeriodMap.values().size() == 0)
			insert newBillRate;
		else
		{
			string laborCategory = newBillRate.LaborCategory__c;
			list<BillRate__c> lBillRates = new list<BillRate__c>();
			for(BillRatePeriod__c lbillRatePeriod:billRatePeriodMap.values())
			{
				newBillRate.BillRate__c = 0;
				newBillRate.BillRatePeriod__c = lbillRatePeriod.Id;
				lBillRates.add(newBillRate);
				if(laborCategoryToBillRatePeriodMap.get(newBillRate.LaborCategory__c)==null)
					laborCategoryToBillRatePeriodMap.put(newBillRate.LaborCategory__c, new list<BillRatePeriod__c>());
				laborCategoryToBillRatePeriodMap.get(newBillRate.LaborCategory__c).add(lbillRatePeriod);

				//if(laborCategoryBillRateMap.get(newBillRate.LaborCategory__c)==null)
				//	laborCategoryBillRateMap.put(newBillRate.LaborCategory__c, new list<BillRate__c>());
				//laborCategoryBillRateMap.get(newBillRate.LaborCategory__c).add(newBillRate);
				billRatePeriodCategoryRateMap.put(lbillRatePeriod.Id +'-' + laborCategory, newBillRate);	
				newBillRate = new BillRate__c(Agreement__c = agreementId, LaborCategory__c = laborCategory);					
			}
			if(lBillRates.size() > 0)
				insert lBillRates;
		}				
		creatingNewBillRate = false;
	}
	
	public set<String> getLaborCategories()
	{
		set<String> keysetValues = new set<String>();
		if(laborCategoryToBillRatePeriodMap.keyset() != null)
			return laborCategoryToBillRatePeriodMap.keyset();
		return keysetValues;
	}
	
	public list<BillRatePeriod__c> getPeriods()
	{
		if(billRatePeriodMap.values() != null)
			return billRatePeriodMap.values();
		return new list<BillRatePeriod__c>();
	}
	
	public void saveBillRates()
	{
		update billRatePeriodCategoryRateMap.values();
	}
	
	public void cancelNewBillRatePeriod()
	{
		creatingNewBillRatePeriod = false;
	}
	
	public void saveNewBillRatePeriod()
	{
		if(laborCategoryToBillRatePeriodMap.keyset().size() == 0)
		{	
			insert newBillRatePeriod;
			billRatePeriodMap.put(newBillRatePeriod.Id, newBillRatePeriod);
		}
		else
		{
			insert newBillRatePeriod;
			list<BillRate__c> lBillRates = new list<BillRate__c>();
			if(billRatePeriodMap.keyset().size() == 0)
			{
				
			}
			else
			{
				for(String laborCategory:laborCategoryToBillRatePeriodMap.keyset())
				{
					newBillRate = new BillRate__c(Agreement__c = agreementId, BillRatePeriod__c = newBillRatePeriod.Id, LaborCategory__c = laborCategory, BillRate__c = 0);
					lBillRates.add(newBillRate);
					laborCategoryToBillRatePeriodMap.get(laborCategory).add(newBillRatePeriod);
					billRatePeriodMap.put(newBillRatePeriod.Id, newBillRatePeriod);
					billRatePeriodCategoryRateMap.put(newBillRatePeriod.Id +'-' + laborCategory, newBillRate);				
				}
			}
			if(lBillRates.size() > 0)
				insert lBillRates;
		}		
				
		creatingNewBillRatePeriod = false;
		
	}	
}