//
//  ContentView.swift
//  BTC_WEBSockets
//
//  Created by Nikolay Beznos on 22.07.2021.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject private(set) var viewModel = ViewModel()

    var body: some View {
        VStack {
        Text("Current BTC price is")
                .fontWeight(.heavy)
                .font(.title)
                .padding()
            
        Text("\(viewModel.price) USD")
            .foregroundColor(.green)
            .fontWeight(.heavy)
            .font(.largeTitle)
            .padding()
            .onAppear(perform: viewModel.start)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
