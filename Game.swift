//
//  Game.swift
//  redLightGreenLight
//
//  Created by Nick Porrazzo on 3/23/24.
//

import SwiftUI

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.scenePhase) var scenePhase: ScenePhase
    
    @State private var backgroundColor = Color.red
    @State private var gameTimer: Int = 0
    @State private var startTime = Date()
    @State private var endTime: Date?
    
    // debugging
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @ObservedObject private var gameSettings = GameSettings()
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    var onGameEnd: () -> Void
    
    var settings: [GameSetting] = []
    
    init(onGameEnd: @escaping () -> Void) {
        self.onGameEnd = onGameEnd

        let url = getDocumentsDirectory().appendingPathComponent("GameSettings.json")
        if let data = try? Data(contentsOf: url),
           let loadedSettings = try? JSONDecoder().decode([GameSetting].self, from: data) {
            settings = loadedSettings
        }
    }

    var instruction: String {
        let colorName = String(describing: backgroundColor).capitalized
        return gameSettings.settings.first(where: { $0.color == colorName })?.instruction ?? ""
    }
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            if endTime != nil {
                Text("Time: \(formatTimeInterval(elaspedTime))")
                    .font(.system(size: 80))
                    .foregroundColor(.black)
                    .offset(x: 0, y: 100)
            } else {
                Text(instruction)
                    .font(.system(size: 80))
                    .foregroundColor(.black)
                    .rotationEffect(scenePhase == .active ? .degrees(0) : .degrees(90))
            }
        }
        .onReceive(timer) { _ in
            let url = getDocumentsDirectory().appendingPathComponent("GameSettings.json")
            if let data = try? Data(contentsOf: url),
               let loadedSettings = try? JSONDecoder().decode([GameSetting].self, from: data) {
                gameSettings.settings = loadedSettings
                if let randomSetting = gameSettings.settings.randomElement() {
                   backgroundColor = colorFromString(randomSetting.color)
                   //print("Selected random setting: \(randomSetting)")
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onTapGesture {
            self.endTime = Date()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.onGameEnd()
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    var elaspedTime: TimeInterval {
        guard let endTime = endTime else {
            return 0
        }
        return endTime.timeIntervalSince(startTime)
    }

    func formatTimeInterval(_ interval: TimeInterval) -> String {
        let intervalInt = Int(interval)
        let milliseconds = Int((interval - Double(intervalInt)) * 1000)
        let seconds = intervalInt % 60
        let minutes = (intervalInt / 60) % 60
        return String(format: "%02d:%02d:%02d", minutes, seconds, milliseconds)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func colorFromString(_ color: String) -> Color {
        switch color.lowercased() {
        case "red":
            return .red
        case "green":
            return .green
        case "blue":
            return .blue
        case "yellow":
            return .yellow
        case "orange":
            return .orange
        case "purple":
            return .purple
        case "grey":
            return .gray
        case "brown":
            return .brown
        case "cyan":
            return .cyan
        // Add more cases as needed
        default:
            return .red
        }
    }
    
    class GameSettings: ObservableObject {
        @Published var settings: [GameSetting] = []

        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0]
        }
        
        init() {
            let url = getDocumentsDirectory().appendingPathComponent("GameSettings.json")
            if let data = try? Data(contentsOf: url),
               let loadedSettings = try? JSONDecoder().decode([GameSetting].self, from: data) {
                settings = loadedSettings
            }
        }
    }
}
    
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(onGameEnd: {})
    }
}
