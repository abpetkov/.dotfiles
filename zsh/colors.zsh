R=$fg[red]
RESET=$reset_color

local return_code="%(?..%{$R%}%? ↵%{$RESET%})"

PROMPT_PATH_BG="#78dce8"
PROMPT_PATH_FG="#2d2a2e"
PROMPT_GIT_BG="#a9dc76"
PROMPT_GIT_FG="#2d2a2e"
PROMPT_ARROW_1="#ffd866"
PROMPT_ARROW_2="#ff6188"

function git_prompt() {
  local ref marks=""
  ref=$(git symbolic-ref --short HEAD 2> /dev/null) || return

  git diff --no-ext-diff --quiet --exit-code || marks="*${marks}"

  if git rev-parse --quiet --verify HEAD >/dev/null; then
    git diff-index --cached --quiet HEAD -- || marks="+${marks}"
  else
    marks="#${marks}"
  fi

  if [ -n "$(git ls-files --others --exclude-standard)" ]; then
    marks="?${marks}"
  fi

  if [ -n "$marks" ]; then
    print -r -- "${ref} ${marks}"
  else
    print -r -- "$ref"
  fi
}

function prompt_build() {
  local cap=$'\ue0b6' sep=$'\ue0b0'
  local branch
  branch=$(git_prompt)

  local out="%F{${PROMPT_PATH_BG}}${cap}%K{${PROMPT_PATH_BG}}%F{${PROMPT_PATH_FG}}%2~ "
  local tail_bg="$PROMPT_PATH_BG"

  if [ -n "$branch" ]; then
    out+="%K{${PROMPT_GIT_BG}}%F{${PROMPT_PATH_BG}}${sep}%F{${PROMPT_GIT_FG}} ${branch} "
    tail_bg="$PROMPT_GIT_BG"
  fi

  # Each arrow's background is the next arrow's color, so they meet with no gap.
  out+="%K{${PROMPT_ARROW_1}}%F{${tail_bg}}${sep}"
  out+="%K{${PROMPT_ARROW_2}}%F{${PROMPT_ARROW_1}}${sep}"
  out+="%k%F{${PROMPT_ARROW_2}}${sep}%f "
  print -r -- "$out"
}

PROMPT='$(prompt_build)'
RPS1="${return_code}"
