#!/bin/sh
set -e

# TODO CHECK IF USER HAS CORRECT PERMITS

npm run start

exec ${@}
