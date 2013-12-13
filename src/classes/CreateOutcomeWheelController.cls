public class CreateOutcomeWheelController 
{
	Contact client=null;
	
	public String  propName{ get; set; }
	public String  propPhone{ get; set; }
	public Decimal  owX1{ get; set; }
	public Decimal  owX2{ get; set; }
	public Decimal owX3{ get; set; }
	public Decimal  owX4{ get; set; }
	public Decimal  owX5{ get; set; }
	public Decimal  owX6{ get; set; }
	public Decimal  owX7{ get; set; }
	public Decimal  owX8{ get; set; }
	public Decimal  owX9{ get; set; }
	public Decimal  owX10{ get; set; }
 
 public CreateOutcomeWheelController(ApexPages.StandardController controller)
    {
	client = (Contact)controller.getRecord();
    }
	public CreateOutcomeWheelController()
		{
		Outcome_Wheel__c obj = [Select id, client__c, X1__c, X2__c, X3__c,
        X4__c, X5__c, X6__c, X7__c, X8__c, X9__c, X10__c 
        From Outcome_Wheel__c 
        where Client__c = :client.id order by Date_of_completion__c asc];
                                               
        owX1 = obj.X1__c;
        owX2 = obj.X2__c;
		owX3 = obj.X3__c;
		owX4 = obj.X4__c;
		owX5 = obj.X5__c;
		owX6 = obj.X6__c;
		owX7 = obj.X7__c;
		owX8 = obj.X8__c;
		owX9 = obj.X9__c;
		owX10 = obj.X10__c;
		}
	}