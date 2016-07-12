//
//  NamedBezierPathsView.swift
//  DropIt
//
//  Created by Ilya Dolgopolov on 12.07.16.
//  Copyright © 2016 Ilya Dolgopolov. All rights reserved.
//

import UIKit

class NamedBezierPathsView: UIView {
    
    var bezierPaths = [String:UIBezierPath]() { didSet { setNeedsDisplay() } }
    
    override func drawRect(rect: CGRect) {
        for (_, path) in bezierPaths{
            path.stroke()
        }
    }
}
