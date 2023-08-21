//
//  Expression.swift
//  Predicate
//
//  Created by Alsey Coleman Miller on 4/2/17.
//  Copyright © 2017 PureSwift. All rights reserved.
//

/// Used to represent expressions in a predicate.
public enum Expression: Equatable, Hashable, Sendable {
    
    /// Expression that represents a given constant value.
    case value(AttributeValue)
    
    /// Expression that invokes `value​For​Key​Path:​` with a given key path.
    case keyPath(PredicateKeyPath)
}

/// Type of predicate expression.
public enum ExpressionType: String, Codable, Sendable {
    
    case value
    case keyPath
}

public extension Expression {
    
    var type: ExpressionType {
        switch self {
        case .value: return .value
        case .keyPath: return .keyPath
        }
    }
}

// MARK: - CustomStringConvertible

extension Expression: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        case let .value(value):    return value.predicateDescription
        case let .keyPath(value):  return value.description
        }
    }
}

internal extension AttributeValue {
    
    var predicateDescription: String {
        
        switch self {
        case .null:                 return "nil"
        case let .string(value):    return "\"\(value)\""
        case let .data(value):      return value.description
        case let .date(value):      return value.description
        case let .uuid(value):      return value.uuidString
        case let .bool(value):      return value.description
        case let .int16(value):     return value.description
        case let .int32(value):     return value.description
        case let .int64(value):     return value.description
        case let .float(value):     return value.description
        case let .double(value):    return value.description
        case let .url(value):       return value.description
        case let .decimal(value):   return value.description
        }
    }
}

// MARK: - Codable

extension Expression: Codable {
    
    internal enum CodingKeys: String, CodingKey {
        
        case type
        case expression
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ExpressionType.self, forKey: .type)
        
        switch type {
        case .value:
            let expression = try container.decode(AttributeValue.self, forKey: .expression)
            self = .value(expression)
        case .keyPath:
            let keyPath = try container.decode(String.self, forKey: .expression)
            self = .keyPath(PredicateKeyPath(rawValue: keyPath))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        
        switch self {
        case let .value(value):
            try container.encode(value, forKey: .expression)
        case let .keyPath(keyPath):
            try container.encode(keyPath.rawValue, forKey: .expression)
        }
    }
}

// MARK: - Extensions

public extension Expression {
    
    func compare(_ type: FetchRequest.Predicate.Comparison.Operator, _ rhs: Expression) -> FetchRequest.Predicate {
        
        let comparison = FetchRequest.Predicate.Comparison(left: self, right: rhs, type: type)
        return .comparison(comparison)
    }
    
    func compare(_ type: FetchRequest.Predicate.Comparison.Operator, _ options: Set<FetchRequest.Predicate.Comparison.Option>, _ rhs: Expression) -> FetchRequest.Predicate {
        
        let comparison = FetchRequest.Predicate.Comparison(left: self, right: rhs, type: type, options: options)
        return .comparison(comparison)
    }
    
    func compare(_ modifier: FetchRequest.Predicate.Comparison.Modifier, _ type: FetchRequest.Predicate.Comparison.Operator, _ options: Set<FetchRequest.Predicate.Comparison.Option>, _ rhs: Expression) -> FetchRequest.Predicate {
        
        let comparison = FetchRequest.Predicate.Comparison(left: self, right: rhs, type: type, modifier: modifier, options: options)
        return .comparison(comparison)
    }
}
