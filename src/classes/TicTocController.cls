public with sharing class TicTocController 
{
    Contact client=null;
    
   
    List<WheelPointData> data = new List<WheelPointData>();
    
    public List<WheelPointData> getWheelData() 
    {
        return data;
    }
    /**
    public class SigIssueData
    {
    	public String sigIssue1 { get; set; }
    	public String sigIssue2 { get; set; }
    	
    	public SigIssueData(List<Tic_Toc_Outcome_Wheel__c> outcomeWheels, String sigISS1)
    	{
    		this.sigIssue1 = (String) sigISS1;
    		this.sigIssue2 = (String)(outcomeWheels[0].get(sigIssue1)!=null?outcomeWheels[0].get(sigIssue1):0);
    	}
    }*/

    // Wrapper class
    public class WheelPointData 
    {
        public String name { get; set; }
        public Integer data1 { get; set; }
        public Integer data2 { get; set; }
        public Integer data3 { get; set; }
        public Integer data4 { get; set; }

        public WheelPointData(List<Tic_Toc_Outcome_Wheel__c> outcomeWheels, String fieldlabel, String fieldname)
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
    
    public TicTocController(ApexPages.StandardController controller)
    {
        client = (Contact)controller.getRecord();
    }
    
    public Boolean getAnyData ()
    {
        return data.size() > 0;
    }
    
    public void extractData ()
    {
       List<Tic_Toc_Outcome_Wheel__c> outcomeWheels = [select Stage__c, X1__c, X2__c, X3__c, X4__c, X5__c,
                X6__c, X7__c, X8__c, X9__c, X10__c, X11__c, X12__c, Significant_issue_1__c, Significant_issue_2__c
                from Tic_Toc_Outcome_Wheel__c where Client__c = :client.id order by Date_of_completion__c asc];
        if (outcomeWheels.size() > 0)
        {
            data.add (new WheelPointData (outcomeWheels, Tic_Toc_Outcome_Wheel__c.X1__c.getDescribe().getLabel(), 'X1__c'));
            data.add (new WheelPointData (outcomeWheels, Tic_Toc_Outcome_Wheel__c.X2__c.getDescribe().getLabel(), 'X2__c'));
            data.add (new WheelPointData (outcomeWheels, Tic_Toc_Outcome_Wheel__c.X3__c.getDescribe().getlabel(), 'X3__c'));         
            data.add (new WheelPointData (outcomeWheels, Tic_Toc_Outcome_Wheel__c.X4__c.getDescribe().getlabel(), 'X4__c'));           
            data.add (new WheelPointData (outcomeWheels, Tic_Toc_Outcome_Wheel__c.X5__c.getDescribe().getlabel(), 'X5__c'));           
            data.add (new WheelPointData (outcomeWheels, Tic_Toc_Outcome_Wheel__c.X6__c.getDescribe().getlabel(), 'X6__c'));           
            data.add (new WheelPointData (outcomeWheels, Tic_Toc_Outcome_Wheel__c.X7__c.getDescribe().getlabel(), 'X7__c'));         
            data.add (new WheelPointData (outcomeWheels, Tic_Toc_Outcome_Wheel__c.X8__c.getDescribe().getlabel(), 'X8__c'));         
            data.add (new WheelPointData (outcomeWheels, Tic_Toc_Outcome_Wheel__c.X9__c.getDescribe().getlabel(), 'X9__c'));         
            data.add (new WheelPointData (outcomeWheels, Tic_Toc_Outcome_Wheel__c.X10__c.getDescribe().getlabel(), 'X10__c'));
            data.add (new WheelPointData (outcomeWheels, Tic_Toc_Outcome_Wheel__c.X11__c.getDescribe().getlabel(), 'X11__c'));  
            data.add (new WheelPointData (outcomeWheels, Tic_Toc_Outcome_Wheel__c.X12__c.getDescribe().getlabel(), 'X12__c'));  
            //data.add (new WheelPointData (outcomeWheels, Tic_Toc_Outcome_Wheel__c.Significant_issue_1__c.getDescribe().getlabel(), 'Significant_issue_1__c'));  
            //String sigIssue1 = (String) outcomeWheels.Significant_issue_1__c;
            //String sigIssue2 = (String) Tic_Toc_Outcome_Wheel__c.Significant_issue_2__c;
        }
        
    }
    
    public static testMethod void testSampleData ()
    {
    	Contact client = new Contact (Lastname='Bloggs');
    	insert client;
    	      
    	Tic_Toc_Outcome_Wheel__c outcomeWheel = new Tic_Toc_Outcome_Wheel__c (Stage__c='Admission', X1__c=2, X2__c=2, X3__c=2, X4__c=2, X5__c=2,
                X6__c=2, X7__c=2, X8__c=2, X9__c=2, X10__c=2, X11__c = 2, X12__c = 2, Client__c = client.id, Date_of_completion__c=system.today());
        insert outcomeWheel;
    	
    	ApexPages.StandardController wheelControllerPage = new ApexPages.StandardController(client);
    	TicTocController wheel = new TicTocController (wheelControllerPage);
    	wheel.extractData();
    	system.assert (wheel.getAnyData());
    	wheel.getWheelData();
    }
}