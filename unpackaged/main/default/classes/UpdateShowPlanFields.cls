/***************************************************************************************************
Author           : Yuva
Creation Date    : 12-17-2009
Description      : 
 1.Update the Show plan fields from the Selected showOccurences in visual Source page.
 2. Also this trigger update the showplan fields on showoccurence on insert, update, delete events
***************************************************************************************************/

public class UpdateShowPlanFields
{ 

  public static List<Show_Plan__C> UpdateRevenueAndIncumbent(Opportunity[] opobjNonrelopp,Show_Plan__c objNonRelAccplan) 
  {
  
    List <Show_plan__C> lstAccPlan= new List <Show_plan__C>() ;
 
        if(opobjNonrelopp!=null && opobjNonrelopp.size()>0)
        {
        objNonRelAccplan.Previous_Occurrence_Revenue__C = opobjNonrelopp[0].Amount;
        objNonRelAccplan.Incumbent__c= opobjNonrelopp[0].Prime_Contractor__c;
        lstAccPlan.add(objNonRelAccplan);
        }
        else
        {
        objNonRelAccplan.Previous_Occurrence_Revenue__C = 0;
        objNonRelAccplan.Incumbent__c= null;
        lstAccPlan.add(objNonRelAccplan);  
        }
    
   return lstAccPlan;
   
  }

  public static void UpdatePrpoposalDate(Show_Plan__c objAccPlan,Opportunity[] objoppList) 
  {  
    if(objAccPlan!=null && objoppList!=null )
    {
        objAccPlan.Proposal_Due_Date__c=objoppList[0].RFP_Due_Date__c;    
        //Calculate Total Amount
        Decimal iSum=0;
        if(objoppList.size()>0)  
        {    
            for(integer i=0; i<objoppList.size();i++)
            {
             iSum = iSum + objoppList[i].amount;
            }
            objAccPlan.Total_Plan_revenue__c = iSum ;
            update objAccPlan;
    
        }  
     }
   }

 public static void UpdateDummyAndRevenue(Show_Plan__c[] objAccPlan,Opportunity[] objShowOccurList) 
  {
    if(objAccPlan.size()>0)
    {
        objAccPlan[0].DummyNonRelatedOppID__c = objShowOccurList[0].id;
        objAccPlan[0].Previous_Occurrence_Revenue__C = objShowOccurList[0].Amount;
        objAccPlan[0].Incumbent__c= objShowOccurList[0].Prime_Contractor__c;
        update objAccPlan;
    
    }
       
   }
  public static void UpdateEmptyValues(Show_Plan__c[] objAccPlan) 
  {
if(objAccPlan!=null)
{
    objAccPlan[0].Proposal_Due_Date__c=null;
    objAccPlan[0].Total_Plan_revenue__c=0;
    objAccPlan[0].Previous_Occurrence_Revenue__C =0.0;
    objAccPlan[0].Incumbent__c= null;
    update objAccPlan;
}
   }
  public static void UpdateEmptyValuesToRevenue(Show_Plan__c[] objAccPlan) 
  {
if(objAccPlan!=null)
{
    objAccPlan[0].Previous_Occurrence_Revenue__C =0.0;
    objAccPlan[0].Incumbent__c= null;    
    update objAccPlan;
}

}


}