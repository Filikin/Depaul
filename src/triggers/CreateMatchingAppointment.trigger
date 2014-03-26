trigger CreateMatchingAppointment on Intervention__c (after insert) {
	
	if(trigger.new.size() < 2){
		
		for(Intervention__c note : trigger.new ){
			List <RecordType> interRTs = [select Id from RecordType where Name = 'Staff Intervention' and SobjectType = 'Intervention__c'];
			Id interRT = interRTs[0].Id;
			if(note.RecordTypeId == interRT && note.Created_by_Trigger__c == false){
				List <Event> matches = [select Id from Event 
				where Matching_Intervention__c = :note.Id];
				if(matches.size() == 0){
					
					
					//Integer Duration = 
					
					Event copy = new Event(Activity_Type__c = note.Activity_Type__c, 
					Depaul_Activity_Type__c = note.Depaul_Intervention_Type__c,
					//Subject = note.Depaul_Intervention_Type__c + ' Intervention with ',
					Life_Skills__c = note.Life_Skills__c,
					StartDateTime = note.Start_DateTime__c,
					EndDateTime = note.End_DateTime__c,
					Subject = note.Name,
					//Date = note.Date__c,
					//DurationInMinutes = 8000,
					Meal_Provision__c = note.Meal_Provision__c,
					Personal_Care__c = note.Personal_Care__c,
					Volunteer_Activtity__c = note.Volunteer_Activity__c,
					Matching_Intervention__c = note.Id,
					WhoId = note.Client__c,
					Created_by_Trigger__c = true);
				
					insert copy;
				
				//	copy.Matching_Intervention__c = note.Id;
					//update copy;
					//note.Matching_Event__c = copy.Id;
					//update note;
					Intervention__c note2 = [select Id, Matching_Event__c
					from Intervention__c where Id = :note.Id limit 1];
					
					note2.Matching_Event__c = copy.Id; 
					
					
					
					
					String yellow = 'yellow';
					
					
					update note2;
				}
			
			}
		
		}
	}

}