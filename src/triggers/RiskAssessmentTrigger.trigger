trigger RiskAssessmentTrigger on Risk_Assessment__c (before insert) 
{
	TriggerDispatcher.MainEntry ('Risk_Assessment__c', trigger.isBefore, trigger.isDelete, trigger.isAfter, trigger.isInsert, trigger.isUpdate, trigger.isExecuting,
		trigger.new, trigger.newMap, trigger.old, trigger.oldMap);
}