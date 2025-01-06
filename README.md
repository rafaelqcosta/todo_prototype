# **Taski - App de Lista de Tarefas**

## Introdução

Dado o prazo limitado de 3 dias e compromissos pessoais durante esse período, optei por priorizar uma abordagem mais direta e eficiente na implementação deste desafio. O objetivo foi desenvolver um aplicativo funcional e focado nos requisitos principais.

Para simplificar a implementação, optei por não utilizar injeção de dependências, gerenciadores de estado de terceiros ou controladores de rotas personalizados. Além disso, as fontes e cores especificadas no protótipo do Figma foram substituídas por estilos padrão para otimizar o tempo de desenvolvimento.

Embora mensagens de feedback para as ações de CRUD não tenham sido implementadas, a estrutura necessária para incluí-las está pronta, permitindo que sejam adicionadas facilmente em iterações futuras.

O app é offline first, com persistência de dados local utilizando o SQLite, e inclui funcionalidades essenciais como listagem, criação, atualização e exclusão de tarefas.

Algumas escolhas técnicas foram realizadas para priorizar simplicidade e eficiência, como o uso de setState para gerenciamento de estado e a exclusão de dependências complexas, como controladores de rotas personalizados ou injeção de dependências.

---

## **Objetivo**

O app foi projetado para:

- Listar tarefas pendentes com suporte a scroll infinito;
- Listar tarefas finalizadas separadamente;
- Criar novas tarefas e atualizá-las;
- Marcar tarefas como concluídas;
- Excluir tarefas individualmente ou em massa (tarefas concluídas);
- Armazenar todas as tarefas localmente (**offline first**).

---

## **Técnicas e Ferramentas Utilizadas**

### **Arquitetura**

- **MVVM (Model-View-ViewModel):**
  - **Model:** Define os dados da aplicação, como a classe `Todo`, que representa uma tarefa.
  - **ViewModel:** Gerencia o estado e as ações da aplicação, como carregar tarefas, adicionar, editar ou excluir. Utiliza `ChangeNotifier` para notificar alterações de estado às views.
  - **View:** Componentes visuais, como `TodoListScreen`, que interagem com o ViewModel para refletir os dados e ações.

### **Banco de Dados**

- **SQLite (sqflite):**  
  Persistência local foi implementada com SQLite, garantindo armazenamento offline. Um `DatabaseService` foi criado para abstrair operações CRUD no banco.

### **Gerenciamento de Estado**

- **`setState`:**  
  Utilizado em conjunto com o padrão MVVM para atualizar o estado local de widgets.
- **`ChangeNotifier`:**  
  Gerencia o estado compartilhado no ViewModel, notificando as views sobre alterações.

### **Lógica de Negócio**

- **Freezed para imutabilidade:**  
  A biblioteca `freezed` foi utilizada para criar modelos de dados imutáveis, como a classe `Todo`, facilitando cópias seguras com modificações (`copyWith`) e garantindo maior integridade nos dados.
- **Repositórios:**  
  O padrão de repositório (`TodoRepository`) foi implementado para centralizar a lógica de persistência de dados, desacoplando o banco de dados do ViewModel.

### **Navegação**

- **Rotas Simples:**  
  A navegação foi mantida simples, utilizando métodos como `Navigator.push` e `showModalBottomSheet` diretamente. Isso permitiu foco na lógica de negócios e na interface.

### **UI/UX**

- **Flutter Widgets:**

  - `ListView.builder`: Para renderizar listas de tarefas.
  - `ListTile` e `Card`: Para estilização dos itens da lista.
  - **Animações Simples:** Foi implementada uma animação de "piscar" no card ao marcar uma tarefa como concluída, utilizando `AnimationController` e `FadeTransition`.

- **Custom Widgets:**  
  Componentes reutilizáveis, como `TaskiCheckbox` e `OptionsTodoComponent`, foram criados para melhorar a modularidade da interface.

### **Outras Técnicas**

- **Comandos Assíncronos:**  
  A classe `Command` foi criada para encapsular ações assíncronas e facilitar o gerenciamento de estados como “carregando” e “erro” em operações CRUD.
- **Filtros de Tarefas:**  
  As tarefas foram filtradas dinamicamente entre concluídas (`isDone == true`) e pendentes (`isDone == false`) no ViewModel.

---

## **Bibliotecas Utilizadas (Principais)**

1. **`freezed` e `build_runner`:** Para geração de classes imutáveis e métodos auxiliares.
2. **`sqflite`:** Para integração com SQLite.
3. **`path`:** Para manipulação de caminhos no sistema de arquivos.

---

## **Estrutura do Código**

- **`business/`:** Contém o modelo de dados (`Todo`) e as regras de negócios.
- **`data/`:** Contém o serviço de banco de dados (`DatabaseService`) e o repositório (`TodoRepository`).
- **`ui/`:** Contém as telas e componentes visuais, como `TodoListScreen` e `ExpansionTileComponent`.
- **`utils/`:** Utilitários gerais, como `Result` e `Command` para operações assíncronas.

---

## **Limitações**

1. Mensagens de feedback após ações CRUD não foram implementadas, mas a estrutura está pronta para futuras adições.
2. Os estilos de fonte e cores do protótipo do Figma foram simplificados, priorizando funcionalidade.
3. Funcionalidades avançadas, como injeção de dependências ou gerenciadores de estado mais robustos (ex.: `Provider` ou `Riverpod`), foram deixadas de lado para priorizar agilidade.

---

**Obrigado pela oportunidade de participar do desafio!**
