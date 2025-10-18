// import 'package:flutter/material.dart';

// class IntroductionPage extends StatelessWidget {
//   const IntroductionPage({super.key});

//   bool get isWeb => identical(0, 0.0);

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     // Tamanhos adaptativos
//     final titleFontSize = isWeb 
//         ? screenWidth * 0.06
//         : screenWidth * 0.08;

//     final buttonWidth = screenWidth * 0.5;
//     final buttonHeight = screenHeight * 0.07;
//     final buttonFontSize = screenWidth * 0.04;

//     // Tamanhos dos círculos
//     final bigCircleSize = screenWidth * 0.4;
//     final smallCircleSize = screenWidth * 0.2;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           // Círculo grande superior esquerdo
//           Positioned(
//             top: -bigCircleSize * 0.2,
//             left: -bigCircleSize * 0.2,
//             child: Container(
//               width: bigCircleSize,
//               height: bigCircleSize,
//               decoration: BoxDecoration(
//                 gradient: RadialGradient(
//                   colors: [
//                     const Color(0xFFE8F5E8).withOpacity(0.8),
//                     const Color(0xFFC8E6C9).withOpacity(0.4),
//                   ],
//                   stops: const [0.1, 1.0],
//                 ),
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),

//           // Círculo pequeno superior esquerdo
//           Positioned(
//             top: bigCircleSize * 0.3,
//             left: bigCircleSize * 0.1,
//             child: Container(
//               width: smallCircleSize,
//               height: smallCircleSize,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFA5D6A7).withOpacity(0.3),
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),

//           // Círculo grande inferior direito
//           Positioned(
//             bottom: -bigCircleSize * 0.2,
//             right: -bigCircleSize * 0.2,
//             child: Container(
//               width: bigCircleSize,
//               height: bigCircleSize,
//               decoration: BoxDecoration(
//                 gradient: RadialGradient(
//                   colors: [
//                     const Color(0xFFE8F5E8).withOpacity(0.8),
//                     const Color(0xFFC8E6C9).withOpacity(0.4),
//                   ],
//                   stops: const [0.1, 1.0],
//                 ),
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),

//           // Círculo pequeno inferior direito
//           Positioned(
//             bottom: bigCircleSize * 0.3,
//             right: bigCircleSize * 0.1,
//             child: Container(
//               width: smallCircleSize,
//               height: smallCircleSize,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFA5D6A7).withOpacity(0.3),
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),

//           // Conteúdo principal
//           SafeArea(
//             child: Center(
//               child: Container(
//                 constraints: const BoxConstraints(maxWidth: 600),
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Ícone do quebra-cabeça (opcional)
//                     Icon(
//                       Icons.extension,
//                       size: isWeb ? 80 : 60,
//                       color: const Color(0xFF2E7D32).withOpacity(0.7),
//                     ),
                    
//                     const SizedBox(height: 20),
                    
//                     // Título responsivo
//                     Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: SelectableText(
//                         'QUEBRA-CABEÇA ODS',
//                         style: TextStyle(
//                           fontSize: titleFontSize.clamp(24, 60),
//                           fontWeight: FontWeight.w900,
//                           color: const Color(0xFF2E7D32),
//                           letterSpacing: isWeb ? 3.0 : 2.0,
//                           height: 1.2,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
                    
//                     SizedBox(height: screenHeight * 0.05),
                    
//                     // Subtítulo
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: isWeb ? 60.0 : 20.0,
//                       ),
//                       child: Text(
//                         'Junte as peças e descubra os Objetivos de Desenvolvimento Sustentável',
//                         style: TextStyle(
//                           fontSize: isWeb ? 18 : 16,
//                           color: Colors.grey[600],
//                           fontWeight: FontWeight.w400,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
                    
//                     SizedBox(height: screenHeight * 0.08),
                    
