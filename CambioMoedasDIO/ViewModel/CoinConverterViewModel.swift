//
//  CoinConverterViewModel.swift
//  CambioMoedasDIO
//
//  Created by Felipe Santos on 14/12/23.
//

import Foundation

class CoinConverterViewModel {
    
    private let exchangeUserDefault = ExchangeUserDefault()
    
    var coinHistory: Coin?
    
    var numberRows: Int {
        return getHistoryExchange().count
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    public func getCoins(pathParam: String, onCompletion: @escaping (ExchangeCoins?, String?) -> Void) {
        WebService().getCoins(pathParam: pathParam) { (data, error) in
            if let coins = data {
                onCompletion(coins, nil)
            } else {
                onCompletion(nil, error)
            }
        }
    }
    
    public func calculateCoins(valueInfo: String, valueCoin: String) -> String {
        guard let value = Float(valueInfo), let coin = Float(valueCoin) else { return "" }
        let calc: Float = coin * value
        return String(format: "%.2f", calc)
    }
    
    public func getListCoins() -> [String] {
        return EnumCoins.allCases.map {$0.rawValue}
    }
    
    public func saveHistoryExchange(coin: Coin, onCompletion: @escaping (String) -> Void) {
        var listCoins: [Coin] = getHistoryExchange()
        if !listCoins.isEmpty {
            let listAux = listCoins.filter {$0.code == coin.code && $0.codein == coin.codein}
            if !listAux.isEmpty {
                onCompletion("Você já salvou um histórico para essa pesquisa")
            } else {
                listCoins.append(coin)
                self.exchangeUserDefault.save(listCoin: listCoins)
                onCompletion("Histórico salvo com sucesso")
            }
        } else {
            listCoins.append(coin)
            self.exchangeUserDefault.save(listCoin: listCoins)
            onCompletion("Histórico salvo com sucesso")
        }
    }
    
    public func getHistoryExchange() -> [Coin] {
        return self.exchangeUserDefault.getListCoins()
    }
}
