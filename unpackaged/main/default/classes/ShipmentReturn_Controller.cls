public class ShipmentReturn_Controller {
    private ApexPages.StandardController ctrl;
    public String scannedId {get;set;}
    public Boolean DisplayDetails {get;set;}
    public Shipment__c Ship {get;set;}
    public List<OrderItem> OrdItems {get;set;}
    public List<ShipmentItem__c> ShipmentItems= new List<ShipmentItem__c>();
    public List<ShipmentItem__c> CheckedIn_Items {get;set;}
    
    public ShipmentReturn_Controller(ApexPages.StandardController controllerParam){
        ctrl = controllerParam;
        DisplayDetails = False;
        
        
    }
    
    public void SpecialCharacterCheck(){
        system.debug('Inside SpecialCharacterCheck====>');
        //scannedId=Apexpages.currentPage().getParameters().get('valFromVf');
        if(scannedId.contains('?')){
            list<string> y= scannedId.split('\\?');
            CheckinAsset(y[0]);
            system.debug('scannedId====>'+scannedId);
        }
        
    }
    
    public void CheckinItem(){
        system.debug('scannedId====>'+scannedId);
        CheckinAsset(scannedId);
    }
    
    public Void CheckinAsset(string AssetID){
        
        Asset AssetItem= new Asset(); //checked in Asset info
        ShipmentItem__c ShipItem= new ShipmentItem__c(); //Shipment Item linked to Asset
        CheckedIn_Items= new List<ShipmentItem__c>(); 
        system.debug('<==Inside CheckinAsset==>');
        system.debug('scannedId====>'+scannedId);
        
        //query asset info using serial number
        try{
            AssetItem =[select Id,Name,SerialNumber,Status,Scan_Out_Date__c,ExpectedReturn__c,Description,Product2.Name from Asset where SerialNumber=:AssetID And Status='Rented Out' limit 1];
        }
        catch(exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No matching Rented Asset found in system!'));
        }
        
        Id itemId=AssetItem.Id;
        
        if(itemId!=Null){ // if asset is found
            System.debug('Asset Found ===>'+AssetItem);
            DisplayDetails=False;
            DisplayDetails=True;
            
            System.debug('Display Details==>'+DisplayDetails);
            try{
                //query shipment Item linked to asset
                ShipItem= [Select Id,Actual_Return_Date__c,AssetID__c,Check_Out_Date__c,Exhibition__c,Expected_Return_Date__c,Inventory__c,Item_is_Packed__c,OrderID__c,OrderProductID__c,Packing_Status__c,ProductID__c,ProductID__r.Name,Quantity__c,Shipment__c,Weight_Kg__c,Weight_Lb__c from ShipmentItem__c where AssetID__c=:itemId and Actual_Return_Date__c= null];
            }
            catch(exception e){
                System.debug('Error:'+e);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unknown Shipment!'));
            }
            
            try{
                ShipItem.Actual_Return_Date__c= date.today();
                update(ShipItem);
            }
            catch(exception e){
                System.debug('Error:'+e);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in update'));
            }
            
            System.debug('Shipment Item Found===>'+ShipItem);
            Id shipmentId=ShipItem.Shipment__c;
            Id OrdId;
            
            if(shipmentId!=null){
                
                try{
                    //query shipment info using shipment Id
                    Ship = [Select Id,ExhibitionOpportunity__c,ShippingDate__c,AccountID__c,OrderID__c,ShowName__c,ReturnDate__c from Shipment__c where Id=:shipmentId limit 1]; 
                }
                catch(QueryException e)
                {
                    System.debug('Error:'+e);
                }
                
                try{
                    //query Order info using shipment Id
                    OrdId = [Select OrderID__c from Shipment__c where Id=:shipmentId limit 1].OrderID__c; 
                }
                catch(QueryException e)
                {
                    System.debug('Error:'+e);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unknown Order!'));
                }
                
                if ( OrdId != null ){
                    System.debug('Order Found===>'+OrdId);
                    OrdItems=new List<OrderItem>();
                    
                    try{
                        //query order Items using order id
                        OrdItems = [Select Id,Quantity,Product2.Name,Inventory__c,Sendable__c from OrderItem where OrderId=:OrdId and Sendable__c=True and Inventory__c=True];
                    }
                    catch(QueryException e){
                        System.debug('Error:'+e);
                    }
                    
                    
                    system.debug('OrdItems======>'+OrdItems);
                    system.debug('Scanned Id=====>'+scannedId);
                    system.debug('Ship Id=====>'+shipmentId);
                    
                    //query all returnable shipment Items
                    ShipmentItems=[Select Id,Actual_Return_Date__c,AssetID__c,Check_Out_Date__c,Exhibition__c,Expected_Return_Date__c,Inventory__c,Item_is_Packed__c,OrderID__c,OrderProductID__c,Packing_Status__c,ProductID__c,ProductID__r.Name,Quantity__c,Shipment__c,Weight_Kg__c,Weight_Lb__c,AssetId__r.Name,AssetId__r.SerialNumber from ShipmentItem__c where Shipment__c=:shipmentId and ProductID__r.Inventory__c=true and ProductID__r.Sendable__c=true]; 
                    
                    System.debug('ShipmentItems====>'+ShipmentItems);
                    
                    for(ShipmentItem__c Item:ShipmentItems){
                        if(Item.Actual_Return_Date__c!=Null){ //check if shipment is returned
                            System.debug('returned Item====>'+Item);
                            CheckedIn_Items.add(Item);
                        }
                    }
                    
                    System.debug('CheckedIn_Items====>'+CheckedIn_Items);
                    
                }
                
            }
            
            
        }
        
        
    }
}