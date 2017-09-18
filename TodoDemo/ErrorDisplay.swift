//
//  ErrorDisplay.swift
//  TodoDemo
//
//  Created by Chandrakala Neerukonda on 9/18/17.
//  Copyright © 2017 Chandrakala Neerukonda. All rights reserved.
//

import UIKit

protocol ErrorDisplay {
    func display(_ error: Error)
}

struct ErrorStrings {
    struct GenericError {
        static let title = NSLocalizedString("Oops", tableName:"Errors", comment: "Generic oops alert title")
        static let message = NSLocalizedString("Sorry something went wrong, please try again later.", tableName:"Errors", comment: "Generic alert message")
    }
    static let ok = NSLocalizedString("ok", tableName:"Errors"
        , comment: "Generic ok button title")
}

extension ErrorDisplay where Self: UIViewController {
    func display(_ error: Error){
        let alert = UIAlertController(title: ErrorStrings.GenericError.title, message: error.localizedDescription.isEmpty ? ErrorStrings.GenericError.message : error.localizedDescription, preferredStyle: .alert)
        let ok = UIAlertAction(title: ErrorStrings.ok, style: .cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
