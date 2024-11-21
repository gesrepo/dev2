@isTest
private class GC_ShowTeamMemberValidationRulesTest {

    // Does not work due to SOQL limit error
    //@isTest static void testValidationRulesSysAdmin() {
    //    GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
    //    User stmUser = GC_TestUtils.createUser('System Administrator', 'test', 'test');
    //    stmUser.GC_Show_Role__c = 'GC Account Manager;GC Traffic Administrator;GC Creative Director;GC Detailer;GC Director of Account Management;GC Graphics Project Manager;GC Sales Manager';
    //    update stmUser;

    //    Schema.DescribeFieldResult fieldResult = GC_Show_Team_Member__c.Show_Role__c.getDescribe();
    //    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    //    List<GC_Show_Team_Member__c> stmsToInsert = new List<GC_Show_Team_Member__c>();
    //    for (Schema.PicklistEntry f : ple) {
    //        GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
    //        stm.Connect2_Show__c = show.Id;
    //        stm.Show_Role__c = f.getValue();
    //        stm.User__c = stmUser.Id;

    //        try {
    //            insert stm;
    //        }
    //        catch (Exception e) {
    //        }

    //    }

    //}

    // we might need to split this up for limits
    @isTest static void testValidationRulesAM() {
        User sysAdminUser = GC_TestUtils.createUser('System Administrator', 'test', 'sysadmin');
        System.runAs(sysAdminUser) {
            GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
            User stmUser = GC_TestUtils.createUser('GC Account Manager', 'test', 'test');
            Schema.DescribeFieldResult fieldResult = GC_Show_Team_Member__c.Show_Role__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            //Account Manager
            //Sales Manager
            //Director of Account Management
            //Creative Director
            //Graphics Project Manager
            //Designer/Detailer
            //Secondary Account Manager
            //Traffic Administrator
            //Show Organizer
            //Client (Show Organizer - Read Only)
            //Vendor

            for (Schema.PicklistEntry f : ple) {
                GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
                stm.Connect2_Show__c = show.Id;
                stm.Show_Role__c = f.getValue();
                stm.User__c = stmUser.Id;

                try {
                    insert stm;
                } catch (Exception e) {
                    System.assertEquals(f.getValue() == 'Account Manager' || f.getValue() == 'Sales Manager', false);
                }
            }

            List<GC_Show_Team_Member__c> actualMembers = [select Id, Show_Role__c from GC_Show_Team_Member__c];
            System.debug('testValidationRulesAM Actual Members: ' + JSON.serialize(actualMembers));
            System.assertEquals(4, actualMembers.size(), 'Should have account manager / secondary account manager / sales manager / Show Organizer');
        }
    }

    @isTest static void testValidationRulesSM() {
        User sysAdminUser = GC_TestUtils.createUser('System Administrator', 'test', 'sysadmin');
        System.runAs(sysAdminUser) {
            GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
            User stmUser = GC_TestUtils.createUser('GC Sales Manager', 'test', 'test');
            Schema.DescribeFieldResult fieldResult = GC_Show_Team_Member__c.Show_Role__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

            for (Schema.PicklistEntry f : ple) {
                GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
                stm.Connect2_Show__c = show.Id;
                stm.Show_Role__c = f.getValue();
                stm.User__c = stmUser.Id;

                try {
                    insert stm;
                } catch (Exception e) {
                    System.assertEquals(f.getValue() == 'Account Manager' || f.getValue() == 'Sales Manager', false);
                }
            }

            List<GC_Show_Team_Member__c> actualMembers = [select Id, Show_Role__c from GC_Show_Team_Member__c];
            System.debug('testValidationRulesSM Actual Members: ' + JSON.serialize(actualMembers));
            System.assertEquals(4, actualMembers.size(), 'Should have account manager / secondary account manager / sales manager / show organizer');
        }
    }

