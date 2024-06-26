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

    var body: some View {
        NavigationView {
            List {
                ForEach(pokedex) { pokemon in
                    NavigationLink {
                        VStack {
                            AsyncImage(url: pokemon.sprite) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150)
                            } placeholder: {
                                ProgressView()
                            }
                            Text(pokemon.name!.capitalized)
                        }
                    } label: {
                        HStack {
                            AsyncImage(url: pokemon.sprite) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50)
                            } placeholder: {
                                ProgressView()
                            }
                            Text(pokemon.name!.capitalized)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
