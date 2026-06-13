//
//  AudioPlayerProtocol.swift
//  RecordNote
//
//  Created by Mohamed Ali on 13/06/2026.
//

import Foundation
import Combine

protocol AudioPlayerProtocol: AnyObject {
    
    var currentTimePublisher: AnyPublisher<Double, Never> { get }

    var durationPublisher: AnyPublisher<Double, Never> { get }

    var statePublisher: AnyPublisher<AudioPlayerStateValues, Never> { get }

    func load(_ item: AudioItem)

    func play()

    func pause()

    func seek(to seconds: Double)

    func stop()
}
