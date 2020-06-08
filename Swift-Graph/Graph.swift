//
//  Graph.swift
//  GraphADT
//
//  Created by Dan Mitu on 6/7/20.
//  Copyright © 2020 Dan Mitu. All rights reserved.
//

import Foundation

class Vertex<T> {
    
    init(_ data: T) {
        self.data = data
    }
    
    let key: String = UUID().uuidString
    var data: T
    var edgeList: [Edge<T>] = []
}

class Edge<T> {
    
    init(weight: Int? = nil, to vertex: Vertex<T>? = nil) {
        self.weight = weight
        self.vertex = vertex
    }
    
    weak var vertex: Vertex<T>!
    var weight: Int?
}

class Graph<T> {

    private var vertexDict = [String : Vertex<T>]()
    
    // O(|V|)
    var vertices: [Vertex<T>] {
        Array(vertexDict.values)
    }
    
    // O(1)
    func add(_ vertex: Vertex<T>) {
        vertexDict[vertex.key] = vertex
    }
    
    // O(1)
    func vertex(for key: String) -> Vertex<T>! {
        vertexDict[key]
    }
    
    // O(1)
    func addEdge(from a: Vertex<T>, to b: Vertex<T>, weight: Int? = nil) {
        precondition(contains(a) && contains(b))
        let edge = Edge(weight: weight, to: b)
        a.edgeList.append(edge)
    }
    
    // O(1)
    func contains(_ vertex: Vertex<T>) -> Bool {
        vertexDict[vertex.key] != nil
    }
    
    // O(|E| + O|V|)
    func remove(_ vertex: Vertex<T>) {
        vertexDict[vertex.key] = nil
        vertices.forEach { v in
            v.edgeList.indices.forEach { i in
                let e = v.edgeList[i]
                if e.vertex == nil {
                    v.edgeList.remove(at: i)
                }
            }
        }
    }
    
    // MARK: - Traversal
    
    // O(|V|)
    func breadthFirstTraversal(from vertex: Vertex<T>?, _ onVisit: (T)->Void) {
        guard let vertex = vertex ?? vertexDict.randomElement()?.value else { return }
        
        var visited = Set<String>()
        let queue = NSMutableOrderedSet()
        queue.add(vertex)
        breadthFirstTraversal(queue: queue, visited: &visited, onVisit: onVisit)
    }
    
    private func breadthFirstTraversal(queue: NSMutableOrderedSet, visited: inout Set<String>, onVisit: (T)->Void) {
        guard queue.count > 0 else { return }
        
        // dequeue
        let vertex = queue.object(at: 0) as! Vertex<T>
        queue.removeObject(at: 0)
        // mark as visited
        visited.insert(vertex.key)
        onVisit(vertex.data)
        
        // add any vertices to qeuue that 1) aren't already visited, and 2) aren't already enqueued
        for edge in vertex.edgeList where !visited.contains(edge.vertex!.key) && !queue.contains(edge.vertex!) {
            queue.add(edge.vertex!)
        }
        
        breadthFirstTraversal(queue: queue, visited: &visited, onVisit: onVisit)
    }
    
    // O(|V|)
    func depthFirstTraversal(from vertex: Vertex<T>?, _ onVisit: (T)->Void) {
        guard let vertex = vertex ?? vertexDict.randomElement()?.value else { return }
        var visited = Set<String>()
        visited.insert(vertex.key)
        depthFirstTraversal(from: vertex, visited: &visited, onVisit: onVisit)
    }
    
    private func depthFirstTraversal(from vertex: Vertex<T>, visited: inout Set<String>, onVisit: (T)->Void) {
        visited.insert(vertex.key)
        onVisit(vertex.data)
        for edge in vertex.edgeList where !visited.contains(edge.vertex!.key) {
            depthFirstTraversal(from: edge.vertex, visited: &visited, onVisit: onVisit)
        }
    }
    
}


