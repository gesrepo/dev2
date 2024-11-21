/*********************************************************************
    FileName: OpportunityWrapper
    Author:Kumud thakur
    Date    : 25 May 2017    
    Desc    : This class will be used to call from AccountTriggerHandler to update Opportunity in future method.(to avoid CPU Limit )
    =============
    Version          CreatedDate                     LastmodifiedDate           Last Modified by            
    1.0              25-May-2017                      25-May-2017               Kumud Thakur
**********************************************************************/

public class OpportunityWrapper{

    
    public ID oppId;
    public string arCustomerNo;
    public string GBMSId;
    public string arCustomerID;
   
    public OpportunityWrapper(Id oppId,String arCustomerNo,String GBMSId,String arCustomerID){
    
        this.oppId=oppId;
        this.arCustomerNo=arCustomerNo;
        this.GBMSId=GBMSId;
        this.arCustomerID=arCustomerID;
    
    }


}