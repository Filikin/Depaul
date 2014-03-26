/*
Author: Eamon Kelly, Enclude
Purpose: 1.Change Support Plan Status of cloned record to: Cloned
		2.Change Support Plan Status of new record: Active
		3.Remove data from fields:
			1.Progress on Goals since last review
			2.Service User Comments
			3.Staff Comments
			4.Review Date
		4.Copy related "Goals and Outcomes"  records into new record

 
Called from: CloneSupportPlanPage - button on a support plan
Tested in: TestCloneSupportPlan
*/
public with sharing class CloneSupportPlan 
{
	private ecass01__Care_Plan_Objective__c originalPlan, clonedPlan;
	
	public CloneSupportPlan(ApexPages.StandardController controller)
    {
        originalPlan = (ecass01__Care_Plan_Objective__c)controller.getRecord();
    }
	
    public PageReference clonePlan ()
    {
        CreateClonePlan ();
	    String clonedTripURL = '/' + clonedPlan.ID + '/e?retURL=%2F' + clonedPlan.ID;
        PageReference clonedPlanPage = new PageReference(clonedTripURL);
        return clonedPlanPage;
    }

    public void CreateClonePlan ()
    {
    	clonedPlan = originalPlan.clone(false, true);
    	clonedPlan.Support_Plan_Status__c = 'Active';
    	insert clonedPlan;
    	
    	ResetOldPlan ();
    	
    	MoveSupportGoals ();
    }
    
    public void ResetOldPlan ()
    {
    	originalPlan.Support_Plan_Status__c = 'Cloned';
    	update originalPlan;
    }
	
	public void MoveSupportGoals ()
	{
		list <Short_Term_Goal_Support_Plan__c> goals = [select Id, Care_Plan_Objective__c from Short_Term_Goal_Support_Plan__c where Care_Plan_Objective__c = :originalPlan.id and Short_Term_Goal_Completed_Date__c = null];
		for (Short_Term_Goal_Support_Plan__c oneGoal : goals)
		{
			oneGoal.Care_Plan_Objective__c = clonedPlan.id;
		}
		if (goals.size() > 0) update goals;
	}
}