    @isTest static void testValidationRulesCD() {
        User sysAdminUser = GC_TestUtils.createUser('System Administrator', 'test', 'sysadmin');
        System.runAs(sysAdminUser) {
            GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
            User stmUser = GC_TestUtils.createUser('GC Creative Director', 'test', 'test');
            Schema.DescribeFieldResult fieldResult = GC_Show_Team_Member__c.Show_Role__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

            for (Schema.PicklistEntry f : ple) {
                GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
                stm.Connect2_Show__c = show.Id;
                stm.Show_Role__c = f.getValue();
                stm.User__c = stmUser.Id;

                try {
                    insert stm;
                } catch (Exception e) {
                    System.assertEquals(f.getValue() == 'Creative Director', false);
                }
            }

            List<GC_Show_Team_Member__c> actualMembers = [select Id, Show_Role__c from GC_Show_Team_Member__c];
            System.debug('testValidationRulesCD Actual Members: ' + JSON.serialize(actualMembers));
            System.assertEquals(1, actualMembers.size());
        }

    }

    @isTest static void testValidationRulesTA() {
        User sysAdminUser = GC_TestUtils.createUser('System Administrator', 'test', 'sysadmin');
        System.runAs(sysAdminUser) {
            GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
            User stmUser = GC_TestUtils.createUser('GC Traffic Administrator', 'test', 'test');
            Schema.DescribeFieldResult fieldResult = GC_Show_Team_Member__c.Show_Role__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

            for (Schema.PicklistEntry f : ple) {
                GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
                stm.Connect2_Show__c = show.Id;
                stm.Show_Role__c = f.getValue();
                stm.User__c = stmUser.Id;

                try {
                    insert stm;
                } catch (Exception e) {
                    System.assertEquals(f.getValue() == 'Traffic Administrator', false);
                }
            }

            List<GC_Show_Team_Member__c> actualMembers = [select Id, Show_Role__c from GC_Show_Team_Member__c ];
            System.debug('testValidationRulesTA Members: ' + JSON.serialize(actualMembers));
            System.assertEquals(1, actualMembers.size());
        }

    }

    @isTest static void testValidationRulesDAM() {
        User sysAdminUser = GC_TestUtils.createUser('System Administrator', 'test', 'sysadmin');
        System.runAs(sysAdminUser) {

            GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
            User stmUser = GC_TestUtils.createUser('GC Director of Account Management', 'test', 'test');
            Schema.DescribeFieldResult fieldResult = GC_Show_Team_Member__c.Show_Role__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

            for (Schema.PicklistEntry f : ple) {
                GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
                stm.Connect2_Show__c = show.Id;
                stm.Show_Role__c = f.getValue();
                stm.User__c = stmUser.Id;

                try {
                    insert stm;
                } catch (Exception e) {
                    System.assertEquals(f.getValue() == 'Director of Account Management', false);
                }
            }

            List<GC_Show_Team_Member__c> actualMembers = [select Id, Show_Role__c from GC_Show_Team_Member__c];
            System.debug('testValidationRulesDAM Members: ' + JSON.serialize(actualMembers));
            System.assertEquals(1, actualMembers.size());

        }
    }

    @isTest static void testValidationRulesDET() {
        User sysAdminUser = GC_TestUtils.createUser('System Administrator', 'test', 'sysadmin');
        System.runAs(sysAdminUser) {
            GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
            User stmUser = GC_TestUtils.createUser('GC Detailer', 'test', 'test');
            Schema.DescribeFieldResult fieldResult = GC_Show_Team_Member__c.Show_Role__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

            for (Schema.PicklistEntry f : ple) {
                GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
                stm.Connect2_Show__c = show.Id;
                stm.Show_Role__c = f.getValue();
                stm.User__c = stmUser.Id;

                try {
                    insert stm;
                } catch (Exception e) {
                    System.assertEquals(f.getValue() == 'Detailer', false);
                }
            }

            List<GC_Show_Team_Member__c> actualMembers = [select Id, Show_Role__c from GC_Show_Team_Member__c];
            System.debug('testValidationRulesDET Members: ' + JSON.serialize(actualMembers));
            System.assertEquals(1, actualMembers.size());

        }
    }

