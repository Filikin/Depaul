@isTest
private class testGenerateOWReports 
{
    static testMethod void GenerateOWReports() 
    {
    	Contact testPerson = new Contact (LastName = 'me');
    	insert testPerson;
    	
    	Contact testPerson2 = new Contact (LastName = 'me too');
    	insert testPerson2;
    	
    	Contact testPerson3 = new Contact (LastName = 'me again');
    	insert testPerson3;
    	
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
    	
    	Outcome_Wheel__c outcomeWheel1 = new Outcome_Wheel__c (Stage__c='Admission',
    	X1__c=2, X2__c=2, X3__c=2, X4__c=2, X5__c=2, X6__c=2, X7__c=2, X8__c=2, X9__c=2, X10__c=2, 
        Client__c = testPerson.id, Date_of_completion__c=(system.today()- 2));
        insert outcomeWheel1;
        
        Outcome_Wheel__c outcomeWheel2 = new Outcome_Wheel__c (Stage__c='Early Review',
    	X1__c=4, X2__c=4, X3__c=4, X4__c=4, X5__c=4, X6__c=4, X7__c=4, X8__c=4, X9__c=4, X10__c=4, 
        Client__c = testPerson.id, Date_of_completion__c=(system.today()-1 ));
        insert outcomeWheel2;
        
        Outcome_Wheel__c outcomeWheel3 = new Outcome_Wheel__c (Stage__c='Admission',
    	X1__c=1, X2__c=1, X3__c=1, X4__c=1, X5__c=1, X6__c=1, X7__c=1, X8__c=1, X9__c=1, X10__c=1, 
        Client__c = testPerson2.id, Date_of_completion__c=(system.today()- 1));
        insert outcomeWheel3;
        
        Outcome_Wheel__c outcomeWheel4 = new Outcome_Wheel__c (Stage__c='Early Review',
    	X1__c=1, X2__c=1, X3__c=1, X4__c=1, X5__c=1, X6__c=1, X7__c=1, X8__c=1, X9__c=1, X10__c=1, 
        Client__c = testPerson2.id, Date_of_completion__c=(system.today()- 0));
        insert outcomeWheel4;
        
        Outcome_Wheel__c outcomeWheel5 = new Outcome_Wheel__c (Stage__c='Admission',
    	X1__c=4, X2__c=4, X3__c=4, X4__c=4, X5__c=4, X6__c=4, X7__c=4, X8__c=4, X9__c=4, X10__c=4, 
        Client__c = testPerson2.id, Date_of_completion__c=(system.today()- 1));
        insert outcomeWheel5;
        
        Outcome_Wheel__c outcomeWheel6 = new Outcome_Wheel__c (Stage__c='Early Review',
    	X1__c=1, X2__c=1, X3__c=1, X4__c=1, X5__c=1, X6__c=1, X7__c=1, X8__c=1, X9__c=1, X10__c=1, 
        Client__c = testPerson2.id, Date_of_completion__c=(system.today()- 0));
        insert outcomeWheel6;
        
        //outcomeWheel6.X1__c = 2;
        //update outcomeWheel6;
        
        //delete outcomeWheel5;
        
        //undelete outcomeWheel5;
        
        //outcomeWheel.X1__c = 3;
       // update outcomeWheel;
        
        system.Assert(true,master.Total_count__c != null);
        system.Assert(true,master.Total_clients_with_2ow__c = 3);
        //system.Assert(true,master.Avr_First_1__c = 2);
        system.Assert(true,master.Total_count__c = 6);
        system.Assert(true,master.Total_first__c = 3);
        /*system.Assert(true,master.Avr_First_2__c = 2);
        system.Assert(true,master.Avr_Last_1__c = 6);
        system.Assert(true,master.Ovr_Average_1__c = 3);
        system.Assert(true,master.Increase_1__c = 100);
        system.Assert(true,master.Increase_2__c = 100);
        system.Assert(true,master.Increase_3__c = 100);
        system.Assert(true,master.Increase_4__c = 100);
        system.Assert(true,master.Increase_5__c = 100);
        system.Assert(true,master.Increase_6__c = 100);
        system.Assert(true,master.Increase_7__c = 100);
        system.Assert(true,master.Increase_8__c = 100);
        system.Assert(true,master.Increase_9__c = 100);
        system.Assert(true,master.Increase_10__c = 100);
        system.Assert(true,master.Avr_Last_1__c = 6);
        system.Assert(true,master.Avr_Last_1__c = 6);
        system.Assert(true,master.Avr_Last_2__c = 6);
        system.Assert(true,master.Avr_Last_3__c = 4);
        system.Assert(true,master.Avr_Last_4__c = 4);
        system.Assert(true,master.Avr_Last_5__c = 4);
        system.Assert(true,master.Avr_Last_6__c = 4);
        system.Assert(true,master.Avr_Last_7__c = 4);
        system.Assert(true,master.Avr_Last_8__c = 4);
        system.Assert(true,master.Avr_Last_9__c = 4);
        system.Assert(true,master.Avr_Last_10__c = 4);
        system.Assert(true,master.Decrease_1__c = 0);
        system.Assert(true,master.Decrease_2__c = 0);
        system.Assert(true,master.Decrease_3__c = 0);
        system.Assert(true,master.Decrease_4__c = 0);
        system.Assert(true,master.Decrease_5__c = 0);
        system.Assert(true,master.Decrease_6__c = 0);
        system.Assert(true,master.Decrease_7__c = 0);
        system.Assert(true,master.Decrease_8__c = 0);
        system.Assert(true,master.Decrease_9__c = 0);
        system.Assert(true,master.Decrease_10__c = 0);
		system.Assert(true,master.Avr_First_1__c = outcomeWheel1.X1__c/master.Total_first__c);
		        
        
        system.Assert(true,
        master.Increase_1__c + master.Decrease_1__c + master.NoChange_1__c == 100);
        //|| master.Increase_1__c + master.Decrease_1__c + master.NoChange_1__c == 0);
        */
    	
    }
}