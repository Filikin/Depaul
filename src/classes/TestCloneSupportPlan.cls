@isTest
private class TestCloneSupportPlan 
{
    public static testMethod void testCreateClonePlan()
    {
     	Contact client = new Contact (FirstName='Test', LastName='Client');
    	insert client;
    	
    	Needs_Assessment__c needsAss = new Needs_Assessment__c (Name='xx', Service_User_Name__c=client.id);
    	insert needsAss;
    	
        ecass01__Care_Plan_Objective__c plan = new ecass01__Care_Plan_Objective__c (Name='x', ecass01__Client__c=client.id, Needs_Assessment__c=needsAss.id);
        plan.Staff_Comments__c = 'Some comment';
        plan.ecass01__Work_to_be_done_to_achieve_objective__c = 'Some work';
        plan.Support_Plan_Status__c = 'Active';
        insert plan;

		Short_Term_Goal_Support_Plan__c doneGoal = new Short_Term_Goal_Support_Plan__c (Name='Done goal', Care_Plan_Objective__c=plan.id, Short_Term_Goal_Completed_Date__c=system.today());
		insert doneGoal;
		
		Short_Term_Goal_Support_Plan__c notdoneGoal = new Short_Term_Goal_Support_Plan__c (Name='Not Done goal', Care_Plan_Objective__c=plan.id);
		insert notdoneGoal;
		
    	Test.setCurrentPage(Page.CloneSupportPlanPage);
    	        
        ApexPages.StandardController planController = new ApexPages.StandardController(plan);
        CloneSupportPlan cloned = new CloneSupportPlan (planController);
        cloned.clonePlan();
        
        ecass01__Care_Plan_Objective__c originalPlan = [select ID, Staff_Comments__c, Support_Plan_Status__c from ecass01__Care_Plan_Objective__c where id=:plan.id];
        system.assertEquals ('Cloned', originalPlan.Support_Plan_Status__c);

        ecass01__Care_Plan_Objective__c clonedPlan = [select ID, Staff_Comments__c, Support_Plan_Status__c from ecass01__Care_Plan_Objective__c where Needs_Assessment__c=:plan.Needs_Assessment__c and Support_Plan_Status__c='Active'];
        system.assertNotEquals (null, clonedPlan.id);
        
        list <Short_Term_Goal_Support_Plan__c> originalGoals = [select Id, Name from Short_Term_Goal_Support_Plan__c where Care_Plan_Objective__c = :originalPlan.id];
        system.assertEquals(1, originalGoals.size());
        system.assertEquals ('Done goal', originalGoals[0].Name);
        
        list <Short_Term_Goal_Support_Plan__c> newGoals = [select Id, Name from Short_Term_Goal_Support_Plan__c where Care_Plan_Objective__c = :clonedPlan.id];
        system.assertEquals(1, newGoals.size());
        system.assertEquals ('Not Done goal', newGoals[0].Name);
    }
}