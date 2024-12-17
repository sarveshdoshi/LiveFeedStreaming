//
//  JSONHelper.swift
//  LiveFeedStreaming
//
//  Created by Sarvesh Doshi on 18/12/24.
//

import Foundation

class JSONHelper {
    
    /// Loads a JSON file from the app bundle and decodes it into a specified model type.
    /// - Parameters:
    ///   - filename: The name of the JSON file (without the `.json` extension).
    ///   - model: The type of model to decode the JSON into (must conform to `Decodable`).
    /// - Returns: The decoded object of the specified model type, or `nil` if an error occurs.
    class func loadJSON<T: Decodable>(filename: String, model: T.Type) -> T? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("Failed to locate \(filename).json in bundle.")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            print("Failed to decode \(filename).json: \(error.localizedDescription)")
            return nil
        }
    }
}
