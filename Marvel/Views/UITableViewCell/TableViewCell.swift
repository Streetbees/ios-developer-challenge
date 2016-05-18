//
//  TableViewCell.swift
//  Marvel
//
//  Created by Gabriel Massana on 18/5/16.
//  Copyright © 2016 Gabriel Massana. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    //MARK: - Identifier
    
    /**
     Help class function to return the cell reuseIdentifier.
     */
    class func reuseIdentifier() -> String {
        
        return NSStringFromClass(self.self)
    }
    
    //MARK: - Layout
    
    /**
     Help function to call auto-layout methods.
     */
    func layoutByApplyingConstraints() {
        
        self.updateConstraintsIfNeeded()
        
        self.layoutIfNeeded()
    }
}
