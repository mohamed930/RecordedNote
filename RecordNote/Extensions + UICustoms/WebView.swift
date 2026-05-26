//
//  WebView.swift
//  Masar
//
//  Created by Mohamed Ali on 27/10/2024.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let htmlContent: String
    @Binding var height: CGFloat // Binding to update height dynamically

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.scrollView.isScrollEnabled = false // Disable scrolling
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Slight delay
                webView.evaluateJavaScript("document.documentElement.scrollHeight") { (height, error) in
                    if let height = height as? CGFloat {
                        DispatchQueue.main.async {
                            self.parent.height = height // Update height binding
                        }
                    }
                }
            }
        }
    }
}
