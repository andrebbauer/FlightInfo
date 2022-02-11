struct Flight {
  let summary: String
  let number: String
  let gateNumber: String
  let origin: String
  let destination: String
  let weatherImageName: String
  let showWeatherEffects: Bool
  let isTakingOff: Bool
  let status: String
}

//MARK:- internal
extension Flight {
  static let londonToParis = Self(
    summary: "26 Oct 2020 09:42",
    number: "ZY 2014",
    gateNumber: "T1 A33",
    origin: "LGW",
    destination: "CDG",
    weatherImageName: "bg-snowy",
    showWeatherEffects: true,
    isTakingOff: true,
    status: "Boarding"
  )

  static let parisToRome = Self(
    summary: "31 Oct 2020 17:05",
    number: "AE 1107",
    gateNumber: "045",
    origin: "CDG",
    destination: "FCO",
    weatherImageName: "bg-sunny",
    showWeatherEffects: false,
    isTakingOff: false,
    status: "Delayed"
  )
}
