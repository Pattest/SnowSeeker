//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Baptiste Cadoux on 19/07/2022.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var favorites = Favorites()

    @State private var showingAlert: Bool = false
    @State private var searchText = ""

    @State private var sortedResorts: [Resort]
    private var resorts: [Resort]
    private var filteredResorts: [Resort] {
        if searchText.isEmpty {
            return sortedResorts
        } else {
            return sortedResorts.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    init() {
        resorts = Bundle.main.decode("resorts.json")
        sortedResorts = resorts
    }

    var body: some View {
        NavigationView {
            List(filteredResorts) { resort in
                NavigationLink {
                    ResortView(resort: resort)
                } label: {
                    Image(resort.country)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 25)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.black, lineWidth: 1)
                        )

                    VStack(alignment: .leading) {
                        Text(resort.name)
                            .font(.headline)
                        Text("\(resort.runs) runs")
                            .foregroundColor(.secondary)
                    }

                    if favorites.contains(resort) {
                        Spacer()
                        Image(systemName: "heart.fill")
                        .accessibilityLabel("This is a favorite resort")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Resorts")
            .toolbar {
                Button {
                    showingAlert = true
                } label: {
                    Image(systemName: "chevron.down.square")
                        .foregroundColor(.black)
                }
            }
            .alert("Sort list by:", isPresented: $showingAlert) {
                Button("Default") {
                    sortedResorts = resorts
                }
                Button("Country") {
                    sortedResorts.sort { firstResort, secondResort in
                        firstResort.country.lowercased() < secondResort.country.lowercased()
                    }
                }
                Button("Name") {
                    sortedResorts.sort { firstResort, secondResort in
                        firstResort.name.lowercased() < secondResort.name.lowercased()
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search for a resort")

            WelcomeView()
        }
        .environmentObject(favorites)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
