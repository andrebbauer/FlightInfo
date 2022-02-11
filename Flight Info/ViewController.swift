import UIKit

class ViewController: UIViewController {
  @IBOutlet var background: UIImageView!
  
  @IBOutlet var summaryIcon: UIImageView!
  @IBOutlet var summary: UILabel!
  
  @IBOutlet var flightNumberLabel: UILabel!
  @IBOutlet var gateNumberLabel: UILabel!
  @IBOutlet var originLabel: UILabel!
  @IBOutlet var destinationLabel: UILabel!
  @IBOutlet var plane: UIImageView!
  
  @IBOutlet var statusLabel: UILabel!
  @IBOutlet var statusBanner: UIImageView!
  
  private let snowView = SnowView( frame: .init(x: -150, y:-100, width: 300, height: 50) )
}

//MARK:- UIViewController
extension ViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Add the snow effect layer
    let snowClipView = UIView( frame: view.frame.offsetBy(dx: 0, dy: 50) )
    snowClipView.clipsToBounds = true
    snowClipView.addSubview(snowView)
    view.addSubview(snowClipView)
    
    // Start rotating the flights
    changeFlight(to: .londonToParis, animated: false)
  }
}

private extension ViewController {
  //MARK:- Animations
  
  func fade(to image: UIImage, showEffects: Bool) {
    // create and set temp view
    let tempView = UIImageView(frame: background.frame)
    tempView.image = image
    tempView.alpha = 0
    tempView.center.y += 20
    tempView.bounds.size.width = background.bounds.width * 1.3
    background.superview!.insertSubview(tempView, aboveSubview: background)
    
    UIView.animate(
      withDuration: 0.5,
      animations: {
        // fade temp view in
        tempView.alpha = 1
        tempView.center.y -= 20
        tempView.bounds.size = self.background.bounds.size
      },
      completion: { _ in
        // update background view and remove temp view
        self.background.image = image
        tempView.removeFromSuperview()
      }
    )
    
    UIView.animate(
      withDuration: 1,
      delay: 0,
      options: .curveEaseOut,
      animations: {
        self.snowView.alpha = showEffects ? 1.0 : 0
      })
  }
  
  func move(label: UILabel, text: String, offset: CGPoint) {
    // create and setup temp label
    let tempLabel = duplicate(label)
    tempLabel.text = text
    tempLabel.transform = .init(translationX: offset.x, y: offset.y)
    tempLabel.alpha = 0
    view.addSubview(tempLabel)
    
    // fade out and translate real label
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      options: .curveEaseIn,
      animations: {
        label.transform = .init(translationX: offset.x, y: offset.y)
        label.alpha = 0
      }
    )
    // fade in and translate temp label
    UIView.animate(
      withDuration: 0.25,
      delay: 0.2,
      options: .curveEaseIn,
      animations: {
        tempLabel.transform = .identity
        tempLabel.alpha = 1
      },
      completion: { _ in
        // update real label and remove temp label
        label.text = text
        label.alpha = 1
        label.transform = .identity
        tempLabel.removeFromSuperview()
      }
    )
  }
  
  func cubeTransition(label: UILabel, text: String) {
    // create and set up temp label
    let tempLabel = duplicate(label)
    tempLabel.text = text
    let tempLabelOffset = label.frame.size.height / 2
    let scale = CGAffineTransform(scaleX: 1, y: 0.1)
    let translate = CGAffineTransform(translationX: 0, y: tempLabelOffset)
    tempLabel.transform = scale.concatenating(translate)
    view.addSubview(tempLabel)
    
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      options: .curveEaseOut,
      animations: {
        // scale temp label down and translate up
        tempLabel.transform = .identity
        
        // scale real label down and translate up
        label.transform = scale.concatenating( translate.inverted() )
      },
      completion: { _ in
        // update real label's text and reset its transform
        label.text = text
        label.transform = .identity
        
        // remove temp label
        tempLabel.removeFromSuperview()
      }
    )
  }
  
  func depart() {
    //TODO: Animate the plane taking off and landing
  }
  
  func changeSummary(to summaryText: String) {
    //TODO: Animate the summary text
  }
  
  func changeFlight(to flight: Flight, animated: Bool = false) {
    // populate the UI with the next flight's data
    flightNumberLabel.text = flight.number
    gateNumberLabel.text = flight.gateNumber
    summary.text = flight.summary
    
    if animated {
      fade(
        to: UIImage(named: flight.weatherImageName)!,
        showEffects: flight.showWeatherEffects
      )
      
      move(label: originLabel, text: flight.origin, offset: .init(x: -80, y: 0))
      move(label: destinationLabel, text: flight.destination, offset: .init(x: 80, y: 0))
      
      cubeTransition(label: statusLabel, text: flight.status)
    } else {
      background.image = UIImage(named: flight.weatherImageName)
      originLabel.text = flight.origin
      destinationLabel.text = flight.destination
      statusLabel.text = flight.status
    }
    
    // schedule next flight
    delay(seconds: 3) {
      self.changeFlight(
        to: flight.isTakingOff ? .parisToRome : .londonToParis,
        animated: true
      )
    }
  }
  
  //MARK:- utility methods
  func duplicate(_ label: UILabel) -> UILabel {
    let newLabel = UILabel(frame: label.frame)
    newLabel.font = label.font
    newLabel.textAlignment = label.textAlignment
    newLabel.textColor = label.textColor
    newLabel.backgroundColor = label.backgroundColor
    return newLabel
  }
}

private func delay(seconds: TimeInterval, execute: @escaping () -> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: execute)
}
