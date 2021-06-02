//
//  Toast.swift
//  WeatherApp
//
//  Created by Neelesh Rai on 30/05/21.
//  Copyright © 2021 Neelesh Rai. All rights reserved.
//

import Foundation
import UIKit

class Toast: NSObject {
    
    private var toastLabel: UILabel?
       
       // MARK: - Show Toast
       func showToast(message: String) {
           DispatchQueue.main.async {
               if self.toastLabel != nil {
                   NSObject.cancelPreviousPerformRequests(withTarget: self,
                                                          selector: #selector(self.addToastLabel(message:)), object: nil)
                   self.toastLabel = nil
               }
               self.addToastLabel(message: message)
           }
       }
    
    @objc private func addToastLabel(message: String) {
        let font = UIFont(name: "Helvetica Neue", size: 12.0)
        let size: CGSize = getSize(message, font: font!)
        self.toastLabel =
            
            UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2 - size.width/2,
                                  y: UIScreen.main.bounds.height-150, width: size.width + 10, height: 35))
        self.toastLabel?.backgroundColor = UIColor.black
        self.toastLabel?.textColor = UIColor.white
        self.toastLabel?.textAlignment = .center
        self.toastLabel?.font = font
        self.toastLabel?.text = message
        self.toastLabel?.alpha = 1.0
        self.toastLabel?.layer.cornerRadius = 10
        self.toastLabel?.numberOfLines = 0
        self.toastLabel?.clipsToBounds  =  true
        UIWindow.key?.addSubview(self.toastLabel!)
        UIView.animate(withDuration: 5.0, delay: 0.0, options: .curveEaseOut, animations: {
            self.toastLabel?.alpha = 0.0
        }, completion: {_ in
            self.toastLabel?.removeFromSuperview()
            self.toastLabel = nil
        })
    }
    
    // MARK: - Calculate Text Size
    func getSize(_ text: String, font: UIFont) -> CGSize {
        let size = CGSize(width: 220, height: 20000.0)
        let attributedText = NSAttributedString(string: text.removingPercentEncoding ?? "",
                                                attributes: [NSAttributedString.Key.font: font])
        let rect: CGRect = attributedText.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)
        return rect.size
    }
}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
