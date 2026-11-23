import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const Aula07PreferenciasApp());
}

class Aula07PreferenciasApp extends StatelessWidget {
  const Aula07PreferenciasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aula 07 - SharedPreferences',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const ConfiguracoesScreen(),
    );
  }
}

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({super.key});

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  static const String _keyTamanhoFonte = 'tamanho_fonte';
  static const String _keyNotificacoes = 'receber_notificacoes';

  String _tamanhoFonte = 'Médio';
  bool _receberNotificacoes = true;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
  }

  Future<void> _carregarPreferencias() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _tamanhoFonte = prefs.getString(_keyTamanhoFonte) ?? 'Médio';
      _receberNotificacoes = prefs.getBool(_keyNotificacoes) ?? true;
      _carregando = false;
    });
  }

  // Exercicio 02: Salva o tamanho da fonte (Pequeno, Medio, Grande)
  Future<void> _salvarTamanhoFonte(String novoTamanho) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTamanhoFonte, novoTamanho);
    setState(() {
      _tamanhoFonte = novoTamanho;
    });
  }

  // Exercicio 03: Salva o estado do switch de notificacoes (bool)
  Future<void> _salvarNotificacoes(bool ativo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificacoes, ativo);
    setState(() {
      _receberNotificacoes = ativo;
    });
  }

  // Exercicio 01: Apaga todas as chaves gravadas usando prefs.clear()
  Future<void> _limparConfiguracoes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      _tamanhoFonte = 'Médio';
      _receberNotificacoes = true;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todas as configurações foram apagadas (prefs.clear()).'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  double get _fontSizeAplicado {
    switch (_tamanhoFonte) {
      case 'Pequeno':
        return 13.0;
      case 'Grande':
        return 21.0;
      case 'Médio':
      default:
        return 16.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double tamanhoTexto = _fontSizeAplicado;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferências Locais - Aula 07'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Card de pre-visualizacao aplicando o tamanho da fonte escolhido
                  Card(
                    color: Colors.indigo.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.indigo.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pré-visualização do Texto ($_tamanhoFonte)',
                            style: TextStyle(
                              fontSize: tamanhoTexto + 2,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Este texto ajusta seu tamanho dinamicamente e permanece salvo no dispositivo via SharedPreferences mesmo após recarregar o app.',
                            style: TextStyle(fontSize: tamanhoTexto, height: 1.4),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Notificações: ${_receberNotificacoes ? "Ativadas" : "Desativadas"}',
                            style: TextStyle(
                              fontSize: tamanhoTexto,
                              fontWeight: FontWeight.w600,
                              color: _receberNotificacoes
                                  ? Colors.green.shade800
                                  : Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Exercicio 02: Seletor de tamanho da fonte
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tamanho da Fonte',
                            style: TextStyle(
                              fontSize: tamanhoTexto + 1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(
                                value: 'Pequeno',
                                label: Text('Pequeno'),
                                icon: Icon(Icons.text_fields, size: 16),
                              ),
                              ButtonSegment(
                                value: 'Médio',
                                label: Text('Médio'),
                                icon: Icon(Icons.text_fields, size: 20),
                              ),
                              ButtonSegment(
                                value: 'Grande',
                                label: Text('Grande'),
                                icon: Icon(Icons.text_fields, size: 24),
                              ),
                            ],
                            selected: {_tamanhoFonte},
                            onSelectionChanged: (Set<String> selecao) {
                              _salvarTamanhoFonte(selecao.first);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Exercicio 03: Switch de Receber Notificacoes
                  Card(
                    elevation: 2,
                    child: SwitchListTile(
                      title: Text(
                        'Receber Notificações',
                        style: TextStyle(
                          fontSize: tamanhoTexto,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Mantém o estado booleano persistido no disco',
                        style: TextStyle(fontSize: tamanhoTexto - 2),
                      ),
                      secondary: Icon(
                        _receberNotificacoes
                            ? Icons.notifications_active
                            : Icons.notifications_off,
                        color: Colors.indigo,
                      ),
                      value: _receberNotificacoes,
                      onChanged: _salvarNotificacoes,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Exercicio 01: Botao Limpar Configuracoes com prefs.clear()
                  OutlinedButton.icon(
                    onPressed: _limparConfiguracoes,
                    icon: const Icon(Icons.delete_sweep, color: Colors.red),
                    label: const Text(
                      'Limpar Configurações',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
