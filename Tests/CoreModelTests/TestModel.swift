//
//  Model.swift
//  
//
//  Created by Alsey Coleman Miller on 8/17/23.
//

import Foundation
import CoreModel

struct Person: Equatable, Hashable, Codable, Identifiable {
    
    let id: UUID
    
    var name: String
    
    var created: Date
    
    var age: UInt
    
    var events: [Event.ID]
    
    init(id: UUID = UUID(), name: String, created: Date = Date(), age: UInt, events: [Event.ID] = []) {
        self.id = id
        self.name = name
        self.created = created
        self.age = age
        self.events = events
    }
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case created
        case age
        case events
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Person.CodingKeys> = try decoder.container(keyedBy: Person.CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: Person.CodingKeys.id)
        self.name = try container.decode(String.self, forKey: Person.CodingKeys.name)
        self.created = try container.decode(Date.self, forKey: Person.CodingKeys.created)
        self.age = try container.decode(UInt.self, forKey: Person.CodingKeys.age)
        self.events = try container.decode([Event.ID].self, forKey: Person.CodingKeys.events)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Person.CodingKeys.self)
        
        try container.encode(self.id, forKey: Person.CodingKeys.id)
        try container.encode(self.name, forKey: Person.CodingKeys.name)
        try container.encode(self.created, forKey: Person.CodingKeys.created)
        try container.encode(self.age, forKey: Person.CodingKeys.age)
        try container.encode(self.events, forKey: Person.CodingKeys.events)
    }
}

extension Person: Entity {
    
    public static var entityName: EntityName { "Person" }
    
    static var attributes: [CodingKeys: AttributeType] {
        [
            .name: .string,
            .created: .date,
            .age: .int16
        ]
    }
    
    static var relationships: [CodingKeys: Relationship] {
        [
            .events: .init(
                id: PropertyKey(CodingKeys.events),
                type: .toMany,
                destinationEntity: Event.entityName,
                inverseRelationship: PropertyKey(Event.CodingKeys.people)
            )
        ]
    }
    
    init(from container: ModelData) throws {
        guard container.entity == Self.entityName else {
            throw DecodingError.typeMismatch(Self.self, DecodingError.Context(codingPath: [], debugDescription: "Cannot decode \(String(describing: Self.self)) from \(container.entity)"))
        }
        guard let id = UUID(uuidString: container.id.rawValue) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Cannot decode identifier from \(container.id)"))
        }
        self.id = id
        self.name = try container.decode(String.self, forKey: Person.CodingKeys.name)
        self.created = try container.decode(Date.self, forKey: Person.CodingKeys.created)
        self.age = try container.decode(UInt.self, forKey: Person.CodingKeys.age)
        self.events = try container.decodeRelationship([Event.ID].self, forKey: Person.CodingKeys.events)
    }
    
    func encode() -> ModelData {
        var container = ModelData(
            entity: Self.entityName,
            id: ObjectID(rawValue: self.id.description)
        )
        container.encode(self.name, forKey: Person.CodingKeys.name)
        container.encode(self.created, forKey: Person.CodingKeys.created)
        container.encode(self.age, forKey: Person.CodingKeys.age)
        container.encodeRelationship(self.events, forKey: Person.CodingKeys.events)
        return container
    }
}

struct Event: Equatable, Hashable, Codable, Identifiable {
    
    let id: UUID
    
    var name: String
    
    var date: Date
    
    var people: [Person.ID]
    
    //var speaker: Person.ID?
    
    //var notes: String?
    
