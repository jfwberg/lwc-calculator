/**
 *	@author			:	Justus van den Berg (jfwberg@gmail.com)
 *	@date			:	2020-12-21 22:00
 *	@description	:	Example basic implementation of a test factory
 *
 *	Copyright (c) 2021 Justus van den Berg, info@aloha-workbench.com
 *
 *	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
@IsTest
public with sharing class lwc_TestFactory {

	/**
	 *	Method for creating the running user record
	 *	Its best practice to run tests in a proper user context
	 */
	public static User getRunningUser(String runningUserProfileName, String[] runningUserPermissionSetNames){
		
		// Get profile and permission set information
		Profile profile 				= [SELECT Id FROM Profile 		WHERE Name =  :runningUserProfileName		 LIMIT   1];
		PermissionSet[] permissionSets	= [SELECT Id FROM PermissionSet WHERE Name IN :runningUserPermissionSetNames LIMIT 100];

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

		// List for holding the different PMAs
		PermissionSetAssignment[] permissionSetAssignments = new PermissionSetAssignment[]{};
		
		// Assign the permission set to the running user
		for(PermissionSet permissionSet : permissionSets){
			permissionSetAssignments.add(
				new PermissionSetAssignment(
					AssigneeId		= runningUser.Id,
					PermissionSetId = permissionSet.Id
				)
			);
		}
		
		// Insert all the new permission set assignments
		insert permissionSetAssignments;
		
		// Return the running user object
		return runningUser;
	}

}
