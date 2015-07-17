public class UserPermissionAssignmentUpdateQueue implements Queueable {

	private List<PermissionSetAssignment> permissionSetAssignmentToRemove;
	private List<PermissionSetAssignment> permissionSetAssignmentToUpdate;
	private List<Id> userIdsToUpdate;
	private UserRole userRole;

	public UserPermissionAssignmentUpdateQueue(List<PermissionSetAssignment> toRemove, List<PermissionSetAssignment> toUpdate, List<Id> usersToUpdate, UserRole role ){

		permissionSetAssignmentToRemove = toRemove;
		permissionSetAssignmentToUpdate = toUpdate;
		userIdsToUpdate = usersToUpdate;
		userRole = role;

	}

    public void execute(QueueableContext context) {
        delete permissionSetAssignmentToRemove;
		insert permissionSetAssignmentToUpdate;

	    List<User> usersToUpdate  =	[SELECT id, UserRoleId
			     										 FROM User
			     										 WHERE id IN :userIdsToUpdate];

		for(User user : usersToUpdate)
		{		     		
			user.UserRoleId = userRole.Id;
		}								 

		update usersToUpdate;
    }
}