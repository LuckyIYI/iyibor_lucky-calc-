//
//  MathOperation.swift
//  Lesson(calculator)
//
//  Created by Лаки on 27.10.17.
//  Copyright © 2017 Lucky. All rights reserved.
//

import Foundation

func factorialFunc(_ someValue: Int) -> Int {
    var facto = 1
    if someValue < 2 {
        return facto
    }
    if someValue < 20 {
    for i in 2...someValue
        {
        facto *= i;
        }
    }
    return facto
}


func degreesToRadians(_ n: Double) -> Double {
    return n * .pi / 180
}

struct CalculatorBrain {
    
    typealias memoryType = (Double, String)
    private var accumulator :Double?
    private var resultSum: Double?
    private var operandPlusSign: memoryType?
    var inDeg = false
    var memoryArray: [memoryType] = [(0.0,"")]
    var memoryArrayLength = 0
    var buttonPressed = false
    

    private enum Operation {
        case constant (Double)
        case unaryOperation ((Double) -> Double)
        case geomOperation ((Double) -> Double)
        case changeOperation ((Double) -> Double)
        case binaryOperation ((Double, Double) -> Double)
        case equals
        case factorial ((Int) -> Int)
        case ac
    }
    

    private var operations : Dictionary <String,Operation> =
        [
            "π": Operation.constant (Double.pi),
            "e": Operation.constant (M_E),
            "ex": Operation.unaryOperation ({pow(M_E,$0)}),
            "√x": Operation.unaryOperation (sqrt),
            "∛x": Operation.unaryOperation ({pow($0, 1.0 / 3.0) }),
            "ʸ√x": Operation.binaryOperation({pow($0, 1.0 / $1) }),
            "cos": Operation.geomOperation (cos),
            "cos⁻¹": Operation.geomOperation(acos),
            "sin": Operation.geomOperation (sin),
            "sin⁻¹": Operation.geomOperation(asin),
            "tan": Operation.geomOperation (tan),
            "tan⁻¹": Operation.geomOperation(atan),
            "sinh": Operation.geomOperation (sinh),
            "cosh": Operation.geomOperation (cosh),
            "cosh⁻¹": Operation.geomOperation(acosh),
            "tanh": Operation.geomOperation (tanh),
            "tanh⁻¹": Operation.geomOperation(atanh),
            "±": Operation.changeOperation ({-$0}),
            "Rand": Operation.constant (Double(arc4random())),
            "x!": Operation.factorial(factorialFunc),
            "×": Operation.binaryOperation ({$0 * $1}),
            "÷": Operation.binaryOperation ({$0 / $1}),
            "+": Operation.binaryOperation ({$0 + $1}),
            "–": Operation.binaryOperation ({$0 - $1}),
            "2ˣ": Operation.unaryOperation({ pow(2, $0) }),
            "x²": Operation.unaryOperation ({$0 * $0}),
            "xʸ": Operation.binaryOperation({ pow($0, $1) }),
            "yˣ":  Operation.binaryOperation({pow($0, $1)}),
            "x³": Operation.unaryOperation ({$0 * $0 * $0}),
            "%": Operation.unaryOperation ({$0 / 100}),
            "log₁₀": Operation.unaryOperation (log10),
            "log₂": Operation.unaryOperation(log2),
            "ln": Operation.unaryOperation (log2),
            "10ˣ": Operation.unaryOperation({pow(10, $0)}),
            "1/x": Operation.unaryOperation({1.0 / $0}),
            "EE": Operation.binaryOperation({$0 * pow(10, $1)}),
            "AC": Operation.ac,
            "C": Operation.ac,
            "=": Operation.equals,
            ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol]{
            switch operation {
            case .constant(let value):
                if resultSum != nil {
                buttonPressed = false
                resultSum = value
                }
                accumulator = value
            case .unaryOperation (let function):
                buttonPressed = false
                if accumulator != nil && resultSum != nil {
                    resultSum = pendingBinaryOperation!.perform(with: accumulator!)
                    accumulator = function (resultSum!)
                }
                else {
                    accumulator = function (accumulator!)
                    }
            case .geomOperation(let function):
                buttonPressed = false
                if accumulator != nil {
                    if inDeg {
                        accumulator = degreesToRadians(accumulator!)
                    }
                    if pendingBinaryOperation != nil {
                    resultSum = pendingBinaryOperation!.perform(with: accumulator!)
                    accumulator = function (resultSum!)
                    } else {
                        accumulator = function (accumulator!)
                    }
                }
                
            case .changeOperation(let function):
                buttonPressed = false
                if accumulator != nil  {
                    accumulator = function (accumulator!)
                }
            case .binaryOperation (let function):
                if resultSum != nil && accumulator != nil && !buttonPressed {
                    resultSum = pendingBinaryOperation!.perform(with: accumulator!)
                    pendingBinaryOperation = PendingBinaryOperation (function: function, firstOperand: resultSum!)
                    accumulator = resultSum!
                    memoryMagic(symbol: symbol)
                    buttonPressed = true
                }
                if accumulator != nil && (!buttonPressed || pendingBinaryOperation == nil)  {
                    pendingBinaryOperation = PendingBinaryOperation (function: function, firstOperand: accumulator!)
                    resultSum =  accumulator!
                    buttonPressed = false
                    print("you here")
                }
                if memoryArray.count == 1 {
                    memoryMagic(symbol: symbol)
                }
            case .equals:
               if !buttonPressed {
                    performPendingBinaryOperation()
                }
               else {
                    accumulator = memoryArray[memoryArrayLength-1].0
               }
               resultSum = nil
               memoryMagic(symbol: symbol)
            case .factorial(let function):
                if accumulator != nil && accumulator! < Double(Int.max) {
                    accumulator = Double(function(Int(accumulator!)))
                }
            case .ac:
                clear()
            }
        }
    }
    
    private mutating func  performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
            buttonPressed = false
        }
    }
     mutating func doUndoFunction() {
        print(memoryArray)
        if memoryArrayLength >= 1 {
            resultSum = nil
            if buttonPressed {
                buttonPressed = false
                memoryArrayLength -= 1
            }
            else {
                accumulator = memoryArray[memoryArrayLength].0
                if memoryArray[memoryArrayLength].1 == "="{
                    accumulator = memoryArray[memoryArrayLength - 1].0
                    memoryArrayLength -= 1
                }
                performOperation(memoryArray[memoryArrayLength].1)
                buttonPressed = true
                }
            }
        else {
            accumulator = 0
            buttonPressed = true
            }
        }

     mutating func doRedoFunction() {
        if memoryArrayLength < memoryArray.count - 1 {
            resultSum = nil
            if buttonPressed {
                accumulator = memoryArray[memoryArrayLength + 1].0
                buttonPressed = false
                print("Redo(Pressed)  \(memoryArrayLength)")
                
            }
            else {
                performOperation(memoryArray[memoryArrayLength].1)
                memoryArrayLength += 1
                buttonPressed = true
                print("Redo(NotPressed) \(memoryArrayLength)")
            }
        }
    }
    
    mutating func clear() {
        accumulator = 0
        resultSum = nil
        memoryArray = [(0,"")]
        buttonPressed = false
        memoryArrayLength = 0
    }

    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double
        func perform (with secondOperand: Double) -> Double {
            return function (firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand (_ operand: Double){
        accumulator = operand
    }
    
    mutating func memoryMagic (symbol: String) {
        memoryArray.append((accumulator!, symbol))
        memoryArrayLength = memoryArray.count - 1
    }

    mutating func checkPressedButton()  {
        buttonPressed = false
    }
    var result: Double? {
        get {
            return accumulator
        }
    }
}
