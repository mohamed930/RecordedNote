//
//  HomeCoordinator.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import UIKit

final class HomeCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    private weak var viewModel: HomeViewModel?
    
    private let title = ""
    private let imgName: UIImage = .unselectedHome
    private let selectedimgName: UIImage = .selectedHome

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let viewModel = HomeViewModel(coordinator: self, useCases: NotesUseCases(notesRepository: NotesRespotery(realm: RealmStorage()), audioPlayer: AudioPlayerService()))
        self.viewModel = viewModel
        let viewController = HomeViewController(viewModel: viewModel)
        viewController.tabBarItem =  UITabBarItem(title: title, image: imgName, selectedImage: selectedimgName)
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func moveToNoteDetailsScreen(note: NoteRealModelInfoModel) {
        let coordinator = NoteDetailsCoordinator(
            navigationController: navigationController,
            note: note,
            delegate: self
        )
        coordinator.parantCoordinator = self
        add(coordinator: coordinator)
        coordinator.start()
    }
    
    func moveToNotesScreen() {
        navigationController.tabBarController?.selectedIndex = 3
    }
}

extension HomeCoordinator: NoteDetailsCoordinatorDelegate {
    func noteDetailsCoordinatorDidRequestRefresh(_ coordinator: NoteDetailsCoordinator) {
        viewModel?.refreshNotesContent()
    }
}
