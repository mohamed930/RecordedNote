//
//  View.swift
//  Masar
//
//  Created by Mohamed Ali on 20/10/2024.
//

import SwiftUI
//import RappleProgressHUD

extension View {
    
//    func handleLoading(isLoading: Binding<Bool>) -> some View {
//        self.onChange(of: isLoading.wrappedValue) { value in
//            if value {
//                RappleActivityIndicatorView.startAnimatingWithLabel("Please wait", attributes: RappleModernAttributes)
//            } else {
//                RappleActivityIndicatorView.stopAnimation()
//            }
//        }
//    }
    
    // SwiftUI alert handler
    func showAlert(
        title: String,
        description: String,
        isPresented: Binding<Bool>,
        completion: @escaping (Bool) -> ()
    ) -> some View {
        self.alert(isPresented: isPresented) {
            Alert(
                title: Text(title),
                message: Text(description),
                primaryButton: .cancel(Text("الغاء الامر"), action: {
                    completion(false)
                }),
                secondaryButton: .default(Text("اعد المحاولة"), action: {
                    completion(true)
                })
            )
        }
    }
}
