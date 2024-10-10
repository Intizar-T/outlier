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

    public abstract void applyMonthlyInterest();
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
                transactionHistory.add("Overdraft protection used: " + Math.abs(balance));
            }
            return true;
        }
        return false;
    }

    @Override
    public void applyMonthlyInterest() {
        // Checking accounts typically don't earn interest
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
    public void applyMonthlyInterest() {
        LocalDate currentDate = LocalDate.now();
        if (currentDate.getMonthValue() != lastInterestDate.getMonthValue() || 
            currentDate.getYear() != lastInterestDate.getYear()) {
            double interest = balance * (interestRate / 12);
            balance += interest;
            transactionHistory.add("Monthly interest applied: " + interest);
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

    public void applyMonthlyInterestToAllAccounts() {
        for (Account account : accounts) {
            account.applyMonthlyInterest();
        }
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

    public void applyMonthlyInterestForAllUsers() {
        for (User user : users.values()) {
            user.applyMonthlyInterestToAllAccounts();
        }
    }
}

public class Main {
    public static void main(String[] args) {
        Bank bank = new Bank();
        bank.addUser("user1", "pass1");

        User user1 = bank.login("user1", "pass1");
        if (user1 != null) {
            user1.addAccount(new CheckingAccount("123456", 500));
            user1.addAccount(new SavingsAccount("789101", 0.05)); // 5% annual interest rate

            Account checkingAccount = user1.getAccount("123456");
            Account savingsAccount = user1.getAccount("789101");

            checkingAccount.deposit(1000);
            savingsAccount.deposit(2000);

            System.out.println("Checking balance: " + checkingAccount.getBalance());
            System.out.println("Savings balance: " + savingsAccount.getBalance());

            checkingAccount.withdraw(1200);
            savingsAccount.withdraw(500);

            System.out.println("Checking balance after withdrawal: " + checkingAccount.getBalance());
            System.out.println("Savings balance after withdrawal: " + savingsAccount.getBalance());

            // Simulate passing of a month
            bank.applyMonthlyInterestForAllUsers();

            System.out.println("Checking balance after a month: " + checkingAccount.getBalance());
            System.out.println("Savings balance after a month: " + savingsAccount.getBalance());

            System.out.println("Checking transaction history:");
            for (String transaction : checkingAccount.getTransactionHistory()) {
                System.out.println(transaction);
            }

            System.out.println("Savings transaction history:");
            for (String transaction : savingsAccount.getTransactionHistory()) {
                System.out.println(transaction);
            }

            System.out.println("Total balance: " + user1.getTotalBalance());
        } else {
            System.out.println("Login failed");
        }
    }
}