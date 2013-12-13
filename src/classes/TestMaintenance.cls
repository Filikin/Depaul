@isTest
private class TestMaintenance 
{
// TEST update Building Item status to OK when Maintenance status is "completed"
// EK 25 November 2013
	static public List<Area_Item__c> CreateAreaItems (Integer itemCount)
	{
		List<Area_Item__c>items = new List<Area_Item__c>();
		for (Integer i=1; i<=itemCount; i++)
		{
			items.add (new Area_Item__c (Name='Main door'+i, Building__c='Back Lane', Area__c='Old Side – 2nd Floor Corridor', Check_Frequency__c='Sundial Day Frequency', Maintenance_Status__c='Isse', H_S_Check_Type__c='Hazard', Status_when_OK__c='Working'));
		}
		insert items;
		return items;
	}
	
	static public List<Maintenance__c> CreateMaintenanceRecords (List<Area_Item__c> buildingItems)
	{
		List<Maintenance__c> maintRecords = new List<Maintenance__c>();
		for (Area_Item__c oneItem: buildingItems)
		{
			Maintenance__c oneMaint = new Maintenance__c (Facility_Item__c = oneItem.id, Name='Maintenance ' + oneItem.Name, Repair_Status__c='In Progress');
			maintRecords.add (oneMaint);
		}
		insert maintRecords;
		return maintRecords;
	}
	
    static testMethod void maintenanceCompleteUpdatesBuildingItem() 
    {
    	Integer creationCount = 10;
    	List<Area_Item__c> areaItems = CreateAreaItems (creationCount);
        List<Maintenance__c> maintRecords = CreateMaintenanceRecords (areaItems);
        for (Maintenance__c oneM: maintRecords)
        {
        	oneM.Repair_Status__c = 'Completed';
        }
        update maintRecords;
        
        areaItems = [select ID from Area_Item__c where Maintenance_Status__c = 'OK'];
        system.assertEquals (creationCount, areaItems.size());
        
    }
}