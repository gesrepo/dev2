@isTest
public class TestMultiselectController
{
    @isTest
    static void testcomponent()
    {
        MultiselectController m=new MultiselectController();        
        Selectoption s1 = new SelectOption('adad','asdasda');
        Selectoption s2 = new SelectOption('adad','asdasda');        
        m.leftOptions = new list<SelectOption>{s1,s2};
        m.rightOptions = new list<SelectOption>{s1,s2};
        m.leftOptionsHidden = 'sdefdfs';
        m.rightOptionsHidden = 'dsffsdf';
    }
}