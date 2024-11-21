/***************************************
Trigger : TriggerEmailMessage 
Description : This is cretaed to insert a new case when a customer sends email message to an existing close case of
              "GES US Service" record type and assign this case to "US Email" queue
Created by : Gaurav Kumar on 31st Jan
***************************************/
trigger TriggerEmailMessage on EmailMessage (After Insert) {

    if(trigger.isafter)
    {    
        if(trigger.isInsert)
        {
            if(Label.DeactivateTrigger == 'false')
            {
                EmailMessageTriggerHelper obj = new EmailMessageTriggerHelper();
                obj.inboundEmailMessage(trigger.new);
            }
        }
    }

}