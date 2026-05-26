//
//  PresentSheet.swift
//  Morizone
//
//  Created by Mohamed Ali on 20/01/2026.
//

import UIKit

protocol PresentSheet {

    var expandedId: UISheetPresentationController.Detent.Identifier { get }
    var collapsedId: UISheetPresentationController.Detent.Identifier { get }

    @discardableResult
    func presentNativeSheet(
        viewController: UIViewController,
        parent: UIViewController,
        maxi: Double
    ) -> UISheetPresentationController?
}

extension PresentSheet {

    var expandedId: UISheetPresentationController.Detent.Identifier {
        UISheetPresentationController.Detent.Identifier("expanded")
    }

    var collapsedId: UISheetPresentationController.Detent.Identifier {
        UISheetPresentationController.Detent.Identifier("collapsed")
    }
    
    @discardableResult
    func presentNativeSheet(
        viewController: UIViewController,
        parent: UIViewController,
        maxi: Double = 414
    ) -> UISheetPresentationController? {

        viewController.modalPresentationStyle = .pageSheet
        viewController.isModalInPresentation = true

        parent.present(viewController, animated: true)

        guard let sheet = viewController.sheetPresentationController else { return nil }

        sheet.prefersScrollingExpandsWhenScrolledToEdge = false

        if #available(iOS 16.0, *) {
            
            sheet.detents = [
                .custom(identifier: collapsedId) { _ in 100 },
                .custom(identifier: expandedId) { _ in maxi }
            ]

            sheet.largestUndimmedDetentIdentifier = expandedId
            
        }

        sheet.prefersGrabberVisible = false
        sheet.preferredCornerRadius = 20

        return sheet
    }
}
