import Foundation

struct GameLevel: Identifiable, Codable {
    var id: Int
    let scoresToWin: Int
    var backgroundIndex: String
    var completed: Bool
    let timePerRound: Int
}
