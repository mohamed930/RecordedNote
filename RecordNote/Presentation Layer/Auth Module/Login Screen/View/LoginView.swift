//
//  LoginView.swift
//  RecordNote
//
//  Created by Mohamed Ali on 26/05/2026.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var viewMdel: LoginViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    LoginView(viewMdel: LoginViewModel(coordinator: LoginCoordinator(navigationController: UINavigationController())))
}
