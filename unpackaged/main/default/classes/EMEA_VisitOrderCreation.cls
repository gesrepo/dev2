//```````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````
//Developer Name => Priyank Saklani (Vertiba)
//Trigger helper called by "EMEA_Visit_Order_Creation_Trigger" 
//``````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````
public without sharing class EMEA_VisitOrderCreation {
    
    //This piece of code is to make sure trigger only runs once 
    private static Boolean run = true;
    public static Boolean runOnce() {
        if (run) {
            /*if(!Test.isRunningTest()){
                run = false;
            }*/
            run = false;
            return true;
        }
            
        else {
            return run;
        }
    }
    //Code piece ends
    
    //Class to CreateOrder,Order items and shipment items
    public static void CreateOrder(List<Quote> qu){
        System.debug('Inside EMEA_VisitOrderCreation');
        Id OrderRecordTypeId= [SELECT Id FROM RecordType where Name ='EMEA Visit Order' limit 1].Id;
        List<Id> Temp= new List<Id>();
        
        for(Quote q:qu){
            Temp.add(q.Id);      //creating a list of all quoteId's related to quotes for which orders have to be generated 
        }
        
        List<Opportunity> Opptys= new List<Opportunity>();  //to store all Opportunities
        List<Opportunity> Exhibition_Opptys= new List<Opportunity>();  //to store all Exhibition Opportunities
        List<QuoteLineItem> QuoteProducts= new List<QuoteLineItem>(); //to store all QuoteLineItems
        map<Id,Opportunity> Oppts= new Map<Id,Opportunity>(); //Map<Opportunity.Id,Opportunity>
        map<Id,Opportunity> Exhibition= new Map<Id,Opportunity>(); //Map<Opportunity.Show_Occurrence_c,Exhibition Opportunity>
        map<Id,List<QuoteLineItem>> QuProducts= new map<Id,List<QuoteLineItem>>();//map<Opportunity.Id,List<QuoteLineItem>>
        
        //quering all OpportunityLineItem related to all Opportunties
        QuoteProducts=[Select Id,Quantity,Discount,UnitPrice,PricebookEntryId,ListPrice,CurrencyIsoCode,TotalPrice,Description,Product2Id,Quote.Id from QuoteLineItem Where Quote.Id in :Temp];
        
        System.debug('QuoteLineItems ======>'+QuoteProducts);
        
        Temp.clear();
        
        for(Quote q:qu){
            Temp.add(q.OpportunityId);      //creating a list of all quoteId's related to quotes for which orders have to be generated 
        }
        
        
        //quering all Opportunities related to all quotes
        Opptys=[Select Id, AccountId, Pricebook2Id, CloseDate, Order_Generated__c, OwnerId, Amount, CurrencyIsoCode, Show_Occurrence__c from Opportunity Where Id in :Temp];
        System.debug('Opportunity======>'+Opptys);
        Temp.clear();
        
        //querying all Exhibition Opportunity
        for(Opportunity Opp:Opptys){
            Temp.add(Opp.Show_Occurrence__c);
        }
        
        Exhibition_Opptys=[Select Id,Show_Close_Date__c from Opportunity where Id in : Temp];
        
        for(Opportunity Opp:Exhibition_Opptys){
            Exhibition.put(Opp.Id, Opp);
        }
        
        
        //arranging all Opportunties in map<Opportunity.Id,Opportunity>
        Temp.clear();
        for(Opportunity Opp:Opptys){
            Temp.add(Opp.AccountId);
            Oppts.put(Opp.Id, Opp);
        }
        
        
        List<Account> Accs= new List<Account>();
        Map<Id,Account> Accts= new Map<Id,Account>();
        
        //quering all accounts
        Accs=[Select BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry from Account Where Id in :Temp];
        System.debug('Account======>'+Accs);
        
        //arranging all accounts in map<Account.Id,Account>
        for(Account Acc:Accs){
            Accts.put(Acc.Id,Acc);
        }
        
        List<Order> ords= new List<Order>();
        
        //iterate over all quotes 
        for(Quote q:qu){
            if((Oppts.get(q.OpportunityId).Order_Generated__c)!=True){      //if order is not generated for the opportunity
                Order Ord= new Order();
                Ord.Status='New';
                Ord.RecordTypeId=OrderRecordTypeId;
                Ord.Discount__c=q.Discount;
                Ord.Order_Subtotal__c=q.Subtotal;
                Ord.QuoteId=q.Id;
                Ord.AccountId=Accts.get(q.AccountId).Id;
                Ord.BillingCity=Accts.get(q.AccountId).BillingCity;
                Ord.BillingStreet=Accts.get(q.AccountId).BillingStreet;
                Ord.BillingState=Accts.get(q.AccountId).BillingState;
                Ord.BillingPostalCode=Accts.get(q.AccountId).BillingPostalCode;
                Ord.BillingCountry=Accts.get(q.AccountId).BillingCountry;
                Ord.ShippingCity=Accts.get(q.AccountId).ShippingCity;
                Ord.ShippingStreet=Accts.get(q.AccountId).ShippingStreet;
                Ord.ShippingState=Accts.get(q.AccountId).ShippingState;
                Ord.ShippingPostalCode=Accts.get(q.AccountId).ShippingPostalCode;
                Ord.ShippingCountry=Accts.get(q.AccountId).ShippingCountry;
                Ord.CurrencyIsoCode=Oppts.get(q.OpportunityId).CurrencyIsoCode;
                Ord.EffectiveDate=Oppts.get(q.OpportunityId).CloseDate;
                Ord.OpportunityId=Oppts.get(q.OpportunityId).Id;
                Ord.Pricebook2Id=q.Pricebook2Id;
                Ord.OwnerId=Oppts.get(q.OpportunityId).OwnerId;
                Ord.Exhibition__c=Oppts.get(q.OpportunityID).Show_Occurrence__c;
                if(Oppts.get(q.OpportunityID).Show_Occurrence__c != NULL){
                    Date d= Exhibition.get(Oppts.get(q.OpportunityID).Show_Occurrence__c).Show_Close_Date__c;
                    Ord.Expected_Return_Date__c=d.addDays(14);
                }
                
                //Ord.TotalAmount=Oppts.get(q.OpportunityId).Amount;
                
                Ords.add(Ord);                
            } 
        }
        
        if(Ords.size()>0){     //if there are orders to insert
            try{
                Insert Ords;  //creating Orders
                System.debug('Oreders entered:'+Ords);
            }
            catch(DMLexception e){
                System.debug('Exception Happened During Order Insert: '+e);
            }
            
            Opptys.clear();
            
            map<Id,Order> Orders= new map<Id,Order>();//map<OpportunityId,Order>
            map<Id,Order> Orders2= new map<Id,Order>();//map<OrderId,Order>
            
            for(Order Ord:Ords){
                Opportunity opp= new Opportunity();
                Orders.put(Ord.QuoteId, Ord);//arranging orders in map<OpportunityId,Order>
                Orders2.put(Ord.Id, Ord);//arranging orders in map<OrderId,Order>
                Opp.Id=Ord.OpportunityId;
                Opp.Order_Generated__c=True;  //Updating Order Generated field on Opportunity
                Opptys.add(Opp);
            }
            
            if(Opptys.size()>0){
                try{
                    Update Opptys;//Updating Opportunity
                    system.debug('Opportuntiy updated:'+Opptys);
                }
                catch(DMLexception e){
                    System.debug('Exception Happened During Opportunity Update: '+e);
                }
            }
            
            system.debug('Orders====>>>>'+Orders);
            
            //Now process starts for creating Order Line Items
            List<OrderItem> OrderProducts= new List<OrderItem>();
            for(QuoteLineItem QuoteProduct:QuoteProducts){
                OrderItem OrderProduct= new OrderItem();
                OrderProduct.OrderId= Orders.get(QuoteProduct.Quote.Id).Id;
                //OrderProduct.OrderId = '0121h0000004O8vAAE';
                OrderProduct.PricebookEntryId = QuoteProduct.PricebookEntryId;
                OrderProduct.Quantity = QuoteProduct.Quantity;
                OrderProduct.Discount__c = QuoteProduct.Discount;
                if(OrderProduct.Discount__c>0){
                    OrderProduct.UnitPrice = QuoteProduct.UnitPrice-((QuoteProduct.UnitPrice)*(OrderProduct.Discount__c)/100);
                }
                else{
                    OrderProduct.UnitPrice = QuoteProduct.UnitPrice;
                }
                
                //OrderProduct.ListPrice = OpptysProduct.ListPrice;
                //OrderProduct.TotalPrice = OpptysProduct.TotalPrice;
                OrderProduct.Description = QuoteProduct.Description;
                //OrderProduct.CurrencyIsoCode = oOpptysProduct.CurrencyIsoCode;
                
                OrderProducts.add(OrderProduct);        
            }
            if(OrderProducts.size()>0){
                try{
                    Insert OrderProducts;//inserting order line items
                    system.debug('Order Products inserted:'+OrderProducts);
                }
                catch(DMLexception e){
                    System.debug('Exception Happened During Order Product Insert: '+e);
                }
                
                
                Temp.clear();
                
                for(OrderItem OpptysProduct:OrderProducts){
                    Temp.add(OpptysProduct.Id);
                }
                
                OrderProducts.clear();
                
                List<Shipment__c> Shipments =new List<Shipment__c>();
                for (Order ord:Ords){
                    Shipment__c shipment=new shipment__c ();
                    shipment.OrderID__c=Ord.ID;
                    shipment.ExhibitionOpportunity__c=Ord.Exhibition__c;
                    shipment.AccountID__c=Ord.AccountId;
                    shipment.ReturnDate__c=Ord.Expected_Return_Date__c;
                    Shipments.add(shipment);
                }
                
                if(Shipments.size()>0){
                    try{
                        insert Shipments;
                        system.debug('Shipments inserted:'+Shipments);
                    }
                    catch(DMLexception e){
                        System.debug('Insertion of Shipments failed :==>'+e);
                    }
                }
                
                map<Id,Shipment__c> shipment_records=new map<Id,Shipment__c>();
                for(Shipment__c Key:Shipments){
                    shipment_records.put(Key.OrderID__c, Key);
                }
                
                OrderProducts=[Select Id,Quantity,OrderId,Inventory__c,Product2Id,Sendable__c,Counter__c from OrderItem where Id in: Temp];
                
                List<ShipmentItem__c> Items = new List<ShipmentItem__c> ();
                for(OrderItem OpptysProduct:OrderProducts){
                    if(OpptysProduct.sendable__c==True){
                        if(OpptysProduct.inventory__c==True){
                            for(Integer i = 0; i < OpptysProduct.Quantity; i++){
                                ShipmentItem__c Item = new ShipmentItem__c ();
                                Item.OrderProductID__c=OpptysProduct.Id;
                                Item.OrderID__c=OpptysProduct.OrderId;
                                Item.ProductID__c=OpptysProduct.Product2Id;
                                Item.Exhibition__c=Orders2.get(OpptysProduct.OrderId).Exhibition__c;
                                Item.Shipment__c=shipment_records.get(OpptysProduct.OrderId).Id;
                                if(Orders2.get(OpptysProduct.OrderId).Exhibition__c != NULL){
                                    Date d=Exhibition.get(Orders2.get(OpptysProduct.OrderId).Exhibition__c).Show_Close_Date__c;
                                    Item.Expected_Return_Date__c=d.addDays(14);
                                }
                                
                                Item.Quantity__c=1;
                                Items.add(Item);
                            }
                        }
                        else{
                            ShipmentItem__c Item = new ShipmentItem__c ();
                            Item.OrderProductID__c=OpptysProduct.Id;
                            Item.OrderID__c=OpptysProduct.OrderId;
                            Item.ProductID__c=OpptysProduct.Product2Id;
                            Item.Shipment__c=shipment_records.get(OpptysProduct.OrderId).Id;
                            Item.Exhibition__c=Orders2.get(OpptysProduct.OrderId).Exhibition__c;
                            if(Orders2.get(OpptysProduct.OrderId).Exhibition__c != NULL){
                                Date d=Exhibition.get(Orders2.get(OpptysProduct.OrderId).Exhibition__c).Show_Close_Date__c;
                                Item.Expected_Return_Date__c=d.addDays(14);
                            }
                            Item.Quantity__c=OpptysProduct.Quantity;
                            Items.add(Item);
                        }
                    }
                }
                
                if(Items.size()>0){
                    try{
                        Insert Items;//inserting Shipment Items
                        system.debug('ShipmentItem inserted:'+Items);
                    }
                    catch(DMLexception e){
                        System.debug('Exception Happened During Shipment Item Insert: '+e);
                    }
                }
                
            }           
        }        
    }
}