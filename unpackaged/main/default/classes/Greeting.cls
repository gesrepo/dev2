public class Greeting {
    public String sayHi() {
        return 'Hi!';
    }

    public String sayHello() {
        return 'Hey!';
    }public String greet(String name) {
        if (String.isBlank(name)) {
            return 'Hello, Guest!';
        } else {
            return 'Hello, ' + name + '!';
        }
    }
}