    init(id: UUID = UUID(), name: String, date: Date, people: [Person.ID] = []) {
        self.id = id
        self.name = name
        self.date = date
        self.people = people
    }
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case date
        case people
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Event.CodingKeys> = try decoder.container(keyedBy: Event.CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: Event.CodingKeys.id)
        self.name = try container.decode(String.self, forKey: Event.CodingKeys.name)
        self.date = try container.decode(Date.self, forKey: Event.CodingKeys.date)
        self.people = try container.decode([Person.ID].self, forKey: Event.CodingKeys.people)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Event.CodingKeys.self)
        
        try container.encode(self.id, forKey: Event.CodingKeys.id)
        try container.encode(self.name, forKey: Event.CodingKeys.name)
        try container.encode(self.date, forKey: Event.CodingKeys.date)
        try container.encode(self.people, forKey: Event.CodingKeys.people)
    }
}

extension Event: Entity {
    
    public static var entityName: EntityName { "Event" }
    
    static var attributes: [CodingKeys: AttributeType] {
        [
            .name: .string,
            .date: .date
        ]
    }
    
    static var relationships: [CodingKeys: Relationship] {
        [
            .people: .init(
                id: PropertyKey(CodingKeys.people),
                type: .toMany,
                destinationEntity: Person.entityName,
                inverseRelationship: PropertyKey(Person.CodingKeys.events))
        ]
    }
}

/// Campground Location
public struct Campground: Equatable, Hashable, Codable, Identifiable {
    
    public let id: UUID
    
    public let created: Date
    
    public let updated: Date
    
    public var name: String
    
    public var address: String
    
    public var location: LocationCoordinates
    
    public var amenities: [Amenity]
    
    public var phoneNumber: String?
    
    public var descriptionText: String
    
    /// The number of seconds from GMT.
    public var timeZone: Int
    
    public var notes: String?
    
    public var directions: String?
    
    public var units: [RentalUnit.ID]
    
    public var officeHours: Schedule
    
    public init(
        id: UUID = UUID(),
        created: Date = Date(),
        updated: Date = Date(),
        name: String,
        address: String,
        location: LocationCoordinates,
        amenities: [Amenity] = [],
        phoneNumber: String? = nil,
        descriptionText: String,
        notes: String? = nil,
        directions: String? = nil,
        units: [RentalUnit.ID] = [],
        timeZone: Int = 0,
        officeHours: Schedule
    ) {
        self.id = id
        self.created = created
        self.updated = updated
        self.name = name
        self.address = address
        self.location = location
        self.amenities = amenities
        self.phoneNumber = phoneNumber
        self.descriptionText = descriptionText
        self.notes = notes
        self.directions = directions
        self.units = units
        self.timeZone = timeZone
        self.officeHours = officeHours
    }
    
    public enum CodingKeys: CodingKey {
        case id
        case created
        case updated
        case name
        case address
        case location
        case amenities
        case phoneNumber
        case descriptionText
        case timeZone
        case notes
        case directions
        case units
        case officeHours
    }
}

extension Campground: Entity {
    
    public static var entityName: EntityName { "Campground" }
    
    public static var attributes: [CodingKeys: AttributeType] {
        [
            .name : .string,
            .created : .date,
            .updated : .date,
            .address : .string,
            .location: .string,
            .amenities: .string,
            .phoneNumber: .string,
            .descriptionText: .string,
            .timeZone: .int32,
            .notes: .string,
            .directions: .string,
            .officeHours: .string
        ]
    }
    
    public static var relationships: [CodingKeys: Relationship] {
        [
            .units : Relationship(
                id: PropertyKey(CodingKeys.units),
                type: .toMany,
                destinationEntity: RentalUnit.entityName,
                inverseRelationship: PropertyKey(RentalUnit.CodingKeys.campground)
            )
        ]
    }
}

public extension Campground {
    
    /// Campground Amenities
    enum Amenity: String, Codable, CaseIterable {
        
        case water
        case amp30
        case amp50
        case wifi
        case laundry
        case mail
        case dumpStation
        case picnicArea
        case storage
        case cabins
        case showers
        case restrooms
        case pool
        case fishing
        case beach
        case lake
        case river
        case rv
        case tent
        case pets
    }
}

extension Array: AttributeEncodable where Self.Element == Campground.Amenity  {
    
