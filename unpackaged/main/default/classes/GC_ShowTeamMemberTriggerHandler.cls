/**
* @author Ethos Solutions - www.ethos.com
* @description Trigger logic for Show team Member
* 2016-04-13 : Original Version
**/
public without sharing class GC_ShowTeamMemberTriggerHandler {
    public static Map<String, String> mapAccessLevel = new Map<String, String> {
        'GC_Connect2_Show__c,Account Manager' => 'Edit'
        , 'GC_Connect2_Show__c,Secondary Account Manager' => 'Edit'
        , 'GC_Connect2_Show__c,Sales Manager' => 'Edit'
        , 'GC_Connect2_Show__c,Creative Director' => 'Edit'
        , 'GC_Connect2_Show__c,Graphics Project Manager' => 'Edit'
        , 'GC_Connect2_Show__c,Traffic Administrator' => 'Edit'
        , 'GC_Connect2_Show__c,Designer' => 'Read'
        , 'GC_Connect2_Show__c,Detailer' => 'Read'
        , 'GC_Connect2_Show__c,Designer/Detailer' => 'Read'
        , 'GC_Connect2_Show__c,Director of Account Management' => 'Read'
        , 'GC_Connect2_Show__c,Show Organizer' => 'Read'
        , 'GC_Connect2_Show__c,Show Organizer - Read Only' => 'Read'
        , 'GC_Connect2_Show__c,Vendor' => 'Read'
        , 'GC_Show_Attribute__c,Account Manager' => 'Edit'
        , 'GC_Show_Attribute__c,Secondary Account Manager' => 'Edit'
        , 'GC_Show_Attribute__c,Sales Manager' => 'Edit'
        , 'GC_Show_Attribute__c,Creative Director' => 'Edit'
        , 'GC_Show_Attribute__c,Designer' => 'Read'
        , 'GC_Show_Attribute__c,Detailer' => 'Read'
        , 'GC_Show_Attribute__c,Designer/Detailer' => 'Read'
        , 'GC_Show_Attribute__c,Director of Account Management' => 'Edit'
        , 'GC_Show_Attribute__c,Graphics Project Manager' => 'Edit'
        , 'GC_Show_Attribute__c,Show Organizer' => 'Edit'
        , 'GC_Show_Attribute__c,Traffic Administrator' => 'Edit'
        , 'GC_Show_Attribute__c,Vendor' => 'Read'
        , 'GC_Show_Team_Member__c,Account Manager' => 'Edit'
        , 'GC_Show_Team_Member__c,Secondary Account Manager' => 'Edit'
        , 'GC_Show_Team_Member__c,Sales Manager' => 'Edit'
        , 'GC_Show_Team_Member__c,Creative Director' => 'Edit'
        , 'GC_Show_Team_Member__c,Designer' => 'Edit'
        , 'GC_Show_Team_Member__c,Detailer' => 'Edit'
        , 'GC_Show_Team_Member__c,Designer/Detailer' => 'Edit'
        , 'GC_Show_Team_Member__c,Director of Account Management' => 'Edit'
        , 'GC_Show_Team_Member__c,Graphics Project Manager' => 'Edit'
        , 'GC_Show_Team_Member__c,Show Organizer' => 'Edit'
        , 'GC_Show_Team_Member__c,Show Organizer - Read Only' => 'Read'
        , 'GC_Show_Team_Member__c,Traffic Administrator' => 'Edit'
        , 'GC_Show_Team_Member__c,Vendor' => 'Edit'
        , 'GC_Design_Request_Form__c,Account Manager' => 'Edit'
        , 'GC_Design_Request_Form__c,Secondary Account Manager' => 'Edit'
        , 'GC_Design_Request_Form__c,Sales Manager' => 'Edit'
        , 'GC_Design_Request_Form__c,Creative Director' => 'Edit'
        , 'GC_Design_Request_Form__c,Designer' => 'Edit'
        , 'GC_Design_Request_Form__c,Detailer' => 'Edit'
        , 'GC_Design_Request_Form__c,Designer/Detailer' => 'Edit'
        , 'GC_Design_Request_Form__c,Director of Account Management' => 'Edit'
        , 'GC_Design_Request_Form__c,Traffic Administrator' => 'Edit'
        , 'GC_Design_Request_Form_Budget__c,Account Manager' => 'Edit'
        , 'GC_Design_Request_Form_Budget__c,Secondary Account Manager' => 'Edit'
        , 'GC_Design_Request_Form_Budget__c,Sales Manager' => 'Edit'
        , 'GC_Design_Request_Form_Budget__c,Creative Director' => 'Edit'
        , 'GC_Design_Request_Form_Budget__c,Designer' => 'Read'
        , 'GC_Design_Request_Form_Budget__c,Detailer' => 'Read'
        , 'GC_Design_Request_Form_Budget__c,Designer/Detailer' => 'Read'
        , 'GC_Design_Request_Form_Budget__c,Director of Account Management' => 'Edit'
        , 'GC_Design_Request_Form_Budget__c,Traffic Administrator' => 'Edit'
        , 'GC_Vendor_Order_Task__c,Director of Account Management' => 'Edit'
        , 'GC_Vendor_Order_Task__c,Account Manager' => 'Edit'
        , 'GC_Vendor_Order_Task__c,Secondary Account Manager' => 'Edit'
        , 'GC_Vendor_Order_Task__c,Show Organizer' => 'Edit'
        , 'GC_Vendor_Order_Task__c,Show Organizer - Read Only' => 'Read'
        , 'GC_GES_Order_Task__c,Account Manager' => 'Edit'
        , 'GC_GES_Order_Task__c,Secondary Account Manager' => 'Edit'
        , 'GC_GES_Order_Task__c,Graphics Project Manager' => 'Edit'
        , 'GC_GES_Order_Task__c,Director of Account Management' => 'Edit'
        , 'GC_GES_Order_Task__c,Show Organizer' => 'Edit'
        , 'GC_GES_Order_Task__c,Show Organizer - Read Only' => 'Read'
        , 'GC_Order__c,Account Manager' => 'Edit'
        , 'GC_Order__c,Secondary Account Manager' => 'Edit'
        , 'GC_Order__c,Director of Account Management' => 'Edit'
        , 'GC_Order__c,Graphics Project Manager' => 'Edit'
        , 'GC_Order__c,Show Organizer' => 'Edit'
        , 'GC_Order__c,Show Organizer - Read Only' => 'Read'
        , 'GC_Design_Element__c,Account Manager' => 'Edit' // account managers are the primary people creating design requests.
        , 'GC_Design_Element__c,Secondary Account Manager' => 'Edit'
        , 'GC_Design_Element__c,Director of Account Management' => 'Edit'
        , 'GC_Design_Element__c,Creative Director' => 'Edit'
        , 'GC_Design_Element__c,Traffic Administrator' => 'Edit'
        , 'GC_Design_Element__c,Graphics Project Manager' => 'Read'
    };

    public static void TotalAMWeight(List<GC_Show_Team_Member__c> showTeamMembers,List<GC_Show_Team_Member__c>showTeamMemberOld){
        if(showTeamMembers!=null && showTeamMembers.size()>0){
            GC_Show_Team_Member__c showTeamMember = showTeamMembers[0];
            Decimal newWeight = showTeamMember.AM_Weight__c;
            Decimal oldWeight = 0;
            Decimal decimalRevenue = 0 ;
            Decimal totalWeight = 0;
            Decimal balance = 0;
            String showRole = showTeamMember.Show_Role__c;
            System.debug('showRole'+showRole);
            System.debug('newWeight'+newWeight);
            if('Account Manager'.equals(showRole)){
        if(newWeight!=null && newWeight>0 && newWeight <=100){
            if(showTeamMemberOld!=null && showTeamMemberOld.size()>0 ){
                System.debug('showTeamMemberOld size---'+showTeamMemberOld.size());
                if(String.valueOf(showTeamMemberOld[0].AM_Weight__c) !=null && String.valueOf(showTeamMemberOld[0].AM_Weight__c) != ''){
                    System.debug('old weight---'+showTeamMemberOld[0].AM_Weight__c);
                    oldWeight = showTeamMemberOld[0].AM_Weight__c;
                }
                
            }
               List<AggregateResult> groupedResults = [select SUM(AM_Weight__c)total from GC_Show_Team_Member__c where Show_Role__c ='Account Manager' and Connect2_Show__c =:showTeamMember.Connect2_Show__c GROUP BY Connect2_Show__c];
                    if(groupedResults.size() > 0 && (String.valueOf(groupedResults[0].get('total'))) != null){
                        decimalRevenue = Decimal.ValueOf(String.valueOf(groupedResults[0].get('total')));
                        totalWeight = decimalRevenue+(newWeight-oldWeight);
                            if(totalWeight>100){
                                balance = 100-decimalRevenue;
                                System.debug('balance'+balance);
                                System.debug('oldWeight'+oldWeight);
                                showTeamMembers[0].AM_Weight__c.addError('Please enter a value less than or equal to '+(balance+oldWeight));
                            }
                    }
        }else if(newWeight>100){
            showTeamMembers[0].AM_Weight__c.addError('Please enter a value less than or equal to 100');
            
        }else if(newWeight<0){
            showTeamMembers[0].AM_Weight__c.addError('Please enter positive numbers only');
        }
        }
        }
    }
        
    public static void UpdateShowRecordAccess(List<GC_Show_Team_Member__c> showTeamMembers) {
        // 10 soql calls
        Set<String> shows = new Set<String>();

        for (GC_Show_Team_Member__c showTeamMember : showTeamMembers) {
            shows.Add(showTeamMember.Connect2_Show__c);
        }

        List<GC_Connect2_Show__c> connect2Shows = [select Id From GC_Connect2_Show__c where Id in :shows];
        List<GC_Show_Team_Member__c> entireShowTeam = [select Id, User__c, Connect2_Show__c from GC_Show_Team_Member__c where Connect2_Show__c in :shows];
        List<GC_Show_Attribute__c> showAttributes = [select Id, Connect2_Show__c from GC_Show_Attribute__c where Connect2_Show__c in :shows];
        //List<GC_Design_Request_Form__c> drfs = [select Id, Connect2_Show__c from GC_Design_Request_Form__c where Connect2_Show__c in :shows]; //SAL-1293 - DRF records access no longer needed - 12/19/23 - Sajid
        //Map<Id, GC_Design_Request_Form__c> drfMap = new Map<Id, GC_Design_Request_Form__c>(drfs); //SAL-1293 - DRF records access no longer needed - 12/19/23 - Sajid
        //SAL-1293 updated where clause  to get the associated Element task records - 12/19/23 - Sajid 
        //List<GC_Design_Element__c> drfElements = [select Id, Design_Request_Form__c, Design_Request_Form__r.Connect2_Show__c from GC_Design_Element__c where Design_Request_Form__c in :drfMap.keySet()];
        List<GC_Design_Element__c> drfElements = [select Id, Design_Request_Form__c, Connect2_Show__c from GC_Design_Element__c where Connect2_Show__c in :shows];
        //List<GC_Design_Request_Form_Budget__c> drfBudgets = [select Id, Design_Request_Form__c, Design_Request_Form__r.Connect2_Show__c from GC_Design_Request_Form_Budget__c where Design_Request_Form__c in :drfMap.keySet()]; //SAL-1293 - DRF records access no longer needed - 12/19/23 - Sajid
        List<GC_Vendor_Order_Task__c> vots = [select Id, Order__r.Connect2_Show__c from GC_Vendor_Order_Task__c where Order__r.Connect2_Show__c in :shows];
        List<GC_GES_Order_Task__c> gots = [select Id, Order__r.Connect2_Show__c from GC_GES_Order_Task__c where Order__r.Connect2_Show__c in :shows];
        List<GC_Order__c> orders = [select Id, Connect2_Show__c from GC_Order__c where Connect2_Show__c in :shows];
        UpdateRecordAccessShows(showTeamMembers, connect2Shows);
        UpdateRecordAccessShowTeamMembers(showTeamMembers, entireShowTeam);
        UpdateRecordAccessShowAttributes(showTeamMembers, showAttributes);
        //UpdateRecordAccessDRF(showTeamMembers, drfs); //SAL-1293 - DRF records access no longer needed - 12/19/23 - Sajid
        //UpdateRecordAccessDRFBudget(showTeamMembers, drfBudgets); //SAL-1293 - DRF records access no longer needed - 12/19/23 - Sajid
        UpdateRecordAccessDesignElementTasks(showTeamMembers, drfElements);
        UpdateRecordAccessGESOrderTasks(showTeamMembers, gots);
        UpdateRecordAccessOrders(showTeamMembers, orders);
        UpdateRecordAccessVendorOrderTasks(showTeamMembers, vots);
    }

    public static void UpdateRecordAccessShows(List<GC_Show_Team_Member__c> showTeamMembers, List<GC_Connect2_Show__c> connect2Shows) {
        List<GC_Connect2_Show__Share> showShares = new List<GC_Connect2_Show__Share>();

        for (GC_Show_Team_Member__c showTeamMember : showTeamMembers) {
            for (GC_Connect2_Show__c show : connect2Shows) {
                if (show.Id != showTeamMember.Connect2_Show__c) {
                    continue;
                }

                String mapLookup = show.getSObjectType().getDescribe().getName() + ',' + showTeamMember.Show_Role__c;

                if (!mapAccessLevel.containsKey(mapLookup)) {
                    continue;
                }

                GC_Connect2_Show__Share shareObject = new GC_Connect2_Show__Share();
                shareObject.ParentId = show.Id;
                shareObject.UserOrGroupId = showTeamMember.User__c;
                shareObject.AccessLevel = mapAccessLevel.get(mapLookup);
                showShares.add(shareObject);
            }
        }

        Database.SaveResult[] saveResultConnect2Shows = Database.insert(showShares, false);
    }

    public static void UpdateRecordAccessShowTeamMembers(List<GC_Show_Team_Member__c> showTeamMembers, List<GC_Show_Team_Member__c> entireShowTeam) {
        List<GC_Show_Team_Member__Share> showTeamMemberShares = new List<GC_Show_Team_Member__Share>();

        for (GC_Show_Team_Member__c showTeamMember : showTeamMembers) {
            for (GC_Show_Team_Member__c stm : entireShowTeam) {
                if (stm.Connect2_Show__c != showTeamMember.Connect2_Show__c) {
                    continue;
                }

                String mapLookup = stm.getSObjectType().getDescribe().getName() + ',' + showTeamMember.Show_Role__c;

                if (!mapAccessLevel.containsKey(mapLookup)) {
                    continue;
                }

                GC_Show_Team_Member__Share shareObject = new GC_Show_Team_Member__Share();
                shareObject.ParentId = showTeamMember.Id;
                shareObject.UserOrGroupId = stm.User__c;
                shareObject.AccessLevel = mapAccessLevel.get(mapLookup);
                showTeamMemberShares.add(shareObject);
                GC_Show_Team_Member__Share shareObject2 = new GC_Show_Team_Member__Share();
                shareObject2.ParentId = stm.Id;
                shareObject2.UserOrGroupId = showTeamMember.User__c;
                shareObject2.AccessLevel = mapAccessLevel.get(mapLookup);
                showTeamMemberShares.add(shareObject2);
            }
        }

        Database.SaveResult[] saveResultShowTeamMember = Database.insert(showTeamMemberShares, false);
    }

    public static void UpdateRecordAccessShowAttributes(List<GC_Show_Team_Member__c> showTeamMembers, List<GC_Show_Attribute__c> showAttributes) {
        List<GC_Show_Attribute__Share> showAttributeShares = new List<GC_Show_Attribute__Share>();

        for (GC_Show_Team_Member__c showTeamMember : showTeamMembers) {
            for (GC_Show_Attribute__c showAttribute : showAttributes) {
                if (showAttribute.Connect2_Show__c != showTeamMember.Connect2_Show__c) {
                    continue;
                }

                String mapLookup = showAttribute.getSObjectType().getDescribe().getName() + ',' + showTeamMember.Show_Role__c;

                if (!mapAccessLevel.containsKey(mapLookup)) {
                    continue;
                }

                GC_Show_Attribute__Share shareObject = new GC_Show_Attribute__Share();
                shareObject.ParentId = showAttribute.Id;
                shareObject.UserOrGroupId = showTeamMember.User__c;
                shareObject.AccessLevel = mapAccessLevel.get(mapLookup);
                showAttributeShares.add(shareObject);
            }
        }

        Database.SaveResult[] saveResultShowAttributes = Database.insert(showAttributeShares, false);
    }
    public static void UpdateRecordAccessDRF(List<GC_Show_Team_Member__c> showTeamMembers, List<GC_Design_Request_Form__c> drfs) {
        List<GC_Design_Request_Form__Share> drfShares = new List<GC_Design_Request_Form__Share>();

        for (GC_Show_Team_Member__c showTeamMember : showTeamMembers) {
            for (GC_Design_Request_Form__c drf : drfs) {
                if (drf.Connect2_Show__c != showTeamMember.Connect2_Show__c) {
                    continue;
                }

                String mapLookup = drf.getSObjectType().getDescribe().getName() + ',' + showTeamMember.Show_Role__c;

                if (!mapAccessLevel.containsKey(mapLookup)) {
                    continue;
                }

                GC_Design_Request_Form__Share shareObject = new GC_Design_Request_Form__Share();
                shareObject.ParentId = drf.Id;
                shareObject.UserOrGroupId = showTeamMember.User__c;
                shareObject.AccessLevel = mapAccessLevel.get(mapLookup);
                drfShares.add(shareObject);
            }
        }

        Database.SaveResult[] saveResultsDrfShares = Database.insert(drfShares, false);
    }
    public static void UpdateRecordAccessDRFBudget(List<GC_Show_Team_Member__c> showTeamMembers, List<GC_Design_Request_Form_Budget__c> drfBudgets) {
        List<GC_Design_Request_Form_Budget__Share> drfBudgetShares = new List<GC_Design_Request_Form_Budget__Share>();

        for (GC_Show_Team_Member__c showTeamMember : showTeamMembers) {
            for (GC_Design_Request_Form_Budget__c drfBudget : drfBudgets) {
                if (drfBudget.Design_Request_Form__r.Connect2_Show__c != showTeamMember.Connect2_Show__c) {
                    continue;
                }

                String mapLookup = drfBudget.getSObjectType().getDescribe().getName() + ',' + showTeamMember.Show_Role__c;

                if (!mapAccessLevel.containsKey(mapLookup)) {
                    continue;
                }

                GC_Design_Request_Form_Budget__Share shareObject = new GC_Design_Request_Form_Budget__Share();
                shareObject.ParentId = drfBudget.Id;
                shareObject.UserOrGroupId = showTeamMember.User__c;
                shareObject.AccessLevel = mapAccessLevel.get(mapLookup);
                drfBudgetShares.add(shareObject);
            }
        }

        Database.SaveResult[] saveResultsDrfBudgetShares = Database.insert(drfBudgetShares, false);
    }
    public static void UpdateRecordAccessDesignElementTasks(List<GC_Show_Team_Member__c> showTeamMembers, List<GC_Design_Element__c> drfElements) {
        List<GC_Design_Element__Share> deShares = new List<GC_Design_Element__Share>();

        for (GC_Show_Team_Member__c showTeamMember : showTeamMembers) {
            for (GC_Design_Element__c de : drfElements) {
                //SAL-1293 - removed DRF reference - 12/22/23 - Sajid
                //if (de.Design_Request_Form__r.Connect2_Show__c != showTeamMember.Connect2_Show__c) {
                if (de.Connect2_Show__c != showTeamMember.Connect2_Show__c) {
                    continue;
                }

                String mapLookup = de.getSObjectType().getDescribe().getName() + ',' + showTeamMember.Show_Role__c;

                if (!mapAccessLevel.containsKey(mapLookup)) {
                    continue;
                }

                GC_Design_Element__Share shareObject = new GC_Design_Element__Share();
                shareObject.ParentId = de.Id;
                shareObject.UserOrGroupId = showTeamMember.User__c;
                shareObject.AccessLevel = mapAccessLevel.get(mapLookup);
                deShares.add(shareObject);
            }
        }

        Database.SaveResult[] saveResultsDEShares = Database.insert(deShares, false);

    }
    public static void UpdateRecordAccessGESOrderTasks(List<GC_Show_Team_Member__c> showTeamMembers, List<GC_GES_Order_Task__c> gots) {
        List<GC_GES_Order_Task__Share> gotShares = new List<GC_GES_Order_Task__Share>();

        for (GC_Show_Team_Member__c showTeamMember : showTeamMembers) {
            for (GC_GES_Order_Task__c got : gots) {
                if (got.Order__r.Connect2_Show__c != showTeamMember.Connect2_Show__c) {
                    continue;
                }

                String mapLookup = got.getSObjectType().getDescribe().getName() + ',' + showTeamMember.Show_Role__c;

                if (!mapAccessLevel.containsKey(mapLookup)) {
                    continue;
                }

                GC_GES_Order_Task__Share shareObject = new GC_GES_Order_Task__Share();
                shareObject.ParentId = got.Id;
                shareObject.UserOrGroupId = showTeamMember.User__c;
                shareObject.AccessLevel = mapAccessLevel.get(mapLookup);
                gotShares.add(shareObject);
            }
        }

        Database.SaveResult[] saveResultsGOTShares = Database.insert(gotShares, false);
    }

    public static void UpdateRecordAccessOrders(List<GC_Show_Team_Member__c> showTeamMembers, List<GC_Order__c> orders) {
        List<GC_Order__Share> orderShares = new List<GC_Order__Share>();

        for (GC_Show_Team_Member__c showTeamMember : showTeamMembers) {
            for (GC_Order__c order : orders) {
                if (order.Connect2_Show__c != showTeamMember.Connect2_Show__c) {
                    continue;
                }

                String mapLookup = order.getSObjectType().getDescribe().getName() + ',' + showTeamMember.Show_Role__c;

                if (!mapAccessLevel.containsKey(mapLookup)) {
                    continue;
                }

                GC_Order__Share shareObject = new GC_Order__Share();
                shareObject.ParentId = order.Id;
                shareObject.UserOrGroupId = showTeamMember.User__c;
                shareObject.AccessLevel = mapAccessLevel.get(mapLookup);
                orderShares.add(shareObject);
            }
        }

        Database.SaveResult[] saveResultsOrderShares = Database.insert(orderShares, false);
    }

    public static void UpdateRecordAccessVendorOrderTasks(List<GC_Show_Team_Member__c> showTeamMembers, List<GC_Vendor_Order_Task__c> vots) {
        List<GC_Vendor_Order_Task__Share> votShares = new List<GC_Vendor_Order_Task__Share>();

        for (GC_Show_Team_Member__c showTeamMember : showTeamMembers) {
            for (GC_Vendor_Order_Task__c vot : vots) {
                if (vot.Order__r.Connect2_Show__c != showTeamMember.Connect2_Show__c) {
                    continue;
                }

                String mapLookup = vot.getSObjectType().getDescribe().getName() + ',' + showTeamMember.Show_Role__c;

                if (!mapAccessLevel.containsKey(mapLookup)) {
                    continue;
                }

                GC_Vendor_Order_Task__Share shareObject = new GC_Vendor_Order_Task__Share();
                shareObject.ParentId = vot.Id;
                shareObject.UserOrGroupId = showTeamMember.User__c;
                shareObject.AccessLevel = mapAccessLevel.get(mapLookup);
                votShares.add(shareObject);
            }
        }

        Database.SaveResult[] saveResultsVOTShares = Database.insert(votShares, false);
    }

    public static void BeforeUpdateShowName(List<GC_Show_Team_Member__c> showTeamMembers) {
        Set<String> shows = new Set<String>();

        for (GC_Show_Team_Member__c showTeamMember : showTeamMembers) {
            shows.Add(showTeamMember.Connect2_Show__c);
        }

        Map<Id, GC_Connect2_Show__c> connect2Shows = new Map<Id, GC_Connect2_Show__c>([select Id, Show_Name__c From GC_Connect2_Show__c where Id in :shows]);

        for (GC_Show_Team_Member__c stm : showTeamMembers) {
            if (connect2Shows.containsKey(stm.Connect2_Show__c)) {
                stm.Show_Name_Text__c = connect2Shows.get(stm.Connect2_Show__c).Show_Name__c;
            }
        }
    }

    public static void UpdateShowTeamMemberIdsField(List<GC_Show_Team_Member__c> showTeamMembers, Boolean isDelete) {

        Map<Id, Set<String>> showIdToUserIds =  new Map<Id, Set<String>>();

        // Since we only have 255 characters in this field, we can hit limits if a lot of people are on the show.
        // We will limit the roles by excluding the large number of roles.
        Set<String> rolesToExclude = new Set<String>();
        rolesToExclude.add('Show Organizer');
        rolesToExclude.add('Vendor');
        rolesToExclude.add('Show Organizer - Read Only');
        rolesToExclude.add('Detailer');
        rolesToExclude.add('Designer');
        rolesToExclude.add('Designer/Detailer');

        for (GC_Show_Team_Member__c showTeamMember : showTeamMembers) {
            if (rolesToExclude.contains(showTeamMember.Show_Role__c)) {
                continue;
            }

            if (!showIdToUserIds.containsKey(showTeamMember.Connect2_Show__c)) {
                showIdToUserIds.put(showTeamMember.Connect2_Show__c, new Set<String>());
            }

            // ignore vendors / clients(Show Organizer - Read Only) / show organizers to reduce this number

            Set<String> showTeamMemberIds = showIdToUserIds.get(showTeamMember.Connect2_Show__c);
            showTeamMemberIds.add(showTeamMember.User__c);
        }

        //Convert Set<Id> to Set<String> for Dao call
        Set<String> showIdSet = new Set<String>(String.join(new List<Id>(showIdToUserIds.keySet()), ',').split(','));

        List<GC_Connect2_Show__c> shows = GC_Connect2ShowDao.getInstance().getShowsByIds(showIdSet);

        for (GC_Connect2_Show__c show : shows) {
            Set<String> userIds = showIdToUserIds.get(show.Id);

            for (String userId : userIds) {
                userId = userId + ',';
                String currentIds = show.Show_Team_Member_Ids__c;

                // If delete, remove user Id from comma separated list
                if (isDelete && currentIds != null) {
                    currentIds = currentIds.replace(userId, '');
                }
                // else add new Id to comma separated list
                else {
                    // If user Id field of length 255 has enough room to add another Id
                    if (String.isBlank(show.Show_Team_Member_Ids__c) || (show.Show_Team_Member_Ids__c.length() < 237 && !show.Show_Team_Member_Ids__c.contains(userId))) {
                        if (String.isBlank(show.Show_Team_Member_Ids__c)) {
                            currentIds = userId;
                        } else {
                            currentIds = currentIds + userId;
                        }
                    }
                }

                show.Show_Team_Member_Ids__c = currentIds;
            }
        }

        update shows;
    }

    public static void HandleShowTeamMemberDelete(List<GC_Show_Team_Member__c> oldStms) {
        Set<Id> showIds = new Set<Id>();
        Set<Id> userIds = new Set<Id>();
        Set<Id> gotIds = new Set<Id>();
        Set<Id> showAttIds = new Set<Id>();
        Set<Id> drfIds = new Set<Id>();
        Set<Id> deIds = new Set<Id>();
        Set<Id> drfBudgetIds = new Set<Id>();
        Set<Id> votIds = new Set<Id>();
        Set<Id> orderIds = new Set<Id>();
        Set<Id> stmIds = new Set<Id>();

        for (GC_Show_Team_Member__c stm : oldStms) {
            showIds.add(stm.Connect2_Show__c);
            userIds.add(stm.User__c);
        }

        // 12 SOQL Calls

        List<GC_Order__c> orders = [select Id, Name From GC_Order__c where Connect2_Show__c in :showIds];

        for (GC_Order__c order : orders) {
            orderIds.add(order.Id);
        }

        List<GC_Order__Share> orderShares = [select Id, ParentId, RowCause, UserOrGroupId, AccessLevel
                                             from GC_Order__Share
                                             where RowCause = 'Manual' AND UserOrGroupId in :userIds AND ParentId in :orderIds];

        List<GC_GES_Order_Task__c> gesOrderTasks = [select Id, Name from GC_GES_Order_Task__c where Order__c in :orderIds];

        for (GC_GES_Order_Task__c gesOrderTask : gesOrderTasks) {
            gotIds.add(gesOrderTask.Id);
        }

        List<GC_GES_Order_Task__Share> gesOrderTaskShares = [select Id, ParentId, RowCause, UserOrGroupId, AccessLevel
                from GC_GES_Order_Task__Share
                where RowCause = 'Manual' AND UserOrGroupId in :userIds AND ParentId in :gotIds];

        List<GC_Connect2_Show__Share> showShares = [select Id, ParentId, RowCause, UserOrGroupId, AccessLevel
                from GC_Connect2_Show__Share
                where RowCause = 'Manual' AND UserOrGroupId in :userIds AND ParentId in :showIds];

        List<GC_Show_Attribute__c> showAttributes = [select Id, Name from GC_Show_Attribute__c where Connect2_Show__c in :showIds];

        for (GC_Show_Attribute__c showAtt : showAttributes) {
            showAttIds.add(showAtt.Id);
        }

        List<GC_Show_Attribute__Share> showAttShares = [select Id, ParentId, RowCause, UserOrGroupId, AccessLevel
                from GC_Show_Attribute__Share
                where RowCause = 'Manual' AND UserOrGroupId in :userIds AND ParentId in :showAttIds];

        List<GC_Design_Request_Form__c> designRequestForms = [select Id, Name from GC_Design_Request_Form__c where Connect2_Show__c in :showIds];

        for (GC_Design_Request_Form__c drf : designRequestForms) {
            drfIds.add(drf.Id);
        }

        List<GC_Design_Request_Form__Share> drfShares = [select Id, ParentId, RowCause, UserOrGroupId, AccessLevel
                from GC_Design_Request_Form__Share
                where RowCause = 'Manual' AND UserOrGroupId in :userIds AND ParentId in :drfIds];

        List<GC_Design_Element__c> designElements = [select Id, Name from GC_Design_Element__c Where Design_Request_Form__c in :drfIds];

        for (GC_Design_Element__c de : designElements) {
            deIds.add(de.Id);
        }

        List<GC_Design_Element__Share> deShares = [select Id, ParentId, RowCause, UserOrGroupId, AccessLevel
                from GC_Design_Element__Share
                where RowCause = 'Manual' AND UserOrGroupId in :userIds AND ParentId in :deIds];

        List<GC_Design_Request_Form_Budget__c> drfBudgets = [select Id, Name from GC_Design_Request_Form_Budget__c where Design_Request_Form__c in :drfIds];

        for (GC_Design_Request_Form_Budget__c drfBudget : drfBudgets) {
            drfBudgetIds.add(drfBudget.Id);
        }

        List<GC_Design_Request_Form_Budget__Share> drfBudgetShares = [select Id, ParentId, RowCause, UserOrGroupId, AccessLevel
                from GC_Design_Request_Form_Budget__Share
                where RowCause = 'Manual' AND UserOrGroupId in :userIds AND ParentId in :drfBudgetIds];

        List<GC_Vendor_Order_Task__c> vendorOrderTasks = [select Id, Name from GC_Vendor_Order_Task__c where Order__c in :orderIds];

        for (GC_Vendor_Order_Task__c vot : vendorOrderTasks) {
            votIds.add(vot.Id);
        }

        List<GC_Vendor_Order_Task__Share> vendorOrderTaskShares = [select Id, ParentId, RowCause, UserOrGroupId, AccessLevel
                from GC_Vendor_Order_Task__Share
                where RowCause = 'Manual' AND UserOrGroupId in :userIds AND ParentId in :votIds];

        List<GC_Show_Team_Member__c> stmRecords = [select Id, Name from GC_Show_Team_Member__c where Connect2_Show__c in :showIds];

        for (GC_Show_Team_Member__c stmRecord : stmRecords) {
            stmIds.add(stmRecord.Id);
        }

        List<GC_Show_Team_Member__Share> stmShares = [select Id, ParentId, RowCause, UserOrGroupId, AccessLevel
                from GC_Show_Team_Member__Share
                where RowCause = 'Manual' AND UserOrGroupId in :userIds AND ParentId in :stmIds];

        Database.delete(orderShares, false);
        Database.delete(gesOrderTaskShares, false);
        Database.delete(showShares, false);
        Database.delete(showAttShares, false);
        Database.delete(drfShares, false);
        Database.delete(deShares, false);
        Database.delete(drfBudgetShares, false);
        Database.delete(vendorOrderTaskShares, false);
        Database.delete(stmShares, false);
    }

     public static void sendEmailNewShowTeamMemberAdd(List<GC_Show_Team_Member__c> showTeamMembers) {
        Set<String> shows = new Set<String>();
        List<String> vendors = new List<String>();
        List<String> showAttributes = new List<String>();
        String showName = '';
        String venEmail = '';
        String showAttName = '';
        Map<Id,String> vendorMemberMap = new Map<Id,String>();
        List<GC_Show_Team_Member__c> stmVendorsOnly = new List<GC_Show_Team_Member__c>();
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        EmailTemplate emailTemplate=[Select id,Subject, HtmlValue, Body from EmailTemplate where DeveloperName=:'WelcomeBack_Vendor'];

        for(GC_Show_Team_Member__c stm : showTeamMembers)
        {
            if(stm.Show_Role__c == 'Vendor')
            {
                stmVendorsOnly.add(stm);
            }
        }
        
        if(stmVendorsOnly.size() > 0)
        {
            
        

        for (GC_Show_Team_Member__c showTeamMember : stmVendorsOnly) {
            shows.Add(showTeamMember.Connect2_Show__c);
            vendors.Add(showTeamMember.User__c);
            showAttributes.add(showTeamMember.Service_Type__c);
             //system.debug('vendors'+showTeamMember.User__c);
             // system.debug('showTeamMember.User__r.Email'+showTeamMember.User__r.Email);

            // if(!vendorMemberMap.containsKey(showTeamMember.Id)){
            //    vendorMemberMap.put(showTeamMember.Id,showTeamMember.User__r.Email);
            //}
        }

        //system.debug('vendorMemberMap'+vendorMemberMap);

        Map<Id, GC_Connect2_Show__c> connect2Shows = new Map<Id, GC_Connect2_Show__c>([select Id, Name From GC_Connect2_Show__c where Id in :shows]);

        Map<Id, User> venUsers = new Map<Id, User>([select Id, Email,FirstName,Username From User where Id in :vendors]);
        Map<Id, GC_Show_Attribute__c> showAttMap = new Map<Id, GC_Show_Attribute__c>([select Name,Name_Unique__c From GC_Show_Attribute__c where Id in :showAttributes]);

        for (GC_Show_Team_Member__c stm : showTeamMembers) {
            if (connect2Shows.containsKey(stm.Connect2_Show__c)) {
                showName = connect2Shows.get(stm.Connect2_Show__c).Name;
            }

            if (venUsers.containsKey(stm.User__c)) {
                venEmail = venUsers.get(stm.User__c).Email;
            }

            if (showAttMap.containsKey(stm.Service_Type__c)) {
                showAttName = showAttMap.get(stm.Service_Type__c).Name;
            }

            system.debug('venEmail'+venEmail);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String htmlBody = emailTemplate.HtmlValue;
            String plainBody = emailTemplate.Body;
            //mail.setTemplateId(emailTemplate.Id);
            //mail.setTargetObjectId(stm.Id);
            htmlBody = htmlBody.replace('{!Receiving_User.FirstName}',venUsers.get(stm.User__c).FirstName);
            htmlBody = htmlBody.replace('{!GC_Connect2_Show__c.Show_Name__c}',showName);
            htmlBody = htmlBody.replace('[ATTRIBUTE]',showAttName);
            htmlBody = htmlBody.replace('{!Receiving_User.Username}',venUsers.get(stm.User__c).Username);
            htmlBody = htmlBody.replace('{!Community_Url}','https://ges.force.com/GESConnect');
                

            mail.setToAddresses(new String[] {venEmail});
            mail.setSaveAsActivity(false);
            mail.setSubject(emailTemplate.Subject);
            mail.setHtmlBody(htmlBody);
            //mail.setSubject('Vendor for Show'+showName);
            if(String.isNotBlank(venEmail)) 
            {
                mailList.add(mail);  
            }
        }

        if(mailList.size() > 0)
        {
            Messaging.sendEmail(mailList);
        }
        
        }

        
    }
}