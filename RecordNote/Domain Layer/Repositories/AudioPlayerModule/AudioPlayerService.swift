//
//  AudioPlayerService.swift
//  RecordNote
//
//  Created by Mohamed Ali on 13/06/2026.
//

import Foundation
import Combine
import AVFoundation

class AudioPlayerService: AudioPlayerProtocol {
    
    // MARK: Publishers
    private let stateSubject =
        CurrentValueSubject<AudioPlayerStateValues, Never>(.idle)

    private let currentTimeSubject =
        CurrentValueSubject<Double, Never>(0)

    private let durationSubject =
        CurrentValueSubject<Double, Never>(0)

    var statePublisher: AnyPublisher<AudioPlayerStateValues, Never> {
        stateSubject.eraseToAnyPublisher()
    }

    var currentTimePublisher: AnyPublisher<Double, Never> {
        currentTimeSubject.eraseToAnyPublisher()
    }

    var durationPublisher: AnyPublisher<Double, Never> {
        durationSubject.eraseToAnyPublisher()
    }

    // MARK: Properties
    private var player: AVPlayer?
    private var timeObserver: Any?
    private var playerItemStatusObservation: NSKeyValueObservation?
    private var playerItemDurationObservation: NSKeyValueObservation?

    deinit {
        removeObservers()
    }
    
    func load(_ item: AudioItem) {
        removeObservers()

        stateSubject.send(.loading)
        currentTimeSubject.send(0)
        durationSubject.send(0)

        let playerItem = AVPlayerItem(url: item.url)

        player = AVPlayer(playerItem: playerItem)

        observePlayerItem(playerItem)
        observePlayer()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinish),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )

        stateSubject.send(.paused)
    }
    
    func play() {
        configureAudioSessionIfNeeded()
        player?.play()
        stateSubject.send(.playing)
    }
    
    func pause() {
        player?.pause()
        stateSubject.send(.paused)
    }
    
    func seek(to seconds: Double) {
        let clampedSeconds = min(max(seconds, 0), durationSubject.value)

        let time = CMTime(
            seconds: clampedSeconds,
            preferredTimescale: 600
        )

        currentTimeSubject.send(clampedSeconds)

        player?.seek(
            to: time,
            toleranceBefore: .zero,
            toleranceAfter: .zero
        )
    }
    
    func stop() {

        player?.pause()

        seek(to: 0)

        currentTimeSubject.send(0)

        stateSubject.send(.idle)
    }
}


extension AudioPlayerService {
    
    private func configureAudioSessionIfNeeded() {
        #if os(iOS)
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
        } catch {
            stateSubject.send(.failed(error))
        }
        #endif
    }
    
    private func observePlayer() {

        guard let player else { return }

        let interval = CMTime(
            seconds: 0.5,
            preferredTimescale: 600
        )

        timeObserver = player.addPeriodicTimeObserver(
            forInterval: interval,
            queue: .main
        ) { [weak self] time in

            guard let self else { return }

            currentTimeSubject.send(time.seconds)

            if let duration = player.currentItem?
                .duration.seconds,
               duration.isFinite {

                durationSubject.send(duration)
            }
        }
    }

    private func observePlayerItem(_ playerItem: AVPlayerItem) {
        playerItemStatusObservation = playerItem.observe(\.status, options: [.initial, .new]) { [weak self] item, _ in
            guard let self else { return }

            switch item.status {
            case .readyToPlay:
                if item.duration.seconds.isFinite {
                    durationSubject.send(item.duration.seconds)
                }
                stateSubject.send(.paused)
            case .failed:
                if let error = item.error {
                    stateSubject.send(.failed(error))
                }
            case .unknown:
                break
            @unknown default:
                break
            }
        }

        playerItemDurationObservation = playerItem.observe(\.duration, options: [.initial, .new]) { [weak self] item, _ in
            guard let self else { return }

            let seconds = item.duration.seconds
            if seconds.isFinite && seconds > 0 {
                durationSubject.send(seconds)
            }
        }
    }
    
    @objc
    private func playerDidFinish() {

        stateSubject.send(.finished)

        currentTimeSubject.send(
            durationSubject.value
        )
    }
    
    private func removeObservers() {
        if let timeObserver {
            player?.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
        
        playerItemStatusObservation?.invalidate()
        playerItemStatusObservation = nil
        playerItemDurationObservation?.invalidate()
        playerItemDurationObservation = nil

        NotificationCenter.default.removeObserver(self)
    }
}
