//
//  UIViewController+Extension.swift
//  AvenCodingChallenge
//
//  Created by Krishna Kumar on 4/2/23.
//

import UIKit

extension UIViewController {
    class func instantiate<T>() -> T {
        let sb = UIStoryboard(name: "Main", bundle: .main)
        let controller = sb.instantiateViewController(identifier: "\(T.self)") as! T
        return controller
    }
}
