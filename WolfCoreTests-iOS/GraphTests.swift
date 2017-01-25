//
//  GraphTests.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/10/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import XCTest
@testable import WolfCore

class GraphTests: XCTestCase {
    func test1() {
        var graph = Graph(label: "Test", defaultNodeValue: "", defaultEdgeValue: "")
        let a = graph += "a"
        let b = graph += "b"
        let c = graph += "c"
        let d = graph += "d"
        let e = graph += "e"
        let f = graph += "f"
        let g = graph += "g"
        let h = graph += "h"
        let i = graph += "i"
        let j = graph += "j"
        graph += (a, [b, f, h])
        graph += (b, [c, a])
        graph += (c, [d, b])
        graph += (d, [e])
        graph += (e, [d])
        graph += (f, [g])
        graph += (g, [f, d])
        graph += (h, [i])
        graph += (i, [h, j, e, c])
        graph += (j, [])

        print("Graph:")
        print(graph.dotFormat())

        let nodeComponents = try! graph.strongComponents()
        let n = nodeComponents.map { (node, componentIndex) in
            return (componentIndex, graph.label(of: node)!)
        }
        let sortedComponents = n.sorted(by:<)

        print("Strongly connected components:")
        for (componentIndex, label) in sortedComponents {
            print("\(label): \(componentIndex)")
        }
    }

    func test2() {
        var graph = Graph(label: "Test", defaultNodeValue: "", defaultEdgeValue: "")

        let a = graph += "a"
        let b = graph += "b"
        let c = graph += "c"
        let d = graph += "d"
        let e = graph += "e"

        graph += (a, b, "ab")
        graph += (a, c, "ac")
        graph += (c, d, "cd")
        graph += (c, b, "cb")
        graph += (b, e, "be")

        print("Original graph:")
        print(graph.dotFormat())

        let g2 = graph.transitiveClosure()
        print("Transitive closure:")
        print(g2.dotFormat())
    }
}
