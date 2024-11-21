//```````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````
//Developer Name => Priyank Saklani (Vertiba)
//Trigger fires on after update or insert and creates orders and shippments from quotes after status of quote is changed to
//'Accepted'
//``````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````
trigger EMEA_Visit_Order_Creation_Trigger on Quote (after update) {
    if (EMEA_VisitOrderCreation.runOnce()) {
        System.debug('Inside EMEA_Visit_Order_Creation_Trigger');
        List<quote> qu = new List<quote>();  //Map<quote.Id,Opp.Id>
        
        /*if (Trigger.isInsert){
System.debug('Inside isInsert');
for(quote q: Trigger.new)
{
List<RecordType> Opp_RecordTypeName= [Select Name from RecordType where Id in (Select RecordTypeId from Opportunity where Id=: q.OpportunityId)];
System.debug('Opp_RecordTypeName==>'+Opp_RecordTypeName);
if(q.Status=='Accepted' && Opp_RecordTypeName[0].Name=='EMEA - Poken and Visit')
{
System.debug('Inside if for insert. Quote added===>'+q);
qu.put(q.Id, q.OpportunityId);
}
}
}*/
        
        if (Trigger.isUpdate){
            System.debug('Inside isUpdate');
            map<Id,quote> Oldqu = Trigger.oldMap;
            for(quote q: Trigger.new)
            {
                string Opp_RecordTypeName= [Select Name from RecordType where Id in (Select RecordTypeId from Opportunity where Id=: q.OpportunityId)].Name;
                String Q_RecordTypeName= [Select Name from RecordType where Id=: q.RecordTypeId].Name;
                System.debug('Opp_RecordTypeName==>'+Opp_RecordTypeName);
                quote Oldq=Oldqu.get(q.Id);
                if(Q_RecordTypeName=='EMEA Visit' && q.Status=='Accepted' &&  Oldq.Status!='Accepted' && Opp_RecordTypeName=='EMEA - Poken and Visit')
                {
                    System.debug('Inside if for update. Quote added===>'+q);
                    qu.add(q);
                }
            }
        }
        System.debug('QU===>'+qu);
        //Sync_Quote.Sync(qu);
        EMEA_VisitOrderCreation.CreateOrder(qu);
    }   
}