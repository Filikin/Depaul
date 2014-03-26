@isTest
private class testMatchingEventsandInterventions {

    static testMethod void myUnitTest() {
		
		List <RecordType> conRTs = [select Id from RecordType where Name = 'Client' and SobjectType = 'Contact'];
		Id conRT = conRTs[0].Id;
		Contact John = new Contact(LastName = 'John', RecordTypeId = conRT);
       	insert John;
       	Intervention__c inter1 = new Intervention__c(Client__c = John.Id,
       	Date_of_Intervention__c = system.today(),
       	Start_Time__c = '11am',
       	Start_Time_Minutes__c = '00',
       	End_Time_Hour__c = '12noon',
       	End_Time_Minutes__c = '00',
       	Activity_Type__c = 'Group Work',
       	Depaul_Intervention_Type__c = 'Offending');
       	insert inter1;
       	
       	inter1.Activity_Type__c = 'Life Skills';
       	inter1.Life_Skills__c = 'Shower';
       	inter1.Name = 'John';
       	//inter1.Meal_Provision__c = 'Dinner';
       	//inter1.Personal_Care__c = 'Shower';
       	//inter1.Volunteer_Activity__c = 'Dinner';
       	inter1.Start_Time__c = '9am';
       	inter1.End_Time_Hour__c = '10am';
       	inter1.Start_Time_Minutes__c = '30';
       	inter1.End_Time_Minutes__c = '30';
       	inter1.Depaul_Intervention_Type__c = 'Drug Misuse';
       	
       	update inter1;
       	
       	Event event1 = new Event(
       	StartDateTime = datetime.newInstance(2012, 10, 5, 00, 00, 0),
        EndDateTime = datetime.newInstance(2012, 10, 5, 01, 00, 0),
        Subject = 'Test',
        WhoId = John.Id,
        Activity_Type__c = 'Life Skills',
        Depaul_Activity_Type__c = 'Offending');
        insert event1;
        
        event1.Activity_Type__c = 'Life Skills';
        event1.Life_Skills__c = 'Grooming';
        event1.StartDateTime = datetime.newInstance(2012, 10, 5, 02, 00, 0);
        event1.EndDateTime = datetime.newInstance(2012, 10, 5, 03, 00, 0);
        event1.Depaul_Activity_Type__c = 'Drug Misuse';
       	update event1;
       	
       /*	event1.Activity_Type__c = 'Meal Provision';
       	event1.Meal_Provision__c = 'Dinner';
       	event1.Subject = 'Blah';
        event1.StartDateTime = datetime.newInstance(2012, 10, 5, 04, 00, 0);
        event1.EndDateTime = datetime.newInstance(2012, 10, 5, 05, 00, 0);
        event1.Personal_Care__c = 'Drug Misuse';
        event1.Volunteer_Activtity__c = 'Shower';
       	update event1;*/
       	
       
    }
}