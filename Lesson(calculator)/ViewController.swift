//
//  ViewController.swift
//  Lesson(calculator)
//
//  Created by Лаки on 24.10.17.
//  Copyright © 2017 Lucky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var userInTheMiddleOfTyping = false
    private var dotAlreadySet = false
    private var secondTurnOn = false
    

    @IBOutlet private var sinButton: RoundButton!
    @IBOutlet private var cosButton: RoundButton!
    @IBOutlet private var tanButton: RoundButton!
    @IBOutlet private var coshButton: RoundButton!
    @IBOutlet private var sinhButton: RoundButton!
    @IBOutlet private var tanhButton: RoundButton!
    @IBOutlet private var exButton: RoundButton!
    @IBOutlet private var lnButton: RoundButton!
    @IBOutlet private var logButton: RoundButton!
    @IBOutlet private var tenXButton: RoundButton!
    
    @IBOutlet weak var plusButton: RoundButton!
    @IBOutlet weak var minusButton: RoundButton!
    @IBOutlet weak var divideButton: RoundButton!
    @IBOutlet weak var multButton: RoundButton!
    @IBOutlet private var clearAC: RoundButton!
    @IBOutlet private var display: UILabel!
    @IBOutlet private var radDisplay: UILabel!
    
    @IBAction func dotSet(_ sender: UIButton) {
        let dot = "."
        
        let textCurrentlyInDisplay = display.text ?? "0"
        if !dotAlreadySet && floor(Double(display.text!)!) == Double(display.text!) && display.text != nil {
            display.text = textCurrentlyInDisplay + dot
            dotAlreadySet = true
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        guard let digit = sender.currentTitle else {return}
        brain.buttonPressed = false
        if userInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            brain.checkPressedButton()
            changeButtonColor()
            if display.text != "0" {
            clearAC.setTitle("C", for: UIControlState.normal)
            }
            userInTheMiddleOfTyping = true
        }
    }
    var displayValue: Double {
        get {
            return Double(display.text ?? "0") ?? 0
        }
        set {
            if  floor(newValue) == newValue && newValue < Double(Int.max) && newValue > Double(Int.min) {
            display.text = String(Int(newValue))
            }
            else {
                 display.text = String(newValue)
            }
        }
    }
    private var brain = CalculatorBrain()
    

    @IBAction func makeFuncChange(_ sender: Any) {
        if !secondTurnOn {
            sinButton.setTitle("sin⁻¹", for: UIControlState.normal)
            cosButton.setTitle("cosh⁻¹", for: UIControlState.normal)
            tanButton.setTitle("tan⁻¹", for: UIControlState.normal)
            sinhButton.setTitle("sinh⁻¹", for: UIControlState.normal)
            coshButton.setTitle("cosh⁻¹", for: UIControlState.normal)
            tanhButton.setTitle("tanh⁻¹", for: UIControlState.normal)
            exButton.setTitle("yˣ", for: UIControlState.normal)
            lnButton.setTitle("logₓ", for: UIControlState.normal)
            logButton.setTitle("log₂", for: UIControlState.normal)
            tenXButton.setTitle("2ˣ", for: UIControlState.normal)
            secondTurnOn = true
        }
        else {
            sinButton.setTitle("sin", for: UIControlState.normal)
            cosButton.setTitle("cos", for: UIControlState.normal)
            tanButton.setTitle("tan", for: UIControlState.normal)
            sinhButton.setTitle("sinh", for: UIControlState.normal)
            coshButton.setTitle("cosh", for: UIControlState.normal)
            tanhButton.setTitle("tanh", for: UIControlState.normal)
            exButton.setTitle("ex", for: UIControlState.normal)
            lnButton.setTitle("tanh", for: UIControlState.normal)
            logButton.setTitle("log₁₀", for: UIControlState.normal)
            tenXButton.setTitle("10x", for: UIControlState.normal)
            secondTurnOn = false
        }
    }
    
    @IBAction func undoButton(_ sender: UIButton) {
        brain.doUndoFunction()
        if let result = brain.result {
            displayValue = result
            dotAlreadySet = false
            }
         userInTheMiddleOfTyping = false
        if brain.memoryArrayLength > 0 {
        switch brain.memoryArray[brain.memoryArrayLength].1 {
            case "+": plusButton.setTitleColor(#colorLiteral(red: 1, green: 0.5825584531, blue: 0, alpha: 1), for: UIControlState.normal); plusButton.backgroundColor =  UIColor.white
            case "–": minusButton.setTitleColor(#colorLiteral(red: 1, green: 0.5825584531, blue: 0, alpha: 1), for: UIControlState.normal); minusButton.backgroundColor =  UIColor.white
            case "÷": divideButton.setTitleColor(#colorLiteral(red: 1, green: 0.5825584531, blue: 0, alpha: 1), for: UIControlState.normal); divideButton.backgroundColor = UIColor.white
            case "×": multButton.setTitleColor(#colorLiteral(red: 1, green: 0.5825584531, blue: 0, alpha: 1), for: UIControlState.normal); multButton.backgroundColor =  UIColor.white
            default : print("None")
            }
        }
            if !brain.buttonPressed {
                changeButtonColor()
            }
        
    }
    
    @IBAction func redoButton(_ sender: UIButton) {
        brain.doRedoFunction()
        if let result = brain.result {
            displayValue = result
            dotAlreadySet = false
        }
        userInTheMiddleOfTyping = false
        if brain.memoryArrayLength < brain.memoryArray.count {
        switch brain.memoryArray[brain.memoryArrayLength].1 {
        case "+": plusButton.setTitleColor(#colorLiteral(red: 1, green: 0.5825584531, blue: 0, alpha: 1), for: UIControlState.normal); plusButton.backgroundColor =  UIColor.white
        case "–": minusButton.setTitleColor(#colorLiteral(red: 1, green: 0.5825584531, blue: 0, alpha: 1), for: UIControlState.normal); minusButton.backgroundColor =  UIColor.white
        case "÷": divideButton.setTitleColor(#colorLiteral(red: 1, green: 0.5825584531, blue: 0, alpha: 1), for: UIControlState.normal); divideButton.backgroundColor = UIColor.white
        case "×": multButton.setTitleColor(#colorLiteral(red: 1, green: 0.5825584531, blue: 0, alpha: 1), for: UIControlState.normal); multButton.backgroundColor =  UIColor.white
        default : print("None")
            }
        }
        if !brain.buttonPressed {
            changeButtonColor()
        }
    }
    
    @IBAction func touchRadButton(_ sender: RoundButton) {
        if sender.currentTitle == "Rad" {
            brain.inDeg = false
            print(brain.inDeg)
            sender.setTitle("Deg", for: UIControlState())
            radDisplay.text = ""
        }
        else {
            brain.inDeg = true
            print(brain.inDeg)
            sender.setTitle("Rad", for: UIControlState())
            radDisplay.text = "Deg"
        }
    }
    
    @IBAction func performOPeration(_ sender: UIButton) {
        if brain.buttonPressed == false || sender.currentTitle == "C" {
            if (sender.currentTitle == "+" || sender.currentTitle == "÷" || sender.currentTitle == "–" || sender.currentTitle == "×" )
            {
                sender.setTitleColor(#colorLiteral(red: 1, green: 0.5825584531, blue: 0, alpha: 1), for: UIControlState.normal); sender.backgroundColor =  UIColor.white
                brain.buttonPressed = true
            }
            if userInTheMiddleOfTyping {
                brain.buttonPressed = false
                brain.setOperand(displayValue)
                userInTheMiddleOfTyping = false
            }
            if  let mathematicalSymbol = sender.currentTitle {
                brain.performOperation(mathematicalSymbol)
                if sender.currentTitle == "C" {
                    self.display.text = "0"
                    changeButtonColor()
                }
            }
            if let result = brain.result {
                displayValue = result
                dotAlreadySet = false
                if result == 0 {
                    clearAC.setTitle("AC", for: UIControlState.normal)
                }
            }
        }
    }
    
    private func changeButtonColor() {
        plusButton.setTitleColor(UIColor.white, for: UIControlState.normal); plusButton.backgroundColor =  #colorLiteral(red: 1, green: 0.5825584531, blue: 0, alpha: 1)
        minusButton.setTitleColor(UIColor.white, for: UIControlState.normal); minusButton.backgroundColor =  #colorLiteral(red: 1, green: 0.5825584531, blue: 0, alpha: 1)
        multButton.setTitleColor(UIColor.white, for: UIControlState.normal); multButton.backgroundColor =  #colorLiteral(red: 1, green: 0.5825584531, blue: 0, alpha: 1)
        divideButton.setTitleColor(UIColor.white, for: UIControlState.normal); divideButton.backgroundColor =  #colorLiteral(red: 1, green: 0.5825584531, blue: 0, alpha: 1)
    }
}
