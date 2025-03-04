package hamster_commander

public func option_demo() {
    var s: Option<Student> = None


    if (s.isSome()) {
        println(s.getOrThrow().get_name())
    } else {
        println("s is None")
    }

    s = Student()
    if (s.isSome()) {
        println(s.getOrThrow().get_name())
    } else {
        println("s is None")
    }
}

public class Student {
    public func get_name(): String {
        return "John Doe"
    }
}
