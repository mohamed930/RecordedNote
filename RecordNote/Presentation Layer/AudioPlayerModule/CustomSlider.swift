//
//  CustomSlider.swift
//  RecordNote
//
//  Created by Mohamed Ali on 13/06/2026.
//

import Combine
import UIKit
import SwiftUI

struct CustomSlider: UIViewRepresentable {

    @Binding var value: Float
    var range: ClosedRange<Float>

    var onEditingChanged: ((Bool) -> Void)?

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()

        slider.minimumValue = range.lowerBound
        slider.maximumValue = range.upperBound

        slider.minimumTrackTintColor = .A_78_BFA
        slider.maximumTrackTintColor = .EDE_9_FE
        slider.thumbTintColor = .A_78_BFA

        let image = UIImage(systemName: "circle.fill")?
            .withTintColor(.A_78_BFA, renderingMode: .alwaysOriginal)

        slider.setThumbImage(image, for: .normal)

        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )

        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.touchDown),
            for: .touchDown
        )

        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.touchUp),
            for: [.touchUpInside, .touchUpOutside, .touchCancel]
        )

        return slider
    }

    func updateUIView(
        _ uiView: UISlider,
        context: Context
    ) {
        uiView.minimumValue = range.lowerBound
        uiView.maximumValue = range.upperBound

        let clampedValue = min(max(value, range.lowerBound), range.upperBound)
        if abs(uiView.value - clampedValue) > 0.001 {
            uiView.value = clampedValue
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {

        let parent: CustomSlider

        init(_ parent: CustomSlider) {
            self.parent = parent
        }

        @objc
        func valueChanged(_ sender: UISlider) {
            parent.value = sender.value
        }

        @objc
        func touchDown() {
            parent.onEditingChanged?(true)
        }

        @objc
        func touchUp() {
            parent.onEditingChanged?(false)
        }
    }
}
