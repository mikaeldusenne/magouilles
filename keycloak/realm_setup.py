from pprint import pformat
import os
from os import environ
import time
import yaml

import requests
from requests.exceptions import ConnectionError


# Keycloak server URL
keycloak_url = f"http://{environ.get('EDS_CONTAINER_PREFIX', 'eds')}-keycloak:8080"
client_id = 'admin-cli' # Default client for administration
username = environ.get('KEYCLOAK_ADMIN', 'admin') # The Keycloak admin username, defaults to 'admin'
password = environ['KEYCLOAK_ADMIN_PASSWORD'] # The Keycloak admin password
auth_realm = 'master' # Master realm is used for authentication

realm_name="royaume" # the realm to which the data will be inserted


endpoints = dict(
    realm=f'admin/realms',
    token=f'realms/{auth_realm}/protocol/openid-connect/token',
    client=f'admin/realms/{realm_name}/clients',
    user=f'admin/realms/{realm_name}/users',
)

# list of clients to create, with their configuration
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


def wait_for_availability():
    """
    Try to send a request to the keycloak server and returns when an answer was received.
    The endpoint should never give an error, so if it does, this function throws an exception
    sleep_factor controls the growth of the sleeping time between two unsuccessul attempts.
    """
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
            print("Waiting for the keycloak server to start... " + wheel[k % len(wheel)], end="\r")
        time.sleep(sleep_time)
        sleep_time *= sleep_factor
        k+=1
    
    assert status_code == 200, f"request HTTP error: {status_code}"
    return status_code


def request_keycloak(endpoint_name, data, description="", headers=None):
    headers = headers or {}
    args = dict(headers=headers)
    
    datakey = "data" if 'urlencoded' in headers.get('Content-Type', '') else "json"
    args[datakey] = data
    
    resp = requests.post(f"""{keycloak_url}/{endpoints[endpoint_name]}""", **args)
    
    if (resp.status_code >= 200) and (resp.status_code < 400):
        print(f"{endpoint_name} {description} : success")
    elif resp.status_code == 409:
        # We don't want to fail if the failure reason is HTTP 409 == element already exists
        # we do not want to overwrite data either so we simply write that the element was already there
        print(f"{endpoint_name} {description} : already exists.")
    else:
        raise Exception(f"""
{endpoint_name} : Failed. Status code: {resp.status_code}
{pformat(resp.text)}
--------
{pformat(headers)}
--------
{pformat(data)}
--------
""")
    return resp


if __name__ == "__main__":
    
    wait_for_availability()
    
    access_token = request_keycloak(
        'token',
        data={
            'client_id': client_id,
            'username': username,
            'password': password,
            'grant_type': 'password'
        },
        headers={'Content-Type': 'application/x-www-form-urlencoded'}
    ).json()['access_token']

    print("obtained access token.")
    # Authorization header with the access token
    auth_headers = {
        'Authorization': f'Bearer {access_token}',
        'Content-Type': 'application/json'
    }
    
    # create realm
    request_keycloak("realm", {
        'id': realm_name,
        'realm': realm_name,
        'enabled': True,
        'displayName': 'Royaume'
    }, headers=auth_headers)

    # create one client for each service
    for client in clients:
        request_keycloak(
            endpoint_name="client",
            data=client,
            description=f"{client['clientId']}",
            headers=auth_headers
        )
    
    # create users if a user file is present
    if os.path.exists("./data/users.yml"):
        with open('data/users.yml', 'r') as file:
            user_data = yaml.safe_load(file)
        for user in user_data:
            request_keycloak(
                "user",
                user,
                f"create user <{user['username']}>",
                headers=auth_headers
            )




