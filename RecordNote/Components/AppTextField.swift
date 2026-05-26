//
//  AppTextField.swift
//  RecordNote
//
//  Created by Mohamed Ali on 26/05/2026.
//


import SwiftUI

struct AppTextField: View {

    enum FieldType {
        case text
        case password
    }

    let placeholder: String
    let icon: ImageResource
    let type: FieldType

    @Binding var text: String

    @State private var isSecure: Bool = true
    
    var onCommit: (() -> Void)? = nil

    var body: some View {

        HStack(spacing: 12) {

            Image(icon)
                .foregroundColor(.gray)

            Group {
                if type == .password {
                    if isSecure {
                        SecureField(placeholder, text: $text,onCommit: {
                            onCommit?()
                        })
                        .setFont(fontName: .mainFont, size: 15)
                    } else {
                        TextField(placeholder, text: $text,onEditingChanged: { editing in
                            if !editing {
                                onCommit?()
                            }
                        },onCommit: {
                            onCommit?()
                        })
                        .setFont(fontName: .mainFont, size: 15)
                    }
                } else {
                    TextField(placeholder, text: $text,onEditingChanged: { editing in
                        if !editing {
                            onCommit?()
                        }
                    },onCommit: {
                        onCommit?()
                    })
                        .setFont(fontName: .mainFont, size: 15)
                }
            }
            .autocorrectionDisabled()

            if type == .password {
                Button {
                    isSecure.toggle()
                } label: {

                    Image(systemName: isSecure ? "eye" : "eye.slash")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .frame(height: 60)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}
#Preview {

    VStack(spacing: 20) {

        AppTextField(
            placeholder: "Email address",
            icon: .email,
            type: .text,
            text: .constant("")
        )

        AppTextField(
            placeholder: "Password",
            icon: .password,
            type: .password,
            text: .constant("")
        )
    }
    .padding()
}
