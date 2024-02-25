//
//  ContentView.swift
//  iDex
//
//  Created by Tyler on 24/02/2024.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Completion Example", destination: CompletionExampleView())
                NavigationLink("Combine Example", destination: CombineExampleView())
                NavigationLink("Async/Await Example", destination: AsyncAwaitExampleView())
                NavigationLink("Paginated Results Example", destination: ResultsView())
            }
            #if os(iOS) || os(macOS)
            .listStyle(.sidebar)
            #endif
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
