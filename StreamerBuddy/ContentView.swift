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
    @State private var responseText = ""
    @State private var isLoading = false
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
            Button(action: {
                isLoading = true
                fetchResponse(username: username)
            }){
                Text("Send API Request").padding()
                }.disabled(isLoading)
            if isLoading {
                ProgressView("Loading...")
            }
            Text(responseText)
        }
        .padding()
    }
    
    func fetchResponse(username: String) {
        let fullRequest: [String: Any] = [
            "model": "gpt-3.5-turbo-16k",
            "messages": [
                [
                    "role": "system",
                    "content": ""
                ],
                [
                    "role": "user",
                    "content": username
                ]
            ],
            "temperature": 0.9,
            "top_p": 1
        ]
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer API_KEY", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let requestData = try? JSONSerialization.data(withJSONObject: fullRequest) {
            request.httpBody = requestData
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data,
                   let decodedResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = decodedResponse["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    
                    DispatchQueue.main.async {
                        self.responseText = content
                    }
                } else {
                    print("API Request Failed")
                }
            }.resume()
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


