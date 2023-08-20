import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var dinosaur: SKSpriteNode!
    var ground: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var score = 0
    
    override func didMove(to view: SKView) {
        setupPhysics()
        setupDinosaur()
        setupGround()
        setupScore()
        spawnObstacles()
        self.backgroundColor = SKColor.blue
    }
    
    struct PhysicsCategories {
        static let dinosaur: UInt32 = 0x1 << 1
        static let obstacle: UInt32 = 0x1 << 2
        static let ground: UInt32 = 0x1 << 3
    }
    
    func setupPhysics() {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
    }
    
    func setupDinosaur() {
        dinosaur = SKSpriteNode(imageNamed: "dinosaur")
        dinosaur.position = CGPoint(x: dinosaur.size.width/2, y: ground.size.height + dinosaur.size.height/2)
        
        dinosaur.physicsBody = SKPhysicsBody(rectangleOf: dinosaur.size)
        dinosaur.physicsBody?.isDynamic = true
        dinosaur.physicsBody?.categoryBitMask = PhysicsCategories.dinosaur
        dinosaur.physicsBody?.collisionBitMask = PhysicsCategories.ground | PhysicsCategories.obstacle
        dinosaur.physicsBody?.contactTestBitMask = PhysicsCategories.obstacle
        
        addChild(dinosaur)
    }
    
    func setupGround() {
        ground = SKSpriteNode(imageNamed: "ground")
        ground.position = CGPoint(x: size.width / 2, y: ground.size.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = PhysicsCategories.ground
        
        addChild(ground)
    }

    func setupScore() {
        scoreLabel = SKLabelNode(fontNamed: "Arial")
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 50)
        scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
    }
    
    func updateScore() {
        score += 1
        scoreLabel.text = "Score: \(score)"
    }
    
    func spawnObstacles() {
        let createObstacle = SKAction.run {
            let obstacle = SKSpriteNode(imageNamed: "obstacle")
            obstacle.position = CGPoint(x: self.size.width + obstacle.size.width / 2, y: self.ground.size.height + obstacle.size.height / 2)
            obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
            obstacle.physicsBody?.categoryBitMask = PhysicsCategories.obstacle
            obstacle.physicsBody?.isDynamic = false
            
            let moveAction = SKAction.moveTo(x: -obstacle.size.width, duration: 5)
            let removeAction = SKAction.removeFromParent()
            obstacle.run(SKAction.sequence([moveAction, removeAction]))
            
            self.addChild(obstacle)
        }
        
        let waitAction = SKAction.wait(forDuration: 2)
        let spawnSequence = SKAction.sequence([createObstacle, waitAction])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        
        run(spawnForever)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dinosaurJump()
    }
    
    func dinosaurJump() {
        let jumpForce = CGVector(dx: 0, dy: 200)
        dinosaur.physicsBody?.applyImpulse(jumpForce)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == PhysicsCategories.dinosaur && contact.bodyB.categoryBitMask == PhysicsCategories.obstacle) ||
           (contact.bodyB.categoryBitMask == PhysicsCategories.dinosaur && contact.bodyA.categoryBitMask == PhysicsCategories.obstacle) {
            gameOver()
        }
    }

    func startGame() {
        score = 0
        self.scene?.isPaused = false
    }

    func gameOver() {
        self.scene?.isPaused = true
        // TODO: Show a "Game Over" label and a restart button
    }

    func restartGame() {
        for child in children {
            if child.name == "obstacle" {
                child.removeFromParent()
            }
        }

        startGame()
    }
}
