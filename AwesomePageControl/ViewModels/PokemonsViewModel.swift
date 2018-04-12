import Foundation

final class PokemonsViewModel {
    
    lazy var pokemons: [Pokemon] = {
        var data: [Pokemon] = []
        for x in 0..<151 {
            data.append(
                Pokemon(
                    imageName: "\(x + 1)",
                    desc: "#\(x + 1)")
            )}
        return data
    }()
}
