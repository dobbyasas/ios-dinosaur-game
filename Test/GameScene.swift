import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var dinosaur: SKSpriteNode!
    var ground: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var score = 0
    
    override func didMove(to view: SKView) {
        setupDinosaur()
        setupGround()
        setupScore()
        spawnObstacles()
    }
    
    func setupDinosaur() {
        dinosaur = SKSpriteNode(imageNamed: "dinosaur")
        // set dinosaur properties and add to scene
        addChild(dinosaur)
    }
    
    func setupGround() {
        ground = SKSpriteNode(imageNamed: "ground")
        // set ground properties, physics, and add to scene
        addChild(ground)
    }
    
    func setupScore() {
        scoreLabel = SKLabelNode(fontNamed: "Arial")
        // set label properties and add to scene
        addChild(scoreLabel)
    }
    
    func spawnObstacles() {
        // Spawn obstacles at intervals and set them to move from right to left
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dinosaurJump()
    }
    
    func dinosaurJump() {
        // Apply force or change velocity to make dinosaur jump
    }
    
    func gameOver() {
        // Handle game over logic
    }
    
    func restartGame() {
        // Reset the game
    }
}
