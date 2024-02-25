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




struct PokemonMainScreen: View {
    let pokemon: Pokemon
    @State private var selectedTab = 0

    var body: some View {
        VStack {
            if let spriteURL = pokemon.spriteURL {
                WebImage(url: spriteURL)
                    .resizable()
                    .frame(width: 100, height: 100)
            } else {
                Text("Sprite not available")
            }
            Text("Name: \(capitalizeFirstLetter(pokemon.name))")
            Text("Pokedex Number: \(pokemon.id)")
            Text("Height: \(pokemon.height)")
            Text("Weight: \(pokemon.weight)")

            HStack {
                Spacer()
                Button(action: {
                    selectedTab = 0
                }) {
                    Text("Abilities")
                        .padding()
                        .background(selectedTab == 0 ? Color.blue : Color.clear)
                        .foregroundColor(selectedTab == 0 ? .white : .blue)
                        .cornerRadius(10)
                }
                Spacer()
                Button(action: {
                    selectedTab = 1
                }) {
                    Text("Moves")
                        .padding()
                        .background(selectedTab == 1 ? Color.blue : Color.clear)
                        .foregroundColor(selectedTab == 1 ? .white : .blue)
                        .cornerRadius(10)
                }
                Spacer()
            }
            .padding()

            if selectedTab == 0 {
                VStack {
                    Text("Abilities:")
                    ForEach(pokemon.abilities, id: \.self) { ability in
                        Text(capitalizeFirstLetter(ability))
                    }
                }
            } else {
                ScrollView{
                    VStack {
                        Text("Moves:")
                        ForEach(pokemon.moves, id: \.self) { move in
                            Text(capitalizeFirstLetter(move))
                        }
                    }
                }
            }
            Spacer()
        }
    }
}

struct PokemonItemView: View {
    let pokemon: Pokemon
    
    var body: some View {
        VStack {
            if let spriteURL = pokemon.spriteURL {
                WebImage(url: spriteURL)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding(.bottom, 5)
            } else {
                Text("Sprite not available")
            }
            Text(pokemon.name.capitalized) // Display Pokémon's name
                .foregroundColor(.white)
                .padding(.top, 5)
        }
        .padding(10) // Add padding around the whole VStack
        .foregroundColor(Color(.white))
        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.971, opacity: 0.25).blur(radius: 10))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
