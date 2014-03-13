public with sharing class PushDonationsToBankFileController 
{
	private List<Opportunity> donationList;
	
	public PushDonationsToBankFileController(ApexPages.StandardSetController stdSetController) 
	{
    	donationList = (List<Opportunity>)stdSetController.getSelected();
		Initialise();
	}
	
	public PushDonationsToBankFileController(Integer testSize)
	{
		donationList = [select ID from Opportunity limit :testSize];
		Initialise();
	}

	public void Initialise ()
	{
    	donationList = [select ID, Name, Donor_Name__c, Donor_BIC__c, Donor_IBAN__c, StageName, CloseDate, Amount, Mandate_Date_of_Signature__c, Mandate_Reference__c from Opportunity where id in :donationList and StageName = 'Pledged'];
	}
	
	public String getMessageID ()
	{
		return 'DEPAUL-'+system.today().year()+'-'+system.today().month()+'-'+system.today().day()+'-'+system.now().hour()*60+system.now().minute();
	}	
	
	public String getTimeStamp ()
	{
		return system.now().format('YYYY-MM-DD')+'T'+system.now().format('HH:mm:ss');
	}
	
	public Integer getNumberOfTransactions ()
	{
		return donationList.size();	
	}
	
	public Decimal getSumTransactions ()
	{
		Decimal totalDonations = 0;
 		for (Opportunity oneDonation: donationList)
 		{
 			totalDonations += oneDonation.Amount;
 		}
		return totalDonations;
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
		return system.now().addDays(10).format('YYYY-MM-DD'); // would be nice to use a custom setting here
	}
	
	public list<Opportunity> getDonationList ()
	{
		return donationList;
	}
	
	public pageReference pushToXML ()
	{
		return ProcessDonations ();
	}
	
	public pageReference ProcessDonations ()
	{
		for (Opportunity oneDonation: donationList)
		{
			oneDonation.StageName = 'Posted';
		}
		update donationList;
		PageReference aPage = Page.PushDonationsToBankFilePage;
//		PageReference aPage = new PageReference(ApexPages.currentPage().getUrl());
//    	aPage.setRedirect(false);
//    	system.debug(aPage.getContent().toString());
    	// would like to refresh the source page
		return null;
	}
}