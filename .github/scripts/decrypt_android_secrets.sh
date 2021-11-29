#!/bin/sh
# Script description:
# 1. decrypt android_keys.zip.gpg and get our android_keys.zip
# 2. unzip android_keys.zip and get .jks, key.properties and service_account_key.json

# --batch to prevent interactive command
# --yes to assume "yes" for questions
gpg --quiet --batch --yes --decrypt --passphrase="$ANDROID_KEYS_SECRET_PASSPHRASE" \
--output android/android_keys.zip android/android_keys.zip.gpg && cd android && jar xvf android_keys.zip && cd -