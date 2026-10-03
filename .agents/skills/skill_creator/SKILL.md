---
name: Skill Creator
description: Use when creating a new agent skill from source material, instructions, or a user request.
---
# Skill Creator

Create structurally complete skills that follow workspace best practices.

When creating a new skill, follow these steps in order:

1. **Analyze the request:**
   - Purpose and core problem the skill solves.
   - Rules, steps, and limits implied by the source material.

2. **Create the folder layout:**
   - Place the skill at `.agents/skills/[skill_name]/`
   - Inside it, create `resources/` and `examples/`

3. **Write `SKILL.md`:**
   - **YAML frontmatter** at the top:
     - `name`: short clear name
     - `description`: precise *when to use* text (agent trigger) — e.g. "Use when..."
   - Prefer numbered steps over long prose.
   - Define clear limits (length, tone, forbidden actions).
   - Tell consumers to check `resources/` and `examples/`.

4. **Review:**
   - Ensure `SKILL.md` is logical, concise, and matches this template’s skill conventions.

## Example `SKILL.md` shape

```markdown
---
name: [Skill name]
description: Use when [exact activation condition].
---
# [Skill name]

Follow these steps:

1. **Prepare:** Check `resources/` for background material.
2. **Examples:** Mirror style from `examples/` (few-shot).
3. **[Step 1]:** [Do this]
4. **[Step 2]:** [Do this]
5. **Limits:**
   - [Limit 1, e.g. under 200 words]
   - [Limit 2, e.g. no jargon]
```
