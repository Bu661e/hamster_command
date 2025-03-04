package hamster_commander.test

import std.unittest.*
import std.unittest.testmacro.*
import hamster_commander.*
import crypto.crypto.*
import std.fs.*
@Test
public class SecretStoreTest {
    @TestCase
    public func testSetAndGet() {
        let secureRandom = SecureRandom()
        let key = "key" + secureRandom.nextInt64().toString()
        let value = "value" + secureRandom.nextInt64().toString()

        let secretStore = SecretStore()
        secretStore.set(key, value)
        let result = secretStore.get(key)
        @Expect(result, value)

        File.delete(secretStore.getSecretStoreFilePath(key))
    }

}