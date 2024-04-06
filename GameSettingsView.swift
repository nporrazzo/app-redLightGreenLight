//
//  UserSettings.swift
//  redLightGreenLight
//
//  Created by Nick Porrazzo on 3/27/24.
//

import SwiftUI
import SwiftData

struct GameSetting: Codable {
    var color: String
    var instruction: String
}

struct GameSettingsView: View {
    @State private var settings: [GameSetting] = []
    
    init() {
        loadSettings()
    }
    
    @State private var showingAlert = false
    @State private var showingResetAlert = false

    enum AlertType: Identifiable {
        case reset, save
        var id: AlertType { self }
    }
    
    @State private var currentAlert: AlertType?
    
    var body: some View {
        NavigationView {
            Form {
                ForEach(settings.indices, id: \.self) { index in
                    HStack {
                        TextField("Color", text: $settings[index].color)
                        TextField("Instruction", text: $settings[index].instruction)
                    }
                }
                .onDelete(perform: deleteSettings)
            }
            .navigationBarTitle("Game Settings")
            .navigationBarItems(leading: HStack {
                Button("Reset") {
                    currentAlert = .reset
                }
                Button("Add") {
                    settings.append(GameSetting(color: "", instruction: ""))
                    saveSettings()
                    //currentAlert = .save
                }
            }, trailing: Button("Save") {
                saveSettings()
                currentAlert = .save
            })
            .alert(item: $currentAlert) { alertType in
                switch alertType {
                case .reset:
                    return Alert(title: Text("Reset Settings"), message: Text("Are you sure you want to reset the settings to their default values?"), primaryButton: .destructive(Text("Reset")) {
                        UserDefaults.standard.removeObject(forKey: "GameSettings")
                    }, secondaryButton: .cancel())
                case .save:
                    return Alert(title: Text("Saved"), message: Text("Your settings have been saved."), dismissButton: .default(Text("OK")))
                }
            }
            .onAppear(perform: loadSettings)
        }
    }

    func saveSettings() {
        let encoder = JSONEncoder()
        if let encodedSettings = try? encoder.encode(settings) {
            let url = getDocumentsDirectory().appendingPathComponent("GameSettings.json")
            do {
                settings.append(GameSetting(color:"", instruction: ""))
                try encodedSettings.write(to: url)
            } catch {
                print("Error writing settings to file: \(error)")
            }
        }
    }
    
    func deleteSettings(at offsets: IndexSet){
        settings.remove(atOffsets: offsets)
        saveSettings()
    }
    
    func loadSettings() {
        let url = getDocumentsDirectory().appendingPathComponent("GameSettings.json")
        if let data = try? Data(contentsOf: url),
           let loadedSettings = try? JSONDecoder().decode([GameSetting].self, from: data) {
            settings = loadedSettings
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}


#Preview {
    GameSettingsView()
}
