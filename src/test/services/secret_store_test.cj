package hamster_commander.test.services

import std.unittest.*
import std.unittest.testmacro.*
import hamster_commander.*
import crypto.crypto.*
import hamster_commander.services.*

@Test
// cjpm.toml output-type = "static"
public class SecretStoreTest {
    @TestCase
    public func set_get_default() {
        let secureRandom = SecureRandom()
        let randomInt16 = secureRandom.nextInt16()
        let key = "key" + randomInt16.toString()
        let value = "value" + secureRandom.nextInt16().toString()

        let secretStore = SecretStore()
        secretStore.set(key, value)
        let valueFromSecretStore = secretStore.get(key)
        
        @Expect(valueFromSecretStore, value)
    }
}