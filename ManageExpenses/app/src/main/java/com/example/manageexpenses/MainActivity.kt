package com.example.manageexpenses

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import androidx.activity.ComponentActivity
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import java.time.LocalDate

class MainActivity : ComponentActivity() {
    private lateinit var expenseAdapter : ExpenseAdapter
    private val REQUEST_CODE_ADD = 123
    private val REQUEST_CODE_UPDATE = 321

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main_activity);
        val rvExpenseItems = findViewById<RecyclerView>(R.id.rvExpenseItems)

        val expense = Expense(name = "exp", amount = 58, description = "apoa fgre gregfr gfreujgreg")
        val list = mutableListOf<Expense>()
/*        list.add(expense)
        list.add(expense)
        list.add(expense)
        list.add(expense)
        list.add(expense)
        list.add(expense)
        list.add(expense)
        list.add(expense)*/
        val expense2 = Expense(name = "exp2", amount = 58, description = "apoa fgre gregfr gfreujgreg", date = LocalDate.of(2023, 2, 2))

        list.add(expense2)
        val expense3 = Expense(name = "exp3", amount = 58, description = "apoa fgre gregfr gfreujgreg", date = LocalDate.of(2023, 2, 2))

        list.add(expense3)

        list.sortByDescending { expense: Expense -> expense.date }
        expenseAdapter = ExpenseAdapter(list)

        rvExpenseItems.adapter = expenseAdapter
        rvExpenseItems.layoutManager = LinearLayoutManager(this)

        val btnAddExpense = findViewById<Button>(R.id.btnAddExpense)
        btnAddExpense.setOnClickListener {
            val intent = Intent(this, AddExpenseActivity::class.java)
            //intent.putExtra("expense", expense)
            startActivityForResult(intent, REQUEST_CODE_ADD)
        }
    }

    @Deprecated("Deprecated in Java")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == REQUEST_CODE_ADD && resultCode == RESULT_OK && data != null) {
            val receivedExpense = data.getSerializableExtra("expense") as? Expense
            if (receivedExpense != null) {
                expenseAdapter.addExpense(receivedExpense)
            }
        }

        if (requestCode == REQUEST_CODE_UPDATE && resultCode == RESULT_OK && data != null) {
            val receivedNewExpense = data.getSerializableExtra("new_expense") as? Expense
            val receivedExpense = data.getSerializableExtra("expense") as? Expense
            if (receivedExpense != null && receivedNewExpense != null) {
                expenseAdapter.updateExpense(receivedExpense, receivedNewExpense)
            }
        }

    }
}

/*
@Composable
fun Greeting(name: String, modifier: Modifier = Modifier) {
    Text(
            text = "Hello $name!",
            modifier = modifier
    )
}

@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    ManageExpensesTheme {
        Greeting("Android")
    }
}*/
