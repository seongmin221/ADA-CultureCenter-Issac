
import Foundation

class ViewModel: ObservableObject {
    
    @Published var words: [String] = []
    
    func fetchNumber(_ number: Int) {
        
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
        
        guard var urlComp = URLComponents(string: "https://random-word-api.herokuapp.com/word?") else { return }
        let urlNumberQuery = [URLQueryItem(name: "number", value: "\(number)")]
        
        urlComp.queryItems = urlNumberQuery
        
        guard let url = urlComp.url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let decoder = JSONDecoder()
                let words = try decoder.decode(Array<String>.self, from: data)
                
                DispatchQueue.main.async {
                    self.words = words
                }
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
    }
}

let viewModel = ViewModel()

viewModel.fetchNumber(10)
print(viewModel.words)
