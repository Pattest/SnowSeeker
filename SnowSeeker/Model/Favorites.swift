//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Baptiste Cadoux on 21/07/2022.
//

import Foundation

class Favorites: ObservableObject {

    // the actual resorts the user has favorited
    private var resorts: Set<String>

    // the key we're using to read/write in UserDefaults
    private let saveKey = "Favorites"

    init() {
        if let decoded  = UserDefaults.standard.object(forKey: saveKey) as? Data,
            let decodedResorts = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded)
            as? Set<String> {
            resorts = decodedResorts
        } else {
            resorts = []
        }
    }

    // returns true if our set contains this resort
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }

    // adds the resort to our set, updates all views, and saves the change
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }

    // removes the resort from our set, updates all views, and saves the change
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }

    func save() {
        let encodedData = try? NSKeyedArchiver.archivedData(
            withRootObject: resorts,
            requiringSecureCoding: false)

        UserDefaults.standard.set(encodedData, forKey: saveKey)
    }
}
