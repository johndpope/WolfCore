//: Playground - noun: a place where people can play

import UIKit
import Foundation
import WolfCore

let s = "0123456789abcdef"
let b: Byte = 0x8e
let d = Data(bytes: [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef])

try s >>- Hex.init >>- Data.init
b >>- Hex.init
d >>- Hex.init >>- String.init
