//
//  ShareSheet.swift
//  RecordNote
//
//  Created by Mohamed Ali on 25/06/2026.
//

import SwiftUI
import UIKit

struct ShareItem: Identifiable {
    let id: String
    let items: [Any]
}

struct ShareSheet: UIViewControllerRepresentable {

    let item: ShareItem

    func makeUIViewController(context: Context) -> UIActivityViewController {

        let controller = UIActivityViewController(
            activityItems: item.items,
            applicationActivities: nil
        )
        
        controller.modalPresentationStyle = .formSheet

        return controller
    }

    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: Context
    ) { }
}
