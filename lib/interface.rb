require "readline"

module MagicWind
  class Interface
    COMPLETION_COMMANDS = [
      "listar arquivos", 
      "mostrar diretório", 
      "criar pasta", 
      "ver conteúdo", 
      "procurar por", 
      "copiar arquivo", 
      "mover arquivo", 
      "deletar arquivo",
      "permissões do arquivo", 
      "espaço em disco", 
      "processos rodando"
    ].freeze

    def self.setup_readline
      Readline.completion_append_character = " "
      Readline.completion_proc = proc do |s|
        COMPLETION_COMMANDS.grep(/^#{Regexp.escape(s)}/i)
      end
    end

    def self.show_welcome
      puts "\n🤖 Magic Wind CLI"
      puts "Digite comandos em linguagem natural e eles serão convertidos em comandos de terminal Unix/Linux"
      puts "Digite 'sair', 'quit' ou 'exit' para encerrar"
      puts "Digite 'ajuda' para ver exemplos"
      puts "💡 Dica: Crie um arquivo 'context.md' para fornecer contexto adicional aos comandos"
      puts "⌨️  Use TAB para autocompletar, setas ↑↓ para histórico\n\n"
    end

    def self.show_help
      puts <<~HELP
        
        📋 Exemplos de comandos:
        • "listar arquivos" → ls
        • "mostrar diretório atual" → pwd
        • "criar pasta teste" → mkdir teste
        • "ver conteúdo do arquivo" → cat arquivo.txt
        • "procurar por texto" → grep "texto" arquivo
        
        💡 Contexto personalizado:
        • Crie um arquivo 'context.md' no diretório atual
        • Adicione informações sobre seu projeto, aliases, caminhos comuns
        • O CLI usará esse contexto para comandos mais precisos
        
      HELP
    end

    def self.read_input
      input = Readline.readline("💬 > ", true)&.strip
      return nil if input.nil?
      
      case input.downcase
      when "sair", "quit", "exit"
        puts "👋 Tchau!"
        return :exit
      when "ajuda", "help"
        show_help
        return :help
      when ""
        return :empty
      else
        return input
      end
    end

    def self.confirm_execution(command)
      puts "✨ Comando: #{command}"
      print "🚀 Executar? (s/N): "
      
      confirm = gets&.strip&.downcase
      confirm == "s" || confirm == "sim" || confirm == "y" || confirm == "yes"
    end

    def self.execute_command(command)
      puts "📋 Executando: #{command}"
      success = system(command)
      puts success ? "✅ Concluído" : "❌ Erro na execução"
    end

    def self.show_security_warning
      puts "🚨 Comando perigoso detectado e bloqueado por segurança!"
      puts "⚠️  Este comando pode ser destrutivo ou inseguro"
    end
  end
end