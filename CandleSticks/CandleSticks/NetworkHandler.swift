//
//  NetworkHandler.swift
//  CandleSticks
//
//  Created by Mohamed Zaki on 20/08/2022.
//

import Foundation

class NetworkHandler {

    let url = "https://fapi.binance.com/fapi/v1/klines?symbol=BTCUSDT&interval=15m&lim"

    func request(completion: ((Result<CandleStickModel, Error>) -> Void)?) {
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
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
