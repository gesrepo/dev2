/*
 *  Test Class for LargeSelectList
 */
@isTest
public class LargeSelectListTest {
    
    @isTest 
    static void  LargeSelectListTest(){
        LargeSelectList  lsl = new LargeSelectList();
        List<SelectOption> options = new List<SelectOption>();
        SelectOption op1 = new SelectOption('', 'None');
        lsl.add(op1);
        options.add(op1);
        
        for (Integer i = 1; i <= 1199; i++) {
            lsl.add(new SelectOption('', 'Test Option' + String.valueOf(i)));
            options.add(new SelectOption('', 'Test Option' + String.valueOf(i)));
        }
        //test1
        System.assertEquals(1200, lsl.getSize());
        
        //test2
        System.assertEquals(op1, lsl.get(0));
        System.assertEquals(null, lsl.get(1201));
        
        //test3
        System.assertEquals(options, lsl.getSelectList());
        
        //test4
        lsl.getNthSubList(0);
        System.assertEquals(new List<SelectOption>(), lsl.getNthSubList(3));
        
        lsl.get0();
        lsl.get1();
        lsl.remove(0);
        lsl.clear();
    }
}