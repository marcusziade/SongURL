//
//  MainView.swift
//  quicksonglink
//
//  Created by Marcus Ziadé on 12.8.2022.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var model = ViewModel(service: SongLinkService())
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Link", text: $model.searchURL)
            
            Button {
                Task { try await model.generate() }
            } label: {
                Text("Generate Song.link URL")
            }
            
            switch model.state {
            case .loading:
                ProgressView()
                    .progressViewStyle(.linear)
                    .frame(width: 150)
                Text(model.state.title)
                
            case .error(let message):
                Text(message)
                    .foregroundColor(.red)
                
            case .result(let link, let message):
                ResultView(link: link, message: message)
                
            case .idle:
                EmptyView()
            }
            
            Spacer()
        }
        .frame(width: 600, height: model.state.isSuccess ? 490 : 150)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
