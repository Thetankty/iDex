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
    @State private var moveDetails: [String: PokemonMove?] = [:]
    @State private var isShinySpriteOn = false
    @State private var pokemonStats: [PokemonStat] = []

    var body: some View {
        VStack {
            // Sprite
            if isShinySpriteOn {
                if let shinySpriteURL = pokemon.frontShinySpriteURL {
                    WebImage(url: shinySpriteURL)
                        .resizable()
                        .frame(width: 100, height: 100)
                } else {
                    Text("Shiny sprite not available")
                }
            } else {
                if let spriteURL = pokemon.spriteURL {
                    WebImage(url: spriteURL)
                        .resizable()
                        .frame(width: 100, height: 100)
                } else {
                    Text("Sprite not available")
                }
            }
            
            // Pokedex number and Pokemon name
            HStack {
                Text("Pokedex number: #\(String(format: "%03d", pokemon.id))")
                Text(pokemon.name.capitalizedFirstLetter())
            }
            .padding(.top, 10)
            
            // Tabs
            HStack {
                ForEach(0..<4) { index in
                    Button(action: {
                        selectedTab = index
                    }) {
                        Text(tabTitles[index])
                            .padding()
                            .background(selectedTab == index ? Color.blue : Color.clear)
                            .foregroundColor(selectedTab == index ? .white : .blue)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
            }
            .padding(.top, 20)
            
            // Content based on selected tab
            TabView(selection: $selectedTab) {
                AboutTabView(pokemon: pokemon)
                    .tag(0)
                StatsTabView(stats: pokemonStats)
                    .tag(1)
                MovesTabView(pokemon: pokemon, moveDetails: $moveDetails)
                    .tag(2)
                Toggle("Shiny Sprite", isOn: $isShinySpriteOn)
                    .padding(.top, 10)
                    .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
        .onAppear {
            if pokemonStats.isEmpty {
                fetchPokemonStats()
            }
        }
    }
    
    private func fetchPokemonStats() {
        let statNames = ["hp", "attack", "defense", "special-attack", "special-defense", "speed"]
        
        DispatchQueue.global().async {
            let group = DispatchGroup()
            
            for statName in statNames {
                group.enter()
                fetchStatDetails(statName: statName) { result in
                    defer { group.leave() }
                    
                    switch result {
                    case .success(let stat):
                        DispatchQueue.main.async {
                            pokemonStats.append(stat)
                        }
                    case .failure(let error):
                        print("Error fetching stat \(statName): \(error)")
                    }
                }
            }
            
            group.wait()
        }
    }
}

struct AboutTabView: View {
    let pokemon: Pokemon
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Types:")
                .fontWeight(.bold)
            ForEach(pokemon.types, id: \.self) { type in
                Text(type.capitalizedFirstLetter())
            }
            .padding(.bottom, 5)
            
            Text("Height: \(String(format: "%.2f", Double(pokemon.height) / 10)) meters")
                .padding(.bottom, 5)
            
            Text("Weight: \(String(format: "%.1f", Double(pokemon.weight) / 10)) kg")
                .padding(.bottom, 5)
            
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
    @Binding var moveDetails: [String: PokemonMove?]
    
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
                        } else {
                            Text("Loading move...")
                                .onAppear {
                                    preloadMoveDetails(moveName: moveName)
                                }
                        }
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
    }
    
    private func preloadMoveDetails(moveName: String) {
        fetchMoveDetails(moveName: moveName) { result in
            switch result {
            case .success(let move):
                DispatchQueue.main.async {
                    moveDetails[moveName] = move
                }
            case .failure(let error):
                print("Error fetching move data for \(moveName): \(error)")
            }
        }
    }
}

struct MoveRow: View {
    let move: PokemonMove?
    
    var body: some View {
        if let move = move {
            VStack(spacing: 8) {
                HStack {
                    Text(move.name.capitalized)
                    Spacer()
                    Text("\(move.power.map { "\($0)" } ?? "N/A")")
                    Text("\(move.accuracy.map { "\($0)" } ?? "N/A")")
                    Text("\(move.pp)")
                }
                .padding(.vertical, 8)
                
                Divider()
            }
        } else {
            Text("Move details not available")
                .foregroundColor(.red)
                .padding(.vertical, 8)
        }
    }
}


private let tabTitles = ["About", "Stats", "Moves", "Other"]

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

func fetchStatDetails(statName: String, completion: @escaping (Result<PokemonStat, Error>) -> Void) {
    let urlString = "https://pokeapi.co/api/v2/stat/\(statName.lowercased())/"
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
            let stat = try decoder.decode(PokemonStat.self, from: data)
            completion(.success(stat))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}

struct StatsTabView: View {
    let stats: [PokemonStat]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(stats, id: \.id) { stat in
                    StatRow(stat: stat)
                }
            }
            .padding()
        }
    }
}

struct StatRow: View {
    let stat: PokemonStat

    var body: some View {
        HStack {
            Text(stat.name)
                .fontWeight(.bold)
            Spacer()
            Text("\(stat.gameIndex)")
        }
        .padding(.vertical, 8)
    }
}
