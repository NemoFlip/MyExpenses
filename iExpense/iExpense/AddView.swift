//
//  AddView.swift
//  iExpense
//
//  Created by Артем Хлопцев on 28.07.2021.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expenses
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    @State private var showingAlert = false
    static var types = ["Personal", "Buisness"]
    var body: some View {
        NavigationView {
                Form {
                    TextField("Enter a name of expense", text: $name)
                    Picker(selection: $type, label: Text("Enter a type of expense?")) {
                        ForEach(Self.types, id: \.self) {
                            Text($0)
                        }
                    }
                    Section(footer: VStack(alignment: .leading) {
                        Text("amount: <= 10$ - lightblue and light weight")
                        Text("amount: <= 100$ - mediumblue and medium weight")
                        Text("amount: > 100$ - darkblue and heavy weight")
                    }) {
                    TextField("Enter amount", text: $amount).keyboardType(.numberPad)
                    }
                }
            .navigationBarTitle("Add expense").navigationBarItems(trailing: Button("Save") {
                if let actualAmount = Int(self.amount) {
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                    self.expenses.items.append(item)
                    self.expenses.items.sort(by: {$1.amount < $0.amount})
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.showingAlert.toggle()
                }
            })
        }.alert(isPresented: $showingAlert, content: {
            Alert(title: Text("There is a problem..."), message: Text("You has probably entered a string"), dismissButton: .default(Text("Ok")) {
                self.showingAlert = false
                self.amount = ""
            })
        })
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
