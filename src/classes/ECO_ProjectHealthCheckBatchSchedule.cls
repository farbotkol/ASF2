global class ECO_ProjectHealthCheckBatchSchedule implements Schedulable {
	global void execute(SchedulableContext sc) {
		ECO_ProjectHealthCheckBatch b = new ECO_ProjectHealthCheckBatch();
		database.executeBatch(b);
	}
}