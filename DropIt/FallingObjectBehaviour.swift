//
//  FallingObjectBehaviour.swift
//  DropIt
//
//  Created by Ilya Dolgopolov on 12.07.16.
//  Copyright © 2016 Ilya Dolgopolov. All rights reserved.
//

import UIKit

class FallingObjectBehaviour: UIDynamicBehavior {
    
    private let gravity = UIGravityBehavior()
    
    private let collider: UICollisionBehavior = {
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true
        return collider
    }()
    
    private let itemBehaviour: UIDynamicItemBehavior = {
       let dib = UIDynamicItemBehavior()
        dib.allowsRotation = false
        dib.elasticity = 0.75
        return dib
    }()
    
    func addBarrier(path: UIBezierPath, named name: String) {
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
    
    override init() {
        super.init() 
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(itemBehaviour)
    }
    
    func addItem(item: UIDynamicItem) {
        gravity.addItem(item)
        collider.addItem(item)
        itemBehaviour.addItem(item)
    }
    
    func removeItem(item: UIDynamicItem) {
        gravity.removeItem(item)
        collider.removeItem(item)
        itemBehaviour.removeItem(item)
        
    }
}
