#!/bin/bash
# NovaPAI cURL Examples
# Docs: https://api.novapai.ai

API_KEY="your-api-key"
BASE_URL="https://api.novapai.ai/router/v1"

# ── Basic Chat ──────────────────────────────────────────────
echo "=== Basic Chat ==="
curl -s "$BASE_URL/chat/completions" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "deepseek-v4-pro",
    "messages": [
      {"role": "system", "content": "You are a helpful assistant."},
      {"role": "user",   "content": "Hello!"}
    ]
  }' | python3 -c "import sys,json; print(json.load(sys.stdin)['choices'][0]['message']['content'])"


# ── Streaming ───────────────────────────────────────────────
echo "=== Streaming ==="
curl -s "$BASE_URL/chat/completions" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "deepseek-v4-pro",
    "messages": [{"role": "user", "content": "Tell me a joke"}],
    "stream": true
  }'


# ── List Models ─────────────────────────────────────────────
echo ""
echo "=== Available Models ==="
curl -s "$BASE_URL/models" \
  -H "Authorization: Bearer $API_KEY" \
  | python3 -c "import sys,json; [print(m['id']) for m in json.load(sys.stdin)['data']]"
