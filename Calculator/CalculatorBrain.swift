//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ahmed Al-Zahrani on 2018-05-01.
//  Copyright © 2018 Ahmed Al-Zahrani. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    
    // Description var and related funcs
    var description: String?
    
    mutating func editDescription(symbolToAdd: String) {
        if (description != nil) {
            description! += symbolToAdd
        } else {
            description = symbolToAdd
        }
        description! += " "
    }
    
    func getDescription() -> String{
        if let describe = description{
            return describe
        }
        return " "
    }
    
    
    var resultIsPending: Bool {
        get {
            if (pendingBinary != nil){
                return true
            } else {
                return false
            }
        }
    }
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String,Operation> = [
        "∏" : .constant(Double.pi),
        "e" : .constant(M_E),
        "√" : .unaryOperation(sqrt),
        "±" : .unaryOperation({ -$0 }),
        "x" : .binaryOperation({ $0 * $1}),
        "+" : .binaryOperation({ $0 + $1}),
        "-" : .binaryOperation({ $0 - $1}),
        "÷" : .binaryOperation({ $0 / $1}),
        "=" : .equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                editDescription(symbolToAdd: symbol)
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                    editDescription(symbolToAdd: symbol)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinary = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    editDescription(symbolToAdd: symbol)
                    accumulator = nil
                }
                break
            case .equals:
                performPendingBinary()
                break
            }
        }
    }
    
   mutating private func performPendingBinary() {
        if pendingBinary != nil && accumulator != nil {
            accumulator = pendingBinary!.perform(with: accumulator!)
            pendingBinary = nil
        }
    }
    
    private var pendingBinary: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        editDescription(symbolToAdd: operand.description)
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
}
