import requests

def test_api_endpoint():
    response = requests.get("http://green-server-url/api/records")
    assert response.status_code == 200
    assert "data" in response.json()
