trigger GenerateOWReports on Outcome_Wheel__c (after update, after insert, after delete, after undelete) {
	
	List <Outcome_Wheel__c> allOWs = [Select Name, 
	X1__c,
	X2__c,
	X3__c,
	X4__c,
	X5__c,
	X6__c,
	X7__c,
	X8__c,
	X9__c,
	X10__c,
	Status__c
	From Outcome_Wheel__c];
	
	
	/**Integer OvrAverage1 = 0;
	Integer OvrAverage2 = 0;
	Integer OvrAverage3 = 0;
	Integer OvrAverage4 = 0;
	Integer OvrAverage5 = 0;
	Integer OvrAverage6 = 0;
	Integer OvrAverage7 = 0;
	Integer OvrAverage8 = 0;
	Integer OvrAverage9 = 0;
	Integer OvrAverage10 = 0;*/
	
	List <Master_OW_Report__c> master1 = [Select
	Name,
	Increase_1__c,
	Increase_2__c,
	Increase_3__c,
	Increase_4__c,
	Increase_5__c,
	Increase_6__c,
	Increase_7__c,
	Increase_8__c,
	Increase_9__c,
	Increase_10__c,
	Decrease_1__c,
	Decrease_2__c,
	Decrease_3__c,
	Decrease_4__c,
	Decrease_5__c,
	Decrease_6__c,
	Decrease_7__c,
	Decrease_8__c,
	Decrease_9__c,
	Decrease_10__c,
	NoChange_1__c,
	NoChange_2__c,
	NoChange_3__c,
	NoChange_4__c,
	NoChange_5__c,
	NoChange_6__c,
	NoChange_7__c,
	NoChange_8__c,
	NoChange_9__c,
	NoChange_10__c,
	Avr_First_1__c,
	Avr_First_10__c,
	Avr_First_2__c,
	Avr_First_3__c,
	Avr_First_4__c,
	Avr_First_5__c,
	Avr_First_6__c,
	Avr_First_7__c,
	Avr_First_8__c,
	Avr_First_9__c,
	Avr_Last_10__c,
	Avr_Last_1__c,
	Avr_Last_2__c,
	Avr_Last_3__c,
	Avr_Last_4__c,
	Avr_Last_5__c,
	Avr_Last_6__c,
	Avr_Last_7__c,
	Avr_Last_8__c,
	Avr_Last_9__c,
	Ovr_Average_1__c,
	Ovr_Average_10__c,
	Ovr_Average_2__c,
	Ovr_Average_3__c,
	Ovr_Average_4__c,
	Ovr_Average_5__c,
	Ovr_Average_6__c,
	Ovr_Average_7__c,
	Ovr_Average_8__c,
	Ovr_Average_9__c,
	Total_count__c,
	Total_first__c,
	Total_last__c,
	Total_clients_with_2ow__c
	from Master_OW_Report__c
	where Name = 'MASTEROW001'
	];
	
	Master_OW_Report__c master = master1[0];
	master.Increase_1__c = 0;
	master.Increase_2__c = 0;
	master.Increase_3__c = 0;
	master.Increase_4__c = 0;
	master.Increase_5__c = 0;
	master.Increase_6__c = 0;
	master.Increase_7__c = 0;
	master.Increase_8__c = 0;
	master.Increase_9__c = 0;
	master.Increase_10__c = 0;
	master.Decrease_1__c = 0;
	master.Decrease_2__c = 0;
	master.Decrease_3__c = 0;
	master.Decrease_4__c = 0;
	master.Decrease_5__c = 0;
	master.Decrease_6__c = 0;
	master.Decrease_7__c = 0;
	master.Decrease_8__c = 0;
	master.Decrease_9__c = 0;
	master.Decrease_10__c = 0;
	master.NoChange_1__c = 0;
	master.NoChange_2__c = 0;
	master.NoChange_3__c = 0;
	master.NoChange_4__c = 0;
	master.NoChange_5__c = 0;
	master.NoChange_6__c = 0;
	master.NoChange_7__c = 0;
	master.NoChange_8__c = 0;
	master.NoChange_9__c = 0;
	master.NoChange_10__c = 0;
	master.Avr_First_1__c = 0;
	master.Avr_First_10__c = 0;
	master.Avr_First_2__c = 0;
	master.Avr_First_3__c = 0;
	master.Avr_First_4__c = 0;
	master.Avr_First_5__c = 0;
	master.Avr_First_6__c = 0;
	master.Avr_First_7__c = 0;
	master.Avr_First_8__c = 0;
	master.Avr_First_9__c = 0;
	master.Avr_Last_10__c = 0;
	master.Avr_Last_1__c = 0;
	master.Avr_Last_2__c = 0;
	master.Avr_Last_3__c = 0;
	master.Avr_Last_4__c = 0;
	master.Avr_Last_5__c = 0;
	master.Avr_Last_6__c = 0;
	master.Avr_Last_7__c = 0;
	master.Avr_Last_8__c = 0;
	master.Avr_Last_9__c = 0;
	master.Ovr_Average_1__c = 0;
	master.Ovr_Average_10__c = 0;
	master.Ovr_Average_2__c = 0;
	master.Ovr_Average_3__c = 0;
	master.Ovr_Average_4__c = 0;
	master.Ovr_Average_5__c = 0;
	master.Ovr_Average_6__c = 0;
	master.Ovr_Average_7__c = 0;
	master.Ovr_Average_8__c = 0;
	master.Ovr_Average_9__c = 0;
	master.Total_count__c = 0;
	master.Total_first__c = 0;
	master.Total_last__c = 0;
	update master;
	
	for (Outcome_Wheel__c a:allOWs)
	{
		master.Total_count__c += 1;
		master.Ovr_Average_1__c += a.X1__c;
		master.Ovr_Average_2__c += a.X2__c;
		master.Ovr_Average_3__c += a.X3__c;
		master.Ovr_Average_4__c += a.X4__c;
		master.Ovr_Average_5__c += a.X5__c;
		master.Ovr_Average_6__c += a.X6__c;
		master.Ovr_Average_7__c += a.X7__c;
		master.Ovr_Average_8__c += a.X8__c;
		master.Ovr_Average_9__c += a.X9__c;
		master.Ovr_Average_10__c += a.X10__c;
		//update master;
		
		if (a.Status__c == 'First')
		{
			master.Total_first__c += 1;
			master.Avr_First_1__c += a.X1__c;
			master.Avr_First_2__c += a.X2__c;
			master.Avr_First_3__c += a.X3__c;
			master.Avr_First_4__c += a.X4__c;
			master.Avr_First_5__c += a.X5__c;
			master.Avr_First_6__c += a.X6__c;
			master.Avr_First_7__c += a.X7__c;
			master.Avr_First_8__c += a.X8__c;
			master.Avr_First_9__c += a.X9__c;
			master.Avr_First_10__c += a.X10__c;
			
			//update master;
		}
		
		if (a.Status__c == 'Latest')
		{
			master.Total_last__c += 1;
			master.Avr_Last_1__c += a.X1__c;
			master.Avr_Last_2__c += a.X2__c;
			master.Avr_Last_3__c += a.X3__c;
			master.Avr_Last_4__c += a.X4__c;
			master.Avr_Last_5__c += a.X5__c;
			master.Avr_Last_6__c += a.X6__c;
			master.Avr_Last_7__c += a.X7__c;
			master.Avr_Last_8__c += a.X8__c;
			master.Avr_Last_9__c += a.X9__c;
			master.Avr_Last_10__c += a.X10__c;
			
			//update master;
			
		}
		update master;
	}
	
		master.Ovr_Average_1__c = master.Ovr_Average_1__c/master.Total_count__c;
		master.Ovr_Average_2__c = master.Ovr_Average_2__c/master.Total_count__c;
		master.Ovr_Average_3__c = master.Ovr_Average_3__c/master.Total_count__c;
		master.Ovr_Average_4__c = master.Ovr_Average_4__c/master.Total_count__c;
		master.Ovr_Average_5__c = master.Ovr_Average_5__c/master.Total_count__c;
		master.Ovr_Average_6__c = master.Ovr_Average_6__c/master.Total_count__c;
		master.Ovr_Average_7__c = master.Ovr_Average_7__c/master.Total_count__c;
		master.Ovr_Average_8__c = master.Ovr_Average_8__c/master.Total_count__c;
		master.Ovr_Average_9__c = master.Ovr_Average_9__c/master.Total_count__c;
		master.Ovr_Average_10__c = master.Ovr_Average_10__c/master.Total_count__c;
		
		//update master;
		
		if (master.Total_last__c > 0)
		{
			master.Avr_Last_1__c = master.Avr_Last_1__c/master.Total_last__c;
			master.Avr_Last_2__c = master.Avr_Last_2__c/master.Total_last__c;
			master.Avr_Last_3__c = master.Avr_Last_3__c/master.Total_last__c;
			master.Avr_Last_4__c = master.Avr_Last_4__c/master.Total_last__c;
			master.Avr_Last_5__c = master.Avr_Last_5__c/master.Total_last__c;
			master.Avr_Last_6__c = master.Avr_Last_6__c/master.Total_last__c;
			master.Avr_Last_7__c = master.Avr_Last_7__c/master.Total_last__c;
			master.Avr_Last_8__c = master.Avr_Last_8__c/master.Total_last__c;
			master.Avr_Last_9__c = master.Avr_Last_9__c/master.Total_last__c;
			master.Avr_Last_10__c = master.Avr_Last_10__c/master.Total_last__c;
			
			//update master;
		}
		
		if (master.Total_first__c > 0)
		{
			master.Avr_First_1__c = master.Avr_First_1__c/master.Total_first__c;
			master.Avr_First_2__c = master.Avr_First_2__c/master.Total_first__c;
			master.Avr_First_3__c = master.Avr_First_3__c/master.Total_first__c;
			master.Avr_First_4__c = master.Avr_First_4__c/master.Total_first__c;
			master.Avr_First_5__c = master.Avr_First_5__c/master.Total_first__c;
			master.Avr_First_6__c = master.Avr_First_6__c/master.Total_first__c;
			master.Avr_First_7__c = master.Avr_First_7__c/master.Total_first__c;
			master.Avr_First_8__c = master.Avr_First_8__c/master.Total_first__c;
			master.Avr_First_9__c = master.Avr_First_9__c/master.Total_first__c;
			master.Avr_First_10__c = master.Avr_First_10__c/master.Total_first__c;
			
			//update master;
		}
	
	List <Outcome_Wheel__c> allfirstOWs = [Select Name, 
	X1__c,
	X2__c,
	X3__c,
	X4__c,
	X5__c,
	X6__c,
	X7__c,
	X8__c,
	X9__c,
	X10__c,
	Client__c,
	Status__c
	From Outcome_Wheel__c
	where Status__c = 'First'];
	
	List <Outcome_Wheel__c> allLastOWs = [Select Name, 
	X1__c,
	X2__c,
	X3__c,
	X4__c,
	X5__c,
	X6__c,
	X7__c,
	X8__c,
	X9__c,
	X10__c,
	Client__c,
	Status__c
	From Outcome_Wheel__c
	where Status__c = 'Latest'];
	
	//system.assert( allLastOWs[0] != null);
	
	for (Outcome_Wheel__c f:allFirstOWs)
	{
		for(Outcome_Wheel__c l:allLastOWs)
		{
			//Nothing in this for loop is being accessed by the test.
			//String FirstClient = f.Client__r;
			//String LastClient = l.Client__r;
			//system.assert(FirstClient.equals(LastClient));
			//if(FirstClient.equals(LastClient))
			
			if(f.Client__c == l.Client__c)
			{
				if(f.X1__c < l.X1__c)
				{
					master.Increase_1__c += 1;
					//update master;
				}
				else if(f.X1__c > l.X1__c)
				{
					master.Decrease_1__c += 1;
					//update master;
				}
				else
				{
					master.NoChange_1__c =+ 1;
					//update master;
				}
				
				if(f.X2__c < l.X2__c)
				{
					master.Increase_2__c += 1;
					//update master;
				}
				else if(f.X2__c > l.X2__c)
				{
					master.Decrease_2__c += 1;
					//update master;
				}
				else
				{
					master.NoChange_2__c =+ 1;
					//update master;
				}
				
				if(f.X3__c < l.X3__c)
				{
					master.Increase_3__c += 1;
					//update master;
				}
				else if(f.X3__c > l.X3__c)
				{
					master.Decrease_3__c += 1;
					//update master;
				}
				else
				{
					master.NoChange_3__c =+ 1;
					//update master;
				}
				
				if(f.X4__c < l.X4__c)
				{
					master.Increase_4__c += 1;
					//update master;
				}
				else if(f.X4__c > l.X4__c)
				{
					master.Decrease_4__c += 1;
					//update master;
				}
				else
				{
					master.NoChange_4__c =+ 1;
					//update master;
				}
				
				if(f.X5__c < l.X5__c)
				{
					master.Increase_5__c += 1;
					//update master;
				}
				else if(f.X5__c > l.X5__c)
				{
					master.Decrease_5__c += 1;
					//update master;
				}
				else
				{
					master.NoChange_5__c =+ 1;
					//update master;
				}
				
				if(f.X6__c < l.X6__c)
				{
					master.Increase_6__c += 1;
					//update master;
				}
				else if(f.X6__c > l.X6__c)
				{
					master.Decrease_6__c += 1;
					//update master;
				}
				else
				{
					master.NoChange_6__c =+ 1;
					//update master;
				}
				
				if(f.X7__c < l.X7__c)
				{
					master.Increase_7__c += 1;
					//update master;
				}
				else if(f.X7__c > l.X7__c)
				{
					master.Decrease_7__c += 1;
					//update master;
				}
				else
				{
					master.NoChange_7__c =+ 1;
					//update master;
				}
				
				if(f.X8__c < l.X8__c)
				{
					master.Increase_8__c += 1;
					//update master;
				}
				else if(f.X8__c > l.X8__c)
				{
					master.Decrease_8__c += 1;
					//update master;
				}
				else
				{
					master.NoChange_8__c =+ 1;
					//update master;
				}
				
				if(f.X9__c < l.X9__c)
				{
					master.Increase_9__c += 1;
					//update master;
				}
				else if(f.X9__c > l.X9__c)
				{
					master.Decrease_9__c += 1;
					//update master;
				}
				else
				{
					master.NoChange_9__c =+ 1;
					//update master;
				}
				
				if(f.X10__c < l.X10__c)
				{
					master.Increase_10__c += 1;
					//update master;
				}
				else if(f.X10__c > l.X10__c)
				{
					master.Decrease_10__c += 1;
					//update master;
				}
				else
				{
					master.NoChange_10__c =+ 1;
					//update master;
				}
				
				master.Total_clients_with_2ow__c =+ 1;
				update master;
			}
		}
	}
	
	//Assigning the % values to Increase fields
	
	if (master.Increase_1__c != 0)
	{
		master.Increase_1__c = (master.Increase_1__c/master.Total_clients_with_2ow__c)*100;
	}
	
	if (master.Increase_2__c != 0)
	{
		master.Increase_2__c = (master.Increase_2__c/master.Total_clients_with_2ow__c)*100;
	}
	
	if (master.Increase_3__c != 0)
	{
		master.Increase_3__c = (master.Increase_3__c/master.Total_clients_with_2ow__c)*100;
	}
	
	if (master.Increase_4__c != 0)
	{
		master.Increase_4__c = (master.Increase_4__c/master.Total_clients_with_2ow__c)*100;
	}
	
	if (master.Increase_5__c != 0)
	{
		master.Increase_5__c = (master.Increase_5__c/master.Total_clients_with_2ow__c)*100;
	}
	
	if (master.Increase_6__c != 0)
	{
		master.Increase_6__c = (master.Increase_6__c/master.Total_clients_with_2ow__c)*100;
	}
	
	if (master.Increase_7__c != 0)
	{
		master.Increase_7__c = (master.Increase_7__c/master.Total_clients_with_2ow__c)*100;
	}
	
	if (master.Increase_8__c != 0)
	{
		master.Increase_8__c = (master.Increase_8__c/master.Total_clients_with_2ow__c)*100;
	}
	
	if (master.Increase_9__c != 0)
	{
		master.Increase_9__c = (master.Increase_9__c/master.Total_clients_with_2ow__c)*100;
	}
	
	if (master.Increase_10__c != 0)
	{
		master.Increase_10__c = (master.Increase_10__c/master.Total_clients_with_2ow__c)*100;
	}
	
	
	//Assigning % values to Decrease fields
	
	if (master.Decrease_1__c != 0)
	{
		master.Decrease_1__c = (master.Decrease_1__c/master.Total_clients_with_2ow__c)*100;
	}
	
	if (master.Decrease_2__c != 0)
	{
		master.Decrease_2__c = (master.Decrease_2__c/master.Total_clients_with_2ow__c)*100;
	}
	
	if (master.Decrease_3__c != 0)
	{
		master.Decrease_3__c = (master.Decrease_3__c/master.Total_clients_with_2ow__c)*100;
	}
	
	if (master.Decrease_4__c != 0)
	{
		master.Decrease_4__c = (master.Decrease_4__c/master.Total_clients_with_2ow__c)*100;
	}
	
	if (master.Decrease_5__c != 0)
	{
		master.Decrease_5__c = (master.Decrease_5__c/master.Total_clients_with_2ow__c)*100;
	}
	
	if (master.Decrease_6__c != 0)
	{
		master.Decrease_6__c = (master.Decrease_6__c/master.Total_clients_with_2ow__c)*100;
	}
	
	if (master.Decrease_7__c != 0)
	{
		master.Decrease_7__c = (master.Decrease_7__c/master.Total_clients_with_2ow__c)*100;
	}
	
	if (master.Decrease_8__c != 0)
	{
		master.Decrease_8__c = (master.Decrease_8__c/master.Total_clients_with_2ow__c)*100;
	}
	
	if (master.Decrease_9__c != 0)
	{
		master.Decrease_9__c = (master.Decrease_9__c/master.Total_clients_with_2ow__c)*100;
	}
	
	if (master.Decrease_10__c != 0)
	{
		master.Decrease_10__c = (master.Decrease_10__c/master.Total_clients_with_2ow__c)*100;
	}
	
	//Assigning % values to NoChange fields
	
	if (master.NoChange_1__c != 0)
	{
		master.NoChange_1__c = (master.NoChange_1__c/master.Total_clients_with_2ow__c)*100;
	}
	if (master.NoChange_2__c != 0)
	{
		master.NoChange_2__c = (master.NoChange_2__c/master.Total_clients_with_2ow__c)*100;
	}
	if (master.NoChange_3__c != 0)
	{
		master.NoChange_3__c = (master.NoChange_3__c/master.Total_clients_with_2ow__c)*100;
	}
	if (master.NoChange_4__c != 0)
	{
		master.NoChange_4__c = (master.NoChange_4__c/master.Total_clients_with_2ow__c)*100;
	}
	if (master.NoChange_5__c != 0)
	{
		master.NoChange_5__c = (master.NoChange_5__c/master.Total_clients_with_2ow__c)*100;
	}
	if (master.NoChange_6__c != 0)
	{
		master.NoChange_6__c = (master.NoChange_6__c/master.Total_clients_with_2ow__c)*100;
	}
	if (master.NoChange_7__c != 0)
	{
		master.NoChange_7__c = (master.NoChange_7__c/master.Total_clients_with_2ow__c)*100;
	}
	if (master.NoChange_8__c != 0)
	{
		master.NoChange_8__c = (master.NoChange_8__c/master.Total_clients_with_2ow__c)*100;
	}
	if (master.NoChange_9__c != 0)
	{
		master.NoChange_9__c = (master.NoChange_9__c/master.Total_clients_with_2ow__c)*100;
	}
	if (master.NoChange_10__c != 0)
	{
		master.NoChange_10__c = (master.NoChange_10__c/master.Total_clients_with_2ow__c)*100;
	}
	
	update master;

}