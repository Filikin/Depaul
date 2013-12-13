public with sharing class ShowItemChecksForNextHour 
{
    private Check_Settings__c checkSettings;
	DateTime nextHourStarts;
	DateTime nextHourEnds;
	public List<Item_Check__c> itemChecks {get;set;}
	public String Building {get;set;}
	public List<SelectOption>itemStatusValues;
	
	void getDefaultSettings ()
	{
		checkSettings = Check_Settings__c.getOrgDefaults();
		if (checkSettings.Item_check_minutes_before_hour__c == null)
		{
			checkSettings = new Check_Settings__c (Item_check_minutes_before_hour__c=15, User_check_minutes_before_hour__c=15, Show_item_checks_in_future_minutes__c=60, Show_user_checks_in_future_minutes__c=60);
			insert checkSettings;
		}
	}

	public ShowItemChecksForNextHour ()
	{
		itemStatusValues = null;
		Building = 'Back Lane';
	}
	
	public void loadChecks ()
	{
    	getDefaultSettings ();
		system.debug ('In LoadChecks');

		DateTime timeNow = system.now();
		system.debug ('Now its: ' + timeNow);
		if (timeNow.minute() > (60 - checkSettings.Item_check_minutes_before_hour__c)) nextHourStarts = DateTime.newInstance (system.today(), Time.newInstance (timeNow.Hour()+1, 0, 0, 0));
		else nextHourStarts = DateTime.newInstance (system.today(), Time.newInstance (timeNow.Hour(), 0, 0, 0));
		nextHourEnds = DateTime.newInstance (system.today(), Time.newInstance (timeNow.Hour(), timeNow.Minute()+(Integer)checkSettings.Show_item_checks_in_future_minutes__c, 0, 0));

		itemChecks = [select ID, Name, Area__c, Area_Item__c, Area_Item__r.Name, Time_of_Check__c, Result__c, Current_Status_of_Item__c, Item_Check_Comment__c, Type_of_Hazard__c from Item_Check__c 
			where Area_Item__r.Building__c = :Building and Time_of_Check__c >= :nextHourStarts and Time_of_Check__c <= : nextHourEnds order by SortKey__c];
		system.debug ('Start: ' + nextHourStarts + '   End: ' + nextHourEnds);
		system.debug (itemChecks);
	}

	public SelectOption[] getBuildings ()
	{
 	  	List<SelectOption> buildings= new List<SelectOption>();
        for(Schema.PicklistEntry p : Area_Item__c.Building__c.getDescribe().getPicklistValues())
        {
        	if(p.isActive() == true)
            {
            	buildings.add(new SelectOption(p.getValue(),p.getLabel()));
            }
        }
        return buildings;
	}
	
	public String[] getQuickchecks ()
	{
 	  	List<String> hints = new List<String>();
        for(Schema.PicklistEntry p : Item_Check__c.Quick_checks__c.getDescribe().getPicklistValues())
        {
        	if(p.isActive() == true)
            {
            	hints.add(p.getLabel());
            }
        }
        return hints;
	}
	
	public pageReference UpdateChecks ()
	{
		update itemChecks;
		return null;
	}
	
	public List<SelectOption> getItemStatusValues()
    {
        if(itemStatusValues== null)
        {
            itemStatusValues= new List<SelectOption>();
            for(Schema.PicklistEntry p : Item_Check__c.Result__c.getDescribe().getPicklistValues())
            {
                if(p.isActive() == true)
                {
                    itemStatusValues.add(new SelectOption(p.getValue(),p.getLabel()));
                }
            }
        }
        return itemStatusValues;
    }    
	
}