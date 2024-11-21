public with sharing class GC_ItemOptionsController {
    private final String DATE_TIME_FORMAT = 'MM/dd/YYYY hh:mm a';

    public GC_GES_Order_Task__c got {get; set;}
    public GC_CoreQuery coreApi {get; set;}
    public SelectOption[] materialAttributes {get; set;}
    public SelectOption[] venueAttributes {get; set;}
    public SelectOption[] designElementTasks {get; set;}
    public SelectOption[] activeGemStructureTasks {get; set;}
    public GC_Task_Field_Manager__c taskFieldManager {get; set;}
    public String selectedParentCategory { get; set; }
    public String selectedChildCategory { get; set; }
    
    public string getstrDeliveryDateTime() {
        if(deliveryDateTime!=null){
            return deliveryDateTime.format('M/d/yyyy  h:mm a', UserInfo.getTimeZone().toString());
        }else{
            return '';
        }
    }
    
    public string getstrCompletionDateTime() {
        if(completionDateTime!=null){
            return completionDateTime.format('M/d/yyyy  h:mm a', UserInfo.getTimeZone().toString());
        }else{
            return '';
        }
    }
    public string getstrRemovalDateTime() {
        if(removalDateTime!=null){
            return removalDateTime.format('M/d/yyyy  h:mm a', UserInfo.getTimeZone().toString());
        }else{
            return '';
        }
    }
    //public string strCompletionDateTime  {get; set;}
    //public string strRemovalDateTime  {get; set;}
    public DateTime deliveryDateTime {get; set;}
    public DateTime completionDateTime {get; set;}
    public DateTime removalDateTime {get; set;}
    public GC_ItemOptionsController(){
    }
    
    public String getDeliveryDateTimeFormatted() {
        system.debug('entered getter');
        if (got != null && got.Delivery_Date_Time__c != null) {
            return got.Delivery_Date_Time__c.format(DATE_TIME_FORMAT);
        }
        else {
            return null;
        }
    }

    public String getRemovalDateTimeFormatted() {
        if (got != null && got.Removal_Date_Time__c != null) {
            return got.Removal_Date_Time__c.format(DATE_TIME_FORMAT);
        }
        else {
            return null;
        }
    }
    
    //public String CompletionDateTimeFormatted {get; set;}
    public String getCompletionDateTimeFormatted() {
        system.debug('got.Completion_Date_Time__c1==='+got.Completion_Date_Time__c);
        if (got != null && got.Completion_Date_Time__c != null) {
            system.debug('got.Completion_Date_Time__c2==='+got.Completion_Date_Time__c);
            system.debug('got.Completion_Date_Time__c3==='+got.Completion_Date_Time__c.format(DATE_TIME_FORMAT));
            return got.Completion_Date_Time__c.format(DATE_TIME_FORMAT);
        }
        else {
            return null;
        }
    }

    public PageReference setDateTime() {
        if (Apexpages.currentPage().getParameters().containsKey('DDT')) {
            DateTime prevValue = got.Delivery_Date_Time__c;
            system.debug('prevValue==='+prevValue);
            try {
                if (String.isBlank(Apexpages.currentPage().getParameters().get('DDT'))) {
                    got.Delivery_Date_Time__c = null;
                }
                else {
                    //got.Delivery_Date_Time__c = Datetime.parse(Apexpages.currentPage().getParameters().get('DDT'));
                    String dt = Apexpages.currentPage().getParameters().get('DDT');
                    String dayHour = changeDateFormat(dt);
                    got.Delivery_Date_Time__c = Datetime.parse(dayHour);
                }
            }
            catch (Exception e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Error validating Delivery Date/Time ' + e.getMessage()));
                got.Delivery_Date_Time__c = prevValue;
            }
            system.debug('got.Delivery_Date_Time__c==='+got.Delivery_Date_Time__c);
            return null;
        }
        else if (Apexpages.currentPage().getParameters().containsKey('CDT')) {
            DateTime prevValue = got.Completion_Date_Time__c;
            system.debug('prevValue==='+prevValue);
            try {
                if (String.isBlank(Apexpages.currentPage().getParameters().get('CDT'))) {
                    got.Completion_Date_Time__c = null;
                }
                else {
                    //system.debug('cdt==='+Apexpages.currentPage().getParameters().get('CDT'));
                    //DateTime dt = Datetime.parse(Apexpages.currentPage().getParameters().get('CDT'));
                    //system.debug('dt==='+dt);
                    //got.Completion_Date_Time__c = dt.addHours(-8);
                    //system.debug('got.Completion_Date_Time__c==='+got.Completion_Date_Time__c);
                    String dt = Apexpages.currentPage().getParameters().get('CDT');
                    String dayHour = changeDateFormat(dt);
                    got.Completion_Date_Time__c = Datetime.parse(dayHour);
                }
            }
            catch (Exception e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Error validating Completion Date/Time ' + e.getMessage()));
                got.Completion_Date_Time__c = prevValue;
                system.debug('e.getMessage()==='+e.getMessage());
            }
            system.debug('got.Completion_Date_Time__c==='+got.Completion_Date_Time__c);
            return null;
        }
        else if (Apexpages.currentPage().getParameters().containsKey('RDT')) {
            DateTime prevValue = got.Removal_Date_Time__c;
            system.debug('prevValue==='+prevValue);
            try {
                if (String.isBlank(Apexpages.currentPage().getParameters().get('RDT'))) {
                    got.Removal_Date_Time__c = null;
                }
                else {
                    //got.Removal_Date_Time__c = Datetime.parse(Apexpages.currentPage().getParameters().get('RDT'));
                    String dt = Apexpages.currentPage().getParameters().get('RDT');
                    String dayHour = changeDateFormat(dt);
                    got.Removal_Date_Time__c = Datetime.parse(dayHour);
                }
            }
            catch (Exception e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Error validating Removal Date/Time ' + e.getMessage()));
                got.Removal_Date_Time__c = prevValue;
            }
            system.debug('got.Removal_Date_Time__c==='+got.Removal_Date_Time__c);
            return null;
        }
        else {
            return null;
        }
    }
    
    public static string changeDateFormat(string dt) {
        List<String> listDT = dt.split(' ');
        List<String> listTime = listDT[1].split(':');
        String time1;
        if(integer.valueof(listTime[0]) < 12) {
            time1 = listTime[0] + ':' + listTime[1] + ' AM';
        } else
        if(integer.valueof(listTime[0]) > 12) {
            integer hour = integer.valueof(listTime[0]) - 12;
            time1 = string.valueof(hour) + ':' + listTime[1] + ' PM';
        } else
        {
            time1 = listTime[0] + ':' + listTime[1] + ' PM';
        }
        String dayHour = listDT[0] + ' ' + time1;
        return dayHour;
    }
    
    public  PageReference  copyDates(){
        system.debug('Entered copyAssociationValues');
        
        if(got.Copy_Default_Order_Dates__c == True){                           
            //got.Delivery_Date_Time__c = deliveryDateTime;
           // got.Completion_Date_Time__c= completionDateTime;
           // got.Removal_Date_Time__c= removalDateTime;
            if(deliveryDateTime!=null){
                got.Delivery_Date_Time__c = deliveryDateTime;
            }
                
            if(completionDateTime!=null ){
                got.Completion_Date_Time__c= completionDateTime;
            }
                
            if(removalDateTime!=null ){
                got.Removal_Date_Time__c= removalDateTime;
            }
                       
            
        }else{
            got.Delivery_Date_Time__c = null;
            got.Completion_Date_Time__c= null;
            got.Removal_Date_Time__c= null;         
        }
        
         return null;
    }
}