# ExtensionMirror

```swift
class Person {
    var name: String = "left"
    var age: Int8 = 18
    var height: Float = 180
    var isAdult: Bool = true
    var weight: Double = 120.0
}

var person = Person()
print(person.weight)  // 120.0
Mirror.set(person, ptr: &person, value: "30", for: "weight")
print(person.weight)  // 30.0
```
