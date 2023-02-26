<h1>
    TallyCounter
</h1>

<p>
   <a href="https://www.linkedin.com/in/vladyslav-fil">
    <img src="https://img.shields.io/badge/author-Vladyslav%20Fil-brightgreen.svg" alt="Author">
   </a>
   <a href="https://github.com/Wsewlad/tally-counter/blob/main/README.md#license">
    <img src="https://img.shields.io/badge/license-MIT-black.svg" alt="License">
   </a>
   <a href="mailto:wladyslawfil@gmail.com">
       <img src="https://img.shields.io/badge/contact-wladyslawfil%40gmail.com-lightgrey.svg" alt="Contant">
   </a>
</p>

Tally Counter is a customizable counter element written in SwiftUI with a stretchy animation and haptics.

|Preview|
|---|
|<img src="https://github.com/Wsewlad/tally-counter/blob/main/resouces/main.gif">|

## Installation

You can install Tally Counter using Swift Package Manager. Simply add the following line to your Package.swift file:

```Swift
dependencies: [
    .package(url: "https://github.com/Wsewlad/tally-counter.git", from: "1.0.2"),
    /// ...
]
```

## Usage

To use Tally Counter in your project, first import the module:

```Swift
import TallyCounter
```

Then, add a TallyCounter view to your SwiftUI hierarchy:

```Swift
struct Example: View {
    @State private var count: Int = 0
    
    var body: some View {
        TallyCounter(
            count: $count
        )
    }
}
```

Parameters:
- `count` is a binding `Int` to the current count value
- `amount` is an optional binding `Int` value. It represents the amount to increment or decrement the count value when the user taps the "-" and "+" buttons or moves the central button left or right.
- `config` is an instance of the `Configuration` struct which allows customization of the counter's appearance

### `amount`

|Example|
|---|
|<img src="https://github.com/Wsewlad/tally-counter/blob/main/resouces/amount.gif">|

```Swift
struct ContentView: View {
    @State private var count: Int = 0
    @State private var amount: Int = 0
    
    var body: some View {
        VStack {
            Text("Amount: \(amount)")
                .font(.largeTitle)
                .foregroundColor(.white)
            
            TallyCounter(
                count: $count,
                amount: $amount
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.screenBackground.edgesIgnoringSafeArea(.all))
    }
}

```

## Configuration
The Configuration struct has the following properties:

- `minValue` (default: 0): The minimum value that the counter can have.
- `maxValue` (default: 999): The maximum value that the counter can have.
- `controlsContainerWidth` (default: 300): The width of the controls container.
- `showAmountLabel` (default: true): Whether to show the amount label.
- `amountLabelColor` (default: .white): The text color of the amount label.
- `controlsColor` (default: .white): The color of the controls.
- `labelBackgroundColor` (default: .labelBackground): The background color of the amount label.
- `labelTextColor` (default: .white) - The text color of the label.
- `controlsBackgroundColor` (default: .controlsBackground): The background color of the controls.
- `controlsOnTapCircleColor` (default: .white): The color of the controls' tap circle.
- `controlsBackgroundOverlayColor` (default: .black): The background overlay color of the controls.
- `hapticsEnabled` (default: true): A boolean value indicating whether haptic feedback should be enabled when interacting with the counter element. When set to true, the element will play custom haptic feedback using CHHapticEngine when the user taps the increment and decrement buttons or swipes on the central button. When set to false, no haptic feedback will be played.

### `showAmountLabel`

|Example|
|---|
|<img src="https://github.com/Wsewlad/tally-counter/blob/main/resouces/showAmountLabel-false.gif">|

```Swift
TallyCounter(
    count: $count,
    amount: $amount,
    config: .init(
        showAmountLabel: false
    )
)
```

### `amountLabelColor`

|Example|
|---|
|<img src="https://github.com/Wsewlad/tally-counter/blob/main/resouces/amountLabelColor.gif">|

```Swift
TallyCounter(
    count: $count,
    amount: $amount,
    config: .init(
        amountLabelColor: .green
    )
)
```

### `controlsColor`

|Example|
|---|
|<img src="https://github.com/Wsewlad/tally-counter/blob/main/resouces/controlsColor.gif">|

```Swift
TallyCounter(
    count: $count,
    amount: $amount,
    config: .init(
        showAmountLabel: false,
        controlsColor: .blue
    )
)
```

### `labelBackgroundColor`

|Example|
|---|
|<img src="https://github.com/Wsewlad/tally-counter/blob/main/resouces/labelBackgroundColor.gif">|

```Swift
TallyCounter(
    count: $count,
    amount: $amount,
    config: .init(
        showAmountLabel: false,
        controlsColor: .blue,
        labelBackgroundColor: .red
    )
)
```

### `controlsBackgroundColor`

|Example|
|---|
|<img src="https://github.com/Wsewlad/tally-counter/blob/main/resouces/controlsBackgroundColor.gif">|

```Swift
TallyCounter(
    count: $count,
    amount: $amount,
    config: .init(
        showAmountLabel: false,
        controlsColor: .blue,
        labelBackgroundColor: .red,
        controlsBackgroundColor: .green
    )
)
```

### `controlsOnTapCircleColor`

|Example|
|---|
|<img src="https://github.com/Wsewlad/tally-counter/blob/main/resouces/controlsOnTapCircleColor.gif">|

```Swift
TallyCounter(
    count: $count,
    amount: $amount,
    config: .init(
        showAmountLabel: false,
        controlsColor: .blue,
        labelBackgroundColor: .red,
        controlsBackgroundColor: .green,
        controlsOnTapCircleColor: .yellow
    )
)
```

### `controlsBackgroundOverlayColor`

|Example|
|---|
|<img src="https://github.com/Wsewlad/tally-counter/blob/main/resouces/controlsBackgroundOverlayColor.gif">|

```Swift
TallyCounter(
    count: $count,
    amount: $amount,
    config: .init(
        showAmountLabel: false,
        controlsColor: .blue,
        labelBackgroundColor: .red,
        controlsBackgroundColor: .white,
        controlsOnTapCircleColor: .yellow,
        controlsBackgroundOverlayColor: .red
    )
)
```

> Inspired by [Ehsan Rahimi](https://dribbble.com/ehsancinematic) Tally Counter Micro-Interaction concept.
<img src="https://github.com/Wsewlad/TallyCounter/blob/main/dribbble.gif" width="500px">

## License

TallyCounter is available under the MIT license. See the <a href="https://github.com/Wsewlad/tally-counter/blob/main/LICENSE.md">LICENSE</a> file for more information.

## Support
###### If my work has brought you value or made your day a little brighter, show your appreciation

<a href="https://www.buymeacoffee.com/vfil">
<img src="https://github.com/Wsewlad/samples/blob/ebac4f3f66d3ffbd9d1f82bd405f04da3e258dd1/bmc/bmc-button.png" width="170px">
<br/>
<img src="https://github.com/Wsewlad/samples/blob/ebac4f3f66d3ffbd9d1f82bd405f04da3e258dd1/bmc/bmc_qr.png" width="170px">
</a>
