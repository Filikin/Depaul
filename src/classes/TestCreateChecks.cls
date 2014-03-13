/*
Author: Eamon Kelly, Enclude
Purpose: Testing Residency and Item checks	
*/
@isTest
private class TestCreateChecks 
{
	static public List<Contact> CreateServiceUsers (Integer userCount)
	{
		List<Contact>serviceUsers = new List<Contact>();
		for (Integer i=1; i<=userCount; i++)
		{
			serviceUsers.add (new Contact (lastName='ServiceUser'+i));
			
		}
		insert serviceUsers;
		return serviceUsers;
	}
	
	static public List<Frequency_Time__c> CreateFrequencyTimes (Frequency__c freq, Integer freqCount, String weekDay, String checkTime)
	{
		List<Frequency_Time__c>times = new List<Frequency_Time__c>();
		for (Integer i=1; i<=freqCount; i++)
		{
			times.add (new Frequency_Time__c (Frequency__c=freq.id, Day_s_of_Week__c=weekDay, Time_of_Check__c=checkTime, Intervals_of_Checks_in_Hours__c=i));
		}	
		insert times;
		return times;
	}
	
	static public List<Frequency__c> CreateFrequencies (Integer freqCount)
	{
		List<Frequency__c>fqs = new List<Frequency__c>();
		for (Integer i=1; i<=freqCount; i++)
		{
			fqs.add (new Frequency__c (Name='Frequency'+i, Default_for__c='Back Lane'));
		}
		insert fqs;
		for (Integer i=0; i<freqCount; i++)
		{
			CreateFrequencyTimes (fqs[i], 3, 'Every Day', '08:00');
			CreateFrequencyTimes (fqs[i], 4, 'Monday', '09:10');
			CreateFrequencyTimes (fqs[i], 3, 'Wednesday', '08:00');
			CreateFrequencyTimes (fqs[i], 3, 'Sunday', '02:01');
		}
		return fqs;
	}
	
	static public List<Residency__c> CreateResidencies (Integer resCount, List <Contact>users)
	{
		List<Residency__c>res = new List<Residency__c>();
		for (Integer i=1; i<=resCount; i++)
		{
			res.add (new Residency__c (Name='Residency'+i, Service_User__c=users[i-1].id, Residency_Status__c='Resident', Date_of_Referral__c=system.today()-i, Departure_Date__c=system.today()+i, Building__c='Back Lane'));
		}
		insert res;
		return res;
	}
	
	static public List<Wellbeing_Check_Frequency__c> CreateWellbeingCheckFrequencies (Integer wcfCount, List<Residency__c>res, List<Frequency__c> freqs)
	{
		List<Wellbeing_Check_Frequency__c>wcfs = new List<Wellbeing_Check_Frequency__c>();
		for (Integer i=0; i<wcfCount; i++)
		{
			wcfs.add (new Wellbeing_Check_Frequency__c (Frequency__c=freqs[i].id, Residency__c=res[i].id, Wellbeing_Check_Type__c='Visual', Start_Time_of_Checks__c=system.now()-i, End_Time_of_Checks__c=system.now()+i));
		}
		insert wcfs;
		return wcfs;
	}
	
	static public List<Area_Item__c> CreateAreaItems (Integer itemCount)
	{
		List<Area_Item__c>items = new List<Area_Item__c>();
		for (Integer i=1; i<=itemCount; i++)
		{
			items.add (new Area_Item__c (Name='Main door'+i, Building__c='Back Lane', Area__c='Old Side – 2nd Floor Corridor', Check_Frequency__c='Sundial Day Frequency', Maintenance_Status__c='OK', H_S_Check_Type__c='Hazard', Status_when_OK__c='Working'));
		}
		insert items;
		return items;
	}
	
	static public List<Item_Check_Frequency__c> CreateItemCheckFrequencies(Integer itemCount, List<Area_Item__c>facItems, List<Frequency__c> freqs)
	{
		List<Item_Check_Frequency__c>cfs = new List<Item_Check_Frequency__c>();
		for (Integer i=0; i<itemCount; i++)
		{
			cfs.add (new Item_Check_Frequency__c (Frequency__c=freqs[i].id, Facility_Item__c=facItems[i].id));
		}
		insert cfs;
		return cfs;
	}
	
    static testMethod void testCheckCreation() 
    {
    	Integer creationCount = 2;
    	List<Frequency__c> freqs = CreateFrequencies (creationCount);
    	List<Contact> serviceUsers = CreateServiceUsers (creationCount);
    	List<Residency__c> res = CreateResidencies (creationCount, serviceUsers);
    	CreateWellbeingCheckFrequencies (creationCount, res, freqs);
    	List<Area_Item__c> areaItems = CreateAreaItems (creationCount);
    	system.debug ('Area items created: ' + areaItems.size());
    	List<Item_Check_Frequency__c> itemcheckfreqs = CreateItemCheckFrequencies (creationCount, areaItems, freqs);
    	system.debug ('Item check frequencies created: ' + itemcheckfreqs.size());
    	
    	Test.startTest();
    	ScheduleFutureChecks sch = new ScheduleFutureChecks();
    	system.schedule('Test create checks', '0 0 18 * * ?', sch);
    	Test.stopTest();

    	List<Wellbeing_Check__c> wellBeingChecks = [select ID from Wellbeing_Check__c];
    	system.assert (wellBeingChecks.size() > 0);
    	
    	List<Item_Check__c> itemChecks = [select ID, Result__c, Area_Item__c from Item_Check__c];
    	system.assert (itemChecks.size() > 0);
    	itemChecks[0].Result__c = 'Issue';
    	update itemChecks[0];
    	
    	Area_Item__c area = [select ID, Maintenance_Status__c from Area_Item__c where ID = :itemChecks[0].Area_Item__c];
    	system.assertEquals (itemChecks[0].Result__c, area.Maintenance_Status__c);
   }
}