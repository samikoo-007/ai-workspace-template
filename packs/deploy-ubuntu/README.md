# Pack: deploy-ubuntu

LAN Ubuntu + Docker-oriented deploy pipeline (optional).

## Activate

```bash
cp -R packs/deploy-ubuntu/deploy ./deploy
mkdir -p .agents/skills
cp -R packs/deploy-ubuntu/.agents/skills/ubuntu_server_deploy .agents/skills/
cp packs/deploy-ubuntu/deploy/deploy.env.example deploy/deploy.env
# edit deploy/deploy.env with YOUR server paths
```

Defaults use placeholders (`your-server`, `your-project`). Replace them before first deploy.
