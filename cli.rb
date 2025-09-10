#!/usr/bin/env ruby
require_relative "lib/config"
require_relative "lib/security"
require_relative "lib/interface"
require_relative "lib/context_manager"

chat = MagicWind::Config.setup_gemini

MagicWind::Interface.setup_readline
MagicWind::Interface.show_welcome

loop do
  begin
    input = MagicWind::Interface.read_input
    
    case input
    when nil
      break
    when :exit
      break
    when :help, :empty
      next
    end

    print "🔄 Processando... "
    
    prompt = MagicWind::ContextManager.build_prompt(input)
    response = chat.ask(prompt)
    command = response.content.strip.gsub(/^`|`$/, '').strip
    
    puts "\r"
    
    if MagicWind::Security.dangerous_command?(command)
      MagicWind::Interface.show_security_warning
    else
      if MagicWind::Interface.confirm_execution(command)
        MagicWind::Interface.execute_command(command)
      else
        puts "⏭️  Comando cancelado"
      end
    end
    
    puts
    
  rescue Interrupt
    puts "\n👋 Interrompido pelo usuário"
    break
  rescue => e
    puts "\n❌ Erro: #{e.message}"
  end
end