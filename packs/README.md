# Optional packs

Packs are **not** part of the default agent context. Activate only what you need.

## How to activate a pack

From the project root (after copying this template):

```bash
# Example: enable Ubuntu deploy scripts + skill
cp -R packs/deploy-ubuntu/deploy ./deploy
mkdir -p .agents/skills
cp -R packs/deploy-ubuntu/.agents/skills/* .agents/skills/

# Example: local LLM bridge
cp -R packs/local-llm/.agents/skills/* .agents/skills/
```

Then tell the agent which pack you enabled.

## Pack catalog

| Pack | Contents |
|------|----------|
| `deploy-ubuntu/` | `deploy/` scripts + `ubuntu_server_deploy` skill |
| `local-llm/` | Gemma/Ollama bridge skill + helper script |
| `data-python/` | Scraper/analyzer templates + ORM skill stub + heavier requirements |
| `web-ui/` | UI/UX, a11y/SEO, brand, API, boilerplate, cloud deploy skills |
| `gemini-gem/` | Gemini Gem kickstart documentation (Finnish) |

Core stays small on purpose. Keep packs out of hot prompts unless activated.
