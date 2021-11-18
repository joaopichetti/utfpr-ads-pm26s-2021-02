import 'dart:io';

import 'package:cadastro_contatos/dao/contato_dao.dart';
import 'package:cadastro_contatos/model/contato.dart';
import 'package:cadastro_contatos/pages/camera_page.dart';
import 'package:cadastro_contatos/widgets/visualizador_imagem.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

class FormContatoPage extends StatefulWidget {
  static const imagem = 'imagem';
  static const video = 'video';

  final Contato? contato;

  const FormContatoPage({Key? key, this.contato}) : super(key: key);

  @override
  _FormContatoPageState createState() => _FormContatoPageState();
}

class _FormContatoPageState extends State<FormContatoPage> {
  final _formKey = GlobalKey<FormState>();
  final _dao = ContatoDao();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneFormatter = MaskTextInputFormatter(
    mask: '(##) ?####-####',
    filter: {'#': RegExp(r'[0-9]'), '?': RegExp(r'[0-9]?')},
  );
  var _salvando = false;
  late String _tipoImagem;
  String? _caminhoImagem;
  String? _caminhoVideo;
  final _picker = ImagePicker();
  VideoPlayerController? _videoPlayerController;
  bool _reproduzindoVideo = false;

  @override
  void initState() {
    super.initState();
    if (widget.contato != null) {
      _nomeController.text = widget.contato!.nome;
      _telefoneController.text = widget.contato!.telefone ?? '';
      _emailController.text = widget.contato!.email ?? '';
      _tipoImagem = widget.contato!.tipoImagem;
      _caminhoImagem = widget.contato!.caminhoImagem;
      _caminhoVideo = widget.contato!.caminhoVideo;
    } else {
      _tipoImagem = Contato.tipoImagemAssets;
    }
    _inicializarVideoPlayerController();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
    );
  }

  AppBar _criarAppBar() {
    final String title;
    if (widget.contato == null) {
      title = 'Novo Contato';
    } else {
      title = 'Alterar Contato';
    }
    final Widget titleWidget;
    if (_salvando) {
      titleWidget = Row(
        children: [
          Expanded(
            child: Text(title),
          ),
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
        ],
      );
    } else {
      titleWidget = Text(title);
    }
    return AppBar(
      title: titleWidget,
      actions: [
        if (!_salvando)
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _salvar,
          ),
      ],
    );
  }

  Widget _criarBody() {
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                  ),
                  controller: _nomeController,
                  validator: (String? valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Informe o nome';
                    }
                    return null;
                  },
                  readOnly: _salvando,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Telefone',
                  ),
                  controller: _telefoneController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [_telefoneFormatter],
                  readOnly: _salvando,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                  ),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: _salvando,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text('Tipo da Imagem'),
                ),
                DropdownButton(
                  value: _tipoImagem,
                  items: Contato.tiposPermitidos
                      .map((tipoImagem) => DropdownMenuItem(
                            value: tipoImagem,
                            child: Text(Contato.getTipoImagemLabel(tipoImagem)),
                          ))
                      .toList(),
                  isExpanded: true,
                  onChanged: (String? novoValor) {
                    if (novoValor?.isNotEmpty == true) {
                      setState(() {
                        _tipoImagem = novoValor!;
                      });
                    }
                  },
                ),
                if (_tipoImagem == Contato.tipoImagemFile) ...[
                  ElevatedButton(
                    child: const Text('Obter da Galeria'),
                    onPressed: () => _usarImagePicker(
                        ImageSource.gallery, FormContatoPage.imagem),
                  ),
                  ElevatedButton(
                    child: const Text('Usar câmera interna'),
                    onPressed: () => _usarCamera(FormContatoPage.imagem),
                  ),
                  ElevatedButton(
                    child: const Text('Usar câmera externa'),
                    onPressed: () => _usarImagePicker(
                        ImageSource.camera, FormContatoPage.imagem),
                  ),
                ],
                VisualizadorImagem(
                  tipoImagem: _tipoImagem,
                  caminhoImagem: _caminhoImagem,
                  size: constraints.maxWidth,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text('Vídeo'),
                ),
                ElevatedButton(
                  child: const Text('Obter da Galeria'),
                  onPressed: () => _usarImagePicker(
                      ImageSource.gallery, FormContatoPage.video),
                ),
                ElevatedButton(
                  child: const Text('Usar câmera interna'),
                  onPressed: () => _usarCamera(FormContatoPage.video),
                ),
                ElevatedButton(
                  child: const Text('Usar câmera externa'),
                  onPressed: () => _usarImagePicker(
                      ImageSource.camera, FormContatoPage.video),
                ),
                _criarWidgetVideo(),
                if (_videoPlayerController != null)
                  ElevatedButton(
                    child: Icon(_videoPlayerController!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow),
                    onPressed: _iniciarPararVideo,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _salvar() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    final novoContato = Contato(
      id: widget.contato?.id,
      nome: _nomeController.text,
      telefone: _telefoneController.text,
      email: _emailController.text,
      tipoImagem: _tipoImagem,
      caminhoImagem: _caminhoImagem,
      caminhoVideo: _caminhoVideo,
    );
    setState(() {
      _salvando = true;
    });
    await _dao.salvar(novoContato);
    setState(() {
      _salvando = false;
    });
    Navigator.of(context).pop(true);
  }

  Future<void> _usarImagePicker(ImageSource origem, String tipo) async {
    XFile? arquivo;
    if (tipo == FormContatoPage.imagem) {
      arquivo = await _picker.pickImage(source: origem);
    } else {
      arquivo = await _picker.pickVideo(source: origem);
    }
    if (arquivo == null) {
      return;
    }
    return _tratarArquivo(arquivo, tipo);
  }

  Future<void> _tratarArquivo(XFile arquivo, String tipo) async {
    final diretorioBase = await getApplicationDocumentsDirectory();
    final idArquivo = Uuid().v1();
    var caminho = '${diretorioBase.path}/$idArquivo' +
        (tipo == FormContatoPage.imagem ? '.jpg' : '.mp4');
    await arquivo.saveTo(caminho);
    if (tipo == FormContatoPage.imagem) {
      setState(() {
        _caminhoImagem = caminho;
      });
    } else {
      _caminhoVideo = caminho;
      await _inicializarVideoPlayerController();
    }
  }

  Future<void> _usarCamera(String tipo) async {
    final arquivo = await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CameraPage(tipo: tipo),
    ));
    if (arquivo == null) {
      return;
    }
    return _tratarArquivo(arquivo, tipo);
  }

  Future<void> _inicializarVideoPlayerController() async {
    if (_caminhoVideo == null || _caminhoVideo!.isEmpty) {
      return;
    }
    if (_videoPlayerController != null) {
      await _videoPlayerController!.dispose();
      _videoPlayerController = null;
    }
    final arquivoVideo = File(_caminhoVideo!);
    _videoPlayerController = VideoPlayerController.file(arquivoVideo);
    _videoPlayerController!.addListener(() {
      if (_reproduzindoVideo && !_videoPlayerController!.value.isPlaying) {
        setState(() {});
      }
    });
    await _videoPlayerController!.initialize();
    setState(() {});
  }

  Widget _criarWidgetVideo() {
    if (_videoPlayerController == null ||
        !_videoPlayerController!.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
      aspectRatio: _videoPlayerController!.value.aspectRatio,
      child: VideoPlayer(_videoPlayerController!),
    );
  }

  void _iniciarPararVideo() {
    setState(() {
      if (_videoPlayerController!.value.isPlaying) {
        _videoPlayerController!.pause();
        _reproduzindoVideo = false;
      } else {
        _videoPlayerController!.play();
        _reproduzindoVideo = true;
      }
    });
  }
}
