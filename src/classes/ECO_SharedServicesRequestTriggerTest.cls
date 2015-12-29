@isTest
private class ECO_SharedServicesRequestTriggerTest {
	
	@isTest static void testGeneration() {
		
		Account testAccount = new Account();
		testAccount.Name = 'test account';
		insert testAccount;

		Country__c c = new Country__c();
		c.name = 'test';
		insert c;

		State_Province_Emirate__c p  = new State_Province_Emirate__c();
		p.name = 'test';
		p.Country__c = c.id;
		insert p;


		//list<recordtype> listRecType = [select id from recordtype Where sObjectType = 'SharedServicesRequest__c' and (developername = 'CreateVendor' OR  developername = 'AddSite' OR developername ='CreateSub' OR  developername = 'CreateCustomer' ) ORDER BY developername ASC];

		list<recordtype> listRecType = [select id from recordtype Where sObjectType = 'SharedServicesRequest__c' and developername = 'CreateCustomer'];

		SharedServicesRequest__c sr = new SharedServicesRequest__c();
		sr.SkipValidation__c = true;
		sr.GenerateObjects__c= true;
		sr.AssigntoSharedServices__c = true;



		sr.recordtypeid = listRecType[0].id;

		sr.CustomerName__c = 'test';

		sr.ParentAccount__c = testAccount.id;
		sr.ClientGroup__c = 'test';
		sr.ClientSubgroup__c = 'test';
		sr.Reach__c = 'test';

		sr.SicCode__c = 'test';
		sr.SicDescription__c = 'test';
		sr.MKDenialStatus__c = 'test';
		sr.IntercompanyCustomer__c = 'test';

		//vendor fields
		sr.ParentAccount__c = testAccount.id;
		sr.VendorType__c = 'test';
		sr.SicCode__c = 'test';
		sr.SicDescription__c = 'test';
		sr.SocioMinorityOwned__c = true;
		sr.SocioNonProfit__c = true;

		sr.SocioSmallBusinessSB__c = true;
		sr.SocioLargeBusiness__c = true;
		sr.SocioVeteranOwnedVO__c = true;
		sr.SocioWomenOwnedWO__c = true;
		sr.SocioServiceDisabledVeteranOwnedSDVO__c = true;
		sr.Socio8aCertifiedFirms8a__c = true;
		sr.SocioAbilityOne__c = true;
		sr.SocioAlaskaNativeCorpandTriballyOwned__c = true;
		sr.EcoEconomicallyDisadvantagedWomanOwned__c = true;
		sr.SocioHistoricallyBlackCollegesandUniv__c = true;
		sr.SocioSmallDisadvantagedBusinessSDB__c = true;
		sr.MKDenialStatus__c = 'test';
		sr.SocioHUBZone__c = true;

		//sub
		sr.CustomerName__c = 'test';
		sr.ParentAccount__c = testAccount.id;
		sr.VendorType__c = 'test';
		sr.SicCode__c = 'test';
		sr.SicDescription__c = 'test';
		sr.SocioMinorityOwned__c = true;
		sr.SocioNonProfit__c = true;
		
		sr.SocioSmallBusinessSB__c = true;
		sr.SocioLargeBusiness__c = true;
		sr.SocioVeteranOwnedVO__c = true;
		sr.SocioWomenOwnedWO__c = true;
		sr.SocioServiceDisabledVeteranOwnedSDVO__c = true;
		sr.Socio8aCertifiedFirms8a__c = true;
		sr.SocioAbilityOne__c = true;
		sr.SocioAlaskaNativeCorpandTriballyOwned__c = true;
		sr.EcoEconomicallyDisadvantagedWomanOwned__c = true;
		sr.SocioHistoricallyBlackCollegesandUniv__c = true;
		sr.SocioSmallDisadvantagedBusinessSDB__c = true;
		sr.MKDenialStatus__c = 'test';
		sr.SocioHUBZone__c = true;		

		//Sites
		sr.Address1StreetPOBox__c = 'test';
		sr.City__c = 'test';
		sr.Country__c = 'Afghanistan';	
		sr.AddressIsPrimary__c = true;
		sr.StateProvinceEmirate__c = p.id;

		sr.BillingStreetPOBox__c = 'test';
		sr.BillingAddressCity__c = 'test';
		sr.BillingAddressCountry__c = 'Afghanistan';	
		sr.BillingAddress1isPrimary__c = false;
		sr.BillingStateProvinceEmirate__c = p.id;


		sr.RemitToAddressLine1__c = 'test';
		sr.RemitToCity__c = 'test';
		sr.RemitToCountry__c = 'Afghanistan';
		sr.RemitIsPrimaryAddress__c = false;
		sr.RemitToStateProvinceEmirate__c = p.id;


		//contacts
		sr.BillingContactLastName__c = 'test';
		sr.BillingContactFirstName__c = 'test';
		sr.BillingContactEmail__c = 'test@test.com';
		sr.BillingContactPhone__c = '1111111';


		sr.Contact1LastName__c = 'test1';
		sr.Contact1FirstName__c = 'test1';
		sr.Contact1EmailAddress__c = 'test@test2.com';
		sr.Contact1Phone__c = '2222222';		

		sr.Contact2LastName__c = 'test2';
		sr.Contact2FirstName__c = 'test2';
		sr.Contact2Email__c = 'test@test3.com';
		sr.Contact2Phone__c = '3333333';

		insert sr;

		update sr;

	}
	
