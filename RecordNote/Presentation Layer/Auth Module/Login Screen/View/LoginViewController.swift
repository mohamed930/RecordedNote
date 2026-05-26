//
//  LoginViewController.swift
//  RecordNote
//
//  Created by Mohamed Ali on 26/05/2026.
//

import UIKit
import SwiftUI

class LoginViewController: UIViewController {
    
    @ObservedObject var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addHosting(LoginView(viewMdel: viewModel))
        
    }
    
}
