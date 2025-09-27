# Recipes Keeper

O Recipes Keeper é um aplicativo Flutter desenvolvido para ajudar os usuários a gerenciar e organizar suas receitas favoritas. O aplicativo permite que os usuários naveguem por receitas por categoria, visualizem instruções detalhadas e marquem suas favoritas para acesso rápido.

Este projeto foi desenvolvido como uma atividade para a disciplina de Programação Avançada II, com foco na implementação de conceitos-chave do Flutter, como navegação por abas, gerenciamento de estado e padrões de arquitetura.

## Principais Funcionalidades

-   **Navegação por Categoria:** As receitas são organizadas em três categorias principais: Doces, Salgadas e Bebidas.
-   **Navegação por Abas:** Uma barra de navegação inferior amigável permite a troca fácil entre as categorias de receitas e a seção de favoritos.
-   **Visualização Detalhada da Receita:** Tocar em um card de receita abre uma visualização detalhada com descrição, ingredientes e modo de preparo.
-   **Receitas Favoritas:** Os usuários podem marcar qualquer receita como favorita, que aparecerá em uma aba dedicada de "Favoritos".
-   **Menu Lateral (Drawer):** Um menu lateral fornece acesso a seções adicionais do aplicativo, como "Configurações" e "Sobre".

## Arquitetura: MVVM (Model-View-ViewModel)

O projeto foi estruturado seguindo a arquitetura **MVVM (Model-View-ViewModel)** para garantir uma separação clara de responsabilidades, tornando a base de código mais escalável, manutenível e testável.

### Model (Modelo)

O Modelo representa os dados e a lógica de negócio da aplicação.

-   **`lib/models/receita.dart`**: Define a classe `Receita`, que é a estrutura de dados para uma receita, incluindo campos como `id`, `titulo`, `descricao`, `ingredientes`, `modoPreparo`, `categoria` e `isFavorite`.

### View (Visão)

A Visão é responsável pela interface do usuário (UI) e por exibir os dados ao usuário. Ela observa o ViewModel em busca de mudanças de estado e se atualiza de acordo.

-   **`lib/views/home_view.dart`**: A tela principal do aplicativo, que contém a `BottomNavigationBar` e hospeda as abas de categoria e a visão de favoritos.
-   **`lib/views/detalhes_view.dart`**: Exibe os detalhes completos de uma receita selecionada.
-   **`lib/views/favoritos_view.dart`**: Mostra uma lista de todas as receitas que foram marcadas como favoritas.
-   **`lib/widgets/`**: Contém componentes de UI reutilizáveis, como `ReceitaCard` e `CategoriaTabs`.

### ViewModel

O ViewModel atua como uma ponte entre o Modelo e a Visão. Ele detém o estado da aplicação e a lógica de negócio, expondo os dados para a Visão e tratando as interações do usuário.

-   **`lib/viewmodels/receitas_viewmodel.dart`**: Este é o núcleo da implementação do MVVM.
    -   Utiliza `ChangeNotifier` para notificar a UI sobre quaisquer mudanças de estado.
    -   A UI é conectada a este ViewModel usando o pacote `provider`, que escuta as mudanças e reconstrói os widgets relevantes.
    -   Ele busca os dados do `ReceitasService` e os prepara para exibição na Visão.
    -   Contém a lógica para alternar o status de favorito de uma receita (`toggleFavorito`).

### Service (Serviço)

Para separar ainda mais as responsabilidades, uma camada de serviço é usada para lidar com a busca de dados.

-   **`lib/services/receitas_service.dart`**: Responsável por carregar os dados das receitas do arquivo local `assets/db.json`. Isso abstrai a fonte de dados do ViewModel.

## Estrutura do Projeto

```
lib/
├── models/
│   └── receita.dart
├── services/
│   └── receitas_service.dart
├── shared/
│   └── app_drawer.dart
├── viewmodels/
│   └── receitas_viewmodel.dart
├── views/
│   ├── detalhes_view.dart
│   ├── favoritos_view.dart
│   ├── home_view.dart
│   ├── settings_view.dart
│   └── sobre_view.dart
├── widgets/
│   ├── categoria_tabs.dart
│   └── receita_card.dart
├── main.dart
assets/
└── db.json
```

## Dependências

-   **`provider`**: Usado para o gerenciamento de estado e para implementar a conexão entre o ViewModel e a Visão.

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
