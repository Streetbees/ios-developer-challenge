//
//  NSNotificationCenter+MainThread.swift
//  PerculaFoundation
//
//  Created by Andy on 05/10/2015.
//  Copyright © 2015 Percula Software. All rights reserved.
//

import Foundation

extension NSNotificationCenter {
    
    public func postNotificationOnMainThread(notification: NSNotification) {
        self.performSelectorOnMainThread(#selector(NSNotificationCenter.postNotification(_:)), withObject: notification, waitUntilDone: true)
    }
    
}