//Parse asset data to List <Map<String, object>> for easy access to fields
public class assetParser {
    public Static List <Map<String, object>> parseAsset(map<string,object> results){
        System.debug('Inside assetParser.parseAsset');
        //map<string,object> results=Exhibitor_Integration.getAsset();//get asset in jason format
        map<string,object> communication= new map<string,object>();
        List <Map<String, object>> assets= new List <Map<String, object>>();
        list<object> orders= (list<object>) results.get('orders');
        
        for (object order: orders) {
            map<string,object> assetinfo= new map<string,object>();
            map<string,object> orderResult= (map<string,object>) order;
            //system.debug(orderResult.get('order'));
            map<string,object> asset=(map<string,object>) orderResult.get('order');
            map<string,object> standinfo=(map<string,object>) asset.get('standinfo');
            assetinfo.putAll(standinfo);
            map<string,object> address=new map<string,object>();
            list<object> addressList=(list<object>) asset.get('address');
            for (object addr : addressList){
                address= (map<string,object>)addr;
                if(address.get('source')=='organisation'){
                    //system.debug(address.get('city'));
                    assetinfo.putAll(address);
                }
                
            }
            //system.debug(addressList[0]);
            list<object> communications=(list<object>) asset.get('communications');
            //system.debug(communications);            
            for (object field: communications){
                map<string,object> fields= (map<string,object>) field;
                if(fields.get('source')=='main contact'){
                    communication.put('source',fields.get('source'));
                    communication.put('requester_contact_name',fields.get('requester_contact_name'));
                    communication.put('main_contact_name',fields.get('main_contact_name'));
                    communication.put('forms_contact_name',fields.get('forms_contact_name'));
                    //communication.put('phone','0');
                    //communication.put('fax','');
                    //communication.put('webaddress','');
                }
                
                if(fields.get('source')=='organisation'){
                    object com=fields.get('communication');
                    list<object> comm=(list<object>) com;
                    map<string,object> email=(map<string,object>) comm.get(1);
                    map<string,object> phone=(map<string,object>) comm.get(0);
                    map<string,object> fax=(map<string,object>) comm.get(2);
                    map<string,object> webaddress=(map<string,object>) comm.get(3);        
                    
                    communication.put('email',email.get('text'));
                    communication.put('phone',phone.get('text'));
                    communication.put('fax',fax.get('text'));
                    communication.put('webaddress',webaddress.get('text'));  
                    
                    
                }
                
            }            
            assetinfo.putAll(communication);
            assetinfo.putAll(asset);
            //system.debug(assetinfo.get('county'));
            assets.add(assetinfo);
        }
        /*system.debug(assets[0].get('stand_nbr'));
system.debug(assets[1].get('stand_nbr'));
system.debug(assets[2].get('stand_nbr'));
system.debug(assets[3].get('stand_nbr'));
system.debug(assets[4].get('stand_nbr'));
system.debug(assets[5].get('stand_nbr'));*/
        //System.debug('Exiting assetParser.parseAsset:'+assets[0].get('trg_event_name'));
        //System.debug('assets after parsing====>'+assets);
        return assets;
    } 
}