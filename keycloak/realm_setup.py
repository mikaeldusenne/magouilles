import requests
import os
from os import environ
import pickle

def load_pickle(path):
    logging.debug('loading pickle from {}'.format(path))
    with open(path, 'rb') as f:
        o = pickle.load(f)
    return o

def save_pickle(path, o):
    logging.debug('saving pickle to {}'.format(path))
    with open(path, 'wb') as f:
        pickle.dump(o, f)

# Keycloak server URL
keycloak_url = 'http://eds-keycloak:8080'
client_id = 'admin-cli' # Default client for administration
username = environ['KEYCLOAK_ADMIN'] # The Keycloak admin username
password = environ['KEYCLOAK_ADMIN_PASSWORD'] # The Keycloak admin password
realm = 'master' # Master realm is used for authentication


token_url = f'{keycloak_url}/realms/{realm}/protocol/openid-connect/token'
headers = {
    'Content-Type': 'application/x-www-form-urlencoded'
}
payload = {
    'client_id': client_id,
    'username': username,
    'password': password,
    'grant_type': 'password'
}

response = requests.post(
    token_url,
    data={
        'client_id': client_id,
        'username': username,
        'password': password,
        'grant_type': 'password'
    },
    headers={'Content-Type': 'application/x-www-form-urlencoded'}
)


response_data = response.json()
access_token = response_data['access_token']

print("obtained access token", access_token)

new_realm_data = {
    'id': 'royaume',
    'realm': 'royaume',
    'enabled': True,
    'displayName': 'Royaume'
}



# Admin API endpoint for creating a new realm
create_realm_url = f'{keycloak_url}/admin/realms'

# Authorization header with the access token
auth_headers = {
    'Authorization': f'Bearer {access_token}',
    'Content-Type': 'application/json'
}


create_realm_response = requests.post(create_realm_url, json=new_realm_data, headers=auth_headers)

if create_realm_response.status_code == 201:
    print("Realm created successfully.")
else:
    print(f"Failed to create realm. Status code: {create_realm_response.status_code}")
    save_pickle("./data/response.pkl", create_realm_response)



