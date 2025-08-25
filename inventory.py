#!/usr/bin/env python3

import json
import sys

# Variáveis específicas de cada host
HOSTVARS = {
    "w3.example.net": {
        "webserver_port": 80
    }
}

def main():
    if len(sys.argv) == 2 and sys.argv[1] == "--list":
        inventory = {
            "webservers": {
                "hosts": ["web.example.net", "w3.example.net"]
            },
            "dbservers": {
                "hosts": ["db.example.net"]
            },

            "office": {
                "hosts": ["off1.example.net"]
            },
            "windows": {
                "children": [
                    "office"
                ]
            },
            "_meta": {
                "hostvars": HOSTVARS
            }
        }
        print(json.dumps(inventory))
    else:
        print(json.dumps({}))

if __name__ == "__main__":
    main()
