#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd "$DIR" \
    && cd .. \
    && sh tanatloc.sh db backup \
    && sh tanatloc.sh data backup
