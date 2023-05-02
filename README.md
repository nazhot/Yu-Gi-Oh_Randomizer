<p align="center">
  <a href="https://noahzydel.com">
    <img alt="Noah Logo" height="128" src="./.github/resources/NoahLogo.svg">
    <h1 align="center">Noah Zydel</h1>
  </a>
</p>

---

- [📖 Overview](#-overview)
- [⭐️ Current Version](#-current-version)
- [🔜 Hopeful Features](#-hopeful-features)
- [🪚 Built With](#-built-with)
- [🔨 Build Instructions](#-build-instructions)

# Yu-Gi-Oh Randomizer
A Yu-Gi-Oh tool aimed at allowing you to look at cards within a format in a very user friendly way, as well as generating fully random decks based on your chosen parameters.
<p align="center">
<img src="./.github/resources/full-calendar-example.png">
</p>

## 📖 Overview
This Processing program was made after a friend and I began getting into the trading card game Yu-Gi-Oh, but wanted to work with older cards. There are many older formats available to play within Yu-Gi-Oh, but the most popular of these have most of the meta discovery already completed. We wanted something that we would have to figure out on our own, and so we ended up playing the game with cards allowed in the GameBoy game [Stairway to the Destined Duel](https://yugioh.fandom.com/wiki/Yu-Gi-Oh!_Worldwide_Edition:_Stairway_to_the_Destined_Duel). This worked great for getting a card/ban list that wasn't mostly figured out yet, but lead to the issue of being the only 2 people trying to use this specific list to deck build. That's where this program was born.

The initial need that had to be addressed was the difficulty in viewing cards within this format. All we had were websites that had the card list in an all text table, with hyperlinks to be able to view cards and their descriptions. Using card data from the [YGoProDeck Api](https://ygoprodeck.com/api-guide/), I created a program that would allow you to filter by monster type/attribute, as well as by format and ban list. Running it would give you a multi-page image grid of all of the matching cards, allowing you to look at a glance for their stats/descriptions.

As our needs evolved, we also wanted the option for decks to be generated for us, to allow for less competitive duels, and to see how well we could just make things work. With that, I expanded the program to let you set parameters such as the number of spells/traps/monsters, how often a type of card should try and fill as many copies of itself as possible, and atk/def limits. Running the randomizer generates deck(s) for you (depending on how many you told it to), and takes you to a screen where you can look at all of the card images for each deck to take your pick. It would also download all of the ydk's so that you can duel in your favorite online simulator.

## ⭐️ Current Version
v0.0.1
- Multiple parameters for filtering card viewing/deck randomizing (* represents parameters that affect both)
  - Monster type(s)*
  - Monster attributes(s)*
  - Format*
  - Ban List*
  - Mult. trap/spell/monster percentage (how much you want the program to try and add multiples of the chosen card)
  - Trap/spell/monster count
  - Atk/def >, >=, =, <, <= value*
  - Number of decks
- Card images viewer
- Randomizer

## Previous Versions
N/A

## 🔜 Hopeful Features
- Allow a slider for the amount of randomness, based on a matrix of decks
- Allow user to create/choose from a list of set cards, that will appear in every deck
  
## 🪚 Built With
- Processing
- SimpleGUI (my java library for programming GUIs)

## 🔨 Build Instructions
If not already install, download and install Processing from https://processing.org/download.

After forking and cloning, navigate to the repository, and open up and of the .pde files. Clicking the Run button in the top left corner will run the program.