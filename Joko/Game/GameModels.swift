
import SwiftUI

struct Ball: Identifiable {
    let id = UUID()
    var imageName: String  // Зберігання назви зображення
    var isMatched: Bool = false
    var isShaking: Bool = false
    var isHinted: Bool = false
}

struct CellPosition: Hashable {
    let row: Int
    let column: Int
}

struct PossibleMove {
    let row1: Int
    let column1: Int
    let row2: Int
    let column2: Int
}

struct ShakeEffect: GeometryEffect {
    var shakes: Int
    var amplitude: CGFloat = 10
    var animatableData: CGFloat = 0

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = amplitude * sin(animatableData * .pi * CGFloat(shakes))
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}

