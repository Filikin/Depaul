trigger ItemChecks on Item_Check__c (after update) 
{
	// update the area item to reflect this change
	// for each item
	// if the result has changed and the then copy the result into the area item
	// also need to create a maintenance record if the status has changed to an issue
	// don't do this for hazards
	Set<ID>areaIDs = new Set <ID>();
	List<Maintenance__c>maintanceIssuesToCreate = new List<Maintenance__c>();
	String createMaintanceSetting = Check_Settings__c.getOrgDefaults().Create_maintenance_if_one_of__c;
	if (createMaintanceSetting == null) createMaintanceSetting = 'Issue';
	
	for (Item_Check__c oneItem: trigger.new)
	{
		if (oneItem.Result__c != null && oneItem.Result__c != 'Hazard') areaIDs.add(oneItem.Area_Item__c);
	}
	Map<ID,Area_Item__c>areasMap = new Map<ID,Area_Item__c>([select ID, Name, Maintenance_Status__c from Area_Item__c where ID in :areaIDs]);
	for (Item_Check__c oneItem: trigger.new)
	{
		Item_Check__c oldItem = trigger.oldMap.get (oneItem.id);
		if (oneItem.Result__c != null && oneItem.Result__c != 'Hazard' && oldItem != null && oldItem.Result__c != oneItem.Result__c)
		{
			Area_Item__c area = areasMap.get(oneItem.Area_Item__c);
			if (area != null)
			{
				area.Maintenance_Status__c = oneItem.Result__c;
			}
			
			if (createMaintanceSetting.contains (oneItem.Result__c))
			{
				String maintName = area.Name + '-' + system.today().format() + '-' + oneItem.Result__c; 
				maintanceIssuesToCreate.add (new Maintenance__c (Name=maintName, Facility_Item__c=area.id, Item_Check__c=oneItem.id));
			}
		}
	}
	if (maintanceIssuesToCreate.size() > 0) insert maintanceIssuesToCreate;
	update areasMap.Values();
}