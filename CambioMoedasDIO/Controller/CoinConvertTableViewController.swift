//
//  CoinConvertTableViewController.swift
//  CambioMoedasDIO
//
//  Created by Felipe Santos on 14/01/24.
//

import UIKit

class CoinConvertTableViewController: UITableViewController {
    
    public var viewModel: CoinConverterViewModel?
        
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel else {
            return 0
        }
        return viewModel.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel else {
            return 0
        }
        return viewModel.numberRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel else {
            return UITableViewCell()
        }
        let obj: Coin = viewModel.getHistoryExchange()[indexPath.row]
        let cell: HistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell
        
        cell.setTitle(obj.name ?? "")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel else {
            return
        }
        viewModel.coinHistory = viewModel.getHistoryExchange()[indexPath.row]
        dismiss(animated: true)
    }
}
