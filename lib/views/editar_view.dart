import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/receita.dart';
import '../viewmodels/receitas_viewmodel.dart';

class EditarView extends StatefulWidget {
  final Receita? receita;

  const EditarView({super.key, this.receita});

  @override
  State<EditarView> createState() => _EditarViewState();
}

class _EditarViewState extends State<EditarView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _descricaoController;
  late TextEditingController _modoPreparoController;
  late TextEditingController _ingredienteController;
  late String _categoria;
  late List<String> _ingredientes;
  late TextEditingController _imagemController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.receita?.titulo ?? '');
    _descricaoController = TextEditingController(text: widget.receita?.descricao ?? '');
    _modoPreparoController = TextEditingController(text: widget.receita?.modoPreparo ?? '');
    _ingredienteController = TextEditingController();
    _imagemController = TextEditingController(text: widget.receita?.imagem ?? '');
    _categoria = widget.receita?.categoria ?? 'doce';
    _ingredientes = widget.receita?.ingredientes.toList() ?? [];
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _modoPreparoController.dispose();
    _ingredienteController.dispose();
    _imagemController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final viewModel = context.read<ReceitasViewModel>();
    final receita = Receita(
      id: widget.receita?.id ?? 0,
      titulo: _tituloController.text,
      descricao: _descricaoController.text,
      ingredientes: _ingredientes,
      modoPreparo: _modoPreparoController.text,
      categoria: _categoria,
      isFavorite: widget.receita?.isFavorite ?? false,
      imagem: _imagemController.text.isEmpty ? null : _imagemController.text,
    );

    try {
      Receita? result;
      if (widget.receita == null) {
        result = await viewModel.adicionarReceita(receita);
      } else {
        result = await viewModel.atualizarReceita(receita);
      }
      if (mounted) {
        Navigator.pop(context, result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar receita: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _adicionarIngrediente() {
    final ingrediente = _ingredienteController.text.trim();
    if (ingrediente.isNotEmpty) {
      setState(() {
        _ingredientes.add(ingrediente);
        _ingredienteController.clear();
      });
    }
  }

  void _removerIngrediente(int index) {
    setState(() {
      _ingredientes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receita == null ? 'Nova Receita' : 'Editar Receita'),
        actions: [
          if (widget.receita != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Confirmar exclusão'),
                    content: Text('Deseja realmente excluir "${widget.receita!.titulo}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('Excluir'),
                      ),
                    ],
                  ),
                );

                if (confirm != true) return;

                final viewModel = context.read<ReceitasViewModel>();
                final receitaToDelete = widget.receita!;

                int? originalIndex;
                switch (receitaToDelete.categoria.toLowerCase()) {
                  case 'doce':
                    originalIndex = viewModel.doces.indexWhere((r) => r.id == receitaToDelete.id);
                    break;
                  case 'salgada':
                    originalIndex = viewModel.salgadas.indexWhere((r) => r.id == receitaToDelete.id);
                    break;
                  case 'bebida':
                    originalIndex = viewModel.bebidas.indexWhere((r) => r.id == receitaToDelete.id);
                    break;
                }

                viewModel.startPendingDeletion(receitaToDelete, originalIndex == -1 ? null : originalIndex);

                late final ScaffoldFeatureController<SnackBar, SnackBarClosedReason> controller;

                final snack = SnackBar(
                  content: Text('${receitaToDelete.titulo} excluída'),
                  action: SnackBarAction(
                    label: 'Desfazer',
                    onPressed: () {
                      viewModel.undoPendingDeletion(receitaToDelete.id);
                      controller.close();
                    },
                  ),
                );

                controller = ScaffoldMessenger.of(context).showSnackBar(snack);

                controller.closed.then((reason) async {
                  if (reason != SnackBarClosedReason.action) {
                    await viewModel.finalizePendingDeletion(receitaToDelete.id);
                  }
                });

                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _tituloController,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um título';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descricaoController,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma descrição';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _categoria,
                    decoration: const InputDecoration(
                      labelText: 'Categoria',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'doce', child: Text('Doce')),
                      DropdownMenuItem(value: 'salgada', child: Text('Salgada')),
                      DropdownMenuItem(value: 'bebida', child: Text('Bebida')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _categoria = value;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, selecione uma categoria';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ingredientes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _ingredienteController,
                                  decoration: const InputDecoration(
                                    labelText: 'Novo ingrediente',
                                    border: OutlineInputBorder(),
                                  ),
                                  onFieldSubmitted: (_) => _adicionarIngrediente(),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: _adicionarIngrediente,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (_ingredientes.isEmpty)
                            const Text(
                              'Nenhum ingrediente adicionado',
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _ingredientes.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  dense: true,
                                  title: Text(_ingredientes[index]),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: () => _removerIngrediente(index),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _modoPreparoController,
                    decoration: const InputDecoration(
                      labelText: 'Modo de Preparo',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o modo de preparo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _imagemController,
                    decoration: const InputDecoration(
                      labelText: 'URL da Imagem (opcional)',
                      border: OutlineInputBorder(),
                      helperText: 'Deixe em branco para usar o padrão',
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _salvar,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Salvar Receita'),
                  ),
                ],
              ),
            ),
    );
  }
}
