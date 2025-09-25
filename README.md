# recipes_keeper
Atividade 4 da Matéria de Programação Avançada II

App de Receitas Favoritas
Objetivo:

Desenvolver um aplicativo Flutter para gerenciar receitas, aplicando a navegação por abas e entre telas

Metodologia do app:
Imagine que você está criando um aplicativo de receitas. A experiência do usuário deve ser intuitiva, permitindo que ele explore diferentes categorias de pratos e salve seus favoritos.

Seu aplicativo precisa de uma tela principal que sirva como um ponto de partida. Nesta tela, o usuário terá acesso a três categorias principais de receitas: Doces, Salgadas e Bebidas. A transição entre essas categorias deve ser fluida, usando abas que ficam visíveis na parte inferior da tela.

Cada aba (Doces, Salgadas e Bebidas) mostrará uma seleção de três receitas. Cada receita será representada por um Card que, ao ser tocado, levará o usuário para uma nova tela com os detalhes completos daquele prato.

Detalhes sobre Card: https://api.flutter.dev/flutter/material/Card-class.html

Ao chegar na tela de detalhes, o usuário deve encontrar o título da receita e, abaixo, uma breve descrição, lista de ingredientes e o modo de preparo. A partir daqui, ele terá a opção de voltar para a tela principal, retornando exatamente à aba de onde partiu.

Para completar a experiência, o aplicativo deve ter um menu lateral, o Drawer, acessível por um ícone de menu no canto superior. Esse menu não é para navegação entre receitas, mas sim para funções gerais do aplicativo. Ele deve conter ícones para 'Configurações' e 'Sobre', que, ao serem clicados, levam o usuário para telas que exibem informações. Para voltar à tela principal com as abas, você deve usar a seta de "voltar" e/ou o botão de "voltar" do seu dispositivo.