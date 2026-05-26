//
//  UIButton.swift
//  Morizone
//
//  Created by Mohamed Ali on 02/02/2026.
//

import UIKit

extension UIButton {
    
    func setUnderlinedTitle(
        _ title: String,
        color: UIColor,
        for state: UIControl.State = .normal
    ) {
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: color
        ]
        
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: attributes
        )
        
        setAttributedTitle(attributedTitle, for: state)
    }
}
