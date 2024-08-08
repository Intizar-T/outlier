import Foundation

enum Suit: String {
    case hearts = "Hearts"
    case diamonds = "Diamonds"
    case clubs = "Clubs"
    case spades = "Spades"
}

enum Rank: Int {
    case two = 2, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king, ace
}

struct Card {
    let suit: Suit
    let rank: Rank
}

class Deck {
    private var cards: [Card] = []

    init() {
        for suit in [Suit.hearts, .diamonds, .clubs, .spades] {
            for rankValue in 2...14 {
                if let rank = Rank(rawValue: rankValue) {
                    cards.append(Card(suit: suit, rank: rank))
                }
            }
        }
        shuffle()
    }

    func shuffle() {
        cards.shuffle()
    }

    func deal() -> Card? {
        return cards.popLast()
    }
}

class Hand {
    private var cards: [Card] = []

    func addCard(_ card: Card) {
        cards.append(card)
    }

    func score() -> Int {
        var total = 0
        var aces = 0

        for card in cards {
            switch card.rank {
            case .ace:
                aces += 1
                total += 11
            case .jack, .queen, .king:
                total += 10
            default:
                total += card.rank.rawValue
            }
        }

        while total > 21 && aces > 0 {
            total -= 10
            aces -= 1
        }

        return total
    }

    func isBusted() -> Bool {
        return score() > 21
    }
}

class BlackjackGame {
    private var deck: Deck
    private var playerHand: Hand
    private var dealerHand: Hand

    init() {
        deck = Deck()
        playerHand = Hand()
        dealerHand = Hand()
        startGame()
    }

    private func startGame() {
        playerHand.addCard(deck.deal()!)
        playerHand.addCard(deck.deal()!)
        dealerHand.addCard(deck.deal()!)
        dealerHand.addCard(deck.deal()!)
    }

    func playerHit() {
        if let card = deck.deal() {
            playerHand.addCard(card)
        }
    }

    func playerStand() {
        while dealerHand.score() < 17 {
            if let card = deck.deal() {
                dealerHand.addCard(card)
            }
        }
    }

    func playerScore() -> Int {
        return playerHand.score()
    }

    func dealerScore() -> Int {
        return dealerHand.score()
    }

    func isPlayerBusted() -> Bool {
        return playerHand.isBusted()
    }

    func isDealerBusted() -> Bool {
        return dealerHand.isBusted()
    }

    func determineWinner() -> String {
        if isPlayerBusted() {
            return "Dealer wins!"
        } else if isDealerBusted() {
            return "Player wins!"
        } else if playerScore() > dealerScore() {
            return "Player wins!"
        } else if playerScore() < dealerScore() {
            return "Dealer wins!"
        } else {
            return "It's a tie!"
        }
    }
}