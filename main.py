def sieve_of_eratosthenes(n):
    """
    Find all prime numbers up to n using the Sieve of Eratosthenes algorithm.

    Parameters:
    n (int): The upper limit (inclusive) to find prime numbers.

    Returns:
    list: A list of prime numbers up to n.
    """
    if n < 2:
        return []

    # Initialize a list to track prime status of numbers from 0 to n
    is_prime = [True] * (n + 1)
    is_prime[0] = is_prime[1] = False  # 0 and 1 are not prime numbers

    # Start with the first prime number, which is 2
    p = 2
    while p * p <= n:
        # If is_prime[p] is still True, then it is a prime
        if is_prime[p]:
            # Mark all multiples of p as not prime
            for multiple in range(p * p, n + 1, p):
                is_prime[multiple] = False
        p += 1

    # Collect all prime numbers
    primes = [num for num, prime in enumerate(is_prime) if prime]
    return primes

# Example usage:
n = 31
print(f"Prime numbers up to {n}: {sieve_of_eratosthenes(n)}")