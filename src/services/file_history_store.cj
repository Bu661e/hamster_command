package hamster_commander.services

import hamster_commander.models.*
import std.collection.*
import std.os.*
import std.fs.*
import encoding.json.*
import std.io.*
import serialization.serialization.*

public class FileHistoryStore <: IHistoryStore {
    public static let historyFilePath: Path
    public static let newHistoryFilePath: Path

    static init() {
        let historyStorePath = homeDir().info.path.join(".hamster_commander")
        if (!Directory.exists(historyStorePath)) {
            Directory.create(historyStorePath, recursive: true)
        }

        historyFilePath = historyStorePath.join("history")
        newHistoryFilePath = historyStorePath.join("history.new")
    }

    public func append(intent: String, command: String): Unit {
        let history = History(intent, command)
        let historyJson = history.serialize().toJson().toJsonString().replace("\n", "")
        try (historyFile = File(historyFilePath, OpenOption.CreateOrAppend), stringWriter = StringWriter(historyFile)) {
            stringWriter.writeln(historyJson)
        }
    }

    public func list(): ArrayList<History> {
        let historyList = ArrayList<History>()
        try (historyFile = File.openRead(historyFilePath), stringReader = StringReader(historyFile)) {
            while (let Some(line) <- stringReader.readln()) {
                let json = line.trimAscii()

                if (json.isEmpty()) {
                    continue
                }

                let history = History.deserialize(DataModel.fromJson(JsonValue.fromStr(json)))
                history.id = historyList.size
                historyList.append(history)
            }
        }

        return historyList
    }

    public func get(id: Int64): Option<History> {
        try (historyFile = File.openRead(historyFilePath), stringReader = StringReader(historyFile)) {
            var lineId = -1
            while (let Some(line) <- stringReader.readln()) {
                lineId++
                let json = line.trimAscii()

                if (lineId != id) {
                    continue
                }

                if (json.isEmpty()) {
                    return None
                }

                let history = History.deserialize(DataModel.fromJson(JsonValue.fromStr(json)))
                history.id = id
                return history
            }
        }

        return None
    }

    public func remove(id: Int64): Unit {
        try (historyFile = File.openRead(historyFilePath), stringReader = StringReader(historyFile), newHistoryFile = File.
            create(newHistoryFilePath), stringWriter = StringWriter(newHistoryFile)) {
            var lineId = -1
            while (let Some(line) <- stringReader.readln()) {
                lineId++
                let json = line.trimAscii()

                if (lineId == id) {
                    continue
                }

                stringWriter.writeln(json)
            }
        }

        File.delete(historyFilePath)
        File.move(newHistoryFilePath, historyFilePath, true)
    }
}
