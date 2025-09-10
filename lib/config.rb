require "ruby_llm"
require "dotenv/load"

module MagicWind
  class Config
    SYSTEM_INSTRUCTIONS = <<~INSTRUCTIONS
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

    def self.setup_gemini
      validate_api_key!
      configure_ruby_llm!
      create_chat_instance
    end

    private

    def self.validate_api_key!
      if ENV['GOOGLE_API_KEY'].nil? || ENV['GOOGLE_API_KEY'].empty?
        puts "⚠️  GOOGLE_API_KEY não encontrada no arquivo .env"
        puts "Opsss é necessário adicionar sua chave da API do Google Gemini no arquivo .env"
        exit 1
      end
    end

    def self.configure_ruby_llm!
      RubyLLM.configure do |config|
        config.gemini_api_key = ENV['GOOGLE_API_KEY']
      end
    rescue => e
      puts "❌ Erro na configuração: #{e.message}"
      exit 1
    end

    def self.create_chat_instance
      base_chat = RubyLLM.chat(model: "gemini-2.5-flash")
      chat = base_chat.with_instructions(SYSTEM_INSTRUCTIONS).with_temperature(0.2)
      puts "✅ Conectado ao modelo: Gemini 2.5 Flash"
      chat
    rescue => error
      puts "❌ Erro ao conectar com Gemini: #{error.message}"
      exit 1
    end
  end
end