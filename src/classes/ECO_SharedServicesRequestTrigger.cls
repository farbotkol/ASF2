public class ECO_SharedServicesRequestTrigger {

	public SharedServicesRequest__c oSharedServicesRequest {get;set;}
	public account oAccount {get;set;}
	public account oVendor {get;set;}
	public account oSub {get;set;}
	public Site__c oSite {get;set;}
	public Site__c oSiteBilling {get;set;}
	public Site__c oSiteRemit {get;set;}
	
	public contact oBillingContact {get;set;}
	public contact oContact {get;set;}
	public contact oContact2 {get;set;}
	public boolean bCreateSiteRequest {get; set;}

	public static void UpdateAccountDB(list<SharedServicesRequest__c> targetSSR, map<id, SharedServicesRequest__c> oldMap){
		list<recordtype> listRecType = [select id from recordtype Where sObjectType = 'SharedServicesRequest__c' and (developername = 'CreateVendor' OR  developername = 'CreateCustomer' ) ORDER BY developername ASC];

		set<id> acctID = new set<id>();
		map<id, SharedServicesRequest__c> mapRefToSSR = new map<id, SharedServicesRequest__c>();

		for(SharedServicesRequest__c SSR: targetSSR){
			if((SSR.recordtypeid == listRecType[0].id || SSR.recordtypeid == listRecType[1].id) && SSR.Status__c == 'Closed' && oldMap.get(SSR.id).Status__c != 'Closed'){
				acctID.add(SSR.referenceaccount__c);
				mapRefToSSR.put(SSR.referenceaccount__c, SSR);
			}
		}

		list<account> lstAccts = [select id from account where id IN: acctID];

		for(account a: lstAccts){
			SharedServicesRequest__c s = mapRefToSSR.get(a.id);

			//a.DBNumberDUNS__c = s.DBNumberDUNS__c;
			a.D_B_Rating__c = s.DBRating__c;
			a.D_B_report_date__c = s.DBReportDate__c;
		}

		update lstAccts;
	}


	public static void HandleValidation(list<SharedServicesRequest__c> targetSSR){
		
		/*list<recordtype> listRecType = [select id from recordtype Where sObjectType = 'SharedServicesRequest__c' and developername = 'CreateVendor'];

		set<string> setCustomerName = new set<string>();
		set<string> setTaxRef = new set<string>(); 
		set<string> setAddress = new set<string>(); 
		set<string> setContact = new set<string>(); 

		map<string, SharedServicesRequest__c> mapTaxRef = new map<string, SharedServicesRequest__c>();
		map<string, SharedServicesRequest__c> mapAddress = new map<string, SharedServicesRequest__c>();
		map<string, SharedServicesRequest__c> mapContact = new map<string, SharedServicesRequest__c>();


		for(SharedServicesRequest__c SSR: targetSSR){

			if(listRecType.size() > 0 && SSR.recordtypeid == listRecType[0].id && !SSR.Override_Validation__c){


				if(SSR.CustomerName__c != null){
					setCustomerName.add('%' + SSR.CustomerName__c + '%');
				}

				if(SSR.TaxReference__c != null){
					setTaxRef.add(SSR.TaxReference__c);
					
					if(mapTaxRef.containskey(SSR.TaxReference__c)){
						SSR.addError('Dupe TaxRef Exists in Batch');
						break;
					}
					
					mapTaxRef.put(SSR.TaxReference__c, SSR);
				}			

				if(SSR.Address1StreetPOBox__c != null){

					setAddress.add(SSR.Address1StreetPOBox__c);

					if(mapAddress.containskey(SSR.Address1StreetPOBox__c)){
						SSR.addError('Dupe Address Exists in Batch');
						break;
					}

					mapAddress.put(SSR.Address1StreetPOBox__c, SSR);
				}	

				if(SSR.BillingContactFirstName__c != null && SSR.BillingContactLastName__c != null){
					
					setContact.add(SSR.BillingContactFirstName__c + ' ' + SSR.BillingContactLastName__c);

					if(mapAddress.containskey(SSR.BillingContactFirstName__c + ' ' + SSR.BillingContactLastName__c)){
						SSR.addError('Dupe Billing Contact Exists in Batch');
						break;
					}

					mapContact.put(SSR.BillingContactFirstName__c + ' ' + SSR.BillingContactLastName__c, SSR);
				}
			}

		}


		if(setTaxRef.size() > 0){
			list<account> listTaxSearch = [select id, TaxReference__c from account where TaxReference__c IN: setTaxRef];
			if(listTaxSearch.size() > 0){
				for(account a: listTaxSearch){
					if(mapTaxRef.containskey(a.TaxReference__c)){
						mapTaxRef.get(a.TaxReference__c).addError('Potential Dupe found on Tax Reference: ' +  a.TaxReference__c);
					}
				}
			}
		}

		if(setAddress.size() > 0){
			list<Site__c> listAddressSearch = [select id, Address1__c from Site__c where Address1__c IN: setAddress];
			if(listAddressSearch.size() > 0){
				for(Site__c s: listAddressSearch){
					if(mapAddress.containskey(s.Address1__c)){
						mapAddress.get(s.Address1__c).addError('Potential Dupe found on Address: ' +  s.Address1__c);
					}
				}
			}
		}
		
		if(setContact.size() > 0){
			list<contact> listContactSearch = [select id, Search_Name__c from contact where Search_Name__c IN: setContact];
			if(listContactSearch.size() > 0){
				for(contact c: listContactSearch){
					if(mapContact.containskey(c.Search_Name__c)){
						mapContact.get(c.Search_Name__c).addError('Potential Dupe found on Contact Name: ' +  c.Search_Name__c);
					}
				}
			}
		}


		if(setCustomerName.size() > 0){
			list<account> listaccountsearch = [select id, name from account where name like : setCustomerName];
			if(listaccountsearch.size() > 1){
				targetSSR[0].addError('Potential Dupe detected on Customer Name');
				return;
			}
		}*/

	}


	public static void HandleGeneration(list<SharedServicesRequest__c> targetSSR){

		list<recordtype> listRecType = [select id from recordtype Where sObjectType = 'SharedServicesRequest__c' and (developername = 'CreateVendor' OR  developername = 'AddSite' OR developername ='CreateSub' OR  developername = 'CreateCustomer' ) ORDER BY developername ASC];


		list<ECO_SharedServicesRequestTrigger> lstWrapper = new list<ECO_SharedServicesRequestTrigger>();


		for(SharedServicesRequest__c SSR: targetSSR){
			if(!SSR.AssigntoSharedServices__c)
				continue;

			if((SSR.recordtypeid == listRecType[1].id) || (SSR.recordtypeid == listRecType[2].id) || (SSR.recordtypeid == listRecType[3].id)){
				if(SSR.SkipValidation__c && SSR.GenerateObjects__c){
					lstWrapper.add(new ECO_SharedServicesRequestTrigger(SSR, false));
				}
			}

			if(SSR.recordtypeid == listRecType[0].id){
				if(SSR.SkipValidation__c && SSR.GenerateObjects__c){
					lstWrapper.add(new ECO_SharedServicesRequestTrigger(SSR, true));
				}
			}
		}

		list<account> lstAccountsToInsert = new list<account>();
		list<contact> lstContactsToInsert = new list<contact>();
		list<Site__c> lstSiteToInsert = new list<Site__c>();

		for(ECO_SharedServicesRequestTrigger wrapper: lstWrapper){
			wrapper.CreateAccount();
			wrapper.CreateContact();

			if(!wrapper.bCreateSiteRequest){
				lstAccountsToInsert.add(wrapper.oAccount);
			}

			if(wrapper.oBillingContact != null){
				lstContactsToInsert.add(wrapper.oBillingContact);
			}
			if(wrapper.oContact != null){
				lstContactsToInsert.add(wrapper.oContact);
			}

			lstSiteToInsert.add(wrapper.oSite);

			if(wrapper.oSiteRemit != null){
				lstSiteToInsert.add(wrapper.oSiteRemit);
			}

			if(wrapper.oSiteBilling != null){
				lstSiteToInsert.add(wrapper.oSiteBilling);
			}


			if(wrapper.oContact2 != null){
				lstContactsToInsert.add(wrapper.oContact2);
			}
		}


		try{
			system.debug('DEBUG****:' + lstAccountsToInsert);

			if(lstAccountsToInsert.size() > 0){
				insert lstAccountsToInsert;

				for(ECO_SharedServicesRequestTrigger wrapper: lstWrapper){
					wrapper.oSharedServicesRequest.referenceaccount__c = wrapper.oAccount.id;
				}
			}



	    } catch (Exception e) {
	        targetSSR[0].addError('Error while trying to insert accounts: ' + e);
	    }    

		for(ECO_SharedServicesRequestTrigger wrapper: lstWrapper){
			wrapper.AssociateContact();
		}	

		try{
			system.debug(lstContactsToInsert);
			insert lstContactsToInsert;
	    } catch (Exception e) {
	        targetSSR[0].addError('Error while trying to insert contacts: ' + e);
	    }   

		for(ECO_SharedServicesRequestTrigger wrapper: lstWrapper){
			wrapper.AssociateSite();
		}	

		try{
			system.debug(lstSiteToInsert);
			insert lstSiteToInsert;

			for(ECO_SharedServicesRequestTrigger wrapper: lstWrapper){

				wrapper.oSharedServicesRequest.ReferenceSite__c = wrapper.oSite.id;

				if(wrapper.oSiteRemit != null){
					wrapper.oSharedServicesRequest.ReferenceRemitSite__c = wrapper.oSiteRemit.id;
				}

				if(wrapper.oSiteBilling != null){
					wrapper.oSharedServicesRequest.ReferenceBillingSite__c = wrapper.oSiteBilling.id;
				}

			}	


	    } catch (Exception e) {
	        targetSSR[0].addError('Error while trying to insert sites: ' + e);
	    }   

		for(ECO_SharedServicesRequestTrigger wrapper: lstWrapper){
			wrapper.AssociateServiceRequest();
		}	


		//system.debug('GOT HERE!');
	}

	public void CreateAccount() {


		map<string, id> mapNameToID = new map<string, id>();
		list<recordtype> lstRT = [select id, developername from recordtype where sobjecttype='SharedServicesRequest__c' and (developername='CreateCustomer' OR developername='CreateSub' OR developername='CreateVendor' OR developername='AddSite')];

		list<Country__c> lstCounty = [select id, name from Country__c];
		map<string, id> mapCountry = new map<string, id>();

		for(Country__c c: lstCounty){
			mapCountry.put(c.name, c.id);
		}

		for(recordtype rt: lstRT){
			mapNameToID.put(rt.developername, rt.id);
		}

		oAccount = new Account();
		if(!bCreateSiteRequest){

			if(oSharedServicesRequest.recordtypeid == mapNameToID.get('CreateCustomer')){

				oAccount.Name = oSharedServicesRequest.CustomerName__c;

				oAccount.ParentID = oSharedServicesRequest.ParentAccount__c;
				oAccount.Client_Group__c = oSharedServicesRequest.ClientGroup__c;
				oAccount.Client_Subgroup__c = oSharedServicesRequest.ClientSubgroup__c;
				oAccount.Reach__c = oSharedServicesRequest.Reach__c;

				//oAccount.TaxReference__c = oSharedServicesRequest.TaxReference__c;
				oAccount.Sic = oSharedServicesRequest.SicCode__c;
				oAccount.SicDesc = oSharedServicesRequest.SicDescription__c;
				oAccount.MK_Denial__c = oSharedServicesRequest.MKDenialStatus__c;
				oAccount.CustomerType__c = oSharedServicesRequest.IntercompanyCustomer__c;
				oAccount.Type__c = 'Client/Prospect';
				oAccount.Type = 'Client/Prospect';


			} else if(oSharedServicesRequest.recordtypeid == mapNameToID.get('CreateVendor')){
				oAccount.Name = oSharedServicesRequest.CustomerName__c;

				oAccount.ParentID = oSharedServicesRequest.ParentAccount__c;
				oAccount.VendorType__c = oSharedServicesRequest.VendorType__c;
				oAccount.Sic = oSharedServicesRequest.SicCode__c;
				oAccount.SicDesc = oSharedServicesRequest.SicDescription__c;
				oAccount.Is_MinorityOwned__c = oSharedServicesRequest.SocioMinorityOwned__c;
				oAccount.NonProfit__c = oSharedServicesRequest.SocioNonProfit__c;
				//oVendor.HubZone__c = oSharedServicesRequest.SocioHUBZone__c;
				oAccount.Is_SmallBusiness__c = oSharedServicesRequest.SocioSmallBusinessSB__c;
				oAccount.LargeBusiness__c = oSharedServicesRequest.SocioLargeBusiness__c;
				oAccount.Is_VeteranOwned__c = oSharedServicesRequest.SocioVeteranOwnedVO__c;
				oAccount.Is_WomanOwned__c = oSharedServicesRequest.SocioWomenOwnedWO__c;
				oAccount.Is_DisabledVetOwned__c = oSharedServicesRequest.SocioServiceDisabledVeteranOwnedSDVO__c;
				oAccount.Eight_A_Certified__c = oSharedServicesRequest.Socio8aCertifiedFirms8a__c;
				oAccount.AbilityOne__c = oSharedServicesRequest.SocioAbilityOne__c;
				oAccount.AK_Native_Tribally_Owned__c = oSharedServicesRequest.SocioAlaskaNativeCorpandTriballyOwned__c;
				oAccount.ECO_Disadvn_WomanOwned_SB__c = oSharedServicesRequest.EcoEconomicallyDisadvantagedWomanOwned__c;
				oAccount.Hist_BLK_Minority_Inst__c = oSharedServicesRequest.SocioHistoricallyBlackCollegesandUniv__c;
				oAccount.SmallDisadvnBusiness__c = oSharedServicesRequest.SocioSmallDisadvantagedBusinessSDB__c;
				oAccount.MK_Denial__c = oSharedServicesRequest.MKDenialStatus__c;
				oAccount.HubZone__c = oSharedServicesRequest.SocioHUBZone__c;
				oAccount.Client_Group__c = 'Industrial/Commercial';
				oAccount.Client_Subgroup__c = 'Other Industrial/Commercial';

				oAccount.Type__c = 'Vendor';
				oAccount.Type = 'Vendor';


			} else if(oSharedServicesRequest.recordtypeid == mapNameToID.get('CreateSub')){
				oAccount.Name = oSharedServicesRequest.CustomerName__c;
				oAccount.ParentID = oSharedServicesRequest.ParentAccount__c;
				oAccount.VendorType__c = oSharedServicesRequest.VendorType__c;
				oAccount.Sic = oSharedServicesRequest.SicCode__c;
				oAccount.SicDesc = oSharedServicesRequest.SicDescription__c;
				oAccount.Is_MinorityOwned__c = oSharedServicesRequest.SocioMinorityOwned__c;
				oAccount.NonProfit__c = oSharedServicesRequest.SocioNonProfit__c;
				//oSub.HubZone__c = oSharedServicesRequest.SocioHUBZone__c;
				oAccount.Is_SmallBusiness__c = oSharedServicesRequest.SocioSmallBusinessSB__c;
				oAccount.LargeBusiness__c = oSharedServicesRequest.SocioLargeBusiness__c;
				oAccount.Is_VeteranOwned__c = oSharedServicesRequest.SocioVeteranOwnedVO__c;
				oAccount.Is_WomanOwned__c = oSharedServicesRequest.SocioWomenOwnedWO__c;
				oAccount.Is_DisabledVetOwned__c = oSharedServicesRequest.SocioServiceDisabledVeteranOwnedSDVO__c;
				oAccount.Eight_A_Certified__c = oSharedServicesRequest.Socio8aCertifiedFirms8a__c;
				oAccount.AbilityOne__c = oSharedServicesRequest.SocioAbilityOne__c;
				oAccount.AK_Native_Tribally_Owned__c = oSharedServicesRequest.SocioAlaskaNativeCorpandTriballyOwned__c;
				oAccount.ECO_Disadvn_WomanOwned_SB__c = oSharedServicesRequest.EcoEconomicallyDisadvantagedWomanOwned__c;
				oAccount.Hist_BLK_Minority_Inst__c = oSharedServicesRequest.SocioHistoricallyBlackCollegesandUniv__c;
				oAccount.SmallDisadvnBusiness__c = oSharedServicesRequest.SocioSmallDisadvantagedBusinessSDB__c;
				oAccount.MK_Denial__c = oSharedServicesRequest.MKDenialStatus__c;
				oAccount.HubZone__c = oSharedServicesRequest.SocioHUBZone__c;
				oAccount.Client_Group__c = 'Industrial/Commercial';
				oAccount.Client_Subgroup__c = 'Other Industrial/Commercial';	
				oAccount.Type__c = 'Subcontractor';
				oAccount.Type = 'Subcontractor';
			

			}

			if(oSharedServicesRequest.AddressIsPrimary__c){
				oAccount.street__c = oSharedServicesRequest.Address1StreetPOBox__c;

				if(oSharedServicesRequest.Address2StreetPOBox__c != null){
					oAccount.street__c += ', ' + oSharedServicesRequest.Address2StreetPOBox__c;
				}
				if(oSharedServicesRequest.Address3StreetPOBox__c != null){
					oAccount.street__c += ', ' + oSharedServicesRequest.Address3StreetPOBox__c;
				}
				if(oSharedServicesRequest.Address4StreetPOBox__c != null){
					oAccount.street__c += ', ' + oSharedServicesRequest.Address4StreetPOBox__c;
				}	

				oAccount.phone = oSharedServicesRequest.OfficePhone__c;
				oAccount.City__c = oSharedServicesRequest.City__c;
				oAccount.State_Province_Emerate__c = oSharedServicesRequest.StateProvinceEmirate__c;
				oAccount.Zip__c = oSharedServicesRequest.ZipPostalCode__c;

				if(mapCountry.containskey(oSharedServicesRequest.Country__c)){
					oAccount.CountryLookup__c = mapCountry.get(oSharedServicesRequest.Country__c);
				}

			} else if (oSharedServicesRequest.BillingAddress1isPrimary__c) {


				oAccount.street__c = oSharedServicesRequest.BillingStreetPOBox__c;

				if(oSharedServicesRequest.BillingAddress2StreetPOBox__c != null){
					oAccount.street__c += ', ' + oSharedServicesRequest.BillingAddress2StreetPOBox__c;
				}
				if(oSharedServicesRequest.BillingAddress3StreetPOBox__c != null){
					oAccount.street__c += ', ' + oSharedServicesRequest.BillingAddress3StreetPOBox__c;
				}
				if(oSharedServicesRequest.BillingAddress4StreetPOBox__c != null){
					oAccount.street__c += ', ' + oSharedServicesRequest.BillingAddress4StreetPOBox__c;
				}

				oAccount.phone = oSharedServicesRequest.BillingOfficePhone__c;
				oAccount.City__c = oSharedServicesRequest.BillingAddressCity__c;
				oAccount.State_Province_Emerate__c = oSharedServicesRequest.BillingStateProvinceEmirate__c;
				oAccount.Zip__c = oSharedServicesRequest.BillingZipPostalCode__c;		
				if(mapCountry.containskey(oSharedServicesRequest.BillingAddressCountry__c)){
					oAccount.CountryLookup__c = mapCountry.get(oSharedServicesRequest.BillingAddressCountry__c);
				}		

			} else if (oSharedServicesRequest.RemitIsPrimaryAddress__c) {

				oAccount.street__c = oSharedServicesRequest.RemitToAddressLine1__c;

				if(oSharedServicesRequest.RemitToAddressLine2__c != null){
					oAccount.street__c += ', ' + oSharedServicesRequest.RemitToAddressLine2__c;
				}

				oAccount.phone = oSharedServicesRequest.RemitToOfficePhone__c;
				oAccount.City__c = oSharedServicesRequest.RemitToCity__c;
				oAccount.State_Province_Emerate__c = oSharedServicesRequest.RemitToStateProvinceEmirate__c;
				oAccount.Zip__c = oSharedServicesRequest.RemitToZipPostalCode__c;

				if(mapCountry.containskey(oSharedServicesRequest.RemitToCountry__c)){
					oAccount.CountryLookup__c = mapCountry.get(oSharedServicesRequest.RemitToCountry__c);
				}		


			}
		}else{
			oAccount.Id = oSharedServicesRequest.Account__c;
		}



		oSite = new Site__c();
		oSite.Address1__c = oSharedServicesRequest.Address1StreetPOBox__c;
		oSite.Address2__c = oSharedServicesRequest.Address2StreetPOBox__c;
		oSite.Address3__c = oSharedServicesRequest.Address3StreetPOBox__c;
		oSite.Address4__c = oSharedServicesRequest.Address4StreetPOBox__c;
		oSite.City__c = oSharedServicesRequest.City__c;
		oSite.State__c = oSharedServicesRequest.StateProvinceEmirateName__c;
		oSite.PostalCode__c = oSharedServicesRequest.ZipPostalCode__c;
		oSite.Country__c = oSharedServicesRequest.Country__c;	
		oSite.PrimaryFlag__c = oSharedServicesRequest.AddressIsPrimary__c;	

		if((oSite.Address1__c == null &&
			oSite.Address2__c == null &&
			oSite.Address3__c == null &&
			oSite.Address4__c == null) ||
			oSite.City__c == null ||
			oSite.State__c == null ||
			oSite.Country__c == null
			){
			oSite = null;
		}


		if(oSharedServicesRequest.recordtypeid == mapNameToID.get('CreateCustomer') || oSharedServicesRequest.recordtypeid == mapNameToID.get('AddSite')){
			oSiteBilling = new Site__c();
			oSiteBilling.Address1__c = oSharedServicesRequest.BillingStreetPOBox__c;
			oSiteBilling.Address2__c = oSharedServicesRequest.BillingAddress2StreetPOBox__c;
			oSiteBilling.Address3__c = oSharedServicesRequest.BillingAddress3StreetPOBox__c;
			oSiteBilling.Address4__c = oSharedServicesRequest.BillingAddress4StreetPOBox__c;
			oSiteBilling.City__c = oSharedServicesRequest.BillingAddressCity__c;
			oSiteBilling.State__c = oSharedServicesRequest.BillingStateProvinceEmirateName__c;
			oSiteBilling.PostalCode__c = oSharedServicesRequest.BillingZipPostalCode__c;
			oSiteBilling.Country__c = oSharedServicesRequest.BillingAddressCountry__c;	
			oSiteBilling.PrimaryFlag__c = oSharedServicesRequest.BillingAddress1isPrimary__c;	

			if((oSiteBilling.Address1__c == null &&
				oSiteBilling.Address2__c == null &&
				oSiteBilling.Address3__c == null &&
				oSiteBilling.Address4__c == null) ||
				oSiteBilling.City__c == null ||
				oSiteBilling.State__c == null ||
				oSiteBilling.Country__c == null
				){
				oSiteBilling = null;
			}


		}
		if (oSharedServicesRequest.recordtypeid == mapNameToID.get('CreateVendor') || oSharedServicesRequest.recordtypeid == mapNameToID.get('CreateSub') || oSharedServicesRequest.recordtypeid == mapNameToID.get('AddSite')){
			oSiteRemit = new Site__c();
			oSiteRemit.Address1__c = oSharedServicesRequest.RemitToAddressLine1__c;
			oSiteRemit.Address2__c = oSharedServicesRequest.RemitToAddressLine2__c;
			oSiteRemit.State__c = oSharedServicesRequest.RemitToStateProvinceEmirateName__c;
			oSiteRemit.City__c = oSharedServicesRequest.RemitToCity__c;
			oSiteRemit.PostalCode__c = oSharedServicesRequest.RemitToZipPostalCode__c;
			oSiteRemit.Country__c = oSharedServicesRequest.RemitToCountry__c;
			oSiteRemit.PrimaryFlag__c = oSharedServicesRequest.RemitIsPrimaryAddress__c;

			if((oSiteRemit.Address1__c == null &&
				oSiteRemit.Address2__c == null) ||
				oSiteRemit.City__c == null ||
				oSiteRemit.State__c == null ||
				oSiteRemit.Country__c == null
				){
				oSiteRemit = null;
			}

		}




	}

	public void CreateContact() {

		if(oSharedServicesRequest.BillingContactLastName__c != null){
			oBillingContact = new contact();
			oBillingContact.lastname = oSharedServicesRequest.BillingContactLastName__c;
			oBillingContact.firstname = oSharedServicesRequest.BillingContactFirstName__c;
			oBillingContact.email = oSharedServicesRequest.BillingContactEmail__c;
			oBillingContact.phone = oSharedServicesRequest.BillingContactPhone__c;
			oBillingContact.RoleType__c = 'Billing';

			if(oBillingContact.lastname == null ||
				oBillingContact.lastname == null ||
				(oBillingContact.email == null && 
					oBillingContact.phone==null)){
				oBillingContact = null;
			}

		}

		if(oSharedServicesRequest.Contact1LastName__c != null){

			oContact = new contact();

			oContact.lastname = oSharedServicesRequest.Contact1LastName__c;
			oContact.firstname = oSharedServicesRequest.Contact1FirstName__c;
			oContact.email = oSharedServicesRequest.Contact1EmailAddress__c;
			oContact.phone = oSharedServicesRequest.Contact1Phone__c;
			oContact.RoleType__c = oSharedServicesRequest.CustomerContact1Role__c;

			if(oContact.lastname == null ||
				oContact.lastname == null ||
				(oContact.email == null && 
					oContact.phone==null)){
				oContact = null;
			}

		}


		if(oSharedServicesRequest.Contact2LastName__c != null){

			oContact2 = new contact();

			oContact2.lastname = oSharedServicesRequest.Contact2LastName__c;
			oContact2.firstname = oSharedServicesRequest.Contact2FirstName__c;
			oContact2.email = oSharedServicesRequest.Contact2Email__c;
			oContact2.phone = oSharedServicesRequest.Contact2Phone__c;
			oContact2.RoleType__c = oSharedServicesRequest.CustomerContact2Role__c;

			if(oContact2.lastname == null ||
				oContact2.lastname == null ||
				(oContact2.email == null && 
					oContact2.phone==null)){
				oContact2 = null;
			}

		}
	}


	Public void AssociateContact(){
		if(oBillingContact != null){
			oBillingContact.AccountId = oAccount.id;
		}

		if(oContact != null){
			oContact.AccountId = oAccount.id;
		}

		if(oContact2 != null){
			oContact2.AccountId = oAccount.id;
		}
	}

	Public void AssociateSite(){
		oSite.Account__c = oAccount.id;

		if(oSiteRemit != null){
			oSiteRemit.Account__c = oAccount.id;
		}

		if(oSiteBilling != null){
			oSiteBilling.Account__c = oAccount.id;
		}
	}

	Public void AssociateServiceRequest(){
		oSharedServicesRequest.Account__c = oAccount.id;

		if(oBillingContact != null){
			oSharedServicesRequest.Contact__c = oBillingContact.id;
		}

		oSharedServicesRequest.GenerateObjects__c = false;
	}

	public ECO_SharedServicesRequestTrigger(SharedServicesRequest__c oSharedServicesRequest){
		this.oSharedServicesRequest = oSharedServicesRequest;
	}

	public ECO_SharedServicesRequestTrigger(SharedServicesRequest__c oSharedServicesRequest, boolean bCreateSiteRequest){
		this.oSharedServicesRequest = oSharedServicesRequest;
		this.bCreateSiteRequest = bCreateSiteRequest;
	}
}