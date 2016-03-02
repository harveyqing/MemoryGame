//
//  ViewController.swift
//  MemoryGame
//
//  Created by qingtian on 16/1/7.
//  Copyright © 2016年 qingtian. All rights reserved.
//

import UIKit

/**
    Levels of difficulty.
*/
enum Difficulty {
    case Easy
    case Medium
    case Hard
}

class ViewController: UIViewController {
    
    // MARK: properties
    
    let buttonWidth = 200
    let buttonHeight = 50

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        NSLog("the view: %@", self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


/**
    The basic menu screen view logics
*/
private extension ViewController {

    func setup() {
        let viewCenterX = view.center.x
        let viewCenterY = view.center.y

        view.backgroundColor = UIColor.greenSea()
        
        buildButtonWithCenter(
            CGPoint(x: viewCenterX, y: viewCenterY / 2.0),
            title: "EASY",
            color: UIColor.emerald(),
            action: "onEasyTapped:"
        )
        
        buildButtonWithCenter(
            CGPoint(x: viewCenterX, y: viewCenterY),
            title: "MEDIUM",
            color: UIColor.sunflower(),
            action: "onMediumTapped:"
        )
        
        buildButtonWithCenter(
            CGPoint(x: viewCenterX, y: viewCenterY * 3.0 / 2.0),
            title: "HARD",
            color: UIColor.alizarin(),
            action: "onHardTapped:"
        )
    }
    
    // MARK: - BuildButton
    
    /**
        Build a `UIButton` object with specified parameters and add it to the current view.
        
        - parameter center: The button object's center point.
        - parameter title:  The button object's caption.
        - parameter color:  The button object's background color.
        - parameter action: The action method called when `TouchUpInside` occurs.
    */
    func buildButtonWithCenter(
        center: CGPoint,
        title: String,
        color: UIColor,
        action: Selector)
    {
        let button = UIButton()
        
        button.setTitle(title, forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        button.frame = CGRect(
            origin: CGPoint(x: 0, y: 0),
            size: CGSize(width: buttonWidth, height: buttonHeight)
        )
        button.center = center
        button.backgroundColor = color
        
        // connect a callback to an event
        button.addTarget(
            self,
            action: action,
            forControlEvents: .TouchUpInside
        )
        
        view.addSubview(button)
    }

}

/**
    The basic menu screen action logics
*/
extension ViewController {
    func onEasyTapped(sender: UIButton) {
        newGameDifficulty(.Easy)
    }
    
    func onMediumTapped(sender: UIButton) {
        newGameDifficulty(.Medium)
    }
    
    func onHardTapped(sender: UIButton) {
        newGameDifficulty(.Hard)
    }
    
    func newGameDifficulty(difficulty: Difficulty) {
        let gameViewController = MemoryViewController(difficulty: difficulty)
        
        presentViewController(gameViewController, animated: true, completion: nil)
    }
}

/**
    A utility for generating UI color
*/
private extension UIColor {
    class func colorComponets(
        components: (CGFloat, CGFloat, CGFloat)) -> UIColor
    {
        return UIColor(
            red: components.0 / 255,
            green: components.1 / 255,
            blue: components.2 / 255,
            alpha: 1
        )
    }
}

extension UIColor {
    class func greenSea() -> UIColor {
        return UIColor.colorComponets((22, 160, 133))
    }
    
    class func emerald() -> UIColor {
        return UIColor.colorComponets((46, 204, 113))
    }
    
    class func sunflower() -> UIColor {
        return UIColor.colorComponets((241, 196, 15))
    }
    
    class func alizarin() -> UIColor {
        return UIColor.colorComponets((231, 76, 60))
    }
}