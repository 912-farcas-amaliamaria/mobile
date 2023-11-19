package com.example.lab4server.domain;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "expenses")
public class Expense {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    int id;
    String name;
    String category;
    double amount;
    String currency;
    LocalDate date;
    String description;

    public Expense(String name, String category, double amount, String currency, LocalDate date, String description) {
        this.name = name;
        this.category = category;
        this.amount = amount;
        this.currency = currency;
        this.date = date;
        this.description = description;
    }
}
