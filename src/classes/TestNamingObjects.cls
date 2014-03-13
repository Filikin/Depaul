/*
	Author: Eamon Kelly, Enclude
	Purpose: Inserted objects and change they are named
*/

@isTest
private class TestNamingObjects {

    static testMethod void TestRiskAssessments() 
    {
    	Contact client = new Contact (FirstName='Test', LastName='Client');
    	insert client;
    	
        Risk_Assessment__c riskAss = new Risk_Assessment__c (Name='x', Service_User_Name__c=client.id);
        insert riskAss;
        riskAss = [select Name from Risk_Assessment__c where id=:riskAss.id];
        system.assertNotEquals('x', riskAss.Name);
    }

    static testMethod void TestNeedsAssessments() 
    {
    	Contact client = new Contact (FirstName='Test', LastName='Client');
    	insert client;
    	
        Needs_Assessment__c needsAss = new Needs_Assessment__c (Name='x', Service_User_Name__c=client.id);
        insert needsAss;
        needsAss = [select Name from Needs_Assessment__c where id=:needsAss.id];
        system.assertNotEquals('x', needsAss.Name);
    }
}