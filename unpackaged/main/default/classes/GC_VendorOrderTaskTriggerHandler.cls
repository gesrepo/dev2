/**
* @author Ethos Solutions - www.ethos.com
* @description Trigger logic for Vendor Order Task
* 2016-04-13 : Original Version
**/
public without sharing class GC_VendorOrderTaskTriggerHandler {

    public static void UpdateShowTeamAccess(List<GC_Vendor_Order_Task__c> vendorOrderTask) {
        Set<Id> votIds = new Set<Id>();

        for (GC_Vendor_Order_Task__c vot : vendorOrderTask) {
            votIds.add(vot.Id);
        }

        List<GC_Vendor_Order_Task__c> votQuery = [select Id, order__r.id, Order__r.Connect2_Show__c, Vendor__c from GC_Vendor_Order_Task__c where Id In :votIds];
        Set<Id> showIds = new Set<Id>();
        Set<Id> vendorIds = new Set<Id>();
        List<GC_Order__c> ordersOfVots = new  List<GC_Order__c>();
        for (GC_Vendor_Order_Task__c vot : votQuery) {
            showIds.add(vot.Order__r.Connect2_Show__c);
            //GC_Order__c votOrder= new GC_Order__c();
            //votOrder
            ordersOfVots.add(vot.Order__r);
            vendorIds.add(vot.Vendor__c);
        }

        List<GC_Show_Team_Member__c> showTeamMembers = [select Id, Name, User__c, Show_Role__c, Connect2_Show__c from GC_Show_Team_Member__c where Connect2_Show__c in :showIds];
        if(vendorIds.size()>0){
                List<GC_Show_Team_Member__c> showVendors = [select Id, Name, User__c, Show_Role__c, Connect2_Show__c from GC_Show_Team_Member__c where Connect2_Show__c in :vendorIds];
                //GC_ShowTeamMemberTriggerHandler.UpdateRecordAccessOrders(showVendors, ordersOfVots);
        }

        
        GC_ShowTeamMemberTriggerHandler.UpdateRecordAccessVendorOrderTasks(showTeamMembers, votQuery);
    }


    public static void HandleShowTeamCreation(List<GC_Vendor_Order_Task__c> vendorOrderTasks) {
        Set<Id> votIds = new Set<Id>();
        List<GC_Show_Team_Member__c> stmList = new List<GC_Show_Team_Member__c>();

        for (GC_Vendor_Order_Task__c vot : vendorOrderTasks) {
            votIds.add(vot.Id);

        }

        List<GC_Vendor_Order_Task__c> votQuery = [select Id, Order__r.Connect2_Show__c, Vendor__c from GC_Vendor_Order_Task__c where Id In :votIds];

        for (GC_Vendor_Order_Task__c vot : votQuery) {

            GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
            stm.Connect2_Show__c = vot.Order__r.Connect2_Show__c;
            stm.User__c = vot.Vendor__c;
            stm.Show_Role__c = 'Vendor';
            stmList.add(stm);
        }

        Database.insert(stmList, false);
    }


    public static void HandleVendorShares(List<GC_Vendor_Order_Task__c> vendorOrderTasks) {
        Set<Id> votIds = new Set<Id>();

        for (GC_Vendor_Order_Task__c vot : vendorOrderTasks) {
            votIds.add(vot.Id);
        }

        List<GC_Vendor_Order_Task__c> votQuery = [Select Id, Order__c, Vendor__c, Vendor2__c, Vendor3__c, Vendor4__c, Vendor5__c, Order__r.Connect2_Show__c from GC_Vendor_Order_Task__c where Id in :votIds];

        List<GC_Vendor_Order_Task__Share> votShares = new List<GC_Vendor_Order_Task__Share>();
        List<GC_Connect2_Show__Share> connect2Shares = new List<GC_Connect2_Show__Share>();
        List<GC_Order__Share> orderShares = new List<GC_Order__Share>();
        Map<String, String> vendorMap = new Map<String, String>();
        List<GC_Show_Team_Member__c> showVendors = new List<GC_Show_Team_Member__c>();

        Set<Id> showIds = new Set<Id>();

        for (GC_Vendor_Order_Task__c vot : votQuery) {
            showIds.add(vot.Order__r.Connect2_Show__c);
        }

        List<GC_Show_Team_Member__c> showteamMembers = [select Id, Name, User__c, Show_role__c, Connect2_Show__c from GC_Show_Team_Member__c where Connect2_Show__c in :showIds];

        for (GC_Vendor_Order_Task__c vot : votQuery) {
            if (vot.Vendor__c != null) {
                GC_Vendor_Order_Task__Share votShareObject = new GC_Vendor_Order_Task__Share();
                votShareObject.ParentId = vot.Id;
                votShareObject.UserOrGroupId = vot.Vendor__c;
                votShareObject.AccessLevel = 'Read';
                votShares.add(votShareObject);

                GC_Connect2_Show__Share connect2ShareObject = new GC_Connect2_Show__Share();
                connect2ShareObject.ParentId = vot.Order__r.Connect2_Show__c;
                connect2ShareObject.UserOrGroupId = vot.Vendor__c;
                connect2ShareObject.AccessLevel = 'Read';
                connect2Shares.add(connect2ShareObject);

                GC_Order__Share orderShareObject = new GC_Order__Share();
                orderShareObject.ParentId = vot.Order__c;
                orderShareObject.UserOrGroupId = vot.Vendor__c;
                orderShareObject.AccessLevel = 'Read';
                orderShares.add(orderShareObject);
                vendorMap.put(vot.Vendor__c, vot.Id);
            }

            if (vot.Vendor2__c != null) {
                GC_Vendor_Order_Task__Share votShareObject = new GC_Vendor_Order_Task__Share();
                votShareObject.ParentId = vot.Id;
                votShareObject.UserOrGroupId = vot.Vendor2__c;
                votShareObject.AccessLevel = 'Read';
                votShares.add(votShareObject);

                GC_Connect2_Show__Share connect2ShareObject = new GC_Connect2_Show__Share();
                connect2ShareObject.ParentId = vot.Order__r.Connect2_Show__c;
                connect2ShareObject.UserOrGroupId = vot.Vendor2__c;
                connect2ShareObject.AccessLevel = 'Read';
                connect2Shares.add(connect2ShareObject);

                GC_Order__Share orderShareObject = new GC_Order__Share();
                orderShareObject.ParentId = vot.Order__c;
                orderShareObject.UserOrGroupId = vot.Vendor2__c;
                orderShareObject.AccessLevel = 'Read';
                orderShares.add(orderShareObject);
                vendorMap.put(vot.Vendor2__c, vot.Id);
            }

            if (vot.Vendor3__c != null) {
                GC_Vendor_Order_Task__Share votShareObject = new GC_Vendor_Order_Task__Share();
                votShareObject.ParentId = vot.Id;
                votShareObject.UserOrGroupId = vot.Vendor3__c;
                votShareObject.AccessLevel = 'Read';
                votShares.add(votShareObject);

                GC_Connect2_Show__Share connect2ShareObject = new GC_Connect2_Show__Share();
                connect2ShareObject.ParentId = vot.Order__r.Connect2_Show__c;
                connect2ShareObject.UserOrGroupId = vot.Vendor3__c;
                connect2ShareObject.AccessLevel = 'Read';
                connect2Shares.add(connect2ShareObject);

                GC_Order__Share orderShareObject = new GC_Order__Share();
                orderShareObject.ParentId = vot.Order__c;
                orderShareObject.UserOrGroupId = vot.Vendor3__c;
                orderShareObject.AccessLevel = 'Read';
                orderShares.add(orderShareObject);
                vendorMap.put(vot.Vendor3__c, vot.Id);
            }

            if (vot.Vendor4__c != null) {
                GC_Vendor_Order_Task__Share votShareObject = new GC_Vendor_Order_Task__Share();
                votShareObject.ParentId = vot.Id;
                votShareObject.UserOrGroupId = vot.Vendor4__c;
                votShareObject.AccessLevel = 'Read';
                votShares.add(votShareObject);

                GC_Connect2_Show__Share connect2ShareObject = new GC_Connect2_Show__Share();
                connect2ShareObject.ParentId = vot.Order__r.Connect2_Show__c;
                connect2ShareObject.UserOrGroupId = vot.Vendor4__c;
                connect2ShareObject.AccessLevel = 'Read';
                connect2Shares.add(connect2ShareObject);

                GC_Order__Share orderShareObject = new GC_Order__Share();
                orderShareObject.ParentId = vot.Order__c;
                orderShareObject.UserOrGroupId = vot.Vendor4__c;
                orderShareObject.AccessLevel = 'Read';
                orderShares.add(orderShareObject);
                vendorMap.put(vot.Vendor4__c, vot.Id);
            }

            if (vot.Vendor5__c != null) {
                GC_Vendor_Order_Task__Share votShareObject = new GC_Vendor_Order_Task__Share();
                votShareObject.ParentId = vot.Id;
                votShareObject.UserOrGroupId = vot.Vendor5__c;
                votShareObject.AccessLevel = 'Read';
                votShares.add(votShareObject);

                GC_Connect2_Show__Share connect2ShareObject = new GC_Connect2_Show__Share();
                connect2ShareObject.ParentId = vot.Order__r.Connect2_Show__c;
                connect2ShareObject.UserOrGroupId = vot.Vendor5__c;
                connect2ShareObject.AccessLevel = 'Read';
                connect2Shares.add(connect2ShareObject);

                GC_Order__Share orderShareObject = new GC_Order__Share();
                orderShareObject.ParentId = vot.Order__c;
                orderShareObject.UserOrGroupId = vot.Vendor5__c;
                orderShareObject.AccessLevel = 'Read';
                orderShares.add(orderShareObject);
                vendorMap.put(vot.Vendor5__c, vot.Id);
            }
        }

        List<GC_Show_Team_Member__c> showVendorQuery = [select Id, Name, User__c, Show_role__c, Connect2_Show__c from GC_Show_Team_Member__c where User__c in :vendorMap.keySet()];

        for (GC_Show_Team_Member__c sho : showVendorQuery) {
            showVendors.add(sho);
        }

        Database.insert(votShares, false);
        Database.insert(connect2Shares, false);
        Database.insert(orderShares, false);
        Database.insert(showVendors, false);
    }

    public static void AddVendorToShow(List<GC_Vendor_Order_Task__c> vendorTasks) {
        List<GC_Show_Team_Member__c> stmList = new List<GC_Show_Team_Member__c>();

        Set<Id> votIds = new Set<Id>();

        for (GC_Vendor_Order_Task__c vot : vendorTasks) {
            votIds.add(vot.Id);
        }

        List<GC_Vendor_Order_Task__c> votQuery = [Select Id, Order__c, Vendor__c, Vendor2__c, Vendor3__c, Vendor4__c, Vendor5__c, Order__r.Connect2_Show__c from GC_Vendor_Order_Task__c where Id in :votIds];

        for (GC_Vendor_Order_Task__c vot : votQuery) {
            if (vot.Vendor__c != null) {
                GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
                stm.Connect2_Show__c = vot.Order__r.Connect2_Show__c;
                stm.User__c = vot.Vendor__c;
                stm.Show_Role__c = 'Vendor';
                stmList.add(stm);
            }

            if (vot.Vendor2__c != null) {
                GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
                stm.Connect2_Show__c = vot.Order__r.Connect2_Show__c;
                stm.User__c = vot.Vendor2__c;
                stm.Show_Role__c = 'Vendor';
                stmList.add(stm);
            }

            if (vot.Vendor3__c != null) {
                GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
                stm.Connect2_Show__c = vot.Order__r.Connect2_Show__c;
                stm.User__c = vot.Vendor3__c;
                stm.Show_Role__c = 'Vendor';
                stmList.add(stm);
            }

            if (vot.Vendor4__c != null) {
                GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
                stm.Connect2_Show__c = vot.Order__r.Connect2_Show__c;
                stm.User__c = vot.Vendor4__c;
                stm.Show_Role__c = 'Vendor';
                stmList.add(stm);
            }

            if (vot.Vendor5__c != null) {
                GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
                stm.Connect2_Show__c = vot.Order__r.Connect2_Show__c;
                stm.User__c = vot.Vendor5__c;
                stm.Show_Role__c = 'Vendor';
                stmList.add(stm);
            }
        }

        if (stmList.size() > 0) {
            //insert stmList;
            Database.insert(stmList, false);
        }
    }

    public static void AddVendorToShow(Map<Id, GC_Vendor_Order_Task__c> oldMap, Map<Id, GC_Vendor_Order_Task__c> newMap) {
        Set<Id> votIds = new Set<Id>();

        for (Id task : oldMap.keySet()) {
            if (oldMap.get(task).Vendor__c != newMap.get(task).Vendor__c) {
                votIds.add(task);
            }

            if (oldMap.get(task).Vendor2__c != newMap.get(task).Vendor2__c) {
                votIds.add(task);
            }

            if (oldMap.get(task).Vendor3__c != newMap.get(task).Vendor3__c) {
                votIds.add(task);
            }

            if (oldMap.get(task).Vendor4__c != newMap.get(task).Vendor4__c) {
                votIds.add(task);
            }

            if (oldMap.get(task).Vendor5__c != newMap.get(task).Vendor5__c) {
                votIds.add(task);
            }
        }

        if (votIds.size() > 0) {
            List<GC_Vendor_Order_Task__c> votQuery = [select Id, Order__r.Connect2_Show__c, Vendor__c, Vendor2__c, Vendor3__c, Vendor4__c, Vendor5__c from GC_Vendor_Order_Task__c where Id In :votIds];
            AddVendorToShow(votQuery);
        }
    }

    public static void CheckChangeOwner(Map<Id, GC_Vendor_Order_Task__c> oldMap, Map<Id, GC_Vendor_Order_Task__c> newMap) {
        List<GC_Vendor_Order_Task__c> recalcRecords = new List<GC_Vendor_Order_Task__c>();

        for (Id taskId : Trigger.newMap.keySet()) {
            if (oldMap.get(taskId).OwnerId != newMap.get(taskId).OwnerId) {
                recalcRecords.add(newMap.get(taskId));
            }
        }

        if (recalcRecords.size() > 0) {
            UpdateShowTeamAccess(recalcRecords);
            HandleVendorShares(recalcRecords);
        }
    }

    public static void HandleGESOrderTaskShares(List<GC_Vendor_Order_Task__c> vendorOrderTasks) {
        // Get the list of vendors by task
        // Get the list of ges tasks by vendor task
        List<GC_GES_Order_Task__Share> newShares = new List<GC_GES_Order_Task__Share>();
        //Set<Id> relatedOrderIdSet= new Set<Id>();
        Map<Id, Set<Id>>orderToVendorsMap = new Map<Id, Set<Id>>();

        for (GC_Vendor_Order_Task__c vot : vendorOrderTasks) {
            if(vot.SelectAllOrderTasks__c && vot.Order__c!=null){
                //relatedOrderIdSet.add(vot.Order__c);
                if(!orderToVendorsMap.containsKey(vot.Order__c)){
                    orderToVendorsMap.put(vot.Order__c, new Set<Id>());
                }
                orderToVendorsMap.get(vot.Order__c).add(vot.Vendor__c);
                //system.debug('Step 1 Checkbox checked for==='+vot.Vendor__c);
            }
            
            if (vot.Vendor__c != null) {
                if (vot.GESOrderTask1__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask1__c, vot.Vendor__c, 'Read'));
                }

                if (vot.GESOrderTask2__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask2__c, vot.Vendor__c, 'Read'));
                }

                if (vot.GESOrderTask3__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask3__c, vot.Vendor__c, 'Read'));
                }

                if (vot.GESOrderTask4__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask3__c, vot.Vendor__c, 'Read'));
                }

                if (vot.GESOrderTask5__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask3__c, vot.Vendor__c, 'Read'));
                }
            }

            if (vot.Vendor2__c != null) {
                if (vot.GESOrderTask1__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask1__c, vot.Vendor2__c, 'Read'));
                }

                if (vot.GESOrderTask2__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask2__c, vot.Vendor2__c, 'Read'));
                }

                if (vot.GESOrderTask3__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask3__c, vot.Vendor2__c, 'Read'));
                }

                if (vot.GESOrderTask4__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask3__c, vot.Vendor2__c, 'Read'));
                }

                if (vot.GESOrderTask5__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask3__c, vot.Vendor2__c, 'Read'));
                }
            }

            if (vot.Vendor3__c != null) {
                if (vot.GESOrderTask1__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask1__c, vot.Vendor3__c, 'Read'));
                }

                if (vot.GESOrderTask2__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask2__c, vot.Vendor3__c, 'Read'));
                }

                if (vot.GESOrderTask3__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask3__c, vot.Vendor3__c, 'Read'));
                }

                if (vot.GESOrderTask4__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask3__c, vot.Vendor3__c, 'Read'));
                }

                if (vot.GESOrderTask5__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask3__c, vot.Vendor3__c, 'Read'));
                }
            }

            if (vot.Vendor4__c != null) {
                if (vot.GESOrderTask1__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask1__c, vot.Vendor4__c, 'Read'));
                }

                if (vot.GESOrderTask2__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask2__c, vot.Vendor4__c, 'Read'));
                }

                if (vot.GESOrderTask3__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask3__c, vot.Vendor4__c, 'Read'));
                }

                if (vot.GESOrderTask4__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask3__c, vot.Vendor4__c, 'Read'));
                }

                if (vot.GESOrderTask5__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask3__c, vot.Vendor4__c, 'Read'));
                }
            }

            if (vot.Vendor5__c != null) {
                if (vot.GESOrderTask1__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask1__c, vot.Vendor5__c, 'Read'));
                }

                if (vot.GESOrderTask2__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask2__c, vot.Vendor5__c, 'Read'));
                }

                if (vot.GESOrderTask3__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask3__c, vot.Vendor5__c, 'Read'));
                }

                if (vot.GESOrderTask4__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask3__c, vot.Vendor5__c, 'Read'));
                }

                if (vot.GESOrderTask5__c != null) {
                    newShares.add(newGESTaskShare(vot.GESOrderTask3__c, vot.Vendor5__c, 'Read'));
                }
            }
        }
        
        //START- Create share objects for orders and all GOTs if the checkbox is selected -START
        if(orderToVendorsMap.keySet().size()>0){
            
            List<GC_GES_Order_Task__c> allGotsToBeShared = [SELECT id, name,Order__c FROM GC_GES_Order_Task__c WHERE Order__c IN :orderToVendorsMap.keySet() ];
            for(GC_GES_Order_Task__c gotToBeShared:allGotsToBeShared){
                if(orderToVendorsMap.containsKey(gotToBeShared.Order__c)){
                    for(Id vendorId: orderToVendorsMap.get(gotToBeShared.Order__c)){
                        newShares.add(newGESTaskShare(gotToBeShared.Id, vendorId, 'Read'));
                        //system.debug('Step 1 Checkbox checked for==='+vendorId);
                    }
                }
            }
            
        }
        
        //END- Create share objects for orders and all GOTs if the checkbox is selected -END
        Database.insert(newShares, false);
    }

    private static GC_GES_Order_Task__Share newGESTaskShare(String gesTaskId, String userId, String permissionLevel) {
        GC_GES_Order_Task__Share newShare = new GC_GES_Order_Task__Share();
        newShare.ParentId = gesTaskId;
        newShare.UserOrGroupId = userId;
        newShare.AccessLevel = 'Read';
        return newShare;
    }

    public static void HandleGESOrderTaskShares(Map<Id, GC_Vendor_Order_Task__c> oldMap, Map<Id, GC_Vendor_Order_Task__c> newMap) {
        // this will ignore things like status changes and instruction changes, and only capture assignment changes.
        List<GC_Vendor_Order_Task__c> vendorTasks = new List<GC_Vendor_Order_Task__c>();

        for (Id task : oldMap.keySet()) {
            if (oldMap.get(task).Vendor__c != newMap.get(task).Vendor__c) {
                vendorTasks.add(newMap.get(task));
            } else if (oldMap.get(task).Vendor2__c != newMap.get(task).Vendor2__c) {
                vendorTasks.add(newMap.get(task));
            } else if (oldMap.get(task).Vendor3__c != newMap.get(task).Vendor3__c) {
                vendorTasks.add(newMap.get(task));
            } else if (oldMap.get(task).Vendor4__c != newMap.get(task).Vendor4__c) {
                vendorTasks.add(newMap.get(task));
            } else if (oldMap.get(task).Vendor5__c != newMap.get(task).Vendor5__c) {
                vendorTasks.add(newMap.get(task));
            } else if (oldMap.get(task).GESOrderTask1__c != newMap.get(task).GESOrderTask1__c) {
                vendorTasks.add(newMap.get(task));
            } else if (oldMap.get(task).GESOrderTask2__c != newMap.get(task).GESOrderTask2__c) {
                vendorTasks.add(newMap.get(task));
            } else if (oldMap.get(task).GESOrderTask3__c != newMap.get(task).GESOrderTask3__c) {
                vendorTasks.add(newMap.get(task));
            } else if (oldMap.get(task).GESOrderTask4__c != newMap.get(task).GESOrderTask4__c) {
                vendorTasks.add(newMap.get(task));
            } else if (oldMap.get(task).GESOrderTask5__c != newMap.get(task).GESOrderTask5__c) {
                vendorTasks.add(newMap.get(task));
            }
        }

        if (vendorTasks.size() > 0) {
            HandleGESOrderTaskShares(vendorTasks);
        }
    }
}