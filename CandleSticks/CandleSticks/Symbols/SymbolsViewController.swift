//
//  SymbolsViewController.swift
//  CandleSticks
//
//  Created by Mohamed Zaki on 20/08/2022.
//

import UIKit

class SymbolsViewController: UIViewController {

    let symbols = [("BTC","BTCUSDT"), ("ETH","ETHUSDT"), ("LTC","LTCUSDT")]
    let cellId = "SymbolTableViewCell"
    @IBOutlet weak var symbolTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        symbolTableView.delegate = self
        symbolTableView.dataSource = self
        let nib = UINib(nibName: cellId, bundle: nil)
        symbolTableView.register(nib, forCellReuseIdentifier: cellId)
        
    }

}

extension SymbolsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        symbols.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)

        guard let symbolCell = cell as? SymbolTableViewCell else {
            return cell
        }
        symbolCell.symbolTitle.text = symbols[indexPath.row].0
        symbolCell.selectionStyle = .none
        return symbolCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let candleStickVC = storyboard.instantiateViewController(withIdentifier: "CandleViewController") as? CandleViewController else {return}
        let candleViewModel = CandleViewModel(symbolParameter: symbols[indexPath.row].1)
        candleStickVC.viewModel = candleViewModel
        navigationController?.pushViewController(candleStickVC, animated: true)
    }
}
