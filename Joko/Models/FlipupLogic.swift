import Foundation

enum FlipupLogic: Int, CaseIterable {
    case level0, level1, level2, level3, level4, level5, level6, level7, level8, level9, level10,
         level11, level12, level13, level14, level15, level16, level17, level18, level19, level20,
         level21, level22, level23, level24, level25, level26, level27, level28, level29, level30, level31,
         level32, level33, level34, level35, level36, level37, level38, level39, level40, level41,
         level42, level43, level44, level45, level46, level47, level48, level49, level50, level51,
         level52, level53, level54, level55, level56, level57, level58, level59, level60, level61,
         level62, level63, level64, level65, level66, level67, level68, level69, level70, level71,
         level72, level73, level74, level75, level76, level77, level78, level79, level80, level81,
         level82, level83, level84, level85, level86, level87, level88, level89, level90, level91,
         level92, level93, level94, level95, level96, level97, level98, level99, level100

    func levelData() -> GameLevel {
        let backgroundIndex = ["1", "2", "2", "4", "5", "6"].randomElement() ?? "No description available."
        
        return GameLevel(id: self.rawValue,
                         scoresToWin: Int.random(in: 200...700),
                         backgroundIndex: backgroundIndex,
                         completed: false,
                         timePerRound: Int.random(in: 40...120))
           
       }
}

