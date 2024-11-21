public without sharing class  CA_RecordBannerApexController {
    
    @AuraEnabled
    public static CA_BannerSettings getBannerSettings(string recId){
        CA_BannerSettings settingsObj= new CA_BannerSettings();
        User currentUser = [select id,Name,profile.name,IsPortalEnabled FROM User Where id =: userInfo.getUserId()];
        String profileName=currentUser.profile.name;
        If (Test.isRunningTest()){profileName='GC BMS Profile';}
        String objectName = (String)  Id.valueOf(recId).getSObjectType().getDescribe().getName();
        CA_Personalized_Object_Setting__c perObjSet=CA_ApexUtils.getHomeTableSettings(profileName, objectName, false);
        settingsObj.objLabel = perObjSet.Object_Label__c;
        settingsObj.objApiName = objectName;
        List<sobject> objectRecord = Database.query('SELECT Id,Name,Name_Auto__c FROM ' + objectName + ' WHERE Id=' + '\'' + recId + + '\'');
        settingsObj.objectRecord = (objectRecord[0]);
        CA_Personalized_Object_Setting__c mainObjSet = CA_ApexUtils.getHomeTableSettings(profileName, 'CA_Main_Event__c', false);
        settingsObj.buttonStyle = mainObjSet.Global_Button_Style__c;
        return settingsObj;
    }
    
    @AuraEnabled
    public static void deleteRecord(string recId){
        try{
            String objectName = (String)  Id.valueOf(recId).getSObjectType().getDescribe().getName();
            List<sobject> objectRecord = Database.query('SELECT Id,Name FROM ' + objectName + ' WHERE Id=' + '\'' + recId + + '\'');
            database.delete(objectRecord);
        }catch(exception e){
            system.debug('erro==='+e.getMessage());
            throw new AuraHandledException(e.getMessage()); 
        }

    }
    
    @AuraEnabled
    public static string getParntObjName(string recId){
        try{
            CA_Product__c tempRec=[SELECT id,name, Exhibit__c,Sponsorship__c,Speaking_Engagement__c,Meeting_Room__c,Meeting_Planning__c,CA_Event__c FROM CA_Product__c WHERE id=:recId];
            system.debug('tempRec==='+tempRec);
            if(tempRec.Exhibit__c!=null){
                return 'Exhibit__c';
            }
            if(tempRec.Sponsorship__c!=null){
                return 'Sponsorship__c';
            }
            if(tempRec.Speaking_Engagement__c!=null){
                return 'Speaking_Engagement__c';
            }
            if(tempRec.Meeting_Room__c!=null){
                return 'Meeting_Room__c';
            }
            if(tempRec.Meeting_Planning__c!=null){
                return 'Meeting_Planning__c';
            }
            if(tempRec.CA_Event__c!=null){
                return 'CA_Event__c';
            }

            return 'Exhibit__c';
        }catch(exception e){
            return e.getMessage();
        }
    }
    
    // added on 26th Feb, 2020 by rsinha for Cloning
    @AuraEnabled
    public static string cloneRecordWithChilds(string recId, string eventId, string activityId){
        //try{
            string mainEventQuery='SELECT ';

            Map<string,List<CA_Product__c>> activityToProducts = new Map<string,List<CA_Product__c>>();
            List<CA_Product__c> clonedProducts= new List<CA_Product__c>();      
            
            String objectName = (String)  Id.valueOf(recId).getSObjectType().getDescribe().getName(); 
            if(objectName.equalsIgnoreCase('CA_Main_Event__c')){
                mainEventQuery+=CA_ApexUtils.getAllFields(objectName);
                mainEventQuery+=' FROM '+objectName+' WHERE id=: recId';            
                
                List<CA_Main_Event__c> mainEventRecords = Database.query(mainEventQuery);
                //clone(Boolean preserveId, Boolean isDeepClone, Boolean preserveReadonlyTimestamps, Boolean preserveAutonumber)
                CA_Main_Event__c clonedMainEvent=mainEventRecords.get(0).clone(false,true,false,false);
                clonedMainEvent.External_UID__c='CAE'+string.valueof(DateTime.now()).remove('-').remove(':').remove(' ');
                CA_Main_Event__c tempRef= new CA_Main_Event__c(External_UID__c=clonedMainEvent.External_UID__c);
                
                insert clonedMainEvent;             
                system.debug(clonedMainEvent.id);
                
                CA_ActivityCloneResult activityCloneResult1= new CA_ActivityCloneResult();
                activityCloneResult1=cloneExhibit(recId, clonedMainEvent.id, true, false);
                if(activityCloneResult1.clonedProducts.size()>0){
                    clonedProducts.addAll(activityCloneResult1.clonedProducts);
                }
                
                CA_ActivityCloneResult activityCloneResult2= new CA_ActivityCloneResult();
                activityCloneResult2=cloneEvent(recId, clonedMainEvent.id, true, false);
                if(activityCloneResult2.clonedProducts.size()>0){
                    clonedProducts.addAll(activityCloneResult2.clonedProducts);
                }
                
                CA_ActivityCloneResult activityCloneResult3= new CA_ActivityCloneResult();
                activityCloneResult3=cloneMPL(recId, clonedMainEvent.id, true, false);
                if(activityCloneResult3.clonedProducts.size()>0){
                    clonedProducts.addAll(activityCloneResult3.clonedProducts);
                }
                
                CA_ActivityCloneResult activityCloneResult4= new CA_ActivityCloneResult();
                activityCloneResult4=cloneMRM(recId, clonedMainEvent.id, true, false);
                if(activityCloneResult4.clonedProducts.size()>0){
                    clonedProducts.addAll(activityCloneResult4.clonedProducts);
                }
                
                CA_ActivityCloneResult activityCloneResult5= new CA_ActivityCloneResult();
                activityCloneResult5=cloneMSS(recId, clonedMainEvent.id, true, false);
                if(activityCloneResult5.clonedProducts.size()>0){
                    clonedProducts.addAll(activityCloneResult5.clonedProducts);
                }
                
                CA_ActivityCloneResult activityCloneResult6= new CA_ActivityCloneResult();
                activityCloneResult6=cloneSPE(recId, clonedMainEvent.id, true, false);
                if(activityCloneResult6.clonedProducts.size()>0){
                    clonedProducts.addAll(activityCloneResult6.clonedProducts);
                }

                CA_ActivityCloneResult activityCloneResult7= new CA_ActivityCloneResult();
                activityCloneResult7=cloneSPS(recId, clonedMainEvent.id, true, false);
                if(activityCloneResult7.clonedProducts.size()>0){
                    clonedProducts.addAll(activityCloneResult7.clonedProducts);
                }
                
                if(clonedProducts.size()>0){
                    insert clonedProducts;
                }
                return clonedMainEvent.id;
            }else if(objectName.equalsIgnoreCase('CA_Exhibit__c')){
                CA_ActivityCloneResult exResult= cloneExhibit(recId, '', true, true);
                return exResult.clonedActivityId;
            }else if(objectName.equalsIgnoreCase('CA_Event__c')){
                CA_ActivityCloneResult evtResult= cloneEvent(recId, '', true, true);
                return evtResult.clonedActivityId;
            }else if(objectName.equalsIgnoreCase('CA_Meeting_Planning__c')){
                CA_ActivityCloneResult evtResult= cloneMPL(recId, '', true, true);
                return evtResult.clonedActivityId;
            }else if(objectName.equalsIgnoreCase('CA_Meeting_Room__c')){
                CA_ActivityCloneResult evtResult= cloneMRM(recId, '', true, true);
                return evtResult.clonedActivityId;
            }else if(objectName.equalsIgnoreCase('CA_Speaking_Engagement__c')){
                CA_ActivityCloneResult evtResult= cloneSPE(recId, '', true, true);
                return evtResult.clonedActivityId;
            }else if(objectName.equalsIgnoreCase('CA_Sponsorship__c')){
                CA_ActivityCloneResult evtResult= cloneSPS(recId, '', true, true);
                return evtResult.clonedActivityId;
            }else if(objectName.equalsIgnoreCase('CA_Membership__c')){
                CA_ActivityCloneResult evtResult= cloneMSS(recId, '', true, true);
                return evtResult.clonedActivityId;
            }else if(objectName.equalsIgnoreCase('CA_Product__c')){
                string productQuery='SELECT ';
                productQuery+=CA_ApexUtils.getAllFields('CA_Product__c');
                productQuery+=' FROM CA_Product__c WHERE Event__c=:recId OR id=:recId';
                List<CA_Product__c> existingRec= Database.query(productQuery);
                CA_Product__c clonedProd1= existingRec.get(0).clone(false,true,false,false);
                insert clonedProd1;
                return clonedProd1.id;
            }else{
                
            }
            return 'success';
    }
    
    @AuraEnabled
    public static string cloneProduct(string recId, string eventId, string activityId){
        return null;
    }
    
    @AuraEnabled
    public static CA_ActivityCloneResult cloneExhibit(string recId, string eventId, boolean cloneProducts, boolean activityClone){
        CA_ActivityCloneResult activityCloneResult= new CA_ActivityCloneResult();
        Map<string,List<CA_Product__c>> activityToProducts = new Map<string,List<CA_Product__c>>();
        List<CA_Product__c> clonedProducts= new List<CA_Product__c>();
        //getting Exhibits
        string exhibitQuery='SELECT ';
        exhibitQuery+=CA_ApexUtils.getAllFields('CA_Exhibit__c');
        exhibitQuery+=',(SELECT ';
        exhibitQuery+=CA_ApexUtils.getAllFields('CA_Product__c');
        exhibitQuery+=' FROM CA_Products__r)';
        exhibitQuery+=' FROM CA_Exhibit__c WHERE Event__c=:recId OR id=:recId';
        
        List<CA_Exhibit__c> clonedExhibits= new List<CA_Exhibit__c>();      
        integer n1=0;
        
        for(CA_Exhibit__c singleExhibit:Database.query(exhibitQuery)){
            CA_Exhibit__c clonedExhibit= singleExhibit.clone(false,true,false,false);
            clonedExhibit.External_UID__c='EXH'+string.valueof(n1)+string.valueof(DateTime.now()).remove('-').remove(':').remove(' ');
            if(string.isNotBlank(eventId)){
                clonedExhibit.Event__c=eventId;
            }else{
                eventId=clonedExhibit.Event__c;
            }
            clonedExhibits.add(clonedExhibit);
            CA_Exhibit__c tempEx= new CA_Exhibit__c(External_UID__c=clonedExhibit.External_UID__c);
            n1+=1;
            if(cloneProducts){
                for(CA_Product__c singleProduct:singleExhibit.CA_Products__r){
                    CA_Product__c clonedProduct=singleProduct.clone(false,true,false,false);
                    clonedProduct.Event__c=eventId;
                    if(!activityToProducts.containsKey(clonedExhibit.External_UID__c)){
                        activityToProducts.put(clonedExhibit.External_UID__c, new List<CA_Product__c>());
                    }
                    activityToProducts.get(clonedExhibit.External_UID__c).add(clonedProduct);
                }
            }
        }
        if(clonedExhibits.size()>0){                    
            insert clonedExhibits;
            activityCloneResult.clonedActivityId=clonedExhibits.get(0).id;
        }
        if(cloneProducts){
            //getting Activity values for Product relationships
            for(CA_Exhibit__c ex: clonedExhibits){
                for(string key:activityToProducts.keySet()){
                    if(ex.External_UID__c==key){
                        for(CA_Product__c prod:activityToProducts.get(key)){
                            prod.Exhibit__c=ex.id;
                            clonedProducts.add(prod);
                        }
                        
                    }
                }
                
            }
        }
        if(activityClone && clonedProducts.size()>0){
            insert clonedProducts;
            activityCloneResult.clonedActivityId=clonedProducts.get(0).exhibit__c;
        }
        activityCloneResult.clonedProducts=clonedProducts;
        return activityCloneResult;
    }
    
    @AuraEnabled
    public static CA_ActivityCloneResult cloneEvent(string recId, string eventId, boolean cloneProducts, boolean activityClone){
        CA_ActivityCloneResult activityCloneResult= new CA_ActivityCloneResult();
        Map<string,List<CA_Product__c>> activityToProducts = new Map<string,List<CA_Product__c>>();
        List<CA_Product__c> clonedProducts= new List<CA_Product__c>();
        //getting Exhibits
        string activityQuery='SELECT ';
        activityQuery+=CA_ApexUtils.getAllFields('CA_Event__c');
        activityQuery+=',(SELECT ';
        activityQuery+=CA_ApexUtils.getAllFields('CA_Product__c');
        activityQuery+=' FROM CA_Products__r)';
        activityQuery+=' FROM CA_Event__c WHERE Event__c=:recId OR id=:recId';
        
        List<CA_Event__c> clonedActivities= new List<CA_Event__c>();        
        integer n1=0;
        
        for(CA_Event__c singleActivity:Database.query(activityQuery)){
            CA_Event__c clonedActivity= singleActivity.clone(false,true,false,false);
            clonedActivity.External_UID__c='EVT'+string.valueof(n1)+string.valueof(DateTime.now()).remove('-').remove(':').remove(' ');
            if(string.isNotBlank(eventId)){
                clonedActivity.Event__c=eventId;
            }else{
                eventId=clonedActivity.Event__c;
            }
            
            clonedActivities.add(clonedActivity);
            n1+=1;
            if(cloneProducts){
                for(CA_Product__c singleProduct:singleActivity.CA_Products__r){
                    CA_Product__c clonedProduct=singleProduct.clone(false,true,false,false);
                    clonedProduct.Event__c=eventId;
                    if(!activityToProducts.containsKey(clonedActivity.External_UID__c)){
                        activityToProducts.put(clonedActivity.External_UID__c, new List<CA_Product__c>());
                    }
                    activityToProducts.get(clonedActivity.External_UID__c).add(clonedProduct);
                }
            }
        }
        if(clonedActivities.size()>0){                  
            insert clonedActivities;
            activityCloneResult.clonedActivityId=clonedActivities.get(0).id;
        }
        if(cloneProducts){
            //getting Activity values for Product relationships
            for(CA_Event__c ex: clonedActivities){
                for(string key:activityToProducts.keySet()){
                    if(ex.External_UID__c==key){
                        for(CA_Product__c prod:activityToProducts.get(key)){
                            prod.CA_Event__c=ex.id;
                            clonedProducts.add(prod);
                        }
                        
                    }
                }               
            }
        }
        if(activityClone && clonedProducts.size()>0){
            insert clonedProducts;
            activityCloneResult.clonedActivityId=clonedProducts.get(0).CA_Event__c;
        }
        activityCloneResult.clonedProducts=clonedProducts;
        return activityCloneResult;
    }
    
        @AuraEnabled
    public static CA_ActivityCloneResult cloneMPL(string recId, string eventId, boolean cloneProducts, boolean activityClone){
        CA_ActivityCloneResult activityCloneResult= new CA_ActivityCloneResult();
        Map<string,List<CA_Product__c>> activityToProducts = new Map<string,List<CA_Product__c>>();
        List<CA_Product__c> clonedProducts= new List<CA_Product__c>();
        //getting Exhibits
        string activityQuery='SELECT ';
        activityQuery+=CA_ApexUtils.getAllFields('CA_Meeting_Planning__c');
        activityQuery+=',(SELECT ';
        activityQuery+=CA_ApexUtils.getAllFields('CA_Product__c');
        activityQuery+=' FROM CA_Products__r)';
        activityQuery+=' FROM CA_Meeting_Planning__c WHERE Event__c=:recId OR id=:recId';
        
        List<CA_Meeting_Planning__c> clonedActivities= new List<CA_Meeting_Planning__c>();      
        integer n1=0;
        
        for(CA_Meeting_Planning__c singleActivity:Database.query(activityQuery)){
            CA_Meeting_Planning__c clonedActivity= singleActivity.clone(false,true,false,false);
            clonedActivity.External_UID__c='MPL'+string.valueof(n1)+string.valueof(DateTime.now()).remove('-').remove(':').remove(' ');
            if(string.isNotBlank(eventId)){
                clonedActivity.Event__c=eventId;
            }else{
                eventId=clonedActivity.Event__c;
            }
            
            clonedActivities.add(clonedActivity);
            n1+=1;
            if(cloneProducts){
                for(CA_Product__c singleProduct:singleActivity.CA_Products__r){
                    CA_Product__c clonedProduct=singleProduct.clone(false,true,false,false);
                    clonedProduct.Event__c=eventId;
                    if(!activityToProducts.containsKey(clonedActivity.External_UID__c)){
                        activityToProducts.put(clonedActivity.External_UID__c, new List<CA_Product__c>());
                    }
                    activityToProducts.get(clonedActivity.External_UID__c).add(clonedProduct);
                }
            }
        }
        if(clonedActivities.size()>0){                  
            insert clonedActivities;
            activityCloneResult.clonedActivityId=clonedActivities.get(0).id;
        }
        if(cloneProducts){
            //getting Activity values for Product relationships
            for(CA_Meeting_Planning__c ex: clonedActivities){
                for(string key:activityToProducts.keySet()){
                    if(ex.External_UID__c==key){
                        for(CA_Product__c prod:activityToProducts.get(key)){
                            prod.Meeting_Planning__c=ex.id;
                            clonedProducts.add(prod);
                        }
                        
                    }
                }               
            }
        }
        if(activityClone && clonedProducts.size()>0){
            insert clonedProducts;
            activityCloneResult.clonedActivityId=clonedProducts.get(0).Meeting_Planning__c;
        }
        activityCloneResult.clonedProducts=clonedProducts;
        return activityCloneResult;
    }
    
    
        @AuraEnabled
    public static CA_ActivityCloneResult cloneMRM(string recId, string eventId, boolean cloneProducts, boolean activityClone){
        CA_ActivityCloneResult activityCloneResult= new CA_ActivityCloneResult();
        Map<string,List<CA_Product__c>> activityToProducts = new Map<string,List<CA_Product__c>>();
        List<CA_Product__c> clonedProducts= new List<CA_Product__c>();
        //getting Exhibits
        string activityQuery='SELECT ';
        activityQuery+=CA_ApexUtils.getAllFields('CA_Meeting_Room__c');
        activityQuery+=',(SELECT ';
        activityQuery+=CA_ApexUtils.getAllFields('CA_Product__c');
        activityQuery+=' FROM CA_Products__r)';
        activityQuery+=' FROM CA_Meeting_Room__c WHERE Event__c=:recId OR id=:recId';
        
        List<CA_Meeting_Room__c> clonedActivities= new List<CA_Meeting_Room__c>();      
        integer n1=0;
        
        for(CA_Meeting_Room__c singleActivity:Database.query(activityQuery)){
            CA_Meeting_Room__c clonedActivity= singleActivity.clone(false,true,false,false);
            clonedActivity.External_UID__c='MRM'+string.valueof(n1)+string.valueof(DateTime.now()).remove('-').remove(':').remove(' ');
            if(string.isNotBlank(eventId)){
                clonedActivity.Event__c=eventId;
            }else{
                eventId=clonedActivity.Event__c;
            }
            
            clonedActivities.add(clonedActivity);
            n1+=1;
            if(cloneProducts){
                for(CA_Product__c singleProduct:singleActivity.CA_Products__r){
                    CA_Product__c clonedProduct=singleProduct.clone(false,true,false,false);
                    clonedProduct.Event__c=eventId;
                    if(!activityToProducts.containsKey(clonedActivity.External_UID__c)){
                        activityToProducts.put(clonedActivity.External_UID__c, new List<CA_Product__c>());
                    }
                    activityToProducts.get(clonedActivity.External_UID__c).add(clonedProduct);
                }
            }
        }
        if(clonedActivities.size()>0){                  
            insert clonedActivities;
            activityCloneResult.clonedActivityId=clonedActivities.get(0).id;
        }
        if(cloneProducts){
            //getting Activity values for Product relationships
            for(CA_Meeting_Room__c ex: clonedActivities){
                for(string key:activityToProducts.keySet()){
                    if(ex.External_UID__c==key){
                        for(CA_Product__c prod:activityToProducts.get(key)){
                            prod.Meeting_Room__c=ex.id;
                            clonedProducts.add(prod);
                        }
                        
                    }
                }               
            }
        }
        if(activityClone && clonedProducts.size()>0){
            insert clonedProducts;
            activityCloneResult.clonedActivityId=clonedProducts.get(0).Meeting_Room__c;
        }
        activityCloneResult.clonedProducts=clonedProducts;
        return activityCloneResult;
    }
    
        @AuraEnabled
    public static CA_ActivityCloneResult cloneMSS(string recId, string eventId, boolean cloneProducts, boolean activityClone){
        CA_ActivityCloneResult activityCloneResult= new CA_ActivityCloneResult();
        Map<string,List<CA_Product__c>> activityToProducts = new Map<string,List<CA_Product__c>>();
        List<CA_Product__c> clonedProducts= new List<CA_Product__c>();
        //getting Exhibits
        string activityQuery='SELECT ';
        activityQuery+=CA_ApexUtils.getAllFields('CA_Membership__c');
        activityQuery+=',(SELECT ';
        activityQuery+=CA_ApexUtils.getAllFields('CA_Product__c');
        activityQuery+=' FROM CA_Products__r)';
        activityQuery+=' FROM CA_Membership__c WHERE Event__c=:recId OR id=:recId';
        
        List<CA_Membership__c> clonedActivities= new List<CA_Membership__c>();      
        integer n1=0;
        
        for(CA_Membership__c singleActivity:Database.query(activityQuery)){
            CA_Membership__c clonedActivity= singleActivity.clone(false,true,false,false);
            clonedActivity.External_UID__c='MSS'+string.valueof(n1)+string.valueof(DateTime.now()).remove('-').remove(':').remove(' ');
            if(string.isNotBlank(eventId)){
                clonedActivity.Event__c=eventId;
            }else{
                eventId=clonedActivity.Event__c;
            }
            
            clonedActivities.add(clonedActivity);
            n1+=1;
            if(cloneProducts){
                for(CA_Product__c singleProduct:singleActivity.CA_Products__r){
                    CA_Product__c clonedProduct=singleProduct.clone(false,true,false,false);
                    clonedProduct.Event__c=eventId;
                    if(!activityToProducts.containsKey(clonedActivity.External_UID__c)){
                        activityToProducts.put(clonedActivity.External_UID__c, new List<CA_Product__c>());
                    }
                    activityToProducts.get(clonedActivity.External_UID__c).add(clonedProduct);
                }
            }
        }
        if(clonedActivities.size()>0){                  
            insert clonedActivities;
            activityCloneResult.clonedActivityId=clonedActivities.get(0).id;
        }
        if(cloneProducts){
            //getting Activity values for Product relationships
            for(CA_Membership__c ex: clonedActivities){
                for(string key:activityToProducts.keySet()){
                    if(ex.External_UID__c==key){
                        for(CA_Product__c prod:activityToProducts.get(key)){
                            prod.Membership__c=ex.id;
                            clonedProducts.add(prod);
                        }
                        
                    }
                }               
            }
        }
        if(activityClone && clonedProducts.size()>0){
            insert clonedProducts;
            activityCloneResult.clonedActivityId=clonedProducts.get(0).Membership__c;
        }
        activityCloneResult.clonedProducts=clonedProducts;
        return activityCloneResult;
    }
    
        @AuraEnabled
    public static CA_ActivityCloneResult cloneSPE(string recId, string eventId, boolean cloneProducts, boolean activityClone){
        CA_ActivityCloneResult activityCloneResult= new CA_ActivityCloneResult();
        Map<string,List<CA_Product__c>> activityToProducts = new Map<string,List<CA_Product__c>>();
        List<CA_Product__c> clonedProducts= new List<CA_Product__c>();
        //getting Exhibits
        string activityQuery='SELECT ';
        activityQuery+=CA_ApexUtils.getAllFields('CA_Speaking_Engagement__c');
        activityQuery+=',(SELECT ';
        activityQuery+=CA_ApexUtils.getAllFields('CA_Product__c');
        activityQuery+=' FROM CA_Products__r)';
        activityQuery+=' FROM CA_Speaking_Engagement__c WHERE Event__c=:recId OR id=:recId';
        
        List<CA_Speaking_Engagement__c> clonedActivities= new List<CA_Speaking_Engagement__c>();        
        integer n1=0;
        
        for(CA_Speaking_Engagement__c singleActivity:Database.query(activityQuery)){
            CA_Speaking_Engagement__c clonedActivity= singleActivity.clone(false,true,false,false);
            clonedActivity.External_UID__c='SPE'+string.valueof(n1)+string.valueof(DateTime.now()).remove('-').remove(':').remove(' ');
            if(string.isNotBlank(eventId)){
                clonedActivity.Event__c=eventId;
            }else{
                eventId=clonedActivity.Event__c;
            }
            
            clonedActivities.add(clonedActivity);
            n1+=1;
            if(cloneProducts){
                for(CA_Product__c singleProduct:singleActivity.CA_Products__r){
                    CA_Product__c clonedProduct=singleProduct.clone(false,true,false,false);
                    clonedProduct.Event__c=eventId;
                    if(!activityToProducts.containsKey(clonedActivity.External_UID__c)){
                        activityToProducts.put(clonedActivity.External_UID__c, new List<CA_Product__c>());
                    }
                    activityToProducts.get(clonedActivity.External_UID__c).add(clonedProduct);
                }
            }
        }
        if(clonedActivities.size()>0){                  
            insert clonedActivities;
            activityCloneResult.clonedActivityId=clonedActivities.get(0).id;
        }
        if(cloneProducts){
            //getting Activity values for Product relationships
            for(CA_Speaking_Engagement__c ex: clonedActivities){
                for(string key:activityToProducts.keySet()){
                    if(ex.External_UID__c==key){
                        for(CA_Product__c prod:activityToProducts.get(key)){
                            prod.Speaking_Engagement__c=ex.id;
                            clonedProducts.add(prod);
                        }
                        
                    }
                }               
            }
        }
        if(activityClone && clonedProducts.size()>0){
            insert clonedProducts;
            activityCloneResult.clonedActivityId=clonedProducts.get(0).Speaking_Engagement__c;
        }
        activityCloneResult.clonedProducts=clonedProducts;
        return activityCloneResult;
    }
    
    @AuraEnabled
    public static CA_ActivityCloneResult cloneSPS(string recId, string eventId, boolean cloneProducts, boolean activityClone){
        CA_ActivityCloneResult activityCloneResult= new CA_ActivityCloneResult();
        Map<string,List<CA_Product__c>> activityToProducts = new Map<string,List<CA_Product__c>>();
        List<CA_Product__c> clonedProducts= new List<CA_Product__c>();
        //getting Exhibits
        string activityQuery='SELECT ';
        activityQuery+=CA_ApexUtils.getAllFields('CA_Sponsorship__c');
        activityQuery+=',(SELECT ';
        activityQuery+=CA_ApexUtils.getAllFields('CA_Product__c');
        activityQuery+=' FROM CA_Products__r)';
        activityQuery+=' FROM CA_Sponsorship__c WHERE Event__c=:recId OR id=:recId';
        
        List<CA_Sponsorship__c> clonedActivities= new List<CA_Sponsorship__c>();        
        integer n1=0;
        
        for(CA_Sponsorship__c singleActivity:Database.query(activityQuery)){
            CA_Sponsorship__c clonedActivity= singleActivity.clone(false,true,false,false);
            clonedActivity.External_UID__c='SPS'+string.valueof(n1)+string.valueof(DateTime.now()).remove('-').remove(':').remove(' ');
            if(string.isNotBlank(eventId)){
                clonedActivity.Event__c=eventId;
            }else{
                eventId=clonedActivity.Event__c;
            }
            
            clonedActivities.add(clonedActivity);
            n1+=1;
            if(cloneProducts){
                for(CA_Product__c singleProduct:singleActivity.CA_Products__r){
                    CA_Product__c clonedProduct=singleProduct.clone(false,true,false,false);
                    clonedProduct.Event__c=eventId;
                    if(!activityToProducts.containsKey(clonedActivity.External_UID__c)){
                        activityToProducts.put(clonedActivity.External_UID__c, new List<CA_Product__c>());
                    }
                    activityToProducts.get(clonedActivity.External_UID__c).add(clonedProduct);
                }
            }
        }
        if(clonedActivities.size()>0){                  
            insert clonedActivities;
            activityCloneResult.clonedActivityId=clonedActivities.get(0).id;
        }
        if(cloneProducts){
            //getting Activity values for Product relationships
            for(CA_Sponsorship__c ex: clonedActivities){
                for(string key:activityToProducts.keySet()){
                    if(ex.External_UID__c==key){
                        for(CA_Product__c prod:activityToProducts.get(key)){
                            prod.Sponsorship__c=ex.id;
                            clonedProducts.add(prod);
                        }
                        
                    }
                }               
            }
        }
        if(activityClone && clonedProducts.size()>0){
            insert clonedProducts;
            activityCloneResult.clonedActivityId=clonedProducts.get(0).Sponsorship__c;
        }
        activityCloneResult.clonedProducts=clonedProducts;
        return activityCloneResult;
    }
    
    public class CA_BannerSettings{
        @AuraEnabled
        public string objLabel{get;set;}
        @AuraEnabled
        public sobject objectRecord{get;set;}
        @AuraEnabled
        public string objApiName{get;set;}
        @AuraEnabled
        public string editButtonLabel{get;set;}
        @AuraEnabled
        public string deleteButtonLabel{get;set;}
        @AuraEnabled
        public string buttonStyle{get;set;}
        @AuraEnabled
        public boolean delPrivilege{get;set;}
        @AuraEnabled
        public boolean editPrivilege{get;set;}
        
        public CA_BannerSettings(){
            this.objLabel='Congress';
            this.objApiName='CA_Main_Event__c';
            this.editButtonLabel='Edit';
            this.deleteButtonLabel='Delete';
            this.buttonStyle='background-color:transparent;';
            this.delPrivilege=true;
            this.editPrivilege=true;
        }
        
    }
    
    public class CA_ActivityCloneResult{
        @AuraEnabled
        public string clonedActivityId{get;set;}
        @AuraEnabled
        public List<CA_Product__c> clonedProducts {get;set;}
            public CA_ActivityCloneResult(){
                this.clonedActivityId='';
                this.clonedProducts= new List<CA_Product__c>();
            }
    }
    /* SCA-848:Back button functionality start By Srinadh*/
    @AuraEnabled        
    public static String getRelatedRecordId(ID recID){
        String recordId;
        String exhibitId;
        String sponsorshipId;
        String meetingRoomId;
        String eventId;
        String speakingEngagementId;
        String regAttendOnlyId;
        String generalEventCostId;
        String meetingPlanningId;
        
        String  objectName = String.valueOf(recID.getSObjectType());
        
        System.debug('objectName--- '+objectName);
        
        if(objectName.contains('CA_Product__c')){
            CA_Product__c prod = [select name,Id,CA_Event__c,Exhibit__c,Meeting_Planning__c,Meeting_Room__c,Membership__c,Speaking_Engagement__c,Sponsorship__c,Sporting_Event__c from CA_Product__c where id =: recID ];
            
            exhibitId = prod.Exhibit__c;
            sponsorshipId = prod.Sponsorship__c;
            meetingRoomId = prod.Meeting_Room__c;
            speakingEngagementId = prod.Speaking_Engagement__c;
            eventId = prod.CA_Event__c;
            //regAttendOnlyId = prod.Registration_Attend_Only__c;
            //generalEventCostId = prod.General_Event_Costs__c;
            meetingPlanningId = prod.Meeting_Planning__c;
            
            if(String.isNotBlank(exhibitId)){
                recordId =  exhibitId;
            }else if(String.isNotBlank(sponsorshipId)){
                recordId =  sponsorshipId;
            }else if(String.isNotBlank(meetingRoomId)){
                recordId =  meetingRoomId;
            }else if(String.isNotBlank(speakingEngagementId)){
                recordId =  speakingEngagementId;
            }else if(String.isNotBlank(eventId)){
                recordId =  eventId;
            }
            else if(String.isNotBlank(regAttendOnlyId)){
                recordId =  regAttendOnlyId;
            }
            else if(String.isNotBlank(generalEventCostId)){
                recordId =  generalEventCostId;
            }
            else if(String.isNotBlank(meetingPlanningId)){
                recordId =  meetingPlanningId;
            }
            else if(String.isNotBlank(prod.Membership__c)){
                recordId =  prod.Membership__c;
            }
            
            else if(String.isNotBlank(prod.Sporting_Event__c)){
                recordId =  prod.Sporting_Event__c;
            }
            
            
        }
        else if(objectName.contains('CA_Exhibit__c')){
            CA_Exhibit__c exhibit = [select name,Id,Event__c from CA_Exhibit__c
                                 where id =: recID ];
            recordId = exhibit.Event__c;
        }
        else if(objectName.contains('CA_Sponsorship__c')){
            CA_Sponsorship__c sponsorship = [select name,Id,Event__c from CA_Sponsorship__c
                                 where id =: recID ];
            recordId = sponsorship.Event__c;
        }
        else if(objectName.contains('CA_Meeting_Room__c')){
            CA_Meeting_Room__c meetingRoom = [select name,Id,Event__c from CA_Meeting_Room__c
                                 where id =: recID ];
            recordId = meetingRoom.Event__c;
        }
        else if(objectName.contains('CA_Speaking_Engagement__c')){
            CA_Speaking_Engagement__c speakingEngagement = [select name,Id,Event__c from CA_Speaking_Engagement__c
                                 where id =: recID ];
            recordId = speakingEngagement.Event__c;
        }
        /*else if(objectName.contains('GT_Event_RL__c')){
            GT_Event_RL__c eventObj = [select name,Id,GES_Connect_Event__c from GT_Event_RL__c
                                 where id =: recID ];
            recordId = eventObj.GES_Connect_Event__c;
        }
        else if(objectName.contains('GT_Reg_Attend_Only__c')){
            GT_Reg_Attend_Only__c regAttendObj = [select name,Id,GES_Connect_Event__c from GT_Reg_Attend_Only__c
                                 where id =: recID ];
            recordId = regAttendObj.GES_Connect_Event__c;
        }
        else if(objectName.contains('GT_General_Event_Costs__c')){
            GT_General_Event_Costs__c genEventCostObj = [select name,Id,GES_Connect_Event__c from GT_General_Event_Costs__c
                                 where id =: recID ];
            recordId = genEventCostObj.GES_Connect_Event__c;
        }*/
        else if(objectName.contains('CA_Meeting_Planning__c')){
            CA_Meeting_Planning__c meetingPlaninngObj = [select name,Id,Event__c from CA_Meeting_Planning__c
                                 where id =: recID ];
            recordId = meetingPlaninngObj.Event__c;
        }
         else if(objectName.contains('CA_Membership__c  ')){
            CA_Membership__c     memberObj = [select name,Id,Event__c from CA_Membership__c 
                                 where id =: recID ];
            recordId = memberObj.Event__c;
        }
        else if(objectName.contains('CA_Sporting_Event__c')){
            CA_Sporting_Event__c memberObj = [select name,Id,Event__c from CA_Sporting_Event__c
                                 where id =: recID ];
            recordId = memberObj.Event__c;
        }
        else if(objectName.contains('CA_Event__c')){
            CA_Event__c memberObj = [select name,Id,Event__c from CA_Event__c
                                 where id =: recID ];
            recordId = memberObj.Event__c;
        }
        
        system.debug('recordId---->'+recordId);
        return recordId;
    }
    /* SCA-848:Back button functionality end By Srinadh */
}