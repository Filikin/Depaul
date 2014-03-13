/*
Author: Eamon Kelly, Enclude
Purpose: Testing Residency and Item checks	
*/
@isTest
private class TestCheckForDuplicateClients 
{
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

    static testMethod void TryAndAddSecondContactSamePassTest() 
    {
		Id clientRecordTypeID = [select ID from RecordType where sObjectType='Contact' and DeveloperName='Client'].id;
		Contact client1 = new Contact (LastName='Test1', RecordTypeID=clientRecordTypeID, PPS_Number__c='12345', PASS_Number__c='12345');
		insert client1;
		
		Contact client2 = new Contact (LastName='Test2', RecordTypeID=clientRecordTypeID, PPS_Number__c='1234', PASS_Number__c='12345');
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
    
    static testMethod void TryAndAddSecondContactSameNationalInsuranceTest() 
    {
		Id clientRecordTypeID = [select ID from RecordType where sObjectType='Contact' and DeveloperName='Client'].id;
		Contact client1 = new Contact (LastName='Test1', RecordTypeID=clientRecordTypeID, PPS_Number__c='12345', PASS_Number__c='12345', National_Insurance_Number__c='12345');
		insert client1;
		
		Contact client2 = new Contact (LastName='Test2', RecordTypeID=clientRecordTypeID, PPS_Number__c='1234', PASS_Number__c='123456', National_Insurance_Number__c='12345');
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

    static testMethod void TryAndAddSecondContactSameNameAndDOBTest() 
    {
		Id clientRecordTypeID = [select ID from RecordType where sObjectType='Contact' and DeveloperName='Client'].id;
		Contact client1 = new Contact (FirstName='Fred', LastName='Test', RecordTypeID=clientRecordTypeID, BirthDate=Date.newInstance (1990, 2, 3), PPS_Number__c='12345', PASS_Number__c='12345', National_Insurance_Number__c='12345');
		insert client1;
		
		Contact client2 = new Contact (FirstName='Bill', LastName='Test', RecordTypeID=clientRecordTypeID, BirthDate=Date.newInstance (1990, 2, 3), PPS_Number__c='1234', PASS_Number__c='123456', National_Insurance_Number__c='123456');
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
    
    static testMethod void TryAndAddSecondContactDifferentNameAndSameDOBTest() 
    {
		Id clientRecordTypeID = [select ID from RecordType where sObjectType='Contact' and DeveloperName='Client'].id;
		Contact client1 = new Contact (FirstName='Fred', LastName='Test', RecordTypeID=clientRecordTypeID, BirthDate=Date.newInstance (1990, 2, 3), PPS_Number__c='12345', PASS_Number__c='12345', National_Insurance_Number__c='12345');
		insert client1;
		
		Contact client2 = new Contact (FirstName='Bill', LastName='Test1', RecordTypeID=clientRecordTypeID, BirthDate=Date.newInstance (1990, 2, 3), PPS_Number__c='1234', PASS_Number__c='123456', National_Insurance_Number__c='123456');
		insert client2;

		Integer clientCount = [select count() from Contact];
		system.assertEquals (2, clientCount);
    }
    
    static testMethod void OverrideDuplicateCheckTest() 
    {
		Id clientRecordTypeID = [select ID from RecordType where sObjectType='Contact' and DeveloperName='Client'].id;
		Contact client1 = new Contact (FirstName='Fred', LastName='Test', RecordTypeID=clientRecordTypeID, BirthDate=Date.newInstance (1990, 2, 3), PPS_Number__c='12345', PASS_Number__c='12345', National_Insurance_Number__c='12345');
		insert client1;
		
		Contact client2 = new Contact (FirstName='Bill', LastName='Test', RecordTypeID=clientRecordTypeID, BirthDate=Date.newInstance (1990, 2, 3), PPS_Number__c='12345', PASS_Number__c='12345', National_Insurance_Number__c='12345');
		client2.Ignore_Duplicate_Check__c = true;
		insert client2;
		
		Integer clientCount = [select count() from Contact];
		system.assertEquals (2, clientCount);
    }
    
}