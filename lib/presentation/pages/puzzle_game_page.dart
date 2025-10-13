import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PuzzleGamePage extends StatefulWidget {
  final int numberOfPieces;
  
  const PuzzleGamePage({
    super.key,
    required this.numberOfPieces,
  });

  @override
  State<PuzzleGamePage> createState() => _PuzzleGamePageState();
}

class _PuzzleGamePageState extends State<PuzzleGamePage> {
  int currentODS = 1;
  List<PuzzlePiece> pieces = [];
  bool isCompleted = false;
  
  // Lista de imagens dos ODS (você precisará adicionar estas imagens no projeto)
  final List<String> odsImages = [
    'assets/ods/ods1.png',
    'assets/ods/ods2.png',
    'assets/ods/ods3.png',
    // ... adicione todas as 17 imagens
    'assets/ods/ods17.png',
  ];

  @override
  void initState() {
    super.initState();
    _loadProgress();
    _initializePuzzle();
  }

  void _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentODS = prefs.getInt('currentODS') ?? 1;
    });
  }

  void _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentODS', currentODS);
    await prefs.setInt('${currentODS}_pieces', widget.numberOfPieces);
  }

  void _initializePuzzle() {
    // Embaralha as peças do quebra-cabeça
    pieces = _generatePuzzlePieces();
    _shufflePieces();
  }

  List<PuzzlePiece> _generatePuzzlePieces() {
    List<PuzzlePiece> generatedPieces = [];
    int gridSize = _calculateGridSize();
    
    for (int i = 0; i < widget.numberOfPieces; i++) {
      generatedPieces.add(PuzzlePiece(
        id: i,
        correctPosition: i,
        currentPosition: i,
        row: i ~/ gridSize,
        col: i % gridSize,
      ));
    }
    
    return generatedPieces;
  }

  int _calculateGridSize() {
    return (widget.numberOfPieces == 6) ? 3 : 
           (widget.numberOfPieces == 10) ? 4 :
           (widget.numberOfPieces == 14) ? 4 :
           (widget.numberOfPieces == 18) ? 5 : 5;
  }

  void _shufflePieces() {
    setState(() {
      pieces.shuffle();
      for (int i = 0; i < pieces.length; i++) {
        pieces[i].currentPosition = i;
      }
    });
  }

  void _checkCompletion() {
    bool completed = true;
    for (var piece in pieces) {
      if (piece.currentPosition != piece.correctPosition) {
        completed = false;
        break;
      }
    }
    
    if (completed) {
      setState(() {
        isCompleted = true;
      });
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Parabéns!'),
          content: Text('Você completou o ODS $currentODS!'),
          actions: [
            if (currentODS < 17)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _nextODS();
                },
                child: const Text('Próximo ODS'),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: const Text('Voltar ao Menu'),
            ),
          ],
        );
      },
    );
  }

  void _nextODS() {
    setState(() {
      currentODS++;
      isCompleted = false;
      _saveProgress();
      _initializePuzzle();
    });
  }

  void _swapPieces(int index1, int index2) {
    setState(() {
      final tempPos = pieces[index1].currentPosition;
      pieces[index1].currentPosition = pieces[index2].currentPosition;
      pieces[index2].currentPosition = tempPos;
      
      final tempPiece = pieces[index1];
      pieces[index1] = pieces[index2];
      pieces[index2] = tempPiece;
    });
    
    _checkCompletion();
    _saveProgress();
  }

  @override
  Widget build(BuildContext context) {
    final gridSize = _calculateGridSize();
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('ODS $currentODS - ${widget.numberOfPieces} Peças'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _shufflePieces,
            tooltip: 'Embaralhar',
          ),
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            tooltip: 'Voltar ao Início',
          ),
        ],
      ),
      body: Column(
        children: [
          // Imagem de referência
          Container(
            padding: const EdgeInsets.all(16),
            child: Image.asset(
              odsImages[currentODS - 1],
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
          
          // Grid do quebra-cabeça
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemCount: pieces.length,
                itemBuilder: (context, index) {
                  final piece = pieces[index];
                  return GestureDetector(
                    onTap: () {
                      // Lógica para mover peças (simplificada)
                      // Você pode implementar drag & drop para melhor experiência
                      _swapPieces(index, (index + 1) % pieces.length);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: Colors.green[100],
                      ),
                      child: Center(
                        child: Text(
                          '${piece.correctPosition + 1}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Barra de progresso
          Container(
            padding: const EdgeInsets.all(16),
            child: LinearProgressIndicator(
              value: currentODS / 17,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
            ),
          ),
          Text(
            'Progresso: $currentODS/17',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class PuzzlePiece {
  final int id;
  final int correctPosition;
  int currentPosition;
  final int row;
  final int col;

  PuzzlePiece({
    required this.id,
    required this.correctPosition,
    required this.currentPosition,
    required this.row,
    required this.col,
  });
}