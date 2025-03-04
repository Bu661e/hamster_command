package hamster_commander.test.services

import hamster_commander.models.*
import hamster_commander.services.*
import std.unittest.*
import std.unittest.testmacro.*
import std.fs.*

@Test
public class FileHistoryStoreTest {
    @BeforeEach
    @AfterEach
    public func removeFiles() {
        if (File.exists(FileHistoryStore.historyFilePath)) {
            File.delete(FileHistoryStore.historyFilePath)
        }

        if (File.exists(FileHistoryStore.newHistoryFilePath)) {
            File.delete(FileHistoryStore.newHistoryFilePath)
        }
    }

    @TestCase
    public func append_get_remove_list_default() {
        var histories = [
            History("intent1", "command1"),
            History("intent2", "command2"),
            History("intent3", "command3"),
            History("intent4", "command4"),
            History("intent5", "command5")
        ];

        let fileHistoryStore = FileHistoryStore()
        for (history in histories) {
            fileHistoryStore.append(history.intent, history.command)
        }

        for (i in 0..histories.size) {
            @Assert(i == fileHistoryStore.get(i).getOrThrow().id)
            @Assert(histories[i].intent == fileHistoryStore.get(i).getOrThrow().intent)
            @Assert(histories[i].command == fileHistoryStore.get(i).getOrThrow().command)
        }

        fileHistoryStore.remove(1)

        var historiesListed = fileHistoryStore.list()
        @Assert(historiesListed.size == histories.size - 1)
        @Assert(historiesListed[0].intent == histories[0].intent)
        @Assert(historiesListed[0].command == histories[0].command)
        @Assert(historiesListed[1].intent == histories[2].intent)
        @Assert(historiesListed[1].command == histories[2].command)
    }
}
