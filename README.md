# Magic Wind CLI

Uma ferramenta de linha de comando que converte instruções em linguagem natural (português) para comandos Unix/Linux usando IA.

## 🚀 Sobre

O Magic Wind CLI utiliza Google Gemini 2.5 Flash para interpretar comandos em português e convertê-los em comandos Unix/Linux equivalentes, com um sistema robusto de segurança para prevenir execução de comandos perigosos.

## 🛠️ Pré-requisitos

- Ruby instalado
- Conta Google Cloud com API Key do Gemini
- Sistema Unix/Linux ou macOS

## 📦 Instalação

1. Clone o repositório:
```bash
git clone git@github.com:carloshendvpm/magic_wind_terminal.git
cd magic_wind_terminal
```

2. Instale as dependências:
```bash
bundle install
```

3. Configure a API Key do Google:
```bash
echo "GOOGLE_API_KEY=api_key_aqui" > .env
```

## 🎯 Como Usar

Execute o CLI:
```bash
ruby cli.rb
```

### Exemplos de Comandos

| Você fala | CLI executa |
|-----------|-------------|
| "listar arquivos" | `ls` |
| "mostrar diretório atual" | `pwd` |
| "criar pasta teste" | `mkdir teste` |
| "ver conteúdo do arquivo config.txt" | `cat config.txt` |
| "encontrar arquivos .rb" | `find . -name "*.rb"` |

### Comandos Especiais

- `ajuda` ou `help` - Mostra exemplos de uso
- `sair`, `quit` ou `exit` - Encerra o programa
- `Ctrl+C` - Interrupção graceful

### 💡 Contexto Personalizado

O CLI suporta contexto personalizado para comandos mais precisos:

1. **Crie um arquivo `context.md`** no diretório atual
2. **Adicione informações relevantes** como:
   - Aliases e comandos customizados
   - Caminhos comuns utilizados
   - Configurações específicas do ambiente

**Exemplo de `context.md`:**
```markdown
# Contexto do Projeto

## Estrutura
- src/ - código fonte
- tests/ - testes automatizados
- docs/ - documentação

## Aliases comuns
- ll = ls -la
- gst = git status

## Caminhos importantes
- Logs: /var/log/myapp/
- Config: ~/.config/myapp/
```

### ⌨️ Recursos de Interface

- **Autocompletar**: Use `TAB` para sugestões de comandos comuns
- **Histórico**: Use setas `↑` `↓` para navegar no histórico de comandos
- **Comandos sugeridos**: "listar arquivos", "mostrar diretório", "criar pasta", etc.

## 🔒 Segurança

O CLI possui proteção contra comandos perigosos, bloqueando automaticamente:

- Remoção de arquivos críticos (`rm` com wildcards/caminhos absolutos)
- Comandos de formatação (`dd`, `format`, `fdisk`, `mkfs`)
- Reinicialização do sistema (`shutdown`, `reboot`)
- Fork bombs e processos maliciosos
- Modificação de arquivos do sistema (`/etc/passwd`, `/etc/shadow`)
- Downloads com execução direta

## 🏗️ Arquitetura

- **Linguagem**: Ruby
- **IA**: Google Gemini 2.5 Flash (via gem `ruby_llm`)
- **Configuração**: Arquivo `.env` para variáveis sensíveis
- **Validação**: Sistema de regex para comandos perigosos

## 📁 Estrutura do Projeto

```
magic_wind_cli/
├── cli.rb          # Arquivo principal
├── Gemfile         # Dependências Ruby
├── .env            # Variáveis de ambiente (não versionado)
├── .gitignore      # Arquivos ignorados
└── README.md       # Este arquivo
```

## 🤝 Contribuindo

1. Sempre priorize segurança ao adicionar novos padrões
2. Mantenha compatibilidade com sistemas Unix/Linux
3. Use português nas mensagens do usuário
4. Teste comandos de validação antes de implementar

## ⚠️ Aviso

Esta ferramenta executa comandos no seu sistema. Mesmo com proteções de segurança, sempre revise os comandos antes de confirmá-los.
