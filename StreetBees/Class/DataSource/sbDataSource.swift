//
//  sbDataSource.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


let SBDataSourceDidSelectNotification = Notification.Name(rawValue: "com.street-bees.dataSource.didSelect")

protocol DataSourceRegistered
{
    associatedtype RegisterType
    
    func register(_ dataView: RegisterType)
}

class DataSource: NSObject
{
    // MARK: - Property(s)
    
    fileprivate var sections: [DataSourceSection] = []
    
    
    // MARK: - Initialisation
    
    init(with objects: [DataSourceSection])
    {
        super.init()
        
        self.sections.append(contentsOf: objects)
    }
    
    
    // MARK: - Accessing Sections
    
    func allSections() -> [DataSourceSection]
    { return self.sections }
    
    func section(at index: Int) -> DataSourceSection?
    {
        guard let section = self.sections[index] as DataSourceSection? else
        { return nil }
        
        return section
    }
}

