//
//  ContentView.swift
//  Pokedex
//
//  Created by Clovis Carmezini on 19/06/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default)
    private var pokedex: FetchedResults<Pokemon>
    
    @StateObject private var prokemonVM = PokemonViewModel(controller: FetchController())

    var body: some View {
        switch prokemonVM.status {
            case .success:
                NavigationStack {
                    List(pokedex) { pokemon in
                        NavigationLink(value: pokemon) {
                            AsyncImage(url: pokemon.sprite) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                            
                            Text(pokemon.name!.capitalized)
                        }
                    }
                    .navigationTitle("Pokedex")
                    .navigationDestination(for: Pokemon.self, destination: { pokemon in
                        PokemonDetail()
                            .environmentObject(pokemon)
                    })
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            EditButton()
                        }
                    }
                }
            case .failed:
                        Text("Something went wrong on fetching pokemons")
            default:
                ProgressView()
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
