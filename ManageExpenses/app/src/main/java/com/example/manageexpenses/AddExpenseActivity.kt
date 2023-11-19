package com.example.manageexpenses

import android.app.DatePickerDialog
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.Button
import android.widget.EditText
import android.widget.Spinner
import android.widget.TextView
import android.widget.Toast
import java.time.LocalDate
import java.util.Calendar

class AddExpenseActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.item_expense)

        val spinnerCategory = findViewById<Spinner>(R.id.sNewCategory)
        val categories = Category.values() // Get all values from the Enum
        val adapter = ArrayAdapter(this, android.R.layout.simple_spinner_item, categories)
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        spinnerCategory.adapter = adapter

        var selectedCategory = categories[0]
        spinnerCategory.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
                selectedCategory = categories[position]
                // Do something with the selected category (e.g., store it in a variable)
            }

            override fun onNothingSelected(parent: AdapterView<*>?) {
                selectedCategory = categories[0]
            }
        }

        val spinnerCurrency = findViewById<Spinner>(R.id.atvNewCurrency)
        val currencies = Currency.values() // Get all values from the Enum
        val adapterC = ArrayAdapter(this, android.R.layout.simple_spinner_item, currencies)
        adapterC.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        spinnerCurrency.adapter = adapterC

        var selectedCurrency = currencies[0]
        spinnerCurrency.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
                selectedCurrency = currencies[position]
                // Do something with the selected category (e.g., store it in a variable)
            }

            override fun onNothingSelected(parent: AdapterView<*>?) {
                selectedCurrency = currencies[0]
            }
        }

        val etNewDate = findViewById<EditText>(R.id.etNewDate)
        val calendar = Calendar.getInstance()
        var selectedDate = LocalDate.now()
        etNewDate.setOnClickListener {
            val year = calendar.get(Calendar.YEAR)
            val month = calendar.get(Calendar.MONTH)
            val day = calendar.get(Calendar.DAY_OF_MONTH)

            val datePickerDialog = DatePickerDialog(this, { view, year, monthOfYear, dayOfMonth ->
                val selectedDate = LocalDate.of(year, monthOfYear + 1, dayOfMonth)
                if (selectedDate.isAfter(LocalDate.now())) {
                    // Prevent selecting a future date, show an error message or handle it as needed
                    // For example, you can show a Toast message:
                    Toast.makeText(this, "Please select a date in the past or today", Toast.LENGTH_SHORT).show()
                } else {
                    // Handle the selected date
                    etNewDate.setText(selectedDate.toString())
                }
            }, year, month, day)

            // Set the maximum date to today
            datePickerDialog.datePicker.maxDate = System.currentTimeMillis()

            datePickerDialog.show()
        }

        val btnNewAdd = findViewById<Button>(R.id.btnNewAdd)
        btnNewAdd.setOnClickListener {

            val etNewName = findViewById<TextView>(R.id.etNewName)
            val name = etNewName.text.toString()

            /*val atvNewCategory = findViewById<TextView>(R.id.atvNewCategory)
            val category = (Category) atvNewCategory.text*/

            val etNewAmount = findViewById<TextView>(R.id.etNewAmount)
            val amount = etNewAmount.text.toString().toIntOrNull() ?: 0

            val etNewDescription = findViewById<TextView>(R.id.etNewDescription)
            val description = etNewDescription.text.toString()

            if (name.isNotBlank() && amount != 0) {
                val expense = Expense(name, selectedCategory, amount, selectedCurrency, description, selectedDate)
                val intent = Intent()
                intent.putExtra("expense", expense)
                setResult(RESULT_OK, intent)
                finish()
            }

        }

        val btnNewCancel = findViewById<Button>(R.id.btnNewCancel)

        btnNewCancel.setOnClickListener {
            finish()
        }
    }
}