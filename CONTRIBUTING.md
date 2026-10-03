# Contributing

Thanks for improving the public template.

## Principles

1. Keep **core** lean. Put niche features in `packs/`.
2. Do not add personal server names, private IPs, or real secrets.
3. Prefer English in agent-facing docs (`AGENTS.md`, workflows, skills).
4. Run `python3 scripts/security_scan.py --all` before opening a PR.

## Suggested workflow

1. Fork / branch
2. Change one concern at a time
3. Update `README.md` or `packs/README.md` if the public surface changes
4. Open a PR with a short "why"

## Relationship to private forks

Private workspaces may keep heavier, personal conventions. Do not merge private product playbooks into this template unless they are generalized and placed under `packs/`.

## Publishing

Before a public release or Template-repo update, follow [docs/github_publish.md](docs/github_publish.md) (scrub checklist, positioning, `gh` steps).
