package hamster_commander.services

import hamster_commander.models.*
import std.collection.*

public interface IHistoryStore {
    func append(intent: String, command: String): Unit

    func list(): ArrayList<History>

    func get(id: Int64): Option<History>

    func remove(id: Int64): Unit
}
