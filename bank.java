import java.util.*;
import java.time.LocalDate;

abstract class Account {
    protected String accountNumber;
    protected double balance;
    protected List<String> transactionHistory;
    protected LocalDate lastInterestDate;

    public Account(String accountNumber) {
        this.accountNumber = accountNumber;
        this.balance = 0.0;
        this.transactionHistory = new ArrayList<>();
        this.lastInterestDate = LocalDate.now();
    }

    public String getAccountNumber() {
        return accountNumber;
    }

    public double getBalance() {
        return balance;
    }

    public void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
            transactionHistory.add("Deposited: " + amount);
        }
    }

    public abstract boolean withdraw(double amount);

    public List<String> getTransactionHistory() {
        return transactionHistory;
    }

    public abstract void endOfMonth();
}

class CheckingAccount extends Account {
    private double overdraftLimit;

    public CheckingAccount(String accountNumber, double overdraftLimit) {
        super(accountNumber);
        this.overdraftLimit = overdraftLimit;
    }

    @Override
    public boolean withdraw(double amount) {
        if (amount > 0 && balance + overdraftLimit >= amount) {
            balance -= amount;
            transactionHistory.add("Withdrawn: " + amount);
            if (balance < 0) {
                transactionHistory.add("Overdraft used: " + Math.abs(balance));
            }
            return true;
        }
        return false;
    }

    @Override
    public void endOfMonth() {
        // No interest applied for Checking Account
    }
}

class SavingsAccount extends Account {
    private double interestRate;

    public SavingsAccount(String accountNumber, double interestRate) {
        super(accountNumber);
        this.interestRate = interestRate;
    }

    @Override
    public boolean withdraw(double amount) {
        if (amount > 0 && balance >= amount) {
            balance -= amount;
            transactionHistory.add("Withdrawn: " + amount);
            return true;
        }
        return false;
    }

    @Override
    public void endOfMonth() {
        LocalDate currentDate = LocalDate.now();
        if (currentDate.getMonthValue() != lastInterestDate.getMonthValue() || 
            currentDate.getYear() != lastInterestDate.getYear()) {
            double interest = balance * (interestRate / 12); // Monthly interest
            balance += interest;
            transactionHistory.add("Interest: " + interest);
            lastInterestDate = currentDate;
        }
    }
}

class User {
    private String username;
    private String password;
    private List<Account> accounts;

    public User(String username, String password) {
        this.username = username;
        this.password = password;
        this.accounts = new ArrayList<>();
    }

    public String getUsername() {
        return username;
    }

    public boolean checkPassword(String password) {
        return this.password.equals(password);
    }

    public void addAccount(Account account) {
        accounts.add(account);
    }

    public Account getAccount(String accountNumber) {
        for (Account account : accounts) {
            if (account.getAccountNumber().equals(accountNumber)) {
                return account;
            }
        }
        return null;
    }

    public List<Account> getAccounts() {
        return accounts;
    }

    public double getTotalBalance() {
        double total = 0.0;
        for (Account account : accounts) {
            total += account.getBalance();
        }
        return total;
    }

    public boolean transfer(String fromAccountNumber, String toAccountNumber, double amount) {
        Account fromAccount = getAccount(fromAccountNumber);
        Account toAccount = getAccount(toAccountNumber);

        if (fromAccount != null && toAccount != null) {
            if (fromAccount.withdraw(amount)) {
                toAccount.deposit(amount);
                return true;
            }
        }
        return false;
    }
}

class Bank {
    private Map<String, User> users;

    public Bank() {
        this.users = new HashMap<>();
    }

    public void addUser(String username, String password) {
        users.put(username, new User(username, password));
    }

    public User login(String username, String password) {
        User user = users.get(username);
        if (user != null && user.checkPassword(password)) {
            return user;
        }
        return null;
    }
}

public class Main {
    public static void main(String[] args) {
        Bank bank = new Bank();
        bank.addUser("user1", "pass1");

        User user1 = bank.login("user1", "pass1");
        if (user1 != null) {
            user1.addAccount(new CheckingAccount("123456", 500));
            user1.addAccount(new SavingsAccount("789101", 0.01)); // 1% annual interest

            Account checkingAccount = user1.getAccount("123456");
            checkingAccount.deposit(500);
            System.out.println("Checking Account balance: " + checkingAccount.getBalance());

            checkingAccount.withdraw(200);
            System.out.println("Checking Account balance after withdrawal: " + checkingAccount.getBalance());

            Account savingsAccount = user1.getAccount("789101");
            savingsAccount.deposit(1000);
            System.out.println("Savings Account balance: " + savingsAccount.getBalance());

            user1.transfer("789101", "123456", 500);
            System.out.println("Checking Account balance after transfer: " + checkingAccount.getBalance());
            System.out.println("Savings Account balance after transfer: " + savingsAccount.getBalance());

            System.out.println("Total balance: " + user1.getTotalBalance());

            // End of month interest
            for (Account account : user1.getAccounts()) {
                account.endOfMonth();
            }

            System.out.println("Total balance after end of month: " + user1.getTotalBalance());
        } else {
            System.out.println("Login failed");
        }
    }
}
