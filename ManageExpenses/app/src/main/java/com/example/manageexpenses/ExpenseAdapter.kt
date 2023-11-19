package com.example.manageexpenses

import android.app.Activity
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageButton
import android.widget.LinearLayout
import android.widget.TextView
import androidx.core.app.ActivityCompat
import androidx.recyclerview.widget.RecyclerView

class ExpenseAdapter(private val expenses: MutableList<Expense>) :
    RecyclerView.Adapter<ExpenseAdapter.ExpenseViewHolder>() {

    // Define the REQUEST_CODE to identify the update request
    companion object {
        const val REQUEST_CODE = 321
    }

    class ExpenseViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val tvItemName: TextView = itemView.findViewById(R.id.tvItemName)
        val tvItemAmount: TextView = itemView.findViewById(R.id.tvItemAmount)
        val tvItemDescription: TextView = itemView.findViewById(R.id.tvItemDescription)
        val layout: LinearLayout = itemView.findViewById(R.id.llItem)
        val btnItemDelete: ImageButton = itemView.findViewById(R.id.btnItemDelete)
        val btnItemUpdate: ImageButton = itemView.findViewById(R.id.btnItemUpdate)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ExpenseViewHolder {
        val itemView = LayoutInflater.from(parent.context).inflate(R.layout.item_expense_list, parent, false)
        return ExpenseViewHolder(itemView)
    }

    override fun getItemCount(): Int {
        return expenses.size
    }

    override fun onBindViewHolder(holder: ExpenseViewHolder, position: Int) {
        val curExp = expenses[position]

        holder.tvItemName.text = "${curExp.name}, ${curExp.category}"
        holder.tvItemAmount.text = "${curExp.amount}  ${curExp.currency}"
        holder.tvItemDescription.text = curExp.description

        if (position % 2 == 0) {
            holder.layout.setBackgroundResource(R.color.white)
        } else {
            holder.layout.setBackgroundResource(androidx.appcompat.R.color.material_grey_100)
        }

        holder.btnItemDelete.setOnClickListener {
            deleteExpense(curExp)
        }

        holder.btnItemUpdate.setOnClickListener {
            val intent = Intent(holder.itemView.context, UpdateExpenseActivity::class.java)
            intent.putExtra("expense", curExp)
            // Start the activity for result
            ActivityCompat.startActivityForResult(holder.itemView.context as Activity, intent, REQUEST_CODE, null)
        }
    }

    fun addExpense(expense: Expense) {
        expenses.add(expense)
        expenses.sortByDescending { exp: Expense -> exp.date}
        notifyDataSetChanged()
    }


    fun updateExpense(expense: Expense, newExpense: Expense) {
        val index = expenses.indexOf(expense)
        if (index != -1) {
            expenses[index] = newExpense
        }
        expenses.sortByDescending { exp: Expense -> exp.date}
        notifyDataSetChanged()
    }

    fun deleteExpense(expense: Expense) {
        expenses.remove(expense)
        notifyDataSetChanged()
    }
}
