public with sharing class ShowChecksForNextHour 
{
    private Check_Settings__c checkSettings;
	DateTime nextHourStarts;
	DateTime nextHourEnds;
	public List<Wellbeing_Check__c> wellbeingChecks {get;set;}
	public String Building {get;set;}
	public List<SelectOption>wellBeingStatusValues;
	
	void getDefaultSettings ()
	{
		checkSettings = Check_Settings__c.getOrgDefaults();
		if (checkSettings.User_check_minutes_before_hour__c == null)
		{
			checkSettings = new Check_Settings__c (Item_check_minutes_before_hour__c=15, User_check_minutes_before_hour__c=15, Show_item_checks_in_future_minutes__c=60, Show_user_checks_in_future_minutes__c=60);
			try {
				insert checkSettings;
			}
			catch (Exception e){
				system.debug ('Failed to insert new setting');
			}
		}
	}

	public ShowChecksForNextHour ()
	{
		wellBeingStatusValues = null;
		Building = 'Back Lane';
	}
	
	public void loadChecks ()
	{
    	getDefaultSettings ();

		DateTime timeNow = system.now();
		system.debug ('Now its: ' + timeNow);
		if (timeNow.minute() > (60 - checkSettings.User_check_minutes_before_hour__c)) nextHourStarts = DateTime.newInstance (system.today(), Time.newInstance (timeNow.Hour()+1, 0, 0, 0));
		else nextHourStarts = DateTime.newInstance (system.today(), Time.newInstance (timeNow.Hour(), 0, 0, 0));
		nextHourEnds = DateTime.newInstance (system.today(), Time.newInstance (timeNow.Hour(), timeNow.Minute()+(Integer)checkSettings.Show_user_checks_in_future_minutes__c, 0, 0));

		wellbeingChecks = [select ID, Name, Room__c, Service_User_Name__c, Residency__r.Service_User__r.ID, Time_of_Check__c, Wellbeing_Status__c from Wellbeing_Check__c 
			where Residency__r.Building__c = :Building and Time_of_Check__c >= :nextHourStarts and Time_of_Check__c <= : nextHourEnds order by SortKey__c];
		system.debug ('Start: ' + nextHourStarts + '   End: ' + nextHourEnds);
		system.debug (wellbeingChecks);
	}

	public SelectOption[] getBuildings ()
	{
 	  	List<SelectOption> buildings= new List<SelectOption>();
        for(Schema.PicklistEntry p : Residency__c.Building__c.getDescribe().getPicklistValues())
        {
        	if(p.isActive() == true)
            {
            	buildings.add(new SelectOption(p.getValue(),p.getLabel()));
            }
        }
        return buildings;
	}
	
	public pageReference UpdateChecks ()
	{
		update wellbeingChecks;
		return null;
	}
	
	public List<SelectOption> getWellBeingStatusValues()
    {
        if(wellBeingStatusValues== null)
        {
            wellBeingStatusValues= new List<SelectOption>();
            for(Schema.PicklistEntry p : Wellbeing_Check__c.Wellbeing_Status__c.getDescribe().getPicklistValues())
            {
                if(p.isActive() == true)
                {
                    wellBeingStatusValues.add(new SelectOption(p.getValue(),p.getLabel()));
                }
            }
        }
        return wellBeingStatusValues;
    }    
        
	
}