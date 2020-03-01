import glob
import subprocess
import os
import hashlib
import base64
import configparser
from eth_utils import keccak
from web3 import Web3

def add_val(parser, section, key, value):
    try:
        parser[section]
    except KeyError:
        parser[section] = {}

    try:
        value = value.decode()
    except AttributeError:
        pass

    try:
        parser[section][key] = str(value)
    except Exception as e:
        ttt = 4

def rand_hex(hexlen=16):
    return os.urandom(hexlen).hex()

def eth_pk():
    return Web3.toHex(keccak(os.urandom(4096)))

template_path = './blank_templates'
specific_secrets_read_path = os.path.join(template_path, 'specific_secrets_template.ini')
common_secrets_read_path = os.path.join(template_path, 'common_secrets_template.ini')

specific_secrets_write_path = './secret/local_secrets.ini'
common_secrets_write_path = './secret/common_secrets.ini'

print('Generating deployment specific (local) secrets')

specific_secrets_parser = configparser.ConfigParser()
specific_secrets_parser.read(specific_secrets_read_path)

APP = 'APP'
add_val(specific_secrets_parser, APP, 'password_pepper', base64.b64encode(os.urandom(32)))
add_val(specific_secrets_parser, APP, 'secret_key', rand_hex(32))
add_val(specific_secrets_parser, APP, 'ecdsa_secret', rand_hex(32))
add_val(specific_secrets_parser, APP, 'basic_auth_username', 'interal_basic_auth')
add_val(specific_secrets_parser, APP, 'basic_auth_password', rand_hex())

# add_val(specific_secrets_parser, 'HEAP', 'id', '')
#
# add_val(specific_secrets_parser, 'TWILIO', 'phone', '')
#
# MESSAGEBIRD = 'MESSAGEBIRD'
# add_val(specific_secrets_parser, MESSAGEBIRD, 'key', '')
# add_val(specific_secrets_parser, MESSAGEBIRD, 'phone', '')

ETHEREUM = 'ETHEREUM'
add_val(specific_secrets_parser, ETHEREUM, 'master_wallet_private_key', eth_pk())
add_val(specific_secrets_parser, ETHEREUM, 'owner_private_key', eth_pk())
add_val(specific_secrets_parser, ETHEREUM, 'float_private_key', eth_pk())

add_val(specific_secrets_parser, 'SLACK', 'HOST', '')

# AFRICASTALKING = 'AFRICASTALKING'
# add_val(specific_secrets_parser, AFRICASTALKING, 'username', '')
# add_val(specific_secrets_parser, AFRICASTALKING, 'api_key', '')
# add_val(specific_secrets_parser, AFRICASTALKING, 'at_sender_id', '')

GE_MIGRATION = 'GE_MIGRATION'
# add_val(specific_secrets_parser, GE_MIGRATION, 'name', '')
# add_val(specific_secrets_parser, GE_MIGRATION, 'user', '')
# add_val(specific_secrets_parser, GE_MIGRATION, 'host', '')
# add_val(specific_secrets_parser, GE_MIGRATION, 'port', '')
# add_val(specific_secrets_parser, GE_MIGRATION, 'password', '')
add_val(specific_secrets_parser, GE_MIGRATION, 'ge_http_provider', 'http://127.0.0.1:7545')

with open(specific_secrets_write_path, 'w') as f:
    specific_secrets_parser.write(f)

print('Generated reasonable local secrets, please modify as required')
print('~~~~')
print('Generating common secrets')
common_secrets_parser = configparser.ConfigParser()
common_secrets_parser.read(common_secrets_read_path)

DATABASE = 'DATABASE'
add_val(common_secrets_parser, DATABASE, 'user', 'postgres')
add_val(common_secrets_parser, DATABASE, 'password', '')
add_val(common_secrets_parser, DATABASE, 'port', '5432')

ETHEREUM = 'ETHEREUM'
add_val(common_secrets_parser, ETHEREUM, 'master_wallet_private_key', '0x4cc8a5b137d505fd6dc5a130745905394522c829a92d1813b0cc44d7dee1e113')

with open(common_secrets_write_path, 'w') as f:
    common_secrets_parser.write(f)
print('Generated reasonable common secrets, please modify as required')

