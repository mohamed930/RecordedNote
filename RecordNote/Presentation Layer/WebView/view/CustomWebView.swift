//
//  CustomWebView.swift
//  RecordNote
//
//  Created by Mohamed Ali on 29/05/2026.
//

import SwiftUI
import WebKit

struct CustomWebView: View {
    
    @ObservedObject var viewModel: CustomWebViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.EDE_9_FE
                
                Text(viewModel.title)
                    .setFont(fontName: .mainFontSemiBold, size: 16)
                
                HStack {
                    Button {
                        viewModel.dismissButtonAction()
                    } label: {
                        Image(.backButton)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal,24)
            }
            .frame(maxHeight: 59)
            
            CustomWebViewAttribute(url: viewModel.makeURL())
            
            Spacer()
        }
    }
}

#Preview {
    CustomWebView(viewModel: CustomWebViewModel(coordinator: CustomWebViewCoordinator(navigationController: UINavigationController(), link: "", title: ""), link: "https://www.google.com", title: "Terms of Service"))
}
