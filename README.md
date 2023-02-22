<h1 align="center">
    TallyCounter
</h1>

<p align="center">
   <a href="https://www.linkedin.com/in/vladyslav-fil">
    <img src="https://img.shields.io/badge/author-Vladyslav%20Fil-brightgreen.svg" alt="Author">
   </a>
   <a href="https://github.com/Wsewlad/tally-counter/main/README.md#license">
    <img src="https://img.shields.io/badge/license-MIT-black.svg" alt="License">
   </a>
   <a href="mailto:wladyslawfil@gmail.com">
       <img src="https://img.shields.io/badge/contact-wladyslawfil%40gmail.com-lightgrey.svg" alt="Contant">
   </a>
</p>

Tally Counter is a counter element written in SwiftUI with a stretchy animation.

## Installation

You can install Tally Counter using Swift Package Manager. Simply add the following line to your Package.swift file:

```Swift
dependencies: [
    .package(url: "https://github.com/Wsewlad/tally-counter.git", from: "1.0.0"),
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
        VStack {
            Text("\(amount)")
                .font(.largeTitle)
                .foregroundColor(.white)
            
            TallyCounter(
                count: $count
            )
        }
    }
}
```

Parameters:
- `count` is a binding `Int` to the current count value
- `amount` is an optional binding `Int` value. It represents the amount to increment or decrement the count value when the user taps the "-" and "+" buttons or moves the central button left or right.
- `config` is an instance of the `Configuration` struct which allows customization of the counter's appearance

## Configuration
The Configuration struct has the following properties:

- `minValue` (default: 0): The minimum value that the counter can have.
- `maxValue` (default: 999): The maximum value that the counter can have.
- `controlsContainerWidth` (default: 300): The width of the controls container.
- `showAmountLabel` (default: true): Whether to show the amount label.
- `controlsColor` (default: .white): The color of the controls.
- `labelBackgroundColor` (default: .labelBackground): The background color of the amount label.
- `controlsBackgroundColor` (default: .controlsBackground): The background color of the controls.
- `controlsOnTapCircleColor` (default: .white): The color of the controls' tap circle.
- `controlsBackgroundOverlayColor` (default: .black): The background overlay color of the controls.

> Inspired by [Ehsan Rahimi](https://dribbble.com/ehsancinematic) Tally Counter Micro-Interaction concept.
<img src="https://github.com/Wsewlad/TallyCounter/blob/main/dribbble.gif" width="500px">

## License
```
MIT License

Copyright (c) 2023 Vladyslav Fil

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
