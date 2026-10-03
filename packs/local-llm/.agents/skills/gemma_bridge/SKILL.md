---
name: gemma_bridge
description: >-
  Delegate tasks to a local Gemma 4 LLM via Ollama.
  Always use when the user mentions "Gemma" or "Gemma4".
---

# Skill: Gemma Bridge (local LLM delegation)

Delegate work to a local Ollama server (e.g. a Gemma 4 model).

## When to use (triggers)

Use this skill and its Python script **immediately** when:

1. The user mentions **"Gemma"** or **"Gemma4"** (explicit request for the local model).
2. The task is **bulk data analysis**: tens or hundreds of KB that would exceed the main agent’s token/context limit.
3. The task needs **privacy**: documents or data that must not be sent to the cloud.

## Execution

Run via `.agents/skills/gemma_bridge/gemma_delegate.py`. The script is built for agent use and supports several modes.

### 1. Basic use (short prompts)

```bash
python3 .agents/skills/gemma_bridge/gemma_delegate.py "Your prompt here"
```

### 2. File-based input (bulk data — recommended)

For large text (file contents, long logs, codebases), write the prompt and data to a temp file and pass `--file`. This avoids shell command-length limits:

```bash
# Create a file first (e.g. prompt.txt) with instructions + data
python3 .agents/skills/gemma_bridge/gemma_delegate.py --file prompt.txt
```

### 3. Structured output (JSON)

To force machine-readable output, instruct the model to return JSON and pass `--json`:

```bash
python3 .agents/skills/gemma_bridge/gemma_delegate.py --json "Analyze and return the answer as valid JSON only..."
```

*(You can combine flags: `python3 ... --json --file prompt.txt`)*

## Configuration and prompting tips

- **API URL**: default `http://localhost:11434/api/generate`.
- **Model**: default `gemma4`.
- **Prompting**: Local models are often weaker — be precise. Give a clear role and exact output format (e.g. *"Reply as a list only"*, *"Return JSON with no other text"*).
- **Errors**: The script has timeout and error handling. On network failure, tell the user clearly: "Could not reach the local Ollama server in time. Confirm Ollama is running on this machine."
