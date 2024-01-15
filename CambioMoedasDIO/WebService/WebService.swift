//
//  WebService.swift
//  CambioMoedasDIO
//
//  Created by Felipe Santos on 14/12/23.
//

import Foundation

class WebService {
    let urlBase = "https://economia.awesomeapi.com.br/json/last/"
    
    public func getCoins(pathParam: String, onCompletion: @escaping (ExchangeCoins?, String?) -> Void) {
        
        let url = urlBase+pathParam
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data {
                if let apiResponse = try? JSONDecoder().decode(ExchangeCoins.self, from: data) {
                    onCompletion(apiResponse, nil)
                } else if let error = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    onCompletion(nil, error.message)
                }
            } else if let error {
                onCompletion(nil, error.localizedDescription)
            }
        }.resume()
    }
}
