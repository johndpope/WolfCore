//
//  StoreManager.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/20/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import StoreKit

public var storeManager = StoreManager()

public class StoreManager: NSObject {
    fileprivate override init() { }

    public typealias ProductsBlock = (SKProductsResponse) -> Void
    private var productsRequest: SKProductsRequest!
    fileprivate var productsResponse: SKProductsResponse!
    fileprivate var productsCompletionBlock: ProductsBlock!

    public func retriveProducts(for identifiers: Set<String>, completion: @escaping ProductsBlock) {
        assert(productsCompletionBlock == nil)

        productsCompletionBlock = completion

        productsRequest = SKProductsRequest(productIdentifiers: identifiers)
        productsRequest.delegate = self
        productsRequest.start()
    }
}

extension StoreManager: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        productsResponse = response

        //print(response.json.prettyString)

        productsCompletionBlock(response)
        productsCompletionBlock = nil
    }
}

extension SKProduct: JSONRepresentable {
    public var json: JSON {
        return JSON([
            "localizedDescription": localizedDescription,
            "localizedTitle": localizedTitle,
            "price": price,
            "priceLocale": priceLocale,
            "productIdentifier": productIdentifier,
            "isDownloadable": isDownloadable,
            "downloadContentLengths": downloadContentLengths,
            "downloadContentVersion": downloadContentVersion
            ])
    }
}

extension SKProductsResponse {
    public var json: JSON {
        return JSON([
            "products": products,
            "invalidProductIdentifiers": invalidProductIdentifiers
        ])
    }
}
