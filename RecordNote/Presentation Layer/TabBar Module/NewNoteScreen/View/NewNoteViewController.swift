//
//  NewNoteViewController.swift
//  RecordNote
//
//  Created Mohamed Ali on 03/06/2026.
//

import UIKit

final class NewNoteViewController: UIViewController {

    // MARK:- Private
    private var viewModel: NewNoteViewModel

    init(viewModel: NewNoteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addHosting(NewNoteView(viewModel: viewModel))
    }
}

