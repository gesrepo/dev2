@isTest
public class GreetingTest {
    @isTest
    static void testSayHi() {
        Greeting greeting = new Greeting();
        String result = greeting.sayHi();
        System.assertEquals('Hi!', result);
    }

    /*
    @isTest
    static void testSayHello() {
    Greeting greeting = new Greeting();
        String result = greeting.sayHello();
        System.assertEquals('Hey!', result);
    }

    @isTest
    static void testSayGoodbye() {
       Greeting greeting = new Greeting();
        String result = greeting.sayGoodbye();
        System.assertEquals('Goodbye!', result);
    }

    @isTest
    static void testGreetWithName() {
        Greeting greeting = new Greeting();
        String result = greeting.greet('John');
        System.assertEquals('Hello, John!', result);
    }

    @isTest
    static void testGreetWithoutName() {
        Greeting greeting = new Greeting();
        String result = greeting.greet('');
        System.assertEquals('Hello, Guest!', result);
    }
    */
}