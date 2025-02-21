//
//  AddView.swift
//  iExpense
//
//  Created by Shashank B on 21/02/25.
//

import SwiftUI

struct AddView: View {
    var expenses: Expenses
    @Environment(\.dismiss) var dismiss
    @Binding var expenseToEdit: ExpenseItem?
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0

    let types = ["Business", "Personal"]

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)

                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }

                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    if let existingItem = expenseToEdit,
                       let index = expenses.items.firstIndex(where: { $0.id == existingItem.id }) {
                        expenses.items[index] = ExpenseItem(name: name, type: type, amount: amount)
                    } else {
                        let newItem = ExpenseItem(name: name, type: type, amount: amount)
                        expenses.items.append(newItem)
                    }
                    dismiss()
                }
            }
            .onAppear {
                if let expense = expenseToEdit {
                    name = expense.name
                    type = expense.type
                    amount = expense.amount
                }
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses(), expenseToEdit: .constant(nil))
}



