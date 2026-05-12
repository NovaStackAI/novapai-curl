#!/bin/bash
# NovaPAI cURL Examples
# Docs: https://novapai.ai

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


# ── Function Calling ────────────────────────────────────────
echo ""
echo "=== Function Calling ==="
curl -s "$BASE_URL/chat/completions" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "deepseek-v4-pro",
    "messages": [
      {"role": "user", "content": "What'\''s the weather in Tokyo?"}
    ],
    "tools": [{
      "type": "function",
      "function": {
        "name": "get_weather",
        "description": "Get current weather for a city",
        "parameters": {
          "type": "object",
          "properties": {
            "city": {"type": "string", "description": "City name"}
          },
          "required": ["city"]
        }
      }
    }]
  }' | python3 -c "
import sys,json
msg = json.load(sys.stdin)['choices'][0]['message']
tc = msg['tool_calls'][0]
print(f\"Function: {tc['function']['name']}\")
print(f\"Args: {tc['function']['arguments']}\")
"


# ── JSON Mode (Structured Output) ───────────────────────────
echo ""
echo "=== JSON Mode ==="
curl -s "$BASE_URL/chat/completions" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "deepseek-v4-pro",
    "messages": [
      {"role": "system", "content": "Extract company info as JSON."},
      {"role": "user", "content": "Apple Inc. is based in Cupertino, founded in 1976."}
    ],
    "response_format": {"type": "json_object"}
  }' | python3 -c "import sys,json; print(json.dumps(json.loads(json.load(sys.stdin)['choices'][0]['message']['content']), indent=2))"


# ── List Models ─────────────────────────────────────────────
echo ""
echo "=== Available Models ==="
curl -s "$BASE_URL/models" \
  -H "Authorization: Bearer $API_KEY" \
  | python3 -c "import sys,json; [print(m['id']) for m in json.load(sys.stdin)['data']]"
