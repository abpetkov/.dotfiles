R=$fg[red]
RESET=$reset_color

local return_code="%(?..%{$R%}%? ↵%{$RESET%})"

PROMPT_PATH="#78dce8"
PROMPT_BRANCH="#ab9df2"
PROMPT_DIRTY="#ff6188"
PROMPT_ARROW="#a9dc76"
PROMPT_SEP="#727072"

function git_branch() {
  git symbolic-ref --short HEAD 2> /dev/null
}

function git_marks() {
  local marks=""

  git diff --no-ext-diff --quiet --exit-code || marks+="!"

  if git rev-parse --quiet --verify HEAD >/dev/null; then
    git diff-index --cached --quiet HEAD -- || marks+="+"
  else
    marks+="#"
  fi

  if [ -n "$(git ls-files --others --exclude-standard)" ]; then
    marks+="?"
  fi

  if [ -n "$marks" ]; then
    print -r -- "[$marks]"
  fi
}

function prompt_build() {
  local branch marks
  local out="%F{${PROMPT_PATH}}%2~%f"

  branch=$(git_branch)
  if [ -n "$branch" ]; then
    marks=$(git_marks)
    out+=" %F{${PROMPT_SEP}}»%f %F{${PROMPT_BRANCH}}${branch}%f"
    if [ -n "$marks" ]; then
      out+=" %F{${PROMPT_DIRTY}}${marks}%f"
    fi
  fi

  out+=" %F{${PROMPT_ARROW}}→%f "
  print -r -- "$out"
}

PROMPT='$(prompt_build)'
RPS1="${return_code}"
