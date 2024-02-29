//
//  PokemonItemView.swift
//  iDex
//
//  Created by Tyler on 26/02/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct PokemonItemView: View {
    let pokemon: Pokemon
    
    var body: some View {
        VStack {
            // Display Pokémon sprite
            if let spriteURL = pokemon.spriteURL {
                WebImage(url: spriteURL)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding(.bottom, 5)
            } else {
                Text("Sprite not available")
                    .foregroundColor(.white)
            }
            
            // Display Pokémon name
            Text(pokemon.name.capitalized)
                .foregroundColor(.white)
                .padding(.top, 5)
        }
        .padding(10) // Add padding around the whole VStack
        .foregroundColor(.white)
        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.971, opacity: 0.25).blur(radius: 10))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
