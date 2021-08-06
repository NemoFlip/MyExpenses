//
//  ContentView.swift
//  iExpense
//
//  Created by Артем Хлопцев on 27.07.2021.
//

import SwiftUI
struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded.sorted(by:{$1.amount < $0.amount})
                return
            }
        }
        self.items = []
    }
}


struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingSecondView = false
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) {item in
                    HStack {
                        VStack(alignment: .leading,spacing: 3) {
                            Text(item.name).bold()
                            Text(item.type)
                        }
                        Spacer()
                        if item.amount <= 10 {
                            Text("$\(item.amount)").foregroundColor(Color.init(#colorLiteral(red: 0.3354369879, green: 0.5436371617, blue: 0.9686274529, alpha: 1))).fontWeight(.medium)
                        } else if item.amount <= 100 && item.amount > 10 {
                            Text("$\(item.amount)").foregroundColor(Color.init(#colorLiteral(red: 0.1764705926, green: 0.4685430423, blue: 0.7568627596, alpha: 1))).fontWeight(.semibold)
                        } else {
                            Text("$\(item.amount)").foregroundColor(Color.init(#colorLiteral(red: 0.2972720382, green: 0.4021633655, blue: 0.8189641627, alpha: 1))).fontWeight(.heavy)
                        }
                        
                    }
                }.onDelete(perform: removeItem)
            }.navigationBarTitle("My expenses").navigationBarItems(leading: EditButton(),trailing: Button(action: {
                self.showingSecondView.toggle()
            }) {
                Image(systemName: "plus")
            }).sheet(isPresented: $showingSecondView, content: {
                AddView(expenses: self.expenses)
            })
            
        }
        
    }
    func removeItem(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
