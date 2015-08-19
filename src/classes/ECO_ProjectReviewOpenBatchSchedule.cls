global class ECO_ProjectReviewOpenBatchSchedule implements Schedulable {
	global void execute(SchedulableContext sc) {
		ECO_ProjectReviewOpenStatusBatch b = new ECO_ProjectReviewOpenStatusBatch();
		database.executeBatch(b);
	}
}