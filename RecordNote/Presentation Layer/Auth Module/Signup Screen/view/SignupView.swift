//
//  SignupView.swift
//  RecordNote
//
//  Created by Mohamed Ali on 27/05/2026.
//

import SwiftUI

struct SignupView: View {
    
    @ObservedObject var viewModel: SignupViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            HeaderComponets(text: "Welcome!",
                            icon: .celebration,
                            isBackVisible: true) {
                viewModel.moveToLoginScreen()
            }
            
            VStack(alignment: .leading,spacing: 10) {
                
                Text("Create your account")
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .setFont(fontName: .mainFontBold, size: 24)
                    .padding(.top,32)
                
                Text("Start recording, transcribing and summarizing with AI")
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .setFont(fontName: .mainFont, size: 14)
                    .foregroundStyle(Color._99_A_1_AF)
                    .padding(.bottom,22)
                
                ScrollView {
                    
                    VStack(spacing: 12) {
                        AppTextField(placeholder: "Full name",
                                     icon: .name,
                                     type: .text,
                                     text: $viewModel.fullName)
                        
                        VStack(spacing: 3) {
                            AppTextField(placeholder: "Email address",
                                         icon: .email,
                                         type: .text,
                                         text: $viewModel.emailAddress) {
                                viewModel.handleValidation()
                            }
                                    
                            Text("Email isn't valid")
                                .setFont(fontName: .mainFont, size: 12)
                                .foregroundStyle(Color.red)
                                .visibility(viewModel.emailValidation ? .gone : .visible)
                                .padding(.bottom,6)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        AppTextField(placeholder: "Password",
                                     icon: .password,
                                     type: .password,
                                     text: $viewModel.password)
                                .padding(.bottom,6)
                        
                        AppTextField(placeholder: "Confirm password",
                                     icon: .password,
                                     type: .password,
                                     text: $viewModel.confirmPassword)
                                .padding(.bottom,6)
                    }
                    
                    HStack(spacing: 8) {
                        Button {
                            viewModel.agreeConditionsAndTerms()
                        } label: {
                            Image(viewModel.isSaved ? .check : .unCheck)
                        }
                        .frame(width: 20,height: 20)
                        
                        HStack(spacing: 3) {
                            Text("I agree to the")
                                .setFont(fontName: .mainFont, size: 12)
                                .foregroundStyle(Color._6_A_7282)
                                 
                             Button {
                                 viewModel.moveToTermsAndConditions()
                             } label: {
                                 Text("Terms of Service")
                                     .setFont(fontName: .mainFontSemiBold, size: 12)
                                     .foregroundStyle(Color._7_C_3_AED)
                             }
                            
                            Text("and")
                                .setFont(fontName: .mainFont, size: 12)
                                .foregroundStyle(Color._6_A_7282)
                            
                            Button {
                                viewModel.moveToPrivacyPolicy()
                            } label: {
                                Text("Privacy Policy")
                                    .setFont(fontName: .mainFontSemiBold, size: 12)
                                    .foregroundStyle(Color._7_C_3_AED)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.bottom,12)
                    
                    
                    AppButton(title: "Sign Up",
                              isLoading: $viewModel.isloading,
                              icon: .arrorRight) {
                        Task {
                            await viewModel.signUpOperation()
                        }
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
                            Task {
                                await viewModel.signUpWithGoogleAction()
                            }
                        }
                        
                        SocialButton(
                            title: "Apple",
                            image: .apple
                        ) {
                            viewModel.signUpWithAppleAction()
                        }
                    }
                    .padding(.bottom,12)
                }
                
                Spacer()
            }
            .padding(.horizontal,24)
            .background(Color.white)
            .cornerRadius(32, corners: [.topLeft, .topRight])
            .padding(.top, -10)
            
            Spacer()
        }
        .overlay {

            if viewModel.errorFlag {

                AppAlert(
                    image: .attension,
                    title: "Error",
                    message: viewModel.errorMessage,
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
    SignupView(viewModel: SignupViewModel(coordinator: SignupCoordinator(navigationController: UINavigationController()), useCases: AuthUseCase(repository: AuthRepository(service: AuthAPI()))))
}
