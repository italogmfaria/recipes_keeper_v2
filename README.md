# Recipes Keeper

O Recipes Keeper é um aplicativo Flutter para gerenciar e organizar receitas pessoais. O objetivo do projeto é oferecer uma experiência simples para navegar por receitas por categoria, visualizar instruções completas, adicionar/editar/remover receitas e marcar favoritas.

Este projeto foi desenvolvido como atividade para a disciplina de Programação Avançada II e demonstra conceitos de Flutter como navegação por abas, gerenciamento de estado com `provider` e arquitetura MVVM.

## Principais Funcionalidades

- Navegação por categoria: Doces, Salgadas e Bebidas.
- Barra de navegação inferior (`BottomNavigationBar`) para trocar entre categorias e favoritos.
- Lista de receitas por categoria exibida em cards.
- Cada card mostra:
  - Título da receita
  - Ícone/imagem ilustrativa
  - Descrição resumida (uma linha / subtítulo)
  - Toque no card para ver detalhes ou editar (conforme o fluxo)
- Tela de detalhes com:
  - Título (no `AppBar` e no corpo)
  - Imagem ilustrativa
  - Descrição completa
  - Lista de ingredientes
  - Modo de preparo
  - Botão Voltar
- Inserir nova receita:
  - Floating Action Button (FAB) que abre a tela de cadastro.
- Editar receita:
  - Ao tocar em um card (ou botão de editar), abre tela de edição com dados preenchidos.
  - Permite salvar alterações.
- Remover receita:
  - Permite remover deslizando o card (`Dismissible`).
  - Ao remover, mostra `SnackBar` com opção de desfazer (undo).
- Favoritos:
  - Marcar/desmarcar receitas como favoritas; existe uma aba dedicada a favoritos.

## Requisitos (resumo da atividade)

- Manter as 3 categorias: Doces, Salgadas e Bebidas.
- Cada aba exibe lista de receitas em Cards.
- Ao tocar em um Card, abrir uma nova página com detalhes.
- A tela de detalhes deve conter título (AppBar + corpo), imagem, descrição completa, ingredientes, modo de preparo e botão voltar.
- FAB para cadastrar nova receita.
- Editar receita existente (tela com dados preenchidos).
- Remover com `Dismissible` e `SnackBar` com desfazer.

## Arquitetura — MVVM (Model-View-ViewModel)

O projeto segue MVVM para separar responsabilidades e facilitar manutenção/testes.

- Model: representa os dados (classe `Receita`).
  - `lib/models/receita.dart`
- Service: abstrai a fonte de dados.
  - `lib/services/receitas_service.dart` — carrega dados de `assets/db.json`.
- ViewModel: mantém o estado e lógica de negócio, notifica a UI.
  - `lib/viewmodels/receitas_viewmodel.dart` (e `categoria_viewmodel.dart` quando aplicável)
  - Utiliza `ChangeNotifier` e é consumido via `provider`.
- View: widgets que compõem a UI.
  - `lib/views/home_view.dart` — tela principal com `BottomNavigationBar`.
  - `lib/views/detalhes_view.dart` — detalhes da receita.
  - `lib/views/editar_view.dart` — edição/cadastro de receita.
  - `lib/views/favoritos_view.dart` — lista de favoritas.
  - `lib/views/settings_view.dart`, `lib/views/sobre_view.dart`
- Widgets reutilizáveis:
  - `lib/widgets/receita_card.dart` — card de receita (toque/gestos, Dismissible).
  - `lib/widgets/categoria_tabs.dart`
- Shared:
  - `lib/shared/app_drawer.dart` — menu lateral (drawer).

## Estrutura (resumida)

```
lib/
├── models/
│   └── receita.dart
├── services/
│   └── receitas_service.dart
├── shared/
│   └── app_drawer.dart
├── viewmodels/
│   ├── categoria_viewmodel.dart
│   └── receitas_viewmodel.dart
├── views/
│   ├── detalhes_view.dart
│   ├── editar_view.dart
│   ├── favoritos_view.dart
│   ├── home_view.dart
│   ├── settings_view.dart
│   └── sobre_view.dart
├── widgets/
│   ├── categoria_tabs.dart
│   └── receita_card.dart
└── main.dart
assets/
└── db.json
```

## Arquivos importantes

- `lib/models/receita.dart`: define/ajusta campos como `id`, `titulo`, `descricao`, `ingredientes`, `modoPreparo`, `categoria`, `isFavorite`, `imagem`.
- `lib/services/receitas_service.dart`: leitura/escrita em `assets/db.json` (ou abstração que permite persistência futura).
- `lib/viewmodels/receitas_viewmodel.dart`: lógica para listar por categoria, adicionar, editar, remover, alternar favorito (`toggleFavorito`), e desfazer remoção (armazena item removido temporariamente para SnackBar).
- `lib/widgets/receita_card.dart`: envolve com `Dismissible`, comportamento de swipe para excluir, e chama `ScaffoldMessenger.of(context).showSnackBar(...)` com ação de desfazer.
- `lib/views/detalhes_view.dart`: exibi todos os campos requisitados; usa `AppBar` com título e `Leading` para voltar (ou `Navigator.pop`).
- `lib/views/editar_view.dart`: formulário para criar/atualizar receita (preencher campos ao editar).

## Como Executar o Projeto

1.  **Clone o repositório:**
    ```bash
    git clone <repository-url>
    ```
2.  **Navegue até o diretório do projeto:**
    ```bash
    cd recipes_keeper
    ```
3.  **Instale as dependências:**
    ```bash
    flutter pub get
    ```
4.  **Execute o aplicativo:**
    ```bash
    flutter run
    ```