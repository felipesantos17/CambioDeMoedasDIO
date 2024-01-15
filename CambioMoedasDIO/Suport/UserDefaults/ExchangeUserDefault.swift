//
//  ExchangeUserDefault.swift
//  CambioMoedasDIO
//
//  Created by Felipe Santos on 15/12/23.
//

import Foundation

class ExchangeUserDefault {
    
    let kHistory = "kHistory"
    
    public func save(listCoin: [Coin]) {
        do {
            let list = try JSONEncoder().encode(listCoin)
            let defaults = UserDefaults.standard
            defaults.setValue(list, forKey: kHistory)
        } catch {
            print(error)
        }
    }
    
    public func getListCoins() -> [Coin] {
        do {
            guard let list = UserDefaults.standard.object(forKey: kHistory) else {
                return []
            }
            let auxList = try JSONDecoder().decode([Coin].self, from: list as? Data ?? Data())
            return auxList
        } catch {
            print(error)
        }
        return []
    }
}
