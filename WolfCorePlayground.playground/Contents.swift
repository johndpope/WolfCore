//: Playground - noun: a place where people can play

import UIKit
import Foundation
import WolfCore

let bytes: [Byte] = Array(150..<200)
let data = Data(bytes: bytes)
let base64 = data |> Base64.init
let data2 = base64 |> Data.init

let base64URL = data |> Base64URL.init
let data3 = base64URL |> Data.init

data2 == data3
