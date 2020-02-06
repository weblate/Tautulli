import sys, requests

r = requests.get('https://localhost:8181/status')

if r.status_code == 200:
    sys.exit(0)
else:
    sys.exit(1)
