# Battler

Display information from barcodes, based on the Barcode Battler II gaming system.

This project has two sides: a CLI binary, and an HTTP server.

## CLI usage

```
battler <ean_digits>
```

The tool accepts any valid EAN-8 or EAN-13 barcode (digits only, checksum validated) and displays the full card stats for both VS Mode and Story Mode.

## HTTP usage

The `server` binary exposes a single route `/barcode/<barcode>`.

You can run it locally and test it with [httpie](https://httpie.io/):

```sh
❯ http localhost:3000/barcode/0381108136502
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 187
Content-Type: application/json
Date: Wed, 01 Jul 2026 10:40:46 GMT
X-Powered-By: Kemal

[
    {
        "Barcode": "0381108136502",
        "Mode": "C0 / C1"
    },
    {
        "Job": "Warrior3",
        "Race": "Animal",
        "Type": "Warrior"
    },
    {
        "DF": "800",
        "HP": "3800",
        "MP": "0",
        "PP": "5",
        "SPD": "6",
        "ST": "1100"
    },
    {
        "Special": "Hero card"
    }
]
```

## Technical specs

Here is a compilation of quite a lot of information and data on the Barcode Battler in general and more specifically on how the v2 works: [TECHNICAL_SPECS.md](TECHNICAL_SPECS.md).

## Development

You'll need to have Ruby available on your system to be able to install Run, which is the project manager that we use :

```rb
gem install run_tasks
```

Then you'll have access to Run commands. To display help:

```sh
run
```

## License

[Don't Be A Dick](https://dont-be-a-dick.animi.st/).
