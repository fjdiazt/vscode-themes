#!/usr/bin/env bash
set -euo pipefail

line() {
  local code="$1"
  local label="$2"
  local hex="$3"
  local text="$4"

  printf '\033[%sm%-18s %-9s %s\033[0m\n' "$code" "$label" "$hex" "$text"
}

printf '\nEVA-01 terminal text preview\n'
printf 'Run inside the VS Code integrated terminal with the eva-01 theme active.\n\n'

printf 'Default foreground #D8C7F2: '
printf 'normal assistant text, command output, explanations, and plain shell text\n\n'

line 32 'ansiGreen' '#6BFF00' 'success: prompt() returned selection 1'
line 36 'ansiCyan' '#6BFF00' 'path: toolbox/src/scripts/parameters/reset-selected-properties.dsa.ts:18'
line 33 'ansiYellow' '#F7BB2A' 'warning: controller-adjusted value changed'
line 96 'brightCyan' '#F7BB2A' 'note: bright cyan currently shares EVA yellow'
line 97 'brightWhite' '#F08B18' 'emphasis: bold/bright white is EVA orange accent'
line 34 'ansiBlue' '#A877C8' 'symbol: DzNumericProperty controller chain'
line 35 'ansiMagenta' '#E36DFF' 'section: Explored / Search / Read'
line 95 'brightMagenta' '#F1A8FF' 'highlight: selected property graph'
line 92 'brightGreen' '#A2DA5A' 'secondary ok: helper/tests still pass'
line 94 'brightBlue' '#A2DA5A' 'secondary path: bright blue shares soft green'
line 37 'ansiWhite' '#CCCCCC' 'plain white: filenames or neutral labels'
line 90 'brightBlack' '#5A3B24' 'muted: elapsed time, separators, low priority text'
line 31 'ansiRed' '#FF0000' 'error: invalid property selection'
line 91 'brightRed' '#FF3333' 'fatal: script aborted'

printf '\nMixed realistic block:\n\n'
printf '\033[35mExplored\033[0m\n'
printf '  \033[32mSearch\033[0m \033[97mDirectDrivingProperty\033[0m \033[34mDzPropertyParam\033[0m \033[33mDzOutParam\033[0m\n'
printf '  \033[32mRead\033[0m   \033[36mdz_controller.d.ts\033[0m, \033[36mdz_property.d.ts\033[0m\n\n'
printf '\033[90m- Worked for 1m 26s\033[0m\n'

printf '\nRealistic assistant block:\n\n'
printf '• Yes, with the new helper we can make \033[32mreset-selected-properties\033[0m handle this better, especially outputs.\n\n'
printf '  For your specific case, selecting \033[32mbody_ctrl_ArmsFrntBck\033[0m and resetting only that property leaves these driven\n'
printf '  outputs untouched as explicit values:\n\n'
printf '  - \033[32mbody_ctrl_ArmsFrntBckRight\033[0m\n'
printf '  - \033[32mbody_ctrl_ArmsFrntBckLeft\033[0m\n\n'
printf '  That creates confusing states because the master property and its left/right outputs can disagree, or one\n'
printf '  side can remain offset/negative after the master is reset.\n\n'
printf '  I would \033[97mnot\033[0m reset inputs by default. Inputs are upstream causes. If selected property is driven by something\n'
printf '  else, resetting the input can have wider effects and may change controls the user did not intend to touch.\n'
printf '  Outputs are downstream consequences of the selected property, so including them is much safer and matches the\n'
printf '  user mental model: “reset this control and the things it drives.”\n\n'
printf '  \033[35mProposed behavior:\033[0m\n\n'
printf '  - Reset selected properties.\n'
printf '  - Also reset their direct outputs from \033[32mgetPropertyOutputs(...)\033[0m.\n'
printf '  - \033[97mDo not\033[0m reset inputs by default.\n'
printf '  - Deduplicate properties so aliases or repeated controller paths do not reset the same property multiple\n'
printf '    times.\n'
printf '  - Keep this one level deep for now. Do not recursively reset outputs-of-outputs unless we have a proven case;\n'
printf '    recursive ERC graphs can get surprising fast.\n'
printf '  - Use the same target choice for outputs:\n'
printf '      - \033[96mZero\033[0m -> outputs to 0\n'
printf '      - \033[96mDefault\033[0m -> outputs to their own default values\n\n'
printf '  \033[90mOne nuance:\033[0m aliases. The sandbox saw aliases on \033[34mSpine 4\033[0m. \033[32mgetPropertyOutputs(...)\033[0m from the master gave the\n'
printf '  real left/right properties, not the aliases. That is probably the correct reset target. The fallback full\n'
printf '  scan found aliases, but I would not include those unless we prove the real property reset does not update the\n'
printf '  alias display/state.\n\n'
printf '  So I’d implement the first pass as:\n\n'
printf '  \033[97mconst\033[0m properties = \033[32mdistinctSelectedPlusDirectOutputs\033[0m(\033[32mgetSelectedNumericProperties\033[0m())\n'
printf '  \033[97mfor each\033[0m property:\n'
printf '    \033[32madjust\033[0m(property, selectedResetValue)\n'
