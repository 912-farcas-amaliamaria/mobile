package com.example.lab4server.controller;

import com.example.lab4server.domain.Expense;
import com.example.lab4server.service.ExpenseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping(path = "/api/expense")
public class ExpenseController {
    private final ExpenseService service;

    @Autowired
    public ExpenseController(ExpenseService service) {
        this.service = service;
    }

    @PostMapping(value = "/add")
    public ResponseEntity<?> addExpense(@RequestBody final Expense expense){
        try {
            this.service.addExpense(expense);
        } catch (Exception e){
            return ResponseEntity.accepted().body(e.getMessage());
        }
        return ResponseEntity.ok().build();
    }

    @GetMapping(value="/all")
    public ResponseEntity<?> getAll(){
        System.out.println("all");
        try {
            return ResponseEntity.ok().body(service.getAll());
        } catch (Exception e){
            return ResponseEntity.accepted().body(e.getMessage());
        }

    }

    @PostMapping(value = "/update")
    public ResponseEntity<?> updateExpense(@RequestBody final Expense expense){
        try {
            this.service.updateExpense(expense);
        } catch (Exception e){
            return ResponseEntity.accepted().body(e.getMessage());
        }
        return ResponseEntity.ok().build();
    }

    @PostMapping(value = "/delete")
    public ResponseEntity<?> deleteExpense(@RequestBody final Expense expense){
        try {
            this.service.deleteExpense(expense);
        } catch (Exception e){
            return ResponseEntity.accepted().body(e.getMessage());
        }
        return ResponseEntity.ok().build();
    }
}