//
//  MenuComponets.swift
//  RecordNote
//
//  Created by Mohamed Ali on 19/06/2026.
//

import SwiftUI

struct MenuComponets: View {
    
    enum MenuAction {
        case edit
        case share
        case savePdf
        case delete
    }
    
    var buttonAction: ((MenuAction) -> ())?
    
    var body: some View {
        
        ZStack {
            
            Color.white
                .cornerRadius(20, corners: .allCorners)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                VStack(spacing: 20) {
                    SettingsRow(title: "Edit details",
                                icon: .edit,
                                showsChevron: false,
                                isCenter: false) {
                        // MARK: Edit action.
                        buttonAction?(.edit)
                        
                    }
                    
                    SettingsRow(title: "Share",
                                icon: .share,
                                showsChevron: false,
                                isCenter: false) {
                        // MARK: share action.
                        buttonAction?(.share)
                    }
                    
                    SettingsRow(title: "Export PDF",
                                icon: .pdfExport,
                                showsChevron: false,
                                isCenter: false) {
                        // MARK: pdf action.
                        buttonAction?(.savePdf)
                    }
                }
                .padding(.horizontal,4)
                
                Divider()
                
                SettingsRow(title: "Delete",
                            icon: .delete,
                            textColor: .red,
                            showsChevron: false,
                            isCenter: false) {
                    // MARK: delete action.
                    buttonAction?(.delete)
                }
                .padding(.horizontal,4)
            }
        }
        .frame(maxWidth: 210,maxHeight: 233)
//        .padding(.vertical,12)
        .borderedCornerRadius(20, corners: .allCorners, lineWidth: 2, borderColor: .F_3_F_4_F_6)
        .shadow(color: .black.opacity(0.2),radius: 20)
        
        
    }
}

#Preview {
    MenuComponets()
}
