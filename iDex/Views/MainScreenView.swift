//
//  MainScreenView.swift
//  iDex
//
//  Created by Tyler on 26/02/2024.
//

import PokemonAPI
import SwiftUI
import SDWebImageSwiftUI

struct PokemonMainScreen: View {
    let pokemon: Pokemon
    @State private var selectedTab = 0
    @State private var move: PokemonMove?
    @State private var moveDetails: [String: PokemonMove] = [:]
    
    var body: some View {
        VStack {
            // Sprite
            if let spriteURL = pokemon.spriteURL {
                WebImage(url: spriteURL)
                    .resizable()
                    .frame(width: 100, height: 100)
            } else {
                Text("Sprite not available")
            }
            
            // Pokedex number and Pokemon name
            HStack {
                Text("Pokedex number: #\(String(format: "%03d", pokemon.id))")
                Text(pokemon.name.capitalizedFirstLetter())
            }
            .padding(.top, 10)
            
            // Tabs
            HStack {
                Spacer()
                Button(action: {
                    selectedTab = 0
                }) {
                    Text("About")
                        .padding()
                        .background(selectedTab == 0 ? Color.blue : Color.clear)
                        .foregroundColor(selectedTab == 0 ? .white : .blue)
                        .cornerRadius(10)
                }
                Spacer()
                Button(action: {
                    selectedTab = 1
                }) {
                    Text("Stats")
                        .padding()
                        .background(selectedTab == 1 ? Color.blue : Color.clear)
                        .foregroundColor(selectedTab == 1 ? .white : .blue)
                        .cornerRadius(10)
                }
                Spacer()
                Button(action: {
                    selectedTab = 2
                }) {
                    Text("Moves")
                        .padding()
                        .background(selectedTab == 2 ? Color.blue : Color.clear)
                        .foregroundColor(selectedTab == 2 ? .white : .blue)
                        .cornerRadius(10)
                }
                Spacer()
                Button(action: {
                    selectedTab = 3
                }) {
                    Text("Other")
                        .padding()
                        .background(selectedTab == 3 ? Color.blue : Color.clear)
                        .foregroundColor(selectedTab == 3 ? .white : .blue)
                        .cornerRadius(10)
                }
                Spacer()
            }
            .padding(.top, 20)
            
            // Content based on selected tab
            if selectedTab == 0 {
                AboutTabView(pokemon: pokemon)
            } else if selectedTab == 1 {
                Text("Stats tab content goes here")
            }  else if selectedTab == 2 {
                    MovesTabView(pokemon: pokemon, moveDetails: moveDetails)
            }else {
                Text("Other tab content goes here")
            }
            
            Spacer()
        }
        .padding()
        .onAppear{
            preloadMoveDetails()
            }
    }
    
    private func preloadMoveDetails() {
            for moveName in pokemon.moves {
                fetchMoveDetails(moveName: moveName) { result in
                    switch result {
                    case .success(let move):
                        moveDetails[moveName] = move
                    case .failure(let error):
                        print("Error fetching move data for \(moveName): \(error)")
                    }
                }
            }
        }
        
        private func tabTitle(for index: Int) -> String {
            switch index {
            case 0: return "About"
            case 1: return "Stats"
            case 2: return "Moves"
            default: return "Other"
            }
        }
    }

    struct AboutTabView: View {
        let pokemon: Pokemon
        
        var body: some View {
            VStack(alignment: .leading) {
                // Types
                HStack {
                    Text("Types:")
                        .fontWeight(.bold)
                    ForEach(pokemon.types, id: \.self) { type in
                        Text(type.capitalizedFirstLetter())
                    }
                }
                .padding(.bottom, 5)
                
                // Height
                Text("Height: \(String(format: "%.2f", Double(pokemon.height) / 10)) meters")
                    .padding(.bottom, 5)
                
                // Weight
                Text("Weight: \(String(format: "%.1f", Double(pokemon.weight) / 10)) kg")
                    .padding(.bottom, 5)
                
                // Abilities
                Text("Abilities:")
                    .fontWeight(.bold)
                ForEach(pokemon.abilities, id: \.self) { ability in
                    Text(ability.capitalizedFirstLetter())
                }
            }
        }
    }

struct MovesTabView: View {
    let pokemon: Pokemon
    let moveDetails: [String: PokemonMove]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Moves:")
                .fontWeight(.bold)
                .padding(.bottom, 5)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Name")
                        .fontWeight(.bold)
                    Spacer()
                    Text("Pow")
                        .fontWeight(.bold)
                    Text("Acc")
                        .fontWeight(.bold)
                    Text("PP")
                        .fontWeight(.bold)
                }
                ScrollView {
                    ForEach(pokemon.moves, id: \.self) { moveName in
                        if let move = moveDetails[moveName] {
                            MoveRow(move: move)
                        }
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
    }
}


struct MoveRow: View {
    let move: PokemonMove
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(move.name.capitalized)
                Spacer()
                Text("\(move.power)")
                Text("\(move.accuracy)")
                Text("\(move.pp)")
            }
            .padding(.vertical, 8) // Add vertical padding
            
            Divider() // Add a divider between move rows
        }
    }
}


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
            }
            return
        }
        
        do {
            let move = try JSONDecoder().decode(PokemonMove.self, from: data)
            completion(.success(move))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}
