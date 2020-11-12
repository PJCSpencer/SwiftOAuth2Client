//
//  UIKit+Additions.swift
//
//  Created by Peter Spencer on 14/07/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import UIKit


// MARK: - Protocol
protocol PJCGeometryLayout
{
    func updateLayout(_ container: UIView?)
}

protocol PJCGeometry
{
    static var fixedSize: CGSize { get }
}

protocol PJCDynamicGeometry
{
    func calculatedSize() -> CGSize
}

