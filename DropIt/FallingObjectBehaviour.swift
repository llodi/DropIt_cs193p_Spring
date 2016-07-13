//
//  FallingObjectBehaviour.swift
//  DropIt
//
//  Created by Ilya Dolgopolov on 12.07.16.
//  Copyright © 2016 Ilya Dolgopolov. All rights reserved.
//

import UIKit

//объединение всех элементов поведения анимации в один класс
//в котором производится настройка всех поведений
class FallingObjectBehaviour: UIDynamicBehavior {
    
    //гравитация - поведение при падеии объектов
    private let gravity = UIGravityBehavior()
    
    //столкновение - поведение, 
    //когда объекты добавленные сюда сталкиваются
    private let collider: UICollisionBehavior = {
        
        let collider = UICollisionBehavior()
        
        //задает границы, за кот-е добавленные объекты на проваливаютя
        //границы - view, что добавлено как reference в анимацию
        collider.translatesReferenceBoundsIntoBoundary = true
        
        return collider
    }()
    
    //настройки поведения каждого элемента
    //что добавлены в участники
    private let itemBehaviour: UIDynamicItemBehavior = {
       let dib = UIDynamicItemBehavior()
        
        //выключение ротации (кручения)
        dib.allowsRotation = false
        
        //прыгучесть: 1.0-сильно, 0.1 - слабо
        dib.elasticity = 0.5
        
        return dib
    }()
    
    //добавляет объект - барьер
    //от него объекты отталкиваются
    func addBarrier(path: UIBezierPath, named name: String) {
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
    
    //конструктор: при создании объекта добавляются поведения
    //что настроены ранее
    override init() {
        super.init() 
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(itemBehaviour)
    }
    
    //метод добавляет элементы (UIView) - кубики
    //будут участвовать в анимации
    func addItem(item: UIDynamicItem) {
        gravity.addItem(item)
        collider.addItem(item)
        itemBehaviour.addItem(item)
    }
    
    //удаляем элементы из аниации
    func removeItem(item: UIDynamicItem) {
        gravity.removeItem(item)
        collider.removeItem(item)
        itemBehaviour.removeItem(item)
        
    }
}
