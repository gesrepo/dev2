public with sharing class GC_ItemOptionsControllerVOT {
    private final String DATE_TIME_FORMAT = 'MM/dd/YYYY hh:mm a';

    public GC_Vendor_Order_Task__c got {get; set;}
    public GC_CoreQuery coreApi {get; set;}
    public SelectOption[] materialAttributes {get; set;}
    public SelectOption[] venueAttributes {get; set;}
    public SelectOption[] designElementTasks {get; set;}
    public SelectOption[] activeGemStructureTasks {get; set;}

    public DateTime deliveryDateTime {get; set;}
    public DateTime completionDateTime {get; set;}
    public DateTime removalDateTime {get; set;}
    public GC_Task_Field_Manager__c taskFieldManager {get; set;}

    public String getDeliveryDateTimeFormatted() {
        if (got != null && got.Delivery_Date_Time_Ven__c != null) {
            return got.Delivery_Date_Time_Ven__c.format(DATE_TIME_FORMAT);
        }
        else {
            return null;
        }
    }

    public String getRemovalDateTimeFormatted() {
        if (got != null && got.Removal_Date_Time_Ven__c != null) {
            return got.Removal_Date_Time_Ven__c.format(DATE_TIME_FORMAT);
        }
        else {
            return null;
        }
    }

    public String getCompletionDateTimeFormatted() {
        if (got != null && got.Completion_Date_Time_Ven__c != null) {
            return got.Completion_Date_Time_Ven__c.format(DATE_TIME_FORMAT);
        }
        else {
            return null;
        }
    }

    public PageReference setDateTime() {
        system.debug('====='+Apexpages.currentPage().getParameters().containsKey('DDT'));
        if (Apexpages.currentPage().getParameters().containsKey('DDT')) {
            DateTime prevValue = got.Delivery_Date_Time_Ven__c;
            try {
                system.debug('++++'+Apexpages.currentPage().getParameters().get('DDT'));
                if (String.isBlank(Apexpages.currentPage().getParameters().get('DDT'))) {
                    got.Delivery_Date_Time_Ven__c = null;
                }
                else {
                    String dt = Apexpages.currentPage().getParameters().get('DDT');
                    String dayHour = changeDateFormat(dt);
                    got.Delivery_Date_Time_Ven__c = Datetime.parse(dayHour);
                    //got.Delivery_Date_Time_Ven__c = Datetime.parse(Apexpages.currentPage().getParameters().get('DDT'));
                }
            }
            catch (Exception e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Error validating Delivery Date/Time ' + e.getMessage()));
                got.Delivery_Date_Time_Ven__c = prevValue;
            }
            system.debug('got.Delivery_Date_Time_Ven__c==='+got.Delivery_Date_Time_Ven__c);
            return null;
        }
        else if (Apexpages.currentPage().getParameters().containsKey('CDT')) {
            DateTime prevValue = got.Completion_Date_Time_Ven__c;
            try {
                if (String.isBlank(Apexpages.currentPage().getParameters().get('CDT'))) {
                    got.Completion_Date_Time_Ven__c = null;
                }
                else {
                    String dt = Apexpages.currentPage().getParameters().get('CDT');
                    String dayHour = changeDateFormat(dt);
                    got.Completion_Date_Time_Ven__c = Datetime.parse(dayHour);
                    //got.Completion_Date_Time_Ven__c = Datetime.parse(Apexpages.currentPage().getParameters().get('CDT'));
                }
            }
            catch (Exception e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Error validating Completion Date/Time ' + e.getMessage()));
                got.Completion_Date_Time_Ven__c = prevValue;
            }
            return null;
        }
        else if (Apexpages.currentPage().getParameters().containsKey('RDT')) {
            DateTime prevValue = got.Removal_Date_Time_Ven__c;
            try {
                if (String.isBlank(Apexpages.currentPage().getParameters().get('RDT'))) {
                    got.Removal_Date_Time_Ven__c = null;
                }
                else {
                    String dt = Apexpages.currentPage().getParameters().get('RDT');
                    String dayHour = changeDateFormat(dt);
                    got.Removal_Date_Time_Ven__c = Datetime.parse(dayHour);
                    //got.Removal_Date_Time_Ven__c = Datetime.parse(Apexpages.currentPage().getParameters().get('RDT'));
                }
            }
            catch (Exception e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Error validating Removal Date/Time ' + e.getMessage()));
                got.Removal_Date_Time_Ven__c = prevValue;
            }
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
        } 
        else{
            time1 = listTime[0] + ':' + listTime[1] + ' PM';
        }
        String dayHour = listDT[0] + ' ' + time1;
        return dayHour;
    }
    
    
}