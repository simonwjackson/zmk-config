When showing keymap layouts, always use the 5×3+3 Corne ASCII box-drawing diagram format (no outer columns), with `┌─────┬─────┐` borders, `│` cell separators, and a split gap between halves.

## Keymap Design Philosophy

This is a **layered homerow-mod layout** optimized for programming:

- **Left hand homerow activates layers; right hand has the actual content.** All layer-tap keys live on the left home row (A→DIR, S→NUM, D→WRP, F→CHK), keeping the right hand free for output.
- **Per-finger tuned hold-tap timings.** Pinky is slowest (280ms), ring (250ms), middle (230ms), index fastest (200ms) — matching each finger's natural speed and strength.
- **Positional shift prevents accidental shifts.** Left shift (V) only activates when a right-hand key follows, and vice versa for right shift (M), avoiding misfires during fast same-hand rolls.
- **Tap-dance brackets keep paired delimiters on single keys.** The WRP layer uses tap-dance: tap once for open bracket, twice for close (e.g., `[` / `]`, `(` / `)`, `{` / `}`, `<` / `>`).
- **Combos put common editing actions on adjacent home-row keys.** Enter (J+K), Esc (K+L), Backspace (I+O), Delete Word (U+I), Save (H+L), Tab (Q+W) — all without leaving the home row.
- **Sub-layers stack for deeper access.** DIR+PAG for paging, DIR+FUN for function keys, NUM+SYM for symbols — keeping the base layer clean while providing full coverage.
- **Mod-morph for context-sensitive keys.** Colon is the default on the semicolon key; shift produces semicolon (reversed from standard) since colon is more common in code.
