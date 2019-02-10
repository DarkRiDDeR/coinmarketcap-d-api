# Coinmarketcap D API

[![](https://img.shields.io/dub/v/coinmarketcap-d-api.svg?style=flat)](https://code.dlang.org/packages/coinmarketcap-d-api)
[![](https://img.shields.io/github/license/DarkRiDDeR/coinmarketcap-d-api.svg?style=flat)](https://github.com/DarkRiDDeR/coinmarketcap-d-api/blob/master/LICENSE)

Dlang wrapper around the https://coinmarketcap.com API

## Install

```sh
$ dub add coinmarketcap-d-api
```

## Usage example

```d
import coinmarketcap_api;
import std.json;

auto cmc = new CoinmarketcapAPI ("api key");

cmc.getMetadata("BTC,ETH"); // resutl string
cmc.getMetadata("BTC", "TRX");
cmc.getMetadata(["BTC", "ETH"]);

cmc.getList(1, 10);
cmc.getList(1, 10, ["EUR", "USD"]);

cmc.getMap("active", 1, 10);
cmc.getMap("active", 1, 2, ["BTC", "ETH"]);

cmc.getQuotes("BTC");
cmc.getQuotes(1);
cmc.getQuotes("BTC,ETH", "EUR");
cmc.getQuotes(["BTC", "ETH"], ["EUR", "USD"]);
cmc.getQuotes(1, ["EUR", "USD"]);
cmc.getQuotes([1, 2], ["EUR", "USD"]);

cmc.getGlobal();
cmc.getGlobal("RUB");
cmc.getGlobal(["USD", "EUR"]);

cmc.getMetadata!JSONValue("BTC,ETH"); // resutl JSONValue
cmc.getList!JSONValue(1, 10);
cmc.getMap!JSONValue("active", 1, 10);
cmc.getQuotes!JSONValue("BTC");
cmc.getGlobal!JSONValue();
```

Check out the [CoinMarketCap API documentation](https://pro.coinmarketcap.com/api/v1#section/Introduction) for more information!

## API

### getList

Get a paginated list of all cryptocurrencies with latest market data

### getMetadata

Get static metadata for one or more cryptocurrencies

### getMap

Returns a paginated list of all cryptocurrencies by CoinMarketCap ID

### getQuotes

Get latest market quote for 1 or more cryptocurrencies

### getGlobal

Get global information





## License

Apache 2.0
