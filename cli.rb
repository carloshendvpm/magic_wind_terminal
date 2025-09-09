#!/usr/bin/env ruby
require "ruby_llm"
require "dotenv/load"

begin
  RubyLLM.configure do |config|
    config.gemini_api_key = ENV['GOOGLE_API_KEY']
  end
rescue => e
  puts "Erro na configuração: #{e.message}"
  exit 1
end

if ENV['GOOGLE_API_KEY'].nil? || ENV['GOOGLE_API_KEY'].empty?
  puts "⚠️  GOOGLE_API_KEY não encontrada no arquivo .env"
  puts "Opsss é necessário adicionar sua chave da API do Google Gemini no arquivo .env"
  exit 1
end

begin
  chat = RubyLLM.chat(model: "gemini-2.5-flash")
  puts "✅ Conectado ao Gemini 2.5 Flash"
rescue => error
  puts "❌ Erro ao conectar com Gemini: #{error.message}"
  exit 1
end

puts "\n🤖 Magic Wind CLI"
puts "Digite comandos em linguagem natural e eles serão convertidos em comandos de terminal Unix/Linux"
puts "Digite 'sair', 'quit' ou 'exit' para encerrar"
puts "Digite 'ajuda' para ver exemplos\n\n"

loop do
  print "💬 > "
  
  begin
    input = gets&.strip
    break if input.nil? 
    
    case input.downcase
    when "sair", "quit", "exit"
      puts "👋 Tchau!"
      break
    when "ajuda", "help"
      puts <<~HELP
        
        📋 Exemplos de comandos:
        • "listar arquivos" → ls
        • "mostrar diretório atual" → pwd
        • "criar pasta teste" → mkdir teste
        • "ver conteúdo do arquivo" → cat arquivo.txt
        • "procurar por texto" → grep "texto" arquivo
        
      HELP
      next
    when ""
      next
    end

    print "🔄 Processando... "
    
    prompt = <<~PROMPT
      Converta a instrução em português abaixo em um comando de terminal Unix/Linux válido.
      Responda APENAS com o comando, sem explicações ou texto adicional:
      
      "#{input}"
    PROMPT

    response = chat.ask(prompt)
    command = response.content.strip.gsub(/^`|`$/, '').strip
    
    puts "\r✨ Comando: #{command}"
    print "🚀 Executar? (s/N): "
    
    confirm = gets&.strip&.downcase
    if confirm == "s" || confirm == "sim" || confirm == "y" || confirm == "yes"
      puts "📋 Executando: #{command}"
      success = system(command)
      puts success ? "✅ Concluído" : "❌ Erro na execução"
    else
      puts "⏭️  Comando cancelado"
    end
    
    puts
    
  rescue Interrupt
    puts "\n👋 Interrompido pelo usuário"
    break
  rescue => e
    puts "\n❌ Erro: #{e.message}"
  end
end
