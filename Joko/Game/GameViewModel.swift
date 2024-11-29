
import SwiftUI

class GameViewModel: ObservableObject {
    @Published var grid: [[Ball]]
    @Published var score: Int = 0

    let rows: Int =  6
    let columns: Int = 5
    let imageNames: [String] = ["asdfgdfh01", "asdfgdfh02", "asdfgdfh03", "asdfgdfh04", "asdfgdfh05", "asdfgdfh06", "asdfgdfh07", "asdfgdfh08"]
    var boardSize: CGFloat = 300
    private var lastMoveTime = Date()
    private var hintTimer: Timer?
    private var hintVisible = false
    
    @Published var selectedLevel: GameLevel


    init(selectedLevel: GameLevel, isSE: Bool) {
        self.selectedLevel = selectedLevel
        self.grid = []
        resetGame()
    }

    func resetGame() {
        score = 0
        grid = (0..<rows).map { _ in
            (0..<columns).map { _ in
                Ball(imageName: imageNames.randomElement()!)
            }
        }
        removeMatches()
        resetHintTimer()
    }

    func selectCell(row: Int, column: Int) {
        resetHints()
        lastMoveTime = Date()
        resetHintTimer()

        let adjacentPositions = [
            (row - 1, column),
            (row + 1, column),
            (row, column - 1),
            (row, column + 1)
        ]

        var didSwap = false

        for position in adjacentPositions {
            let newRow = position.0
            let newColumn = position.1

            if newRow >= 0 && newRow < rows && newColumn >= 0 && newColumn < columns {
                if canSwapAndMatch(row1: row, column1: column, row2: newRow, column2: newColumn) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        swapCells(row1: row, column1: column, row2: newRow, column2: newColumn)
                    }
                    didSwap = true
                    // After 0.4 seconds, start removing matches
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.removeMatches()
                    }
                    break
                }
            }
        }

        if !didSwap {
            grid[row][column].isShaking = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.grid[row][column].isShaking = false
            }
        }
    }

    func canSwapAndMatch(row1: Int, column1: Int, row2: Int, column2: Int) -> Bool {
        swapCells(row1: row1, column1: column1, row2: row2, column2: column2)
        let hasMatch = hasMatches()
        swapCells(row1: row1, column1: column1, row2: row2, column2: column2)
        return hasMatch
    }

    func swapCells(row1: Int, column1: Int, row2: Int, column2: Int) {
        let temp = grid[row1][column1]
        grid[row1][column1] = grid[row2][column2]
        grid[row2][column2] = temp
    }

    func hasMatches() -> Bool {
        return !findMatches().isEmpty
    }

    func removeMatches() {
        let matches = findMatches()

        if !matches.isEmpty {
            let matchedCount = matches.count
            score += matchedCount * matchedCount

            // Після 0.4 секунд починаємо видаляти матчі
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                var delay: Double = 0
                for position in matches {
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            // Змінюємо назву картинки на "emptyImageName"
                            self.grid[position.row][position.column].imageName = "emptyImageName"
                        }
                    }
                    delay += 0.1
                }

                // Після видалення всіх м'ячів, оновлюємо сітку
                DispatchQueue.main.asyncAfter(deadline: .now() + delay + 0.3) {
                    self.collapseGrid()
                    self.fillEmptyCells()
                    self.removeMatches()
                }
            }
        }
    }

    func findMatches() -> Set<CellPosition> {
        var matches = Set<CellPosition>()

        // Знайти горизонтальні матчі
        for row in 0..<rows {
            var matchLength = 1
            for column in 1..<columns {
                if grid[row][column].imageName == grid[row][column - 1].imageName && grid[row][column].imageName != "emptyImageName" {
                    matchLength += 1
                } else {
                    if matchLength >= 3 {
                        for i in 0..<matchLength {
                            matches.insert(CellPosition(row: row, column: column - 1 - i))
                        }
                    }
                    matchLength = 1
                }
            }
            if matchLength >= 3 {
                for i in 0..<matchLength {
                    matches.insert(CellPosition(row: row, column: columns - 1 - i))
                }
            }
        }

        // Знайти вертикальні матчі
        for column in 0..<columns {
            var matchLength = 1
            for row in 1..<rows {
                if grid[row][column].imageName == grid[row - 1][column].imageName && grid[row][column].imageName != "emptyImageName" {
                    matchLength += 1
                } else {
                    if matchLength >= 3 {
                        for i in 0..<matchLength {
                            matches.insert(CellPosition(row: row - 1 - i, column: column))
                        }
                    }
                    matchLength = 1
                }
            }
            if matchLength >= 3 {
                for i in 0..<matchLength {
                    matches.insert(CellPosition(row: rows - 1 - i, column: column))
                }
            }
        }

        return matches
    }

    func collapseGrid() {
        for column in 0..<columns {
            var emptyRows = [Int]()
            for row in (0..<rows).reversed() {
                if grid[row][column].imageName == "emptyImageName" {
                    emptyRows.append(row)
                } else if !emptyRows.isEmpty {
                    let emptyRow = emptyRows.removeFirst()
                    grid[emptyRow][column] = grid[row][column]
                    grid[row][column] = Ball(imageName: "emptyImageName") // Оновлене
                    emptyRows.append(row)
                }
            }
        }
    }

    func fillEmptyCells() {
        for row in 0..<rows {
            for column in 0..<columns {
                if grid[row][column].imageName == "emptyImageName" {
                    // Призначте нову назву зображення випадково з доступних зображень
                    grid[row][column] = Ball(imageName: imageNames.randomElement()!)
                }
            }
        }
        resetHintTimer()
    }

    // Hint System
    func resetHintTimer() {
        hintTimer?.invalidate()
        hintVisible = false
        resetHints()
        hintTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            self.showHint()
        }
    }

    func showHint() {
        if hintVisible { return }
        hintVisible = true
        if let hint = findPossibleMatches().first {
            grid[hint.row1][hint.column1].isHinted = true
            grid[hint.row2][hint.column2].isHinted = true

            // Hide hint after 1 second
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.resetHints()
                self.hintVisible = false
                // If no action is taken, show hint again after 5 seconds
                self.hintTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
                    self.showHint()
                }
            }
        } else {
            hintVisible = false
        }
    }

    func resetHints() {
        for row in 0..<rows {
            for column in 0..<columns {
                grid[row][column].isHinted = false
            }
        }
    }

    func findPossibleMatches() -> [PossibleMove] {
        var possibleMoves = [PossibleMove]()

        for row in 0..<rows {
            for column in 0..<columns {
                let currentImageName = grid[row][column].imageName
                if currentImageName == "emptyImageName" { continue } // Замість .clear перевіряємо на "emptyImageName"

                let adjacentPositions = [
                    (row, column + 1), // Праворуч
                    (row + 1, column)  // Нижче
                ]

                for position in adjacentPositions {
                    let newRow = position.0
                    let newColumn = position.1

                    if newRow >= 0 && newRow < rows && newColumn >= 0 && newColumn < columns {
                        // Обмінюємо елементи
                        swapCells(row1: row, column1: column, row2: newRow, column2: newColumn)
                        // Перевіряємо на наявність збігів
                        if hasMatches() {
                            possibleMoves.append(PossibleMove(row1: row, column1: column, row2: newRow, column2: newColumn))
                        }
                        // Повертаємо на місце
                        swapCells(row1: row, column1: column, row2: newRow, column2: newColumn)
                    }
                }
            }
        }
        return possibleMoves
    }
}
