//
//  CustomWebViewViewController.swift
//  RecordNote
//
//  Created by Mohamed Ali on 29/05/2026.
//

import UIKit
import SwiftUI

class CustomWebViewViewController: UIViewController {
    
    @ObservedObject var viewModel: CustomWebViewModel
    
    init(viewModel: CustomWebViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addHosting(CustomWebView(viewModel: viewModel))
    }
}
