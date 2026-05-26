//
//  CountdownTimer.swift
//  Morizone
//
//  Created by Mohamed Ali on 04/01/2026.
//


import Foundation
import Combine

final class CountdownTimer {
    // MARK: - Configuration
    private let duration: TimeInterval

    // MARK: - Publishers
    let progressPublisher = CurrentValueSubject<Float, Never>(0)
    let finishedPublisher = PassthroughSubject<Void, Never>()

    // MARK: - Private
    private var startDate: Date?
    private var cancellable: AnyCancellable?

    // MARK: - Init
    init(duration: TimeInterval = 120) {
        self.duration = duration
    }

    // MARK: - Control
    func start() {
        reset()

        startDate = Date()

        cancellable = Timer
            .publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] now in
                self?.update(now: now)
            }
    }

    func cancel() {
        cancellable?.cancel()
        cancellable = nil
    }

    func reset() {
        cancel()
        progressPublisher.send(0)
    }

    // MARK: - Progress Handling
    private func update(now: Date) {
        guard let startDate = startDate else { return }

        let elapsed = now.timeIntervalSince(startDate)
        let progress = min(Float(elapsed / duration), 1)

        progressPublisher.send(progress)

        if elapsed >= duration {
            finishedPublisher.send(())
            cancel()
        }
    }
}
