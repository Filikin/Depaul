trigger UpdateMatchingIntervention on Event (after update) {
	
	if(trigger.new.size() < 2){
		List <RecordType> conRTs = [select Id from RecordType where Name = 'Client' and SobjectType = 'Contact'];
		Id conRT = conRTs[0].Id;
			if(trigger.new[0].WhoId != null){
				List <Contact> clients = [select Id,RecordTypeId,Name from Contact where Id = :trigger.new[0].WhoId];
				Contact client = clients[0];
				//Contact client = trigger.new[0].WhoId;
			if(client.RecordTypeId == conRT && trigger.new[0].Depaul_Activity_Type__c != null){
			//for(Event appoint : trigger.new){
			Map<Id, Event> newAppointMap = Trigger.newMap;
			Map<Id, Event> oldAppointMap = Trigger.oldMap;

			//Loop through the map
			for(Id appointmentId:newAppointMap.keySet()){
 				Event myNewAppoint = newAppointMap.get(appointmentId);
 				Event myOldAppoint = oldAppointMap.get(appointmentId);
				
				
				
					
				Intervention__c matchinter = [select Id, Matching_Event__c from Intervention__c where
				Id = :myNewAppoint.Matching_Intervention__c];
				if(matchinter.Matching_Event__c == null){
					matchinter.Matching_Event__c = myNewAppoint.Id;
					update matchinter;
				}
				if (myNewAppoint.Matching_Intervention__c == null){
					myNewAppoint.Matching_Intervention__c = matchinter.Id;
					update myNewAppoint;
				}
					
					
				List <Intervention__c> matches = [select Depaul_Intervention_Type__c, Activity_Type__c,Start_DateTime__c, Life_Skills__c,Name,
				Meal_Provision__c, Personal_Care__c,End_DateTime__c,  Volunteer_Activity__c, Client__c from Intervention__c where
				Id = :trigger.new[0].Matching_Intervention__c limit 1];
				
				Intervention__c match = matches[0];
				//Event appoint = trigger.new[0];
				
				if (myNewAppoint.Depaul_Activity_Type__c <> myOldAppoint.Depaul_Activity_Type__c
				|| myNewAppoint.Activity_Type__c <> myOldAppoint.Activity_Type__c
				|| myNewAppoint.Life_Skills__c <> myOldAppoint.Life_Skills__c
				|| myNewAppoint.Subject <> myOldAppoint.Subject
				|| myNewAppoint.Meal_Provision__c <> myOldAppoint.Meal_Provision__c
				|| myNewAppoint.Personal_Care__c <> myOldAppoint.Personal_Care__c
				|| myNewAppoint.Volunteer_Activtity__c <> myOldAppoint.Volunteer_Activtity__c
				|| myNewAppoint.WhoId <> myOldAppoint.WhoId){
					if(myNewAppoint.Depaul_Activity_Type__c != match.Depaul_Intervention_Type__c
					|| myNewAppoint.Activity_Type__c != match.Activity_Type__c
					|| myNewAppoint.Life_Skills__c != match.Life_Skills__c
					|| myNewAppoint.Subject != match.Name
					|| myNewAppoint.Meal_Provision__c != match.Meal_Provision__c
					|| myNewAppoint.Personal_Care__c != match.Personal_Care__c
					|| myNewAppoint.Volunteer_Activtity__c != match.Volunteer_Activity__c
					|| myNewAppoint.WhoId != match.Volunteer_Activity__c
					){
						match.Depaul_Intervention_Type__c = myNewAppoint.Depaul_Activity_Type__c;
						match.Life_Skills__c = myNewAppoint.Life_Skills__c;
						match.Name = myNewAppoint.Subject;
						match.Meal_Provision__c = myNewAppoint.Meal_Provision__c;
						match.Personal_Care__c = myNewAppoint.Personal_Care__c;
						
						match.Volunteer_Activity__c = myNewAppoint.Volunteer_Activtity__c;
						match.Volunteer_Activity__c = myNewAppoint.WhoId;
						
						update match;
					}
				}
				
				if (myNewAppoint.EndDateTime <> myOldAppoint.EndDateTime || 
				myNewAppoint.StartDateTime <> myOldAppoint.StartDateTime){
					if(myNewAppoint.EndDateTime != match.End_DateTime__c || 
					myNewAppoint.StartDateTime != match.Start_DateTime__c){
						String endtimeField = myNewAppoint.EndDateTime.format('hh:mm');
						String starttimeField = myNewAppoint.StartDateTime.format('hh:mm');
						match.End_Time_Minutes__c = endtimeField.right(2);
						match.Start_Time_MInutes__c = starttimeField.right(2);
						match.End_Time_Hour__c = formathoursTime(endtimeField);
						match.Start_Time__c = formathoursTime(starttimeField);
						match.Date_of_Intervention__c = myNewAppoint.StartDateTime.date();
						update match;
					}
				
				}
								
				
				
			}
		}
	}
}
	
public String formatHoursTime(String timeOf)
    {
	String hours = timeOf.left(2);
	//String mins = time.right(2);
	
	if (hours == '01'){
		hours = '1am';
		return hours;
	}
	else if (hours == '02'){
		hours = '2am';
		return hours;
	}
	else if (hours == '03'){
		hours = '3am';
		return hours;
	}
	else if (hours == '04'){
		hours = '4am';
		return hours;
	}
	else if (hours == '05'){
		hours = '5am';
		return hours;
	}
	else if (hours == '06'){
		hours = '6am';
		return hours;
	}
	else if (hours == '07'){
		hours = '7am';
		return hours;
	}
	else if (hours == '08'){
		hours = '8am';
		return hours;
	}
	else if (hours == '09'){
		hours = '9am';
		return hours;
	}
	else if (hours == '10'){
		hours = '10am';
		return hours;
	}
	else if (hours == '11'){
		hours = '11am';
		return hours;
	}
	else if (hours == '12'){
		hours = '12noon';
		return hours;
	}
	else if (hours == '13'){
		hours = '1pm';
		return hours;
	}
	else if (hours == '14'){
		hours = '2pm';
		return hours;
	}
	else if (hours == '15'){
		hours = '3pm';
		return hours;
	}
	else if (hours == '16'){
		hours = '4pm';
		return hours;
	}
	else if (hours == '17'){
		hours = '5pm';
		return hours;
	}
	else if (hours == '18'){
		hours = '6pm';
		return hours;
	}
	else if (hours == '19'){
		hours = '7pm';
		return hours;
	}
	else if (hours == '20'){
		hours = '8pm';
		return hours;
	}
	else if (hours == '21'){
		hours = '9pm';
		return hours;
	}
	else if (hours == '22'){
		hours = '10pm';
		return hours;
	}
	else if (hours == '23'){
		hours = '11pm';
		return hours;
	}
	else if (hours == '00'){
		hours = '12midnight';
		return hours;
	}
	else{
		return null;
	}
	
    }
}