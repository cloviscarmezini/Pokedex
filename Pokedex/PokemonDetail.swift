//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by Clovis Carmezini on 01/07/24.
//

import SwiftUI
import CoreData

struct PokemonDetail: View {
    @EnvironmentObject var pokemon: Pokemon
    @State var showShiny: Bool = false
    
    var body: some View {
        ScrollView {
            ZStack {
                Image("normalgrasselectricpoisonfairy")
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .black, radius: 6)
                
                AsyncImage(url: showShiny ? pokemon.shiny : pokemon.sprite) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 50)
                        .shadow(color: .black, radius: 6)
                } placeholder: {
                    ProgressView()
                }
            }
            
            HStack {
                ForEach(pokemon.types!, id: \.self) { type in
                    Text(type.capitalized)
                        .font(.title2)
                        .shadow(color: .white,radius: 1)
                        .padding([.top, .bottom], 7)
                        .padding([.leading, .trailing])
                        .background(Color(type.capitalized))
                        .cornerRadius(50)
                }
                
                Spacer()
            }.padding()
        }
        .navigationTitle(pokemon.name!.capitalized)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showShiny.toggle()
                } label: {
                    if(showShiny) {
                        Image(systemName: "wand.end.stars")
                            .foregroundStyle(.yellow)
                    } else {
                        Image(systemName: "wand.end.stars.inverse")
                    }
                }
            }
        }
    }
}

#Preview {
    PokemonDetail().environmentObject(SamplePokemon.samplePokemon)
}
