//
//  StartupScreenView.swift
//  iDex
//
//  Created by Tyler on 26/02/2024.
//

import SwiftUI
import FluidGradient

struct StartupScreen: View {
    @State private var isNavigationActive = false
    
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
        }
    }
}

struct StartupScreen_Previews: PreviewProvider {
    static var previews: some View {
        StartupScreen()
    }
}


