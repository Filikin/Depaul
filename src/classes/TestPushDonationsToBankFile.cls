@isTest
private class TestPushDonationsToBankFile 
{
 	static testMethod void TestPushDonationsToBankFile ()
	{
		ID DonorRecordTypeID = [select ID from RecordType where sObjectType='Contact' and DeveloperName='Donor'].id;
		Contact donor = new Contact (LastName='Me', RecordTypeID=DonorRecordTypeID);
		insert donor;
		
 		npe03__Recurring_Donation__c standingOrder = new npe03__Recurring_Donation__c (Name='Test donation', npe03__Installments__c=3, npe03__Amount__c=300, npe03__Contact__c=donor.id);
 		insert standingOrder;
 		
 		test.startTest();
		PushDonationsToBankFileController pc = new PushDonationsToBankFileController(2);
 		pc.getSEPATransactionCodeList();
 		pc.getMessageID();
 		pc.getCollectionDate();
 		pc.getNumberOfTransactions();
 		pc.getPaymentInfoID1();
 		pc.getSequenceType();
 		pc.getTimeStamp();
 		pc.ProcessDonations();
 		pc.pushToXML();
 		test.stopTest();
 	}
}