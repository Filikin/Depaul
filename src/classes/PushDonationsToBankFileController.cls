/*
Author: Eamon Kelly, Enclude
Purpose: Produce an XML file in SEPA pain.008.001.02 format
Called from: ushDonationsToBankFilePage and PushDonationsToSEPANI (for NI (Stg) - not used yet)
Tested from: TestPushDonationsToBankFile
*/
public with sharing class PushDonationsToBankFileController 
{
	public class DonationsWithOneSEPACode
	{
		public String sepaCode {get; set;}
		public list <Opportunity> donations {get;set;}
		public Integer numberOfTransactions {get; set;}
		public Decimal sumOfTransactions {get;set;}
		
		DonationsWithOneSEPACode (String code, list<Opportunity>donat)
		{
			sepaCode = code;
			donations = donat;
			if (donations != null) 
			{
				numberOfTransactions = donations.size();
				sumOfTransactions = sumTransactions (donat);
			}
			else numberOfTransactions = 0;
		}
	
		public Decimal sumTransactions (list<Opportunity> donationsToSum)
		{
			Decimal totalDonations = 0;
	 		for (Opportunity oneDonation: donationsToSum)
	 		{
	 			totalDonations += oneDonation.Amount;
	 		}
			return totalDonations;
		}
	
	}
	
	private List<Opportunity> selectedDonationList;
	private list<DonationsWithOneSEPACode> allDonationsByCode = new list<DonationsWithOneSEPACode>();
	public Decimal sumOfTransactions {get;set;}
	public Integer numberOfTransactions {get;set;}
	private Date collectionDate;
	
	public list<DonationsWithOneSEPACode> getSEPATransactionCodeList ()
	{
		return 	allDonationsByCode;
	}
	
	public PushDonationsToBankFileController(ApexPages.StandardSetController stdSetController) 
	{
    	selectedDonationList = (List<Opportunity>)stdSetController.getSelected();
		Initialise();
	}
	
	public PushDonationsToBankFileController(Integer testSize)
	{
		selectedDonationList = [select ID from Opportunity limit :testSize];
		Initialise();
	}

	public Date calculateCollectionDate (Date currentDate)
	{
		Date collDate;
		SEPA_Settings__c theobject = SEPA_Settings__c.getOrgDefaults();
		if(theobject==null) 
		{
			theobject = new SEPA_Settings__c();
			theobject.name = 'default';
			if(!Test.isRunningTest()) Database.Insert(theobject);
			else // set default test values (can be different from default values) 
			{
				theobject.Day_of_the_month_for_collection__c = 2;
			}
		}
		if (currentDate.day() < theobject.Day_of_the_month_for_collection__c) 
		{
			collDate = Date.newInstance (currentDate.year(), currentDate.month(), (Integer)theobject.Day_of_the_month_for_collection__c);
		}
		else 
		{
			if (currentDate.month() == 12) collDate = Date.newInstance (currentDate.year(), 1, (Integer)theobject.Day_of_the_month_for_collection__c);
			else collDate = Date.newInstance (currentDate.year(), currentDate.month()+1, (Integer)theobject.Day_of_the_month_for_collection__c); 
		}
		return collDate;  	
	}
	
	public void Initialise ()
	{
		collectionDate = calculateCollectionDate (system.today());
		
		for (String transCode: new list<String>{'FRST', 'RCUR', 'OOFF', 'FNAL'})
		{
			DonationsWithOneSEPACode oneCode = new DonationsWithOneSEPACode (transCode, 
    			[select ID, Name, SEPA_transaction_code__c, Donor_Name__c, Donor_BIC__c, Donor_IBAN__c, StageName, CloseDate, Amount, Mandate_Date_of_Signature__c, Mandate_Reference__c from Opportunity where id in :selectedDonationList and StageName = 'Pledged' and SEPA_transaction_code__c= :transCode]);
    		allDonationsByCode.add (oneCode);
		}
		sumOfTransactions = (Decimal)([select sum(Amount) sumTransactions from Opportunity where id in :selectedDonationList and StageName = 'Pledged'][0].get('sumTransactions'));
		numberOfTransactions = [select count() from Opportunity where id in :selectedDonationList and StageName = 'Pledged'];
	}
	
	public String getMessageID ()
	{
		return 'DEPAUL-'+system.today().year()+'-'+system.today().month()+'-'+system.today().day()+'-'+system.now().hour()*60+system.now().minute();
	}	
	
	public String getTimeStamp ()
	{
		return system.now().format('YYYY-MM-dd')+'T'+system.now().format('HH:mm:ss');
	}
	
	public String getPaymentInfoID1 ()
	{
		return getMessageID() + '-1';
	}
	
	public String getSequenceType ()
	{
		/* Valid values are:
			FRST – for First presentation
			RCUR – for Recurrent presentation
			OOFF – for Once off presentation
			FNAL – for Final presentation
		*/
		return 'FRST';	
	}
	
	public String getCollectionDate ()
	{
		return system.now().addDays(8).format('YYYY-MM-dd'); // would be nice to use a custom setting here
	}
	
	public pageReference pushToXML ()
	{
		return ProcessDonations ();
	}
	
	public pageReference ProcessDonations ()
	{
		list<Opportunity> allDonations = [select StageName from Opportunity where id in :selectedDonationList and StageName = 'Pledged'];
		for (Opportunity oneDonation: allDonations)
		{
			oneDonation.StageName = 'Posted';
		}
		update allDonations;
		PageReference aPage = Page.PushDonationsToBankFilePage;
//		PageReference aPage = new PageReference(ApexPages.currentPage().getUrl());
//    	aPage.setRedirect(false);
//    	system.debug(aPage.getContent().toString());
    	// would like to refresh the source page
		return null;
	}
}