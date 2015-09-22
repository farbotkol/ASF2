public with sharing class INC_EnrollmentLetterController {

	public EnrollmentParticipant__c oEP;
	public calcHolder oCH;
	public string epID {get;set;}



	public class calcHolder{
		public date letterDate{get;set;}
		public decimal V {get;set;}
		public decimal Y {get;set;}
		public decimal AF {get;set;}
		public decimal W {get;set;}
		public decimal Z {get;set;}
		public decimal AG {get;set;}
		public decimal X {get;set;}
		public decimal AA {get;set;}
		public decimal AH {get;set;}
		public decimal AC {get;set;}
		public decimal AD {get;set;}
		public decimal AE {get;set;}	
		public string gmtm {get;set;}	

		public void calculate(EnrollmentParticipant__c ep){
			letterDate = date.today();

			if(ep.EnrollmentPlan__r.IncentivePlan__r.ContractSubType__c == 'Gross Margin'){
				gmtm = 'GM';
			} else {
				gmtm = 'NM';
			}


			V = EP.EnrollmentPlan__r.BaselineGrossMargin__c * 1.1;
			Y = EP.EnrollmentPlan__r.BaselineGrossMargin__c * 1.25;
			AE = EP.EnrollmentPlan__r.BaselineGrossMargin__c * 1.5;
			AF = AE - EP.EnrollmentPlan__r.BaselineGrossMargin__c;
			W = V - EP.EnrollmentPlan__r.BaselineGrossMargin__c;
			Z = Y - EP.EnrollmentPlan__r.BaselineGrossMargin__c;
			AG = AF * EP.EnrollmentPlan__r.IncentivePlan__r.ProfitSharingPercent__c;
			X =  W * EP.EnrollmentPlan__r.IncentivePlan__r.ProfitSharingPercent__c;
			AA = Z * EP.EnrollmentPlan__r.IncentivePlan__r.ProfitSharingPercent__c;

			if(EP.TargetIncentivePoolAllocated__c != null){
				AH = AG * EP.TargetIncentivePoolAllocated__c;
				AC = X  * EP.TargetIncentivePoolAllocated__c;
				AD = AA * EP.TargetIncentivePoolAllocated__c;	
			}		
		}
	}


	private void getEP(){
		if(oEP == null){
			oEP  = [select id
								, name
								, CurrencyIsoCode
								, TargetIncentivePoolAllocated__c
								, EnrollmentPlan__r.Approver1__r.name
								, EmployeeName__r.name
								, EmployeeName__r.firstname
								, EnrollmentPlan__r.IncentiveProject__r.name
								, EnrollmentPlan__r.IncentiveProject__r.contracttype__c
								, EnrollmentPlan__r.IncentivePlan__r.name
								, EnrollmentPlan__r.IncentivePlan__r.ProfitSharingPercent__c
								, EnrollmentPlan__r.IncentivePlan__r.ContractSubType__c
								, EnrollmentPlan__r.BaselineGrossMargin__c
								, EnrollmentPlan__r.BaselineGMofNSR__c	
								, EnrollmentPlan__r.DSOTarget__c					

						from EnrollmentParticipant__c
						where id=:epID];
		}		
	}

	public EnrollmentParticipant__c getoEP(){
		getEP();
		return oEP;
	}

	public calcHolder getoCH(){
		getEP();

		if(oCH == null){
			oCH = new calcHolder();
			oCH.calculate(oEP);
		}

		return oCH;
	}


	public INC_EnrollmentLetterController() {

	}

}