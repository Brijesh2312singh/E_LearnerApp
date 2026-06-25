//
//  Loaderhelper.swift
//  ElearnerApp
//
//  Created by Coding Brains on 25/06/26.
//

import Foundation
extension UIViewController {

    func showLoader() {
        let loader = UIActivityIndicatorView(style: .large)
        loader.tag = 9999
        loader.center = view.center
        loader.startAnimating()
        view.addSubview(loader)
    }

    func hideLoader() {
        view.viewWithTag(9999)?.removeFromSuperview()
    }
}
