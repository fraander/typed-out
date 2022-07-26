//
//  SavedVM.swift
//  typed-out
//
//  Created by Frank Anderson on 7/26/22.
//

import Foundation
import Combine

class SavedVM: ObservableObject, Equatable, Codable {
    
    @Published var items: [SaveItem]
    private var saveSubscription: AnyCancellable?
    
    init(_ items: [SaveItem] = []) {
        self.items = []
    }
    
    
    
    // MARK: - Codable conformance
    private enum CodingKeys : String, CodingKey {
        case items
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(items, forKey: .items)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        items = try values.decode(Array<SaveItem>.self, forKey: .items)
    }
    
    // MARK: - Equatable conformance
    static func == (lhs: SavedVM, rhs: SavedVM) -> Bool {
        return lhs.items == rhs.items
    }
    
    // MARK: - Persisting Data
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("saved.data")
    }
    
    static func save(items: [SaveItem], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(items)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(items.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func load(completion: @escaping (Result<[SaveItem], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let items = try JSONDecoder().decode([SaveItem].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(items))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
