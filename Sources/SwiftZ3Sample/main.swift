import SwiftZ3
import Z3

func main() {
    let config = Z3Config()
    config.setParameter(name: "model", value: "true")

    let context = Z3Context(configuration: config)
}
