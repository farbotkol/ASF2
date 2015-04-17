public with sharing class ECO_Temp_PortalController {
	public User theHeaderUser { get; set; }
	
	public ECO_Temp_PortalController () {
		theHeaderUser = ECO_Service_Users.getUserInfoById(UserInfo.getUserId());
	} 
}