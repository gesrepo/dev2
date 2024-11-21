public with sharing class ShipmentFulfillment_Controller {
    private ApexPages.StandardController ctrl;
    public List<OrderItem> OrdItems {get;set;}
    public List<ShipmentItem__c> ShipItems {get;set;}
    public String scannedId {get;set;}
    public List<Asset> CheckedOut_Items {get;set;}
    public boolean ShipmentStatus {get;set;}
    
    
    public ShipmentFulfillment_Controller(ApexPages.StandardController controllerParam){
        ctrl = controllerParam;
        get_OrderProducts();
    }
    
    public void get_OrderProducts(){
        Id Ord;
        list<Id> Assets= new List<Id>();
        
        OrdItems=new List<OrderItem>();
        ShipItems=new List<ShipmentItem__c>();
        CheckedOut_Items=new List<Asset> ();
        Shipment__c ship=new Shipment__c();
        try{
            Ord = [Select OrderID__c from Shipment__c where Id=:ctrl.getId() limit 1].OrderID__c; 
        }
        catch(QueryException e)
        {
            System.debug('Error:'+e);
        }
        
        
        OrdItems = [Select Id,Quantity,Product2.Name,Inventory__c,Sendable__c from OrderItem where OrderId=:Ord and sendable__c=True];
        
        system.debug('OrdItemss======>'+OrdItems);
        system.debug('Scanned Id=====>'+scannedId);
        
        try{
            ShipItems = [Select Id,Actual_Return_Date__c,AssetID__c,Check_Out_Date__c,Exhibition__c,Expected_Return_Date__c,Inventory__c,Item_is_Packed__c,OrderID__c,OrderProductID__c,Packing_Status__c,ProductID__c,ProductID__r.Name,Quantity__c,Shipment__c,Weight_Kg__c,Weight_Lb__c from ShipmentItem__c where Shipment__c=:ctrl.getId() and ProductID__r.Inventory__c=true]; 
        }
        catch(QueryException e)
        {
            System.debug('Error:'+e);
        }
        system.debug('ShipItems======>'+ShipItems);
        
        for(ShipmentItem__c ShipItem:ShipItems){
            if(ShipItem.AssetID__c!=Null){
                Assets.add(ShipItem.AssetID__c);
            }
        }
        
        try{
            CheckedOut_Items = [select Id,Name,SerialNumber,Status,Scan_Out_Date__c,ExpectedReturn__c,Description,Product2.Name from Asset where Id IN :Assets]; 
        }
        catch(QueryException e)
        {
            System.debug('Error:'+e);
        }
        
        try{
            ship = [select Id,ShipmentStatus__c from Shipment__c where Id =:ctrl.getId()]; 
        }
        catch(QueryException e)
        {
            System.debug('Error:'+e);
        }
        
        
        if(ship.ShipmentStatus__c=='Complete'){
            ShipmentStatus=True;
        }
        else{
            ShipmentStatus=False;
        }
        
    }
    
    public void SpecialCharacterCheck(){
        system.debug('Inside SpecialCharacterCheck====>');
        //scannedId=Apexpages.currentPage().getParameters().get('valFromVf');
        if(scannedId.contains('?')){
            list<string> y= scannedId.split('\\?');
            linkAssetShipmentItem(y[0]);
            system.debug('scannedId====>'+scannedId);
        }
        
    }
    
    public void AddItem(){
        linkAssetShipmentItem(scannedId);
    }
    
    public void updateShipmentStatus(){
        shipment__c ship= new shipment__c();
        ship.Id= ctrl.getId();
        ship.ShipmentStatus__c='Complete';
        try{
            update(ship);
            system.debug('updated shipment status: '+ship);
        }
        catch(DMLexception e){
            system.debug('Error occured while updating shipment: '+e);
        }
        
        ShipmentStatus=True;
    }
    
    public Void linkAssetShipmentItem(string AssetID){
        //CheckedOut_Items=new List<Asset> ();
        ShipmentItem__c ToUpdateItem =new ShipmentItem__c();
        Asset item=new Asset();
        
        System.debug('Inside linkAssetShipmentItem====>');
        System.debug('AssetID====>'+AssetID);
        
        //if asset not in system
        try{
            item =[select Id,Name,SerialNumber,Status,Scan_Out_Date__c,ExpectedReturn__c,Description,Product2.Name from Asset where SerialNumber=:AssetID limit 1];
        }
        catch(QueryException e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No matching Asset found in system!'));
            system.debug('Asset not found in system!');
            system.debug('Error message: '+e);
        }
        
        System.debug('Asset===>'+item);
        
        //if asset in system
        if(item != NULL && item.Id != NULL) {
            boolean flag=False;
            
            //if asset status !='Available'
            if(item.Status!='Available'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Asset is '+item.Status+'. ==> '+item.Product2.Name+' [Serial Number='+item.SerialNumber+']'));
                system.debug('This Asset is '+item.Status);
            }
            //if asset status =='Available'
            else{
                for(OrderItem items:OrdItems){    
                    //if product is needed
                    if(items.Product2.Name==item.Product2.Name){
                        if(item.Status=='Available'){
                            flag=True;
                            
                        }
                    }
                }
                if(flag==False){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Asset is not needed.==>'+item.Product2.Name+' [Serial Number='+item.SerialNumber+']'));
                    system.debug('This Asset is not needed.');
                }
                else{
                    system.debug('This Asset is '+item.Status+' and needed');
                    system.debug('ShipItems===>'+ShipItems);
                    for(ShipmentItem__c ShipItem:ShipItems){
                        
                        if(ShipItem.AssetID__c==Null && item.Product2.Name==ShipItem.ProductID__r.Name){
                            
                            System.debug('Empty shipment found ShipItem==>'+ShipItem);
                            ToUpdateItem=ShipItem;
                            ToUpdateItem.AssetID__c=item.Id;
                            System.debug('ToUpdateItem==>'+ToUpdateItem);
                            break;
                        }
                    } 
                    
                    if(ToUpdateItem.Id!=Null){
                        try{
                            Update(ToUpdateItem);
                            system.debug('Shipment Item update Successful');
                            system.debug('Shipment Item==>'+ToUpdateItem);
                            
                            
                        }
                        catch(DMLException e){
                            System.debug('Error happend during Shipment Item update===>'+e);
                            
                        }
                        
                        if(item.Id!=Null){
                            try{
                                item.Status='Rented Out';
                                Update(item);
                                system.debug('Shipment Asset update Successful');
                                system.debug('Shipment Asset==>'+item);
                            }
                            catch(DMLException e){
                                System.debug('Error happend during Asset update===>'+e);
                            }
                        }
                        CheckedOut_Items.add(item);
                        System.debug('CheckedOut_Items====>'+CheckedOut_Items);
                        System.debug('ShipItems====>'+ShipItems);
                    }
                    else{
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Asset is not needed.==>'+item.Product2.Name+' [Serial Number='+item.SerialNumber+']'));
                        system.debug('This Asset is not needed.');
                    }
                    
                }
            }
            
            scannedId = '';
            
            if(CheckedOut_Items.size()==ShipItems.size()){
                updateShipmentStatus();
            }
            
        }
    }
}