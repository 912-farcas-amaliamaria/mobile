package com.example.lab4server.service;

import com.example.lab4server.domain.Expense;
import com.example.lab4server.repository.ExpenseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ExpenseService {

    private final ExpenseRepository repo;

    @Autowired
    public ExpenseService(ExpenseRepository repo) {
        this.repo = repo;
    }

    public void addExpense(Expense expense){
        repo.save(expense);
    }

    public List<Expense> getAll(){
        return repo.findAll();
    }

    public void deleteExpense(Expense expense){
        if(repo.existsById(expense.getId())) {
            repo.delete(expense);

        } else {
            throw new RuntimeException("No such expense");
        }
    }

    public void updateExpense(Expense expense){
        if(repo.existsById(expense.getId())) {
            repo.save(expense);
        } else {
            throw new RuntimeException("No such expense");
        }
    }
}
