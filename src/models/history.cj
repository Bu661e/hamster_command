package hamster_commander.models

import serialization.serialization.*
import encoding.json.*

public class History <: Serializable<History> {
    public var id: Int64 = 0

    public History(
        public let intent: String,
        public let command: String
    ) {}

    public func serialize(): DataModel {
        DataModelStruct().add(field<String>("intent", intent)).add(field<String>("command", command))
    }

    public static func deserialize(dm: DataModel): History {
        let dms = match (dm) {
            case d: DataModelStruct => d
            case _ => throw Exception("this data is not DataModelStruct")
        }
        History(
            String.deserialize(dms.get("intent")),
            String.deserialize(dms.get("command"))
        )
    }
}
