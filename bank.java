import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

class Transaction {
    private String type;
    private double amount;
    private String timestamp;

    public Transaction(String type, double amount) {
        this.type = type;
        this.amount = amount;
        this.timestamp = java.time.LocalDateTime.now().toString();
    }

    @Override
    public String toString() {
        return String.format("%s: %s %.2f", timestamp, type, amount);
    }
}

class Account {
    private String accountNumber;
    private double balance;
    private List<Transaction> transactions;

    public Account(String accountNumber) {
        this.accountNumber = accountNumber;
        this.balance = 0.0;
        this.transactions = new ArrayList<>();
    }

    public String getAccountNumber() {
        return accountNumber;
    }

    public double getBalance() {
        return balance;
    }

    public void deposit(double amount) {
        balance += amount;
        transactions.add(new Transaction("Deposit", amount));
    }

    public boolean withdraw(double amount) {
        if (balance >= amount) {
            balance -= amount;
            transactions.add(new Transaction("Withdrawal", amount));
            return true;
        }
        return false;
    }

    public List<Transaction> getTransactionHistory() {
        return new ArrayList<>(transactions);
    }
}

class User {
    private String name;
    private Map<String, Account> accounts;

    public User(String name) {
        this.name = name;
        this.accounts = new HashMap<>();
    }

    public void addAccount(String accountNumber) {
        accounts.put(accountNumber, new Account(accountNumber));
    }

    public boolean deposit(String accountNumber, double amount) {
        Account account = accounts.get(accountNumber);
        if (account != null) {
            account.deposit(amount);
            return true;
        }
        return false;
    }

    public boolean withdraw(String accountNumber, double amount) {
        Account account = accounts.get(accountNumber);
        if (account != null) {
            return account.withdraw(amount);
        }
        return false;
    }

    public boolean transfer(String fromAccountNumber, String toAccountNumber, double amount) {
        Account fromAccount = accounts.get(fromAccountNumber);
        Account toAccount = accounts.get(toAccountNumber);
        if (fromAccount != null && toAccount != null && fromAccount.withdraw(amount)) {
            toAccount.deposit(amount);
            return true;
        }
        return false;
    }

    public double getBalance(String accountNumber) {
        Account account = accounts.get(accountNumber);
        return account != null ? account.getBalance() : -1;
    }

    public List<Transaction> getTransactionHistory(String accountNumber) {
        Account account = accounts.get(accountNumber);
        return account != null ? account.getTransactionHistory() : new ArrayList<>();
    }
}

public class BankingSystem {
    public static void main(String[] args) {
        User user = new User("John Doe");

        user.addAccount("1001");
        user.addAccount("1002");

        user.deposit("1001", 1000);
        user.deposit("1002", 500);

        System.out.println("Account 1001 balance: " + user.getBalance("1001"));
        System.out.println("Account 1002 balance: " + user.getBalance("1002"));

        user.withdraw("1001", 200);
        user.transfer("1002", "1001", 300);

        System.out.println("Account 1001 balance: " + user.getBalance("1001"));
        System.out.println("Account 1002 balance: " + user.getBalance("1002"));

        System.out.println("Transaction history for account 1001:");
        for (Transaction transaction : user.getTransactionHistory("1001")) {
            System.out.println(transaction);
        }
    }
}