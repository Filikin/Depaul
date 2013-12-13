public with sharing class OutcomeWheelChartController 
{
    Contact client=null;
    List<WheelPointData> data = new List<WheelPointData>();
    
    public List<WheelPointData> getWheelData() 
    {
        return data;
    }

    // Wrapper class
    public class WheelPointData 
    {
        public String name { get; set; }
        public Integer data1 { get; set; }
        public Integer data2 { get; set; }
        public Integer data3 { get; set; }
        public Integer data4 { get; set; }

        public WheelPointData(List<Outcome_Wheel__c> outcomeWheels, String fieldlabel, String fieldname)
        {
            try
            {
                this.name = fieldlabel;
                this.data1 = (Integer)(Decimal)(outcomeWheels[0].get(fieldname)!=null?outcomeWheels[0].get(fieldname):0);
                this.data2 = (Integer)(Decimal)(outcomeWheels.size()>1 && outcomeWheels[1].get(fieldname)!=null ? outcomeWheels[1].get(fieldname):0);
                this.data3 = (Integer)(Decimal)(outcomeWheels.size()>2 && outcomeWheels[2].get(fieldname)!=null ? outcomeWheels[2].get(fieldname):0);
                this.data4 = (Integer)(Decimal)(outcomeWheels.size()>3 && outcomeWheels[3].get(fieldname)!=null ? outcomeWheels[3].get(fieldname):0);
            }
            catch (Exception e)
            {
                system.debug (e);
                this.name = '';
                this.data1 = 0;
                this.data2 = 0;
                this.data3 = 0;
                this.data4 = 0;
            }
        }
    }
    
    public OutcomeWheelChartController(ApexPages.StandardController controller)
    {
        client = (Contact)controller.getRecord();
    }
    
    public Boolean getAnyData ()
    {
        return data.size() > 0;
    }
    
    public void extractData ()
    {
       List<Outcome_Wheel__c> outcomeWheels = [select Stage__c, X1__c, X2__c, X3__c, X4__c, X5__c,
                X6__c, X7__c, X8__c, X9__c, X10__c
                from Outcome_Wheel__c where Client__c = :client.id order by Date_of_completion__c asc];
        if (outcomeWheels.size() > 0)
        {
            data.add (new WheelPointData (outcomeWheels, Outcome_Wheel__c.X1__c.getDescribe().getLabel(), 'X1__c'));
            data.add (new WheelPointData (outcomeWheels, Outcome_Wheel__c.X2__c.getDescribe().getLabel(), 'X2__c'));
            data.add (new WheelPointData (outcomeWheels, Outcome_Wheel__c.X3__c.getDescribe().getlabel(), 'X3__c'));         
            data.add (new WheelPointData (outcomeWheels, Outcome_Wheel__c.X4__c.getDescribe().getlabel(), 'X4__c'));           
            data.add (new WheelPointData (outcomeWheels, Outcome_Wheel__c.X5__c.getDescribe().getlabel(), 'X5__c'));           
            data.add (new WheelPointData (outcomeWheels, Outcome_Wheel__c.X6__c.getDescribe().getlabel(), 'X6__c'));           
            data.add (new WheelPointData (outcomeWheels, Outcome_Wheel__c.X7__c.getDescribe().getlabel(), 'X7__c'));         
            data.add (new WheelPointData (outcomeWheels, Outcome_Wheel__c.X8__c.getDescribe().getlabel(), 'X8__c'));         
            data.add (new WheelPointData (outcomeWheels, Outcome_Wheel__c.X9__c.getDescribe().getlabel(), 'X9__c'));         
            data.add (new WheelPointData (outcomeWheels, Outcome_Wheel__c.X10__c.getDescribe().getlabel(), 'X10__c'));
                   
                     
        }
    }
    
    public static testMethod void testSampleData ()
    {
    	Contact client = new Contact (Lastname='Bloggs');
    	insert client;
    	      
    	Master_OW_Report__c master = new Master_OW_Report__c(Name = 'MASTEROW001',
    	Avr_First_1__c = 4,
		Avr_First_10__c = 4,
		Avr_First_2__c = 4,
		Avr_First_3__c = 4,
		Avr_First_4__c = 4,
		Avr_First_5__c = 4,
		Avr_First_6__c = 4,
		Avr_First_7__c = 4,
		Avr_First_8__c = 4,
		Avr_First_9__c = 4,
		Avr_Last_10__c = 4,
		Avr_Last_1__c = 4,
		Avr_Last_2__c = 4,
		Avr_Last_3__c = 4,
		Avr_Last_4__c = 4,
		Avr_Last_5__c = 4,
		Avr_Last_6__c= 4,
		Avr_Last_7__c = 4,
		Avr_Last_8__c = 4,
		Avr_Last_9__c = 4,
		Ovr_Average_1__c= 4,
		Ovr_Average_10__c = 4,
		Ovr_Average_2__c = 4,
		Ovr_Average_3__c = 4,
		Ovr_Average_4__c  =4,
		Ovr_Average_5__c = 4,
		Ovr_Average_6__c = 4,
		Ovr_Average_7__c = 4,
		Ovr_Average_8__c = 4,
		Ovr_Average_9__c = 4,
		Increase_1__c = 4,
		Increase_2__c = 4,
		Increase_3__c = 4,
		Increase_4__c = 4,
		Increase_5__c = 4,
		Increase_6__c = 4,
		Increase_7__c = 4,
		Increase_8__c = 4,
		Increase_9__c = 4,
		Increase_10__c = 4,
		Decrease_1__c = 4,
		Decrease_2__c = 4,
		Decrease_3__c = 4,
		Decrease_4__c = 4,
		Decrease_5__c = 4,
		Decrease_6__c = 4,
		Decrease_7__c = 4,
		Decrease_8__c = 4,
		Decrease_9__c = 4,
		Decrease_10__c = 4,
		NoChange_1__c = 4,
		NoChange_2__c = 4,
		NoChange_3__c = 4,
		NoChange_4__c = 4,
		NoChange_5__c = 4,
		NoChange_6__c = 4,
		NoChange_7__c = 4,
		NoChange_8__c = 4,
		NoChange_9__c = 4,
		NoChange_10__c = 4,
		Total_clients_with_2ow__c = 4,
		Total_count__c = 4,
		Total_first__c = 4,
		Total_last__c = 5);
    	insert master;
    	      
    	Outcome_Wheel__c outcomeWheel = new Outcome_Wheel__c (Stage__c='Admission', X1__c=2, X2__c=2, X3__c=2, X4__c=2, X5__c=2,
                X6__c=2, X7__c=2, X8__c=2, X9__c=2, X10__c=2, Client__c = client.id, Date_of_completion__c=system.today());
        insert outcomeWheel;
    	
    	ApexPages.StandardController wheelControllerPage = new ApexPages.StandardController(client);
    	OutcomeWheelChartController wheel = new OutcomeWheelChartController (wheelControllerPage);
    	wheel.extractData();
    	system.assert (wheel.getAnyData());
    	wheel.getWheelData();
    }
}