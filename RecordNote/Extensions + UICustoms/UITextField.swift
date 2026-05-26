//
//  UITextField.swift
//  LNJ-Daftar
//
//  Created by Mohamed Ali on 10/02/2024.
//

import UIKit
import Combine

extension UITextField {
    
    private func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    private func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func addPadding(amount:CGFloat, placeHolder:String , color: UIColor,padding: Bool = true) {
        if padding {
            setLeftPaddingPoints(amount)
            setRightPaddingPoints(amount)
        }
        else {
            setRightPaddingPoints(30)
            setLeftPaddingPoints(amount)
        }
        
        
        self.attributedPlaceholder = NSAttributedString(string: placeHolder,
                attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    
    func textPublisher() -> AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: Self.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text  ?? "" }
            .eraseToAnyPublisher()
    }
}
