//
//  setTimer.swift
//  LNJ
//
//  Created by Mohamed Ali on 31/05/2023.
//

import Foundation
import Combine

class TimerManager {
    weak private var timer: Timer?
    private var remainingTime: TimeInterval// 8 minutes in seconds
    private var originalremainingTime: Double
    
    
    private var hourBehaviour = CurrentValueSubject<Int,Never>(0)
    private var minutesBehaviour = CurrentValueSubject<Int,Never>(0)
    private var secondsBehaviour = CurrentValueSubject<Int,Never>(0)
    
    private var hoursObservable: AnyPublisher<Int,Never> {
        return hourBehaviour.eraseToAnyPublisher()
    }
    
    private var minutesObservable: AnyPublisher<Int,Never> {
        return minutesBehaviour.eraseToAnyPublisher()
    }
    private var secondssObservable: AnyPublisher<Int,Never> {
        return secondsBehaviour.eraseToAnyPublisher()
    }
    
    var stopBehaviour = CurrentValueSubject<Bool,Never>(false)
    
    var remainTimerPublisher: AnyPublisher<(Int, Int, Int), Never> {
        return Publishers.CombineLatest3(
            hoursObservable,
            minutesObservable,
            secondssObservable
        )
        .map { (hours, minutes, seconds) in
            return (hours, minutes, seconds)
        }
        .eraseToAnyPublisher()
    }
    
    init(remainingTime: Double) {
        self.remainingTime = TimeInterval(remainingTime)
        self.originalremainingTime = remainingTime
    }
    
    func startTimer() {
        self.remainingTime = TimeInterval(originalremainingTime)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
            let hours = Int(remainingTime) / 3600
            let minutes = Int(remainingTime) % 3600 / 60
            let seconds = Int(remainingTime) % 60
            
            hourBehaviour.send(hours)
            minutesBehaviour.send(minutes)
            secondsBehaviour.send(seconds)
        } else {
            stopTimer()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        print("Timer stopped")
        
        stopBehaviour.send(true)
    }
    
    func stopTimerInBackGround() {
        timer?.invalidate()
        timer = nil
    }
}
