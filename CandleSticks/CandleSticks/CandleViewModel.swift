//
//  CandleViewModel.swift
//  CandleSticks
//
//  Created by Mohamed Zaki on 20/08/2022.
//

import Foundation
import Charts

class CandleViewModel {
    let request = NetworkHandler()
    var yValue: Observable<[CandleChartDataEntry]> = Observable([])

    func fetchData() {
        request.request { result in
            switch result {
            case .success(let model):
                var values: [CandleChartDataEntry] = [CandleChartDataEntry]()
                var open: Double = 0.0
                var close: Double = 0.0
                var high: Double = 0.0
                var low: Double = 0.0
                model.enumerated().forEach {index, array in
                    if case .string(let str) = array[1] {
                        open = Double(str)!
                    }
                    if case .string(let str) = array[2] {
                        high = Double(str)!
                    }
                    if case .string(let str) = array[3] {
                        low = Double(str)!
                    }
                    if case .string(let str) = array[4] {
                        close = Double(str)!
                    }
                    let value = CandleChartDataEntry(x: Double(index), shadowH: high, shadowL: low, open: open, close: close)
                    values.append(value)
                }
                self.yValue.value = values
            case .failure(let error):
                print(error)
            }
        }
    }
}
