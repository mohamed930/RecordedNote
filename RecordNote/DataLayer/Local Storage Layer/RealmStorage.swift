//
//  RealmStorage.swift
//  RecordNote
//
//  Created by Mohamed Ali on 06/06/2026.
//

import Foundation
import RealmSwift

protocol RealmStorageProtocol {
    func object<T: Object>() -> T?
    func object<T: Object>(_ key: Any?) -> T?
    func object<T: Object>(_ predicate: (T) -> Bool) -> T?

    func objects<T: Object>() -> [T]
    func objects<T: Object>(_ predicate: (T) -> Bool) -> [T]

    @discardableResult func write<T: Object>(_ object: T?) -> Bool
    @discardableResult func write<T: Object>(_ objects: [T]?) -> Bool

    @discardableResult func update(_ block: () -> Void) -> Bool
    @discardableResult func delete<T: Object>(_ object: T) -> Bool

    @discardableResult func flush() -> Bool
}

final class RealmStorage: RealmStorageProtocol {

    private lazy var realm: Realm? = {
        do {
            let config = Realm.Configuration(
                schemaVersion: 1,
                migrationBlock: { _, oldSchemaVersion in
                    if oldSchemaVersion < 1 {
                        // Future migrations
                    }
                }
            )

            Realm.Configuration.defaultConfiguration = config

            if let url = config.fileURL {
                print("Realm Path: \(url.path)")
            }

            return try Realm(configuration: config)

        } catch {
            print("Default realm init failed:", error)

            if let url = Realm.Configuration.defaultConfiguration.fileURL {
                try? FileManager.default.removeItem(at: url)
            }

            return nil
        }
    }()

    func object<T: Object>() -> T? {
        object(0)
    }

    func object<T: Object>(_ key: Any?) -> T? {
        guard let key,
              let realm,
              let object = realm.object(ofType: T.self,
                                        forPrimaryKey: key)
        else {
            return nil
        }

        return object.isInvalidated ? nil : object
    }

    func object<T: Object>(_ predicate: (T) -> Bool) -> T? {
        guard let realm else { return nil }

        return realm
            .objects(T.self)
            .first(where: { !$0.isInvalidated && predicate($0) })
    }

    func objects<T: Object>() -> [T] {
        guard let realm else { return [] }

        return realm
            .objects(T.self)
            .filter { !$0.isInvalidated }
    }

    func objects<T: Object>(_ predicate: (T) -> Bool) -> [T] {
        guard let realm else { return [] }

        return realm
            .objects(T.self)
            .filter { !$0.isInvalidated && predicate($0) }
    }

    @discardableResult
    func write<T: Object>(_ object: T?) -> Bool {
        guard let object,
              let realm,
              !object.isInvalidated
        else {
            return false
        }

        do {
            try realm.write {
                realm.add(object, update: .modified)
            }
            return true
        } catch {
            print("Write failed for \(T.self): \(error)")
            return false
        }
    }

    @discardableResult
    func write<T: Object>(_ objects: [T]?) -> Bool {
        guard let objects,
              let realm
        else {
            return false
        }

        let validated = objects.filter { !$0.isInvalidated }

        do {
            try realm.write {
                realm.add(validated, update: .modified)
            }
            return true
        } catch {
            print("Write array failed for \(T.self): \(error)")
            return false
        }
    }

    @discardableResult
    func update(_ block: () -> Void) -> Bool {
        guard let realm else { return false }

        do {
            try realm.write {
                block()
            }
            return true
        } catch {
            print("Update failed:", error)
            return false
        }
    }

    @discardableResult
    func delete<T: Object>(_ object: T) -> Bool {
        guard let realm else { return false }

        if object.isInvalidated {
            return true
        }

        do {
            try realm.write {
                realm.delete(object)
            }
            return true
        } catch {
            print("Delete failed for \(T.self): \(error)")
            return false
        }
    }

    @discardableResult
    func flush() -> Bool {
        guard let realm else { return false }

        do {
            try realm.write {
                realm.deleteAll()
            }
            return true
        } catch {
            print("Database flush failed:", error)
            return false
        }
    }
}
