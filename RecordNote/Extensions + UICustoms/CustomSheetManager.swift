//
//  CustomSheetManager.swift
//  Akarom
//
//  Created by Mohamed Ali on 22/08/2025.
//

import SwiftUI
import Combine
import BottomSheet

final class CustomSheetManager: ObservableObject {

    @Published var isPresented = false

    // MARK: Position

    @Published var position: BottomSheetPosition = .hidden
    @Published var switchablePositions: [BottomSheetPosition] = []

    // MARK: Appearance

    @Published var showDragIndicator = true
    @Published var showCloseButton = false

    @Published var backgroundBlur = true
    @Published var overlayOpacity: Double = 0.4
    @Published var showsOverlay: Bool = true

    @Published var animation: Animation? = .easeInOut

    // MARK: Interaction

    @Published var isResizable = true
    @Published var enableContentDrag = true
    @Published var enableSwipeToDismiss = true
    @Published var enableTapToDismiss = true
    @Published var enableFlickThrough = true

    @Published var enableKeyboard = true
    @Published var enableAppleScrollBehavior = true
    @Published var enableFloatingIPadSheet = false

    // MARK: Width

    @Published var sheetWidth: BottomSheetWidth = .platformDefault

    // MARK: Threshold

    @Published var threshold: Double = 0.3

    // MARK: Callbacks

    var onDismiss: (() -> Void)?
    var onDragChanged: ((DragGesture.Value) -> Void)?
    var onDragEnded: ((DragGesture.Value) -> Void)?
}

extension View {

    func appBottomSheet<SheetContent: View>(
        manager: CustomSheetManager,
        @ViewBuilder content: @escaping () -> SheetContent
    ) -> some View {

        self
            .bottomSheetOverlay(
                isPresented:manager.showsOverlay && manager.position != .hidden,
                opacity: manager.overlayOpacity
            ) {
                if manager.enableTapToDismiss {
                    manager.position = .hidden
                }
            }
            .bottomSheet(
                bottomSheetPosition: Binding(
                    get: { manager.position },
                    set: { manager.position = $0 }
                ),
                switchablePositions: manager.switchablePositions
            ) {
                content()
            }
            .showDragIndicator(manager.showDragIndicator)
            .showCloseButton(manager.showCloseButton)
            .enableSwipeToDismiss(manager.enableSwipeToDismiss)
            .enableTapToDismiss(manager.enableTapToDismiss)
            .enableContentDrag(manager.enableContentDrag)
            .enableFlickThrough(manager.enableFlickThrough)
            .enableAccountingForKeyboardHeight(manager.enableKeyboard)
            .enableAppleScrollBehavior(manager.enableAppleScrollBehavior)
            .enableFloatingIPadSheet(manager.enableFloatingIPadSheet)
            .sheetWidth(manager.sheetWidth)
            .customThreshold(manager.threshold)
            .isResizable(manager.isResizable)
            .customAnimation(manager.animation)
            .customBackground(
                Color.white
                    .cornerRadius(30, corners: [.topLeft,.topRight])
            )
            .onChange(of: manager.position) { newPosition in
                if newPosition == .hidden {
                    print("✅ BottomSheet dismissed")
                    manager.onDismiss?()
                }
            }
    }
    
    @ViewBuilder
    func bottomSheetOverlay(
        isPresented: Bool,
        opacity: Double = 0.4,
        onTap: (() -> Void)? = nil
    ) -> some View {

        self.overlay {
            if isPresented {
                Color.black
                    .opacity(opacity)
                    .ignoresSafeArea()
                    .onTapGesture {
                        onTap?()
                    }
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isPresented)
    }
}
