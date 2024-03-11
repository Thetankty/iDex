//
//  Fetchdata.swift
//  iDex
//
//  Created by Tyler on 29/02/2024.
//

import Foundation
import SwiftUI
import PokemonAPI

func fetchMoveDetails(moveName: String, completion: @escaping (Result<PokemonMove, Error>) -> Void) {
    let urlString = "https://pokeapi.co/api/v2/move/\(moveName.lowercased())/"
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(NSError(domain: "Data is nil", code: 0, userInfo: nil)))
            }
            return
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let move = try decoder.decode(PokemonMove.self, from: data)
            completion(.success(move))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}


