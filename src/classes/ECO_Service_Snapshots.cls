public with sharing class ECO_Service_Snapshots {
	private static Date epoch;

	static {
		epoch = Date.newInstance(1900, 1, 7);  // a known Sunday, definitely in the past
	}

	public static Integer getDayOfWeek(Date dDate) {
		return Math.mod(epoch.daysBetween(dDate), 7);
	}

	public static String getWeekNumber(Date dDate) {
		Date firstDay = Date.newInstance(dDate.year(), 1, 1);  // January 1st of current year

		Integer offset = getDayOfWeek(firstDay);

		return String.valueOf((firstDay.daysBetween(dDate) + offset) / 7 + 1);
	}

	public static Date getFirstDateOfWeek(Date dDate) {
		Integer offset = getDayOfWeek(dDate);

		return dDate.addDays(-offset);
	}

	public static string DateToSnapshotKey(Date dDate, Id sProjectId, Id sTaskId){
		string sSnapshotKey = '';

//		string sWeekNumber = DateTime.newInstanceGmt(Date.newInstance(dDate.year(), dDate.month(), dDate.day()).toStartOfWeek()
//												   , Time.NewInstance(12,0,0,0)).format('w');

//		Date dFirstDate = getFirstDateOfWeek(dDate);

		// TODO - not convinced that this snapshot key rolls from one year to the next properly, also see below for similar code

//		sSnapshotKey = sProjectId + '_' + sTaskId + '_' + dFirstDate.year() + '-WK' + getWeekNumber(dDate);
		sSnapshotKey = sProjectId + '_' + sTaskId + '_' + dDate.year() + '-WK' + getWeekNumber(dDate);

		return sSnapshotKey;
	}

	public static string DateToSnapshotKey(Date dDate, Id sProjectId){
		string sSnapshotKey = '';

//		string sWeekNumber = DateTime.newInstanceGmt(Date.newInstance(dDate.year(), dDate.month(), dDate.day()).toStartOfWeek()
//												   , Time.NewInstance(12,0,0,0)).format('w');

//		Date dFirstDate = getFirstDateOfWeek(dDate);

//		sSnapshotKey = sProjectId + '_' + '_' + dFirstDate.year() + '-WK' + getWeekNumber(dDate);
		sSnapshotKey = sProjectId + '_' + '_' + dDate.year() + '-WK' + getWeekNumber(dDate);

		return sSnapshotKey;
	}
}