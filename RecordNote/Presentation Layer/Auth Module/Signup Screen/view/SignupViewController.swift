//
//  SignupViewController.swift
//  RecordNote
//
//  Created by Mohamed Ali on 27/05/2026.
//

import UIKit
import SwiftUI

class SignupViewController: UIViewController {
    
    @ObservedObject var viewModel: SignupViewModel
    
    init(viewModel: SignupViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addHosting(SignupView(viewModel: viewModel))
    }

}
