//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Marquis on 15/9/9.
//  Copyright (c) 2015年 Marquis. All rights reserved.
//

import Foundation
class CalculatorBrain{
    
    private var opStack = [Op]()
    private var knowOps = Dictionary<String, Op>()
    
    private enum Op:Printable{
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        var description:String{
            get {
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .UnaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    func pushOperand(operand: Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?{
        if let operation = knowOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    
    init() {
        knowOps["+"] = Op.BinaryOperation("+"){$0 + $1}
        knowOps["−"] = Op.BinaryOperation("−"){$1 - $0}
        knowOps["x"] = Op.BinaryOperation("x"){$0 * $1}
        knowOps["÷"] = Op.BinaryOperation("÷"){$1 / $0}
        knowOps["√"] = Op.UnaryOperation("√"){sqrt($0)}
    }
    
    func evaluate() -> Double?{
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    private func evaluate(ops: [Op])->(result: Double?, remainingOps: [Op]){
        var remainingOps = ops
        if !ops.isEmpty {
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                    let otherOperandEvaluation = evaluate(operandEvaluation.remainingOps)
                    if let otherOperand = otherOperandEvaluation.result{
                        return (operation(operand, otherOperand), otherOperandEvaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
}