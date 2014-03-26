global class ScheduleFutureItemChecks implements Schedulable
{
   global void execute(SchedulableContext SC) 
   {
      CreateFutureChecks checks = new CreateFutureChecks(); 
      checks.CreateChecks(false);
   }
}