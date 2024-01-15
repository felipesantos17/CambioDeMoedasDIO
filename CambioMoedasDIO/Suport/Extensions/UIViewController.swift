//
//  UIViewController.swift
//  CambioMoedasDIO
//
//  Created by Felipe Santos on 14/12/23.
//

import UIKit

extension UIViewController {
    public func showErroAlert(errorMessage: String, title: String = "Atenção") {
        let alert = UIAlertController(title: title , message: errorMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}
