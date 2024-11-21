/***************************************
Class: EmailMessageTriggerHelper
Description : It is called from trigger "TriggerEmailMessage" to implement business logic.
Created by : Gaurav Kumar on 31st Jan
***************************************/
public class EmailMessageTriggerHelper{

/***********************
Method : inboundEmailMessage
Description : it is used to created new Case when  an inbound
              message came to a closed "GES US Service" Case.
***********************/
    public void inboundEmailMessage(list<EmailMessage> lstNewEM)
    {
        list<Case> lstEMCase = new list<Case>();
        list<Case> lstNewEMCase = new list<Case>();
        map<id,EmailMessage> mapEMIDCaseID = new map<id,EmailMessage>();
        set<id> setCaseID = new set<id>();
        Case objCase;
        for(EmailMessage tempEM : lstNewEM)
        {                       
            if(tempEM != null && (tempEM.Incoming == true && (tempEM.Subject != null && (!tempEM.Subject.contains('autoreply') || 
            !tempEM.Subject.contains('auto reply') || !tempEM.Subject.contains('Auto-Reply'))))) 
            {
                if(tempEM.Parentid != null)
                    setCaseID.add(tempEM.Parentid);
                mapEMIDCaseID.put(tempEM.id,tempEM);
            }
        }
        Id CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CaseRecordType).getRecordTypeId();
        if(!setCaseID.isempty())
        {
            lstEMCase = [select id,casenumber,Accountid,Booth__c,Reason__c,Show_Name__c,Show_Opportunity__c,Customer_Name__c,Contactid,ContactEmail,
            ContactPhone,ContactMobile,Origin,Customer_Type__c,Show_Status__c,GES_Type__c,Resolution__c,Priority,status from Case where status =: 'closed' and
            RecordTypeid =: CaseRecordTypeId and id in : setCaseID];
            if(!lstEMCase.isEmpty())
            {               
                for(Case tempVar : lstEMCase)
                {
                    objCase = new Case();
                    objCase.Accountid = tempVar.Accountid;
                    if(tempVar.Booth__c !=null)
                        objCase.Booth__c = tempVar.Booth__c;
                    objCase.Reason__c = tempVar.Reason__c;
                    objCase.recordtypeid = CaseRecordTypeId;
                    objCase.ownerid = Label.Case_QueueID;
                    objCase.US_Reopened__c= true;
                    if(tempVar.Show_Name__c !=null)
                        objCase.Show_Name__c = tempVar.Show_Name__c;
                    if(tempVar.Show_Opportunity__c !=null)
                        objCase.Show_Opportunity__c = tempVar.Show_Opportunity__c;
                    objCase.Customer_Name__c = tempVar.Customer_Name__c;
                    objCase.Contactid = tempVar.Contactid;
                    objCase.Origin = tempVar.Origin;
                    objCase.Customer_Type__c = tempVar.Customer_Type__c;
                    objCase.Show_Status__c = tempVar.Show_Status__c;
                    objCase.GES_Type__c = tempVar.GES_Type__c;
                    objCase.Resolution__c = tempVar.Resolution__c;
                    objCase.Priority = tempVar.Priority;
                    objCase.status = 'Open';
                    objCase.Parentid = tempVar.id;
                    lstNewEMCase.add(objCase);
                }
                if(!lstNewEMCase.isEmpty())
                {
                    try               
                    {
                        insert lstNewEMCase;
                        system.debug('Inserted cases :'+lstNewEMCase);
                        createEmailMessage(lstNewEMCase,mapEMIDCaseID);
                    }catch(exception e)
                    {
                        system.debug('Please contact system administrator'+e);
                    }
                }
            }
        }   
    }

/***********************
Method : createEmailMessage
Description : it is used to create a new Email Message from the existing inbound email message, when  an inbound
              message came to a closed "GES US Service" Case.
***********************/    
    public void createEmailMessage(list<case> lstCasesNew,map<id,EmailMessage> mapEM)
    {
        EmailMessage temEMObj;
        list<EmailMessage> lstEMNew = new list<EmailMessage>();
        for(Case tempCase : lstCasesNew)
        {
            for(EmailMessage tempEMVar: mapEM.values())
            {
                if(tempEMVar.parentid == tempCase.parentid)
                {
                    temEMObj = new EmailMessage();
                    temEMObj.status = '0';
                    temEMObj.parentid = tempCase.id;                    
                    temEMObj.subject = tempEMVar.subject;
                    temEMObj.BccAddress = tempEMVar.BccAddress;
                    temEMObj.FromAddress = tempEMVar.FromAddress;
                    temEMObj.FromName = tempEMVar.FromName;
                    temEMObj.Incoming = tempEMVar.Incoming;
                    temEMObj.MessageDate = tempEMVar.MessageDate;
                    temEMObj.ToAddress = tempEMVar.ToAddress;
                    temEMObj.TextBody = tempEMVar.TextBody;
                    lstEMNew.add(temEMObj);
                }           
            }
        }
        if(!lstEMNew.isEmpty())
        {
            try{
                insert lstEMNew;
            }catch(Exception e)
            {
                system.debug('Exception details : ' +e);
            }
            
        }
    }
}