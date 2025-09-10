module MagicWind
  class Security
    DANGEROUS_PATTERNS = [
      /\brm\s+(-[rf]+\s+)?\//, # rm com caminho absoluto
      /\brm\s+(-[rf]+\s+)?\*/, # rm com wildcard
      /\brm\s+(-[rf]+\s+)?\.\*/, # rm com padrão perigoso
      /\bdd\s/, # comando dd
      /\b(sudo\s+)?rm\s+(-[rf]+\s+)?\//,  # sudo rm
      />\s*\/dev\/sd[a-z]/, # redirecionamento para dispositivos
      /\bformat\b/, # comando format
      /\bfdisk\b/, # fdisk
      /\bmkfs\b/, # mkfs
      /\b:\s*\(\)\s*\{.*\}\s*;/, # fork bomb
      /\bkill(all)?\s+(-9\s+)?-1/, # kill -1
      /\bshutdown\b/, # shutdown
      /\breboot\b/, # reboot
      /\binit\s+0/, # init 0
      /\b(wget|curl).*(\\||;|&&)/, # download e execução
      /\bchmod\s+777/, # chmod 777 perigoso
      /\bchown.*root/, # mudança para root
      /etc\/passwd/, # modificação de arquivos críticos
      /etc\/shadow/,
      /proc\/.*\/mem/,
      /\bmv\s+.*\/etc/, # mover arquivos para /etc
      /\bcp\s+.*\/etc/  # copiar arquivos para /etc
    ].freeze

    def self.dangerous_command?(command)
      DANGEROUS_PATTERNS.any? { |pattern| command.match?(pattern) }
    end
  end
end