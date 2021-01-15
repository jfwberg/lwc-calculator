@IsTest
public with sharing class lwc_TestFactory {

	/**
	 *	Method for creating the running user record
	 *	Its best practice to run tests in a proper user context
	 */
	public static User getRunningUser(String runningUserProfileName, String[] runningUserPermissionSetNames){
		
		// Get profile and permission set information
		Profile profile 			= [SELECT Id FROM Profile 		WHERE Name =  :runningUserProfileName		 LIMIT 1];
		PermissionSet permissionSet = [SELECT Id FROM PermissionSet WHERE Name IN :runningUserPermissionSetNames LIMIT 100];

		// Setup a user, so you can run the test code for a specific profile / permission set
		// In out best practice we use permission sets, so it's best to test these permission sets accordingly with the proper user Profile
		User runningUser = new User();
		runningUser.Alias 			 =	'testuser';
		runningUser.Email			 =	'testuser@aloha-workbench.com';
		runningUser.EmailEncodingKey =	'UTF-8';
		runningUser.LastName		 =	'testuser';
		runningUser.LanguageLocaleKey=	'en_US';
		runningUser.LocaleSidKey	 =	'en_US';
		runningUser.ProfileId 		 =	 profile.Id;
		runningUser.TimeZoneSidKey	 =	'Europe/London';
		runningUser.UserName 		 =	'test_user_' + DateTime.now().getTime() + '@aloha-workbench.com';
		insert runningUser;

		// Assign the permission set to the running user
		PermissionSetAssignment psa = new PermissionSetAssignment(
			AssigneeId		= runningUser.Id,
			PermissionSetId = permissionSet.Id
		);
		insert psa;
		
		return runningUser;
	}

}
