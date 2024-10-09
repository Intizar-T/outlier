#include <iostream>
#include <cstdlib>
#include <ctime>
#include <cassert>

class Character {
public:
    std::string name;
    int health;
    int maxHealth;
    int stamina;
    int maxStamina;
    int attackPower;
    int defensePower;

    Character(std::string n, int h, int s, int ap, int dp)
        : name(n), maxHealth(h), health(h), maxStamina(s), stamina(s), attackPower(ap), defensePower(dp) {}

    bool isAlive() const {
        return health > 0;
    }

    void attack(Character& target) {
        if (stamina >= 10) {
            int damage = attackPower - target.defensePower;
            if (damage > 0) {
                target.health -= damage;
                std::cout << name << " attacks " << target.name << " for " << damage << " damage!\n";
            } else {
                std::cout << name << "'s attack was too weak to damage " << target.name << "!\n";
            }
            stamina -= 10;
        } else {
            std::cout << name << " doesn't have enough stamina to attack!\n";
        }
    }

    void defend() {
        std::cout << name << " is defending, reducing damage for the next attack!\n";
        defensePower += 5; // Temporarily increase defense
    }

    void heal() {
        if (stamina >= 15) {
            int healAmount = maxHealth / 5;
            health += healAmount;
            if (health > maxHealth) {
                health = maxHealth;
            }
            stamina -= 15;
            std::cout << name << " heals for " << healAmount << " health!\n";
        } else {
            std::cout << name << " doesn't have enough stamina to heal!\n";
        }
    }

    void regainStamina() {
        stamina += 5;
        if (stamina > maxStamina) {
            stamina = maxStamina;
        }
    }

    void resetDefense() {
        defensePower -= 5; // Reset defense after the defending turn
    }

    void status() const {
        std::cout << name << " | Health: " << health << "/" << maxHealth
                  << ", Stamina: " << stamina << "/" << maxStamina << "\n";
    }
};

class Combat {
public:
    Combat(Character& p, Character& e) : player(p), enemy(e) {}

    void startCombat() {
        std::srand(static_cast<unsigned int>(std::time(0)));
        while (player.isAlive() && enemy.isAlive()) {
            std::cout << "\n--- New Turn ---\n";
            player.status();
            enemy.status();

            playerTurn();
            if (!enemy.isAlive()) break;

            enemyTurn();
            player.resetDefense();
            enemy.resetDefense();
        }

        if (player.isAlive()) {
            std::cout << player.name << " has defeated " << enemy.name << "!\n";
        } else {
            std::cout << enemy.name << " has defeated " << player.name << "!\n";
        }
    }

private:
    Character& player;
    Character& enemy;

    void playerTurn() {
        int choice;
        std::cout << "\nPlayer's Turn! Choose action:\n";
        std::cout << "1. Attack\n2. Defend\n3. Heal\nChoice: ";
        std::cin >> choice;

        switch (choice) {
        case 1:
            player.attack(enemy);
            break;
        case 2:
            player.defend();
            break;
        case 3:
            player.heal();
            break;
        default:
            std::cout << "Invalid choice! Skipping turn.\n";
            break;
        }
        player.regainStamina();
    }

    void enemyTurn() {
        std::cout << "\nEnemy's Turn!\n";
        int action = std::rand() % 2; // 0 = attack, 1 = defend

        if (action == 0) {
            enemy.attack(player);
        } else {
            enemy.defend();
        }
        enemy.regainStamina();
    }
};

#include <iostream>
#include <sstream>
#include <string>

// Include the original code here for testing

// Redirect std::cin and std::cout for automated testing
std::istringstream testInput;
std::ostringstream testOutput;
std::streambuf *cinBackup, *coutBackup;

void setInput(const std::string &input) {
    testInput.str(input);
    cinBackup = std::cin.rdbuf();
    std::cin.rdbuf(testInput.rdbuf());
}

void clearOutput() {
    testOutput.str("");
}

std::string getOutput() {
    return testOutput.str();
}

void restoreStreams() {
    std::cin.rdbuf(cinBackup);
    std::cout.rdbuf(coutBackup);
}

int main() {
    // Redirect cout for testing
    coutBackup = std::cout.rdbuf();
    std::cout.rdbuf(testOutput.rdbuf());

    // Test 1: Player attacks and enemy takes damage
    {
        Character player("Player", 100, 50, 20, 10);
        Character enemy("Enemy", 80, 40, 15, 8);

        player.attack(enemy);

        assert(enemy.health == 70);
        assert(player.stamina == 40);
        assert(getOutput() == "Player attacks Enemy for 10 damage!\n");
        clearOutput();
    }

    // Test 2: Player defends and defense increases temporarily
    {
        Character player("Player", 100, 50, 20, 10);
        player.defend();

        assert(player.defensePower == 15);
        assert(getOutput() == "Player is defending, reducing damage for the next attack!\n");
        clearOutput();
    }

    // Test 3: Player heals and health increases
    {
        Character player("Player", 100, 50, 20, 10);
        player.stamina = 20; // Ensure player has enough stamina to heal
        player.health = 50;
        player.heal();

        assert(player.health == 70);
        assert(player.stamina == 5);
        assert(getOutput() == "Player heals for 20 health!\n");
        clearOutput();
    }

    // Test 4: Enemy defends and defense increases temporarily
    {
        Character enemy("Enemy", 80, 40, 15, 8);
        enemy.defend();

        assert(enemy.defensePower == 13);
        assert(getOutput() == "Enemy is defending, reducing damage for the next attack!\n");
        clearOutput();
    }

    // Test 5: Combat ends when one character is defeated
    {
        Character player("Player", 100, 50, 20, 10);
        Character enemy("Enemy", 1, 40, 15, 8);

        Combat combat(player, enemy);

        setInput("1\n");
        combat.startCombat();

        assert(getOutput().find("Player has defeated Enemy!") != std::string::npos);
        clearOutput();
        restoreStreams();
    }

    // Test 6: Combat ends when player is defeated
    {
        Character player("Player", 1, 50, 20, 10);
        Character enemy("Enemy", 80, 40, 15, 8);

        Combat combat(player, enemy);

        setInput("1\n");
        combat.startCombat();

        assert(getOutput().find("Enemy has defeated Player!") != std::string::npos);
        clearOutput();
        restoreStreams();
    }

    std::cout << "All tests passed!\n";
    return 0;
}
