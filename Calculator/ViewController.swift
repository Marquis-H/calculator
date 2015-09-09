//
//  ViewController.swift
//  Calculator
//
//  Created by Marquis on 15/8/26.
//  Copyright (c) 2015年 Marquis. All rights reserved.
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
    var brain = CalculatorBrain()
    
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

    @IBAction func setReturn() {
        changeNumber = false
        if let result = brain.pushOperand(displayValue){
            displayValue = result
        }else{
            displayValue = 0
        }
    }
    
    @IBAction func reset() {
        changeNumber = false
        brain.evaluate()
        display.text = "0"
    }
    @IBAction func operate(sender: UIButton) {
        if changeNumber{
            setReturn()
        }
        
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(operation){
                displayValue = result
            }else{
                displayValue = 0
            }
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



}

