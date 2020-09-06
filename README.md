<img src="EndgameCore.png" width="120" height="120"/>

# EndgameCore

EndgameCore is a pure Swift chess library. The goal of this library is to make writing chess application as easy as possible. As of now the library supports PGN parsing and move generation.


#### Warning: This project is currently in development and is subject to changes!

## Features:

* [x] PGN Decoding
* [ ] PGN Encoding
* [x] FEN Decoding
* [ ] FEN Encoding


## Install with Swift Packages

If you are using Xcode 11 or later:

1. On an Xcode project click File
2. Swift Packages
3. Add Package Dependency
4. Specify the git URL for for EndgameCore ```https://github.com/Jelizondo/EndgameCore```.

## Usage:

Decoding from a file:

```Swift
let pgn = PGNDecoder().decode(fileName: "file.pgn", bundle: .main)
```
Decoding from a string:
```Swift
let pgn = PGNDecoder().decode(rawValue: PGNRaw)
```

Initialize a game from a pgn:

```Swift
guard let game = Game(pgn: pgn) else {
  // Unable to create game from pgn
}
```
