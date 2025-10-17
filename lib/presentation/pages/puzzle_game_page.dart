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
  int currentODS = 1;
  List<PuzzlePiece?> boardPieces = [];
  List<PuzzlePiece> availablePieces = [];
  bool isCompleted = false;

  final List<String> odsImages = [
    'assets/ods/ods1.png',
    'assets/ods/ods2.png',
    'assets/ods/ods3.png',
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
  }

  void _initializePuzzle() {
    int gridColumns = _calculateGridColumns();
    int gridRows = _calculateGridRows();
    
    List<PuzzlePiece> generated = [];
    for (int i = 0; i < widget.numberOfPieces; i++) {
      generated.add(PuzzlePiece(
        id: i,
        correctPosition: i,
        currentPosition: i,
        row: i ~/ gridColumns,
        col: i % gridColumns,
        imagePath: odsImages[currentODS - 1],
      ));
    }

    generated.shuffle();

    setState(() {
      availablePieces = List.from(generated);
      boardPieces = List.filled(widget.numberOfPieces, null);
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
      return 6;
    }
  }

  int _calculateGridRows() {
    int columns = _calculateGridColumns();
    return (widget.numberOfPieces / columns).ceil();
  }

  double _calculatePuzzleWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Para mobile, usa quase toda a largura
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

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Parabéns!'),
        content: Text('Você completou o ODS $currentODS!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pop(context);
            },
            child: const Text('Voltar ao Menu'),
          )
        ],
      ),
    );
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
    int gridColumns = _calculateGridColumns();
    int gridRows = _calculateGridRows();
    double puzzleWidth = _calculatePuzzleWidth(context);
    double puzzleHeight = _calculatePuzzleHeight(context);
    double pieceWidth = _calculatePieceWidth(context);
    double pieceHeight = _calculatePieceHeight(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('ODS $currentODS - ${widget.numberOfPieces} Peças ($gridColumns x $gridRows)'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
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
        // 🔹 Lado esquerdo: imagem de referência
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                const Text(
                  'Referência',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: puzzleWidth * 0.9,
                  height: puzzleHeight * 0.9,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    odsImages[currentODS - 1],
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),

        // 🔹 Meio: área de montagem
        Expanded(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Monte o Quebra-Cabeça',
                  style: TextStyle(
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
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
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
        ),

        // 🔹 Lado direito: peças embaralhadas
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
    return SingleChildScrollView( // 🔹 BARRA DE ROLAGEM ADICIONADA
      child: Column(
        children: [
          // Imagem de referência (bem menor em mobile)
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                const Text(
                  'Referência',
                  style: TextStyle(
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
                    odsImages[currentODS - 1],
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          
          // Área de montagem
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                const Text(
                  'Monte o Quebra-Cabeça',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: puzzleWidth,
                  height: puzzleHeight,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
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
          
          // Peças embaralhadas
          Container(
            height: 200, // 🔹 ALTURA FIXA PARA O PAINEL DE PEÇAS
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
              ? Center(
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Colors.grey,
                    size: pieceWidth * 0.3,
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
    return SingleChildScrollView( // 🔹 BARRA DE ROLAGEM ADICIONADA
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Peças Embaralhadas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6, // 🔹 ALTURA MÁXIMA
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(), // 🔹 PERMITE ROLAGEM
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
    return SingleChildScrollView( // 🔹 BARRA DE ROLAGEM ADICIONADA
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Text(
              'Peças Disponíveis',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              constraints: BoxConstraints(
                maxHeight: 150, // 🔹 ALTURA MÁXIMA PARA MOBILE
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(), // 🔹 PERMITE ROLAGEM
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