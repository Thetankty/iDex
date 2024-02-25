//
//  PokemonApi.swift
//  iDex
//
//  Created by Tyler on 25/02/2024.
//

import Foundation
import PokemonAPI
import SwiftUI

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
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(8)
                .padding(.horizontal)
            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }
        }
    }
}



