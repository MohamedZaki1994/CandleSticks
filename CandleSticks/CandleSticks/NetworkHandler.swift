//
//  NetworkHandler.swift
//  CandleSticks
//
//  Created by Mohamed Zaki on 20/08/2022.
//

import Foundation

class NetworkHandler {

    let baseURL = "https://fapi.binance.com"
    let path = "/fapi/v1/klines"

    func request(symbolParameter: String, completion: ((Result<CandleStickModel, Error>) -> Void)?) {
        var urlComponent = URLComponents(string: baseURL)!
        urlComponent.path = path
        urlComponent.queryItems = [
            URLQueryItem(name: "symbol", value: symbolParameter),
            URLQueryItem(name: "interval", value: "15m")
        ]
        URLSession.shared.dataTask(with: urlComponent.url!) { data, response, error in
            guard let data = data else {
                guard let error = error else {
                    return
                }
                completion?(.failure(error))
                return
            }
            do {
                let model = try JSONDecoder().decode(CandleStickModel.self, from: data)
                completion?(.success(model))
            }
            catch {
                completion?(.failure(error))
            }
        }.resume()
    }
}
