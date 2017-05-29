//: Playground - noun: a place where people can play

import Cocoa


extension Mirror {
    
    static func headerPointerOfClass(obj: AnyObject) -> UnsafeMutablePointer<Int8> {
        let opaquePointer = Unmanaged.passUnretained(obj).toOpaque()
        let mutableTypedPointer = opaquePointer.bindMemory(to: Int8.self, capacity: MemoryLayout.stride(ofValue: obj))
        return UnsafeMutablePointer<Int8>(mutableTypedPointer)
    }
    
    static func getTypeAlignment(any: Any) -> Int {
        switch any {
        case is Int8:
            return MemoryLayout<Int8>.alignment
        case is Int16:
            return MemoryLayout<Int16>.alignment
        case is Int32:
            return MemoryLayout<Int32>.alignment
        case is Float:
            return MemoryLayout<Float>.alignment
        case is Double:
            return MemoryLayout<Double>.alignment
        case is String:
            return MemoryLayout<String>.alignment
        default:
            return 0
        }
    }
    
    static func getTypeSize(any: Any) -> Int {
        switch any {
        case is Int8:
            return MemoryLayout<Int8>.size
        case is Int16:
            return MemoryLayout<Int16>.size
        case is Int32:
            return MemoryLayout<Int32>.size
        case is Float:
            return MemoryLayout<Float>.size
        case is Double:
            return MemoryLayout<Double>.size
        case is String:
            return MemoryLayout<String>.size
        default:
            return 0
        }
    }
    
    static func process(obj: Any, value: String, for key: String, pointer: UnsafeMutableRawPointer) {
        var pointer = pointer
        let mirror = Mirror(reflecting: obj)
        for child in mirror.children {
            // add padding
            if pointer.debugDescription.hasPrefix("0x") {
                let hexAddress = String(pointer.debugDescription.characters.dropFirst(2))
                var decimalAddress = Int.init(hexAddress, radix: 16)!
                let alignment = getTypeAlignment(any: child.value)
                while decimalAddress % alignment != 0 {
                    decimalAddress += 1
                    pointer = pointer.advanced(by: 1)
                }
            }
            
            if let name = child.label, name == key {
                switch child.value {
                case is Int8:
                    let int8Ptr = pointer.assumingMemoryBound(to: Int8.self)
                    int8Ptr.pointee = Int8(value)!
                case is Int16:
                    let int16Ptr = pointer.assumingMemoryBound(to: Int16.self)
                    int16Ptr.pointee = Int16(value)!
                case is Int32:
                    let int32Ptr = pointer.assumingMemoryBound(to: Int32.self)
                    int32Ptr.pointee = Int32(value)!
                case is Float:
                    let floatPtr = pointer.assumingMemoryBound(to: Float.self)
                    floatPtr.pointee = Float(value)!
                case is Double:
                    let doublePtr = pointer.assumingMemoryBound(to: Double.self)
                    doublePtr.pointee = Double(value)!
                case is String:
                    let stringPtr = pointer.assumingMemoryBound(to: String.self)
                    stringPtr.pointee = String(value)!
                default:
                    print("type undefined")
                }
                
                break
            }
            
            let size = getTypeSize(any: child.value)
            pointer = pointer.advanced(by: size)
        }
    }
    
    static func set(_ obj: AnyObject, value: String, for key: String) {
        var pointer = UnsafeMutableRawPointer(headerPointerOfClass(obj: obj))
        pointer = pointer.advanced(by: 16)  // type + reference count
        process(obj: obj, value: value, for: key, pointer: pointer)
    }
}

class Person {
    var name: String = "left"
    var age: Int8 = 18
    var height: Float = 180
    var weight: Double = 120.0
}


var person = Person()
print(person.height)
Mirror.set(person, value: "0", for: "height")
print(person.height)

