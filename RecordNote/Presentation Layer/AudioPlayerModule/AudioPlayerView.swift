//
//  AudioPlayerView.swift
//  RecordNote
//
//  Created by Mohamed Ali on 13/06/2026.
//

import SwiftUI

struct AudioPlayerView: View {
    
    @ObservedObject var viewModel: AudioPlayerViewModel
    
    let minLightIntensity = 1.0
    let maxLightIntensity = 5.0
    
    var body: some View {
        ZStack {
            Color.FAFAFA
                .ignoresSafeArea()
            
            HStack(spacing: 10) {
                Text(viewModel.stateValue)
                    .setFont(fontName: .mainFontMeduim, size: 12)
                    .foregroundStyle(Color._99_A_1_AF)
                
                CustomSlider(
                    value: $viewModel.sliderValue,
                    range: 0...Float(viewModel.duration),
                    onEditingChanged: viewModel.sliderEditingChanged
                )
                .frame(height: 4)
                
                Text(viewModel.totalValue)
                    .setFont(fontName: .mainFontMeduim, size: 12)
                    .foregroundStyle(Color._99_A_1_AF)
                
                Button {
                    viewModel.buttonActionBasedOnState()
                } label: {
                    Image(viewModel.isPlaying ? .pauseButton : .buttonPlay)
                }

            }
            .padding(.horizontal,16)
            .padding(.bottom,16)
        }
        .frame(height: 82)
        .disabled(!viewModel.audioState)
    }
}

#Preview {
    AudioPlayerView(viewModel: AudioPlayerViewModel(useCases: NotesUseCases(notesRepository: NotesRespotery(realm: RealmStorage()), audioPlayer: AudioPlayerService()), model: .mock))
}
