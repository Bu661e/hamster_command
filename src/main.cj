package hamster_commander
import hamster_commander_toolkit.*


main(): Int64 {

    let command = Command()

    // println(command.generateCommand(args[0]))
    let secretStore = SecretStore()
    secretStore.set("test", "test")
    let result = secretStore.get("test")
    println(result)
    return 0
}

// change from dev_dht_5