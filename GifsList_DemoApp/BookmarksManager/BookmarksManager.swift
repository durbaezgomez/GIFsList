//
//  BookmarksManager.swift
//  GifsList_DemoApp
//
//  Created by Dominik Urbaez Gomez on 27/02/2021.
//

import Foundation

class BookmarksManager {
    var bookmarks: Set<String>
    private let saveKey = "Bookmarks"

    let defaults =  UserDefaults.standard
    
    init() {
        self.bookmarks = []
        retrieve()
    }
    
    func contains(_ id: String) -> Bool {
        retrieve()
        return bookmarks.contains(id)
    }
    
    func add(_ id: String) {
        bookmarks.insert(id)
        save()
    }
    
    func remove(_ id: String) {
        bookmarks.remove(id)
        save()
    }
    
    func save() {
        let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: bookmarks, requiringSecureCoding: false)
        defaults.set(encodedData, forKey: saveKey)
    }
    
    func retrieve() {
        guard let decoded  = defaults.object(forKey: saveKey) as? Data else { return }
        bookmarks = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as! Set<String>
    }
}
