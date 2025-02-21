//
//  ContentView.swift
//  iExpense
//
//  Created by Shashank B on 21/02/25.
//

import SwiftUI



struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    @State private var selectedFilter = "All"
    @State private var expenseToEdit: ExpenseItem? = nil


    let expenseTypes = ["All", "Personal", "Business"]

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Expense Type", selection: $selectedFilter) {
                    ForEach(expenseTypes, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List {
                    ForEach(filteredExpenses) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }
                            
                            Spacer()
                            Text(item.amount, format: .currency(code: "USD"))
                                .font(styling(for: item.amount))
                                .foregroundColor(color(for: item.amount))
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            expenseToEdit = item
                            showingAddExpense = true
                        }
                    }
                    .onDelete(perform: { indexSet in
                        removeItems(at: indexSet)
                    })
                }
                .navigationTitle("iExpense")
                .sheet(isPresented: $showingAddExpense){
                    AddView(expenses: expenses, expenseToEdit: $expenseToEdit)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            expenseToEdit = nil 
                            showingAddExpense = true
                        } label: {
                            Label("Add Expense", systemImage: "plus")
                        }
                    }
                }
            }
        }
    }
    
    var filteredExpenses: [ExpenseItem] {
        if selectedFilter == "All" {
                return expenses.items
        } else {
                return expenses.items.filter { $0.type == selectedFilter }
        }
    }
    
    func removeItems(at offsets:IndexSet){
        expenses.items.remove(atOffsets: offsets)
    }
    func color(for amount: Double) -> Color {
            switch amount {
            case ..<10:
                return .green
            case ..<100:
                return .orange
            default:
                return .red
        }
    }
    func styling(for amount: Double) -> Font {
           switch amount {
           case ..<10:
               return .body
           case ..<100:
               return .headline.bold()
           default:
               return .headline.bold().italic()
        }
    }
}

#Preview {
    ContentView()
}
