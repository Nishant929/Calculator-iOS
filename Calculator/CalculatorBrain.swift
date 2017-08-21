//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Nishant Hooda
//  Copyright © 2017 digix. All rights reserved.
//

import Foundation

class CalculatorBrain   {
    
    private var accumulator = 0.0
    var signChange = 0.0
    
    func setOperand (operand: Double) {
        accumulator = operand
        signChange = operand
    }
    
    private var operations: Dictionary <String,Operation> = [
        "π": Operation.Constant(Double.pi),
        "e": Operation.Constant(M_E),
        "cos" : Operation.UnaryOperation(cos),
        "sin" : Operation.UnaryOperation(sin),
        "tan" : Operation.UnaryOperation(tan),
        "√" : Operation.UnaryOperation(sqrt),
        "±" : Operation.UnaryOperation({-$0}),
        "×" : Operation.BinaryOperation( {return $0 * $1} ), // $0,$1,... default arguments
        "+" : Operation.BinaryOperation( {return $0 + $1} ), // swift infers from `Line` that the arguments are double
        "-" : Operation.BinaryOperation( {return $0 - $1} ), // so we only need to write return statement
        "÷" : Operation.BinaryOperation( {return $0 / $1} ),
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double)->Double)
        case BinaryOperation((Double,Double)->Double) // Line
        case Equals
    }
    
    func performOperation (symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let valueOfConstant):
                accumulator = valueOfConstant
            case .UnaryOperation(let valueOfUnaryOperation):
                accumulator = valueOfUnaryOperation(accumulator)
            case .BinaryOperation(let valueOfBinaryOperation):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: valueOfBinaryOperation, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    func executePendingBinaryOperation ()   {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
        
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
        
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}
