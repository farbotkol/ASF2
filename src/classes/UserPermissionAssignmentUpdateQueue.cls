public class UserPermissionAssignmentUpdateQueue implements Queueable {

	private List<PermissionSetAssignment> permissionSetAssignmentToRemove;
	private List<PermissionSetAssignment> permissionSetAssignmentToUpdate;

	public UserPermissionAssignmentUpdateQueue(List<PermissionSetAssignment> toRemove, List<PermissionSetAssignment> toUpdate){

		permissionSetAssignmentToRemove = toRemove;
		permissionSetAssignmentToUpdate = toUpdate;
	}

    public void execute(QueueableContext context) {
    	system.debug(permissionSetAssignmentToUpdate);
        database.delete (permissionSetAssignmentToRemove, false);
		database.insert (permissionSetAssignmentToUpdate, false);
    }
}