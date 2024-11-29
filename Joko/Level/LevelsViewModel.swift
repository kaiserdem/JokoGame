import SwiftUI

class LevelsViewModel: ObservableObject {
    @Published var score: Int = 0
    @Published var levels: [GameLevel] = []
    @Published var totalCoins: Int = 0
    @Published var isDebugMode: Bool = false
    
    init() {
        
        if let debugModeValue = Bundle.main.object(forInfoDictionaryKey: "DebugMode") as? Bool {
            isDebugMode = debugModeValue
        }
        
        getData()
        
        NotificationCenter.default.addObserver(forName: Notification.Name("UpdateLevels"), object: nil, queue: .main)  { [weak self] _ in
            guard let self = self else { return }
            
            self.getData()
        }
        
    }
    
    func getData() {
        levels = loadLevels()
        
        if let savedCoins = UserDefaults.standard.integer(forKey: "totalCoins") as? Int {
            totalCoins = savedCoins
            print("Loaded total Coins: \(totalCoins)")

        }
       
        levels.forEach {
            print("scores To Win: \($0.scoresToWin), time:\($0.timePerRound), \($0.completed), index: \($0.backgroundIndex)")
        }
    }
    
    func saveLevels(_ levels:[ GameLevel]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(levels) {
            UserDefaults.standard.set(encoded, forKey: "SavedGameLevels")
        }
    }
    
    
    private func loadLevels() -> [GameLevel] {
        if let data = UserDefaults.standard.data(forKey: "SavedGameLevels") {
            do {
                return try JSONDecoder().decode([GameLevel].self, from: data)
            } catch {
                print("Помилка декодування: \(error)")
                return []
            }
        } else {
            let items = FlipupLogic.allCases.map { $0.levelData() }
            levels = items
            saveLevels(items)
            
            return levels
            
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
