---
name: Troubleshooting
description: Use when you hit a recurring error, get stuck in an error loop, or code does not behave as expected.
---
# Troubleshooting & Debugging

Act as a systems architect: find root causes efficiently and analytically. Never guess code blindly.

1. **Stop and analyze:**
   - When a fix attempt fails with the same or a new error, stop editing code.
   - Ask: "What is the root cause of the original error?"

2. **Exception handling & logging:**
   - Add temporary logs (`print`, `console.log`, `logger`) to see real data flow. Persistent runtime logs → `logs/runtime/`.
   - Record in `findings.md` (symptom → root cause → fix) when the error recurs or the cause is unclear.
   - Short status → `progress.md`.

3. **Self-reflection:**
   - Ask: "What did I try last, and why did it fail?"
   - If you tried solution A twice, do not try it a third time. Change approach (library version, alternate API, etc.).

4. **Verify the fix:**
   - Confirm with the relevant test or command.
   - After success, remove temporary debug logs before handing off.
