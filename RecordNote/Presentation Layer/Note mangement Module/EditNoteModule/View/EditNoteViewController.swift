//
//  EditNoteViewController.swift
//  RecordNote
//
//  Created by Mohamed Ali on 29/06/2026.
//

import UIKit

class EditNoteViewController: UIViewController {
    
    // MARK:- Private
    private var viewModel: EditNoteViewModel
    
    init(viewModel: EditNoteViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addHosting(EditNoteView(viewModel: viewModel))
    }
}