	@isTest static void testGeneration2() {
		
		Account testAccount = new Account();
		testAccount.Name = 'test account';
		insert testAccount;

		Country__c c = new Country__c();
		c.name = 'test';
		insert c;

		State_Province_Emirate__c p  = new State_Province_Emirate__c();
		p.name = 'test';
		p.Country__c = c.id;
		insert p;


		//list<recordtype> listRecType = [select id from recordtype Where sObjectType = 'SharedServicesRequest__c' and (developername = 'CreateVendor' OR  developername = 'AddSite' OR developername ='CreateSub' OR  developername = 'CreateCustomer' ) ORDER BY developername ASC];

		list<recordtype> listRecType = [select id from recordtype Where sObjectType = 'SharedServicesRequest__c' and developername = 'CreateSub'];

		SharedServicesRequest__c sr = new SharedServicesRequest__c();
		sr.SkipValidation__c = true;
		sr.GenerateObjects__c= true;
		sr.AssigntoSharedServices__c = true;



		sr.recordtypeid = listRecType[0].id;

		sr.CustomerName__c = 'test';

		sr.ParentAccount__c = testAccount.id;
		sr.ClientGroup__c = 'test';
		sr.ClientSubgroup__c = 'test';
		sr.Reach__c = 'test';

		sr.SicCode__c = 'test';
		sr.SicDescription__c = 'test';
		sr.MKDenialStatus__c = 'test';
		sr.IntercompanyCustomer__c = 'test';

		//vendor fields
		sr.ParentAccount__c = testAccount.id;
		sr.VendorType__c = 'test';
		sr.SicCode__c = 'test';
		sr.SicDescription__c = 'test';
		sr.SocioMinorityOwned__c = true;
		sr.SocioNonProfit__c = true;

		sr.SocioSmallBusinessSB__c = true;
		sr.SocioLargeBusiness__c = true;
		sr.SocioVeteranOwnedVO__c = true;
		sr.SocioWomenOwnedWO__c = true;
		sr.SocioServiceDisabledVeteranOwnedSDVO__c = true;
		sr.Socio8aCertifiedFirms8a__c = true;
		sr.SocioAbilityOne__c = true;
		sr.SocioAlaskaNativeCorpandTriballyOwned__c = true;
		sr.EcoEconomicallyDisadvantagedWomanOwned__c = true;
		sr.SocioHistoricallyBlackCollegesandUniv__c = true;
		sr.SocioSmallDisadvantagedBusinessSDB__c = true;
		sr.MKDenialStatus__c = 'test';
		sr.SocioHUBZone__c = true;

		//sub
		sr.CustomerName__c = 'test';
		sr.ParentAccount__c = testAccount.id;
		sr.VendorType__c = 'test';
		sr.SicCode__c = 'test';
		sr.SicDescription__c = 'test';
		sr.SocioMinorityOwned__c = true;
		sr.SocioNonProfit__c = true;
		
		sr.SocioSmallBusinessSB__c = true;
		sr.SocioLargeBusiness__c = true;
		sr.SocioVeteranOwnedVO__c = true;
		sr.SocioWomenOwnedWO__c = true;
		sr.SocioServiceDisabledVeteranOwnedSDVO__c = true;
		sr.Socio8aCertifiedFirms8a__c = true;
		sr.SocioAbilityOne__c = true;
		sr.SocioAlaskaNativeCorpandTriballyOwned__c = true;
		sr.EcoEconomicallyDisadvantagedWomanOwned__c = true;
		sr.SocioHistoricallyBlackCollegesandUniv__c = true;
		sr.SocioSmallDisadvantagedBusinessSDB__c = true;
		sr.MKDenialStatus__c = 'test';
		sr.SocioHUBZone__c = true;		

		//Sites
		sr.Address1StreetPOBox__c = 'test';
		sr.City__c = 'test';
		sr.Country__c = 'Afghanistan';	
		sr.AddressIsPrimary__c = true;
		sr.StateProvinceEmirate__c = p.id;

		sr.BillingStreetPOBox__c = 'test';
		sr.BillingAddressCity__c = 'test';
		sr.BillingAddressCountry__c = 'Afghanistan';	
		sr.BillingAddress1isPrimary__c = false;
		sr.BillingStateProvinceEmirate__c = p.id;


		sr.RemitToAddressLine1__c = 'test';
		sr.RemitToCity__c = 'test';
		sr.RemitToCountry__c = 'Afghanistan';
		sr.RemitIsPrimaryAddress__c = false;
		sr.RemitToStateProvinceEmirate__c = p.id;


		//contacts
		sr.BillingContactLastName__c = 'test';
		sr.BillingContactFirstName__c = 'test';
		sr.BillingContactEmail__c = 'test@test.com';
		sr.BillingContactPhone__c = '1111111';


		sr.Contact1LastName__c = 'test1';
		sr.Contact1FirstName__c = 'test1';
		sr.Contact1EmailAddress__c = 'test@test2.com';
		sr.Contact1Phone__c = '2222222';		

		sr.Contact2LastName__c = 'test2';
		sr.Contact2FirstName__c = 'test2';
		sr.Contact2Email__c = 'test@test3.com';
		sr.Contact2Phone__c = '3333333';

		insert sr;

		update sr;

	}	

