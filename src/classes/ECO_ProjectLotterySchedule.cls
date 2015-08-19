global class ECO_ProjectLotterySchedule implements Schedulable {
	global void execute(SchedulableContext sc) {
		ECO_ProjectLotteryPickBatch b = new ECO_ProjectLotteryPickBatch();
		database.executeBatch(b);
	}
}