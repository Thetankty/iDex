//
//  TabView.swift
//  iDex
//
//  Created by Tyler on 29/02/2024.
//

import Foundation
import SwiftUI

let tabTitles = ["About", "Stats", "Moves", "Other"]

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


