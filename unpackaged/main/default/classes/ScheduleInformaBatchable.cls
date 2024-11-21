/**
 * Class: ScheduleInformaBatchable.cls
 * Developer: Marian Iovi (marian.iovi@vertiba.com)
 * Created: December 28, 2016
 * Modified: -
 * Objective: This class is a job. Running at 6 AM GMT
 *
 **/

global class ScheduleInformaBatchable implements schedulable {

    global void execute(SchedulableContext sc) {
               
        InformaBatchable informaBatch = new InformaBatchable();
        informaBatch.query = 'SELECT Id, Name,Token__c, Event_Code__c, Organizer_Client__c, AccountId, Last_Run_Date__c FROM Opportunity where Token__c != null and Event_Code__c != null';
        Database.executeBatch(informaBatch);
        
    }
}