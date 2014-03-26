/*
Author: Eamon Kelly, Enclude
Purpose: a) remove the data from the fields:
				Service User Comment and Commitment
				Staff Support
				Date Completed
				RMP Review Data
		b) Set "RMP Status" of cloned record to : Inactive
		c) Set "RMP Status" of new record to: Active
 
Called from: CloneRiskManagementPlanPage - button on a risk management plan
Tested in: TestCloneRiskManagementPlan
*/
public with sharing class CloneRiskManagementPlan 
{
	private Risk_Management_Plan__c originalPlan, clonedPlan;
	
	public CloneRiskManagementPlan(ApexPages.StandardController controller)
    {
        originalPlan = (Risk_Management_Plan__c)controller.getRecord();
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
    	clonedPlan.RMP_Status__c = 'Active';
    	insert clonedPlan;
    	
    	ResetOldPlan ();
    }
    
    public void ResetOldPlan ()
    {
    	originalPlan.RMP_Status__c = 'Inactive';
    	update originalPlan;
    }
}