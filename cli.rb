#!/usr/bin/env ruby
require "ruby_llm"
require "dotenv/load"

RubyLLM.configure do |config|
  config.gemini_api_key = ENV['GOOGLE_API_KEY']
end

chat = RubyLLM.chat(model: "gemini-2.5-flash")

puts "Digite o que você quer executar (ou 'sair' para encerrar):"

loop do
  print "> "
  input = gets.strip
  break if input.downcase == "sair"

  prompt = <<~PROMPT
    Converta a instrução abaixo em um comando de terminal válido (sem explicação, apenas o comando):
    "#{input}"
  PROMPT

  response = chat.ask(prompt)

  command = response.strip
  puts "Executando: #{command}"

  system(command)
end