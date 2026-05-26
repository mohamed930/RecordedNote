//
//  AppButton.swift
//  RecordNote
//
//  Created by Mohamed Ali on 26/05/2026.
//

import SwiftUI

struct AppButton: View {

    enum ImagePosition {
        case leading
        case trailing
    }

    let title: String

    @Binding var isLoading: Bool

    var icon: ImageResource?
    var imagePosition: ImagePosition = .trailing

    var action: (() -> Void)?

    @State private var isPressed = false

    var body: some View {

        Button {

            guard !isLoading else { return }

            action?()

        } label: {

            ZStack {

                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color._7_C_3_AED.opacity(0.76),
                                Color._8_B_5_CF_6.opacity(0.9)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )

                ZStack {

                    HStack(spacing: 12) {

                        if let icon,
                           imagePosition == .leading {

                            buttonImage(icon)
                        }

                        Text(title)
                            .setFont(
                                fontName: .mainFontSemiBold,
                                size: 16
                            )

                        if let icon,
                           imagePosition == .trailing {

                            buttonImage(icon)
                        }
                    }
                    .opacity(isLoading ? 0 : 1)

                    if isLoading {

                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.1)
                    }
                }
                .foregroundColor(.white)
            }
            .frame(
                width: isLoading ? 58 : nil,
                height: 58
            )
            .frame(maxWidth: .infinity)
            .scaleEffect(isPressed ? 0.96 : 1)
            .opacity(isLoading ? 0.8 : 1)
            .animation(
                .spring(
                    response: 0.35,
                    dampingFraction: 0.8
                ),
                value: isLoading
            )
            .animation(
                .spring(
                    response: 0.25,
                    dampingFraction: 0.7
                ),
                value: isPressed
            )
        }
        .buttonStyle(.plain)
        .simultaneousGesture(

            DragGesture(minimumDistance: 0)
                .onChanged { _ in

                    if !isPressed {
                        isPressed = true
                    }
                }
                .onEnded { _ in

                    isPressed = false
                }
        )
        .disabled(isLoading)
    }

    @ViewBuilder
    private func buttonImage(
        _ icon: ImageResource
    ) -> some View {

        Image(icon)
            .resizable()
            .scaledToFit()
            .frame(width: 20)
    }
}

#Preview {

    VStack(spacing: 20) {

        AppButton(
            title: "Log In",
            isLoading: .constant(false),
            icon: .arrorRight
        )

        AppButton(
            title: "Loading",
            isLoading: .constant(true),
            icon: .arrorRight
        )

        AppButton(
            title: "Back",
            isLoading: .constant(false),
            icon: .arrowLeft,
            imagePosition: .leading
        )
    }
    .padding()
}
