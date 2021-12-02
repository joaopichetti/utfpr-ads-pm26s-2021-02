import 'package:flutter/material.dart';
import 'package:test_api/model/cep.dart';
import 'package:test_api/services/cep_service.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ConsultaCepFragment extends StatefulWidget {
  static const title = 'Buscar CEP';

  @override
  State<StatefulWidget> createState() => _ConsultaCepFragmentState();
}

class _ConsultaCepFragmentState extends State<ConsultaCepFragment> {
  final _service = CepService();
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _loading = false;
  final _cepFormatter = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {'#': RegExp(r'[0-9]')}
  );
  Cep? _cep;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'CEP',
                suffixIcon: _loading ? const Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ) : IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _findCep,
                ),
              ),
              inputFormatters: [_cepFormatter],
              validator: (String? value) {
                if (value == null || value.isEmpty || !_cepFormatter.isFill()) {
                  return 'Informe um CEP válido';
                }
                return null;
              },
            ),
          ),
          Container(height: 10),
          ..._buildResultWidgets(),
        ],
      ),
    );
  }

  Future<void> _findCep() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _loading = true;
    });
    try {
      _cep = await _service.findCepAsObject(_cepFormatter.getUnmaskedText());
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Ocorreu um erro ao consultar o CEP. Tente novamente.'),
      ));
    }
    setState(() {
      _loading = false;
    });
  }

  List<Widget> _buildResultWidgets() {
    final List<Widget> widgets = [];
    if (_cep != null) {
      final map = _cep!.toJson();
      for (final key in map.keys) {
        widgets.add(Text('$key: ${map[key]}'));
      }
    }
    return widgets;
  }

}