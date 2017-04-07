//
//  CacheLayer.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/4/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public typealias CacheLayerCompletion = (Data?) -> Void

public protocol CacheLayer {
    func store(data: Data, forURL url: URL)
    func retrieveData(forURL url: URL, completion: @escaping CacheLayerCompletion)
    func removeData(forURL url: URL)
    func removeAll()
}
