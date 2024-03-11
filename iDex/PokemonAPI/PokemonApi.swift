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

struct Pokemon: Identifiable, Decodable, Equatable, Hashable {
    let id: Int
    let name: String
    let frontShinySpriteURL: URL?
    let spriteURL: URL?
    let height: Int
    let weight: Int
    let types: [String]
    let abilities: [String]
    let moves: [String]
    
    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
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
                            .padding(.leading, 15) 
                            .padding(.trailing, 4)

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
    let type: String

    var body: some View {
        Image(type.lowercased())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
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
    let power: Int?
    let accuracy: Int?
    let pp: Int
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

extension PokemonAPI: ObservableObject { }

extension Image {
    static let left = Image(systemName: "chevron.left")
    static let right = Image(systemName: "chevron.right")
    static let first = Image(systemName: "chevron.left.2")
    static let last = Image(systemName: "chevron.right.2")
}

