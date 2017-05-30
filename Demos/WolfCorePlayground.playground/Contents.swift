//: Playground - noun: a place where people can play

import UIKit
import WolfCore

class Animal: Hashable, CustomStringConvertible {
    let name: String

    init(name: String) {
        self.name = name
    }

    var hashValue: Int {
        return name.hashValue
    }

    static func == (lhs: Animal, rhs: Animal) -> Bool {
        return lhs.name == rhs.name
    }

    var description: String {
        return name
    }
}

var dog: Animal! = Animal(name: "dog")
var cat: Animal! = Animal(name: "cat")
var giraffe: Animal! = Animal(name: "giraffe")

var animals = WeakSet<Animal>()

animals.insert(dog)
animals.insert(cat)
animals.insert(giraffe)
print ("After initial inserts:")
for animal in animals { print(animal) }

// Prints:
//    After initial inserts:
//    giraffe
//    cat
//    dog

giraffe = nil
print ("After giraffe becomes nil:")
for animal in animals { print(animal) }

// Prints:
//    After giraffe becomes nil:
//    cat
//    dog

animals.remove(dog)
print ("After removing dog:")
for animal in animals { print(animal) }

// Prints:
//    After removing dog:
//    cat

cat = nil
print ("After cat becomes nil:")
for animal in animals { print(animal) }

// Prints:
//    After cat becomes nil:
