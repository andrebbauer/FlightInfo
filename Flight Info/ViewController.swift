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
    //TODO: Animate a label's translation property
  }
  
  func cubeTransition(label: UILabel, text: String) {
    //TODO: Create a faux rotating cube animation
  }
  
  func depart() {
    //TODO: Animate the plane taking off and landing
  }
  
  func changeSummary(to summaryText: String) {
    //TODO: Animate the summary text
  }
  
  func changeFlight(to flight: Flight, animated: Bool = false) {
    // populate the UI with the next flight's data
    originLabel.text = flight.origin
    destinationLabel.text = flight.destination
    flightNumberLabel.text = flight.number
    gateNumberLabel.text = flight.gateNumber
    statusLabel.text = flight.status
    summary.text = flight.summary
    
    if animated {
      fade(
        to: UIImage(named: flight.weatherImageName)!,
        showEffects: flight.showWeatherEffects
      )
    } else {
      background.image = UIImage(named: flight.weatherImageName)
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
