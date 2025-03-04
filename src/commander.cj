package hamster_commander

import hamster_commander.models.*
import hamster_commander.services.*
import std.collection.*
import hamster_commander.services.command_service_constant.*

public class Commander {
    public Commander(let secretStore: SecretStore, let commandService: ICommandService, let historyStore: IHistoryStore) {}

    public func generateCommand(intent: String): String {
        let command = commandService.generateCommand(intent)
        historyStore.append(intent, command)
        return command
    }

    public func listHistory(): ArrayList<History> {
        return historyStore.list()
    }

    public func getHistory(id: Int64): Option<History> {
        return historyStore.get(id)
    }

    public func removeHistory(id: Int64) {
        historyStore.remove(id)
    }

    public func setKeySecret(key: String, secret: String) {
        secretStore.set(API_KEY_KEY, key)
        secretStore.set(API_SECRET_KEY, secret)
    }
}
