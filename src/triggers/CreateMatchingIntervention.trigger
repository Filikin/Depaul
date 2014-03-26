trigger CreateMatchingIntervention on Event (after insert) {
	
	List<String> My_TriggerIds = new List<String>();
	
	if(trigger.new.size() < 18) {//works for 17
		List <RecordType> conRTs = [select Id from RecordType where Name = 'Client' and SobjectType = 'Contact'];
		Id conRT = conRTs[0].Id;
			if(trigger.new[0].WhoId != null){
				List <Contact> clients = [select Id,RecordTypeId,Name from Contact where Id = :trigger.new[0].WhoId];
				Contact client = clients[0];
				//Contact client = trigger.new[0].WhoId;
				if(client.RecordTypeId == conRT && trigger.new[0].Depaul_Activity_Type__c != null && trigger.new[0].Created_by_Trigger__c == false){
		
					for(Event appoint : trigger.new ){
						if(appoint.IsRecurrence == false){
					
							//My_TriggerIds.add(appoint.Id);
							//COmmented out code was an attempt to use @future call to raise trigger size
							//limit to 24
							//system.assert(My_TriggerIds[0]!=null);
							
							Integer stHour = appoint.StartDateTime.hour();
							String startHour = string.valueof(stHour);
							String timestartHour = formatHoursTime(startHour);
							Integer stMins = appoint.StartDateTime.minute();
							String startMins = string.valueof(stMins);
				
							Integer enHour = appoint.EndDateTime.hour();
							String endHour = string.valueof(enHour);
							String timeendHour = formatHoursTime(endHour);
							Integer enMins = appoint.EndDateTime.minute();
							String endMins = string.valueof(enMins);
				
							Intervention__c copy = new Intervention__c(Activity_Type__c = appoint.Activity_Type__c, 
							Depaul_Intervention_Type__c = appoint.Depaul_Activity_Type__c,
							Life_Skills__c = appoint.Life_Skills__c,
							Meal_Provision__c = appoint.Meal_Provision__c,
							Name = appoint.Subject,
							End_Time_Hour__c = timeendHour,
							End_Time_Minutes__c = endMins,
							Start_Time__c = timestartHour,
							Start_Time_Minutes__c = startMins,
							Personal_Care__c = appoint.Personal_Care__c,
							Date_of_Intervention__c = appoint.StartDateTime.date(),
							Matching_Event__c = appoint.Id,
							Created_by_Trigger__c = true,
							Volunteer_Activity__c = appoint.Volunteer_Activtity__c,
							Client__c = appoint.WhoId);
							insert copy; 
		
					
							Event note2 = [select Id, Matching_Intervention__c
							from Event where Id = :appoint.Id limit 1];
					
							note2.Matching_Intervention__c = copy.Id; 
							update note2;
						}  
					}
					//system.assert(My_TriggerIds[0]!=null);
					//inserts(My_TriggerIds);	
				}
		}
	}
	/*public static void inserts(LIST<String> My_Ids){
		
		futureDoInserts.doInserts(My_Ids);
		
	}*/
	
	public static String formatHoursTime(String timeOf){
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