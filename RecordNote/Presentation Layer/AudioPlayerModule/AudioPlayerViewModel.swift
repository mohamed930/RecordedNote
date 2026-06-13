//
//  AudioPlayerViewModel.swift
//  RecordNote
//
//  Created by Mohamed Ali on 13/06/2026.
//

import Foundation
import Combine

class AudioPlayerViewModel: ObservableObject {
    
    // MARK: - AVPlayser.
    var useCases: NotesUseCases
    var model: NoteRealModelInfoModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Publishers.
    @Published var audioState:  Bool   = false
    @Published var stateValue:  String = "00:00"
    @Published var totalValue:  String = "00:00"
    @Published var isPlaying:   Bool   = false
    @Published var sliderValue: Float  = 0.0
    @Published var duration:    Double = 0.0
    @Published var isDragging = false
    
    init(useCases: NotesUseCases,model: NoteRealModelInfoModel) {
        self.useCases = useCases
        self.model    = model
        
        audioState = useCases.loadAudio(for: model)

        useCases.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }

                switch state {
                case .idle, .paused:
                    isPlaying = false
                case .playing:
                    isPlaying = true
                case .finished:
                    isPlaying = false
                    sliderValue = Float(duration)
                    stateValue = duration.formatTimer()
                case .loading:
                    break
                case .failed:
                    audioState = false
                    isPlaying = false
                }
            }
            .store(in: &cancellables)
        
        useCases.currentTimePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] time in
                guard let self else { return }

                if !isDragging {
                    sliderValue = Float(time)
                }

                stateValue = Double(time).formatTimer()
            }
            .store(in: &cancellables)
        
        useCases.durationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] duration in
                self?.duration = duration
                self?.totalValue = duration.formatTimer()
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: - Actions.
    func sliderEditingChanged(_ editing: Bool) {
        isDragging = editing

        if !editing {
            useCases.seekAudio(to: Double(sliderValue))
        }
    }
    
    func buttonActionBasedOnState() {
        if isPlaying {
            useCases.pauseAudio()
        } else {
            useCases.playAudio()
        }
    }
}
