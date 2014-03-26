@isTest
private class TestCloneRiskManagementPlan 
{
    public static testMethod void testCreateCloneTrip()
    {
     	Contact client = new Contact (FirstName='Test', LastName='Client');
    	insert client;
    	
        Risk_Assessment__c riskAss = new Risk_Assessment__c (Name='x', Service_User_Name__c=client.id);
        riskAss.Risk_1_Details__c = 'Details of risk 1';
        riskAss.Risk_1_Likelihood__c = 9;
        riskAss.Risk_1_Severity__c = 6;
        riskAss.Risk_2_Details__c = 'Details of risk 2';
        riskAss.Risk_2_Likelihood__c = 8;
        riskAss.Risk_2_Severity__c = 9;
        riskAss.Risk_16_Details__c = 'Details of risk 16';
        riskAss.Risk_16_Likelihood__c = 3;
        riskAss.Risk_16_Severity__c = 9;
        insert riskAss;
        Risk_Management_Plan__c rmp = new  Risk_Management_Plan__c (Risk_Assessment__c = riskAss.id);
        insert rmp;
        
        ApexPages.StandardController rmpController = new ApexPages.StandardController(rmp);
        CloneRiskManagementPlan plan = new CloneRiskManagementPlan (rmpController);
        plan.clonePlan();
    }
}