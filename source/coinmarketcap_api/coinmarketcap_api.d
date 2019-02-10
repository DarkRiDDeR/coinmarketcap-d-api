module coinmarketcap_api.coinmarketcap_api;

import std.array: join;
import std.conv: to;
import std.json;
import std.net.curl;
import std.uri;
import std.zlib;

class CoinmarketcapAPI {
    protected:
    const string BASE_URL = "https://pro-api.coinmarketcap.com";
    HTTP client;
    UnCompress decompressor;
    string url;
    string versionApi;
    string _version = "0.1.0";

    
    public:
    
    this (in string apiKey, in string versionApi = "v1") {
        this.versionApi = versionApi;
        this.url = BASE_URL ~ "/" ~ versionApi ~ "/";
        this.decompressor = new UnCompress();

        this.client = HTTP();
        client.method = HTTP.Method.get;
        client.addRequestHeader("X-CMC_PRO_API_KEY", apiKey);
        client.addRequestHeader("Accept", "application/json");
        client.addRequestHeader("Accept-Charset", "UTF-8");
        //client.addRequestHeader("Accept-Encoding", "deflate, gzip");
        client.addRequestHeader("User-Agent", "coinmarketcap-d-api/"~this._version);
    }

    HTTP getClient () {
        return client;
    }


    /**
    * Get a paginated list of all cryptocurrencies with latest market data

    * @param {int=} Return results from rank start and above
    * @param {int=} Only returns limit number of results [1..5000]
    * @param {string[]=} Return info in terms of another currency
    * @param {string=} Sort results by the options at https://pro.coinmarketcap.com/api/v1#operation/getV1CryptocurrencyListingsLatest
    * @param {string=} Direction in which to order cryptocurrencies ("asc" | "desc")
    * @param {string=} Type of cryptocurrency to include ("all" | "coins" | "tokens")
    *
    * @example
    * getList(1, 10)
    * getList(1, 10, ["EUR", "USD"])
    */
    auto getList (T = string)(
        in int start = 1, in int limit = 100, in string[] convert = ["USD"],
        in string sort = "market_cap", in string sortDir = "", in string cryptocurrencyType = "all"
    ) {
        string[string] data = [
            "start": to!string(start),
            "limit": to!string(limit),
            "convert": join(convert, ","),
            "sort": sort,
            "cryptocurrency_type": cryptocurrencyType
        ];
        if (sortDir != "") data["sort_dir"] = sortDir;
        return request!T("cryptocurrency/listings/latest", data);
    }


    /**
    * Get static metadata for one or more cryptocurrencies
    *
    * @param {string|string[]|int|int[]=} One or more comma separated cryptocurrency IDs or symbols
    * 
    * @example
    * metadata(2);
    * metadata(1, 2);
    * metadata([1, 2]);
    * metadata("BTC,ETH");
    * metadata("BTC", "ETH");
    * metadata(["BTC", "ETH"]);
    */
    auto getMetadata (T = string)(in int[] ids) {
        return request!T("cryptocurrency/info", ["symbol", join(to!(string[])(ids), ",")]);
    }
    auto getMetadata (T = string)(in int[] ids...) {
        return request!T("cryptocurrency/info", ["symbol", join(to!(string[])(ids), ",")]);
    }
    auto getMetadata (T = string)(in string[] symbols) {
        return request!T("cryptocurrency/info", ["symbol": join(symbols, ",")]);
    }
    auto getMetadata (T = string)(in string[] symbols...) {
        return request!T("cryptocurrency/info", ["symbol": join(symbols, ",")]);
    }


