package com.example.lab4server.repository;

import com.example.lab4server.domain.Expense;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

public interface ExpenseRepository extends JpaRepository<Expense, Integer> {
}
