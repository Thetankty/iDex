//
//  ListView.swift
//  iDex
//
//  Created by Tyler on 25/02/2024.
//

import Foundation
import PokemonAPI
import SwiftUI
import FluidGradient


struct PokemonScreen: View {
    @State private var selectedPokemon: Pokemon?
    @State private var pokemonList: [Pokemon] = []
    @State private var isSearchBarVisible = false
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            ZStack{
                FluidGradient(blobs: [.red, .green, .blue],
                              highlights: [.yellow, .orange, .purple],
                              speed: 1.0,
                              blur: 0.75)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    
                    if isSearchBarVisible || searchText.isEmpty {
                        ScrollView {
                            LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
                                ForEach(filteredPokemonList) { pokemon in
                                    NavigationLink(destination: PokemonMainScreen(pokemon: pokemon)) {
                                        PokemonItemView(pokemon: pokemon)
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle(Text("Pokémon").font(.headline))
                .navigationBarItems(trailing:
                                        Group {
                    if isSearchBarVisible {
                        SearchBar(text: $searchText, placeholder: "Search Pokémon")
                            .padding()
                    } else {
                        Button(action: {
                            isSearchBarVisible.toggle()
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.primary)
                                .font(.title)
                        }
                        .padding()
                    }
                }
                )
            }
            .onAppear {
                fetchPokemonList()
            }
        }
    }

    var filteredPokemonList: [Pokemon] {
        if searchText.isEmpty {
            return pokemonList
        } else {
            return pokemonList.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }


    func fetchPokemonList() {
        let numberOfPokemon = 898 // Total number of Pokémon
        let pokemonIDs = Array(1...numberOfPokemon)
        pokemonIDs.forEach { id in
            PokemonAPI().pokemonService.fetchPokemon(id) { result in
                switch result {
                case .success(let pkmpokemon):
                    if var name = pkmpokemon.name {
                        // Capitalize the first letter only
                        name = name.prefix(1).capitalized + name.dropFirst()
                        
                        // Fetch sprite URL
                        if let sprites = pkmpokemon.sprites {
                            if let frontDefault = sprites.frontDefault {
                                let spriteURL = URL(string: frontDefault)
                                let height = pkmpokemon.height ?? 0 // Set default height if nil
                                let weight = pkmpokemon.weight ?? 0 // Set default weight if nil
                                let abilities = pkmpokemon.abilities?.compactMap { $0.ability?.name } ?? [] // Fetch abilities
                                let types = pkmpokemon.types?.compactMap { $0.type?.name } ?? [] // Fetch types
                                
                                let moves = pkmpokemon.moves?.compactMap { $0.move?.name } ?? []
                                
                                let pokemon = Pokemon(id: id, name: name, height: height, weight: weight, abilities: abilities, spriteURL: spriteURL, types: types, moves: moves)
                                pokemonList.append(pokemon)
                                pokemonList.sort { $0.id < $1.id } // Sort the pokemonList by ID
                            }
                        }
                    }
                case .failure(let error):
                    print("Error fetching Pokémon with ID \(id): \(error)")
                }
            }
        }
    }
}

struct PokemonItemView: View {
    let pokemon: Pokemon

    var body: some View {
        VStack {
            if let spriteURL = pokemon.spriteURL {
                AsyncImage(url: spriteURL)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            } else {
                Text("Sprite not available")
            }
            Text(pokemon.name) // Display Pokémon's name
                .padding(.top, 5) // Add padding at the top of the text
        }
        .padding(10) // Add padding around the whole VStack
        .background(Color.gray.opacity(0.3))
        .cornerRadius(10)
        .frame(width: 120, height: 150) // Set fixed size for the frame
    }
}

struct PokemonMainScreen: View {
    let pokemon: Pokemon
    @State private var selectedTab = 0

    var body: some View {
        VStack {
            if let spriteURL = pokemon.spriteURL {
                AsyncImage(url: spriteURL)
                    .frame(width: 100, height: 100)
            } else {
                Text("Sprite not available")
            }
            Text("Name: \(capitalizeFirstLetter(pokemon.name))")
            Text("Pokedex Number: \(pokemon.id)")
            Text("Height: \(pokemon.height)")
            Text("Weight: \(pokemon.weight)")

            // Add navigation bar with tabs for abilities and moves
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

            // Display content based on the selected tab
            if selectedTab == 0 {
                // Display abilities
                VStack {
                    Text("Abilities:")
                    ForEach(pokemon.abilities, id: \.self) { ability in
                        Text(capitalizeFirstLetter(ability))
                    }
                }
            } else {
                // Display moves
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




struct PokeScreen_Previews: PreviewProvider {
    static var previews: some View {
        PokemonScreen()
    }
}

