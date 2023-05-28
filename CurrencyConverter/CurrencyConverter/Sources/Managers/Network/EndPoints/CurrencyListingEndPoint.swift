//
//  CurrencyListingEndPoint.swift
//  CurrencyConverter
//
//  Created by Vikas Salian on 14/05/23.
//

import Foundation

struct CurrencyListingEndPoint: Endpoint {
    var httpMethod: HTTPMethod { .get }
    let baseURL: URL = URL(string: "https://openexchangerates.org")!
    let path = "/api/currencies.json"
    var queryParameters: [String: Any]?

    init(queryParameters: [String: Any]?) {
        self.queryParameters = queryParameters
    }

}
