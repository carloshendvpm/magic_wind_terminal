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
  base_chat = RubyLLM.chat(model: "gemini-2.5-flash")
  
  system_instructions = <<~INSTRUCTIONS
    Você é um assistente especializado em converter comandos em linguagem natural (português) 
    para comandos Unix/Linux válidos e seguros.

    REGRAS IMPORTANTES:
    - Responda SEMPRE apenas com o comando, sem explicações
    - Use comandos seguros e não destrutivos
    - Para listagem de arquivos, prefira 'ls -la' 
    - Para busca de texto, use 'grep -r' quando apropriado
    - Se não souber o comando exato, sugira a alternativa mais segura
    - NUNCA use comandos como 'rm -rf /', 'dd', 'format', ou outros destrutivos
    - Prefira comandos que não modificam o sistema permanentemente
    
    Exemplos:
    - "listar arquivos" → ls -la
    - "procurar arquivo" → find . -name
    - "ver conteúdo" → cat
    - "criar diretório" → mkdir
  INSTRUCTIONS
  
  chat = base_chat.with_instructions(system_instructions).with_temperature(0.2)
  puts "✅ Conectado ao modelo: Gemini 2.5 Flash"
rescue => error
  puts "❌ Erro ao conectar com Gemini: #{error.message}"
  exit 1
end

puts "\n🤖 Magic Wind CLI"
puts "Digite comandos em linguagem natural e eles serão convertidos em comandos de terminal Unix/Linux"
puts "Digite 'sair', 'quit' ou 'exit' para encerrar"
puts "Digite 'ajuda' para ver exemplos"
puts "💡 Dica: Crie um arquivo 'context.md' para fornecer contexto adicional aos comandos\n\n"

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
        
        💡 Contexto personalizado:
        • Crie um arquivo 'context.md' no diretório atual
        • Adicione informações sobre seu projeto, aliases, caminhos comuns
        • O CLI usará esse contexto para comandos mais precisos
        
      HELP
      next
    when ""
      next
    end

    print "🔄 Processando... "
    
    context = ""
    if File.exist?("context.md")
      context = File.read("context.md")
    end

    prompt = if context.empty?
      "#{input}"
    else
      <<~PROMPT
        Contexto do projeto:
        #{context}

        Instrução: #{input}
      PROMPT
    end

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
