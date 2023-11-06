//
//  ContentView.swift
//  StreamerBuddy
//
//  Created by Melchor Tatlonghari on 6/11/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var username: String=""
    @State private var showAlert = false
    @State private var joke: String = ""
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello")
            TextField(
                    "Enter your Query",
                    text: $username
            ).onSubmit {
                print("hello world")
            }
            Text(joke)
            Button {
                        Task {
                            let (data, _) = try await URLSession.shared.data(from: URL(string:"https://api.chucknorris.io/jokes/random")!)
                            let decodedResponse = try? JSONDecoder().decode(Joke.self, from: data)
                            joke = decodedResponse?.value ?? ""
                        }
                    } label: {
                        Text("Fetch Chuck Norris Joke")
                    }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Joke: Codable {
    let value: String
}


