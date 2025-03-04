package hamster_commander.services

import std.os.*
import std.fs.*
import std.io.*
import crypto.crypto.*

public class SecretStore {
    let secretStorePath: Path = homeDir().info.path.join(".hamster_commander")
    let key = "hamster_commandr";
    let iv = "commanderhamster";
    let sm4: SM4

    public init() {
        sm4 = SM4(OperationMode.CBC, key.toArray(), iv: iv.toArray())
    }

    private func getSecretStoreFilePath(key: String): Path {
        return secretStorePath.join(key)
    }

    public func get(key: String): ?String {
        let secretStoreFilePath = getSecretStoreFilePath(key)
        if (!File.exists(secretStoreFilePath)) {
            return None
        }

        try (secretStoreFile = File.openRead(secretStoreFilePath)) {
            return String.fromUtf8(sm4.decrypt(secretStoreFile.readToEnd()))
        }

        return None
    }

    public func set(key: String, value: String) {
        if (!Directory.exists(secretStorePath)) {
            Directory.create(secretStorePath, recursive: true)
        }

        let secretStoreFilePath = getSecretStoreFilePath(key)
        if (File.exists(secretStoreFilePath)) {
            File.delete(secretStoreFilePath)
        }

        try (secretStoreFile = File.create(secretStoreFilePath)) {
            secretStoreFile.write(sm4.encrypt(value.toArray()))
        }
    }
}
