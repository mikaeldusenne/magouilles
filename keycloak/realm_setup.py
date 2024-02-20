from pprint import pformat
import os
from os import environ
import pickle
import time

import requests
from requests.exceptions import ConnectionError



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
keycloak_url = f"http://{environ.get('EDS_CONTAINER_PREFIX', 'eds')}-keycloak:8080"
client_id = 'admin-cli' # Default client for administration
username = environ['KEYCLOAK_ADMIN'] # The Keycloak admin username
password = environ['KEYCLOAK_ADMIN_PASSWORD'] # The Keycloak admin password
realm = 'master' # Master realm is used for authentication

def wait_for_availability():
    wheel="|/-\\"
    sleep_time=1
    sleep_factor=1
    k=0
    status_code = None
    while status_code is None:
        try:
            resp = requests.get(f"{keycloak_url}/realms/master")
            status_code = resp.status_code
        except ConnectionError as ex:
            print(wheel[k % len(wheel)], end="\r")
        time.sleep(sleep_time)
        sleep_time *= sleep_factor
    
    assert status_code == 200, f"request HTTP error: {status_code}"
    return status_code

wait_for_availability()

token_url = f'{keycloak_url}/realms/{realm}/protocol/openid-connect/token'

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

print("obtained access token.")

################

realm_name="royaume"

endpoints = dict(
    realm=f'{keycloak_url}/admin/realms',
    client=f'{keycloak_url}/admin/realms/{realm_name}/clients',
)

# Authorization header with the access token
auth_headers = {
    'Authorization': f'Bearer {access_token}',
    'Content-Type': 'application/json'
}


def request_keycloak(endpoint_name, data, description=""):
    resp = requests.post(endpoints[endpoint_name], json=data, headers=auth_headers)
    if resp.status_code == 201:
        print(f"{endpoint_name} {description} : success")
    elif resp.status_code == 409:
        print(f"{endpoint_name} {description} : already exists.")
    else:
        save_pickle("./data/response.pkl", resp)
        raise Exception(f"""
{endpoint_name} : Failed. Status code: {resp.status_code}

--------
{pformat(data)}
--------
""")


request_keycloak("realm", {
    'id': realm_name,
    'realm': realm_name,
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
    },
    {
        'clientId': 'matrix',
        'name': 'Matrix',
        'description': '',
        'enabled': True,
        'protocol': 'openid-connect',
        'publicClient': False,
        'redirectUris': [f'https://matrix.{environ["EDS_DOMAIN"]}/_synapse/client/oidc/callback'],
        'clientAuthenticatorType': 'client-secret',
        'secret': environ["KEYCLOAK_MATRIX_SECRET"]
    },
    {
        'clientId': 'gitlab',
        'name': 'Gitlab',
        'description': '',
        'enabled': True,
        'protocol': 'openid-connect',
        'publicClient': False,
        'redirectUris': [f'https://jupyter.{environ["EDS_DOMAIN"]}/users/auth/openid_connect/callback'],
        'clientAuthenticatorType': 'client-secret',
        'secret': environ["KEYCLOAK_GITLAB_SECRET"]
    },
]

for client in clients:
    request_keycloak(
        "client",
        client,
        f"{client['clientId']}"
    )
