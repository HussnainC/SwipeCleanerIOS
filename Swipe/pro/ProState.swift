


import StoreKit

class ProState: ObservableObject {
    @Published  var  isProUser: Bool = false
    @Published var products: [Product]?
    @Published var credits: Int = 0
    private var dailyCreditTask: Task<Void, Never>?
    init(){
        refreshState()
        Task{
             await self.fetchProducts()
        }
    }
    
    func refreshState()  {
        Task {
               await self.checkActiveSubscription()
           }
       
    }
    
    func getProduct(id: String) -> Product? {
        return  products?.first(where: { $0.id == id })
    }
    
    @MainActor
    private func fetchProducts() async {
            do {
                 products = try await Product.products(for: [ProductKeys.weekly,ProductKeys.monthly,ProductKeys.yearly])
            } catch {
                print("Error fetching subscription: \(error)")
            }
        }

    @MainActor
    func checkActiveSubscription() async {
           for await result in Transaction.currentEntitlements {
               guard case .verified(let transaction) = result else {
                   continue
               }

               if [ProductKeys.weekly, ProductKeys.monthly, ProductKeys.yearly].contains(transaction.productID),
                  transaction.revocationDate == nil,
                  transaction.expirationDate.map({ $0 > Date() }) != false {
                   print("Active subscription found! \(String(describing: transaction.expirationDate))")
                   self.isProUser = true
                   return
               }
           }

        self.isProUser = false
       }
}