    /**
    * Returns a paginated list of all cryptocurrencies by CoinMarketCap ID
    *
    * @param {string=} active or inactive coins
    * @param {int=} Optionally offset the start (1-based index) of the paginated list of items to return.
    * @param {int=} Optionally specify the number of results to return
    * @param {string=|string[]} Optionally pass a comma-separated list of cryptocurrency symbols to return CoinMarketCap IDs for.
    * If this option is passed, other options will be ignored.
    * 
    * @example
    * getMap();
    * getMap("active", 1, 10);
    * getMap("active", 1, 1, ["BTC", "ETH"]);
    */
    auto getMap (T = string)(in string status = "active", in int start = 1, in int limit = 100, in string symbols = "") {
        auto data = [
            "listing_status": status,
            "start": to!string(start),
            "limit": to!string(limit)
        ];
        if (symbols != "") data["symbol"] = symbols;
        return request!T("cryptocurrency/map", data);
    }
    auto getMap (T = string)(in string status, in int start, in int limit, in string[] symbols) {

        return getMap!T(status, start, limit, join(symbols, ","));
    }


    /**
    * Get latest market quote for 1 or more cryptocurrencies

    * @param {string|string[]|int|int[]}  One or more comma separated cryptocurrency symbols
    * @param {string|string[]=} Return quotes in terms of another currency
    *
    * @example
    * getQuotes("BTC")
    * getQuotes(1)
    * getQuotes("BTC,ETH", "EUR")
    * getQuotes(["BTC", "ETH"], ["EUR, "USD"])
    * getQuotes(1, ["EUR, "USD"])
    * getQuotes([1, 2], ["EUR, "USD"])
    */
    auto getQuotes (T = string)(in string symbol, in string convert = "USD") {
        auto data = [
            "symbol": symbol,
            "convert": convert
        ];
        return request!T("cryptocurrency/quotes/latest", data);
    }
    auto getQuotes (T = string)(in string symbol, in string[] convert) {
        return getQuotes!T(symbol, join(convert, ","));
    }
    auto getQuotes (T = string)(in string[] symbols, in string convert) {
        return getQuotes!T(join(symbols, ","), convert);
    }
    auto getQuotes (T = string)(in string[] symbols, in string[] convert) {
        return getQuotes!T(join(symbols, ","), join(convert, ","));
    }

    auto getQuotes (T = string)(in int id, in string convert = "USD") {
        auto data = [
            "id": to!string(id),
            "convert": convert
        ];
        return request!T("cryptocurrency/quotes/latest", data);
    }
    auto getQuotes (T = string)(in int id, in string[] convert) {
        return getQuotes!T(to!string(id), join(convert, ","));
    }
    auto getQuotes (T = string)(in int[] ids, in string convert) {
        return getQuotes!T(join(to!(string[])(ids), ","), convert);
    }
    auto getQuotes (T = string)(in int[] ids, in string[] convert) {
        return getQuotes!T(join(to!(string[])(ids), ","), join(convert, ","));
    }


    /**
    * Get global information
    * 
    * @param {string|string[]=} Return quotes in terms of another currency
    *
    * @example
    * getGlobal("ETH")
    * getGlobal(["ETH", "LTC"])
    */
    auto getGlobal (T = string)(in string convert = "USD") {
        return request!T("global-metrics/quotes/latest", ["convert": convert]);
    }
    auto getGlobal (T = string)(in string[] convert) {
        return getGlobal!T(join(convert, ","));
    }


    string paramsToStr (in string[string] params) {
        string[] ar;
        foreach(key, val; params) {
            ar ~= key ~ "=" ~ val.encode;
        }
        return join(ar, "&");
    }

    T request (T = string)(in string method, in string[string] params) {
        return request!T(method, paramsToStr(params));
    }

    T request (T: JSONValue)(in string method, in string[string] params) {
        return request!T(method, paramsToStr(params));
    }
    
    T request (T = string)(in string method, in string param = "") {
        ubyte[] result;
        bool isGzip = false;

        if (param == "") client.url = this.url ~ method;
        else client.url = this.url ~ method ~ "?" ~ param;

        client.onReceiveHeader = (in char[] key, in char[] value) {
            string v = cast(string)value;
            if (cast(string)key == "content-encoding" && (v == "gzip" || v == "deflate")) isGzip = true;
        };
        client.onReceive = (ubyte[] data)
        {
            result ~= data;
            return data.length;
        };
        client.perform();
        return cast(string) (isGzip ? decompressor.uncompress(result) : result);
    }

    T request (T: JSONValue)(in string method, in string param = "") {
        return parseJSON(request(method, param));
    }
}