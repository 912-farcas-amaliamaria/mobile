package com.example.manageexpenses

import java.io.Serializable
import java.time.LocalDate

data class Expense (val name : String,
                    val category : Category = Category.OTHERS,
                    val amount: Int = 0,
                    val currency : Currency = Currency.EUR,
                    val description : String,
                    val date : LocalDate = LocalDate.now()) : Serializable