trigger LatestOutcomeWheels on Outcome_Wheel__c (before insert) {
	//for (SMS__c obj: trigger.new){
		
	Outcome_Wheel__c LastOW = trigger.new[0];
	Integer marker = 0;
	
	List <Outcome_Wheel__c> oldLastOW = [Select Date_of_completion__c, Client__c, Is_latest_completed__c, Is_second_latest_completed__c 
	From Outcome_Wheel__c
	Where Is_latest_completed__c = true OR Is_second_latest_completed__c = true];
	
	for (Outcome_Wheel__c a: oldLastOW)
	{
		if (a != null)
		{
			
			if (a.Client__c == LastOW.Client__c)
			{	
				marker = 1;
				if (LastOW.Date_of_completion__c >= a.Date_of_completion__c)
				{
					if (a.Is_latest_completed__c == true)
					{
						a.Is_latest_completed__c = false;
						a.Is_second_latest_completed__c = true;
						update a;
					}
					else if (a.Is_second_latest_completed__c == true)
					{
						a.Is_latest_completed__c = false;
						a.Is_second_latest_completed__c = false;
						update a;
					}
				}
			}
		}
	}
	
}