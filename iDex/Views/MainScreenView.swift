//
//  MainScreenView.swift
//  iDex
//
//  Created by Tyler on 26/02/2024.
//

import PokemonAPI
import SwiftUI
import SDWebImageSwiftUI
import FluidGradient

struct PokemonMainScreen: View {
    let pokemon: Pokemon
    @State private var selectedTab = 0
    @State private var moveDetails: [String: PokemonMove?] = [:]
    @State private var isShinySpriteOn = false
    
    let typeColors: [String: Color] = [
        "normal": Color(hex: "A8A77A"),
        "fire": Color(hex: "EE8130"),
        "water": Color(hex: "6390F0"),
        "electric": Color(hex: "F7D02C"),
        "grass": Color(hex: "7AC74C"),
        "ice": Color(hex: "96D9D6"),
        "fighting": Color(hex: "C22E28"),
        "poison": Color(hex: "A33EA1"),
        "ground": Color(hex: "E2BF65"),
        "flying": Color(hex: "A98FF3"),
        "psychic": Color(hex: "F95587"),
        "bug": Color(hex: "A6B91A"),
        "rock": Color(hex: "B6A136"),
        "ghost": Color(hex: "735797"),
        "dragon": Color(hex: "6F35FC"),
        "dark": Color(hex: "705746"),
        "steel": Color(hex: "B7B7CE"),
        "fairy": Color(hex: "D685AD")
    ]
    
    var body: some View {
        
        NavigationView() {
            ZStack{
                FluidGradient(blobs: gradientColors(), highlights: gradientColors(), speed: 0.9, blur: 0.75)
                    .edgesIgnoringSafeArea(.all).mask( Image("CircleOverlay"))
                VStack {
                    // Sprite
                    if isShinySpriteOn {
                        if let shinySpriteURL = pokemon.frontShinySpriteURL {
                            WebImage(url: shinySpriteURL)
                                .resizable()
                                .frame(width: 250, height: 250)
                        } else {
                            Text("Shiny sprite not available")
                        }
                    } else {
                        if let spriteURL = pokemon.spriteURL {
                            WebImage(url: spriteURL)
                                .resizable()
                                .frame(width: 250, height: 250)
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
                        //StatsTabView(pokemon: pokemon)
                            .tag(1)
                        MovesTabView(pokemon: pokemon, moveDetails: $moveDetails)
                            .tag(2)
                        //OtherTabView(pokemon: pokemon)
                            .tag(3)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .padding(.top, 20)
                .padding()
            }
        }
    }
    private func gradientColors() -> [Color] {
        var colors: [Color] = []
        for type in pokemon.types {
            if let color = typeColors[type.lowercased()] {
                colors.append(color)
            }
        }
        return colors
    }
}

