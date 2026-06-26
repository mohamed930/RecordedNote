//
//  AppAlert.swift
//  RecordNote
//
//  Created by Mohamed Ali on 26/05/2026.
//

import SwiftUI

struct AppAlert: View {

    // MARK: - Properties

    let image: ImageResource?

    let title: String
    let message: String

    let actionTitle: String
    let cancelTitle: String

    var hideCancelButton: Bool = false

    var action: (() -> Void)?
    var cancelAction: (() -> Void)?
    var backgroundTapAction: (() -> Void)?

    // MARK: - Binding

    @Binding var isPresented: Bool

    // MARK: - Body

    var body: some View {

        ZStack {

            // Background Overlay

            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture {

                    backgroundTapAction?()
                    
                    if hideCancelButton == false {
                        dismiss()
                    }
                }

            // Alert Card

            VStack(spacing: 20) {

                // Image

                if let image {

                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                }

                // Title

                Text(title)
                    .multilineTextAlignment(.center)
                    .setFont(
                        fontName: .mainFontBold,
                        size: 24
                    )
                    .foregroundStyle(.black)

                // Message

                Text(message)
                    .multilineTextAlignment(.center)
                    .setFont(
                        fontName: .mainFont,
                        size: 16
                    )
                    .foregroundStyle(Color._99_A_1_AF)

                // Buttons

                VStack(spacing: 12) {

                    // Action Button

                    Button {

                        action?()
                        dismiss()

                    } label: {

                        Text(actionTitle)
                            .setFont(
                                fontName: .mainFontSemiBold,
                                size: 16
                            )
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(

                                LinearGradient(
                                    colors: [
                                        Color._7_C_3_AED.opacity(0.76),
                                        Color._8_B_5_CF_6.opacity(0.9)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: 16)
                            )
                    }

                    // Cancel Button

                    if !hideCancelButton {

                        Button {

                            cancelAction?()
                            dismiss()

                        } label: {

                            Text(cancelTitle)
                                .setFont(
                                    fontName: .mainFontSemiBold,
                                    size: 16
                                )
                                .foregroundStyle(Color._7_C_3_AED)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.clear)
                                .overlay(

                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            Color._7_C_3_AED,
                                            lineWidth: 1
                                        )
                                )
                        }
                    }
                }
                .padding(.top, 8)
            }
            .padding(24)
            .background(Color.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 32)
            )
            .padding(.horizontal, 24)
            .transition(
                .scale.combined(with: .opacity)
            )
        }
        .animation(
            .spring(
                response: 0.35,
                dampingFraction: 0.8
            ),
            value: isPresented
        )
    }

    // MARK: - Helpers

    private func dismiss() {

        withAnimation {

            isPresented = false
        }
    }
}

#Preview {

    ZStack {

        Color.gray.opacity(0.2)
            .ignoresSafeArea()

        AppAlert(
            image: .attension,
            title: "Delete Note?",
            message: "Are you sure you want to delete this voice note permanently?",
            actionTitle: "Delete",
            cancelTitle: "Cancel",
            hideCancelButton: false,
            action: {
                print("Delete tapped")
            },
            cancelAction: {
                print("Cancel tapped")
            },
            isPresented: .constant(true)
        )
    }
}
