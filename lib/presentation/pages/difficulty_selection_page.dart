import 'package:flutter/material.dart';
import 'puzzle_game_page.dart';

class DifficultySelectionPage extends StatelessWidget {
  const DifficultySelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<int> pieceOptions = [6, 10, 14, 18, 22];
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = identical(0, 0.0);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Círculos de fundo (similar à introduction page)
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFE8F5E8).withOpacity(0.6),
                    const Color(0xFFC8E6C9).withOpacity(0.3),
                  ],
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFE8F5E8).withOpacity(0.6),
                    const Color(0xFFC8E6C9).withOpacity(0.3),
                  ],
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Ícone
                    Icon(
                      Icons.extension,
                      size: isWeb ? 80 : 60,
                      color: const Color(0xFF2E7D32),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Título
                    Text(
                      'Selecionar Dificuldade',
                      style: TextStyle(
                        fontSize: isWeb ? 32 : 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2E7D32),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Descrição
                    Text(
                      'Escolha quantas peças terá o seu quebra-cabeça',
                      style: TextStyle(
                        fontSize: isWeb ? 16 : 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Botões de dificuldade
                    Column(
                      children: pieceOptions.asMap().entries.map((entry) {
                        final index = entry.key;
                        final pieces = entry.value;
                        final colors = [
                          const Color(0xFF4CAF50), // Verde
                          const Color(0xFF8BC34A), // Verde claro
                          const Color(0xFFCDDC39), // Lima
                          const Color(0xFFFFC107), // Âmbar
                          const Color(0xFFFF9800), // Laranja
                        ];
                        
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ElevatedButton(
                            onPressed: () {
                              _startGame(context, pieces);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors[index % colors.length],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                              shadowColor: colors[index % colors.length].withOpacity(0.3),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _getDifficultyIcon(pieces),
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '$pieces Peças',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _getDifficultyText(pieces),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Botão voltar
                    SizedBox(
                      width: screenWidth * 0.4,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2E7D32),
                          side: const BorderSide(
                            color: Color(0xFF2E7D32),
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Voltar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getDifficultyIcon(int pieces) {
    switch (pieces) {
      case 6:
        return Icons.child_care;
      case 10:
        return Icons.school;
      case 14:
        return Icons.work;
      case 18:
        return Icons.engineering;
      case 22:
        return Icons.emoji_events;
      default:
        return Icons.extension;
    }
  }

  String _getDifficultyText(int pieces) {
    switch (pieces) {
      case 6:
        return 'FÁCIL';
      case 10:
        return 'INICIANTE';
      case 14:
        return 'INTERMEDIÁRIO';
      case 18:
        return 'DESAFIADOR';
      case 22:
        return 'EXPERT';
      default:
        return 'PADRÃO';
    }
  }

  void _startGame(BuildContext context, int pieces) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PuzzleGamePage(
          numberOfPieces: pieces,
        ),
      ),
    );
  }
}