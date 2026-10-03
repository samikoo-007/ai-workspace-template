---
name: Template Skill
description: Use as the structural template when creating new recurring agent skills. Example of correct skill layout and metadata.
---
# Template Skill

When running or creating a skill, follow these steps in order:

1. **Prepare:** Check `resources/` for background facts and links.
2. **Use examples:** Mirror successful patterns from `examples/` (few-shot).
3. **Execute:** Do the work step by step (code, writing, data, etc.).
4. **Respect limits:**
   - Prefer numbered checklists over long prose in instructions.
   - Define concrete rules (word counts, tone, code style).
5. **Review:** Confirm the result matches the skill’s stated goals.

## Structure notes

- **Precise YAML frontmatter:** `name` and a strong `description` between `---` markers. Agents often load the full skill only when the description matches the task.
- **Numbered steps:** Agents follow checklists better than long paragraphs.
- **Clear limits:** Concrete bounds improve consistency.
- **Subfolders:** Skills are folders with `resources/` and `examples/`.
