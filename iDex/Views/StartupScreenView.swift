//
//  StartupScreenView.swift
//  iDex
//
//  Created by Tyler on 26/02/2024.
//

import SwiftUI
import FluidGradient
import WhatsNewKit

struct StartupScreen: View {
    @State private var isNavigationActive = false
    @State
    var whatsNew: WhatsNew? = WhatsNew(
        title: "iDex",
        features: [
            .init(
                image: .init(
                    systemName: "star.fill",
                    foregroundColor: .orange
                ),
                title: "Added Stats to Pokemon Page",
                subtitle: "Hp, Special-Defense, Attack, Defense, Speed and Special-Attack"
            ),
            
            .init(
                image: .init(
                    systemName: "paintbrush.fill",
                    foregroundColor: .purple
                ),
                title: "Updated Gradient",
                subtitle: "Improving the asthetics for the app"
            ),
            
            .init(
                image: .init(
                    systemName: "ladybug.fill",
                    foregroundColor: .red
                ),
                title: "Performance Upgrades",
                subtitle: "Utilising caching to speed up the loading of the app"
            ),
            
        ]
    )
    
    var body: some View {
        NavigationView {
            ZStack {
                FluidGradient(blobs: [.red, .black],
                              highlights: [],
                              speed: 0.4,
                              blur: 0.75)
                    .edgesIgnoringSafeArea(.all)
                    .preferredColorScheme(.dark)
                
                VStack {
                    Spacer()
                    
                    Text("iDex")
                        .font(.system(size: 60, weight: .bold))
                        .padding()
                    
                    Text("Your ultimate Pokémon companion")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Spacer()
                    
                    NavigationLink(
                        destination: PokemonScreen(),
                        isActive: $isNavigationActive,
                        label: {
                            Text("Get Started")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        })
                        .padding()
                }
            }
            .navigationBarHidden(true)
        }.sheet(
            whatsNew: self.$whatsNew
            )
    }
}

struct StartupScreen_Previews: PreviewProvider {
    static var previews: some View {
        StartupScreen()
    }
}


