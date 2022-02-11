import UIKit

final class SnowView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let emitter = layer as! CAEmitterLayer
    emitter.emitterPosition = .init(x: bounds.size.width / 2, y: 0)
    emitter.emitterSize = bounds.size
    emitter.emitterShape = .rectangle
    
    let emitterCell = CAEmitterCell()
    emitterCell.contents = UIImage(named: "flake")!.cgImage
    emitterCell.birthRate = 200
    emitterCell.lifetime = 3.5
    emitterCell.color = UIColor.white.cgColor
    emitterCell.redRange = 0
    emitterCell.blueRange = 0.1
    emitterCell.greenRange = 0
    emitterCell.velocity = 10
    emitterCell.velocityRange = 350
    emitterCell.emissionRange = .pi / 2
    emitterCell.emissionLongitude = -.pi
    emitterCell.yAcceleration = 70
    emitterCell.xAcceleration = 0
    emitterCell.scale = 1 / 3
    emitterCell.scaleRange = 1.25
    emitterCell.scaleSpeed = -0.25
    emitterCell.alphaRange = 0.5
    emitterCell.alphaSpeed = -0.15
    
    emitter.emitterCells = [emitterCell]
  }
  
  required init(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override class var layerClass: AnyClass { CAEmitterLayer.self }
}
