public with sharing class CreateFutureChecks 
{
// This code will run every night at 6pm and create the checks for tomorrow
// Checks will be on the nearest hour or half hour
// for every Wellbeing Check Frequency generate a Wellbeing Check for that resident 
// for every Item Check Frequency...
// Removed the restriction to only generate checks for items with the maintenance status = OK
	public DateTime startTime, endTime;
	public String dayName;
	public Integer WellbeingNumberCreated {get;set;}
	public Integer ItemNumberCreated {get;set;}
	public Integer dayInFuture = 1; // allow for a test mode for today
	
	public CreateFutureChecks ()
	{
	}
	
	public void CreateChecks (Boolean wellbeingChecks)
	{
		dayName = readableDay(system.today()+dayInFuture);
		startTime = DateTime.newInstance(system.today()+dayInFuture, Time.newInstance(0, 0, 0, 0));
		endTime = DateTime.newInstance(system.today()+dayInFuture, Time.newInstance(23, 59, 59, 0));
		
		if (wellbeingChecks) WellbeingNumberCreated = CreateWellBeingChecks ();
		else ItemNumberCreated = CreateItemChecks ();
		for (Integer i=0; i<10; i++)
		{
			if (RemoveDuplicateChecks (wellbeingChecks) == 0) break;// may have to do a second pass if we find too many duplicates
		}
	}
	
	public void createTodaysWellbeingChecks ()
	{
		dayInFuture=0;
		CreateChecks(true);
	}
	
	public void createTodaysItemChecks ()
	{
		dayInFuture=0;
		CreateChecks(false);
	}

	public Integer CreateWellBeingChecks ()
	{
		List<Wellbeing_Check__c> checksCreated = new List<Wellbeing_Check__c>();
		List<Wellbeing_Check_Frequency__c> checks = [select ID, Residency__c, Frequency__c, Start_Time_of_Checks__c, End_Time_of_Checks__c, Wellbeing_Check_Type__c
			from Wellbeing_Check_Frequency__c where (Start_Time_of_Checks__c <= :endTime or Start_Time_of_Checks__c = null) and (End_Time_of_Checks__c >= :startTime or End_Time_of_Checks__c = null) and Residency__r.Residency_Status__c = 'Resident'];
	
		// get a list of the frequency times
		Set <ID>freqs = new Set<ID>();		
		for (Wellbeing_Check_Frequency__c oneCheck: checks)
		{
			freqs.add (oneCheck.Frequency__c);
		}
		List<Frequency_Time__c>freqTimes = [select ID, Frequency__c, Intervals_of_Checks_in_Hours__c, Time_of_Check__c from Frequency_Time__c where Frequency__c in :freqs and (Day_s_of_Week__c=:dayName or Day_s_of_Week__c='Every Day') order by Time_of_Check__c];
		
		for (Wellbeing_Check_Frequency__c oneCheck: checks)
		{
			for (Frequency_Time__c oneTime: freqTimes)
			{
				if (oneTime.Frequency__c == oneCheck.Frequency__c)
				{
					checksCreated.addAll (GenerateOneSetOfWellBeingChecks (oneCheck, oneTime));
				}
			}
		}		
		if (checksCreated.size()>0) insert checksCreated;
		return checksCreated.size();
	}

	public List<Wellbeing_Check__c> GenerateOneSetOfWellBeingChecks (Wellbeing_Check_Frequency__c checkFrequency, Frequency_Time__c fTime)
	{
		// checks should only be generated between the start and end time
		// if both the same, then only one check
		// round the check to the nearest hour or half hour
		DateTime earliestStart = DateTime.newInstance (system.today()+dayInFuture, checkFrequency.Start_Time_of_Checks__c == null?Time.newInstance(0,0,0,0):checkFrequency.Start_Time_of_Checks__c.Time());
		DateTime latestEnd = DateTime.newInstance (system.today()+dayInFuture, checkFrequency.End_Time_of_Checks__c == null?Time.newInstance(23,59,0,0):checkFrequency.End_Time_of_Checks__c.Time());
		
		DateTime checkTime;
		List<Wellbeing_Check__c>checks = new List<Wellbeing_Check__c>();
		if (fTime.Intervals_of_Checks_in_Hours__c == null || fTime.Intervals_of_Checks_in_Hours__c == 0 || earliestStart == latestEnd) // then just one check
		{
			Wellbeing_Check__c oneCheck = new Wellbeing_Check__c (Residency__c=checkFrequency.Residency__c, Time_of_Check__c=CreateDateTimeFromTime(fTime.Time_of_Check__c), Check_type__c=checkFrequency.Wellbeing_Check_Type__c);
			checks.add (oneCheck);
		}
		else // multiple checks
		{
			DateTime nextTime = CreateDateTimeFromTime(fTime.Time_of_Check__c); 
			do {
				if (nextTime >= earliestStart && nextTime <= latestEnd)
				{
					Wellbeing_Check__c oneCheck = new Wellbeing_Check__c (Residency__c=checkFrequency.Residency__c, Time_of_Check__c=nextTime, Check_type__c=checkFrequency.Wellbeing_Check_Type__c);
					checks.add (oneCheck);
				}
				nextTime = nextTime.addHours ((Integer)fTime.Intervals_of_Checks_in_Hours__c); 				
			} while (nextTime < endTime);
		}
		return checks;
	}
	
	public Integer CreateItemChecks ()
	{
		List<Item_Check__c> checksCreated = new List<Item_Check__c>();
		
		List<Item_Check_Frequency__c> checks = [select ID, Facility_Item__c, Frequency__c
			from Item_Check_Frequency__c]; //  where Facility_Item__r.Maintenance_Status__c = 'OK'];
	
		// get a list of the frequency times
		Set <ID>freqs = new Set<ID>();		
		for (Item_Check_Frequency__c oneCheck: checks)
		{
			freqs.add (oneCheck.Frequency__c);
		}
		List<Frequency_Time__c>freqTimes = [select ID, Frequency__c, Intervals_of_Checks_in_Hours__c, Time_of_Check__c from Frequency_Time__c where Frequency__c in :freqs and (Day_s_of_Week__c=:dayName or Day_s_of_Week__c='Every Day') order by Time_of_Check__c];
		for (Item_Check_Frequency__c oneCheck: checks)
		{
			for (Frequency_Time__c oneTime: freqTimes)
			{
				if (oneTime.Frequency__c == oneCheck.Frequency__c)
				{
					checksCreated.addAll (GenerateOneSetOfItemChecks (oneCheck, oneTime));
				}
			}
		}
		if (checksCreated.size()>0) insert checksCreated;
		return checksCreated.size();
	}
	
	// returns 0 if not equal
	// returns 1 if the first should be kept
	// returns 2 if the second should be kept
	public Integer wellbeingTimesEqual (Wellbeing_Check__c one, Wellbeing_Check__c two)
	{
		if (one.Residency__c == two.Residency__c && one.Time_of_Check__c == two.Time_of_Check__c)	
		{
			if (one.Check_Type__c == two.Check_Type__c) return 2; 
			else if (one.Check_Type__c == 'Special') return 1;
			else if (two.Check_Type__c == 'Special') return 2;
			else if (one.Check_Type__c == 'Carer Check') return 1;
			else if (two.Check_Type__c == 'Carer Check') return 2;
			else if (one.Check_Type__c == 'Verbal') return 1;
			else return 2;
		}
		else return 0;
	}
	
	public Integer RemoveDuplicateChecks (Boolean wellbeingChecks)
	{
		Integer checksRemoved = 0;
		Set<ID> checksToRemove = new Set<ID>();
		if (wellbeingChecks)
		{
			List<Wellbeing_Check__c> tomorrowsChecks = [select ID, Residency__c, Residency__r.Name, Time_of_Check__c, Check_type__c from Wellbeing_Check__c where Time_of_Check__c <= :endTime and Time_of_Check__c >= :startTime order by Residency__r.Name asc, Time_of_Check__c asc];
			if (tomorrowsChecks.size() > 1)
			{
				for (Integer checkNo = 0; checkNo<tomorrowsChecks.size(); checkNo++)
					system.debug ('Order ' + checkNo + ' ' + tomorrowsChecks[checkNo].Residency__r.Name + ' ' + tomorrowsChecks[checkNo].Time_of_Check__c + ' ' + tomorrowsChecks[checkNo].Check_type__c);
					
				for (Integer checkNo = 1; checkNo<tomorrowsChecks.size(); checkNo++)
				{
					// if this check is equal to the next one, them remove it and move on to the next
					Integer keepWhich = wellbeingTimesEqual (tomorrowsChecks[checkNo-1], tomorrowsChecks[checkNo]);
					if (keepWhich == 1)
					{
						checksToRemove.add (tomorrowsChecks[checkNo].ID);
						system.debug ('One ' + checkNo + ' removing ' + tomorrowsChecks[checkNo].Time_of_Check__c + ' ' + tomorrowsChecks[checkNo].Check_type__c);
					}
					else if (keepWhich == 2)
					{
						checksToRemove.add (tomorrowsChecks [checkNo-1].ID);
						system.debug ('Two ' + checkNo + ' removing ' + tomorrowsChecks[checkNo-1].Time_of_Check__c + ' ' + tomorrowsChecks[checkNo-1].Check_type__c);
					}
				}
				if (checksToRemove.size() > 0) 
				{
					checksRemoved = checksToRemove.size();
					delete [select ID from Wellbeing_Check__c where ID in :checksToRemove];
				}			
			}
		} 
		else
		{
			List<Item_Check__c> tomorrowItemChecks = [select ID, Area__c, Area_Item__c, Area_Item__r.Name, Time_of_Check__c from Item_Check__c where Time_of_Check__c <= :endTime and Time_of_Check__c >= :startTime order by Area__c, Area_Item__r.Name asc, Time_of_Check__c asc];
			if (tomorrowItemChecks.size() > 1)
			{
				for (Integer checkNo = 0; checkNo<tomorrowItemChecks.size(); checkNo++)
					system.debug ('Order ' + checkNo + ' ' + tomorrowItemChecks[checkNo].Area_Item__r.Name + ' ' + tomorrowItemChecks[checkNo].Time_of_Check__c);
					
				for (Integer checkNo = 1; checkNo<tomorrowItemChecks.size(); checkNo++)
				{
					// if this check is equal to the next one, them remove it and move on to the next
					if (tomorrowItemChecks[checkNo-1].Time_of_Check__c == tomorrowItemChecks[checkNo].Time_of_Check__c && tomorrowItemChecks[checkNo-1].Area__c == tomorrowItemChecks[checkNo].Area__c && tomorrowItemChecks[checkNo-1].Area_Item__r.Name == tomorrowItemChecks[checkNo].Area_Item__r.Name)
					{
						checksToRemove.add (tomorrowItemChecks[checkNo].ID);
						system.debug (checkNo + ' removing ' + tomorrowItemChecks[checkNo].Time_of_Check__c);
					}
				}
				if (checksToRemove.size() > 0) 
				{
					checksRemoved += checksToRemove.size();
					delete [select ID from Item_Check__c where ID in :checksToRemove];
				}			
			}
		} 
		return checksRemoved;
	}
	
	public List<Item_Check__c> GenerateOneSetOfItemChecks (Item_Check_Frequency__c checkFrequency, Frequency_Time__c fTime)
	{
		// checks should only be generated between the start and end time
		// if both the same, then only one check
		// round the check to the nearest hour or half hour
		DateTime earliestStart = DateTime.newInstance (system.today()+dayInFuture, Time.newInstance(0,0,0,0));
		DateTime latestEnd = DateTime.newInstance (system.today()+dayInFuture, Time.newInstance(23,59,0,0));
		
		DateTime checkTime;
		List<Item_Check__c>checks = new List<Item_Check__c>();
		if (fTime.Intervals_of_Checks_in_Hours__c == null || fTime.Intervals_of_Checks_in_Hours__c == 0 || earliestStart == latestEnd) // then just one check
		{
			Item_Check__c oneCheck = new Item_Check__c (Area_Item__c=checkFrequency.Facility_Item__c, Time_of_Check__c=CreateDateTimeFromTime(fTime.Time_of_Check__c));
			checks.add (oneCheck);
		}
		else // multiple checks
		{
			DateTime nextTime = CreateDateTimeFromTime(fTime.Time_of_Check__c); 
			do {
				if (nextTime >= earliestStart && nextTime <= latestEnd)
				{
					Item_Check__c oneCheck = new Item_Check__c (Area_Item__c=checkFrequency.Facility_Item__c, Time_of_Check__c=nextTime);
					checks.add (oneCheck);
				}
				nextTime = nextTime.addHours ((Integer)fTime.Intervals_of_Checks_in_Hours__c); 				
			} while (nextTime < endTime);
		}
		return checks;
	}
	
	public String readableDay(Date d) {
		Datetime dt = DateTime.newInstance(d.year(), d.month(), d.day());
		return dt.format('EEEE'); //returns Sunday or Monday or ..
	} 
	
	DateTime CreateDateTimeFromTime (String dayTime)
	{
		try
		{
			List<String>times = dayTime.splitByCharacterType (); 
			return DateTime.newInstance (system.today()+dayInFuture, Time.newInstance(Integer.ValueOf(times[0]), Integer.ValueOf(times[2]), 0, 0));
		}
		catch (Exception e)
		{
			return DateTime.newInstance (system.today()+dayInFuture, Time.newInstance(0, 0, 0, 0));
		}
	}
}