    public var attributeValue: AttributeValue {
        let string = self.reduce("", { $0 + ($0.isEmpty ? "" : ",") + $1.rawValue })
        return .string(string)
    }
}

extension Array: AttributeDecodable where Self.Element == Campground.Amenity  {
    
    public init?(attributeValue: AttributeValue) {
        guard let string = String(attributeValue: attributeValue) else {
            return nil
        }
        let components = string
            .components(separatedBy: ",")
            .filter { $0.isEmpty == false }
        var values = [Campground.Amenity]()
        values.reserveCapacity(components.count)
        for element in components {
            guard let value = Self.Element(rawValue: element) else {
                return nil
            }
            values.append(value)
        }
        self = values
    }
}

public extension Campground {
    
    /// Location Coordinates
    struct LocationCoordinates: Equatable, Hashable, Codable {
        
        /// Latitude
        public var latitude: Double
        
        /// Longitude
        public var longitude: Double
        
        public init(latitude: Double, longitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
        }
    }
}

extension Campground.LocationCoordinates: AttributeEncodable {
    
    public var attributeValue: AttributeValue {
        return .string("\(latitude),\(longitude)")
    }
}

extension Campground.LocationCoordinates: AttributeDecodable {
    
    public init?(attributeValue: AttributeValue) {
        guard let string = String(attributeValue: attributeValue) else {
            return nil
        }
        let components = string.components(separatedBy: ",")
        guard components.count == 2,
            let latitude = Double(components[0]),
            let longitude = Double(components[1]) else {
            return nil
        }
        self.init(latitude: latitude, longitude: longitude)
    }
}

public extension Campground {
    
    /// Schedule (e.g. Check in, Check Out)
    struct Schedule: Equatable, Hashable, Codable {
        
        public var start: UInt
        
        public var end: UInt
        
        public init(start: UInt, end: UInt) {
            assert(start < end)
            self.start = start
            self.end = end
        }
    }
}

extension Campground.Schedule: AttributeEncodable {
    
    public var attributeValue: AttributeValue {
        return .string("\(start),\(end)")
    }
}

extension Campground.Schedule: AttributeDecodable {
    
    public init?(attributeValue: AttributeValue) {
        guard let string = String(attributeValue: attributeValue) else {
            return nil
        }
        let components = string.components(separatedBy: ",")
        guard components.count == 2,
            let start = UInt(components[0]),
            let end = UInt(components[1]) else {
            return nil
        }
        self.init(start: start, end: end)
    }
}

public extension Campground {
    
    /// Campground Rental Unit
    struct RentalUnit: Equatable, Hashable, Codable, Identifiable {
        
        public let id: UUID
        
        public let campground: Campground.ID
        
        public var name: String
        
        public var notes: String?
        
        public var amenities: [Amenity]
        
        public var checkout: Schedule
        
        public init(
            id: UUID = UUID(),
            campground: Campground.ID,
            name: String,
            notes: String? = nil,
            amenities: [Amenity] = [],
            checkout: Schedule
        ) {
            self.id = id
            self.campground = campground
            self.name = name
            self.notes = notes
            self.amenities = amenities
            self.checkout = checkout
        }
        
        public enum CodingKeys: CodingKey {
            
            case id
            case campground
            case name
            case notes
            case amenities
            case checkout
        }
    }
}

extension Campground.RentalUnit: Entity {
    
    public static var entityName: EntityName { "RentalUnit" }
    
    public static var attributes: [CodingKeys: AttributeType] {
        [
            .name : .string,
            .notes : .string,
            .amenities : .string,
            .checkout : .string
        ]
    }
    
    public static var relationships: [CodingKeys: Relationship] {
        [
            .campground : Relationship(
                id: PropertyKey(CodingKeys.campground),
                type: .toOne,
                destinationEntity: Campground.entityName,
                inverseRelationship: PropertyKey(Campground.CodingKeys.units)
            )
        ]
    }
}
