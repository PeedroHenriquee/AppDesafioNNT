

import UIKit

class MoviewViewController: UIViewController {
    
    private var cards: [CardData] = []
    
    /*
     private let musics: [Music] = [
     .init(title: "BLUESMAN", releaseDate: "BACO EXU DO BLUES", imageURL: "", timeMusica: ""),
     .init(title: "PROSTURADO E CALMO", releaseDate: "LEO SANTANA", imageURL: "", timeMusica: ""),
     .init(title: "SOLTO", releaseDate: "DJONGA", imageURL: "", timeMusica: ""),
     .init(title: "LITTLE WING", releaseDate: "JIMI", imageURL: "", timeMusica: ""),
     .init(title: "BIG MESS", releaseDate: "MAMUDI", imageURL: "", timeMusica: ""),
     .init(title: "NOTION", releaseDate: "TASH SUITANA", imageURL: "", timeMusica: ""),
     .init(title: "WAR PIGS", releaseDate: "BLACK SABBATH", imageURL: "", timeMusica: "")
     ]
    */
    
    // 1
    //Edicao do label title
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 26, weight: .black)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "Lista de cartas Yu Gih Oh"
        
        return label
    }()
    
    
    //edicao das tabelas
    private let tableView : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        return table
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        addViewsInHierarchy()
        setupConstraints()
        
        Task {
            do {
                try await fetchYuGiOhCards()
            } catch {
                print("Erro: \(error)")
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    //incluir tabelas e titulo na tela
    private func addViewsInHierarchy(){
        view.addSubview(titleLabel)
        view.addSubview(tableView)
    }
    
    //ajusta a view e tamanho na tela usando o NSLayout
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            //parte topo da tela
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            //Parte de baixo da tela
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            //parte esquerda da tela
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            //parte direita da tela
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
    }
    
    private func fetchYuGiOhCards() async throws -> Void {
        let request = ApiRequests()
        self.cards = try await request.fetchYuGiOhCards()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension MoviewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection  section: Int) -> Int {
        cards.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CardCell()
        let card = cards[indexPath.row]
        cell.setup(card: card)
        return cell
    }
}
    

extension MoviewViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let storyboard = UIStoryboard(name: "Detail", bundle: Bundle(for:  DetailsViewController.self))
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "Detail")
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
