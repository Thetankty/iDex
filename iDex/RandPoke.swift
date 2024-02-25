import SwiftUI
import PokemonAPI

struct RandPoke: View {
    @State private var pokemon: Pokemon?
    
    var body: some View {
        VStack {
            if let pokemon = pokemon {
                Text("Name: \(capitalizeFirstLetter(pokemon.name))")
                Text("Pokedex Number: \(pokemon.id)")
                Text("Height: \(pokemon.height)")
                Text("Weight: \(pokemon.weight)")
                Text("Abilities:")
                ForEach(pokemon.abilities, id: \.self) { ability in
                    Text(capitalizeFirstLetter(ability))
                }
                if let spriteURL = pokemon.spriteURL {
                    AsyncImage(url: spriteURL)
                        .frame(width: 100, height: 100)
                } else {
                    Text("Sprite not available")
                }
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            //fetchRandomPokemon()
        }
    }
    
    //   func fetchRandomPokemon() {
    //        let randomID = Int.random(in: 1...898)
    //        PokemonAPI().pokemonService.fetchPokemon(randomID) { result in
    //            switch result {
    //            case .success(let pkmpokemon):
    //                let abilities = pkmpokemon.abilities?.compactMap { $0.ability?.name } ?? []
    //                let spriteURLString = pkmpokemon.sprites?.frontDefault
    //                let spriteURL = URL(string: spriteURLString ?? "")
    //                let pokemon = Pokemon(id: pkmpokemon.id ?? 0,
    //                                      name: pkmpokemon.name ?? "",
    //                                      height: pkmpokemon.height ?? 0,
    //                                      weight: pkmpokemon.weight ?? 0,
    //                                      abilities: abilities,
    //                                      spriteURL: spriteURL)
    //                self.pokemon = pokemon
    //            case .failure(let error):
    //                print("Error fetching Pokémon: \(error)")
    //            }
    //        }
    //   }
    //
    //}
}

struct RandPoke_Previews: PreviewProvider {
    static var previews: some View {
        RandPoke()
    }
}


// Extension for equatable conformance to be able to use the contains method in ForEach
//extension Pokemon: Equatable {
//    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
//        return lhs.id == rhs.id
//    }
//}

func capitalizeFirstLetter(_ text: String) -> String {
    guard let firstLetter = text.first else { return "" }
    return String(firstLetter).uppercased() + text.dropFirst()
}

