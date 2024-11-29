import AVFoundation

class MusicManager {
    static let shared = MusicManager()
    
    var audioPlayer: AVAudioPlayer?
    private init() {}
    
    func playBackgroundMusic() {
            guard let url = Bundle.main.url(forResource: "joco-music", withExtension: "mp3") else {
                print("File not found: joco-music.mp3")
                return
            }
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.volume = 0.3
                audioPlayer?.prepareToPlay() // Додано prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Error loading music file: \(error)")
            }
        }
    
    func stopBackgroundMusic() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
    
    func toggleMusic() -> Bool {
        if audioPlayer?.isPlaying == true {
            stopBackgroundMusic()
            return false
        } else {
            playBackgroundMusic()
            return true 
        }
    }
    
    func toggleMusic() {
        if audioPlayer?.isPlaying == true {
            stopBackgroundMusic()
        } else {
            playBackgroundMusic()
        }
    }
}
