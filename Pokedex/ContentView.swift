//
//  ContentView.swift
//  Pokedex
//
//  Created by Clovis Carmezini on 19/06/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default
    ) private var pokedex: FetchedResults<Pokemon>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        predicate: NSPredicate(format: "favorite = %d", true),
        animation: .default
    ) private var favorites: FetchedResults<Pokemon>
    
    @State var filterByFavorites = false
    @StateObject private var prokemonVM = PokemonViewModel(controller: FetchController())

    var body: some View {
        switch prokemonVM.status {
            case .success:
                NavigationStack {
                    List(filterByFavorites ? favorites : pokedex) { pokemon in
                        NavigationLink(value: pokemon) {
                            HStack(alignment: .center) {
                                AsyncImage(url: pokemon.sprite) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 100, height: 100)
                                
                                Text(pokemon.name!.capitalized)
                                
                                Spacer()
                                
                                if pokemon.favorite {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                }
                            }
                        }
                    }
                    .navigationTitle("Pokedex")
                    .navigationDestination(for: Pokemon.self, destination: { pokemon in
                        PokemonDetail()
                            .environmentObject(pokemon)
                    })
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                withAnimation {
                                    filterByFavorites.toggle()
                                }
                            } label: {
                                Image(systemName: filterByFavorites ? "star.fill" : "star")
                            }
                            .font(.title)
                            .foregroundColor(.yellow)
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
