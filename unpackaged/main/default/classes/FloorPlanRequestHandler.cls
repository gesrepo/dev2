public class FloorPlanRequestHandler {
    
    public static void updateDueDate(List<Floor_Plan_Request__c> listFPR){
        Date currentDate = System.today();
        Date oldDate = Date.newInstance(1900, 1, 7);
        Integer dateDiff = oldDate.daysBetween(currentDate);
        Integer day = Math.mod(dateDiff,7);
        List<String> holidayList = System.Label.GC_USHolidayList.split(',');
        Integer dueDays = caclulateDueDate(holidayList, day, currentDate);
        for(Floor_Plan_Request__c fpr : listFPR){
            fpr.UserEntered_Requested_Due_Date__c = currentDate + dueDays;
            fpr.Is_Approval_Submitted__c = false;
        }
    }
    
    public static Integer caclulateDueDate(List<String> holidayList, Integer day, Date currentDate){
        Integer skipSaturday = 0;
        Integer skipSanday = 0;
        Integer countDays = 0;
        Integer countDueDays = 0;
        
        system.debug('holidayList:: '+holidayList);
        system.debug('day:: '+day);
        system.debug('currentDate:: '+currentDate);
        skipSaturday = day==0? 6 : day==1? 5: day==2? 4 : day==3? 3: day==4? 2 : day==5? 1 : day==6? 7 : 0;
        skipSanday =   day==0? 7 : day==1? 6: day==2? 5 : day==3? 4: day==4? 3 : day==5? 2 : day==6? 1 : 0;
		
        system.debug('skipSaturday:: '+skipSaturday);
        system.debug('skipSanday:: '+skipSanday);
        
        for(Integer i=1; i<100; i++){
            if(skipSaturday == i){
                skipSaturday = i+7;
                continue;
            }else if(skipSanday == i){
                skipSanday = i+7;
                continue;
            }
            
            String textDate = String.Valueof(currentDate+i);
            
            if(!holidayList.contains(textDate)){
                ++countDays;
            }
            
            if(countDays == 2){
                countDueDays = i;
                break; 
            }
        }
        return countDueDays;
    }

}