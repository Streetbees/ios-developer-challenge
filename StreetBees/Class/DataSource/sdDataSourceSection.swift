//
//  sdDataSourceSection.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


// MARK: - Creating and Indentifing Cell(s)
@objc protocol DataSourceSectionRegistered
{
    var cellClass: AnyClass? { get }
}

// MARK: - Modifying Cell(s)
@objc protocol DataSourceSectionPresentation
{
    func cell(_ cell: UIView, displayObjectAt index: Int)
    
    func cellSize(forObjectAt index: Int) -> CGSize
}

protocol DataSourceSectionStorage
{
    associatedtype StroreStype
    
    var objects: [StroreStype] { get set }
}

class DataSourceSection
{
    // MARK: - Constant(s)
    
    static let defaultCellHeight: CGFloat = -1.0
    
    
    // MARK: - Property(s)
    
    var tag: Int = -1
    
    var title: String?
    
    var reuseIdentifier: String
    { return String(describing: type(of: self)) }
    
    var objects: [Any] = []
    
    
    // MARK: - Initialisation
    
    init(_ title: String? = nil, with objects: [Any])
    {
        self.title = title ?? self.title
        self.objects.append(contentsOf: objects)
    }
}

// MARK: - DataSourceSectionRegistered Protocol
extension DataSourceSection: DataSourceSectionRegistered
{
    var cellClass: AnyClass?
    { return nil }
}

// MARK: - DataSourceSectionPresentation Protocol
extension DataSourceSection: DataSourceSectionPresentation
{
    func cell(_ cell: UIView, displayObjectAt index: Int) {}
    
    func cellSize(forObjectAt index: Int) -> CGSize
    { return CGSize.zero }
}
