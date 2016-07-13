//
//  NamedBezierPathsView.swift
//  DropIt
//
//  Created by Ilya Dolgopolov on 12.07.16.
//  Copyright © 2016 Ilya Dolgopolov. All rights reserved.
//

import UIKit

//класс для фигур от которых будут отталкиваться кубики
class NamedBezierPathsView: UIView {
    
    //словарь
    var bezierPaths = [String:UIBezierPath]() { didSet { setNeedsDisplay() } }
    
    //отрисовка фигуры
    override func drawRect(rect: CGRect) {
        for (_, path) in bezierPaths{
            path.stroke()
        }
    }
}
