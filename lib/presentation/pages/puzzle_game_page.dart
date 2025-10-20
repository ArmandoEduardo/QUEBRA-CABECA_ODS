import 'dart:ui' as ui;

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
  int currentODSIndex = 0; 
  List<PuzzlePiece?> boardPieces = [];
  List<PuzzlePiece> availablePieces = [];
  bool isCompleted = false;
  bool _isLoading = true;
  int _lastNumberOfPieces = 0;

  final Map<int, String> odsMap = {
    1: 'assets/ods/ods1.png',
    2: 'assets/ods/ods2.png',
    3: 'assets/ods/ods3.png', 
    4: 'assets/ods/ods4.png',
    6: 'assets/ods/ods6.png', 
    7: 'assets/ods/ods7.png', 
    8: 'assets/ods/ods8.png',
    9: 'assets/ods/ods9.png',
    10: 'assets/ods/ods10.png',
    11: 'assets/ods/ods11.png',
    12: 'assets/ods/ods12.png',
    13: 'assets/ods/ods13.png',
    14: 'assets/ods/ods14.png',
    15: 'assets/ods/ods15.png',
    16: 'assets/ods/ods16.png',
    17: 'assets/ods/ods17.png',
  };

  final Map<int, String> nomeOds = {
    1: 'erradicação da pobreza',
    2: 'Fome Zero e Agricultura Sustentável',
    3: 'Saúde e Bem-Estar',
    4: 'Educação de Qualidade',
    6: 'Água Potável e Saneamento',
    7: 'Energia Limpa e Acessível',
    8: 'Trabalho Decente e Crescimento Econômico',
    9: 'Indústria, inovação e infraestrutura',
    10: 'Redução das desigualdades',
    11: 'Cidades e comunidades sustentáveis',
    12: 'Consumo e produção responsáveis',
    13: 'Ação contra a mudança global do clima',
    14: 'Vida na água',
    15: 'Vida terrestre',
    16: 'Paz, Justiça e Instituições Eficazes',
    17: 'Parcerias e meios de implementação',
  };

  List<int> get availableODSNumbers => odsMap.keys.toList()..sort();

  int get currentODSNumber => availableODSNumbers[currentODSIndex];

  String get currentODSImage => odsMap[currentODSNumber]!;

  String get currentODSName => nomeOds[currentODSNumber] ?? 'ODS $currentODSNumber';

  
  String get nextODSName {
    if (_isLastODS) return 'Final';
    int nextODSNumber = availableODSNumbers[currentODSIndex + 1];
    return nomeOds[nextODSNumber] ?? 'ODS $nextODSNumber';
  }

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() async {
    setState(() {
      _isLoading = true;
    });
    
    await _loadProgressAndLastDifficulty();
    
    final bool isNewDifficulty = _lastNumberOfPieces != widget.numberOfPieces;
    
    if (isNewDifficulty) {
      await _resetToFirstODS();
      await _saveLastDifficulty(widget.numberOfPieces);
    }
    
    _initializePuzzle();
    
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadProgressAndLastDifficulty() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        currentODSIndex = prefs.getInt('currentODSIndex') ?? 0; 
        _lastNumberOfPieces = prefs.getInt('lastNumberOfPieces') ?? 0;
      });
    }
  }

  Future<void> _saveLastDifficulty(int numberOfPieces) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastNumberOfPieces', numberOfPieces);
    if (mounted) {
      setState(() {
        _lastNumberOfPieces = numberOfPieces;
      });
    }
  }

  Future<void> _resetToFirstODS() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentODSIndex', 0); 
    if (mounted) {
      setState(() {
        currentODSIndex = 0;
      });
    }
  }

  void _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentODSIndex', currentODSIndex); 
  }

  void _initializePuzzle() {
    if (!mounted) return;
    
    int gridColumns = _calculateGridColumns();
    
    List<PuzzlePiece> generated = [];
    for (int i = 0; i < widget.numberOfPieces; i++) {
      generated.add(PuzzlePiece(
        id: i,
        correctPosition: i,
        currentPosition: i,
        row: i ~/ gridColumns,
        col: i % gridColumns,
        imagePath: currentODSImage, 
      ));
    }

    generated.shuffle();

    setState(() {
      availablePieces = List.from(generated);
      boardPieces = List.filled(widget.numberOfPieces, null);
      isCompleted = false;
    });
  }

  int _calculateGridColumns() {
    if (widget.numberOfPieces <= 6) {
      return 3;
    } else if (widget.numberOfPieces <= 12) {
      return 4;
    } else if (widget.numberOfPieces <= 15) {
      return 5;
    } else if (widget.numberOfPieces <= 20) {
      return 5;
    } else if (widget.numberOfPieces <= 24) {
      return 6;
    } else if (widget.numberOfPieces <= 30) {
      return 6;
    } else {
      return 7;
    }
  }

  int _calculateGridRows() {
    int columns = _calculateGridColumns();
    return (widget.numberOfPieces / columns).ceil();
  }

  double _calculatePuzzleWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    if (screenWidth < 600) {
      return screenWidth * 0.95;
    }
    
    double maxWidth = screenWidth * 0.6;
    double maxHeight = screenHeight * 0.6;
    
    int gridColumns = _calculateGridColumns();
    int gridRows = _calculateGridRows();
    double aspectRatio = gridColumns / gridRows;
    
    double widthFromHeight = maxHeight * aspectRatio;
    
    return widthFromHeight < maxWidth ? widthFromHeight : maxWidth;
  }

  double _calculatePuzzleHeight(BuildContext context) {
    double puzzleWidth = _calculatePuzzleWidth(context);
    int gridColumns = _calculateGridColumns();
    int gridRows = _calculateGridRows();
    return puzzleWidth * (gridRows / gridColumns);
  }

  double _calculatePieceWidth(BuildContext context) {
    return _calculatePuzzleWidth(context) / _calculateGridColumns();
  }

  double _calculatePieceHeight(BuildContext context) {
    return _calculatePuzzleHeight(context) / _calculateGridRows();
  }

  void _checkCompletion() {
    bool completed = true;
    for (int i = 0; i < boardPieces.length; i++) {
      if (boardPieces[i]?.correctPosition != i) {
        completed = false;
        break;
      }
    }

    if (completed && !boardPieces.contains(null)) {
      setState(() => isCompleted = true);
      _showCompletionDialog();
    }
  }

  bool get _isLastODS {
    return currentODSIndex >= availableODSNumbers.length - 1; 
  }

  
  int get _nextODSNumber {
    if (_isLastODS) return currentODSNumber;
    return availableODSNumbers[currentODSIndex + 1];
  }

  void _goToNextODS() {
    if (_isLastODS) {
      _showGameCompletedDialog();
    } else {
      setState(() {
        currentODSIndex++; 
        isCompleted = false;
      });
      _saveProgress();
      _initializePuzzle();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
              const SizedBox(height: 16),
              
              const Text(
                'Parabéns!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 8),
              
              Text(
                'ODS $currentODSNumber: $currentODSName', 
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              
              Container(
                width: 380,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  currentODSImage, 
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              
              Text(
                'ODS $currentODSNumber Concluído!', 
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_isLastODS)
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showGameCompletedDialog();
                      },
                      child: const Text(
                        'Finalizar Jogo',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _goToNextODS();
                      },
                      child: Text(
                        'Próximo: ODS $_nextODSNumber', 
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGameCompletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Parabéns!'),
        content: const Text('Você completou todos os ODS! Jogo concluído!'),
        actions: [
          TextButton(
            onPressed: () {
              _resetProgressAndReturnToMenu();
            },
            child: const Text('Voltar ao Menu'),
          )
        ],
      ),
    );
  }

  void _resetProgressAndReturnToMenu() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentODSIndex', 0); 
    await prefs.setInt('lastNumberOfPieces', 0);
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _onPieceDraggedFromBoard(PuzzlePiece piece) {
    setState(() {
      for (int i = 0; i < boardPieces.length; i++) {
        if (boardPieces[i]?.id == piece.id) {
          boardPieces[i] = null;
          break;
        }
      }
      availablePieces.add(piece);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('ODS ? - ${widget.numberOfPieces} Peças'),
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
          ),
        ),
      );
    }

    int gridColumns = _calculateGridColumns();
    int gridRows = _calculateGridRows();
    double puzzleWidth = _calculatePuzzleWidth(context);
    double puzzleHeight = _calculatePuzzleHeight(context);
    double pieceWidth = _calculatePieceWidth(context);
    double pieceHeight = _calculatePieceHeight(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('ODS $currentODSNumber - ${widget.numberOfPieces} Peças'), // 🔹 MUDANÇA
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          if (_isLastODS)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.flag, color: Colors.yellow),
            )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWideScreen = constraints.maxWidth > 800;
          
          return isWideScreen ? _buildWideLayout(
            context, 
            puzzleWidth, 
            puzzleHeight, 
            pieceWidth, 
            pieceHeight,
            gridColumns,
            gridRows
          ) : _buildNarrowLayout(
            context, 
            puzzleWidth, 
            puzzleHeight, 
            pieceWidth, 
            pieceHeight,
            gridColumns,
            gridRows
          );
        },
      ),
    );
  }

  Widget _buildWideLayout(
    BuildContext context,
    double puzzleWidth,
    double puzzleHeight,
    double pieceWidth,
    double pieceHeight,
    int gridColumns,
    int gridRows
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Text(
                  'ODS $currentODSNumber - Referência', 
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    currentODSImage, 
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${_isLastODS ? 'Último' : 'Próximo'}: ${_isLastODS ? 'Final' : 'ODS $_nextODSNumber'}', 
                  style: TextStyle(
                    fontSize: 14,
                    color: _isLastODS ? Colors.orange : Colors.grey,
                    fontWeight: _isLastODS ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),

        Expanded(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'ODS $currentODSNumber - Monte o Quebra-Cabeça', 
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: puzzleWidth,
                  height: puzzleHeight,
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                   child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                    scrollbars: false, 
                    overscroll: false,
            ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridColumns,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: boardPieces.length,
                    itemBuilder: (context, index) {
                      return _buildBoardCell(context, index, pieceWidth, pieceHeight, gridColumns, gridRows);
                    },
                  ),
                ),
                ),

              ],
            ),
          ),
        ),

        Expanded(
          flex: 2,
          child: _buildPiecesPanel(context, pieceWidth, pieceHeight, gridColumns, gridRows),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(
    BuildContext context,
    double puzzleWidth,
    double puzzleHeight,
    double pieceWidth,
    double pieceHeight,
    int gridColumns,
    int gridRows
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  'ODS $currentODSNumber - Referência', 
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: puzzleWidth * 0.5,
                  height: puzzleHeight * 0.4,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    currentODSImage, 
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_isLastODS ? 'Último ODS' : 'Próximo: ODS $_nextODSNumber'}', 
                  style: TextStyle(
                    fontSize: 12,
                    color: _isLastODS ? Colors.orange : Colors.grey,
                    fontWeight: _isLastODS ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  'ODS $currentODSNumber - Monte o Quebra-Cabeça', 
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: puzzleWidth,
                  height: puzzleHeight,
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: Colors.grey[300]!),
                  //   borderRadius: BorderRadius.circular(8),
                  // ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridColumns,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: boardPieces.length,
                    itemBuilder: (context, index) {
                      return _buildBoardCell(context, index, pieceWidth, pieceHeight, gridColumns, gridRows);
                    },
                  ),
                ),
              ],
            ),
          ),
          
          Container(
            height: 200,
            child: _buildPiecesPanelMobile(context, pieceWidth, pieceHeight, gridColumns, gridRows),
          ),
        ],
      ),
    );
  }

  Widget _buildBoardCell(
    BuildContext context,
    int index,
    double pieceWidth,
    double pieceHeight,
    int gridColumns,
    int gridRows
  ) {
    final piece = boardPieces[index];
    return DragTarget<PuzzlePiece>(
      onWillAccept: (data) => piece == null,
      onAccept: (received) {
        setState(() {
          boardPieces[index] = received;
          availablePieces.removeWhere((p) => p.id == received.id);
        });
        _checkCompletion();
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            color: candidateData.isNotEmpty
                ? Colors.green[100]
                : (piece == null ? Colors.grey[100] : Colors.white),
          ),
          child: piece == null
              ? 
              Center(
                  // child: Icon(
                  //   Icons.add_circle_outline,
                  //   color: Colors.grey,
                  //   size: pieceWidth * 0.3,
                  // ),
                  child: Icon(
                    Icons.extension, 
                    color: Colors.grey[400],
                    size: pieceWidth * 0.4,
                    ),
                )
              : Draggable<PuzzlePiece>(
                  data: piece,
                  feedback: Material(
                    color: Colors.transparent,
                    child: SizedBox(
                      width: pieceWidth,
                      height: pieceHeight,
                      child: PuzzlePieceWidget(
                        piece: piece,
                        gridColumns: gridColumns,
                        gridRows: gridRows,
                      ),
                    ),
                  ),
                  childWhenDragging: Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(
                        Icons.hourglass_empty,
                        color: Colors.grey,
                        size: pieceWidth * 0.3,
                      ),
                    ),
                  ),
                  onDragStarted: () => _onPieceDraggedFromBoard(piece),
                  child: PuzzlePieceWidget(
                    piece: piece,
                    gridColumns: gridColumns,
                    gridRows: gridRows,
                  ),
                ),
        );
      },
    );
  }

  Widget _buildPiecesPanel(
    BuildContext context,
    double pieceWidth,
    double pieceHeight,
    int gridColumns,
    int gridRows
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'ODS $currentODSNumber - Peças Embaralhadas', 
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: GridView.builder(
              shrinkWrap: false,
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: pieceWidth / pieceHeight,
              ),
              itemCount: availablePieces.length,
              itemBuilder: (context, index) {
                final piece = availablePieces[index];
                return Draggable<PuzzlePiece>(
                  data: piece,
                  feedback: Material(
                    color: Colors.transparent,
                    child: SizedBox(
                      width: pieceWidth,
                      height: pieceHeight,
                      child: PuzzlePieceWidget(
                        piece: piece,
                        gridColumns: gridColumns,
                        gridRows: gridRows,
                      ),
                    ),
                  ),
                  childWhenDragging: Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(
                        Icons.hourglass_empty,
                        color: Colors.grey,
                        size: pieceWidth * 0.3,
                      ),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF2E7D32), width: 2),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green[50],
                    ),
                    child: PuzzlePieceWidget(
                      piece: piece,
                      gridColumns: gridColumns,
                      gridRows: gridRows,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${availablePieces.length} peças disponíveis',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPiecesPanelMobile(
    BuildContext context,
    double pieceWidth,
    double pieceHeight,
    int gridColumns,
    int gridRows
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            'ODS $currentODSNumber - Peças Disponíveis', 
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            constraints: BoxConstraints(
              maxHeight: 150,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: pieceWidth / pieceHeight,
              ),
              itemCount: availablePieces.length,
              itemBuilder: (context, index) {
                final piece = availablePieces[index];
                return Draggable<PuzzlePiece>(
                  data: piece,
                  feedback: Material(
                    color: Colors.transparent,
                    child: SizedBox(
                      width: pieceWidth,
                      height: pieceHeight,
                      child: PuzzlePieceWidget(
                        piece: piece,
                        gridColumns: gridColumns,
                        gridRows: gridRows,
                      ),
                    ),
                  ),
                  childWhenDragging: Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(
                        Icons.hourglass_empty,
                        color: Colors.grey,
                        size: pieceWidth * 0.3,
                      ),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF2E7D32), width: 1),
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.green[50],
                    ),
                    child: PuzzlePieceWidget(
                      piece: piece,
                      gridColumns: gridColumns,
                      gridRows: gridRows,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${availablePieces.length} peças disponíveis',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class PuzzlePieceWidget extends StatefulWidget {
  final PuzzlePiece piece;
  final int gridColumns;
  final int gridRows;

  const PuzzlePieceWidget({
    super.key,
    required this.piece,
    required this.gridColumns,
    required this.gridRows,
  });

  @override
  State<PuzzlePieceWidget> createState() => _PuzzlePieceWidgetState();
}

