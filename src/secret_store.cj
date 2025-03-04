package hamster_commander

import std.os.*
import std.fs.*
import std.io.*

public class SecretStore {
    let secretStorePath = homeDir().info.path.join(".secret_store_demo")

    public func getSecretStoreFilePath(key: String): Path {
        return secretStorePath.join(key)
    }

    public func set(key: String, value: String) {
        if (!Directory.exists(secretStorePath)) {
            println(Directory.exists(secretStorePath))
            Directory.create(secretStorePath, recursive: true)
        }
        

        let secretStoreFilePath = getSecretStoreFilePath(key)
        if (File.exists(secretStoreFilePath)) {
            File.delete(secretStoreFilePath)
        }

        try (secretStoreFile = File.create(secretStoreFilePath), secretStoreFileWriter = StringWriter(secretStoreFile)) {
            secretStoreFileWriter.write(value)
        }
    }

    public func get(key: String): ?String {
        let secretStoreFilePath = getSecretStoreFilePath(key)
        if (!File.exists(secretStoreFilePath)) {
            return None
        }

        // 这里这样写是为了过编译
        // try在cj中是一个表达式，返回值是Unit。cj中函数体中如果没有写return，就会把最后一个表达式作为返回值
        // 但是get函数的返回值是?String，所以需要显式返回
        try (secretStoreFile = File.openRead(secretStoreFilePath), secretStoreFileReader = StringReader(secretStoreFile)) {
            return secretStoreFileReader.readToEnd()
        }

        return None
    }
}
