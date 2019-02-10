module coinmarketcap_api;


public import coinmarketcap_api.coinmarketcap_api;

package unittest {
    import std.json;
    import std.stdio;

    auto cmc = new CoinmarketcapAPI ("api key");
    try {
        auto f = File("test.txt", "w");

        f.writeln("@@", "getMetadata", "@@");
        f.writeln(`==getMetadata("BTC,ETH")==`, cmc.getMetadata("BTC,ETH"));
        f.writeln(`==getMetadata("BTC", "TRX")==`, cmc.getMetadata("BTC", "TRX"));
        f.writeln(`==getMetadata(["BTC", "ETH"])==`, cmc.getMetadata(["BTC", "ETH"]));

        f.writeln("@@", "getList", "@@");
        f.writeln("==getList(1, 10)==", cmc.getList(1, 10));
        f.writeln(`==getList(1, 10, ["EUR", "USD"])==`, cmc.getList(1, 10, ["EUR", "USD"]));

        f.writeln("@@", "getMap", "@@");
        f.writeln(`==getMap("active", 1, 10)==`, cmc.getMap("active", 1, 10));
        f.writeln(`==getMap("active", 1, 2, ["BTC", "ETH"])==`, cmc.getMap("active", 1, 2, ["BTC", "ETH"]));

        f.writeln("@@", "getQuotes", "@@");
        f.writeln(`==getQuotes("BTC")==`, cmc.getQuotes("BTC"));
        f.writeln(`==getQuotes(1)==`, cmc.getQuotes(1));
        f.writeln(`==getQuotes("BTC,ETH", "EUR")==`, cmc.getQuotes("BTC,ETH", "EUR"));
        f.writeln(`==getQuotes(["BTC", "ETH"], ["EUR", "USD"])==`, cmc.getQuotes(["BTC", "ETH"], ["EUR", "USD"]));
        f.writeln(`==getQuotes(1, ["EUR", "USD"])==`, cmc.getQuotes(1, ["EUR", "USD"]));
        f.writeln(`==getQuotes([1, 2], ["EUR", "USD"])==`, cmc.getQuotes([1, 2], ["EUR", "USD"]));

        f.writeln("@@", "getGlobal", "@@");
        f.writeln(`==getGlobal()==`, cmc.getGlobal());
        f.writeln(`==getGlobal("RUB"==`, cmc.getGlobal("RUB"));
        f.writeln(`==getGlobal(["USD", "EUR"])==`, cmc.getGlobal(["USD", "EUR"]));

        f.writeln("@@", "type JSONValue", "@@");
        f.writeln(cmc.getMetadata!JSONValue("BTC,ETH"));
        f.writeln(cmc.getList!JSONValue(1, 10));
        f.writeln(cmc.getMap!JSONValue("active", 1, 10));
        f.writeln(cmc.getQuotes!JSONValue("BTC"));
        f.writeln(cmc.getGlobal!JSONValue());
    } catch (Exception e) {
        writeln(e);
    }

}