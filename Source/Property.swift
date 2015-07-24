//
//  Property.swift
//  CoreModel
//
//  Created by Alsey Coleman Miller on 6/24/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

public protocol Property {
    
    typealias PropertyType
    
    var name: String { get }
    
    var optional: Bool { get }
    
    var propertyType: PropertyType { get }
}

public struct Attribute {
    
    var name: String
    
    var optional: Bool
    
    var propertyType: AttributeType
    
    init(name: String, propertyType: AttributeType, optional: Bool = false) {
        
        self.name = name
        self.propertyType = propertyType
        self.optional = optional
    }
}

public struct Relationship {
    
    var name: String
    
    var optional: Bool = false
    
    var propertyType: RelationshipType
    
    var destinationEntityName: String
    
    var inverseRelationshipName: String
    
    init(name: String,
        propertyType: RelationshipType,
        optional: Bool = false,
        destinationEntityName: String,
        inverseRelationshipName: String) {
        
        self.name = name
        self.propertyType = propertyType
        self.optional = optional
        self.destinationEntityName = destinationEntityName
        self.inverseRelationshipName = inverseRelationshipName
    }
}