//
//  GraphADTTests.swift
//  GraphADTTests
//
//  Created by Dan Mitu on 6/7/20.
//  Copyright © 2020 Dan Mitu. All rights reserved.
//

import XCTest
@testable import Swift_Graph

class GraphTests: XCTestCase {

    typealias G = Graph<Int>
    typealias V = Vertex<Int>
    
    func testAddVertex() {
        let g = G()
        g.add(V(1))
        g.add(V(2))
        g.add(V(3))
        g.add(V(4))
        let expectation = Set([1, 2, 3, 4])
        let result = Set(g.vertices.map { $0.data })
        XCTAssertEqual(expectation, result)
    }
    
    func testGetVertex() {
        let g = G()
        let v1 = V(1)
        g.add(v1)
        let result = g.vertex(for: v1.key)
        XCTAssert(v1 === result)
    }
    
    func testAddEdge() {
        let g = G()
        let v1 = V(1)
        let v2 = V(2)
        g.add(v1)
        g.add(v2)
        g.addEdge(from: v1, to: v2)
        XCTAssertEqual(v1.edgeList.count, 1)
        let edge = v1.edgeList.first!
        let edgeVertex = edge.vertex
        XCTAssert(v2 === edgeVertex)
    }
    
    func testRemoveVertex() {
        let g = G()
        let v1 = V(1); g.add(v1)
        let v2 = V(2); g.add(v2)
        let v3 = V(3); g.add(v3)
        g.addEdge(from: v1, to: v2)
        g.addEdge(from: v2, to: v3)
        g.addEdge(from: v3, to: v1)
        g.remove(v1)
        XCTAssert(v2.edgeList.count == 1)
        XCTAssert(v3.edgeList.count == 1)
    }
    
    /// Test: Each vertex is visited.
    func testBFT1() {
        let g = G()
        let v1 = V(1)
        let v2 = V(2)
        let v3 = V(3)
        g.add(v1)
        g.add(v2)
        g.add(v3)
        g.addEdge(from: v1, to: v2)
        g.addEdge(from: v2, to: v3)
        g.addEdge(from: v3, to: v1)
        var expectedVisits = Set([1, 2, 3])
        g.breadthFirstTraversal(from: v1, {
            XCTAssert(expectedVisits.contains($0))
            expectedVisits.remove($0)
        })
        XCTAssert(expectedVisits.isEmpty)
    }
    
    /// Test: Traversed in order.
    func testBFT2() {
        /**
         Create an even and odd path. Make sure that each time a vertex is visited, it switches between even and odd.
         */
        let g = G()
        let v0 = V(0); g.add(v0)
        let v1 = V(1); g.add(v1)
        let v2 = V(2); g.add(v2)
        let v3 = V(3); g.add(v3)
        let v4 = V(4); g.add(v4)
        let v5 = V(5); g.add(v5)
        let v6 = V(6); g.add(v6)
        // Odd path
        g.addEdge(from: v0, to: v1)
        g.addEdge(from: v1, to: v3)
        g.addEdge(from: v3, to: v5)
        // Even path
        g.addEdge(from: v0, to: v2)
        g.addEdge(from: v2, to: v4)
        g.addEdge(from: v4, to: v6)
        
        var oddOrder = [1, 3, 5]
        var foundEven: Bool = false
        var evenOrder = [2, 4, 6]
        var foundOdd: Bool = false
        
        // We should get odd, even, odd, even, and so on
        g.breadthFirstTraversal(from: v0, { int in
            if int == 0 {
                return
            } else if int % 2 == 0 { // EVEN
                XCTAssert(!foundEven)
                foundEven = true
                foundOdd = false
                XCTAssert(evenOrder.removeFirst() == int)
            } else if int % 2 == 1 { // ODD
                XCTAssert(!foundOdd)
                foundEven = false
                foundOdd = true
                XCTAssert(oddOrder.removeFirst() == int)
            }
        })
        XCTAssert(oddOrder.isEmpty)
        XCTAssert(evenOrder.isEmpty)
    }
    
    /// Test that each node is visited once and only once using DFT.
    func testDFT1() {
        let g = G()
        let v1 = V(1); g.add(v1)
        let v2 = V(2); g.add(v2)
        let v3 = V(3); g.add(v3)
        let v4 = V(4); g.add(v4)
        let v5 = V(5); g.add(v5)
        g.addEdge(from: v1, to: v5)
        g.addEdge(from: v5, to: v1)
        g.addEdge(from: v1, to: v4)
        g.addEdge(from: v4, to: v1)
        g.addEdge(from: v2, to: v5)
        g.addEdge(from: v5, to: v2)
        g.addEdge(from: v2, to: v4)
        g.addEdge(from: v4, to: v2)
        g.addEdge(from: v3, to: v5)
        g.addEdge(from: v5, to: v3)
        g.addEdge(from: v3, to: v4)
        g.addEdge(from: v4, to: v3)
        var expectedResults = Set([1, 2, 3, 4, 5])
        g.depthFirstTraversal(from: v1, { int in
            print(int)
            XCTAssertNotNil(expectedResults.remove(int))
        })
        XCTAssert(expectedResults.isEmpty)
    }
    
    /// Test that a depth first traversal is performed
    func testDFT2() {
        let g = G()
        let v0 = V(0); g.add(v0)
        let v1 = V(1); g.add(v1)
        let v2 = V(2); g.add(v2)
        let v3 = V(3); g.add(v3)
        let v4 = V(4); g.add(v4)
        g.addEdge(from: v0, to: v1)
        g.addEdge(from: v1, to: v3)
        g.addEdge(from: v0, to: v2)
        g.addEdge(from: v2, to: v4)
        var oddFirst: Bool?
        var oddOrder = [1, 3]
        var evenOrder = [2, 4]
        g.depthFirstTraversal(from: v0, { int in
            if int == 0 {
                return
            } else if int % 2 == 0 { // EVEN
                if oddFirst == nil { oddFirst = false }
                if oddFirst! { XCTAssert(oddOrder.isEmpty) }
                XCTAssert(evenOrder.removeFirst() == int)
            } else if int % 2 == 1 { // ODD
                if oddFirst == nil { oddFirst = true }
                if !oddFirst! { XCTAssert(evenOrder.isEmpty) }
                XCTAssert(oddOrder.removeFirst() == int)
            }
        })
        XCTAssert(oddOrder.isEmpty && evenOrder.isEmpty)
    }
    
}
