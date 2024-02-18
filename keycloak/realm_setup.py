import requests
import os
from os import environ
import pickle

def load_pickle(path):
    print('loading pickle from {}'.format(path))
    with open(path, 'rb') as f:
        o = pickle.load(f)
    return o

def save_pickle(path, o):
    print('saving pickle to {}'.format(path))
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




# Admin API endpoint for creating a new realm
# create_realm_url = f'{keycloak_url}/admin/realms'

endpoints = dict(
    realm=f'{keycloak_url}/admin/realms',
    client=f'{keycloak_url}/admin/realms/mynewrealm/clients',
)

# Authorization header with the access token
auth_headers = {
    'Authorization': f'Bearer {access_token}',
    'Content-Type': 'application/json'
}


def request_keycloak(endpoint_name, data, description=""):
    resp = requests.post(endpoints['endpoint_name'], json=data, headers=auth_headers)
    if resp.status_code == 201:
        print(f"{endpoint_name} {description} : success")
    elif resp.status_code == 409:
        print(f"{endpoint_name} {description} : already exists.")
    else:
        save_pickle("./data/response.pkl", resp)
        raise Exception(f"{endpoint_name} {description} : Failed. Status code: {create_realm_response.status_code}")


request_keycloak("realm", {
    'id': 'royaume',
    'realm': 'royaume',
    'enabled': True,
    'displayName': 'Royaume'
})

clients = [
    {
        'clientId': 'jupyterhub',
        'name': 'JupyterHub',
        'description': '',
        'enabled': True,
        'protocol': 'openid-connect',
        'publicClient': False,
        'redirectUris': [f'https://jupyter.{environ["EDS_DOMAIN"]}/hub/oauth_callback'],
        'clientAuthenticatorType': 'client-secret',
        'secret': environ["KEYCLOAK_JUPYTER_SECRET"]
    }
]

for client in clients:
    # create_client_response = requests.post(create_client_url, json=new_client_data, headers=auth_headers)
    request_keycloak(
        "client",
        client,
        f"{client['clientId']}"
    )
