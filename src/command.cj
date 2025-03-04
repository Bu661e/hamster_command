package hamster_commander
import hamster_commander_toolkit.*

public class Command {
    private let apiKey: String 
    private let apiSecret: String 
    private let commandGenerator: SparkCommandGenerator

    public Command() {
        apiKey = "3cf2889805cc16a16a0236229e814936"
        apiSecret = "OThiZDc2MWRkNzZkZTAwMjBlZTdmMTI2"
        commandGenerator = SparkCommandGenerator(apiKey, apiSecret)
    }

    public func generateCommand(intend: String): String {
        return commandGenerator.generateCommand(intend)
    }

}
