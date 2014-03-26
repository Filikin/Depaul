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

	public void Initialise ()
	{
		for (String transCode: new list<String>{'FRST', 'RCUR', 'OOFF', 'FNAL'})
		{
			DonationsWithOneSEPACode oneCode = new DonationsWithOneSEPACode (transCode, 
    			[select ID, Name, SEPA_transaction_code__c, Donor_Name__c, Donor_BIC__c, Donor_IBAN__c, StageName, CloseDate, Amount, Mandate_Date_of_Signature__c, Mandate_Reference__c from Opportunity where id in :selectedDonationList and StageName = 'Pledged' and SEPA_transaction_code__c= :transCode]);
    		allDonationsByCode.add (oneCode);
		}
		sumOfTransactions = (Decimal)([select sum(Amount) sumTransactions from Opportunity where id in :selectedDonationList and StageName = 'Pledged'][0].get('sumTransactions'));
	}
	
	public String getMessageID ()
	{
		return 'DEPAUL-'+system.today().year()+'-'+system.today().month()+'-'+system.today().day()+'-'+system.now().hour()*60+system.now().minute();
	}	
	
	public String getTimeStamp ()
	{
		return system.now().format('YYYY-MM-dd')+'T'+system.now().format('HH:mm:ss');
	}
	
	public Integer getNumberOfTransactions ()
	{
		return  [select count() from Opportunity where id in :selectedDonationList and StageName = 'Pledged'];
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
		return system.now().addDays(6).format('YYYY-MM-dd'); // would be nice to use a custom setting here
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