//
//  CoinConverterController.swift
//  CambioMoedasDIO
//
//  Created by Felipe Santos on 10/12/23.
//

import UIKit
import iOSDropDown

class CoinConverterController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var dropDownTo: DropDown!
    @IBOutlet weak var dropDownFrom: DropDown!
    @IBOutlet weak var lblValueConvert: UILabel!
    @IBOutlet weak var lblTypeConverted: UILabel!
    @IBOutlet weak var txtValueInfo: UITextField!
    @IBOutlet weak var showHistoryBtn: UIButton!
    
    // MARK: Private var/let
    private var coinUsed: Coin?
    private var lastValueSearch: String?
    
    // MARK: ViewModel
    private var viewModel: CoinConverterViewModel?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CoinConverterViewModel()
        configDropDown()
        hiddenShowHistoryButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let coin = viewModel?.coinHistory {
            dropDownTo.text = coin.code
            dropDownFrom.text = coin.codein
        }
    }
    
    // MARK: IBActions
    @IBAction func actGetCoins(_ sender: UIButton) {
        if validFields() {
            guard let viewModel else {
                return
            }
            if let coin = viewModel.coinHistory {
                let currencyCoin = setCurrencyCoin(coin.codein)

                let messageConvert = coin.name
                let convertedValue = viewModel.calculateCoins(valueInfo: lastValueSearch ?? "10", valueCoin: coin.buyValue)
                DispatchQueue.main.async { [weak self] in
                    self?.lblTypeConverted.text = messageConvert
                    self?.lblValueConvert.text = "\(currencyCoin) \(convertedValue)"
                }
            } else {
                getCoins(dropDownTo.text, dropDownFrom.text, value: txtValueInfo.text)
            }
        }
    }
    
    @IBAction func saveHistory(_ sender: Any) {
        if validFields() {
            if let coinUsed {
                viewModel?.saveHistoryExchange(coin: coinUsed, onCompletion: { [weak self] message in
                    DispatchQueue.main.async {
                        self?.showErroAlert(errorMessage: message)
                    }
                })
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.showErroAlert(errorMessage: "Você precisa primeiro fazer a conversão, para salvar")
                }
            }
            hiddenShowHistoryButton()
        }
    }
    
    @IBAction func showHistory(_ sender: Any) {
        performSegue(withIdentifier: "history", sender: nil)
    }
    
    // MARK: Private Funcs
    private func getCoins(_ to: String?, _ from: String?, value: String?) {
        guard let viewModel, let to, let from, let value else {
            return
        }
        lastValueSearch = value
        viewModel.getCoins(pathParam: "\(to)-\(from)") { [weak self] data, error in
            
            if let coins = data {
                guard let coin = coins.first,
                      let currencyCoin = self?.setCurrencyCoin(from) else {
                      return
                }
                self?.coinUsed = coin.value
                let messageConvert = coins.first?.value.name
                let convertedValue = viewModel.calculateCoins(valueInfo: value, valueCoin: coin.value.buyValue)
                DispatchQueue.main.async {
                    self?.lblTypeConverted.text = messageConvert
                    self?.lblValueConvert.text = "\(currencyCoin) \(convertedValue)"
                }
            } else {
                DispatchQueue.main.async {
                    self?.showErroAlert(errorMessage: error ?? "Erro")
                }
            }
        }
    }
    
    private func configDropDown() {
        guard let viewModel else { return }
        self.dropDownTo.optionArray = viewModel.getListCoins()
        self.dropDownTo.arrowSize = 5
        self.dropDownTo.selectedRowColor = .gray
        	
        self.dropDownFrom.optionArray = viewModel.getListCoins()
        self.dropDownFrom.arrowSize = 5
        self.dropDownFrom.selectedRowColor = .gray
    }
    
    private func validFields() -> Bool {
        if let value = txtValueInfo.text, value.isEmpty {
            showErroAlert(errorMessage: "Digite um valor para ser convertido!")
            return false
        }
        
        if let valueTo = dropDownTo.text, let valueFrom = dropDownFrom.text {
            if valueTo.isEmpty || valueFrom.isEmpty {
                showErroAlert(errorMessage: "Selecione uma moeda para converter o valor!")
                return false
            }
            if valueTo == valueFrom {
                showErroAlert(errorMessage: "Selecione moedas diferentes para converter o valor!")
                return false
            }
        }
        
        return true
    }
    
    private func setCurrencyCoin(_ selectCurrency: String?) -> String {
        guard let selectCurrency else { return "" }
        
        if selectCurrency == "USD" {
            return "US$:"
        }
        if selectCurrency == "EUR" {
            return "€:"
        }
        return "R$:"
    }
    
    private func hiddenShowHistoryButton() {
        guard let viewModel else {
            return
        }
        let hidden: Bool = viewModel.getHistoryExchange().count <= 0
        showHistoryBtn.isHidden = hidden
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? CoinConvertTableViewController {
            controller.viewModel = viewModel
        }
    }
}
