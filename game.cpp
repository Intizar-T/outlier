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

int main() {
    Character player("Player", 100, 50, 20, 10);
    Character enemy("Enemy", 80, 40, 15, 8);

    Combat combat(player, enemy);
    combat.startCombat();

    return 0;
}
