//
//  sbUIKit-Ext.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


protocol Geometry
{
    static var fixedSize: CGSize { get }
}

protocol DynamicGeometry
{
    func calculatedSize() -> CGSize
}

protocol GeometrySpacing
{
    static var marginSize: CGSize { get }
}

protocol GeometryLayout
{
    func updateLayout(_ container: UIView?)
}

enum Device
{
    case iPhone5, iPhone6, iPhone6Plus, iPhoneX
    case iPadAir, iPadPro9, iPadPro12
    case Unkown
    
    static let iPhoneTable: [Int:Device]    = [568:.iPhone5, 667:.iPhone6, 736:.iPhone6Plus, 812:.iPhoneX]
    static let iPadTable: [Int:Device]      = [768:.iPadAir, 834:.iPadPro9, 1024:.iPadPro12]
    
    static var current: Device
    {
        let isLandscape: Bool = UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)
        let tag: Int = Int(isLandscape ? UIScreen.main.bounds.width : UIScreen.main.bounds.height)
        let table = UIDevice.current.userInterfaceIdiom == .phone ? Device.iPhoneTable : Device.iPadTable
        
        guard let unwrapped = table[tag] else { return .Unkown }
        return unwrapped
    }
}

extension CGFloat
{
    func wscale(_ device: Device? = nil) -> CGFloat
    { return CGSize.wscale(self, device: device) }
    
    func hscale(_ device: Device? = nil) -> CGFloat
    { return CGSize.hscale(self, device: device) }
}

extension CGSize
{
    // MARK: - Constant(s)
    
    static let deviceDefault: Device = .iPhone5
    
    static let deviceTable: [Device:CGSize] =
    [
        .iPhone5        : CGSize(width: 320.0, height: 568.0),
        .iPhone6        : CGSize(width: 375.0, height: 667.0),
        .iPhone6Plus    : CGSize(width: 414.0, height: 736.0),
        .iPhoneX        : CGSize(width: 375.0, height: 812.0),
        .iPadAir        : CGSize(width: 768.0, height: 1024.0),
        .iPadPro9       : CGSize(width: 834.0, height: 1112.0),
        .iPadPro12      : CGSize(width: 1024.0, height: 1366.0)
    ]
    
    
    // MARK: - Initialisation
    
    init(device: Device? = nil)
    {
        self.init()
        
        let src: Device = device ?? Device.current
        guard let size: CGSize = CGSize.deviceTable[src] else
        { return }
        
        self.width = size.width
        self.height = size.height
    }
    
    
    // MARK: - Scaling Utility(s)
    
    func scale(_ device: Device? = nil) -> CGSize
    {
        return CGSize(width: self.wscale(device),
                      height: self.hscale(device))
    }
    
    func wscale(_ device: Device? = nil) -> CGFloat
    { return CGSize.wscale(self.width, device: device) }
    
    static func wscale(_ points: CGFloat,
                       device: Device? = nil) -> CGFloat
    {
        let src: Device = device ?? deviceDefault
        let ramp: CGFloat = 1.0 / CGSize(device: src).width * points
        
        return CGSize(device: nil).width * ramp
    }
    
    func hscale(_ device: Device? = nil) -> CGFloat
    { return CGSize.hscale(self.height, device: device) }
    
    static func hscale(_ points: CGFloat,
                       device: Device? = nil) -> CGFloat
    {
        let src: Device = device ?? deviceDefault
        let ramp: CGFloat = 1.0 / CGSize(device: src).height * points
        
        return CGSize(device: nil).height * ramp
    }
}

