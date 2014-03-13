trigger Contact on Contact (before insert, before update) 
{
	TriggerDispatcher.MainEntry ('Contact', trigger.isBefore, trigger.isDelete, trigger.isAfter, trigger.isInsert, trigger.isUpdate, trigger.isExecuting,
		trigger.new, trigger.newMap, trigger.old, trigger.oldMap);
}