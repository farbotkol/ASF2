trigger ECO_ReviewMember on ReviewMember__c (before insert, before update) {

	set<id> listTeamMembers = new set<id>();
	map<id, ReviewMember__c> mapRM = new map<id, ReviewMember__c>();

	for(ReviewMember__c rm: trigger.new){
		listTeamMembers.add(rm.TechnicalQualityTeamMember__c);
		mapRM.put(rm.TechnicalQualityTeamMember__c, rm);
	}

	list<TechnicalQualityTeam__c> lstTQM = [select id, TechnicalQualityTeamMember__c from TechnicalQualityTeam__c where id IN: listTeamMembers];

	for(TechnicalQualityTeam__c TQM: lstTQM) {
		if(mapRM.containskey(TQM.id)) {
			mapRM.get(TQM.id).User_Stamp__c = TQM.TechnicalQualityTeamMember__c;
		}
	}

}