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
                audioPlayer?.volume = Float(UserDefaults.standard.float(forKey: "musicVolume")) // Завантаження гучності з UserDefaults
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
    
    func toggleMusic() {
        if audioPlayer?.isPlaying == true {
            stopBackgroundMusic()
        } else {
            playBackgroundMusic()
        }
    }
}