    @isTest static void testValidationRulesGPM() {
        User sysAdminUser = GC_TestUtils.createUser('System Administrator', 'test', 'sysadmin');
        System.runAs(sysAdminUser) {
            DateTime startTest = DateTime.now();
            GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
            User stmUser = GC_TestUtils.createUser('GC Graphics Project Manager', 'test', 'test');
            Schema.DescribeFieldResult fieldResult = GC_Show_Team_Member__c.Show_Role__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

            for (Schema.PicklistEntry f : ple) {
                GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
                stm.Connect2_Show__c = show.Id;
                stm.Show_Role__c = f.getValue();
                stm.User__c = stmUser.Id;

                try {
                    insert stm;
                } catch (Exception e) {
                    System.assertEquals(false, (f.getValue() == 'Graphics Project Manager' || f.getValue() == 'Graphics Project Manager Direct'));
                }
            }

            List<GC_Show_Team_Member__c> actualMembers = [select Id, Show_Role__c from GC_Show_Team_Member__c];
            System.debug('testValidationRulesGPM Members: ' + JSON.serialize(actualMembers));
            System.assertEquals(2, actualMembers.size());
        }
    }

    @isTest static void testValidationRulesClient() {

        User sysAdminUser = GC_TestUtils.createUser('System Administrator', 'test', 'sysadmin');
        sysAdminUser.UserRoleId = UserInfo.getUserRoleId();
        update sysAdminUser;
        System.runAs(sysAdminUser) {

            GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
            User stmUser = GC_TestUtils.getPortalUsers().get('GC Community Client');
            Schema.DescribeFieldResult fieldResult = GC_Show_Team_Member__c.Show_Role__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

            for (Schema.PicklistEntry f : ple) {
                GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
                stm.Connect2_Show__c = show.Id;
                stm.Show_Role__c = f.getValue();
                stm.User__c = stmUser.Id;

                try {
                    insert stm;
                } catch (Exception e) {
                    System.debug('testValidationRulesClient message was: ' + e.getMessage());
                    System.assertEquals(f.getValue() == 'Show Organizer' || f.getValue() == 'Show Organizer - Read Only', false, 'Expected to not have Show Organizer or Client, but value was: ' + f.getValue());
                }
            }

            List<GC_Show_Team_Member__c> actualMembers = [select Id, Show_Role__c from GC_Show_Team_Member__c];
            System.debug('testValidationRulesClient Members: ' + JSON.serialize(actualMembers));

            System.assertEquals(2, actualMembers.size()); // client (Show Organizer - Read Only)and show organizer
        }
    }

    @isTest static void testValidationRulesVendor() {
        DateTime startTest = DateTime.now();
        User sysAdminUser = GC_TestUtils.createUser('System Administrator', 'test', 'sysadmin');
        sysAdminUser.UserRoleId = UserInfo.getUserRoleId();
        update sysAdminUser;
        System.runAs(sysAdminUser) {

            GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
            User stmUser = GC_TestUtils.getPortalUsers().get('GC Community Vendor');
            Schema.DescribeFieldResult fieldResult = GC_Show_Team_Member__c.Show_Role__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

            for (Schema.PicklistEntry f : ple) {
                GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
                stm.Connect2_Show__c = show.Id;
                stm.Show_Role__c = f.getValue();
                stm.User__c = stmUser.Id;

                try {
                    insert stm;
                } catch (Exception e) {
                    System.assertEquals(f.getValue() == 'Vendor', false);
                }
            }

            List<GC_Show_Team_Member__c> actualMembers = [select Id, Show_Role__c from GC_Show_Team_Member__c];
            System.debug('testValidationRulesVendor Members: ' + JSON.serialize(actualMembers));
            System.assertEquals(1, actualMembers.size());
        }
    }

}