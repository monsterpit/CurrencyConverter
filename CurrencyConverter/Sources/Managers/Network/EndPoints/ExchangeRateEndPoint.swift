//
//  ExchangeRateEndPoint.swift
//  CurrencyConverter
//
//  Created by Vikas Salian on 14/05/23.
//

import Foundation

struct ExchangeRateEndPoint: Endpoint {

    var httpMethod: HTTPMethod { .get }
    var queryParameters: [String: Any]?
    var baseURL: URL = URL(string: "https://openexchangerates.org")!
    var path = "/api/latest.json"

    init(queryParameters: [String: Any]?) {
        self.queryParameters = queryParameters
    }

}
