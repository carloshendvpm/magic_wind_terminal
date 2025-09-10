module MagicWind
  class ContextManager
    def self.load_context
      return "" unless File.exist?("context.md")
      File.read("context.md")
    end

    def self.build_prompt(input, context = nil)
      context ||= load_context
      
      if context.empty?
        input
      else
        <<~PROMPT
          Contexto do projeto:
          #{context}

          Instrução: #{input}
        PROMPT
      end
    end
  end
end