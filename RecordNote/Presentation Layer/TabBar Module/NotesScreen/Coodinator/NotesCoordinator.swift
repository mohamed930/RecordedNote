//
//  NotesCoordinator.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import UIKit

final class NotesCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    private let title = ""
    private let imgName: UIImage = .unSelectedNotes
    private let selectedimgName: UIImage = .selectedNotes

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() {
        let viewModel      = NotesViewModel(coordinator: self, useCases: NotesUseCases(notesRepository: NotesRespotery(realm: RealmStorage()), audioPlayer: AudioPlayerService()))
        let viewController = NotesViewController(viewModel: viewModel)
        viewController.tabBarItem = UITabBarItem(title: title, image: imgName, selectedImage: selectedimgName)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func moveToNewNoteScreen() {
        let coordinator = NewNoteCoordinator(navigationController: navigationController,cameFromTabBar: false)
        add(coordinator: coordinator)
        coordinator.start()
    }
    
    func moveToNoteDetailsScreen(note: NoteRealModelInfoModel) {
        let coordinator = NoteDetailsCoordinator(navigationController: navigationController, note: note)
        add(coordinator: coordinator)
        coordinator.start()
    }
}
