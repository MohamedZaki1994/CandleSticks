//
//  ViewController.swift
//  CandleSticks
//
//  Created by Mohamed Zaki on 19/08/2022.
//

import UIKit
import Charts

class ViewController: UIViewController {
    lazy var candleChartView: CandleStickChartView = {
        let chartView = CandleStickChartView()
        chartView.backgroundColor = .systemBlue
        chartView.rightAxis.enabled = false
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        yAxis.labelPosition = .insideChart

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 12)
        xAxis.setLabelCount(6, force: false)
        xAxis.labelTextColor = .white
        xAxis.axisLineColor = .systemBlue

        return chartView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(candleChartView)
        candleChartView.translatesAutoresizingMaskIntoConstraints = false
        candleChartView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        candleChartView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        candleChartView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        candleChartView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        let request = NetworkHandler()
        request.request { result in
            switch result {
            case .success(let model):
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
                    self.yValue.append(value)
                }
                DispatchQueue.main.async {
                let set = CandleChartDataSet(entries: self.yValue, label: "price")
                let data = CandleChartData(dataSet: set)
                    self.candleChartView.data = data
                }
            case .failure(let error):
                print(error)
            }
        }
        let set = CandleChartDataSet(entries: setDataCount(10, range: 50), label: "price")
        let data = CandleChartData(dataSet: set)
        
        candleChartView.data = data
    }

    func setDataCount(_ count: Int, range: UInt32) -> [CandleChartDataEntry] {
        return [CandleChartDataEntry(x: 0.0, shadowH: 0, shadowL: 0.2, open: 0.01, close: 0.015),CandleChartDataEntry(x: 1.0, shadowH: 0.1, shadowL: 0.6, open: 0.9, close: 0.15)]
    }

    var yValue: [CandleChartDataEntry] = []
}


extension ViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
}
