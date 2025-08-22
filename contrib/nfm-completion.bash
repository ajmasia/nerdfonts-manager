# bash completion for nfm
_nfm_completions() {
  local cur prev opts fonts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD - 1]}"

  # subcommands
  opts="list l install i uninstall u -h --help -v --version"

  case "${prev}" in
  install | i | uninstall | u)
    # completar con la lista de fuentes disponibles o instaladas
    if [[ "${prev}" == "install" || "${prev}" == "i" ]]; then
      fonts="0xProto 3270 AdwaitaMono Agave AnonymousPro Arimo \
        AtkinsonHyperlegibleMono AurulentSansMono BigBlueTerminal \
        BitstreamVeraSansMono IBMPlexMono CascadiaMono CascadiaCode \
        CodeNewRoman ComicShannsMono CommitMono Cousine D2Coding \
        DaddyTimeMono DejaVuSansMono DepartureMono DroidSansMono \
        EnvyCodeR FantasqueSansMono FiraCode FiraMono GeistMono \
        Go-Mono Gohu Hack Hasklig HeavyData Hermit iA-Writer \
        Inconsolata InconsolataGo InconsolataLGC IntelOneMono \
        Iosevka IosevkaTerm IosevkaTermSlab JetBrainsMono Lekton \
        LiberationMono Lilex MartianMono Meslo Monaspace Monofur \
        Monoid Mononoki MPlus Noto OpenDyslexic Overpass \
        ProFont ProggyClean Recursive RobotoMono ShureTechMono \
        SourceCodePro SpaceMono NerdFontsSymbolsOnly Terminus Tinos \
        Ubuntu UbuntuMono UbuntuSans VictorMono ZedMono"
    else
      # para uninstall listar solo las fuentes instaladas actualmente
      fonts="$(nfm list 2>/dev/null | awk '{print $2}')"
    fi
    COMPREPLY=($(compgen -W "${fonts}" -- "${cur}"))
    return 0
    ;;
  esac

  # default: sugerir comandos
  COMPREPLY=($(compgen -W "${opts}" -- "${cur}"))
  return 0
}

complete -F _nfm_completions nfm