//                     // Botão responsivo
//                     SizedBox(
//                       width: buttonWidth.clamp(200, 400),
//                       height: buttonHeight.clamp(50, 80),
//                       child: ElevatedButton(
//                         onPressed: () {
//                           _navigateToGame(context);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF4CAF50),
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           elevation: 8,
//                           shadowColor: Colors.green.withOpacity(0.3),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'INICIAR',
//                               style: TextStyle(
//                                 fontSize: buttonFontSize.clamp(18, 24),
//                                 fontWeight: FontWeight.bold,
//                                 letterSpacing: 1.5,
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             Icon(
//                               Icons.arrow_forward,
//                               size: buttonFontSize.clamp(18, 24) * 0.8,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _navigateToGame(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Em breve: Tela do jogo!'),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'difficulty_selection_page.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  bool get isWeb => identical(0, 0.0);

  void _navigateToDifficultySelection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DifficultySelectionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Tamanhos adaptativos
    final titleFontSize = isWeb 
        ? screenWidth * 0.06
        : screenWidth * 0.08;

    final buttonWidth = screenWidth * 0.5;
    final buttonHeight = screenHeight * 0.07;
    final buttonFontSize = screenWidth * 0.04;

    // Tamanhos dos círculos
    final bigCircleSize = screenWidth * 0.4;
    final smallCircleSize = screenWidth * 0.2;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Círculo grande superior esquerdo
          Positioned(
            top: -bigCircleSize * 0.2,
            left: -bigCircleSize * 0.2,
            child: Container(
              width: bigCircleSize,
              height: bigCircleSize,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFE8F5E8).withOpacity(0.8),
                    const Color(0xFFC8E6C9).withOpacity(0.4),
                  ],
                  stops: const [0.1, 1.0],
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Círculo pequeno superior esquerdo
          Positioned(
            top: bigCircleSize * 0.3,
            left: bigCircleSize * 0.1,
            child: Container(
              width: smallCircleSize,
              height: smallCircleSize,
              decoration: BoxDecoration(
                color: const Color(0xFFA5D6A7).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Círculo grande inferior direito
          Positioned(
            bottom: -bigCircleSize * 0.2,
            right: -bigCircleSize * 0.2,
            child: Container(
              width: bigCircleSize,
              height: bigCircleSize,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFE8F5E8).withOpacity(0.8),
                    const Color(0xFFC8E6C9).withOpacity(0.4),
                  ],
                  stops: const [0.1, 1.0],
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Círculo pequeno inferior direito
          Positioned(
            bottom: bigCircleSize * 0.3,
            right: bigCircleSize * 0.1,
            child: Container(
              width: smallCircleSize,
              height: smallCircleSize,
              decoration: BoxDecoration(
                color: const Color(0xFFA5D6A7).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Conteúdo principal
          SafeArea(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Ícone do quebra-cabeça
                    Icon(
                      Icons.extension,
                      size: isWeb ? 80 : 60,
                      color: const Color(0xFF2E7D32).withOpacity(0.7),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Título responsivo
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SelectableText(
                        'QUEBRA-CABEÇA ODS',
                        style: TextStyle(
                          fontSize: titleFontSize.clamp(24, 60),
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF2E7D32),
                          letterSpacing: isWeb ? 3.0 : 2.0,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.05),
                    
                    // Subtítulo
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWeb ? 60.0 : 20.0,
                      ),
                      child: Text(
                        'Junte as peças dos Objetivos de Desenvolvimento Sustentável',
                        style: TextStyle(
                          fontSize: isWeb ? 18 : 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.08),
                    
                    // Botão responsivo
                    SizedBox(
                      width: buttonWidth.clamp(200, 400),
                      height: buttonHeight.clamp(50, 80),
                      child: ElevatedButton(
                        onPressed: () {
                          _navigateToDifficultySelection(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 8,
                          shadowColor: Colors.green.withOpacity(0.3),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'INICIAR',
                              style: TextStyle(
                                fontSize: buttonFontSize.clamp(18, 24),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward,
                              size: buttonFontSize.clamp(18, 24) * 0.8,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Informações adicionais
                    SizedBox(height: screenHeight * 0.05),
                    
                    // Container(
                    //   padding: const EdgeInsets.all(16),
                    //   decoration: BoxDecoration(
                    //     color: const Color(0xFFE8F5E8),
                    //     borderRadius: BorderRadius.circular(12),
                    //     border: Border.all(
                    //       color: const Color(0xFFC8E6C9),
                    //       width: 1,
                    //     ),
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Icon(
                    //             Icons.eco,
                    //             color: const Color(0xFF2E7D32),
                    //             size: isWeb ? 24 : 20,
                    //           ),
                    //           const SizedBox(width: 8),
                    //           Text(
                    //             '17 Objetivos de Desenvolvimento Sustentável',
                    //             style: TextStyle(
                    //               fontSize: isWeb ? 16 : 14,
                    //               fontWeight: FontWeight.bold,
                    //               color: const Color(0xFF2E7D32),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       const SizedBox(height: 8),
                    //       Text(
                    //         'Complete cada quebra-cabeça e aprenda sobre as ODS da ONU',
                    //         style: TextStyle(
                    //           fontSize: isWeb ? 14 : 12,
                    //           color: Colors.grey[700],
                    //         ),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}