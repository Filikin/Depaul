/*
Author: Eamon Kelly, Enclude
Purpose: Testing Residency and Item checks	
*/
@isTest
private class TestCheckForDuplicateClients {

    static testMethod void TryAndAddSecondContactSamePPSTest() 
    {
		Id clientRecordTypeID = [select ID from RecordType where sObjectType='Contact' and DeveloperName='Client'].id;
		Contact client1 = new Contact (LastName='Test1', RecordTypeID=clientRecordTypeID, PPS_Number__c='12345');
		insert client1;
		
		Contact client2 = new Contact (LastName='Test2', RecordTypeID=clientRecordTypeID, PPS_Number__c='12345');
		try
		{
			insert client2;
		}
		catch (Exception e)
		{
			return; // should get an exception because it is a duplicate
		}
		system.assert(false); // should not get here

    }
}