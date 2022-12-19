//
//  ReusableViewCell+Helper.swift
//  ImageMachine
//
//  Created by Phincon on 15/12/22.
//

import Foundation
import UIKit

// MARK: - Reusable View Cell Protocol
/// Protocol to conform `UITableViewCell` and `UICollectionViewCell` have reusable function and properties
public protocol ReusableViewCell: AnyObject {
    
    static var cellIdentifier: String { get }
}

public extension ReusableViewCell {
    
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

// MARK: - UITableView
extension UITableView {
    
    /// Register class of `UITableViewCell` to reusable
    /// Call `register(cell: UITableViewCell.self)`
    final func register<T: UITableViewCell>(cell: T.Type) where T: ReusableViewCell {
        self.register(T.self, forCellReuseIdentifier: cell.cellIdentifier)
    }
    
    /// Register class of `UITableViewHeaderFooterView` to reusable
    /// Call `register(cell: UITableViewHeaderFooterView.self)`
    final func register<T: UITableViewHeaderFooterView>(headerFooter: T.Type) where T: ReusableViewCell {
        self.register(T.self, forHeaderFooterViewReuseIdentifier: headerFooter.cellIdentifier)
    }
    
    /// Dequeue class of `UITableViewCell` of reusable
    /// Call `dequeueReusableCell(for: indexPath, cell: UITableViewCell.self)`
    final func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cell: T.Type = T.self) -> T where T: ReusableViewCell {
        guard let reusableCell = self.dequeueReusableCell(withIdentifier: cell.cellIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue cell with identifier \(cell.cellIdentifier) matching type \(cell.self)")
        }
        
        return reusableCell
    }
}

extension UITableViewCell {
    
    /// Reuse cellIdentifier string
    static var cellIdentifier: String {
        return String(describing: self)
    }
}
