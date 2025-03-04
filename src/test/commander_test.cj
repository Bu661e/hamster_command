package hamster_commander.test

import std.unittest.*
import std.unittest.testmacro.*
import hamster_commander.*
import crypto.crypto.*
import std.unittest.mock.*
import std.unittest.mock.mockmacro.*
import hamster_commander.services.*
import hamster_commander.models.*
import std.collection.*
import hamster_commander.services.command_service_constant.*

@Test
public class CommanderTest {
    @TestCase
    public func setKeySecret_default() {
        let secureRandom = SecureRandom()
        let randomInt16 = secureRandom.nextInt16()
        let key = "key" + randomInt16.toString()
        let secret = "secret" + secureRandom.nextInt16().toString()

        let secretStore = SecretStore()
        let commanderService = mock<ICommandService>()
        let historyStore = mock<IHistoryStore>()
        let commander = Commander(secretStore, commanderService, historyStore)
        commander.setKeySecret(key, secret)
        let keyFromSecretStore = secretStore.get(API_KEY_KEY)
        let secretFromSecretStore = secretStore.get(API_SECRET_KEY)

        @Expect(keyFromSecretStore, key)
        @Expect(secretFromSecretStore, secret)
    }

    @TestCase
    public func listHistory_default() {
        let secretStore = SecretStore()
        let commanderService = mock<ICommandService>()
        let historyStore = mock<IHistoryStore>()

        let historiesToReturn = ArrayList<History>(
            History("intent1", "command1"),
            History("intent2", "command2"),
            History("intent3", "command3")
        )
        @On(historyStore.list()).returns(historiesToReturn)

        let commander = Commander(secretStore, commanderService, historyStore)
        var histories = commander.listHistory()

        @Assert(refEq(histories, historiesToReturn))
    }

    @TestCase
    public func getHistory_default() {
        let secretStore = SecretStore()
        let commanderService = mock<ICommandService>()
        let historyStore = mock<IHistoryStore>()

        let historyToReturn = History("intent1", "command1")
        @On(historyStore.get(1)).returns(historyToReturn)

        let commander = Commander(secretStore, commanderService, historyStore)
        let history = commander.getHistory(1)

        @Assert(history.isSome())
        @Assert(refEq(history.getOrThrow(), historyToReturn))
    }

    @TestCase
    public func removeHistory_default() {
        let secretStore = SecretStore()
        let commanderService = mock<ICommandService>()
        let historyStore = mock<IHistoryStore>()
        @On(historyStore.remove(1)).returns()

        let commander = Commander(secretStore, commanderService, historyStore)
        commander.removeHistory(1)

        Verify.that(@Called(historyStore.remove(1)))
    }

    @TestCase
    public func generateCommand_default() {
        let secretStore = SecretStore()
        let commanderService = mock<ICommandService>()
        let historyStore = mock<IHistoryStore>()

        let intent = "intent"
        let commandToReturn = "command"
        @On(commanderService.generateCommand(intent)).returns(commandToReturn)
        @On(historyStore.append("intent", "command")).returns()

        let commander = Commander(secretStore, commanderService, historyStore)
        let command = commander.generateCommand(intent)

        @Assert(command == commandToReturn)
        Verify.that(@Called(historyStore.append(intent, commandToReturn)))
    }
}
