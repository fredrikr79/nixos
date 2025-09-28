# # config.nu
# #
# # Installed by:
# # version = "0.106.1"
# #
# # This file is used to override default Nushell settings, define
# # (or import) custom commands, or run any other startup tasks.
# # See https://www.nushell.sh/book/configuration.html
# #
# # Nushell sets "sensible defaults" for most configuration settings, 
# # so your `config.nu` only needs to override these defaults if desired.
# #
# # You can open this file in your default editor using:
# #     config nu
# #
# # You can also pretty-print and page through the documentation for configuration
# # options using:
# #     config nu --doc | nu-highlight | less -R


###
### stolen from https://wiki.nixos.org/wiki/Nushell
###

# Completions
# mainly pieced together from https://www.nushell.sh/cookbook/external_completers.html

# carapce completions https://www.nushell.sh/cookbook/external_completers.html#carapace-completer
# + fix https://www.nushell.sh/cookbook/external_completers.html#err-unknown-shorthand-flag-using-carapace
# enable the package and integration bellow
let carapace_completer = {|spans: list<string>|
  carapace $spans.0 nushell ...$spans
  | from json
  | if ($in | default [] | where value == $"($spans | last)ERR" | is-empty) { $in } else { null }
}
# some completions are only available through a bridge
# eg. tailscale
# https://carapace-sh.github.io/carapace-bin/setup.html#nushell
$env.CARAPACE_BRIDGES = 'zsh,bash,inshellisense'

# zoxide completions https://www.nushell.sh/cookbook/external_completers.html#zoxide-completer
let zoxide_completer = {|spans|
    $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
}

# multiple completions
# the default will be carapace, but you can also switch to fish
# https://www.nushell.sh/cookbook/external_completers.html#alias-completions
let multiple_completers = {|spans|
  ## alias fixer start https://www.nushell.sh/cookbook/external_completers.html#alias-completions
  let expanded_alias = scope aliases
  | where name == $spans.0
  | get -o 0.expansion

  let spans = if $expanded_alias != null {
    $spans
    | skip 1
    | prepend ($expanded_alias | split row ' ' | take 1)
  } else {
    $spans
  }
  ## alias fixer end

  match $spans.0 {
    __zoxide_z | __zoxide_zi => $zoxide_completer
    _ => $carapace_completer
  } | do $in $spans
}

$env.config = {
  buffer_editor: "nvim",
  show_banner: false,
  completions: {
    case_sensitive: false # case-sensitive completions
    quick: true           # set to false to prevent auto-selecting completions
    partial: true         # set to false to prevent partial filling of the prompt
    algorithm: "fuzzy"    # prefix or fuzzy
    external: {
      # set to false to prevent nushell looking into $env.PATH to find more suggestions
      enable: true 
      # set to lower can improve completion performance at the cost of omitting some options
      max_results: 100 
      completer: $multiple_completers
    }
  },
  hooks: {
    pre_prompt: [{ ||
      if (which direnv | is-empty) {
        return
      }

      direnv export json | from json | default {} | load-env
      if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
        $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
      }
    }]
  }
} 
$env.PATH = ($env.PATH | 
  split row (char esep) |
  prepend /home/myuser/.apps |
  append /usr/bin/env
)

###
### end steal
###

source ./themes/dracula.nu

