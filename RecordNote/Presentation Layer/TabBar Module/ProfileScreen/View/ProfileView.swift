//
//  ProfileView.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import SwiftUI

// MARK: - ProfileView

struct ProfileView: View {

    // MARK:- Private
    @ObservedObject private var viewModel: ProfileViewModel

    init(viewModel: ProfileViewModel) {
      self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Color.FAFAFA
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                ZStack {
                    
                    Color.white
                    
                    Text("Profile")
                        .setFont(fontName: .mainFontBold, size: 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal,24)
                }
                .frame(height: 53)
                .padding(.bottom,16)
                
                ZStack {
                    Color.white
                    
                    VStack(spacing: 12) {
                        InitialsAvatarView(fullName: viewModel.userName, size: 80)
                        
                        Text(viewModel.userName)
                            .setFont(fontName: .mainFontSemiBold, size: 18)
                        
                        Text(viewModel.email)
                            .setFont(fontName: .mainFont, size: 13)
                            .foregroundStyle(Color._99_A_1_AF)
                    }
                    
                }
                .borderedCornerRadius(20, corners: .allCorners, lineWidth: 1, borderColor: Color.F_3_F_4_F_6)
                .frame(maxHeight: 193)
                .padding(.horizontal,16)
                .padding(.bottom,20)
                
                HStack {
                    
                    ZStack {
                        Color.white
                        
                        VStack(alignment: .leading,spacing: 8) {
                            HStack {
                                Image(.usage)
                                
                                Text("Usage")
                                    .setFont(fontName: .mainFontMeduim, size: 13)
                                    .foregroundStyle(Color._6_A_7282)
                                
                                Spacer()
                            }
                            
                            Text(viewModel.recordSize)
                                .setFont(fontName: .mainFontSemiBold, size: 16)
                        }
                        .padding(.horizontal,16)
                        
                    }
                    .borderedCornerRadius(20, corners: .allCorners, lineWidth: 1, borderColor: Color.F_3_F_4_F_6)
                    .frame(maxWidth: 165,maxHeight: 85)
                    .padding(.horizontal,16)
                    
                    
                    
                    Spacer()
                }
                .padding(.bottom,20)
                
                VStack(spacing: 20) {
                    SettingsRow(title: "Settings",
                                icon: .settings)
                    
                    Divider()
                    
                    SettingsRow(title: "Help & Support",
                                icon: .faq)
                }
                .padding(20)
                .background(Color.white)
                .borderedCornerRadius(20, corners: .allCorners, lineWidth: 1, borderColor: Color.F_3_F_4_F_6)
                .padding(.horizontal,12)
                .padding(.bottom,20)
                
                VStack(spacing: 20) {
                    SettingsRow(title: "Log Out",
                                icon: .logout,
                                textColor: .red,
                                showsChevron: false)
                }
                .padding(20)
                .background(Color.white)
                .borderedCornerRadius(20, corners: .allCorners, lineWidth: 1, borderColor: Color.F_3_F_4_F_6)
                .padding(.horizontal,12)
                .onTapGesture {
                    viewModel.logoutButtonAction()
                }
                
                
                Spacer()
            }
        }
    }
}

#Preview {
    ProfileView(
        viewModel: ProfileViewModel(coordinator: ProfileCoordinator(navigationController: UINavigationController()), useCase: ProfileUseCases(respotery: HomeRespository(realm: RealmStorage(), local: LocalStorage())))
    )
}
