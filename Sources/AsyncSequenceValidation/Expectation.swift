//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Async Algorithms open source project
//
// Copyright (c) 2022 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

extension AsyncSequenceValidationDiagram {
  public struct ExpectationResult: Sendable {
    public var expected: [(Clock.Instant, Result<String?, Error>)]
    public var actual: [(Clock.Instant, Result<String?, Error>)]
  }
  
  public struct ExpectationFailure: Sendable, CustomStringConvertible {
    public enum Kind: Sendable {
      case expectedFinishButGotValue(String)
      case expectedMismatch(String, String)
      case expectedValueButGotFinished(String)
      case expectedFailureButGotValue(Error, String)
      case expectedFailureButGotFinish(Error)
      case expectedValueButGotFailure(String, Error)
      case expectedFinishButGotFailure(Error)
      case expectedValue(String)
      case expectedFinish
      case expectedFailure(Error)
      case unexpectedValue(String)
      case unexpectedFinish
      case unexpectedFailure(Error)
      
      case specificationViolationGotValueAfterIteration(String)
      case specificationViolationGotFailureAfterIteration(Error)
    }
    public var when: Clock.Instant
    public var kind: Kind
    
    var reason: String {
      switch kind {
      case .expectedFinishButGotValue(let actual):
        return "expected finish but got \"\(actual)\""
      case .expectedMismatch(let expected, let actual):
        return "expected \"\(expected)\" but got \"\(actual)\""
      case .expectedValueButGotFinished(let expected):
        return "expected \"\(expected)\" but got finish"
      case .expectedFailureButGotValue(_, let actual):
        return "expected failure but got \"\(actual)\""
      case .expectedFailureButGotFinish:
        return "expected failure but got finish"
      case .expectedValueButGotFailure(let expected, _):
        return "expected \"\(expected)\" but got failure"
      case .expectedFinishButGotFailure:
        return "expected finish but got failure"
      case .expectedValue(let expected):
        return "expected \"\(expected)\""
      case .expectedFinish:
        return "expected finish"
      case .expectedFailure:
        return "expected failure"
      case .unexpectedValue(let actual):
        return "unexpected \"\(actual)\""
      case .unexpectedFinish:
        return "unexpected finish"
      case .unexpectedFailure:
        return "unexpected failure"
      case .specificationViolationGotValueAfterIteration(let actual):
        return "specification violation got \"\(actual)\" after iteration terminated"
      case .specificationViolationGotFailureAfterIteration:
        return "specification violation got failure after iteration terminated"
      }
    }
    
    public var description: String {
      return reason + " at tick \(when.when.rawValue - 1)"
    }
  }
}
