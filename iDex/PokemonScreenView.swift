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
import SDWebImageSwiftUI

struct PokemonScreen: View {
    @State private var selectedPokemon: Pokemon?
    @State private var pokemonList: [Pokemon] = []
    @State private var isSearchBarVisible = false
    @State private var searchText = ""
    private let batchSize = 50
    
    var body: some View {
        NavigationView {
            ZStack {
                FluidGradient(blobs: [.red, .green, .blue],
                              highlights: [.yellow, .orange, .purple],
                              speed: 0.4,
                              blur: 0.75)
                    .edgesIgnoringSafeArea(.all)
                    .preferredColorScheme(.dark)
                
                VStack(spacing: 20) {
                    if isSearchBarVisible || searchText.isEmpty {
                        ScrollView {
                            LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
                                ForEach(filteredPokemonList) { pokemon in
                                    NavigationLink(destination: PokemonMainScreen(pokemon: pokemon)) {
                                        PokemonItemView(pokemon: pokemon)
                                    }
                                }
                            }
                            .padding(.bottom, 20)
                        }
                    }
                }
                .padding(.top, 20)
            }
            .navigationBarItems(leading:
                Text("Pokémon")
                    .font(.largeTitle)
                    .padding(.top, 20),
                trailing:
                HStack {
                    if isSearchBarVisible {
                        SearchBar(text: $searchText, placeholder: "Search Pokémon")
                            .padding(.top, 30)
                    } else {
                        Button(action: {
                            isSearchBarVisible.toggle()
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.primary)
                                .font(.title)
                                .padding(.trailing, 8)
                                .padding(.top, 30)
                        }
                    }
                }
                .padding(.bottom)
            )
            .onAppear {
                fetchPokemonList()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    var filteredPokemonList: [Pokemon] {
        if searchText.isEmpty {
            return pokemonList
        } else {
            return pokemonList.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    func fetchPokemonList() {
        DispatchQueue.global().async {
            for id in 1...898 { // Fetch all Pokémon IDs
                PokemonAPI().pokemonService.fetchPokemon(id) { result in
                    switch result {
                    case .success(let pkmpokemon):
                        if let name = pkmpokemon.name,
                           let sprites = pkmpokemon.sprites,
                           let frontDefault = sprites.frontDefault,
                           let spriteURL = URL(string: frontDefault),
                           let height = pkmpokemon.height,
                           let weight = pkmpokemon.weight,
                           let abilities = pkmpokemon.abilities?.compactMap({ $0.ability?.name }),
                           let types = pkmpokemon.types?.compactMap({ $0.type?.name }),
                           let moves = pkmpokemon.moves?.compactMap({ $0.move?.name }) {
                            
                            let pokemon = Pokemon(id: id, name: name, height: height, weight: weight, abilities: abilities, spriteURL: spriteURL, types: types, moves: moves)
                            
                            DispatchQueue.main.async {
                                pokemonList.append(pokemon)
                                pokemonList.sort { $0.id < $1.id } // Sort the list
                            }
                        }
                    case .failure(let error):
                        print("Error fetching Pokémon with ID \(id): \(error)")
                    }
                }
            }
        }
    }

}


struct PokeScreen_Previews: PreviewProvider {
    static var previews: some View {
        PokemonScreen()
    }
}
