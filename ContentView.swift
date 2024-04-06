//
//  ContentView.swift
//  redLightGreenLight
//
//  Created by Nick Porrazzo on 3/23/24.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) var scenePhase: ScenePhase
    @Query private var items: [Item]
    @State private var backgroundColor: Color = Color.clear;
    @State private var showCountdownScreen = false;
    @State private var showUserSettings = false;
    @State private var showGameSettings = false;

    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()
                Text("Red Light Green Light🚦!")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
                    
                Button(action: {
                    self.showCountdownScreen = true
                }) {
                    Text("Start Game")
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $showCountdownScreen, content: {
                    CountdownView()
                })
                
                Spacer()
                
            }
            .background(backgroundColor)
            .transition(.opacity)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {self.showUserSettings = true}) {
                        Label("User Settings", systemImage: "gearshape.fill")
                    }
                }
            }
            .sheet(isPresented: $showUserSettings) {
                UserSettingsView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {self.showGameSettings = true}) {
                        Label("Game Settings", systemImage: "line.horizontal.3")
                    }
                }
            }
            .sheet(isPresented: $showGameSettings, content: {
                GameSettingsView()
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

