global with sharing class rsSearch extends rsModel {
	
    public static Finder find = new Finder('rs_Search__c');

    private List<Condition> mConditions; //rs_Profile_part__c
    private String mSearchType; // Basic/Advanced
    private Map<String,Condition> mUserConditions; //User conditions
    private List<Condition> mPRTeamEmpConditions;

    private List<String> mResultFields; //String of selection on the left
    private List<SelectOption> mResultFieldsOptions; //Picklist on the left
    private List<String> mSelectedFields; //String of selection on the right
    private List<SelectOption> mSelectedFieldOptions; //Picklist on the right
    private List<SelectOption> mAdvancedFieldOptions; //picklist of available field options

    //private String mAdditionalLanguage;
    private String mLicenseRegCountry;
    private String mLicenseReg;
    private String mTextSearch; //Search String
    private String mFilter; // Filter Logic String

    public rsSearch() {
    	super(new rs_Search__c());
    	mConditions = new List<Condition>();
    	mUserConditions = setUpUserConditionMap();
    	mPRTeamEmpConditions = new List<Condition>();
    	//mAdditionalLanguage = 'EN';
    	mLicenseRegCountry = '';
    	mLicenseReg = '';
    	mSearchType = BASIC_SEARCH;
    	getResultFieldOptions();
    	sortSelectedFieldsSpecific();
    }

    //public String getAdditionalLanguage() {
    //	return mAdditionalLanguage;
    //}

    //public void setAdditionalLanguage(String value) {
    //	mAdditionalLanguage = value;
    //}

    public String getLastName() {
    	return (String)mUserConditions.get('lastName').value.replaceAll('%','');
    }

    public void setLastName(String lstName) {
    	String name = String.isNotBlank(lstName) ? lstName+'%' : lstName;
    	String operator = ' LIKE ';
    	String field = 'LastName';
    	mUserConditions.put('lastName',new Condition(name,operator,field));
    }

    public String getFirstName() {
    	return (String)mUserConditions.get('firstName').value.replaceAll('%','');
    }

    public void setFirstName(String frstName) {
    	String name = String.isNotBlank(frstName) ? frstName+'%' : frstName;
    	String operator = ' LIKE ';
    	String field = 'FirstName';
    	mUserConditions.put('firstName',new Condition(name,operator,field));
    }

    public String getLicenseRegistrationCountry() {
    	return mLicenseRegCountry;
    }

    public void setLicenseRegistrationCountry(String country) {
    	mLicenseRegCountry = country;
    }

    public String getLicenseRegistration() {
    	return mLicenseReg;
    }

    public void setLicenseRegistration(String licReg) {
    	mLicenseReg = licReg;
    }

    public List<SelectOption> getLicenseRegistrationList() {
    	List<SelectOption> licReg = new List<SelectOption>();
    	licReg.add(new SelectOption('','--None--'));
    	licReg.add(new SelectOption('Agrologist in Training','Agrologist in Training'));
		licReg.add(new SelectOption('Air Monitoring  Technician','Air Monitoring  Technician'));
		licReg.add(new SelectOption('Applied Science Technologist','Applied Science Technologist'));
		licReg.add(new SelectOption('Approved Consulting Forester','Approved Consulting Forester'));
		licReg.add(new SelectOption('Articling Agrologist','Articling Agrologist'));
		licReg.add(new SelectOption('Associate Value Specialist','Associate Value Specialist'));
		licReg.add(new SelectOption('Association of Architectural Technologist of Ontario','Association of Architectural Technologist of Ontario'));
		licReg.add(new SelectOption('Biologist in Training','Biologist in Training'));
		licReg.add(new SelectOption('Board Certified Environmental Engineer','Board Certified Environmental Engineer'));
		licReg.add(new SelectOption('Board Certified Environmental Engineering Member','Board Certified Environmental Engineering Member'));
		licReg.add(new SelectOption('Canadian Registered Safety Professional','Canadian Registered Safety Professional'));
		licReg.add(new SelectOption('Certified Arborist','Certified Arborist'));
		licReg.add(new SelectOption('Certified Associate in Project Management','Certified Associate in Project Management'));
		licReg.add(new SelectOption('Certified Building Contractor','Certified Building Contractor'));
		licReg.add(new SelectOption('Certified Construction Contract Administrator','Certified Construction Contract Administrator'));
		licReg.add(new SelectOption('Certified Construction Manager ','Certified Construction Manager '));
		licReg.add(new SelectOption('Certified Consulting Meteorologist','Certified Consulting Meteorologist'));
		licReg.add(new SelectOption('Certified Cost Professional','Certified Cost Professional'));
		licReg.add(new SelectOption('Certified Ecologist','Certified Ecologist'));
		licReg.add(new SelectOption('Certified Emergency Manager ','Certified Emergency Manager '));
		licReg.add(new SelectOption('Certified Energy Manager','Certified Energy Manager'));
		licReg.add(new SelectOption('Certified Engineering Geologist','Certified Engineering Geologist'));
		licReg.add(new SelectOption('Certified Engineering Technician','Certified Engineering Technician'));
		licReg.add(new SelectOption('Certified Engineering Technologist','Certified Engineering Technologist'));
		licReg.add(new SelectOption('Certified Environmental Analytical Chemist ','Certified Environmental Analytical Chemist '));
		licReg.add(new SelectOption('Certified Environmental Engineer ','Certified Environmental Engineer '));
		licReg.add(new SelectOption('Certified Environmental Manager','Certified Environmental Manager'));
		licReg.add(new SelectOption('Certified Environmental Practitioner in Training','Certified Environmental Practitioner in Training'));
		licReg.add(new SelectOption('Certified Floodplain Manager','Certified Floodplain Manager'));
		licReg.add(new SelectOption('Certified GIS Professional','Certified GIS Professional'));
		licReg.add(new SelectOption('Certified Hazardous Materials Manager','Certified Hazardous Materials Manager'));
		licReg.add(new SelectOption('Certified Hydrogeologist','Certified Hydrogeologist'));
		licReg.add(new SelectOption('Certified Industrial Hygienist','Certified Industrial Hygienist'));
		licReg.add(new SelectOption('Certified Interior Designer','Certified Interior Designer'));
		licReg.add(new SelectOption('Certified Planner','Certified Planner'));
		licReg.add(new SelectOption('Certified Planning Technician','Certified Planning Technician'));
		licReg.add(new SelectOption('Certified Professional Environmental Auditor','Certified Professional Environmental Auditor'));
		licReg.add(new SelectOption('Certified Professional Geologist','Certified Professional Geologist'));
		licReg.add(new SelectOption('Certified Professional in Erosion and Sediment Control','Certified Professional in Erosion and Sediment Control'));
		licReg.add(new SelectOption('Certified Professional Services Marketer','Certified Professional Services Marketer'));
		licReg.add(new SelectOption('Certified Safety Professional','Certified Safety Professional'));
		licReg.add(new SelectOption('Certified Technician','Certified Technician'));
		licReg.add(new SelectOption('Certified Technology Specialist, Design','Certified Technology Specialist, Design'));
		licReg.add(new SelectOption('Certified Technology Specialist, General','Certified Technology Specialist, General'));
		licReg.add(new SelectOption('Certified Technology Specialist, Installation','Certified Technology Specialist, Installation'));
		licReg.add(new SelectOption('Certified Value Specialist','Certified Value Specialist'));
		licReg.add(new SelectOption('Certified Wetland Delineator','Certified Wetland Delineator'));
		licReg.add(new SelectOption('Chartered Biologist','Chartered Biologist'));
		licReg.add(new SelectOption('Chartered Chemist','Chartered Chemist'));
		licReg.add(new SelectOption('Chartered Engineer','Chartered Engineer'));
		licReg.add(new SelectOption('Chartered Environmentalist, Society for the Environment, UK','Chartered Environmentalist, Society for the Environment, UK'));
		licReg.add(new SelectOption('Chartered Scientist','Chartered Scientist'));
		licReg.add(new SelectOption('Chartered Surveyor','Chartered Surveyor'));
		licReg.add(new SelectOption('Chartered Water & Environment Manager','Chartered Water & Environment Manager'));
		licReg.add(new SelectOption('Data Center Design Consultant','Data Center Design Consultant'));
		licReg.add(new SelectOption('Designated Consulting Engineer','Designated Consulting Engineer'));
		licReg.add(new SelectOption('Designer of Engineering Systems','Designer of Engineering Systems'));
		licReg.add(new SelectOption('Diplomate of the American Board of Toxicology','Diplomate of the American Board of Toxicology'));
		licReg.add(new SelectOption('Electrical Contractor','Electrical Contractor'));
		licReg.add(new SelectOption('Electronic Safety and Security Designer','Electronic Safety and Security Designer'));
		licReg.add(new SelectOption('Engineer in Training','Engineer in Training'));
		licReg.add(new SelectOption('Engineering Intern','Engineering Intern'));
		licReg.add(new SelectOption('ENV Sustainability Professional','ENV Sustainability Professional'));
		licReg.add(new SelectOption('European Engineer','European Engineer'));
		licReg.add(new SelectOption('FCC General Radiotelephone Operator License','FCC General Radiotelephone Operator License'));
		licReg.add(new SelectOption('Foreign Licensee (Engineering) ','Foreign Licensee (Engineering) '));
		licReg.add(new SelectOption('Geologist in Training','Geologist in Training'));
		licReg.add(new SelectOption('Geoscientist in Training','Geoscientist in Training'));
		licReg.add(new SelectOption('Green Globes Professional','Green Globes Professional'));
		licReg.add(new SelectOption('Incorporated Engineer','Incorporated Engineer'));
		licReg.add(new SelectOption('Interior Designer','Interior Designer'));
		licReg.add(new SelectOption('Intern Architect','Intern Architect'));
		licReg.add(new SelectOption('Landscape Architect','Landscape Architect'));
		licReg.add(new SelectOption('LEED Accredited Professional','LEED Accredited Professional'));
		licReg.add(new SelectOption('LEED AP Building Design + Construction (BD+C)','LEED AP Building Design + Construction (BD+C)'));
		licReg.add(new SelectOption('LEED Green Associate','LEED Green Associate'));
		licReg.add(new SelectOption('Licensed Asbestos Building Inspector','Licensed Asbestos Building Inspector'));
		licReg.add(new SelectOption('Licensed Attorney ','Licensed Attorney '));
		licReg.add(new SelectOption('Licensed Construction Supervisor','Licensed Construction Supervisor'));
		licReg.add(new SelectOption('Licensed Contractor','Licensed Contractor'));
		licReg.add(new SelectOption('Licensed Designer','Licensed Designer'));
		licReg.add(new SelectOption('Licensed Environmental Professional','Licensed Environmental Professional'));
		licReg.add(new SelectOption('Licensed Lead Risk Assessor','Licensed Lead Risk Assessor'));
		licReg.add(new SelectOption('Licensed Remediation Specialist','Licensed Remediation Specialist'));
		licReg.add(new SelectOption('Licensed Site Professional','Licensed Site Professional'));
		licReg.add(new SelectOption('Licensed Site Remediation Professional','Licensed Site Remediation Professional'));
		licReg.add(new SelectOption('Licensed Surveyor','Licensed Surveyor'));
		licReg.add(new SelectOption('Licensed Technologist, Ontario Association of Architects','Licensed Technologist, Ontario Association of Architects'));
		licReg.add(new SelectOption('Licensed Tree Expert','Licensed Tree Expert'));
		licReg.add(new SelectOption('Limited Licence Engineer','Limited Licence Engineer'));
		licReg.add(new SelectOption('Maryland Department of the Environment Green Card','Maryland Department of the Environment Green Card'));
		licReg.add(new SelectOption('Maryland Department of the Environment Yellow Card','Maryland Department of the Environment Yellow Card'));
		licReg.add(new SelectOption('NCARB Certificate','NCARB Certificate'));
		licReg.add(new SelectOption('NCEES Certificate','NCEES Certificate'));
		licReg.add(new SelectOption('NCIDQ Certificate','NCIDQ Certificate'));
		licReg.add(new SelectOption('Network Technology Systems Designer','Network Technology Systems Designer'));
		licReg.add(new SelectOption('Notary Public','Notary Public'));
		licReg.add(new SelectOption('Ordre des ingénieurs du Québec','Ordre des ingénieurs du Québec'));
		licReg.add(new SelectOption('Outside Plant Designer','Outside Plant Designer'));
		licReg.add(new SelectOption('Permission to Consult','Permission to Consult'));
		licReg.add(new SelectOption('Planning and Scheduling Professional','Planning and Scheduling Professional'));
		licReg.add(new SelectOption('Professional Agrologist','Professional Agrologist'));
		licReg.add(new SelectOption('Professional Biologist','Professional Biologist'));
		licReg.add(new SelectOption('Professional Chemist ','Professional Chemist '));
		licReg.add(new SelectOption('Professional Engineer','Professional Engineer'));
		licReg.add(new SelectOption('Professional Engineer (Agricultural)','Professional Engineer (Agricultural)'));
		licReg.add(new SelectOption('Professional Engineer (Chemical)','Professional Engineer (Chemical)'));
		licReg.add(new SelectOption('Professional Engineer (Civil)','Professional Engineer (Civil)'));
		licReg.add(new SelectOption('Professional Engineer (Civil/Environmental)','Professional Engineer (Civil/Environmental)'));
		licReg.add(new SelectOption('Professional Engineer (Civil/Structural)','Professional Engineer (Civil/Structural)'));
		licReg.add(new SelectOption('Professional Engineer (Control Systems)','Professional Engineer (Control Systems)'));
		licReg.add(new SelectOption('Professional Engineer (Electrical)','Professional Engineer (Electrical)'));
		licReg.add(new SelectOption('Professional Engineer (Environmental)','Professional Engineer (Environmental)'));
		licReg.add(new SelectOption('Professional Engineer (Fire Protection)','Professional Engineer (Fire Protection)'));
		licReg.add(new SelectOption('Professional Engineer (Geotechnical)','Professional Engineer (Geotechnical)'));
		licReg.add(new SelectOption('Professional Engineer (Industrial)','Professional Engineer (Industrial)'));
		licReg.add(new SelectOption('Professional Engineer (Mechanical)','Professional Engineer (Mechanical)'));
		licReg.add(new SelectOption('Professional Engineer (Mechanical-Electrical)','Professional Engineer (Mechanical-Electrical)'));
		licReg.add(new SelectOption('Professional Engineer (Petroleum)','Professional Engineer (Petroleum)'));
		licReg.add(new SelectOption('Professional Engineer (Sanitary)','Professional Engineer (Sanitary)'));
		licReg.add(new SelectOption('Professional Engineer (Structural)','Professional Engineer (Structural)'));
		licReg.add(new SelectOption('Professional Engineer (Traffic)','Professional Engineer (Traffic)'));
		licReg.add(new SelectOption('Professional Environmental Scientist','Professional Environmental Scientist'));
		licReg.add(new SelectOption('Professional Geologist','Professional Geologist'));
		licReg.add(new SelectOption('Professional Geophysicist','Professional Geophysicist'));
		licReg.add(new SelectOption('Professional Geoscientist','Professional Geoscientist'));
		licReg.add(new SelectOption('Professional Hydrogeologist','Professional Hydrogeologist'));
		licReg.add(new SelectOption('Professional Hydrologist','Professional Hydrologist'));
		licReg.add(new SelectOption('Professional Land Surveyor','Professional Land Surveyor'));
		licReg.add(new SelectOption('Professional Licensee (Engineering)','Professional Licensee (Engineering)'));
		licReg.add(new SelectOption('Professional Licensee (Geoscience)','Professional Licensee (Geoscience)'));
		licReg.add(new SelectOption('Professional Planner','Professional Planner'));
		licReg.add(new SelectOption('Professional Soil Scientist','Professional Soil Scientist'));
		licReg.add(new SelectOption('Professional Traffic Operations Engineer™','Professional Traffic Operations Engineer™'));
		licReg.add(new SelectOption('Professional Transportation Planner','Professional Transportation Planner'));
		licReg.add(new SelectOption('Professional Wetland Scientist','Professional Wetland Scientist'));
		licReg.add(new SelectOption('Program Management Professional','Program Management Professional'));
		licReg.add(new SelectOption('Project Management Professional ','Project Management Professional '));
		licReg.add(new SelectOption('Provisional Licensee (Engineering)','Provisional Licensee (Engineering)'));
		licReg.add(new SelectOption('Qualified Environmental Professional','Qualified Environmental Professional'));
		licReg.add(new SelectOption('Real Estate Broker','Real Estate Broker'));
		licReg.add(new SelectOption('Registered Architect','Registered Architect'));
		licReg.add(new SelectOption('Registered Biology Technologist','Registered Biology Technologist'));
		licReg.add(new SelectOption('Registered Communications Distribution Designer ','Registered Communications Distribution Designer '));
		licReg.add(new SelectOption('Registered Communications Distribution Designer','Registered Communications Distribution Designer'));
		licReg.add(new SelectOption('Registered Community Planner','Registered Community Planner'));
		licReg.add(new SelectOption('Registered Engineering Technician','Registered Engineering Technician'));
		licReg.add(new SelectOption('Registered Engineering Technologist','Registered Engineering Technologist'));
		licReg.add(new SelectOption('Registered Environmental Manager','Registered Environmental Manager'));
		licReg.add(new SelectOption('Registered Environmental Professional','Registered Environmental Professional'));
		licReg.add(new SelectOption('Registered Environmental Property Assessor','Registered Environmental Property Assessor'));
		licReg.add(new SelectOption('Registered Groundwater Professional','Registered Groundwater Professional'));
		licReg.add(new SelectOption('Registered Information Technology Professional','Registered Information Technology Professional'));
		licReg.add(new SelectOption('Registered Land Court Surveyor','Registered Land Court Surveyor'));
		licReg.add(new SelectOption('Registered Land Surveyor','Registered Land Surveyor'));
		licReg.add(new SelectOption('Registered Landscape Architect','Registered Landscape Architect'));
		licReg.add(new SelectOption('Registered Nurse','Registered Nurse'));
		licReg.add(new SelectOption('Registered Occupational Hygienist ','Registered Occupational Hygienist '));
		licReg.add(new SelectOption('Registered Professional Archaeologist','Registered Professional Archaeologist'));
		licReg.add(new SelectOption('Registered Professional Biologist','Registered Professional Biologist'));
		licReg.add(new SelectOption('Registered Professional Engineering Technologist','Registered Professional Engineering Technologist'));
		licReg.add(new SelectOption('Registered Professional Forester','Registered Professional Forester'));
		licReg.add(new SelectOption('Registered Professional Planner','Registered Professional Planner'));
		licReg.add(new SelectOption('Registered Professional Technologist','Registered Professional Technologist'));
		licReg.add(new SelectOption('Registered Respiratory Therapist','Registered Respiratory Therapist'));
		licReg.add(new SelectOption('Registered Safety Professional','Registered Safety Professional'));
		licReg.add(new SelectOption('Registered Sanitarian','Registered Sanitarian'));
		licReg.add(new SelectOption('Registered Site Manager','Registered Site Manager'));
		licReg.add(new SelectOption('Registered Specification Writer','Registered Specification Writer'));
		licReg.add(new SelectOption('Registered Telecommunications Project Manager','Registered Telecommunications Project Manager'));
		licReg.add(new SelectOption('Structural Engineering Certification Board','Structural Engineering Certification Board'));
		licReg.add(new SelectOption('Surveyor in Training','Surveyor in Training'));
		licReg.add(new SelectOption('Technician in Training','Technician in Training'));
		licReg.add(new SelectOption('Technologist in Training','Technologist in Training'));
		licReg.add(new SelectOption('Toxic Substance Reduction Planner','Toxic Substance Reduction Planner'));
		licReg.add(new SelectOption('Well Drilling/Pump Installation Contractor','Well Drilling/Pump Installation Contractor'));
		licReg.add(new SelectOption('Wireless Designer','Wireless Designer'));
		return licReg;
    }

    public List<SelectOption> getCountryList() {
    	List<SelectOption> countries = new List<SelectOption>();
    	countries.add(new SelectOption('','--None--'));
    	sObject sObj = Schema.getGlobalDescribe().get('rs_Profile_Part__c').newSObject();
    	countries.addAll(rsDataUtils.getPicklistValues(sObj, 'Country__c'));
    	return countries;
    }

    public String getCountry() {
    	String retVal = '';
    	if(mUserConditions.get('country') != null) {
    		retVal = (String)mUserConditions.get('country').value;
    	}
    	return retVal;
    }

    public void setCountry(String country) {
    	mUserConditions.put('country',new Condition(country, ' = ', 'Country'));
    }

    public String getGeography() {
    	String retVal = '';
    	if(mUserConditions.get('geography') != null) {
    		retVal = (String)mUserConditions.get('geography').value;
    	}
    	return retVal;
    }

    public void setGeography(String geo) {
    	mUserConditions.put('geography',new Condition(geo,' = ', 'Geography__c'));
    } 

    public List<SelectOption> getGeographyList() {
    	List<SelectOption> geos = new List<SelectOption>();
    	geos.add(new SelectOption('','--None--'));
    	geos.add(new SelectOption('AECOM TECHNOLOGY CORP','AECOM TECHNOLOGY CORP'));
		geos.add(new SelectOption('AFRICA GROUP','AFRICA GROUP'));
		geos.add(new SelectOption('ANZ GROUP','ANZ GROUP'));
		geos.add(new SelectOption('Americas','Americas'));
		geos.add(new SelectOption('Americas CS','Americas CS'));
		geos.add(new SelectOption('Asia','Asia'));
		geos.add(new SelectOption('China','China'));
		geos.add(new SelectOption('EMEA','EMEA'));
		geos.add(new SelectOption('EMEA (Corp)','EMEA (Corp)'));
		geos.add(new SelectOption('EUROPE','EUROPE'));
		geos.add(new SelectOption('IT - APAC','IT - APAC'));
		geos.add(new SelectOption('IT - Americas','IT - Americas'));
		geos.add(new SelectOption('IT - Americas CS','IT - Americas CS'));
		geos.add(new SelectOption('IT - EMEA','IT - EMEA'));
		geos.add(new SelectOption('ME GROUP','ME GROUP'));
		geos.add(new SelectOption('North America','North America'));
		return geos;
    }

    public String getOfficeLocation() {
    	String retVal = '';
    	if(mUserConditions.get('officeLocation') != null) {
    		retVal = (String)mUserConditions.get('officeLocation').value;
    	}
    	return retVal;
    }

    public void setOfficeLocation(String offLoc) {
    	mUserConditions.put('officeLocation',new Condition(offLoc, ' = ', 'Office__c'));
    }

    public List<SelectOption> getOfficeLocationList() {
    	List<SelectOption> offList = new List<SelectOption>();
    	offList.add(new SelectOption('','--None--'));
    	offList.add(new SelectOption('AE - Abu Dhabi, UAE - International Tower','AE - Abu Dhabi, UAE - International Tower'));
		offList.add(new SelectOption('AE - Al Ain, UAE - Liwa Centre Building','AE - Al Ain, UAE - Liwa Centre Building'));
		offList.add(new SelectOption('AE - Dubai, UAE - Oud Metha Building, Oud Metha','AE - Dubai, UAE - Oud Metha Building, Oud Metha'));
		offList.add(new SelectOption('AE - Dubai, UAE - UBora Tower','AE - Dubai, UAE - UBora Tower'));
		offList.add(new SelectOption('AT - Vienna - Bovis Lend Lease','AT - Vienna - Bovis Lend Lease'));
		offList.add(new SelectOption('AU - Adelaide, SA','AU - Adelaide, SA'));
		offList.add(new SelectOption('AU - Brisbane, QLD','AU - Brisbane, QLD'));
		offList.add(new SelectOption('AU - Cairns, QLD','AU - Cairns, QLD'));
		offList.add(new SelectOption('AU - Canberra, ACT','AU - Canberra, ACT'));
		offList.add(new SelectOption('AU - Darwin, NT','AU - Darwin, NT'));
		offList.add(new SelectOption('AU - Hobart, TAS','AU - Hobart, TAS'));
		offList.add(new SelectOption('AU - Hunter, NSW','AU - Hunter, NSW'));
		offList.add(new SelectOption('AU - Mackay, QLD','AU - Mackay, QLD'));
		offList.add(new SelectOption('AU - Maroochydore, QLD','AU - Maroochydore, QLD'));
		offList.add(new SelectOption('AU - Melbourne, VIC - 8 Exhibition St','AU - Melbourne, VIC - 8 Exhibition St'));
		offList.add(new SelectOption('AU - Perth, WA','AU - Perth, WA'));
		offList.add(new SelectOption('AU - Rockhampton, QLD','AU - Rockhampton, QLD'));
		offList.add(new SelectOption('AU - Sydney, NSW','AU - Sydney, NSW'));
		offList.add(new SelectOption('AU - Townsville, QLD','AU - Townsville, QLD'));
		offList.add(new SelectOption('AZ - Baku - 96, Nizami Street','AZ - Baku - 96, Nizami Street'));
		offList.add(new SelectOption('BA - Sarajevo - Tesanjska 24A','BA - Sarajevo - Tesanjska 24A'));
		offList.add(new SelectOption('BH - Manama, BH - Al Saffar House, Seef District','BH - Manama, BH - Al Saffar House, Seef District'));
		offList.add(new SelectOption('BR - Nova Lima, Brazil - Alameda do Inga','BR - Nova Lima, Brazil - Alameda do Inga'));
		offList.add(new SelectOption('BR - Rio de Janeiro, Brazil - Praia de Botafogo','BR - Rio de Janeiro, Brazil - Praia de Botafogo'));
		offList.add(new SelectOption('BR - Sao Paulo, Brazil - Rua Antonio das Chagas','BR - Sao Paulo, Brazil - Rua Antonio das Chagas'));
		offList.add(new SelectOption('BR - Sao Paulo, Brazil - Rua Tenente Negrao','BR - Sao Paulo, Brazil - Rua Tenente Negrao'));
		offList.add(new SelectOption('BW - Gaborone - Gaborone International Finance Park','BW - Gaborone - Gaborone International Finance Park'));
		offList.add(new SelectOption('CAN - Baie Comeau, QC - 231, Blvd La Salle','CAN - Baie Comeau, QC - 231, Blvd La Salle'));
		offList.add(new SelectOption('CAN - Barrie, ON - 55 Cedar Point Drive','CAN - Barrie, ON - 55 Cedar Point Drive'));
		offList.add(new SelectOption('CAN - Bracebridge, ON - 345 Ecclestone Dr','CAN - Bracebridge, ON - 345 Ecclestone Dr'));
		offList.add(new SelectOption('CAN - Burnaby, BC - 3292 Production Way','CAN - Burnaby, BC - 3292 Production Way'));
		offList.add(new SelectOption('CAN - Calgary, AB - 340 Midpark Way SE','CAN - Calgary, AB - 340 Midpark Way SE'));
		offList.add(new SelectOption('CAN - Calgary, AB - 6807 Railway St SE','CAN - Calgary, AB - 6807 Railway St SE'));
		offList.add(new SelectOption('CAN - Chicoutimi, QC - 255, Rue Racine Est','CAN - Chicoutimi, QC - 255, Rue Racine Est'));
		offList.add(new SelectOption('CAN - Cobalt, ON - 1 Station Rd','CAN - Cobalt, ON - 1 Station Rd'));
		offList.add(new SelectOption('CAN - Edmonton, AB - 17007 107 Ave','CAN - Edmonton, AB - 17007 107 Ave'));
		offList.add(new SelectOption('CAN - Edmonton, AB - 17203 103 Ave','CAN - Edmonton, AB - 17203 103 Ave'));
		offList.add(new SelectOption('CAN - Gatineau, QC - 228 Boulevard Saint-Joseph','CAN - Gatineau, QC - 228 Boulevard Saint-Joseph'));
		offList.add(new SelectOption('CAN - Guelph, ON - 55 Wyndham St N','CAN - Guelph, ON - 55 Wyndham St N'));
		offList.add(new SelectOption('CAN - Halifax, NS - 1701 Hollis St','CAN - Halifax, NS - 1701 Hollis St'));
		offList.add(new SelectOption('CAN - Hamilton, ON - 45 Goderich Rd','CAN - Hamilton, ON - 45 Goderich Rd'));
		offList.add(new SelectOption('CAN - Kelowna, BC - 3275 Lakeshore Rd','CAN - Kelowna, BC - 3275 Lakeshore Rd'));
		offList.add(new SelectOption('CAN - Kingston, ON - 654 Norris Ct','CAN - Kingston, ON - 654 Norris Ct'));
		offList.add(new SelectOption('CAN - Kitchener, ON - 50 Sportsworld Crossing Rd','CAN - Kitchener, ON - 50 Sportsworld Crossing Rd'));
		offList.add(new SelectOption('CAN - Laval, QC - 1 Place Laval','CAN - Laval, QC - 1 Place Laval'));
		offList.add(new SelectOption('CAN - Levis, QC - 1120 Boul. de la Rive-Sud','CAN - Levis, QC - 1120 Boul. de la Rive-Sud'));
		offList.add(new SelectOption('CAN - London, ON - 250 York St','CAN - London, ON - 250 York St'));
		offList.add(new SelectOption('CAN - Longueuil, QC - 2199 Blvd Fernand-Lafontaine','CAN - Longueuil, QC - 2199 Blvd Fernand-Lafontaine'));
		offList.add(new SelectOption('CAN - Markham, ON - 105 Commerce Valley Dr W','CAN - Markham, ON - 105 Commerce Valley Dr W'));
		offList.add(new SelectOption('CAN - Mississauga, ON - 5080 Commerce Blvd','CAN - Mississauga, ON - 5080 Commerce Blvd'));
		offList.add(new SelectOption('CAN - Montreal, QC - 1010 de la Gauchetiere St W','CAN - Montreal, QC - 1010 de la Gauchetiere St W'));
		offList.add(new SelectOption('CAN - Montreal, QC - 85, Sainte-Catherine St West','CAN - Montreal, QC - 85, Sainte-Catherine St West'));
		offList.add(new SelectOption('CAN - North Bay, ON - 189 Wyld St','CAN - North Bay, ON - 189 Wyld St'));
		offList.add(new SelectOption('CAN - Ottawa, ON - 1150 Morrison Dr','CAN - Ottawa, ON - 1150 Morrison Dr'));
		offList.add(new SelectOption('CAN - Ouagadougou, BF - BP2601 Ouagadougou 01','CAN - Ouagadougou, BF - BP2601 Ouagadougou 01'));
		offList.add(new SelectOption('CAN - Port-au-Prince, HT - 63, rue Faustin 1er','CAN - Port-au-Prince, HT - 63, rue Faustin 1er'));
		offList.add(new SelectOption('CAN - Port of Spain, Trinidad','CAN - Port of Spain, Trinidad'));
		offList.add(new SelectOption('CAN - Quebec, QC - 4700, Blvd Wilfrid-Hamel','CAN - Quebec, QC - 4700, Blvd Wilfrid-Hamel'));
		offList.add(new SelectOption('CAN - Regina, SK - 183-1621 Albert St','CAN - Regina, SK - 183-1621 Albert St'));
		offList.add(new SelectOption('CAN - Riviere Du Loup, QC - 2, Rue de la Cour','CAN - Riviere Du Loup, QC - 2, Rue de la Cour'));
		offList.add(new SelectOption('CAN - Rouyn-Noranda, QC - 436, Ave Lariviere','CAN - Rouyn-Noranda, QC - 436, Ave Lariviere'));
		offList.add(new SelectOption('CAN - Saskatoon, SK - 2100 8th St','CAN - Saskatoon, SK - 2100 8th St'));
		offList.add(new SelectOption('CAN - Sault Ste Marie, ON - 523 Wellington St E','CAN - Sault Ste Marie, ON - 523 Wellington St E'));
		offList.add(new SelectOption('CAN - St Catharines, ON - 30 Hannover Dr','CAN - St Catharines, ON - 30 Hannover Dr'));
		offList.add(new SelectOption('CAN - Sudbury, ON - 1361 Paris Street','CAN - Sudbury, ON - 1361 Paris Street'));
		offList.add(new SelectOption('CAN - Sydney, NS - 164 Charlotte St','CAN - Sydney, NS - 164 Charlotte St'));
		offList.add(new SelectOption('CAN - Trois-Rivieres, QC - 2, Rue Fusey','CAN - Trois-Rivieres, QC - 2, Rue Fusey'));
		offList.add(new SelectOption('CAN - Victoria, BC - 415 Gorge Rd E','CAN - Victoria, BC - 415 Gorge Rd E'));
		offList.add(new SelectOption('CAN - Whitby, ON - 1615 Dundas St E','CAN - Whitby, ON - 1615 Dundas St E'));
		offList.add(new SelectOption('CAN - Whitby, ON - 300 Water St','CAN - Whitby, ON - 300 Water St'));
		offList.add(new SelectOption('CAN - Windsor, ON - 350 Cabana Rd E','CAN - Windsor, ON - 350 Cabana Rd E'));
		offList.add(new SelectOption('CAN - Winnipeg, MB - 99 Commerce Dr','CAN - Winnipeg, MB - 99 Commerce Dr'));
		offList.add(new SelectOption('CAN - Yellowknife, NT - 4916 47 St','CAN - Yellowknife, NT - 4916 47 St'));
		offList.add(new SelectOption('CH - Zug - Lend Lease','CH - Zug - Lend Lease'));
		offList.add(new SelectOption('CN - Beijing - No 9 Zheng Ren Building','CN - Beijing - No 9 Zheng Ren Building'));
		offList.add(new SelectOption('CN - Beijing - Office 24, F24, Tower One','CN - Beijing - Office 24, F24, Tower One'));
		offList.add(new SelectOption('CN - Chongqing - 35F Metropolitan Tower','CN - Chongqing - 35F Metropolitan Tower'));
		offList.add(new SelectOption('CN - Guangzhou - 34F HNA Building','CN - Guangzhou - 34F HNA Building'));
		offList.add(new SelectOption('CN - Jiangxi - 459 Industrial Road','CN - Jiangxi - 459 Industrial Road'));
		offList.add(new SelectOption('CN - Shanghai - 36-38/F Wheelock Square','CN - Shanghai - 36-38/F Wheelock Square'));
		offList.add(new SelectOption('CN - Shenzhen - 14/F Southern Securities Bldg','CN - Shenzhen - 14/F Southern Securities Bldg'));
		offList.add(new SelectOption('CN - Shenzhen - 14-15/F, Block B, East Tower, Coastal Bldg','CN - Shenzhen - 14-15/F, Block B, East Tower, Coastal Bldg'));
		offList.add(new SelectOption('CN - Shenzhen - Unit 01- 05, 28F, Tiley Central Plaza','CN - Shenzhen - Unit 01- 05, 28F, Tiley Central Plaza'));
		offList.add(new SelectOption('CN - Tianjin - Maigou International Plaza','CN - Tianjin - Maigou International Plaza'));
		offList.add(new SelectOption('CO - Bogota, Colombia - Calle 72 No 10-51','CO - Bogota, Colombia - Calle 72 No 10-51'));
		offList.add(new SelectOption('CZ - Brno - Gen.Píky , Brno','CZ - Brno - Gen.Píky , Brno'));
		offList.add(new SelectOption('CZ - Liberec - Londynska 51/2, Liberec','CZ - Liberec - Londynska 51/2, Liberec'));
		offList.add(new SelectOption('CZ - Ostrava - Brandlova 6','CZ - Ostrava - Brandlova 6'));
		offList.add(new SelectOption('CZ - Plzen - Borská 55','CZ - Plzen - Borská 55'));
		offList.add(new SelectOption('CZ - Prague - Trojská 92','CZ - Prague - Trojská 92'));
		offList.add(new SelectOption('DE - Munich - Heimeranstrasse 37','DE - Munich - Heimeranstrasse 37'));
		offList.add(new SelectOption('ES - A Gudina - Calle Atallo 6','ES - A Gudina - Calle Atallo 6'));
		offList.add(new SelectOption('ES - Barcelona - Calle Josep Estivill 77','ES - Barcelona - Calle Josep Estivill 77'));
		offList.add(new SelectOption('ES - Barcelona - Calle La Sagrera 111','ES - Barcelona - Calle La Sagrera 111'));
		offList.add(new SelectOption('ES - Espinardo - Avenida Juan Carlos I','ES - Espinardo - Avenida Juan Carlos I'));
		offList.add(new SelectOption('ES - Madrid - Calle Quintana 2','ES - Madrid - Calle Quintana 2'));
		offList.add(new SelectOption('ES - Madrid - Calle Serrano 98-2nd Flr','ES - Madrid - Calle Serrano 98-2nd Flr'));
		offList.add(new SelectOption('ES - Roales del Pan - Calle Merida 26','ES - Roales del Pan - Calle Merida 26'));
		offList.add(new SelectOption('FR - Paris - 28 Bld Haussmann','FR - Paris - 28 Bld Haussmann'));
		offList.add(new SelectOption('FR - Paris - 63 Rue Sainte Anne','FR - Paris - 63 Rue Sainte Anne'));
		offList.add(new SelectOption('GH - Accra - Limited F641/1 Otu Kofi Link','GH - Accra - Limited F641/1 Otu Kofi Link'));
		offList.add(new SelectOption('GR - Athens - 47-49 Persefonis Street','GR - Athens - 47-49 Persefonis Street'));
		offList.add(new SelectOption('HK - Shatin, N.T.','HK - Shatin, N.T.'));
		offList.add(new SelectOption('HU - Budapest - Ráday utca 42-44','HU - Budapest - Ráday utca 42-44'));
		offList.add(new SelectOption('ID - Jakarta Selatan - Recapital Building, 1st Floor','ID - Jakarta Selatan - Recapital Building, 1st Floor'));
		offList.add(new SelectOption('IE - Cork - Douglas Business Centre','IE - Cork - Douglas Business Centre'));
		offList.add(new SelectOption('IE - Dublin - 24 Lower Hatch Street','IE - Dublin - 24 Lower Hatch Street'));
		offList.add(new SelectOption('IE - Dublin - Kingswood Drive','IE - Dublin - Kingswood Drive'));
		offList.add(new SelectOption('IE - Dublin - Upper Grand Canal Street','IE - Dublin - Upper Grand Canal Street'));
		offList.add(new SelectOption('IE - Galway - Heritage Hall','IE - Galway - Heritage Hall'));
		offList.add(new SelectOption('IE - Limerick','IE - Limerick'));
		offList.add(new SelectOption('IN - Assam - H/o Harprasad Ghosh','IN - Assam - H/o Harprasad Ghosh'));
		offList.add(new SelectOption('IN - Bangalore, Mittal Tower','IN - Bangalore, Mittal Tower'));
		offList.add(new SelectOption('IN - Bihar - Manoma Public School','IN - Bihar - Manoma Public School'));
		offList.add(new SelectOption('IN - Chennai, Apex Towers','IN - Chennai, Apex Towers'));
		offList.add(new SelectOption('IN - Chennai, Ega Trade Centre','IN - Chennai, Ega Trade Centre'));
		offList.add(new SelectOption('IN - Chennai - 5/F Khivraj Building II','IN - Chennai - 5/F Khivraj Building II'));
		offList.add(new SelectOption('IN - Dehradun - Uttarakhand Tourism','IN - Dehradun - Uttarakhand Tourism'));
		offList.add(new SelectOption('IN - GANDHINAGAR - 3rd Floor, Udyog Bhavan','IN - GANDHINAGAR - 3rd Floor, Udyog Bhavan'));
		offList.add(new SelectOption('IN - Gujarat - 3rd Floor, Udyog Bhavan','IN - Gujarat - 3rd Floor, Udyog Bhavan'));
		offList.add(new SelectOption('IN - Gurgaon - 3rd floor, DLF Cyber City','IN - Gurgaon - 3rd floor, DLF Cyber City'));
		offList.add(new SelectOption('IN - Gurgaon - 5/F, Building No-10, DLF Cyber City','IN - Gurgaon - 5/F, Building No-10, DLF Cyber City'));
		offList.add(new SelectOption('IN - Gurgaon - 9th Floor, Infinity Tower C','IN - Gurgaon - 9th Floor, Infinity Tower C'));
		offList.add(new SelectOption('IN - Gurgaon - P81, DLF Site','IN - Gurgaon - P81, DLF Site'));
		offList.add(new SelectOption('IN - Guwahati - Goswami Bhawan','IN - Guwahati - Goswami Bhawan'));
		offList.add(new SelectOption('IN - Hamirpur - 218, Asthakanwal Complex','IN - Hamirpur - 218, Asthakanwal Complex'));
		offList.add(new SelectOption('IN - Hyderabad, 2nd Floor, House No 8-202','IN - Hyderabad, 2nd Floor, House No 8-202'));
		offList.add(new SelectOption('IN - Hyderabad, Aditya Jayarag Building','IN - Hyderabad, Aditya Jayarag Building'));
		offList.add(new SelectOption('IN - Hyderabad, Hi-Tech City','IN - Hyderabad, Hi-Tech City'));
		offList.add(new SelectOption('IN - Kannur Site, Kerala','IN - Kannur Site, Kerala'));
		offList.add(new SelectOption('IN - Karanataka - C/o Nagashree Building','IN - Karanataka - C/o Nagashree Building'));
		offList.add(new SelectOption('IN - Kolkata, CF 327, Ground floor, Sector - 1','IN - Kolkata, CF 327, Ground floor, Sector - 1'));
		offList.add(new SelectOption('IN - Kolkata, HRBC Bhawan','IN - Kolkata, HRBC Bhawan'));
		offList.add(new SelectOption('IN - Kolkata, KMRCL Bhawan','IN - Kolkata, KMRCL Bhawan'));
		offList.add(new SelectOption('IN - Kolkata - 1st floor, DLF IT park -1','IN - Kolkata - 1st floor, DLF IT park -1'));
		offList.add(new SelectOption('IN - Lucknow - Essel Infraprojects Ltd','IN - Lucknow - Essel Infraprojects Ltd'));
		offList.add(new SelectOption('IN - Manipur - 1st Floor, Food World Building','IN - Manipur - 1st Floor, Food World Building'));
		offList.add(new SelectOption('IN - Mumbai, Times Square','IN - Mumbai, Times Square'));
		offList.add(new SelectOption('IN - Noida, A-109, II&III Floor, Sector-63','IN - Noida, A-109, II&III Floor, Sector-63'));
		offList.add(new SelectOption('IN - Noida, A-197, Sector-63','IN - Noida, A-197, Sector-63'));
		offList.add(new SelectOption('IN - Noida - Sec 32 A, Wave City Centre','IN - Noida - Sec 32 A, Wave City Centre'));
		offList.add(new SelectOption('IN - Odisha - 1B/27, L&T Construction','IN - Odisha - 1B/27, L&T Construction'));
		offList.add(new SelectOption('IN - Pune, Pride Portal Building','IN - Pune, Pride Portal Building'));
		offList.add(new SelectOption('IN - Tinsukia - Bordoloi Nagar','IN - Tinsukia - Bordoloi Nagar'));
		offList.add(new SelectOption('IT - Milan - Via Francesco Ferrucci 17/A','IT - Milan - Via Francesco Ferrucci 17/A'));
		offList.add(new SelectOption('IT - Pescara - Via Di Sotto 123/2','IT - Pescara - Via Di Sotto 123/2'));
		offList.add(new SelectOption('JP - Tokyo - Kojimachi Square Plaza','JP - Tokyo - Kojimachi Square Plaza'));
		offList.add(new SelectOption('KSA - Al Khobar, SA - Al Khereji Business Center','KSA - Al Khobar, SA - Al Khereji Business Center'));
		offList.add(new SelectOption('KSA - Jeddah, SA - Aster Center Bldg','KSA - Jeddah, SA - Aster Center Bldg'));
		offList.add(new SelectOption('KSA - Jeddah, SA - Bin Sulaiman Center','KSA - Jeddah, SA - Bin Sulaiman Center'));
		offList.add(new SelectOption('KSA - Riyadh, SA - Tatweer Building','KSA - Riyadh, SA - Tatweer Building'));
		offList.add(new SelectOption('KZ - Almaty - 134 Dostyk Ave','KZ - Almaty - 134 Dostyk Ave'));
		offList.add(new SelectOption('LK - Colombo - 51/4A Ward Place','LK - Colombo - 51/4A Ward Place'));
		offList.add(new SelectOption('LR - Monrovia - Old Rd, Congo Town','LR - Monrovia - Old Rd, Congo Town'));
		offList.add(new SelectOption('LV - Riga - Kr. Barona iela 36-4','LV - Riga - Kr. Barona iela 36-4'));
		offList.add(new SelectOption('LY - Tripoli - Ben Ashour Area','LY - Tripoli - Ben Ashour Area'));
		offList.add(new SelectOption('MY - Johor Bahru','MY - Johor Bahru'));
		offList.add(new SelectOption('MY - Kuala Lumpur - 18-6, Blk B, 18th Fl, Megan Ave II','MY - Kuala Lumpur - 18-6, Blk B, 18th Fl, Megan Ave II'));
		offList.add(new SelectOption('MY - Kuching','MY - Kuching'));
		offList.add(new SelectOption('MY - Penang','MY - Penang'));
		offList.add(new SelectOption('MY - Petaling Jaya - Level 2A, Tower Block Menara Batu Kawan','MY - Petaling Jaya - Level 2A, Tower Block Menara Batu Kawan'));
		offList.add(new SelectOption('MZ - Maputo - Rua de Argelia','MZ - Maputo - Rua de Argelia'));
		offList.add(new SelectOption('NG - Lagos - 51 Agodoga Ave','NG - Lagos - 51 Agodoga Ave'));
		offList.add(new SelectOption('NL - Amsterdam - Herengracht 124','NL - Amsterdam - Herengracht 124'));
		offList.add(new SelectOption('NL - Rotterdam - Rivium Boulevard 301','NL - Rotterdam - Rivium Boulevard 301'));
		offList.add(new SelectOption('NZ - Auckland','NZ - Auckland'));
		offList.add(new SelectOption('NZ - Christchurch','NZ - Christchurch'));
		offList.add(new SelectOption('NZ - Hamilton','NZ - Hamilton'));
		offList.add(new SelectOption('NZ - Wellington','NZ - Wellington'));
		offList.add(new SelectOption('OM - Muscat, OM - Al Khuwair','OM - Muscat, OM - Al Khuwair'));
		offList.add(new SelectOption('PH - Taguig City - 23rd Floor, Fort Legend Tower','PH - Taguig City - 23rd Floor, Fort Legend Tower'));
		offList.add(new SelectOption('PL - Kraków - BP Europa SE','PL - Kraków - BP Europa SE'));
		offList.add(new SelectOption('PL - Warsaw - Warsaw Ambassador Office Building','PL - Warsaw - Warsaw Ambassador Office Building'));
		offList.add(new SelectOption('PL - Wroclaw - Ul. Legnicka 55 C / 5','PL - Wroclaw - Ul. Legnicka 55 C / 5'));
		offList.add(new SelectOption('PT - Lisbon - Lagoas Park - Edifício 3 - 2º Piso','PT - Lisbon - Lagoas Park - Edifício 3 - 2º Piso'));
		offList.add(new SelectOption('QA - Doha, QA - Jaidah Square','QA - Doha, QA - Jaidah Square'));
		offList.add(new SelectOption('QA - Doha, QA - The Pearl Building','QA - Doha, QA - The Pearl Building'));
		offList.add(new SelectOption('QA - Doha, QA - West Bay Office','QA - Doha, QA - West Bay Office'));
		offList.add(new SelectOption('RO - Bucharest - 141-143 Calea Floreasca St','RO - Bucharest - 141-143 Calea Floreasca St'));
		offList.add(new SelectOption('RO - Bucharest - 68-72 Polona St','RO - Bucharest - 68-72 Polona St'));
		offList.add(new SelectOption('RU - Kaluga - Poselok Rosva','RU - Kaluga - Poselok Rosva'));
		offList.add(new SelectOption('RU - Moscow - 29 Serebryanicheskaya nab','RU - Moscow - 29 Serebryanicheskaya nab'));
		offList.add(new SelectOption('RU - Moscow - Bovis Lend Lease, 127254 B. Novodmitro','RU - Moscow - Bovis Lend Lease, 127254 B. Novodmitro'));
		offList.add(new SelectOption('RU - Moscow - Bovis Lend Lease International Ltd','RU - Moscow - Bovis Lend Lease International Ltd'));
		offList.add(new SelectOption('RU - Saint-Petersburg - Bovis Lend Lease, 30 Bolshaya','RU - Saint-Petersburg - Bovis Lend Lease, 30 Bolshaya'));
		offList.add(new SelectOption('RU - Saint-Petersburg - Office 701/1','RU - Saint-Petersburg - Office 701/1'));
		offList.add(new SelectOption('RU - Tolstoy SCA, 2 Bovis Lend Lease, Schekino District','RU - Tolstoy SCA, 2 Bovis Lend Lease, Schekino District'));
		offList.add(new SelectOption('SG - 865 Mountbatten Road','SG - 865 Mountbatten Road'));
		offList.add(new SelectOption('SG - Resorts World at Sentosa','SG - Resorts World at Sentosa'));
		offList.add(new SelectOption('SG - The Concourse','SG - The Concourse'));
		offList.add(new SelectOption('TH - Bangkok - 53 Sivayathorn Tower 12A Floor','TH - Bangkok - 53 Sivayathorn Tower 12A Floor'));
		offList.add(new SelectOption('TH - Bangkok - 999/9 The Offices at Central World 19th Fl','TH - Bangkok - 999/9 The Offices at Central World 19th Fl'));
		offList.add(new SelectOption('TH - Bangkok - Suriyawong Road','TH - Bangkok - Suriyawong Road'));
		offList.add(new SelectOption('TR - Ankara - Ahmet Rasim Sokak','TR - Ankara - Ahmet Rasim Sokak'));
		offList.add(new SelectOption('TR - Ankara - Mustafa Kemal Mah. Dumlup?nar Bulvari','TR - Ankara - Mustafa Kemal Mah. Dumlup?nar Bulvari'));
		offList.add(new SelectOption('TR - Istanbul - Bovis Lend Lease Construction','TR - Istanbul - Bovis Lend Lease Construction'));
		offList.add(new SelectOption('TR - Istanbul - Buyukdere Cad Harman Sokak','TR - Istanbul - Buyukdere Cad Harman Sokak'));
		offList.add(new SelectOption('TR - Istanbul - Rumeli Caddesi 4-6','TR - Istanbul - Rumeli Caddesi 4-6'));
		offList.add(new SelectOption('TW - Kaohsiung City','TW - Kaohsiung City'));
		offList.add(new SelectOption('TW - New Taipei City','TW - New Taipei City'));
		offList.add(new SelectOption('TW - Taipei - 16F, Shin Kong Manhattan Building','TW - Taipei - 16F, Shin Kong Manhattan Building'));
		offList.add(new SelectOption('TW - Taipei City','TW - Taipei City'));
		offList.add(new SelectOption('UA - Kiev - Horizon Business Park','UA - Kiev - Horizon Business Park'));
		offList.add(new SelectOption('UG - Kampala - 1207 Ggaba Rd','UG - Kampala - 1207 Ggaba Rd'));
		offList.add(new SelectOption('UK - Aberdeen','UK - Aberdeen'));
		offList.add(new SelectOption('UK - Altrincham','UK - Altrincham'));
		offList.add(new SelectOption('UK - Barnsley - Wentworth Business Park','UK - Barnsley - Wentworth Business Park'));
		offList.add(new SelectOption('UK - Belfast','UK - Belfast'));
		offList.add(new SelectOption('UK - Birmingham - Colmore Plaza','UK - Birmingham - Colmore Plaza'));
		offList.add(new SelectOption('UK - Bristol','UK - Bristol'));
		offList.add(new SelectOption('UK - Cambridge - 36 Storey\'s Way','UK - Cambridge - 36 Storey\'s Way'));
		offList.add(new SelectOption('UK - Cardiff','UK - Cardiff'));
		offList.add(new SelectOption('UK ? Chelmsford','UK ? Chelmsford'));
		offList.add(new SelectOption('UK ? Croydon - Bedford Park','UK ? Croydon - Bedford Park'));
		offList.add(new SelectOption('UK - Edinburgh ? Tanfield','UK - Edinburgh ? Tanfield'));
		offList.add(new SelectOption('UK - Exeter','UK - Exeter'));
		offList.add(new SelectOption('UK - Glasgow','UK - Glasgow'));
		offList.add(new SelectOption('UK - Glasgow - 120 Bothwell Street','UK - Glasgow - 120 Bothwell Street'));
		offList.add(new SelectOption('UK - Leeds','UK - Leeds'));
		offList.add(new SelectOption('UK - Leeds - Livingstone House','UK - Leeds - Livingstone House'));
		offList.add(new SelectOption('UK - Liverpool','UK - Liverpool'));
		offList.add(new SelectOption('UK - London - MidCity Place','UK - London - MidCity Place'));
		offList.add(new SelectOption('UK - Maidstone','UK - Maidstone'));
		offList.add(new SelectOption('UK - Manchester - 1 New York Street','UK - Manchester - 1 New York Street'));
		offList.add(new SelectOption('UK - Milton Keynes','UK - Milton Keynes'));
		offList.add(new SelectOption('UK - Milton Keynes - Global Alliance','UK - Milton Keynes - Global Alliance'));
		offList.add(new SelectOption('UK - Newcastle-upon-Tyne','UK - Newcastle-upon-Tyne'));
		offList.add(new SelectOption('UK - Newry - Old Gasworks Business Park','UK - Newry - Old Gasworks Business Park'));
		offList.add(new SelectOption('UK - Norwich','UK - Norwich'));
		offList.add(new SelectOption('UK - Norwich - 3 St James Court','UK - Norwich - 3 St James Court'));
		offList.add(new SelectOption('UK - Oxford - Avalon House','UK - Oxford - Avalon House'));
		offList.add(new SelectOption('UK - Peterborough - Clarence House','UK - Peterborough - Clarence House'));
		offList.add(new SelectOption('UK - Southampton','UK - Southampton'));
		offList.add(new SelectOption('UK - St. Albans','UK - St. Albans'));
		offList.add(new SelectOption('UK ? Tankersley - Wentworth Business Park','UK ? Tankersley - Wentworth Business Park'));
		offList.add(new SelectOption('UK- Wakefield - ETM Head Office','UK- Wakefield - ETM Head Office'));
		offList.add(new SelectOption('US - Abidjan, Cote d\'Ivoire','US - Abidjan, Cote d\'Ivoire'));
		offList.add(new SelectOption('US - Abu Dhabi, UAE - Al Jazira Sports Club','US - Abu Dhabi, UAE - Al Jazira Sports Club'));
		offList.add(new SelectOption('US - Afghanistan','US - Afghanistan'));
		offList.add(new SelectOption('US - Akron, OH - 209 South Main Street','US - Akron, OH - 209 South Main Street'));
		offList.add(new SelectOption('US - Alabama - Telecommute','US - Alabama - Telecommute'));
		offList.add(new SelectOption('US - Alaska - Telecommute','US - Alaska - Telecommute'));
		offList.add(new SelectOption('US - Albuquerque, NM - 201 Third St NW','US - Albuquerque, NM - 201 Third St NW'));
		offList.add(new SelectOption('US - Alexandria, Egypt','US - Alexandria, Egypt'));
		offList.add(new SelectOption('US - Alexandria, VA - 6440 General Green Way','US - Alexandria, VA - 6440 General Green Way'));
		offList.add(new SelectOption('US - Alexandria, VA - 675 N Washington St','US - Alexandria, VA - 675 N Washington St'));
		offList.add(new SelectOption('US - Almaty, Kazakhstan - 12/24 Dostyk-Kazaybek Bi St','US - Almaty, Kazakhstan - 12/24 Dostyk-Kazaybek Bi St'));
		offList.add(new SelectOption('US - Amherst, NY - 100 Corporate Pkwy','US - Amherst, NY - 100 Corporate Pkwy'));
		offList.add(new SelectOption('US - Amman, Jordan','US - Amman, Jordan'));
		offList.add(new SelectOption('US - Anchorage, AK - 1835 S Bragaw St','US - Anchorage, AK - 1835 S Bragaw St'));
		offList.add(new SelectOption('US - Annapolis Junction, MD - 430 National Business Parkway','US - Annapolis Junction, MD - 430 National Business Parkway'));
		offList.add(new SelectOption('US - Arizona - Telecommute','US - Arizona - Telecommute'));
		offList.add(new SelectOption('US - Arlington, VA - 100 Boundry Channel Dr','US - Arlington, VA - 100 Boundry Channel Dr'));
		offList.add(new SelectOption('US - Arlington, VA - 2101 Wilson Blvd','US - Arlington, VA - 2101 Wilson Blvd'));
		offList.add(new SelectOption('US - Arlington, VA - 3101 Wilson Blvd','US - Arlington, VA - 3101 Wilson Blvd'));
		offList.add(new SelectOption('US - Arlington, VA - Army Navy Dr & Fern St','US - Arlington, VA - Army Navy Dr & Fern St'));
		offList.add(new SelectOption('US - Arlington, WA - 27700 Washington 530','US - Arlington, WA - 27700 Washington 530'));
		offList.add(new SelectOption('US - Astoria, NY','US - Astoria, NY'));
		offList.add(new SelectOption('US - Astoria, NY - 42-15 Berrian Blvd','US - Astoria, NY - 42-15 Berrian Blvd'));
		offList.add(new SelectOption('US - Atlanta, GA - 1360 Peachtree St NE','US - Atlanta, GA - 1360 Peachtree St NE'));
		offList.add(new SelectOption('US - Atlanta, GA - 2400 Piedmont Rd NE','US - Atlanta, GA - 2400 Piedmont Rd NE'));
		offList.add(new SelectOption('US - Austin, TX - 400 W 15th St','US - Austin, TX - 400 W 15th St'));
		offList.add(new SelectOption('US - Bakersfield, CA - 5001 E Commercenter Dr','US - Bakersfield, CA - 5001 E Commercenter Dr'));
		offList.add(new SelectOption('US - Baltimore, MD - 100 S Charles Street - MTA Prj Office','US - Baltimore, MD - 100 S Charles Street - MTA Prj Office'));
		offList.add(new SelectOption('US - Baltimore, MD - 6 Saint Paul Street - MTA Office','US - Baltimore, MD - 6 Saint Paul Street - MTA Office'));
		offList.add(new SelectOption('US - Baltimore, MD - 7 Saint Paul St','US - Baltimore, MD - 7 Saint Paul St'));
		offList.add(new SelectOption('US - Bamako, Mali','US - Bamako, Mali'));
		offList.add(new SelectOption('US - Bangkok, Thailand - 5/117 Soi Suanlu','US - Bangkok, Thailand - 5/117 Soi Suanlu'));
		offList.add(new SelectOption('US - Baton Rouge, LA - 232 Third St','US - Baton Rouge, LA - 232 Third St'));
		offList.add(new SelectOption('US - Battle Creek, MI - 4625 Beckley Road','US - Battle Creek, MI - 4625 Beckley Road'));
		offList.add(new SelectOption('US - Bellingham, WA - 401 Harris Ave','US - Bellingham, WA - 401 Harris Ave'));
		offList.add(new SelectOption('US - Bethesda, MD - 6000 MacArthur Boulevard','US - Bethesda, MD - 6000 MacArthur Boulevard'));
		offList.add(new SelectOption('US - Billings, MT - 207 N Broadway STE 315','US - Billings, MT - 207 N Broadway STE 315'));
		offList.add(new SelectOption('US - Birmingham, AL - 3800 Colonnade Parkway','US - Birmingham, AL - 3800 Colonnade Parkway'));
		offList.add(new SelectOption('US - Birmingham, MI','US - Birmingham, MI'));
		offList.add(new SelectOption('US - Bismarck, ND - 400 East Broadway','US - Bismarck, ND - 400 East Broadway'));
		offList.add(new SelectOption('US - Bloomington, IN - 1800 W 17th St','US - Bloomington, IN - 1800 W 17th St'));
		offList.add(new SelectOption('US - Boston, MA - 66 Long Wharf','US - Boston, MA - 66 Long Wharf'));
		offList.add(new SelectOption('US - Bronx, NY - 2301 White Plains Road','US - Bronx, NY - 2301 White Plains Road'));
		offList.add(new SelectOption('US - Brooklyn, NY - 4105 Ave V','US - Brooklyn, NY - 4105 Ave V'));
		offList.add(new SelectOption('US - California - Telecommute','US - California - Telecommute'));
		offList.add(new SelectOption('US - Camarillo, CA - 1220 Avenida Acaso','US - Camarillo, CA - 1220 Avenida Acaso'));
		offList.add(new SelectOption('US - Centennial, CO 12445 East Caley Ave','US - Centennial, CO 12445 East Caley Ave'));
		offList.add(new SelectOption('US - Charleston, SC - 3820 Faber Place Dr','US - Charleston, SC - 3820 Faber Place Dr'));
		offList.add(new SelectOption('US - Charlotte, NC - 5925 Carnegie Boulevard','US - Charlotte, NC - 5925 Carnegie Boulevard'));
		offList.add(new SelectOption('US - Chelmsford, MA - 250 Apollo Drive','US - Chelmsford, MA - 250 Apollo Drive'));
		offList.add(new SelectOption('US - Chestnut Ridge, NY - 100 Red Schoolhouse Rd','US - Chestnut Ridge, NY - 100 Red Schoolhouse Rd'));
		offList.add(new SelectOption('US - Chicago, IL - 10510 W Zemke Rd','US - Chicago, IL - 10510 W Zemke Rd'));
		offList.add(new SelectOption('US - Chicago, IL - 1 S Wacker Dr','US - Chicago, IL - 1 S Wacker Dr'));
		offList.add(new SelectOption('US - Chicago, IL - 303 E Wacker Dr','US - Chicago, IL - 303 E Wacker Dr'));
		offList.add(new SelectOption('US - Chico, CA','US - Chico, CA'));
		offList.add(new SelectOption('US - Churubusco, NY - 385 Ryan Rd','US - Churubusco, NY - 385 Ryan Rd'));
		offList.add(new SelectOption('US - Cincinnati, OH - 4219 Malsbary Rd','US - Cincinnati, OH - 4219 Malsbary Rd'));
		offList.add(new SelectOption('US - Cleveland, OH - 1001 Lakeside Avenue','US - Cleveland, OH - 1001 Lakeside Avenue'));
		offList.add(new SelectOption('US - College Park, GA - 1255 S Loop Rd','US - College Park, GA - 1255 S Loop Rd'));
		offList.add(new SelectOption('US - College Park, MD - 8601 Adelphi Rd','US - College Park, MD - 8601 Adelphi Rd'));
		offList.add(new SelectOption('US - Colorado Springs, CO','US - Colorado Springs, CO'));
		offList.add(new SelectOption('US - Colorado Springs, CO - 160 Patrick St','US - Colorado Springs, CO - 160 Patrick St'));
		offList.add(new SelectOption('US - Colorado - Telecommute','US - Colorado - Telecommute'));
		offList.add(new SelectOption('US - Columbia, MD - 8320 Guilford Rd','US - Columbia, MD - 8320 Guilford Rd'));
		offList.add(new SelectOption('US - Columbia, SC','US - Columbia, SC'));
		offList.add(new SelectOption('US - Columbus, OH - 300 E Broad Street','US - Columbus, OH - 300 E Broad Street'));
		offList.add(new SelectOption('US - Connecticut - Telecommute','US - Connecticut - Telecommute'));
		offList.add(new SelectOption('US - Coral Gables, FL','US - Coral Gables, FL'));
		offList.add(new SelectOption('US - Coral Springs, FL - 11555 Heron Bay Blvd','US - Coral Springs, FL - 11555 Heron Bay Blvd'));
		offList.add(new SelectOption('US - Cutler Bay, FL - 32300 SW 97th Avenue','US - Cutler Bay, FL - 32300 SW 97th Avenue'));
		offList.add(new SelectOption('US - Dallas, TX - 1401 Pacific Ave','US - Dallas, TX - 1401 Pacific Ave'));
		offList.add(new SelectOption('US - Dallas, TX - 16000 Dallas Parkway','US - Dallas, TX - 16000 Dallas Parkway'));
		offList.add(new SelectOption('US - Dallas, TX - 3801 Herschel Ave','US - Dallas, TX - 3801 Herschel Ave'));
		offList.add(new SelectOption('US - Denver, CO - 717 17th St','US - Denver, CO - 717 17th St'));
		offList.add(new SelectOption('US - Denver, CO - 8500 Pena Blvd','US - Denver, CO - 8500 Pena Blvd'));
		offList.add(new SelectOption('US - Des Moines, IA - 500 SW 7th St','US - Des Moines, IA - 500 SW 7th St'));
		offList.add(new SelectOption('US - Destin, FL - 4300 Legendary Dr','US - Destin, FL - 4300 Legendary Dr'));
		offList.add(new SelectOption('US - Detroit, MI - 719 Griswold St','US - Detroit, MI - 719 Griswold St'));
		offList.add(new SelectOption('US - District of Columbia - Telecommute','US - District of Columbia - Telecommute'));
		offList.add(new SelectOption('US - Doha, Qatar','US - Doha, Qatar'));
		offList.add(new SelectOption('US - Doha, Qatar - Pearl Bldg PO Box 6650','US - Doha, Qatar - Pearl Bldg PO Box 6650'));
		offList.add(new SelectOption('US - Doha, Qatar - United Car Al-Mana Building','US - Doha, Qatar - United Car Al-Mana Building'));
		offList.add(new SelectOption('US - Duluth, MN - 11 East Superior Street','US - Duluth, MN - 11 East Superior Street'));
		offList.add(new SelectOption('US - East Islip, NY - 164 Easy Main Street','US - East Islip, NY - 164 Easy Main Street'));
		offList.add(new SelectOption('US - East Syracuse, NY - 5015 Campuswood Dr','US - East Syracuse, NY - 5015 Campuswood Dr'));
		offList.add(new SelectOption('US - East Windsor, NJ - 50 Millstone Rd','US - East Windsor, NJ - 50 Millstone Rd'));
		offList.add(new SelectOption('US - Edmond, OK - 2305 Faircloud Cove','US - Edmond, OK - 2305 Faircloud Cove'));
		offList.add(new SelectOption('US - Edmonton, Alberta','US - Edmonton, Alberta'));
		offList.add(new SelectOption('US - Egg Harbor Township, NJ','US - Egg Harbor Township, NJ'));
		offList.add(new SelectOption('US - El Paso, TX - Ft Bliss DOL','US - El Paso, TX - Ft Bliss DOL'));
		offList.add(new SelectOption('US - Flint, MI','US - Flint, MI'));
		offList.add(new SelectOption('US - Florida - Telecommute','US - Florida - Telecommute'));
		offList.add(new SelectOption('US - Fort Collins, CO - 1513 Webster Court','US - Fort Collins, CO - 1513 Webster Court'));
		offList.add(new SelectOption('US - Fort Collins, CO - 1601 Prospect Pkwy','US - Fort Collins, CO - 1601 Prospect Pkwy'));
		offList.add(new SelectOption('US - Fort Lauderdale, FL - 2300 W Commercial Blvd','US - Fort Lauderdale, FL - 2300 W Commercial Blvd'));
		offList.add(new SelectOption('US - Fort Lauderdale, FL - 3400 Commercial Blvd','US - Fort Lauderdale, FL - 3400 Commercial Blvd'));
		offList.add(new SelectOption('US - Fort Lauderdale, FL - 4101 Ravenswood Road','US - Fort Lauderdale, FL - 4101 Ravenswood Road'));
		offList.add(new SelectOption('US - Fort Myers, FL','US - Fort Myers, FL'));
		offList.add(new SelectOption('US - Fort Myers, FL - 4415 Metro Pkwy','US - Fort Myers, FL - 4415 Metro Pkwy'));
		offList.add(new SelectOption('US - Fort Pierce, FL - 222 Colonial Rd','US - Fort Pierce, FL - 222 Colonial Rd'));
		offList.add(new SelectOption('US - Fort Worth, TX - 1200 Summit Avenue Suite 102','US - Fort Worth, TX - 1200 Summit Avenue Suite 102'));
		offList.add(new SelectOption('US - Fort Worth, TX - 1200 Summit Avenue Suite 320','US - Fort Worth, TX - 1200 Summit Avenue Suite 320'));
		offList.add(new SelectOption('US - Fort Worth, TX - 2821 Cullen St','US - Fort Worth, TX - 2821 Cullen St'));
		offList.add(new SelectOption('US - Fresno, CA - 1360 E Spruce Ave','US - Fresno, CA - 1360 E Spruce Ave'));
		offList.add(new SelectOption('US - Ft Myers, FL - 10041 Daniels Parkway','US - Ft Myers, FL - 10041 Daniels Parkway'));
		offList.add(new SelectOption('US - Gaborone, Botswana - PO Box 602090','US - Gaborone, Botswana - PO Box 602090'));
		offList.add(new SelectOption('US - Georgia - Telecommute','US - Georgia - Telecommute'));
		offList.add(new SelectOption('US - Glen Allen, VA - 4840 Cox Road','US - Glen Allen, VA - 4840 Cox Road'));
		offList.add(new SelectOption('US - Grand Rapids, MI - 5555 Glenwood Hills Pkwy SE','US - Grand Rapids, MI - 5555 Glenwood Hills Pkwy SE'));
		offList.add(new SelectOption('US - Green Bay, WI - 1035 Kepler Dr','US - Green Bay, WI - 1035 Kepler Dr'));
		offList.add(new SelectOption('US - Greenville, SC - 10 Patewood Dr','US - Greenville, SC - 10 Patewood Dr'));
		offList.add(new SelectOption('US - Greenwich, CT','US - Greenwich, CT'));
		offList.add(new SelectOption('US - Hagatna, Guam - 414 W Soledad Ave','US - Hagatna, Guam - 414 W Soledad Ave'));
		offList.add(new SelectOption('US - Harrisburg, PA - 210 Pine Street','US - Harrisburg, PA - 210 Pine Street'));
		offList.add(new SelectOption('US - Hawaii - Telecommute','US - Hawaii - Telecommute'));
		offList.add(new SelectOption('US - Herndon, VA - 380 Herndon Pkwy','US - Herndon, VA - 380 Herndon Pkwy'));
		offList.add(new SelectOption('US - High Holborn, London','US - High Holborn, London'));
		offList.add(new SelectOption('US - Hilo, HI','US - Hilo, HI'));
		offList.add(new SelectOption('US - Hollywood, FL - 6565 Taft Street','US - Hollywood, FL - 6565 Taft Street'));
		offList.add(new SelectOption('US - Honolulu, HI - 1001 Bishop St','US - Honolulu, HI - 1001 Bishop St'));
		offList.add(new SelectOption('US - Horsham, PA - 125 Rock Rd','US - Horsham, PA - 125 Rock Rd'));
		offList.add(new SelectOption('US - Houston, TX - 5444 Westheimer Road','US - Houston, TX - 5444 Westheimer Road'));
		offList.add(new SelectOption('US - Huntsville, AL - 310 The Bridge Street','US - Huntsville, AL - 310 The Bridge Street'));
		offList.add(new SelectOption('US - Hyattsville, MD - 6525 Belcrest Rd','US - Hyattsville, MD - 6525 Belcrest Rd'));
		offList.add(new SelectOption('US - Idaho - Telecommute','US - Idaho - Telecommute'));
		offList.add(new SelectOption('US - Illinois - Telecommute','US - Illinois - Telecommute'));
		offList.add(new SelectOption('US - Indianapolis, IN - 4030 Vincennes Road','US - Indianapolis, IN - 4030 Vincennes Road'));
		offList.add(new SelectOption('US - Indiana - Telecommute','US - Indiana - Telecommute'));
		offList.add(new SelectOption('US - Indian Springs, NV - 432 WG/UASOCS 2nd St','US - Indian Springs, NV - 432 WG/UASOCS 2nd St'));
		offList.add(new SelectOption('US - Jacksonville, FL','US - Jacksonville, FL'));
		offList.add(new SelectOption('US - Jacksonville, FL - 10151 Deerwood Park Blvd','US - Jacksonville, FL - 10151 Deerwood Park Blvd'));
		offList.add(new SelectOption('US - Jamaica, NY - JFK Airport','US - Jamaica, NY - JFK Airport'));
		offList.add(new SelectOption('US - Jeddah, Saudi Arabia - Sultan Center Bldg','US - Jeddah, Saudi Arabia - Sultan Center Bldg'));
		offList.add(new SelectOption('US - Juba, Sudan - PO Box 18','US - Juba, Sudan - PO Box 18'));
		offList.add(new SelectOption('US - Kansas City, MO - 2380 McGee St','US - Kansas City, MO - 2380 McGee St'));
		offList.add(new SelectOption('US - Kansas - Telecommute','US - Kansas - Telecommute'));
		offList.add(new SelectOption('US - Kentucky - Telecommute','US - Kentucky - Telecommute'));
		offList.add(new SelectOption('US - Lake Mary, FL - 300 Colonial Center Pkwy','US - Lake Mary, FL - 300 Colonial Center Pkwy'));
		offList.add(new SelectOption('US - Lansing, MI - 401 S Washington Sq','US - Lansing, MI - 401 S Washington Sq'));
		offList.add(new SelectOption('US - Las Vegas, NV - 250 Pilot Rd','US - Las Vegas, NV - 250 Pilot Rd'));
		offList.add(new SelectOption('US - Las Vegas, NV - 3373 Pepper Lane','US - Las Vegas, NV - 3373 Pepper Lane'));
		offList.add(new SelectOption('US - Las Vegas, NV - 7660 W Cheyenne Ave','US - Las Vegas, NV - 7660 W Cheyenne Ave'));
		offList.add(new SelectOption('US - Latham, NY - 40 British American Blvd','US - Latham, NY - 40 British American Blvd'));
		offList.add(new SelectOption('US - Laurel, MD','US - Laurel, MD'));
		offList.add(new SelectOption('US - Lenexa, KS - 9401 Renner Blvd','US - Lenexa, KS - 9401 Renner Blvd'));
		offList.add(new SelectOption('US - Livonia, MI - 13955 Farmington Rd','US - Livonia, MI - 13955 Farmington Rd'));
		offList.add(new SelectOption('US - Long Beach, CA - 3995 Via Oro Ave','US - Long Beach, CA - 3995 Via Oro Ave'));
		offList.add(new SelectOption('US - Long Island City, NY','US - Long Island City, NY'));
		offList.add(new SelectOption('US - Los Angeles, CA - 1999 Avenue of the Stars','US - Los Angeles, CA - 1999 Avenue of the Stars'));
		offList.add(new SelectOption('US - Los Angeles, CA - 515 S Flower','US - Los Angeles, CA - 515 S Flower'));
		offList.add(new SelectOption('US - Los Angeles, CA - 555 S Flower','US - Los Angeles, CA - 555 S Flower'));
		offList.add(new SelectOption('US - Los Angeles, CA - 7301 World Way West','US - Los Angeles, CA - 7301 World Way West'));
		offList.add(new SelectOption('US - Louisiana - Telecommute','US - Louisiana - Telecommute'));
		offList.add(new SelectOption('US - Lynchburg, VA','US - Lynchburg, VA'));
		offList.add(new SelectOption('US - Makati City, Philippines - 168 Salcedo St','US - Makati City, Philippines - 168 Salcedo St'));
		offList.add(new SelectOption('US - Manchester, NH - 1000 Elm Street','US - Manchester, NH - 1000 Elm Street'));
		offList.add(new SelectOption('US - Maputo, Mozambique','US - Maputo, Mozambique'));
		offList.add(new SelectOption('US - Marquette, MI','US - Marquette, MI'));
		offList.add(new SelectOption('US - Maryland - Telecommute','US - Maryland - Telecommute'));
		offList.add(new SelectOption('US - Marysville, CA - 2088 N Beale Rd','US - Marysville, CA - 2088 N Beale Rd'));
		offList.add(new SelectOption('US - Massachusetts - Telecommute','US - Massachusetts - Telecommute'));
		offList.add(new SelectOption('US - Mechanicsburg, PA - 100 Sterling Parkway','US - Mechanicsburg, PA - 100 Sterling Parkway'));
		offList.add(new SelectOption('US - Mexico City, Mexico - Cerro de la Estrella 107 PH','US - Mexico City, Mexico - Cerro de la Estrella 107 PH'));
		offList.add(new SelectOption('US - Miami, FL - 1001 NW 111th Ave','US - Miami, FL - 1001 NW 111th Ave'));
		offList.add(new SelectOption('US - Michigan - Telecommute','US - Michigan - Telecommute'));
		offList.add(new SelectOption('US - Middlebury, VT','US - Middlebury, VT'));
		offList.add(new SelectOption('US - Middleton, WI - 1350 Deming Way','US - Middleton, WI - 1350 Deming Way'));
		offList.add(new SelectOption('US - Milwaukee, WI','US - Milwaukee, WI'));
		offList.add(new SelectOption('US - Milwaukee, WI - 1555 N Rivercenter Drive','US - Milwaukee, WI - 1555 N Rivercenter Drive'));
		offList.add(new SelectOption('US - Minneapolis, MN - 800 LaSalle Ave','US - Minneapolis, MN - 800 LaSalle Ave'));
		offList.add(new SelectOption('US - Minnesota - Telecommute','US - Minnesota - Telecommute'));
		offList.add(new SelectOption('US - Missouri - Telecommute','US - Missouri - Telecommute'));
		offList.add(new SelectOption('US - Moffett Federal Airfield, CA','US - Moffett Federal Airfield, CA'));
		offList.add(new SelectOption('US - Montgomery, AL','US - Montgomery, AL'));
		offList.add(new SelectOption('US - Morgantown, WV','US - Morgantown, WV'));
		offList.add(new SelectOption('US - Nashville, TN - 220 Athens Way','US - Nashville, TN - 220 Athens Way'));
		offList.add(new SelectOption('US - Nassau, The Bahamas - West Bay Street','US - Nassau, The Bahamas - West Bay Street'));
		offList.add(new SelectOption('US - Nebraska - Telecommute','US - Nebraska - Telecommute'));
		offList.add(new SelectOption('US - Nevada - Telecommute','US - Nevada - Telecommute'));
		offList.add(new SelectOption('US - Newark, NJ - 1 Riverfront Plaza','US - Newark, NJ - 1 Riverfront Plaza'));
		offList.add(new SelectOption('US - Newark, NJ - 2 Gateway Center','US - Newark, NJ - 2 Gateway Center'));
		offList.add(new SelectOption('US - Newark, NJ - 570 Broad St','US - Newark, NJ - 570 Broad St'));
		offList.add(new SelectOption('US - New Hampshire - Telecommute','US - New Hampshire - Telecommute'));
		offList.add(new SelectOption('US - New Haven, CT','US - New Haven, CT'));
		offList.add(new SelectOption('US - New Jersey - Telecommute','US - New Jersey - Telecommute'));
		offList.add(new SelectOption('US - New Mexico - Telecommute','US - New Mexico - Telecommute'));
		offList.add(new SelectOption('US - New Orleans, LA - 1555 Poydras St','US - New Orleans, LA - 1555 Poydras St'));
		offList.add(new SelectOption('US - New York, NY - 100 Broadway, 3rd + 4th Floors','US - New York, NY - 100 Broadway, 3rd + 4th Floors'));
		offList.add(new SelectOption('US - New York, NY - 100 Park Ave','US - New York, NY - 100 Park Ave'));
		offList.add(new SelectOption('US - New York, NY - 125 Broad Street','US - New York, NY - 125 Broad Street'));
		offList.add(new SelectOption('US - New York, NY - 30 Broad Street','US - New York, NY - 30 Broad Street'));
		offList.add(new SelectOption('US - New York, NY - 314 E 34th St','US - New York, NY - 314 E 34th St'));
		offList.add(new SelectOption('US - New York, NY - 469 7th Ave','US - New York, NY - 469 7th Ave'));
		offList.add(new SelectOption('US - New York, NY - 605 Third Ave','US - New York, NY - 605 Third Ave'));
		offList.add(new SelectOption('US - New York, NY - 71 West 23rd St','US - New York, NY - 71 West 23rd St'));
		offList.add(new SelectOption('US - New York, NY - Alexander Hamilton','US - New York, NY - Alexander Hamilton'));
		offList.add(new SelectOption('US - New York, NY - Moynihan Station','US - New York, NY - Moynihan Station'));
		offList.add(new SelectOption('US - New York, NY - Penn Station','US - New York, NY - Penn Station'));
		offList.add(new SelectOption('US - New York, NY - Randall\'s Island SVC Rd','US - New York, NY - Randall\'s Island SVC Rd'));
		offList.add(new SelectOption('US - New York, NY - Rte 9A Pier 40','US - New York, NY - Rte 9A Pier 40'));
		offList.add(new SelectOption('US - New York, NY - Tappan Zee','US - New York, NY - Tappan Zee'));
		offList.add(new SelectOption('US - New York - Telecommute','US - New York - Telecommute'));
		offList.add(new SelectOption('US - Norfolk, VA - 440 Monticello Ave','US - Norfolk, VA - 440 Monticello Ave'));
		offList.add(new SelectOption('US - North Carolina - Telecommute','US - North Carolina - Telecommute'));
		offList.add(new SelectOption('US - Oakland, CA - 2101 Webster St','US - Oakland, CA - 2101 Webster St'));
		offList.add(new SelectOption('US - Oak Ridge, TN - 117A Broadway Ave','US - Oak Ridge, TN - 117A Broadway Ave'));
		offList.add(new SelectOption('US - Ohio - Telecommute','US - Ohio - Telecommute'));
		offList.add(new SelectOption('US - Oklahoma - Telecommute','US - Oklahoma - Telecommute'));
		offList.add(new SelectOption('US - Olyphant, PA','US - Olyphant, PA'));
		offList.add(new SelectOption('US - Omaha, NE - 12020 Shamrock Plaza','US - Omaha, NE - 12020 Shamrock Plaza'));
		offList.add(new SelectOption('US - Ontario, CA - 1131 W Sixth St','US - Ontario, CA - 1131 W Sixth St'));
		offList.add(new SelectOption('US - Ontario, CA - 901 Via Piemonte','US - Ontario, CA - 901 Via Piemonte'));
		offList.add(new SelectOption('US - Orange, CA - 999 Town & Country Rd','US - Orange, CA - 999 Town & Country Rd'));
		offList.add(new SelectOption('US - Oregon - Telecommute','US - Oregon - Telecommute'));
		offList.add(new SelectOption('US - Orlando, FL - 150 N Orange Ave','US - Orlando, FL - 150 N Orange Ave'));
		offList.add(new SelectOption('US - Orlando, FL - 1560 North Orange Ave','US - Orlando, FL - 1560 North Orange Ave'));
		offList.add(new SelectOption('US - Oshkosh, WI','US - Oshkosh, WI'));
		offList.add(new SelectOption('US - Palmdale, CA - 41235 11th St W','US - Palmdale, CA - 41235 11th St W'));
		offList.add(new SelectOption('US - Pennsylvania - Telecommute','US - Pennsylvania - Telecommute'));
		offList.add(new SelectOption('US - Petion-Ville, Haiti - rue Panaméricaine no 47','US - Petion-Ville, Haiti - rue Panaméricaine no 47'));
		offList.add(new SelectOption('US - Philadelphia, PA - 1700 Market St','US - Philadelphia, PA - 1700 Market St'));
		offList.add(new SelectOption('US - Philadelphia, PA - 1900 Market St','US - Philadelphia, PA - 1900 Market St'));
		offList.add(new SelectOption('US - Philadelphia, PA - 2 Intl Plaza','US - Philadelphia, PA - 2 Intl Plaza'));
		offList.add(new SelectOption('US - Phoenix, AZ - 2325 E Camelback','US - Phoenix, AZ - 2325 E Camelback'));
		offList.add(new SelectOption('US - Piketon, OH - 1862 Shyville Road','US - Piketon, OH - 1862 Shyville Road'));
		offList.add(new SelectOption('US - Piscataway, NJ - 30 Knightsbridge Rd','US - Piscataway, NJ - 30 Knightsbridge Rd'));
		offList.add(new SelectOption('US - Pittsburgh, PA - 416 7th Avenue','US - Pittsburgh, PA - 416 7th Avenue'));
		offList.add(new SelectOption('US - Pittsburgh, PA - 707 Grant Street','US - Pittsburgh, PA - 707 Grant Street'));
		offList.add(new SelectOption('US - Pocasset, MA - 9 Jonathan Bourne Drive','US - Pocasset, MA - 9 Jonathan Bourne Drive'));
		offList.add(new SelectOption('US - Pompano Beach, FL - Florida\'s Turnpike Enterprise','US - Pompano Beach, FL - Florida\'s Turnpike Enterprise'));
		offList.add(new SelectOption('US - Portland, OR - 333 SW 5th Ave','US - Portland, OR - 333 SW 5th Ave'));
		offList.add(new SelectOption('US - Port of Spain, Trinidad & Tobago - 26 Kelly Kenny St','US - Port of Spain, Trinidad & Tobago - 26 Kelly Kenny St'));
		offList.add(new SelectOption('US - Prague, Czech Republic - Trojska 92','US - Prague, Czech Republic - Trojska 92'));
		offList.add(new SelectOption('US - Providence, RI','US - Providence, RI'));
		offList.add(new SelectOption('US - Pueblo, CO - 45825 Hwy 96E','US - Pueblo, CO - 45825 Hwy 96E'));
		offList.add(new SelectOption('US - Queens, NY - LIRR','US - Queens, NY - LIRR'));
		offList.add(new SelectOption('US - Raleigh, NC - 701 Corporate Center Dr','US - Raleigh, NC - 701 Corporate Center Dr'));
		offList.add(new SelectOption('US - Reading, PA','US - Reading, PA'));
		offList.add(new SelectOption('US - Reston, VA - 11911 Freedom Drive','US - Reston, VA - 11911 Freedom Drive'));
		offList.add(new SelectOption('US - Rhode Island - Telecommute','US - Rhode Island - Telecommute'));
		offList.add(new SelectOption('US - Richland, WA - 825 Goethals Drive','US - Richland, WA - 825 Goethals Drive'));
		offList.add(new SelectOption('US - Richmond, VA - 900 East Broad Street','US - Richmond, VA - 900 East Broad Street'));
		offList.add(new SelectOption('US - Riyadh, Saudi Arabia - King Abdullah Education Bldg','US - Riyadh, Saudi Arabia - King Abdullah Education Bldg'));
		offList.add(new SelectOption('US - Roanoke, VA - 10 S Jefferson St','US - Roanoke, VA - 10 S Jefferson St'));
		offList.add(new SelectOption('US - Roanoke, VA - 1315 Franklin Rd','US - Roanoke, VA - 1315 Franklin Rd'));
		offList.add(new SelectOption('US - Rochester, NY - 1200 Brooks Ave','US - Rochester, NY - 1200 Brooks Ave'));
		offList.add(new SelectOption('US - Rocky Hill, CT','US - Rocky Hill, CT'));
		offList.add(new SelectOption('US - Rocky Hill, CT - 500 Enterprise Dr','US - Rocky Hill, CT - 500 Enterprise Dr'));
		offList.add(new SelectOption('US - Sacramento, CA - 10411 Old Placerville Rd','US - Sacramento, CA - 10411 Old Placerville Rd'));
		offList.add(new SelectOption('US - Sacramento, CA - 10461 Old Placerville Rd','US - Sacramento, CA - 10461 Old Placerville Rd'));
		offList.add(new SelectOption('US - Sacramento, CA - 2020 L St','US - Sacramento, CA - 2020 L St'));
		offList.add(new SelectOption('US - Sacramento, CA - 6705 Lindbergh Dr','US - Sacramento, CA - 6705 Lindbergh Dr'));
		offList.add(new SelectOption('US - Salt Lake City, UT - 776 N Terminal Dr','US - Salt Lake City, UT - 776 N Terminal Dr'));
		offList.add(new SelectOption('US - San Antonio, TX - 112 Pecan Street','US - San Antonio, TX - 112 Pecan Street'));
		offList.add(new SelectOption('US - San Diego, CA - 1420 Kettner Blvd','US - San Diego, CA - 1420 Kettner Blvd'));
		offList.add(new SelectOption('US - San Diego, CA - 2417 McCain Road','US - San Diego, CA - 2417 McCain Road'));
		offList.add(new SelectOption('US - San Diego, CA - 7807 Convoy Ct','US - San Diego, CA - 7807 Convoy Ct'));
		offList.add(new SelectOption('US - Sandy, UT - 45 West 10000 South','US - Sandy, UT - 45 West 10000 South'));
		offList.add(new SelectOption('US - San Francisco, CA - 300 California Street','US - San Francisco, CA - 300 California Street'));
		offList.add(new SelectOption('US - San Jose, CA - 2025 Gateway Pl','US - San Jose, CA - 2025 Gateway Pl'));
		offList.add(new SelectOption('US - San Luis Obispo, CA - 1194 Pacific St','US - San Luis Obispo, CA - 1194 Pacific St'));
		offList.add(new SelectOption('US - Santa Maria, CA - 2400 Professional Parkway','US - Santa Maria, CA - 2400 Professional Parkway'));
		offList.add(new SelectOption('US - Sarasota, FL - 6151 Lake Osprey Drive','US - Sarasota, FL - 6151 Lake Osprey Drive'));
		offList.add(new SelectOption('US - Seattle, WA - 710 Second Ave','US - Seattle, WA - 710 Second Ave'));
		offList.add(new SelectOption('US - Shatin, Hong Kong - 138 Shatin Rural Committee Road','US - Shatin, Hong Kong - 138 Shatin Rural Committee Road'));
		offList.add(new SelectOption('US - Sheboygan, WI - 4135 Technology Pkwy','US - Sheboygan, WI - 4135 Technology Pkwy'));
		offList.add(new SelectOption('US - Singapore - 300 Beach Rd','US - Singapore - 300 Beach Rd'));
		offList.add(new SelectOption('US - Sioux Falls, SD - 2801 N Jaycee Lane','US - Sioux Falls, SD - 2801 N Jaycee Lane'));
		offList.add(new SelectOption('US - Solana Beach, CA - 440 Stevens Ave','US - Solana Beach, CA - 440 Stevens Ave'));
		offList.add(new SelectOption('US - South Carolina - Telecommute','US - South Carolina - Telecommute'));
		offList.add(new SelectOption('US - Southport, CT - 2425 Post Rd','US - Southport, CT - 2425 Post Rd'));
		offList.add(new SelectOption('US - South Portland, ME - 500 Southborough Dr','US - South Portland, ME - 500 Southborough Dr'));
		offList.add(new SelectOption('US - Spokane, WA','US - Spokane, WA'));
		offList.add(new SelectOption('US - Springfield, VA - 6564 Loisdale Ct','US - Springfield, VA - 6564 Loisdale Ct'));
		offList.add(new SelectOption('US - Springfield, VA - 7405 Alban Station Ct','US - Springfield, VA - 7405 Alban Station Ct'));
		offList.add(new SelectOption('US - Springfield, VA - OCONUS Classified','US - Springfield, VA - OCONUS Classified'));
		offList.add(new SelectOption('US - State College, PA','US - State College, PA'));
		offList.add(new SelectOption('US - Stevens Point, WI - 200 Indiana Ave','US - Stevens Point, WI - 200 Indiana Ave'));
		offList.add(new SelectOption('US - Stuart, FL - 850 NW Federal Highway','US - Stuart, FL - 850 NW Federal Highway'));
		offList.add(new SelectOption('US - Sugar Creek, MO - PO Box 7770','US - Sugar Creek, MO - PO Box 7770'));
		offList.add(new SelectOption('US - Tampa, FL - One Metro Center','US - Tampa, FL - One Metro Center'));
		offList.add(new SelectOption('US - Tennessee - Telecommute','US - Tennessee - Telecommute'));
		offList.add(new SelectOption('US - Texas - Telecommute','US - Texas - Telecommute'));
		offList.add(new SelectOption('US - Trenton, NJ','US - Trenton, NJ'));
		offList.add(new SelectOption('US - Tripoli, Libya','US - Tripoli, Libya'));
		offList.add(new SelectOption('US - Tucson, AZ - 1840 East River Road','US - Tucson, AZ - 1840 East River Road'));
		offList.add(new SelectOption('US - Utah - Telecommute','US - Utah - Telecommute'));
		offList.add(new SelectOption('US - Vermont - Telecommute','US - Vermont - Telecommute'));
		offList.add(new SelectOption('US - Vernon Hills, IL','US - Vernon Hills, IL'));
		offList.add(new SelectOption('US - Virginia - Telecommute','US - Virginia - Telecommute'));
		offList.add(new SelectOption('US - Wakefield, MA','US - Wakefield, MA'));
		offList.add(new SelectOption('US - Warner Robins, GA - 1452 Corporate Point','US - Warner Robins, GA - 1452 Corporate Point'));
		offList.add(new SelectOption('US - Warrenville, IL - 27755 Diehl Rd','US - Warrenville, IL - 27755 Diehl Rd'));
		offList.add(new SelectOption('US - Washington, DC - 1150 18th St NW','US - Washington, DC - 1150 18th St NW'));
		offList.add(new SelectOption('US - Washington, DC - 5000 Overlook Ave SW','US - Washington, DC - 5000 Overlook Ave SW'));
		offList.add(new SelectOption('US - Washington - Telecommute','US - Washington - Telecommute'));
		offList.add(new SelectOption('US - Waterloo, IA - 501 Sycamore St','US - Waterloo, IA - 501 Sycamore St'));
		offList.add(new SelectOption('US - West Palm Beach, FL - 2090 Palm Beach Lakes Blvd','US - West Palm Beach, FL - 2090 Palm Beach Lakes Blvd'));
		offList.add(new SelectOption('US - West Palm Beach, FL - 2300 N Jog Road','US - West Palm Beach, FL - 2300 N Jog Road'));
		offList.add(new SelectOption('US - Wichita, KS','US - Wichita, KS'));
		offList.add(new SelectOption('US - Wilmington, DE - 1013 Centre Rd','US - Wilmington, DE - 1013 Centre Rd'));
		offList.add(new SelectOption('US - Windhoek, Namibia','US - Windhoek, Namibia'));
		offList.add(new SelectOption('US - Wisconsin - Telecommute','US - Wisconsin - Telecommute'));
		offList.add(new SelectOption('US - Wyoming - Telecommute','US - Wyoming - Telecommute'));
		offList.add(new SelectOption('VE - Caracas, Venezuela - Av Solano Centro Emp Sabana Grande','VE - Caracas, Venezuela - Av Solano Centro Emp Sabana Grande'));
		offList.add(new SelectOption('VN - Ho Chi Minh City - 7/F Saigon Finance Centre','VN - Ho Chi Minh City - 7/F Saigon Finance Centre'));
		offList.add(new SelectOption('ZA - Bloemfontein, 27 President Steyn Avenue','ZA - Bloemfontein, 27 President Steyn Avenue'));
		offList.add(new SelectOption('ZA - Cape Town, 45 Buitengragt Street','ZA - Cape Town, 45 Buitengragt Street'));
		offList.add(new SelectOption('ZA - Cape Town, Carl Cronje Drive, Bellville','ZA - Cape Town, Carl Cronje Drive, Bellville'));
		offList.add(new SelectOption('ZA - Durban, 2 Maryvale Road, Westville','ZA - Durban, 2 Maryvale Road, Westville'));
		offList.add(new SelectOption('ZA - East London, 35 Tecoma Street, Berea','ZA - East London, 35 Tecoma Street, Berea'));
		offList.add(new SelectOption('ZA - George, 97 Mitchell Street','ZA - George, 97 Mitchell Street'));
		offList.add(new SelectOption('ZA - Johannesburg, 11 St Andrews Road, Park Town','ZA - Johannesburg, 11 St Andrews Road, Park Town'));
		offList.add(new SelectOption('ZA - Johannesburg - 145 West Street','ZA - Johannesburg - 145 West Street'));
		offList.add(new SelectOption('ZA - Mthatha - 93 Nelson Mandela Dr','ZA - Mthatha - 93 Nelson Mandela Dr'));
		offList.add(new SelectOption('ZA - Nelspruit, 3 Le Roux Street','ZA - Nelspruit, 3 Le Roux Street'));
		offList.add(new SelectOption('ZA - Pietermaritzburg, 170 Peter Brown Drive','ZA - Pietermaritzburg, 170 Peter Brown Drive'));
		offList.add(new SelectOption('ZA - Polokwane, 118 General Beyers Street','ZA - Polokwane, 118 General Beyers Street'));
		offList.add(new SelectOption('ZA - Port Elizabeth, 2 Fort Street','ZA - Port Elizabeth, 2 Fort Street'));
		offList.add(new SelectOption('ZA - Potchefstroom, 39 Buskus Street','ZA - Potchefstroom, 39 Buskus Street'));
		offList.add(new SelectOption('ZA - Pretoria, 263A West Avenue, Centurion','ZA - Pretoria, 263A West Avenue, Centurion'));
		offList.add(new SelectOption('ZA - Richards Bay, 68 Dollar Lane','ZA - Richards Bay, 68 Dollar Lane'));
		offList.add(new SelectOption('ZA - Rustenburg, 67 Brink Street','ZA - Rustenburg, 67 Brink Street'));
		offList.add(new SelectOption('ZA - Stellenbosch, Time Square','ZA - Stellenbosch, Time Square'));
		return offList;
    }

    public String getBusinessLine() {
    	String retVal = '';
    	if(mUserConditions.get('businessLine') != null) {
    		retVal = (String)mUserConditions.get('businessLine').value;
    	}
    	return retVal;
    }

    public void setBusinessLine(String busLine) {
    	mUserConditions.put('businessLine', new Condition(busLine, ' = ', 'Business_Line__c'));
    }
    public List<SelectOption> getBusinessLineList() {
    	List<SelectOption> busLineList = new List<SelectOption>();
    	busLineList.add(new SelectOption('','--None--'));
    	busLineList.add(new SelectOption('AECOM Corp','AECOM Corp'));
		busLineList.add(new SelectOption('AGS','AGS'));
		busLineList.add(new SelectOption('AID','AID'));
		busLineList.add(new SelectOption('Architecture','Architecture'));
		busLineList.add(new SelectOption('Building Engineering','Building Engineering'));
		busLineList.add(new SelectOption('Construction Services','Construction Services'));
		busLineList.add(new SelectOption('DP&E','DP&E'));
		busLineList.add(new SelectOption('Design-Build','Design-Build'));
		busLineList.add(new SelectOption('Energy','Energy'));
		busLineList.add(new SelectOption('Environment','Environment'));
		busLineList.add(new SelectOption('GSS','GSS'));
		busLineList.add(new SelectOption('Geography OH','Geography OH'));
		busLineList.add(new SelectOption('Geotechnical','Geotechnical'));
		busLineList.add(new SelectOption('Mining & Metals','Mining & Metals'));
		busLineList.add(new SelectOption('PCC','PCC'));
		busLineList.add(new SelectOption('Planning Design & Dev','Planning Design & Dev'));
		busLineList.add(new SelectOption('Transportation','Transportation'));
		busLineList.add(new SelectOption('Water','Water'));
		return busLineList;
    }

    public Boolean getActive() {
    	return Boolean.valueOf(mUserConditions.get('active').value);
    }

    public void setActive(Boolean value) {
    	String operator = ' = ';
    	String field = 'IsActive';
    	mUserConditions.put('active',new Condition(String.valueOf(value),operator,field));
    }

    public String getName() {
    	return (String)this.mObj.get('Name');
    }

    public void setName(String name) {
    	this.mObj.put('Name',name);
    } 

	public rsSearch(rs_Search__c s) {
		super(s);
	}

	public void setResultFields(List<String> resultFields) {
		mResultFields = resultFields;
	}

	public List<String> getResultFields() {
		return mResultFields;
	}

	public String getSearchType() {
		return mSearchType;
	}

	public void setSearchType(String type) {
		mSearchType = type;
	}

	//Sets up conditions lists/map based on the text search and user fields
	//and puts them into the Search object
	public void setConditions(String textSearch) {
		mPRTeamEmpConditions = new List<Condition>();
		textSearch = textSearch+'%';
		if(mSearchType == BASIC_SEARCH) {
			mConditions = new List<Condition>();
			List<Condition> saveConditions = new List<Condition>();
			for(SearchField s : getFieldsForObject('rs_Profile_Part__c',false)) {
				if((rsStringUtil.cleanFieldName(s.getSelectOption().getValue(),'|') != 'License_Registration_Name__c' ) 
					&& (rsStringUtil.cleanFieldName(s.getSelectOption().getValue(),'|') != 'License_Registration_Country__c')) {
					mConditions.add(new Condition(textSearch,'LIKE',rsStringUtil.cleanFieldName(s.getSelectOption().getValue(),'|')));
				} else if(rsStringUtil.cleanFieldName(s.getSelectOption().getValue(),'|') == 'License_Registration_Name__c' 
					&& !rsStringUtil.isNullOrEmpty(mLicenseReg)) {
					mConditions.add(new Condition(mLicenseReg,'LIKE',rsStringUtil.cleanFieldName(s.getSelectOption().getValue(),'|')));
				} else if (rsStringUtil.cleanFieldName(s.getSelectOption().getValue(),'|') == 'License_Registration_Country__c'
					&& !rsStringUtil.isNullOrEmpty(mLicenseRegCountry)) {
					mConditions.add(new Condition(mLicenseRegCountry,'LIKE',rsStringUtil.cleanFieldName(s.getSelectOption().getValue(),'|')));
				}
			}
			for(SearchField s : getFieldsForObject('PR_Team_Employee__c',false)) {
				mPRTeamEmpConditions.add(new Condition(textSearch,'=',rsStringUtil.cleanFieldName(s.getSelectOption().getValue(),'|')));
			}
		} else if(mSearchType == ADVANCED_SEARCH) {
			System.debug('list mConditions size: ' + mConditions.size());
			List<Condition> conditions = new List<Condition>();
			for(Condition cond : mConditions) {
				System.debug('#### cond.value : ' + cond.value + ' cond.field: ' + cond.field + ' cond.operator: ' + cond.operator);
				if(!rsStringUtil.isNullOrEmpty(cond.value) && !rsStringUtil.isNullOrEmpty(cond.operator) &&
					!rsStringUtil.isNullOrEmpty(cond.field)) {
					conditions.add(cond);
				}
			}
			setConditions(conditions);
		}
		List<String> selectFields = new List<String>();
		for(SelectOption os : getSelectedFieldOptions()) {
			selectFields.add(os.getValue());
		}
		mObj.put('PR_Team_Employee_Fields__c',JSON.serializePretty(mPRTeamEmpConditions));
		mObj.put('User_Fields__c',JSON.serializePretty(mUserConditions));
		mObj.put('Search_Fields__c',JSON.serializePretty(mConditions));
		mObj.put('Result_Fields__c',JSON.serializePretty(selectFields));
		mObj.put('User__c',UserInfo.getUserId());
		mObj.put('Search_Type__c',mSearchType);
		mObj.put('Filter_Logic__c',mFilter);
	}

	public void setConditions(List<Condition> cond) {
		mConditions = cond;
		if(mConditions != null && mConditions.size() > 0 && mSearchType == BASIC_SEARCH) {
			System.debug('### condition text' + mConditions.get(0).value.replaceAll('%',''));
			mTextSearch = (mConditions.get(0).value.replaceAll('%|"null"',''));
			for(Condition condition : mConditions) {
				System.debug('#### ' + condition.value);
				if(condition.field == 'License_Registration_Name__c' &&  String.isNotBlank(condition.value) && !condition.value.startsWith('%')) {
					mLicenseReg = condition.value;
				} else if(condition.field == 'License_Registration_Country__c' && !condition.value.startsWith('%') && String.isNotBlank(condition.value)) {
					mLicenseRegCountry = condition.value;
				}
			}
		} else if(mConditions.size() < 5 && mSearchType == ADVANCED_SEARCH) {
			while(mConditions.size() < 5) {
				mConditions.add(new Condition('','',''));
			}
		} 
	}

	public Map<String,Condition> getUserConditions() {
		return mUserConditions;
	}

	public void setUserConditions(Map<String,Condition> cond) {
		mUserConditions = cond;
	}

	public List<Condition> getConditions() {
		return mConditions;
	}

	public List<Condition> getPRTeamEmployeeConditions() {
		return mPRTeamEmpConditions;
	}

	public void setPRTeamEmployeeConditions(List<Condition> cond) {
		mPRTeamEmpConditions = cond;
	} 

	public List<SearchField> getSearchFields() {

        List<SearchField> searchFields = new List<SearchField>();
    	searchFields.addAll(getFieldsForObject('User',true));
    	searchFields.sort();
        return searchFields;
	}

	public List<SelectOption> getAdvancedFieldOptions() {
		if(mAdvancedFieldOptions == null) {
			List<SearchField> searchFields = new List<SearchField>(); 			// Adding Search fields that are filterable
	        searchFields.addAll(getFieldsForObject('PR_Team_Employee__c',false));
	    	searchFields.addAll(getFieldsForObject('User',false));
	    	searchFields.addAll(getFieldsForObject('rs_Profile_Part__c',false));
	    	searchFields.sort();
			List<SelectOption> options = new List<SelectOption>();
			for(SearchField s : searchFields) {
	            options.add(s.getSelectOption());
			}
			mAdvancedFieldOptions = options;
		}
		return mAdvancedFieldOptions;
	}

	public List<SelectOption> getResultFieldOptions() {
		if(mResultFieldsOptions == null) {
			List<SelectOption> options = new List<SelectOption>();
			for(SearchField s : getSearchFields()) {
				if( s.FieldName != 'User|Name' &&
					s.FieldName != 'User|Title' &&
					s.FieldName != 'User|Business_Line__c' &&
					s.FieldName != 'User|Region__c' &&
					s.FieldName != 'User|Email' &&
					s.FieldName != 'User|City' &&
					s.FieldName != 'User|Phone' &&
					s.FieldName != 'User|Cisco_IP_Phone__c') {
	            	options.add(s.getSelectOption());
				} else {
					if(mSelectedFieldOptions == null) {
						if(s.FieldName != 'User|Name') setSelectedFieldOptions(new List<SelectOption>{s.getSelectOption()});
						else setSelectedFieldOptions(new List<SelectOption>{new SelectOption('User|Name',Label.Name)});
					} else {
						if(s.FieldName != 'User|Name') mSelectedFieldOptions.add(s.getSelectOption());
						else mSelectedFieldOptions.add(new SelectOption('User|Name',Label.Name));
					}
				}
			}
			mResultFieldsOptions = options;
		} else {
			//blau AECR-664, Select Option has a sort that doesn't sort by label
			// will have to turn list into search fields, sort, then turn back into 
			// select option
			List<SearchField> sortList = new List<SearchField>();
			for(SelectOption sel : mResultFieldsOptions) {
				String objectName = sel.getValue().substring(0,sel.getValue().indexOf('|'));
				sortList.add(new SearchField(sel.getValue(),sel.getLabel(),objectName));
			}
			sortList.sort();
			mResultFieldsOptions.clear();
			for(SearchField s : sortList) {
				mResultFieldsOptions.add(s.getSelectOption());
			}
		}
		return mResultFieldsOptions;
	}

	public void setResultFieldOptions(List<SelectOption> resOptions) {
		mResultFieldsOptions = resOptions;
	}
	
	public List<SelectOption> getSelectedFieldOptions() {
		if(mSelectedFieldOptions == null) {
			mSelectedFieldOptions = new List<SelectOption>();
		}
		return mSelectedFieldOptions;
	}

	public List<String> getSelectedFields() {
		if(mSelectedFields == null) {
			mSelectedFields = new List<String>();
		}
		return mSelectedFields;
	}

	public String getTextSearch() {
		if(mTextSearch == null) {
			mTextSearch = '';
		}
		return mTextSearch;
	}

	public String getFilter() {
		return mFilter;
	}

	public void setTextSearch(String search) {
		mTextSearch = search;
	} 

	public void setSelectedFields(List<String> selFields) {
		mSelectedFields = selFields;
	}

	public void setSelectedFieldOptions(List<SelectOption> selOptions) {
		mSelectedFieldOptions = selOptions;
	}

	public void setFilter(String filterString) {
		mFilter = filterString;
	}

	private void sortSelectedFieldsSpecific() {
		if(mSelectedFieldOptions.size() == 8) {
			SelectOption nameOp = new SelectOption('','');
			SelectOption titleOp = new SelectOption('','');
			SelectOption businessLineOp = new SelectOption('','');
			SelectOption regionOp = new SelectOption('','');
			SelectOption phoneOp = new SelectOption('','');
			SelectOption extOp = new SelectOption('','');
			SelectOption emailOp = new SelectOption('','');
			SelectOption cityOp = new SelectOption('','');

			for( SelectOption op : mSelectedFieldOptions ) {
				if(op.getValue() == 'User|Name') {
					nameOp = op;
				} else if ( op.getValue() == 'User|Title' ) {
					titleOp = op;
				} else if ( op.getValue() == 'User|Business_Line__c' ) {
					businessLineOp = op;
				} else if ( op.getValue() == 'User|Region__c' ) {
					regionOp = op;
				} else if ( op.getValue() == 'User|Email' ) {
					emailOp = op;
				} else if ( op.getValue() == 'User|City' ) {
					cityOp = op;
				} else if ( op.getValue() == 'User|Phone' ) {
					phoneOp = op;
				} else if ( op.getValue() == 'User|Cisco_IP_Phone__c' ) {
					extOp = op;
				}
			}
			mSelectedFieldOptions.set(0, nameOp);
			mSelectedFieldOptions.set(1, titleOp);
			mSelectedFieldOptions.set(2, businessLineOp);
			mSelectedFieldOptions.set(3, regionOp);
			mSelectedFieldOptions.set(4, phoneOp);
			mSelectedFieldOptions.set(5, extOp);
			mSelectedFieldOptions.set(6, emailOp);
			mSelectedFieldOptions.set(7, cityOp);
		}
	}

	private Map<String,Condition> setUpUserConditionMap() {
		Map<String, Condition> userMap = new Map<String, Condition>();
		userMap.put('lastName',new Condition('%%','=','LastName'));
		userMap.put('firstName',new Condition('%%','=','FirstName'));
		userMap.put('active',new Condition('false','=','IsActive'));
		userMap.put('geography',new Condition('','=','Geography__c'));
		userMap.put('officeLocation',new Condition('','=','Office__c'));
		userMap.put('businessLine',new Condition('','=','Business_Line__c'));
		userMap.put('country', new Condition('','=','Country'));
		return userMap;
	}

	private List<SearchField> getFieldsForObject(String objectName, Boolean getNonFilterable) {
        List<SearchField> searchFields = new List<SearchField>();

        SObjectType objToken = Schema.getGlobalDescribe().get(objectName);
        Map<String, Schema.SObjectField> objectFields 
    	    = objToken.getDescribe().fields.getMap();

    	for(String key : objectFields.keySet()) {
    		Schema.DescribeFieldResult f = objectFields.get(key).getDescribe();
    		if(f.isAccessible() && isSearchable(f) && getNonFilterable && !IGNORED_FIELDS.contains(f.getName())) {
                searchFields.add( 
                    new SearchField(objectName + '|' + f.getName(),f.getLabel(),objectName)
                );
    		} else if(f.isAccessible() && isSearchable(f) && !getNonFilterable && f.isFilterable() && !IGNORED_FIELDS.contains(f.getName())) {
    			searchFields.add( 
                    new SearchField(objectName + '|' + f.getName(),f.getLabel(),objectName)
                );
    		}
    	}

        return searchFields;
	}

	private Boolean isSearchable(Schema.DescribeFieldResult f) {
		
		//TODO - this probably needs to be a hardcoded set of API names or something
		//Since we can't do it by data type
        Schema.DisplayType t = f.getType();
		return t == Schema.DisplayType.Email
		|| t == Schema.DisplayType.TextArea
		|| t == Schema.DisplayType.Picklist
		|| t == Schema.DisplayType.String
		|| t == Schema.DisplayType.Phone;

	}

	global class SearchField implements Comparable {
		
		public String FieldName {get; set;}
		public String FieldLabel {get; set;}
		public String FieldObject {get; set;}

		public SearchField(String fieldName, String fieldLabel, String fieldObject) {
			this.FieldName = fieldName;
			this.FieldLabel = fieldLabel;
			this.FieldObject = fieldObject;
		}

		public SelectOption getSelectOption() {
            return new SelectOption(this.FieldName, this.FieldLabel);
		}

        global Integer compareTo(Object compareTo) {
      
            SearchField compareToField = (SearchField)compareTo; 
            return this.FieldLabel.compareTo(compareToField.FieldLabel);    
        }


	}

	public class Condition {
        public String value {get; set;}
        public String operator {get; set;}
        public String field {get; set;}

        public Condition(String value, String operator, String field) {
        	this.value = value;
        	this.operator = operator;
        	this.field = field;
        }

        public List<SelectOption> getOperators() {
			List<SelectOption> operators = new List<SelectOption>();
			if(!rsStringUtil.isNullOrEmpty(field) && field.contains('|')) {
				String objectName = field.substring(0,field.indexOf('|'));
				String fieldName = rsStringUtil.cleanFieldName(field, '|');
				Schema.DisplayType dispType = getDisplayType(objectName,fieldName);
				if(dispType == Schema.DisplayType.TextArea) {
					operators.add(new SelectOption('c','contains'));
					operators.add(new SelectOption('dnc','does not contain'));
				} else if (dispType == Schema.DisplayType.String || dispType == Schema.DisplayType.Picklist 
					|| dispType == Schema.DisplayType.Email || dispType == Schema.DisplayType.Phone) {
					operators.add(new SelectOption('e','equals'));
					operators.add(new SelectOption('ne','not equal to'));
					operators.add(new SelectOption('lt','less than'));
					operators.add(new SelectOption('gt','greater than'));
					operators.add(new SelectOption('loe','less or equal'));
					operators.add(new SelectOption('goe','greater or equal'));
					operators.add(new SelectOption('c','contains'));
					operators.add(new SelectOption('dnc','does not contain'));
					operators.add(new SelectOption('sw','starts with'));
				}
			} else {
				operators.add(new SelectOption('e','equals'));
				operators.add(new SelectOption('ne','not equal to'));
				operators.add(new SelectOption('c','contains'));
				operators.add(new SelectOption('sw','starts with'));
				operators.add(new SelectOption('dnc','does not contain'));
				operators.add(new SelectOption('lt','less than'));
				operators.add(new SelectOption('gt','greater than'));
				operators.add(new SelectOption('loe','less or equal'));
				operators.add(new SelectOption('goe','greater or equal'));
				operators.add(new SelectOption('i','includes'));
				operators.add(new SelectOption('x','excludes'));
				operators.add(new SelectOption('w','within'));
			}
			return operators;
		}

		public Schema.DisplayType getDisplayType(String objectName, String fieldName) {
			Schema.DisplayType dispType = null;
			if(objectName == 'User') {
				dispType = rsSearch.USER_FIELDS.get(fieldName).getDescribe().getType();
			} else if(objectName == 'rs_Profile_Part__c') {
				dispType = rsSearch.PROFILE_PART_FIELDS.get(fieldName).getDescribe().getType();
			} else if(objectName == 'PR_Team_Employee__c') {
				dispType = rsSearch.PR_TEAM_EMPLOYEE_FIELDS.get(fieldName).getDescribe().getType();
			} else {
				SObjectType objToken = Schema.getGlobalDescribe().get(objectName);
		        Map<String, Schema.SObjectField> objectFields = objToken.getDescribe().fields.getMap();
		        dispType = objectFields.get(fieldName).getDescribe().getType();
		    }
	    	return dispType;
		}
	}

	public class Finder extends rsFinder {

        public Finder(String sObjectName) {
        	super(sObjectName);
        }

        public override rsModel byId(Id recId) {
        	return new rsSearch((rs_Search__c)byId(recId).getObj());
        }

        public List<rsSearch> getSearchesByUser(String userId) {
        	List<rsSearch> searches = new List<rsSearch>();
        	List<rs_Search__c> rsSearches = (List<rs_Search__c>)Database.query(getSelect() + 'where User__c =: userId ORDER BY Name ASC');
        	for(rs_Search__c s : rsSearches) {
        		searches.add(new rsSearch(s));
        	}
        	return searches;
        }

	}

	public static final String BASIC_SEARCH = 'Basic';
	public static final String ADVANCED_SEARCH = 'Advanced';
	public static final Map<String, Schema.SObjectField> USER_FIELDS = Schema.getGlobalDescribe().get('User').getDescribe().fields.getMap();
	public static final Map<String, Schema.SObjectField> PROFILE_PART_FIELDS = Schema.getGlobalDescribe().get('rs_Profile_Part__c').getDescribe().fields.getMap();
	public static final Map<String, Schema.SObjectField> PR_TEAM_EMPLOYEE_FIELDS = Schema.getGlobalDescribe().get('PR_Team_Employee__c').getDescribe().fields.getMap();
	private static final Set<String> IGNORED_FIELDS = new Set<String>{  'ChkUniqueEmp__c',
																		'Client__c',
																		'Client_Name__c',
																		'Client_Name_Editable__c',								
																		'CurrencyIsoCode',
																		'Emp_Name__c',
																		'Initial_Locale__c',
																		'Location_Country_Editable__c',
																		'Location_State_Prov_Emirate_Editable__c',
																		'Oracle_Project_Number__c',
																		'Project_Group_Editable__c',
																		'Project_Number__c',
																		'ProjectSort__c',
																		'PRStatusEmployee__c',
																		'Resume_Link__c',
																		'Status__c',
																		'Attachment_Id__c',
																		'CurrencyIsoCode',
																		'Alias',
																		'Allocation_Subcategory__c',
																		'Assignment_Status__c',
																		'Citizenship__c',
																		'Comment_on_User__c',
																		'CommunityNickname',
																		'CompanyName',
																		'CurrencyIsoCode',
																		'DefaultCurrencyIsoCode',
																		'DefaultGroupNotificationFrequency',
																		'DigestFrequency',
																		'Division',
																		'EmailEncodingKey',
																		'Employee_Category__c',
																		'FederationIdentifier',
																		'Gender__c',
																		'Geography_Allocation__c',
																		'Global_Position_Title__c',
																		'IDReport__c',
																		'International_Assignment_Status__c',
																		'Job_Family_Meaning__c',
																		'LanguageLocaleKey',
																		'LocaleSidKey',
																		'Location_City_Editable__c',																		
																		'Manager_Email__c',
																		'Manager_Name__c',
																		'ManagerID__c',
																		'Middle_Names__c',
																		'Names_Suffix__c',
																		'Nationality__c',
																		'PortalRole',
																		'PostalCode',
																		'Project_Name_Editable__c',
																		'Project_Number_Editable__c',
																		'Religion__c',
																		'SenderEmail',
																		'SenderName',
																		'Service_Line__c',
																		'Signature',
																		'Status__c',
																		'StayInTouchNote',
																		'StayInTouchSignature',
																		'StayInTouchSubject',
																		'Sub_Business_Line__c',
																		'TimeZoneSidKey',
																		'TrackingID__c',
																		'User_Name__c',
																		'Username',
																		'UserType'
																		};
}