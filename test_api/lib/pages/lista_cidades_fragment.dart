import 'package:flutter/material.dart';
import 'package:test_api/model/cidade.dart';
import 'package:test_api/services/cidade_service.dart';

class ListaCidadesFragment extends StatefulWidget {
  static const title = 'Cidades';

  @override
  State<StatefulWidget> createState() => _ListaCidadesFragmentState();
}

class _ListaCidadesFragmentState extends State<ListaCidadesFragment> {
  final _service = CidadeService();
  final List<Cidade> _cidades = [];
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: LayoutBuilder(
        builder: (_, constraints) {
          Widget content;
          if (_cidades.isEmpty) {
            content = SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: const Center(
                  child: Text('Nenhuma cidade cadastrada'),
                ),
              ),
            );
          } else {
            content = ListView.separated(
              itemCount: _cidades.length,
              itemBuilder: (_, index) {
                final cidade = _cidades[index];
                return ListTile(
                  title: Text('${cidade.nome} - ${cidade.uf}'),
                );
              },
              separatorBuilder: (_, __) => const Divider(),
            );
          }
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            child: content,
            onRefresh: _findCidades,
          );
        },
      ),
    );
  }

  Future<void> _findCidades() async {
    await Future.delayed(Duration(seconds: 2));
    final cidades = await _service.findCidades();
    setState(() {
      _cidades.clear();
      if (cidades.isNotEmpty) {
        _cidades.addAll(cidades);
      }
    });
  }

}