	@isTest static void testGeneration3() {
		
		Account testAccount = new Account();
		testAccount.Name = 'test account';
		insert testAccount;

		Country__c c = new Country__c();
		c.name = 'test';
		insert c;

		State_Province_Emirate__c p  = new State_Province_Emirate__c();
		p.name = 'test';
		p.Country__c = c.id;
		insert p;


		//list<recordtype> listRecType = [select id from recordtype Where sObjectType = 'SharedServicesRequest__c' and (developername = 'CreateVendor' OR  developername = 'AddSite' OR developername ='CreateSub' OR  developername = 'CreateCustomer' ) ORDER BY developername ASC];

		list<recordtype> listRecType = [select id from recordtype Where sObjectType = 'SharedServicesRequest__c' and developername = 'CreateVendor'];

		SharedServicesRequest__c sr = new SharedServicesRequest__c();
		sr.SkipValidation__c = true;
		sr.GenerateObjects__c= true;
		sr.AssigntoSharedServices__c = true;



		sr.recordtypeid = listRecType[0].id;

		sr.CustomerName__c = 'test';

		sr.ParentAccount__c = testAccount.id;
		sr.ClientGroup__c = 'test';
		sr.ClientSubgroup__c = 'test';
		sr.Reach__c = 'test';

		sr.SicCode__c = 'test';
		sr.SicDescription__c = 'test';
		sr.MKDenialStatus__c = 'test';
		sr.IntercompanyCustomer__c = 'test';

		//vendor fields
		sr.ParentAccount__c = testAccount.id;
		sr.VendorType__c = 'test';
		sr.SicCode__c = 'test';
		sr.SicDescription__c = 'test';
		sr.SocioMinorityOwned__c = true;
		sr.SocioNonProfit__c = true;

		sr.SocioSmallBusinessSB__c = true;
		sr.SocioLargeBusiness__c = true;
		sr.SocioVeteranOwnedVO__c = true;
		sr.SocioWomenOwnedWO__c = true;
		sr.SocioServiceDisabledVeteranOwnedSDVO__c = true;
		sr.Socio8aCertifiedFirms8a__c = true;
		sr.SocioAbilityOne__c = true;
		sr.SocioAlaskaNativeCorpandTriballyOwned__c = true;
		sr.EcoEconomicallyDisadvantagedWomanOwned__c = true;
		sr.SocioHistoricallyBlackCollegesandUniv__c = true;
		sr.SocioSmallDisadvantagedBusinessSDB__c = true;
		sr.MKDenialStatus__c = 'test';
		sr.SocioHUBZone__c = true;

		//sub
		sr.CustomerName__c = 'test';
		sr.ParentAccount__c = testAccount.id;
		sr.VendorType__c = 'test';
		sr.SicCode__c = 'test';
		sr.SicDescription__c = 'test';
		sr.SocioMinorityOwned__c = true;
		sr.SocioNonProfit__c = true;
		
		sr.SocioSmallBusinessSB__c = true;
		sr.SocioLargeBusiness__c = true;
		sr.SocioVeteranOwnedVO__c = true;
		sr.SocioWomenOwnedWO__c = true;
		sr.SocioServiceDisabledVeteranOwnedSDVO__c = true;
		sr.Socio8aCertifiedFirms8a__c = true;
		sr.SocioAbilityOne__c = true;
		sr.SocioAlaskaNativeCorpandTriballyOwned__c = true;
		sr.EcoEconomicallyDisadvantagedWomanOwned__c = true;
		sr.SocioHistoricallyBlackCollegesandUniv__c = true;
		sr.SocioSmallDisadvantagedBusinessSDB__c = true;
		sr.MKDenialStatus__c = 'test';
		sr.SocioHUBZone__c = true;		

		//Sites
		sr.Address1StreetPOBox__c = 'test';
		sr.City__c = 'test';
		sr.Country__c = 'Afghanistan';	
		sr.AddressIsPrimary__c = true;
		sr.StateProvinceEmirate__c = p.id;

		sr.BillingStreetPOBox__c = 'test';
		sr.BillingAddressCity__c = 'test';
		sr.BillingAddressCountry__c = 'Afghanistan';	
		sr.BillingAddress1isPrimary__c = false;
		sr.BillingStateProvinceEmirate__c = p.id;


		sr.RemitToAddressLine1__c = 'test';
		sr.RemitToCity__c = 'test';
		sr.RemitToCountry__c = 'Afghanistan';
		sr.RemitIsPrimaryAddress__c = false;
		sr.RemitToStateProvinceEmirate__c = p.id;


		//contacts
		sr.BillingContactLastName__c = 'test';
		sr.BillingContactFirstName__c = 'test';
		sr.BillingContactEmail__c = 'test@test.com';
		sr.BillingContactPhone__c = '1111111';


		sr.Contact1LastName__c = 'test1';
		sr.Contact1FirstName__c = 'test1';
		sr.Contact1EmailAddress__c = 'test@test2.com';
		sr.Contact1Phone__c = '2222222';		

		sr.Contact2LastName__c = 'test2';
		sr.Contact2FirstName__c = 'test2';
		sr.Contact2Email__c = 'test@test3.com';
		sr.Contact2Phone__c = '3333333';

		insert sr;

		update sr;

	}	

