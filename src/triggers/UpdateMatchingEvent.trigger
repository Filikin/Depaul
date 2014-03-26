trigger UpdateMatchingEvent on Intervention__c (after update) {
//*******************************************
	
//Change all the individual 'if field changed' statements one big one!!!!

//***************************************
	if(trigger.new.size() < 2){
		List <RecordType> interRTs = [select Id from RecordType where Name = 'Staff Intervention' and SobjectType = 'Intervention__c'];
		Id interRT = interRTs[0].Id;
		if(trigger.new[0].RecordTypeId == interRT){
			//for(Event appoint : trigger.new){
			Map<Id, Intervention__c> newInterMap = Trigger.newMap;
			Map<Id, Intervention__c> oldInterMap = Trigger.oldMap;

			//Loop through the map
			for(Id interId:newInterMap.keySet()){
 				Intervention__c myNewInter = newInterMap.get(interId);
 				Intervention__c myOldInter = oldInterMap.get(interId);
				
				
				
				//List <Event> matchevents = [select Id, Matching_Case__c from Event where
				//Id = :myNewNote.Matching_Event__c];
				Event matchevent = [select Id, Matching_Intervention__c from Event where
				Id = :myNewInter.Matching_Event__c];
				if(matchevent.Matching_Intervention__c == null){
					matchevent.Matching_Intervention__c = myNewInter.Id;
					update matchevent;
				}
				if (myNewInter.Matching_Event__c == null){
					myNewInter.Matching_Event__c = matchevent.Id;
					update myNewInter;
				}
				
				List <Event> matches = [select Depaul_Activity_Type__c, Subject, Activity_Type__c, 
				Life_Skills__c, StartDateTime, EndDateTime, Meal_Provision__c, Personal_Care__c,
				Volunteer_Activtity__c, WhoID, Created_by_Trigger__c, Matching_Intervention__c  from Event where
				Id = :myNewInter.Matching_Event__c limit 1];
				
				Event match = matches[0];
				//Event appoint = trigger.new[0];
				if(trigger.isDelete == true){	
					delete match;
				}
				else{
				if (myNewInter.Depaul_Intervention_Type__c <> myOldInter.Depaul_Intervention_Type__c
				|| myNewInter.Activity_Type__c <> myOldInter.Activity_Type__c
				|| myNewInter.Life_Skills__c <> myOldInter.Life_Skills__c
				|| myNewInter.Name <> myOldInter.Name
				|| myNewInter.Meal_Provision__c <> myOldInter.Meal_Provision__c
				|| myNewInter.Personal_Care__c <> myOldInter.Personal_Care__c
				|| myNewInter.Volunteer_Activity__c <> myOldInter.Volunteer_Activity__c
				|| myNewInter.Client__c <> myOldInter.Client__c){
					if(myNewInter.Depaul_Intervention_Type__c != match.Depaul_Activity_Type__c
					|| myNewInter.Activity_Type__c != match.Activity_Type__c
					|| myNewInter.Life_Skills__c != match.Life_Skills__c
					|| myNewInter.Name != match.Subject
					|| myNewInter.Meal_Provision__c != match.Meal_Provision__c
					|| myNewInter.Personal_Care__c != match.Personal_Care__c
					|| myNewInter.Personal_Care__c != match.Personal_Care__c
					|| myNewInter.Volunteer_Activity__c != match.Volunteer_Activtity__c
					|| myNewInter.Client__c != match.WhoId){
						match.Depaul_Activity_Type__c = myNewInter.Depaul_Intervention_Type__c;
						match.Activity_Type__c = myNewInter.Activity_Type__c;
						match.Life_Skills__c = myNewInter.Life_Skills__c;
						match.Subject = myNewInter.Name;
						match.Meal_Provision__c = myNewInter.Meal_Provision__c;
						match.Personal_Care__c = myNewInter.Personal_Care__c;
						match.Volunteer_Activtity__c = myNewInter.Volunteer_Activity__c;
						match.WhoId = myNewInter.Client__c;
						update match;
					}
					
				}
				
						
			
				
				if (myNewInter.Start_DateTime__c <> myOldInter.Start_DateTime__c ||
				myNewInter.End_DateTime__c <> myOldInter.End_DateTime__c){
					if(myNewInter.Start_DateTime__c != match.StartDateTime ||
					myNewInter.End_DateTime__c != match.EndDateTime){
						match.EndDateTime = myNewInter.End_DateTime__c;
						match.StartDateTime = myNewInter.Start_DateTime__c;
						//match.Date__c = match.Start_Time__c.date();
						update match;
						//match.Date__c = match.Start_Time__c.date();
					}
				}
				
				} 
				
			}
		}
	}

}