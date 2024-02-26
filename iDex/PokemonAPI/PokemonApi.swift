//
//  PokemonApi.swift
//  iDex
//
//  Created by Tyler on 25/02/2024.
//

import Foundation
import PokemonAPI
import SwiftUI
import SDWebImageSwiftUI

struct Pokemon: Identifiable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let abilities: [String]
    let spriteURL: URL?
    let types: [String]
    let moves: [String]
}

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String

    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 15) // Add padding to the leading edge of the magnifying glass icon
                            .padding(.trailing, 4) // Add padding to the trailing edge of the magnifying glass icon

                        Spacer()
                        
                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
        }
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
}

func capitalizeFirstLetter(_ text: String) -> String {
    guard let firstLetter = text.first else { return "" }
    return String(firstLetter).uppercased() + text.dropFirst()
}

struct PokemonTypeImageView: View {
    let type: String // Assuming type is a string representing the Pokémon type

    var body: some View {
        Image(type.lowercased()) // Assuming image names match type names
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30) // Adjust size as needed
            .padding(5)
            .background(Color.white)
            .cornerRadius(5)
    }
}

extension String {
    func capitalizedFirstLetter() -> String {
        guard let first = self.first else { return self }
        return String(first).uppercased() + self.dropFirst()
    }
}

struct PokemonMove: Codable {
    let name: String
    let power: Int
    let accuracy: Int
    let pp: Int
}

struct MoveCategory: Codable {
    let id: Int
    let name: String
    let moves: [NamedAPIResource]
}

struct NamedAPIResource: Codable {
    let name: String
    let url: String
}




