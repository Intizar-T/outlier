func sieveOfEratosthenes(_ n: Int) -> [Int] {
    // Handle edge cases
    guard n >= 2 else {
        return []
    }

    // Initialize the boolean array to keep track of prime numbers
    var isPrime = [Bool](repeating: true, count: n + 1)
    isPrime[0] = false
    isPrime[1] = false

    // Implement the Sieve of Eratosthenes algorithm
    for i in 2...Int(Double(n).squareRoot()) {
        if isPrime[i] {
            for j in stride(from: i * i, through: n, by: i) {
                isPrime[j] = false
            }
        }
    }

    // Collect all prime numbers
    return (2...n).compactMap { isPrime[$0] ? $0 : nil }
}

// Example usage
print(sieveOfEratosthenes(2))