class _PuzzlePieceWidgetState extends State<PuzzlePieceWidget> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    final imageProvider = AssetImage(widget.piece.imagePath);
    final ImageStream stream = imageProvider.resolve(ImageConfiguration.empty);
    stream.addListener(ImageStreamListener((ImageInfo info, bool _) {
      if (mounted) {
        setState(() {
          _image = info.image;
        });
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null) {
      return Container(
        color: Colors.grey[300],
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return CustomPaint(
      size: const Size.square(double.infinity),
      painter: PuzzlePiecePainter(
        image: _image!,
        gridColumns: widget.gridColumns,
        gridRows: widget.gridRows,
        row: widget.piece.row,
        col: widget.piece.col,
      ),
    );
  }
}

class PuzzlePiecePainter extends CustomPainter {
  final ui.Image image;
  final int gridColumns;
  final int gridRows;
  final int row;
  final int col;

  PuzzlePiecePainter({
    required this.image,
    required this.gridColumns,
    required this.gridRows,
    required this.row,
    required this.col,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double pieceWidth = image.width / gridColumns;
    final double pieceHeight = image.height / gridRows;

    final srcRect = Rect.fromLTWH(
      col * pieceWidth,
      row * pieceHeight,
      pieceWidth,
      pieceHeight,
    );

    final dstRect = Rect.fromLTWH(0, 0, size.width, size.height);

    final paint = Paint()..filterQuality = FilterQuality.high;

    canvas.drawImageRect(image, srcRect, dstRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PuzzlePiece {
  final int id;
  final int correctPosition;
  int currentPosition;
  final int row;
  final int col;
  final String imagePath;

  PuzzlePiece({
    required this.id,
    required this.correctPosition,
    required this.currentPosition,
    required this.row,
    required this.col,
    required this.imagePath,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PuzzlePiece &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}