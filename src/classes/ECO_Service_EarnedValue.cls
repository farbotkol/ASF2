public without sharing class ECO_Service_EarnedValue {


	public static List<EarnedValueTask__c> getEarnedValueTasksForEarnedValueSnapShot(Id earnedValueSnapShotId){
		
		List<EarnedValueTask__c> results = [SELECT Id,
												PercentComplete__c,
												ProjectTask__c,
												NotifyTaskOwner__c,
												Comments__c,
												Committed__c,
												CostAccruals__c
											FROM EarnedValueTask__c
											WHERE EarnedValueSnapshot__c = :earnedValueSnapShotId];

		return results;

	}

	public static List<EarnedValueTask__c> getEarnedValueTasksForEarnedValueReport(Id earnedValueHeaderId){
		List<EarnedValueTask__c> results = new List<EarnedValueTask__c>();

		Set<Id> snapshotIds = new Set<Id>();
		List<EarnedValueSnapshot__c> snapshots = getEarnedValueSnapShotsForReport(earnedValueHeaderId);
		if(!snapshots.isEmpty()){
			for(EarnedValueSnapshot__c snapshot : snapshots){
				snapshotIds.add(snapshot.Id);
			}
		}
		
		results = [SELECT Id,
						PercentComplete__c,
						ProjectTask__c,
						NotifyTaskOwner__c,
						Comments__c,
						Committed__c,
						CostAccruals__c,
						EarnedValueSnapshot__c 
					FROM EarnedValueTask__c
					WHERE EarnedValueSnapshot__c IN :snapshotIds
					ORDER BY EarnedValueSnapshot__r.AsOfDate__c ASC];

		return results;

	}


	public static List<EarnedValueSnapshot__c> getEarnedValueSnapShotsForReport(Id earnedValueHeaderId){

		List<EarnedValueSnapshot__c> results = [SELECT Id
													, AsOfDate__c
													//, EarnedValueHeader__c
													, Comments__c
												FROM EarnedValueSnapshot__c
												//WHERE EarnedValueHeader__c = :earnedValueHeaderId
												ORDER BY AsOfDate__c DESC];

		return results;

	}

	public static List<EarnedValueSnapshot__c> getEarnedValueSnapShotsForReportAsc(Id earnedValueHeaderId){

		List<EarnedValueSnapshot__c> results = [SELECT Id
													, AsOfDate__c
													//, EarnedValueHeader__c
													, Comments__c
												FROM EarnedValueSnapshot__c
												//WHERE EarnedValueHeader__c = :earnedValueHeaderId
												ORDER BY AsOfDate__c ASC];

		return results;

	}

	public static EarnedValueSnapshot__c getLatestEarnedValueSnapshot(Id earnedValueHeaderId){
		
		EarnedValueSnapshot__c result = null;

		List<EarnedValueSnapshot__c> snapshots = getEarnedValueSnapShotsForReport(earnedValueHeaderId);
		if(!snapshots.isEmpty()){
			result = snapshots.get(0);
		}

		return result;
	}

	public static Map<Id, EarnedValueSnapshot__c> getLatestEarnedValueSnapShotsForReports(Set<Id> earnedValueHeaderIds){
		Map<Id, EarnedValueSnapshot__c> results = new Map<Id, EarnedValueSnapshot__c>();

		List<EarnedValueSnapshot__c> snapshots = [SELECT Id
													, AsOfDate__c
													//, EarnedValueHeader__c
													, Comments__c
												FROM EarnedValueSnapshot__c
												//WHERE EarnedValueHeader__c IN :earnedValueHeaderIds
												ORDER BY AsOfDate__c DESC];

		
		for(EarnedValueSnapshot__c snapshot : snapshots){
			//if(!results.containsKey(snapshot.EarnedValueHeader__c)){
				//results.put(snapshot.EarnedValueHeader__c, snapshot);
			//}
		}	

		return results;

	}
	
	public static List<EVPoint> getAllEVPointsForProject (Id projectId) {
		List<EVPoint> returnList = new List<EVPoint>();
		
		for (AggregateResult ar : [SELECT WeekStartDate__c
										, SUM(ThisWeekAmount__c) totalAmountThisWeek
										, SUM(ThisWeekRunningTotalAmount__c) totalAmountSoFar
									FROM EarnedValueSnapshot__c
									WHERE ProjectTask__r.pse__Project__c = :projectId
									GROUP BY WeekStartDate__c
									ORDER BY WeekStartDate__c]) {
			EVPoint newPoint = new EVPoint();
			newPoint.weekStartDate = (Date)ar.get('WeekStartDate__c');
			newPoint.amountThisWeek = (Decimal)ar.get('totalAmountThisWeek'); 
			newPoint.amountSoFar = (Decimal)ar.get('totalAmountSoFar'); 
			returnList.add(newPoint);
		}
		
		return returnList;
	}
	
	public class EVPoint {
		public Date weekStartDate;
		public Decimal amountThisWeek;
		public Decimal amountSoFar;
	}
	
	public static Map<String, List<EarnedValueSnapshot__c>> calculateFrontLoadedCurveForTask (pse__Project_Task__c projTask, List<EarnedValueSnapshot__c> existingSnaps) {
		if (projTask.pse__Start_Date__c == null) {
			throw new EarnedValueException('Start Date cannot be null for task:  '+projTask.Id);
		}
		if (projTask.pse__End_Date__c == null) {
			throw new EarnedValueException('End Date cannot be null for task:  '+projTask.Id);
		}
		if (projTask.TotalApprovedCost__c == null) {
			return null;
			throw new EarnedValueException('Total Approved Cost cannot be null for task:  '+projTask.Id);
		}
		if (existingSnaps == null) {
			throw new EarnedValueException('Incoming Project Task must include Earned Value Snapshot Subquery for task:  '+projTask.Id);
		}
		
		Map<String, List<EarnedValueSnapshot__c>> returnMap = new Map<String, List<EarnedValueSnapshot__c>>();
		returnMap.put('Upsert', new List<EarnedValueSnapshot__c>());
		returnMap.put('Delete', new List<EarnedValueSnapshot__c>());
		
		Date startDateWeekStartDay = projTask.pse__Start_Date__c.toStartOfWeek();
		Date endDateWeekStartDay = projTask.pse__End_Date__c.toStartOfWeek();
		Integer daysBetween = startDateWeekStartDay.daysBetween(endDateWeekStartDay);
		Integer numOfWeeks = (daysBetween/7)+1;
		
		Decimal averageAmount = projTask.TotalApprovedCost__c / numOfWeeks;
		Decimal runningTotal = 0;
		Integer weekNum = 1;
		Date weekStartDateRunning = startDateWeekStartDay;
		
		List<EarnedValueSnapshot__c> evsToUpsert = new List<EarnedValueSnapshot__c>();
		List<EarnedValueSnapshot__c> evsToDelete = new List<EarnedValueSnapshot__c>();
		
		for (Decimal i = 0; i < numOfWeeks; i++) {
			
			system.debug('averageAmount:  '+averageAmount);
			
			Decimal taskAmount = Math.log(Math.pow((Double)averageAmount, (Double)i+1));
			
			taskAmount = taskAmount.setScale(2, System.RoundingMode.HALF_UP);
			
			system.debug('taskAmount:  '+taskAmount);
			
			runningTotal += taskAmount;
			
			EarnedValueSnapshot__c newEVSnap = new EarnedValueSnapshot__c();
			newEVSnap.ProjectTask__c = projTask.Id;
			newEVSnap.CompositeKey__c = projTask.Id+'_'+weekNum;
			newEVSnap.SnapshotKey__c = ECO_Service_Snapshots.DateToSnapshotKey(weekStartDateRunning, projTask.pse__Project__c, projTask.Id);
			newEVSnap.WeeklyRollupEntry__r = new WeeklyRollupEntry__c(CompositeKey__c = ECO_Service_Snapshots.DateToSnapshotKey(weekStartDateRunning, projTask.pse__Project__c));
			newEVSnap.WeekStartDate__c = weekStartDateRunning;
			newEVSnap.ThisWeekNumber__c = weekNum;
			newEVSnap.ThisWeekAmount__c = taskAmount;
			
			evsToUpsert.add(newEVSnap);
			
			weekNum++;
			weekStartDateRunning = weekStartDateRunning.addDays(7);
		}
		
		system.debug('projTask.TotalApprovedCost__c:  '+projTask.TotalApprovedCost__c);
		system.debug('runningTotal:  '+runningTotal);
		
		// now we have task amounts that are way too huge to be the final amount, but we have good ratios between them, step it down
		Decimal fixerRatio = projTask.TotalApprovedCost__c / runningTotal;
		
		system.debug('fixerRatio:  '+fixerRatio);
		
		// reset the running total
		runningTotal = 0;
		
		// with the ratio we can fix the amounts
		for (EarnedValueSnapshot__c evs : evsToUpsert) {
			evs.ThisWeekAmount__c = (evs.ThisWeekAmount__c * fixerRatio).setScale(2, System.RoundingMode.HALF_UP);
			
			//system.debug('fixed evs.ThisWeekAmount__c:  '+evs.ThisWeekAmount__c);
			
			runningTotal += evs.ThisWeekAmount__c;
			
			evs.ThisWeekRunningTotalAmount__c = runningTotal;
			evs.ThisWeekTotalRemaining__c = projTask.TotalApprovedCost__c - runningTotal;
		}
		
		// reset the running total
		runningTotal = 0;
		
		List<Decimal> valuesList = new List<Decimal>(); // We'll use this to hold values in the order we want them
		
		// Now we have the curve, let's reverse it for front loaded.
		for (Integer i = evsToUpsert.size()-1 ; i >= 0 ; i--) {
			
			valuesList.add(evsToUpsert[i].ThisWeekAmount__c);
			
			system.debug('reverse order:  '+evsToUpsert[i].ThisWeekAmount__c);
		}
		
		// Finally, let's loop once more in the proper order to replace all the values
		Integer listPos = 0;
		for (EarnedValueSnapshot__c evs : evsToUpsert) {
			evs.ThisWeekAmount__c = valuesList[listPos];
			
			runningTotal += evs.ThisWeekAmount__c;
			
			evs.ThisWeekRunningTotalAmount__c = runningTotal;
			evs.ThisWeekTotalRemaining__c = projTask.TotalApprovedCost__c - runningTotal;
			
			listPos++;
		}
		
		for (EarnedValueSnapshot__c ev : existingSnaps) {
			if (ev.ThisWeekNumber__c > numOfWeeks) {
				evsToDelete.add(ev);
			}
		}
		
		returnMap.get('Upsert').addAll(evsToUpsert);
		returnMap.get('Delete').addAll(evsToDelete);
		
		return returnMap;
	}
	
	public static Map<String, List<EarnedValueSnapshot__c>> calculateBackLoadedCurveForTask (pse__Project_Task__c projTask, List<EarnedValueSnapshot__c> existingSnaps) {
		if (projTask.pse__Start_Date__c == null) {
			throw new EarnedValueException('Start Date cannot be null for task:  '+projTask.Id);
		}
		if (projTask.pse__End_Date__c == null) {
			throw new EarnedValueException('End Date cannot be null for task:  '+projTask.Id);
		}
		if (projTask.TotalApprovedCost__c == null) {
			throw new EarnedValueException('Total Approved Cost cannot be null for task:  '+projTask.Id);
		}
		if (existingSnaps == null) {
			throw new EarnedValueException('Incoming Project Task must include Earned Value Snapshot Subquery for task:  '+projTask.Id);
		}
		
		Map<String, List<EarnedValueSnapshot__c>> returnMap = new Map<String, List<EarnedValueSnapshot__c>>();
		returnMap.put('Upsert', new List<EarnedValueSnapshot__c>());
		returnMap.put('Delete', new List<EarnedValueSnapshot__c>());
		
		Date startDateWeekStartDay = projTask.pse__Start_Date__c.toStartOfWeek();
		Date endDateWeekStartDay = projTask.pse__End_Date__c.toStartOfWeek();
		Integer daysBetween = startDateWeekStartDay.daysBetween(endDateWeekStartDay);
		Integer numOfWeeks = (daysBetween/7)+1;
		
		Decimal averageAmount = projTask.TotalApprovedCost__c / numOfWeeks;
		Decimal runningTotal = 0;
		Integer weekNum = 1;
		Date weekStartDateRunning = startDateWeekStartDay;
		
		List<EarnedValueSnapshot__c> evsToUpsert = new List<EarnedValueSnapshot__c>();
		List<EarnedValueSnapshot__c> evsToDelete = new List<EarnedValueSnapshot__c>();
		
		for (Decimal i = 0; i < numOfWeeks; i++) {
			
			system.debug('averageAmount:  '+averageAmount);
			
			Decimal taskAmount = Math.log(Math.pow((Double)averageAmount, (Double)i+1));
			
			taskAmount = taskAmount.setScale(2, System.RoundingMode.HALF_UP);
			
			system.debug('taskAmount:  '+taskAmount);
			
			runningTotal += taskAmount;
			
			EarnedValueSnapshot__c newEVSnap = new EarnedValueSnapshot__c();
			newEVSnap.ProjectTask__c = projTask.Id;
			newEVSnap.CompositeKey__c = projTask.Id+'_'+weekNum;
			newEVSnap.SnapshotKey__c = ECO_Service_Snapshots.DateToSnapshotKey(weekStartDateRunning, projTask.pse__Project__c, projTask.Id);
			newEVSnap.WeeklyRollupEntry__r = new WeeklyRollupEntry__c(CompositeKey__c = ECO_Service_Snapshots.DateToSnapshotKey(weekStartDateRunning, projTask.pse__Project__c));
			newEVSnap.WeekStartDate__c = weekStartDateRunning;
			newEVSnap.ThisWeekNumber__c = weekNum;
			newEVSnap.ThisWeekAmount__c = taskAmount;
			
			evsToUpsert.add(newEVSnap);
			
			weekNum++;
			weekStartDateRunning = weekStartDateRunning.addDays(7);
		}
		
		system.debug('projTask.TotalApprovedCost__c:  '+projTask.TotalApprovedCost__c);
		system.debug('runningTotal:  '+runningTotal);
		
		// now we have task amounts that are way too huge to be the final amount, but we have good ratios between them, step it down
		Decimal fixerRatio = projTask.TotalApprovedCost__c / runningTotal;
		
		system.debug('fixerRatio:  '+fixerRatio);
		
		// reset the running total
		runningTotal = 0;
		
		// with the ratio we can fix the amounts
		for (EarnedValueSnapshot__c evs : evsToUpsert) {
			evs.ThisWeekAmount__c = (evs.ThisWeekAmount__c * fixerRatio).setScale(2, System.RoundingMode.HALF_UP);
			
			system.debug('fixed evs.ThisWeekAmount__c:  '+evs.ThisWeekAmount__c);
			
			runningTotal += evs.ThisWeekAmount__c;
			
			evs.ThisWeekRunningTotalAmount__c = runningTotal;
			evs.ThisWeekTotalRemaining__c = projTask.TotalApprovedCost__c - runningTotal;
		}
		
		for (EarnedValueSnapshot__c ev : existingSnaps) {
			if (ev.ThisWeekNumber__c > numOfWeeks) {
				evsToDelete.add(ev);
			}
		}
		
		returnMap.get('Upsert').addAll(evsToUpsert);
		returnMap.get('Delete').addAll(evsToDelete);
		
		return returnMap;
	}
	
	public static Map<String, List<EarnedValueSnapshot__c>> calculateEvenCurveForTask (pse__Project_Task__c projTask, List<EarnedValueSnapshot__c> existingSnaps) {
		if (projTask.pse__Start_Date__c == null) {
			throw new EarnedValueException('Start Date cannot be null for task:  '+projTask.Id);
		}
		if (projTask.pse__End_Date__c == null) {
			throw new EarnedValueException('End Date cannot be null for task:  '+projTask.Id);
		}
		if (projTask.TotalApprovedCost__c == null) {
			return null;
			throw new EarnedValueException('Total Approved Cost cannot be null for task:  '+projTask.Id);
		}
		if (existingSnaps == null) {
			throw new EarnedValueException('Incoming Project Task must include Earned Value Snapshot Subquery for task:  '+projTask.Id);
		}
		
		Map<String, List<EarnedValueSnapshot__c>> returnMap = new Map<String, List<EarnedValueSnapshot__c>>();
		returnMap.put('Upsert', new List<EarnedValueSnapshot__c>());
		returnMap.put('Delete', new List<EarnedValueSnapshot__c>());
		
		Date startDateWeekStartDay = projTask.pse__Start_Date__c.toStartOfWeek();
		Date endDateWeekStartDay = projTask.pse__End_Date__c.toStartOfWeek();
		Integer daysBetween = startDateWeekStartDay.daysBetween(endDateWeekStartDay);
		Integer numOfWeeks = (daysBetween/7)+1;
		
		Decimal averageAmount = projTask.TotalApprovedCost__c / numOfWeeks;
		Decimal runningTotal = 0;
		Integer weekNum = 1;
		Date weekStartDateRunning = startDateWeekStartDay;
		
		List<EarnedValueSnapshot__c> evsToUpsert = new List<EarnedValueSnapshot__c>();
		List<EarnedValueSnapshot__c> evsToDelete = new List<EarnedValueSnapshot__c>();
		
		for (Decimal i = 0; i < numOfWeeks; i++) {
			
			Decimal taskAmount = averageAmount;
			
			taskAmount = taskAmount.setScale(2, System.RoundingMode.HALF_UP);
			
			runningTotal += taskAmount;
			
			EarnedValueSnapshot__c newEVSnap = new EarnedValueSnapshot__c();
			newEVSnap.ProjectTask__c = projTask.Id;
			newEVSnap.CompositeKey__c = projTask.Id+'_'+weekNum;
			newEVSnap.SnapshotKey__c = ECO_Service_Snapshots.DateToSnapshotKey(weekStartDateRunning, projTask.pse__Project__c, projTask.Id);
			newEVSnap.WeeklyRollupEntry__r = new WeeklyRollupEntry__c(CompositeKey__c = ECO_Service_Snapshots.DateToSnapshotKey(weekStartDateRunning, projTask.pse__Project__c));
			newEVSnap.WeekStartDate__c = weekStartDateRunning;
			newEVSnap.ThisWeekNumber__c = weekNum;
			newEVSnap.ThisWeekAmount__c = taskAmount;
			newEVSnap.ThisWeekRunningTotalAmount__c = runningTotal;
			newEVSnap.ThisWeekTotalRemaining__c = projTask.TotalApprovedCost__c - runningTotal;
			
			evsToUpsert.add(newEVSnap);
			
			weekNum++;
			weekStartDateRunning = weekStartDateRunning.addDays(7);
		}
		
		for (EarnedValueSnapshot__c ev : existingSnaps) {
			if (ev.ThisWeekNumber__c > numOfWeeks) {
				evsToDelete.add(ev);
			}
		}
		
		returnMap.get('Upsert').addAll(evsToUpsert);
		returnMap.get('Delete').addAll(evsToDelete);
		
		return returnMap;
	}

	public static Map<String, List<EarnedValueSnapshot__c>> calculateSCurveForTask (pse__Project_Task__c projTask, List<EarnedValueSnapshot__c> existingSnaps) {
		if (projTask.pse__Start_Date__c == null) {
			throw new EarnedValueException('Start Date cannot be null for task:  '+projTask.Id);
		}
		if (projTask.pse__End_Date__c == null) {
			throw new EarnedValueException('End Date cannot be null for task:  '+projTask.Id);
		}
		if (projTask.TotalApprovedCost__c == null) {
			return null;
			throw new EarnedValueException('Total Approved Cost cannot be null for task:  '+projTask.Id);
		}
		if (existingSnaps == null) {
			throw new EarnedValueException('Incoming Project Task must include Earned Value Snapshot Subquery for task:  '+projTask.Id);
		}
		
		Map<String, List<EarnedValueSnapshot__c>> returnMap = new Map<String, List<EarnedValueSnapshot__c>>();
		returnMap.put('Upsert', new List<EarnedValueSnapshot__c>());
		returnMap.put('Delete', new List<EarnedValueSnapshot__c>());
		
		Date startDateWeekStartDay = projTask.pse__Start_Date__c.toStartOfWeek();
		Date endDateWeekStartDay = projTask.pse__End_Date__c.toStartOfWeek();
		Integer daysBetween = startDateWeekStartDay.daysBetween(endDateWeekStartDay);
		Integer numOfWeeks = (daysBetween/7)+1;
		
		Decimal runningTotal = 0;
		Decimal totalAmount = projTask.TotalApprovedCost__c;
		Decimal numWeeksTotal = numOfWeeks;
		Decimal halfWeeks = numWeeksTotal/2;
		Decimal negWeekStart = halfWeeks*-1;
		
		List<EarnedValueSnapshot__c> evsToUpsert = new List<EarnedValueSnapshot__c>();
		List<EarnedValueSnapshot__c> evsToDelete = new List<EarnedValueSnapshot__c>();
		
		Date weekStartDateRunning = startDateWeekStartDay;
		
		Integer weekNum = 1;
		
		//system.debug('negWeekStart:  '+negWeekStart);
		//system.debug('halfWeeks:  '+halfWeeks);
		
		for (Decimal i = negWeekStart; i < halfWeeks; i++) {
		
			Decimal rawSigmoid = ECO_Utils_Math.sigmoid(i);
			system.debug('i number:  '+i);
			//system.debug('rawSigmoid:  '+rawSigmoid);
			Decimal taskAmount = ((rawSigmoid*totalAmount));
			
			taskAmount = taskAmount.setScale(2, System.RoundingMode.HALF_UP);
			
			runningTotal += taskAmount;
			
			system.debug('Task Amount:  '+taskAmount+', total:  '+runningTotal);
			//system.debug('Week Number:  '+weekNum);
			
			EarnedValueSnapshot__c newEVSnap = new EarnedValueSnapshot__c();
			newEVSnap.ProjectTask__c = projTask.Id;
			newEVSnap.CompositeKey__c = projTask.Id+'_'+weekNum;
			newEVSnap.SnapshotKey__c = ECO_Service_Snapshots.DateToSnapshotKey(weekStartDateRunning, projTask.pse__Project__c, projTask.Id);
			newEVSnap.WeeklyRollupEntry__r = new WeeklyRollupEntry__c(CompositeKey__c = ECO_Service_Snapshots.DateToSnapshotKey(weekStartDateRunning, projTask.pse__Project__c));
			newEVSnap.WeekStartDate__c = weekStartDateRunning;
			newEVSnap.ThisWeekNumber__c = weekNum;
			newEVSnap.ThisWeekAmount__c = taskAmount;
			
			evsToUpsert.add(newEVSnap);
			
			weekNum++;
			weekStartDateRunning = weekStartDateRunning.addDays(7);
		}
		
		// now we have task amounts that are way too huge to be the final amount, but we have good ratios between them, step it down
		Decimal fixerRatio = totalAmount / runningTotal;
		
		// reset the running total
		runningTotal = 0;
		
		// with the ratio we can fix the amounts
		for (EarnedValueSnapshot__c evs : evsToUpsert) {
			evs.ThisWeekAmount__c = (evs.ThisWeekAmount__c * fixerRatio).setScale(2, System.RoundingMode.HALF_UP);
			
			runningTotal += evs.ThisWeekAmount__c;
			
			evs.ThisWeekRunningTotalAmount__c = runningTotal;
			evs.ThisWeekTotalRemaining__c = totalAmount - runningTotal;
		}
		
		for (EarnedValueSnapshot__c ev : existingSnaps) {
			if (ev.ThisWeekNumber__c > numWeeksTotal) {
				evsToDelete.add(ev);
			}
		}
		
		system.debug('Total At End:  '+runningTotal);
		system.debug('totalAmount:  '+totalAmount);
		
		
		returnMap.get('Upsert').addAll(evsToUpsert);
		returnMap.get('Delete').addAll(evsToDelete);
		
		return returnMap;
	}
	
	public static Map<String, List<EarnedValueSnapshot__c>> calculateBellCurveForTask (pse__Project_Task__c projTask, List<EarnedValueSnapshot__c> existingSnaps) {
		if (projTask.pse__Start_Date__c == null) {
			throw new EarnedValueException('Start Date cannot be null for task:  '+projTask.Id);
		}
		if (projTask.pse__End_Date__c == null) {
			throw new EarnedValueException('End Date cannot be null for task:  '+projTask.Id);
		}
		if (projTask.TotalApprovedCost__c == null) {
			return null;
			throw new EarnedValueException('Total Approved Cost cannot be null for task:  '+projTask.Id);
		}
		if (existingSnaps == null) {
			throw new EarnedValueException('Incoming Project Task must include Earned Value Snapshot Subquery for task:  '+projTask.Id);
		}
		
		Map<String, List<EarnedValueSnapshot__c>> returnMap = new Map<String, List<EarnedValueSnapshot__c>>();
		returnMap.put('Upsert', new List<EarnedValueSnapshot__c>());
		returnMap.put('Delete', new List<EarnedValueSnapshot__c>());
		
		Date startDateWeekStartDay = projTask.pse__Start_Date__c.toStartOfWeek();
		Date endDateWeekStartDay = projTask.pse__End_Date__c.toStartOfWeek();
		Integer daysBetween = startDateWeekStartDay.daysBetween(endDateWeekStartDay);
		Integer numOfWeeks = (daysBetween/7)+1;
		
		Decimal runningTotal = 0;
		Decimal totalAmount = projTask.TotalApprovedCost__c;
		Decimal numWeeksTotal = numOfWeeks;
		Decimal meanWeeks = (numWeeksTotal+1)/2;
		
		List<EarnedValueSnapshot__c> evsToUpsert = new List<EarnedValueSnapshot__c>();
		List<EarnedValueSnapshot__c> evsToDelete = new List<EarnedValueSnapshot__c>();
		
		Date weekStartDateRunning = startDateWeekStartDay;
		
		Integer weekNum = 1;
		
		
		Decimal meanValue = totalAmount / numWeeksTotal;
		
		for (Decimal i = 0; i < numWeeksTotal; i++) {

			Decimal taskAmount = totalAmount - ((Math.abs(((i+1) - meanWeeks))) * meanValue);
			
			taskAmount = taskAmount.setScale(2, System.RoundingMode.HALF_UP);
			
			//system.debug('Calced Sigma:  '+(totalAmount - (Math.abs(((i+1) - meanWeeks))) * meanValue));
			//system.debug('Calced Sigma:  '+((Math.abs(((i+1) - meanWeeks))) * meanValue));
			
			runningTotal += taskAmount;
			
			system.debug('Task Amount:  '+taskAmount+', total:  '+runningTotal);
			//system.debug('Week Number:  '+weekNum);
			
			EarnedValueSnapshot__c newEVSnap = new EarnedValueSnapshot__c();
			newEVSnap.ProjectTask__c = projTask.Id;
			newEVSnap.CompositeKey__c = projTask.Id+'_'+weekNum;
			newEVSnap.SnapshotKey__c = ECO_Service_Snapshots.DateToSnapshotKey(weekStartDateRunning, projTask.pse__Project__c, projTask.Id);
			newEVSnap.WeeklyRollupEntry__r = new WeeklyRollupEntry__c(CompositeKey__c = ECO_Service_Snapshots.DateToSnapshotKey(weekStartDateRunning, projTask.pse__Project__c));
			newEVSnap.WeekStartDate__c = weekStartDateRunning;
			newEVSnap.ThisWeekNumber__c = weekNum;
			newEVSnap.ThisWeekAmount__c = taskAmount;
			
			evsToUpsert.add(newEVSnap);
			
			weekNum++;
			weekStartDateRunning = weekStartDateRunning.addDays(7);
		}
		
		// now we have task amounts that are way too huge to be the final amount, but we have good ratios between them, step it down
		
		Decimal fixerRatio = (runningTotal != 0) ? totalAmount / runningTotal : 0;
		
		// reset the running total
		runningTotal = 0;
		
		// with the ratio we can fix the amounts
		for (EarnedValueSnapshot__c evs : evsToUpsert) {
			evs.ThisWeekAmount__c = (evs.ThisWeekAmount__c * fixerRatio).setScale(2, System.RoundingMode.HALF_UP);
			
			system.debug('fixed evs.ThisWeekAmount__c :  '+evs.ThisWeekAmount__c );
			
			runningTotal += evs.ThisWeekAmount__c;
			
			evs.ThisWeekRunningTotalAmount__c = runningTotal;
			evs.ThisWeekTotalRemaining__c = totalAmount - runningTotal;
		}
		
		for (EarnedValueSnapshot__c ev : existingSnaps) {
			if (ev.ThisWeekNumber__c > numWeeksTotal) {
				evsToDelete.add(ev);
			}
		}
		
		system.debug('Total At End:  '+runningTotal);
		system.debug('totalAmount:  '+totalAmount);
		
		
		returnMap.get('Upsert').addAll(evsToUpsert);
		returnMap.get('Delete').addAll(evsToDelete);
		
		return returnMap;
	}

	private class EarnedValueException extends Exception {}

}