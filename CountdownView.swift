//
//  CountdownView.swift
//  redLightGreenLight
//
//  Created by Nick Porrazzo on 3/24/24.
//

import SwiftUI

struct CountdownView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.scenePhase) var scenePhase: ScenePhase
    @State private var timeRemaining = 3
    @State private var timer: Timer?
    @State private var backgroundColor: Color = Color.clear;
    @State private var showGameScreen = false;
    
    var body: some View{
        VStack {
            Spacer()
            if timeRemaining > 0 {
                Text("\(timeRemaining)")
                .font(.system(size: 60))
                .multilineTextAlignment(.center)
                .rotationEffect(scenePhase == .active ? .degrees(0) : .degrees(90))
            }
            Spacer()
        }
        .onAppear(perform: startTimer)
        .onDisappear(perform: stopTimer)
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showGameScreen, content: {
            GameView(onGameEnd:{self.presentationMode.wrappedValue.dismiss()})
        })
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                showGameScreen = true
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
    }
}

#Preview {
    CountdownView()
}