	@isTest static void testGeneration4() {
		
		Account testAccount = new Account();
		testAccount.Name = 'test account';
		insert testAccount;

		Country__c c = new Country__c();
		c.name = 'test';
		insert c;

		State_Province_Emirate__c p  = new State_Province_Emirate__c();
		p.name = 'test';
		p.Country__c = c.id;
		insert p;


		//list<recordtype> listRecType = [select id from recordtype Where sObjectType = 'SharedServicesRequest__c' and (developername = 'CreateVendor' OR  developername = 'AddSite' OR developername ='CreateSub' OR  developername = 'CreateCustomer' ) ORDER BY developername ASC];

		list<recordtype> listRecType = [select id from recordtype Where sObjectType = 'SharedServicesRequest__c' and developername = 'CreateCustomer'];

		SharedServicesRequest__c sr = new SharedServicesRequest__c();
		sr.SkipValidation__c = true;
		sr.GenerateObjects__c= true;
		sr.AssigntoSharedServices__c = true;



		sr.recordtypeid = listRecType[0].id;

		sr.CustomerName__c = 'test';

		sr.ParentAccount__c = testAccount.id;
		sr.ClientGroup__c = 'test';
		sr.ClientSubgroup__c = 'test';
		sr.Reach__c = 'test';

		sr.SicCode__c = 'test';
		sr.SicDescription__c = 'test';
		sr.MKDenialStatus__c = 'test';
		sr.IntercompanyCustomer__c = 'test';

		//vendor fields
		sr.ParentAccount__c = testAccount.id;
		sr.VendorType__c = 'test';
		sr.SicCode__c = 'test';
		sr.SicDescription__c = 'test';
		sr.SocioMinorityOwned__c = true;
		sr.SocioNonProfit__c = true;

		sr.SocioSmallBusinessSB__c = true;
		sr.SocioLargeBusiness__c = true;
		sr.SocioVeteranOwnedVO__c = true;
		sr.SocioWomenOwnedWO__c = true;
		sr.SocioServiceDisabledVeteranOwnedSDVO__c = true;
		sr.Socio8aCertifiedFirms8a__c = true;
		sr.SocioAbilityOne__c = true;
		sr.SocioAlaskaNativeCorpandTriballyOwned__c = true;
		sr.EcoEconomicallyDisadvantagedWomanOwned__c = true;
		sr.SocioHistoricallyBlackCollegesandUniv__c = true;
		sr.SocioSmallDisadvantagedBusinessSDB__c = true;
		sr.MKDenialStatus__c = 'test';
		sr.SocioHUBZone__c = true;

		//sub
		sr.CustomerName__c = 'test';
		sr.ParentAccount__c = testAccount.id;
		sr.VendorType__c = 'test';
		sr.SicCode__c = 'test';
		sr.SicDescription__c = 'test';
		sr.SocioMinorityOwned__c = true;
		sr.SocioNonProfit__c = true;
		
		sr.SocioSmallBusinessSB__c = true;
		sr.SocioLargeBusiness__c = true;
		sr.SocioVeteranOwnedVO__c = true;
		sr.SocioWomenOwnedWO__c = true;
		sr.SocioServiceDisabledVeteranOwnedSDVO__c = true;
		sr.Socio8aCertifiedFirms8a__c = true;
		sr.SocioAbilityOne__c = true;
		sr.SocioAlaskaNativeCorpandTriballyOwned__c = true;
		sr.EcoEconomicallyDisadvantagedWomanOwned__c = true;
		sr.SocioHistoricallyBlackCollegesandUniv__c = true;
		sr.SocioSmallDisadvantagedBusinessSDB__c = true;
		sr.MKDenialStatus__c = 'test';
		sr.SocioHUBZone__c = true;		

		//Sites
		sr.Address1StreetPOBox__c = 'test';
		sr.City__c = 'test';
		sr.Country__c = 'Afghanistan';	
		sr.AddressIsPrimary__c = false;
		sr.StateProvinceEmirate__c = p.id;

		sr.BillingStreetPOBox__c = 'test';
		sr.BillingAddressCity__c = 'test';
		sr.BillingAddressCountry__c = 'Afghanistan';	
		sr.BillingAddress1isPrimary__c = true;
		sr.BillingStateProvinceEmirate__c = p.id;


		sr.RemitToAddressLine1__c = 'test';
		sr.RemitToCity__c = 'test';
		sr.RemitToCountry__c = 'Afghanistan';
		sr.RemitIsPrimaryAddress__c = false;
		sr.RemitToStateProvinceEmirate__c = p.id;


		//contacts
		sr.BillingContactLastName__c = 'test';
		sr.BillingContactFirstName__c = 'test';
		sr.BillingContactEmail__c = 'test@test.com';
		sr.BillingContactPhone__c = '1111111';


		sr.Contact1LastName__c = 'test1';
		sr.Contact1FirstName__c = 'test1';
		sr.Contact1EmailAddress__c = 'test@test2.com';
		sr.Contact1Phone__c = '2222222';		

		sr.Contact2LastName__c = 'test2';
		sr.Contact2FirstName__c = 'test2';
		sr.Contact2Email__c = 'test@test3.com';
		sr.Contact2Phone__c = '3333333';

		insert sr;

		update sr;

	}


}