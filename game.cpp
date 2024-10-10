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
    int specialCharge;

    Character(std::string n, int h, int s, int ap, int dp)
        : name(n), maxHealth(h), health(h), maxStamina(s), stamina(s), attackPower(ap), defensePower(dp), specialCharge(0) {}

    bool isAlive() const {
        return health > 0;
    }

    void attack(Character& target) {
        if (stamina >= 10) {
            int damage = attackPower - target.defensePower;
            if (specialCharge == 100) {
                damage *= 2;
                specialCharge = 0;
                std::cout << name << " uses a special attack!\n";
            }
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

    void chargeSpecial() {
        if (specialCharge < 100) {
            specialCharge += 20;
            if (specialCharge > 100) {
                specialCharge = 100;
            }
            std::cout << name << " charges special attack to " << specialCharge << "%!\n";
        } else {
            std::cout << name << "'s special attack is already fully charged!\n";
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
                  << ", Stamina: " << stamina << "/" << maxStamina
                  << ", Special Charge: " << specialCharge << "%\n";
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
        std::cout << "1. Attack\n2. Defend\n3. Heal\n4. Charge Special Attack\n5. Use Special Attack\nChoice: ";
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
        case 4:
            player.chargeSpecial();
            break;
        case 5:
            if (player.specialCharge == 100) {
                player.attack(enemy);
            } else {
                std::cout << "Special attack is not fully charged! Skipping turn.\n";
            }
            break;
        default:
            std::cout << "Invalid choice! Skipping turn.\n";
            break;
        }
        player.regainStamina();
    }

    void enemyTurn() {
        std::cout << "\nEnemy's Turn!\n";
        int action = std::rand() % 3; // 0 = attack, 1 = defend, 2 = charge special

        if (action == 0) {
            enemy.attack(player);
        } else if (action == 1) {
            enemy.defend();
        } else {
            enemy.chargeSpecial();
        }
        enemy.regainStamina();
    }
};

#include <cassert>
#include <sstream>
#include <iostream>

// Assuming the Combat and Character classes are defined above this code

void testCombatWithAllActions() {
    // Redirect cout to our stringstream
    std::stringstream output;
    std::streambuf* oldCout = std::cout.rdbuf(output.rdbuf());

    // Create characters for the test
    Character player("TestPlayer", 100, 50, 20, 10);
    Character enemy("TestEnemy", 100, 50, 15, 8);

    // Create combat instance
    Combat combat(player, enemy);

    // Simulate player inputs
    std::stringstream input;
    input << "4\n" // Charge Special Attack
          << "4\n" // Charge Special Attack
          << "4\n" // Charge Special Attack
          << "4\n" // Charge Special Attack
          << "4\n" // Charge Special Attack
          << "5\n" // Use Special Attack
          << "2\n" // Defend
          << "3\n" // Heal
          << "1\n"; // Normal Attack

    // Redirect cin to our input stringstream
    std::streambuf* oldCin = std::cin.rdbuf(input.rdbuf());

    // Start the combat
    combat.startCombat();

    // Restore the original cin and cout
    std::cin.rdbuf(oldCin);
    std::cout.rdbuf(oldCout);

    // Get the output as a string
    std::string outputStr = output.str();

    // Assertions to check if all actions were performed correctly
    assert(outputStr.find("TestPlayer charges special attack to 20%!") != std::string::npos);
    assert(outputStr.find("TestPlayer charges special attack to 40%!") != std::string::npos);
    assert(outputStr.find("TestPlayer charges special attack to 60%!") != std::string::npos);
    assert(outputStr.find("TestPlayer charges special attack to 80%!") != std::string::npos);
    assert(outputStr.find("TestPlayer charges special attack to 100%!") != std::string::npos);
    assert(outputStr.find("TestPlayer uses a special attack!") != std::string::npos);
    assert(outputStr.find("TestPlayer is defending, reducing damage for the next attack!") != std::string::npos);
    assert(outputStr.find("TestPlayer heals for 20 health!") != std::string::npos);
    assert(outputStr.find("TestPlayer attacks TestEnemy for") != std::string::npos);

    std::cout << "All actions test passed successfully!" << std::endl;
}

int main() {
    testCombatWithAllActions();
    return 0;
}