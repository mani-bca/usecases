# usecases
usecases-13 & 14

echo '{"query_vector": [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]}' > payload.json


curl -X POST \
  -H "Content-Type: application/json" \
  -d @payload.json \
  https://b5zt3yw07.execute-api.us-east-1.amazonaws.com/$default/search


echo '{"query_vector": [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]}' > payload.json