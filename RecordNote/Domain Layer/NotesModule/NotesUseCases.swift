//
//  NotesUseCases.swift
//  RecordNote
//
//  Created by Mohamed Ali on 06/06/2026.
//

import Foundation

import Foundation
import Combine

final class NotesUseCases {

    private let repository: HomeRespository =
        HomeRespository(
            realm: RealmStorage(),
            local: LocalStorage()
        )

    private let notesRepository: NotesRespoteryProtocol
    private let audioPlayer: AudioPlayerProtocol

    init(
        notesRepository: NotesRespoteryProtocol,
        audioPlayer: AudioPlayerProtocol
    ) {
        self.notesRepository = notesRepository
        self.audioPlayer = audioPlayer
    }

    // MARK: - Notes

    func fetchAllNotes() -> [MeetingNote] {
        repository.fetchNotes()
    }

    func fetchUserName() -> String {
        repository.fetchUserName() ?? ""
    }

    func fetchNotes() -> [MeetingNoteCardAttributes] {
        notesRepository.fetchNotes()
    }

    func fetchFiltersNotes(
        filter: NotesFilterValues
    ) -> [MeetingNoteCardAttributes] {
        notesRepository.filterNotes(filter: filter)
    }

    func convertNoteDTOToFullObject(
        id: String
    ) -> NoteRealModelInfoModel? {
        notesRepository.convertNoteToNoteRealModel(id: id)
    }

    // MARK: - Audio

    func loadAudio(for note: NoteRealModelInfoModel) -> Bool {

        guard let audioData = note.audio else {
            return false
        }

        let fileURL = FileManager.default
            .temporaryDirectory
            .appendingPathComponent("\(note.id).mp3")

        do {
            try audioData.write(to: fileURL)

            let item = AudioItem(
                id: note.id,
                url: fileURL,
                title: note.name
            )

            audioPlayer.load(item)
            
            return true

        } catch {
            print("Failed to write audio data: \(error)")
            return false
        }
    }

    func playAudio() {
        audioPlayer.play()
    }

    func pauseAudio() {
        audioPlayer.pause()
    }

    func seekAudio(to seconds: Double) {
        audioPlayer.seek(to: seconds)
    }

    // MARK: - Publishers
    var statePublisher: AnyPublisher<AudioPlayerStateValues, Never> {
        audioPlayer.statePublisher
    }

    var currentTimePublisher: AnyPublisher<Double, Never> {
        audioPlayer.currentTimePublisher
    }

    var durationPublisher: AnyPublisher<Double, Never> {
        audioPlayer.durationPublisher
    }
}
