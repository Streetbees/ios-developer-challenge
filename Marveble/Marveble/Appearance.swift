//
//  Appearance.swift
//  Marveble
//
//  Created by André Abou Chami Campana on 26/04/2016.
//  Copyright © 2016 Bell App Lab. All rights reserved.
//

import UIKit


struct Appearance
{
    static func customise()
    {
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "Futura-CondensedMedium", size: 18)!, NSForegroundColorAttributeName: UIColor.marvelRed()]
        UINavigationBar.appearance().tintColor = UIColor.marvelRed()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Futura-CondensedMedium", size: 16)!], forState: .Normal)
    }
}


extension UIColor
{
    static func marvelRed() -> UIColor
    {
        return UIColor(red:0.940,  green:0.076,  blue:0.117, alpha:1)
    }
}
