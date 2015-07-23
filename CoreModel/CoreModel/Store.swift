//
//  Store.swift
//  CoreModel
//
//  Created by Alsey Coleman Miller on 7/22/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/// Defines the interface for CoreModel's Store type.
public protocol Store {
    
    /// The model the persistent store will handle.
    var model: [Entity] { get }
    
    /// Queries the store for entities matching the fetch request.
    func fetch<T: Entity>(fetchRequest: FetchRequest<T>) throws -> [Resource<T>]
    
    /// Fetches the specified specified by resource ID.
    func fetch<T: Entity>(entity: T.Type, withResourceID resourceID: String) throws -> Resource<T>
    
    /// Fetches the entities specified in the resource IDs.
    func fetch<T: Entity>(entity: T.Type, withResourceIDs resourceIDs: [String]) throws -> Resource<T>
    
    /// Creates the specified entity
    func create<T: Entity>(entity: T.Type, initialValues: ValuesObject?) throws -> Resource<T>
    
    /// Deletes the specified entity.
    func delete<T: Entity>(resource: Resource<T>) throws
    
    /// Edits the specified entity.
    func edit<T: Entity>(resource: Resource<T>, changes: ValuesObject) throws
    
    /// Returns the entity's values as a JSON object.
    func values<T: Entity>(forEntity entity: T) throws -> ValuesObject
}

/// Standard errors for Store.
public enum StoreError: ErrorType {
    
    /// The entity provided doesn't belong to the store's schema.
    case InvalidEntity
    
    /// Invalid values were given to the Store.
    case InvalidValues
    
    /// The specified entity could not be found.
    case NotFound
}