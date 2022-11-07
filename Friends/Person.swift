import UIKit

// 친구 개개인의 정보를 표현할 모델 구조체
struct Person: Codable, Equatable {
    
    // MARK: - Nested Types
    struct Name: Codable, Equatable {
        let title: String
        let first: String
        let last: String
        
        var full: String {
            return (self.title + ". " + self.last + " " + self.first).uppercased()
        }
    }
    
    struct PictureURL: Codable, Equatable {
        let large: URL
        let medium: URL
        let thumbnail: URL
    }
    
    // MARK: - Properties
    let name: Name
    let cell: String
    let pictureURL: PictureURL
    
    // MARK: Privates
    private let nat: String
}

// MARK: - Coding Keys
extension Person {
    enum CodingKeys: String, CodingKey {
        case name, cell, nat
        case pictureURL = "picture"
    }
}

// MARK: - Computed Properties
extension Person {
    var nationality: String {
        return nat.uppercased()
    }
}

// MARK: - Best Friends JSON File URL
extension Person {
    private static let bestFriendFileName: String = "best_friends.json"
    private static var bestFriendFileURL: URL? {
        
        let fileManager: FileManager = FileManager.default
        
        let documentURL: URL
        
        do {
            documentURL =
                try fileManager.url(for: FileManager.SearchPathDirectory.applicationSupportDirectory,
                                    in: FileManager.SearchPathDomainMask.userDomainMask,
                                    appropriateFor: nil,
                                    create: true)
        } catch {
            print("can not find application support directory")
            print(error.localizedDescription)
            return nil
        }
        
        let fileURL: URL = documentURL.appendingPathComponent(bestFriendFileName)
        
        return fileURL
    }
}

// MARK: - Load Best Friends
extension Person {
    private static func loadBestFriendsFromFile() -> [Person] {
        
        guard let fileURL: URL = bestFriendFileURL else { return [] }
        
        do {
            let data: Data = try Data(contentsOf: fileURL)
            
            let decoder: JSONDecoder = JSONDecoder()
            let friends: [Person] = try decoder.decode([Person].self, from: data)
            
            return friends
        } catch {
            print("can not decode JSON")
            print(error.localizedDescription)
        }
        
        return []
    }
}

// MARK: - Best Friends Properties
extension Person {
    static var bestFriends: [Person] = Person.loadBestFriendsFromFile()
}

// MARK: - Save Best Friends
extension Person {
    
    static func saveCurrentBestFriendsToFile() -> Bool {
        
        guard let fileURL: URL = bestFriendFileURL else { return false }
        
        let encoder: JSONEncoder = JSONEncoder()
        
        do {
            let data: Data = try encoder.encode(self.bestFriends)
            try data.write(to: fileURL)
            return true
        } catch {
            print("can not save best friends")
            print(error.localizedDescription)
        }
        return false
    }
}

// MARK: - Add Best Friends
extension Person {
    
    static func addBestFriend(_ friend: Person,
                              completion: ((_ isSuccess: Bool) -> Void)? = nil) {
        self.bestFriends.append(friend)
        
        DispatchQueue.main.async {
            completion?(self.saveCurrentBestFriendsToFile())
        }
    }
}

// MARK: - Find Best Friend Index
extension Person {
    private static func bestFriendIndex(of target: Person) -> Int? {
        guard let index: Int = self.bestFriends.index(where: {
            (friend: Person) -> Bool in
            friend == target
        }) else { return nil }
        
        return index
    }
}

// MARK: - Remove Best Friends
extension Person {
    
    static func removeBestFriend(_ friend: Person,
                                 completion: ((_ isSuccess: Bool) -> Void)? = nil) {
        if let index: Int = self.bestFriendIndex(of: friend) {
            self.bestFriends.remove(at: index)
            
            DispatchQueue.main.async {
                completion?(self.saveCurrentBestFriendsToFile())
            }
        } else {
            DispatchQueue.main.async {
                completion?(false)
            }
        }
    }
}
