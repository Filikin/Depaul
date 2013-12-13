/*
	This class will be launched from a button on a needs assessment page
	A needs assessement is made up of a number of assessments, each with a checkbox indicating if a support plan is needed.
	this checkbox is listed in a field set Create_support_plan followed by a text fields, the label on the checkbox (without 'Support Plan Needed') 
	will be used as the support	plan name, the second as the Action to be taken
	
	Only create support plans where one does not already exists, 
*/
public with sharing class CreateSupportPlans 
{
    private Needs_Assessment__c needsAssessment;
    private List<String> planAreaList;
    private List <ecass01__Care_Plan_Objective__c> plansToCreate;
    
 	public static List<Needs_Assessment__c> createNeedsQuery (List<Schema.FieldSetMember> needsFields, ID assessmentID)
	{
		String soql = getSelectStatement (needsFields, 'FROM Needs_Assessment__c');
		soql += ' where ID  = :assessmentID';
		
		System.debug(soql);
	    return database.query(soql);
	}
 
    public static String getSelectStatement (List<Schema.FieldSetMember> fieldList, String extraBit)
 	{
 		String query = 'SELECT Service_User_Name__c, ';
        for(Schema.FieldSetMember f : fieldList) {
            query += f.getFieldPath() + ', ';
        }
        // if name is not already there, include it
        if (!query.contains(' Name,')) query += 'Name, ';
        query += 'Id ' + extraBit;	
        return query;
 	}

	public Map<String, ID> getCurrentSupportPlans (ID needsAssessment)
	{
		List <ecass01__Care_Plan_Objective__c> currentPlans = [select ID, Name from ecass01__Care_Plan_Objective__c where Needs_Assessment__c = :needsAssessment];
		Map<String, ID> currentPlansMap = new Map<String, ID> ();
		for (ecass01__Care_Plan_Objective__c onePlan: currentPlans)	
		{
			currentPlansMap.put (onePlan.Name, onePlan.ID);
		}
		return currentPlansMap;
	}
	
	public Boolean createSupportPlans() 
    {
    	String fieldSetName = 'Create_support_plan';
    	Schema.FieldSet fs1 = Schema.SObjectType.Needs_Assessment__c.fieldSets.getMap().get(fieldSetName);
    	if (fs1 == null) 
		{
			ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Field set Create support plan not found, please contact ENCLUDE');
			ApexPages.addMessage(msg);
			return false;
		}
		else
		{
	    	List<Schema.FieldSetMember> allFields = fs1.getFields();
	    	
	    	List<Needs_Assessment__c> needsAssessments = createNeedsQuery (allFields, needsAssessment.id);
	    	if (needsAssessments.size() > 0)
	    	{
	    		needsAssessment = needsAssessments[0];
	    	}
	    	else
	    	{
				ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Needs Assessment record not found, please contact ENCLUDE');
				ApexPages.addMessage(msg);
				return false;
			}
	    	
	    	Map<String, ID> currentPlansMap = getCurrentSupportPlans (needsAssessment.id);
			String base = ' Support Plan Needed';
	    	for (Integer i=0; i<allFields.size(); i+=2)
	    	{
	    		String fieldName = allFields[i].getFieldPath();
	    		String fieldLabel = allFields[i].getLabel().left(allFields[i].getLabel().length()-base.length());
	    		if ((Boolean)(needsAssessment.get(fieldName)) && currentPlansMap.get(fieldLabel) == null) // checkbox is set, so create a care plan if not already there
	    		{
	    			ecass01__Care_Plan_Objective__c supportPlan = new ecass01__Care_Plan_Objective__c (Name=fieldLabel);
	    			supportPlan.ecass01__Work_to_be_done_to_achieve_objective__c = (String)needsAssessment.get(allFields[i+1].getFieldPath());
	    			supportPlan.ecass01__Client__c = needsAssessment.Service_User_Name__c;
	    			supportPlan.Needs_Assessment__c = needsAssessment.ID;
	    			supportPlan.ecass01__Date_objective_set__c = system.today();
	    			plansToCreate.add(supportPlan);
	    		}
	    	}
	    	return true;
		}
    }

    public CreateSupportPlans(ApexPages.StandardController controller)
    {
        needsAssessment = (Needs_Assessment__c)controller.getRecord();
     }

	public pageReference createPlans ()
	{
		plansToCreate = new List <ecass01__Care_Plan_Objective__c>();
		if (createSupportPlans())
		{
			if (plansToCreate.size() > 0) insert plansToCreate;
		
			 String returnURL = '/' + needsAssessment.ID; 
	         PageReference needsAssessmentPage = new PageReference(returnURL);
	         return needsAssessmentPage;
		}
		else return null;
	}

	public static testMethod CreateSupportPlans testCreateObjects()
    {
        Needs_Assessment__c needsAss;
    	for (Integer i=1; i<=5; i++)
    	{
	    	Contact client = new Contact (FirstName='Test', LastName='Client' + i);
	    	insert client;
	    	
	        needsAss = new Needs_Assessment__c (Service_User_Name__c=client.id);
	        needsAss.Accommodation_Needs_Support_Plan_Needed__c = true;
	        needsAss.Accommodation_Needs_Assessment__c = 'Find housing';
	        needsAss.Alcohol_Use_Support_Plan_Needed__c = true;
	        needsAss.Alcohol_Use_Needs_Assessment__c = 'Stay out of pubs';
	        insert needsAss;
    	}
    	
        ApexPages.StandardController needsController = new ApexPages.StandardController(needsAss);
        return new CreateSupportPlans (needsController);
    }

	public static testMethod void testPlanCreation ()
	{
		CreateSupportPlans rp = testCreateObjects();
		rp.createPlans ();
		
		List <ecass01__Care_Plan_Objective__c> plans = [select ID, Name from ecass01__Care_Plan_Objective__c where Needs_Assessment__c = :rp.needsAssessment.id];
		system.assertEquals (2, plans.size());
		
		rp = testCreateObjects();
		rp.createPlans (); // this should have no further effect
		plans = [select ID, Name from ecass01__Care_Plan_Objective__c where Needs_Assessment__c = :rp.needsAssessment.id];
		system.assertEquals (2, plans.size());
	}

}