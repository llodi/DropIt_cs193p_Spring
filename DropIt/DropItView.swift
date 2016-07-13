//
//  DropItView.swift
//  DropIt
//
//  Created by Ilya Dolgopolov on 12.07.16.
//  Copyright © 2016 Ilya Dolgopolov. All rights reserved.
//

import UIKit

class DropItView: NamedBezierPathsView, UIDynamicAnimatorDelegate {
    
    private var dropBehaviour = FallingObjectBehaviour()
    
    //анимация через lazy - будет инициализировано
    //когда будет создан объект или первый вызов
    private lazy var animator: UIDynamicAnimator = {
        //инициализация анимации
        let animator = UIDynamicAnimator(referenceView: self)
        animator.delegate = self
        return animator
    }()
    
    //реализация протокола UIDynamicAnimatorDelegate
    //срабатывает когда поведение анимации останавливается либо замирает
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
         removeCompleteRow()
    }
    
    //включатель/выключатель анимации
    var animating: Bool = false {
        didSet {
            if animating {
                //добавляет поведение для анимации
                animator.addBehavior(dropBehaviour)
            } else {
                //убирает поведение
                animator.removeBehavior(dropBehaviour)
            }
        }
    }
    
    private var attachment: UIAttachmentBehavior? {
        willSet {
            if attachment != nil {
                animator.removeBehavior(attachment!)
                bezierPaths[PathNames.Attachment] = nil
            }
        }
        didSet {
            if attachment != nil {
                animator.addBehavior(attachment!)
                attachment!.action = { [unowned self] in
                    if let attachedDrop = self.attachment!.items.first as? UIView {
                        self.bezierPaths[PathNames.Attachment] =
                            UIBezierPath.lineFrom(self.attachment!.anchorPoint, to: attachedDrop.center)
                    }
                }
            }
        }
    }
    
    
    //удаляет строку с кубиками, когда все 10 в строке
    private func removeCompleteRow() {
        //массив для удаления
        var dropsToRemove = [UIView]()
        //инициализация объекта
        var hitTestRect = CGRect(origin: bounds.lowerLeft, size: dropSize)
        
        repeat {
            //начало строки
            hitTestRect.origin.x = bounds.minX
            //
            hitTestRect.origin.y -= dropSize.height
            
            //счетчик проверки
            var dropsTested = 0
            //найденые вью
            var dropsFound = [UIView]()
            //цикл пробегат в строке и добавляет найденые кубики
            while dropsTested < dropsPerRow {
                //если в отмеченной области есть кубик добавляется в массив
                if let hitView = hitTest(hitTestRect.mid) where hitView.superview == self {
                    dropsFound.append(hitView)
                } else {
                    break
                }
                //переход к следующей области где может быть кубик
                hitTestRect.origin.x += dropSize.width
                dropsTested += 1
            }
            //добавление в массив строк с кубиками под удаление
            if dropsTested == dropsPerRow {
                dropsToRemove += dropsFound
            }
        } while dropsToRemove.count == 0 && hitTestRect.origin.y > bounds.minY
        
        //удаление кубиков
        for drop in dropsToRemove {
            dropBehaviour.removeItem(drop)
            drop.removeFromSuperview()
        }
    }
    
    private struct PathNames {
        static let MiddleBarrier = "Middle Barrier"
        static let Attachment = "Attachment"
        
    }
    
    
    //в момент формирования layout отрисовывается объект
    override func layoutSubviews() {
        super.layoutSubviews()
        //создание фигуры
        let path = UIBezierPath(ovalInRect: CGRect(center: bounds.mid, size: dropSize))
        //добавление фигуры
        dropBehaviour.addBarrier(path, named: PathNames.MiddleBarrier)
        //добавляем в словарь фигуру
        //после срабатывает метод setNeedsDisplay для отрисовки - drawRect
        bezierPaths[PathNames.MiddleBarrier] = path
    }
    
    func grabDrop(recognizer: UIPanGestureRecognizer) {
        let gesturePoint = recognizer.locationInView(self)
        switch recognizer.state {
        case .Began:
            //create attachment
            if let dropToAttachTo = lastDrop where dropToAttachTo.superview != nil {
                attachment = UIAttachmentBehavior(item: dropToAttachTo, attachedToAnchor: gesturePoint)
            }
            lastDrop = nil
        case .Changed:
            //change attachment's anchor point
            attachment?.anchorPoint = gesturePoint
        default: attachment = nil
        }
    }
    
    //количество кубиков в строке
    private let dropsPerRow = 10
    
    //размер кубика:
    //ширна: ширина view деленая на кол-во кубиков в строке
    private var dropSize: CGSize {
        let size = bounds.size.width / CGFloat(dropsPerRow)
        return CGSize(width: size, height: size)
    }
    
    private var lastDrop: UIView?
    
    //добавляет кубик в view
    func addDrop() {
        //внешние границы
        var frame = CGRect(origin: CGPoint.zero, size: dropSize)
        //рандомно определяется координата x
        frame.origin.x = CGFloat.random(dropsPerRow) * dropSize.width
        
        let drop = UIView(frame: frame)
        drop.backgroundColor = UIColor.random
        
        addSubview(drop)
        dropBehaviour.addItem(drop)
        lastDrop = drop
    }
    
}
