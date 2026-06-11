//
//  NoteDetailsViewController.swift
//  RecordNote
//
//  Created Mohamed Ali on 11/06/2026.
//

import UIKit

final class NoteDetailsViewController: UIViewController {

    // MARK:- Private
    private var viewModel: NoteDetailsViewModel

    init(viewModel: NoteDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addHosting(NoteDetailsView(viewModel: viewModel))
    }
}

