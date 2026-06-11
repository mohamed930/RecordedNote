//
//  HomeView.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import SwiftUI

// MARK: - HomeView

struct HomeView: View {

    // MARK:- Private
    @ObservedObject private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
      self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading,spacing: 0) {
            
            HStack(spacing: 0) {
                Text("Good Morning ")
                
                Text("\(viewModel.userName) ")
                
                Image(.hi)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                
                Spacer()
            }
            .setFont(fontName: .mainFontBold, size: 20)
            .padding(.bottom,3.5)
            
            Text("Let's capture your thoughts")
                .setFont(fontName: .mainFont, size: 16)
                .foregroundStyle(Color._6_A_7282)
                .padding(.bottom,32)
            
            VStack(alignment: .center,spacing: 0) {
                Button {
                    viewModel.recordNoteButtonAction()
                } label: {
                    Image(.recordButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 192)
                        .blur(radius: 0.9)
                }
                
                Text("Tap to start recording")
                    .setFont(fontName: .mainFontMeduim, size: 16)
                    .foregroundStyle(Color._6_A_7282)

            }
            .frame(maxWidth: .infinity)
            .padding(.bottom,60)
            
            
            if viewModel.isEmpty {
                VStack(alignment: .center) {
                    
                    Text("There is no notes avaliable")
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                }
                .frame(maxHeight: .infinity)
            }
            else {
                HStack {
                    Text("Recent Notes")
                        .setFont(fontName: .mainFontBold, size: 18)
                    
                    Spacer()
                    
                    Button {
                        viewModel.seeAllButtonAction()
                    } label: {
                        HStack(spacing: 2) {
                            Text("See All")
                                .setFont(fontName: .mainFont, size: 14)
                                .foregroundStyle(Color._7_C_3_AED)
                            
                            Image(.moreButton)
                        }
                    }

                }
                .padding(.bottom,16)
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.notes) { note in
                            MeetingNoteCard(note: note)
                        }
                    }
                }
            }
            
            
            
            Spacer()
        }
        .padding(.top,10)
        .padding(.horizontal,24)
    }
}

#Preview {
    HomeView(
        viewModel: HomeViewModel(coordinator: HomeCoordinator(navigationController: UINavigationController()), useCases: NotesUseCases(notesRespotery: NotesRespotery(realm: RealmStorage())))
    )
}
