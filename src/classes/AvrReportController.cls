public with sharing class AvrReportController {
	
	
	

	List <Master_OW_Report__c> master1 = [Select
	Name,
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
	Difference_1__c,
	Difference_2__c,
	Difference_3__c,
	Difference_4__c,
	Difference_5__c,
	Difference_6__c,
	Difference_7__c,
	Difference_8__c,
	Difference_9__c,
	Difference_10__c,
	Overall_Average__c,
	Overall_First_Average__c,
	Overall_Last_Average__c,
	Overall_Difference__c,
	Total_count__c,
	Total_first__c,
	Total_last__c
	from Master_OW_Report__c
	where Name = 'MASTEROW001'
	];
	
	Master_OW_Report__c master = master1[0];
	
		
	public Master_OW_Report__c getMaster() {
        return master;
    }
    
    
}