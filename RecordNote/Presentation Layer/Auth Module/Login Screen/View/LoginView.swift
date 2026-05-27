//
//  LoginView.swift
//  RecordNote
//
//  Created by Mohamed Ali on 26/05/2026.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        
        VStack(spacing: 0) {
            HeaderComponets(text: "Welcome back!",
                            isBackVisible: false)
            
            VStack(alignment: .leading,spacing: 10) {
                
                Text("Log in to your account")
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .setFont(fontName: .mainFontBold, size: 24)
                    .padding(.top,32)
                
                Text("Continue your journey with Smart Voice Notes AI")
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .setFont(fontName: .mainFont, size: 14)
                    .foregroundStyle(Color._99_A_1_AF)
                    .padding(.bottom,22)
                
                AppTextField(placeholder: "Email address",
                             icon: .email,
                             type: .text,
                             text: $viewModel.emailAddress) {
                    viewModel.checkMailValidation()
                }
                        
                Text("Email isn't valid")
                    .setFont(fontName: .mainFont, size: 12)
                    .foregroundStyle(Color.red)
                    .visibility(viewModel.emailValidation ? .gone : .visible)
                    .padding(.bottom,6)
                
                AppTextField(placeholder: "Password",
                             icon: .password,
                             type: .password,
                             text: $viewModel.password)
                        .padding(.bottom,6)
                
                HStack(spacing: 8) {
                    Button {
                        viewModel.savedPasswordButtonAction()
                    } label: {
                        Image(viewModel.isSaved ? .check : .unCheck)
                    }
                    .frame(width: 20,height: 20)
                    
                    Text("Remember me")
                        .setFont(fontName: .mainFont, size: 16)
                    
                    Spacer()

                    Button {
                        viewModel.forgetPasswordButtonAction()
                    } label: {
                        Text("Forgot password?")
                            .setFont(fontName: .mainFontSemiBold, size: 16)
                            .foregroundStyle(Color._7_C_3_AED)
                    }
                }
                .padding(.bottom,12)
                
                
                AppButton(title: "Login In",
                          isLoading: $viewModel.isloading,
                          icon: .arrorRight) {
                    viewModel.loginButtonAction()
                }
                .padding(.bottom,14)
                .disabled(!viewModel.isButtonEnabled)
                
                HStack(spacing: 4) {
                    Color.F_3_F_4_F_6
                        .frame(height: 1) // Set thickness
                        .padding(.horizontal) // Optional: add side spacing
                    
                    Text("Or continue with")
                        .setFont(fontName: .mainFontMeduim, size: 14)
                        .foregroundStyle(Color._99_A_1_AF)
                    
                    Color.F_3_F_4_F_6
                        .frame(height: 1) // Set thickness
                        .padding(.horizontal) // Optional: add side spacing
                }
                .padding(.bottom,14)
                
                HStack(spacing: 12) {
                    SocialButton(
                        title: "Google",
                        image: .google
                    ) {
                        viewModel.loginWithGoogleAction()
                    }
                    
                    SocialButton(
                        title: "Apple",
                        image: .apple
                    ) {
                        viewModel.loginWithAppleAction()
                    }
                }
                .padding(.bottom,12)
                
                Button(action: {
                    viewModel.moveToSignUpButtonAction()
                }, label: {
                    HStack(spacing: 3) {
                        Spacer()
                        
                        Text("Don't have an account?")
                            .setFont(fontName: .mainFont, size: 14)
                            .foregroundStyle(Color._99_A_1_AF)
                        
                        Text("Sign up")
                            .setFont(fontName: .mainFontBold, size: 14)
                            .foregroundStyle(Color._7_C_3_AED)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                })
                
                Spacer()
            }
            .padding(.horizontal,24)
            .background(Color.white)
            .cornerRadius(32, corners: [.topLeft, .topRight])
            .padding(.top, -10)
        }
        .overlay {

            if viewModel.errorFlag {

                AppAlert(
                    image: .attension,
                    title: "Error",
                    message: "Email or password isn't correct",
                    actionTitle: "Ok",
                    cancelTitle: "Cancel",
                    hideCancelButton: true,
                    action: {
                        viewModel.errorFlag = false
                    },
                    backgroundTapAction: {
                        viewModel.errorFlag = false
                    },
                    isPresented: $viewModel.errorFlag
                )
            }
        }
        
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(coordinator: LoginCoordinator(navigationController: UINavigationController())))
}
