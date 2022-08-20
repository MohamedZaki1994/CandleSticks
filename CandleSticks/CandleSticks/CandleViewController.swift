//
//  CandleViewController.swift
//  CandleSticks
//
//  Created by Mohamed Zaki on 19/08/2022.
//

import UIKit
import Charts

class CandleViewController: UIViewController {
    let viewModel = CandleViewModel()
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
        embedView()
        viewModel.fetchData()
        viewModel.yValue.bind { values in
            guard let values = values else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                let set = CandleChartDataSet(entries: values, label: "price")
                let data = CandleChartData(dataSet: set)
                self?.candleChartView.data = data
            }
        }
        viewModel.hasError?.bind({ [weak self] hasError in
            if hasError ?? false {
                self?.showError()
            }
        })
    }

    func embedView() {
        view.addSubview(candleChartView)
        candleChartView.translatesAutoresizingMaskIntoConstraints = false
        candleChartView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        candleChartView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        candleChartView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        candleChartView.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }

    func showError() {
        let alert = UIAlertController(title: "Error", message: "couldn't load your content", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "try again", style: .default, handler: { [weak self] alertAction in
            self?.viewModel.hasError?.value = false
            self?.viewModel.fetchData()
        }))
        present(alert, animated: true, completion: nil)
    }
}


extension CandleViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
}
