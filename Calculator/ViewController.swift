//
//  ViewController.swift
//  Calculator
//
//  Created by 侯德善 on 15/8/26.
//  Copyright (c) 2015年 侯德善. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var changeNumber: Bool = false
    
    @IBOutlet weak var display: UILabel!

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if changeNumber {
            display.text = display.text! + digit
        }else{
            display.text = digit
            changeNumber = true
        }
    }
    
    var openStack = Array<Double>()
    

    @IBAction func setReturn() {
        changeNumber = false
        openStack.append(displayValue)
        
        println("\(openStack)")
    }
    
    @IBAction func reset() {
        changeNumber = false
        openStack = []
        
        display.text = "0"
        println("\(openStack)")
    }
    @IBAction func operate(sender: UIButton) {
        let operateName = sender.currentTitle
        if changeNumber{
            setReturn()
        }
        switch operateName! {
        case "+": performOperate({$0 + $1})
        case "−": performOperate({$1 - $0})
        case "x": performOperate({$0 * $1})
        case "÷": performOperate({$1 / $0})
        case "√": performOperate({(op1) in  sqrt(op1) })
        default: break
        }
    }
    
    var displayValue: Double{
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            changeNumber = false
        }
    }

    private func performOperate(operate: (Double, Double)->Double){
        if openStack.count >= 2 {
            displayValue = operate(openStack.removeLast(), openStack.removeLast())
            setReturn()
        }
    }
    
    private func performOperate(operate: Double->Double){
        if openStack.count >= 1 {
            displayValue = operate(openStack.removeLast())
            setReturn()
        }
    }


}

