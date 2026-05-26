//
//  UICollectionView.swift
//  LNJ-Daftar
//
//  Created by Mohamed Ali on 10/02/2024.
//

import UIKit

extension UICollectionView: Reusable {

    func registerNib<Cell: UICollectionViewCell>(cell: Cell.Type) {
        let nibName = Cell.identifier
        self.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
    }
    
    func dequeue<Cell: UICollectionViewCell>(indexPath: IndexPath) -> Cell {
        let nibName = Cell.identifier
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: nibName, for: indexPath) as? Cell else {
            fatalError("Error in cell")
        }
        return cell
    }
    
}

extension UICollectionViewCell: Reusable {}
