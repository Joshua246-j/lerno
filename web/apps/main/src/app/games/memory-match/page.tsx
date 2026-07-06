"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { useAudio } from "@/hooks/useAudio";
import { X, Trophy, RefreshCcw, Coins } from "lucide-react";
import confetti from "canvas-confetti";
import { motion } from "framer-motion";

const ICONS = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼"];

interface Card {
  id: number;
  icon: string;
  isFlipped: boolean;
  isMatched: boolean;
}

export default function MemoryMatchPage() {
  const router = useRouter();
  const { play } = useAudio();
  
  const [gameState, setGameState] = useState<"idle" | "playing" | "gameover">("idle");
  const [cards, setCards] = useState<Card[]>([]);
  const [flippedIndices, setFlippedIndices] = useState<number[]>([]);
  const [score, setScore] = useState(0);
  const [moves, setMoves] = useState(0);

  const initGame = () => {
    const shuffled = [...ICONS, ...ICONS]
      .sort(() => Math.random() - 0.5)
      .map((icon, id) => ({ id, icon, isFlipped: false, isMatched: false }));
    setCards(shuffled);
    setGameState("playing");
    setScore(0);
    setMoves(0);
    setFlippedIndices([]);
    play("click");
  };

  const handleCardClick = (index: number) => {
    if (flippedIndices.length === 2 || cards[index].isFlipped || cards[index].isMatched) return;

    play("click");
    const newCards = [...cards];
    newCards[index].isFlipped = true;
    setCards(newCards);

    const newFlipped = [...flippedIndices, index];
    setFlippedIndices(newFlipped);

    if (newFlipped.length === 2) {
      setMoves(prev => prev + 1);
      const [first, second] = newFlipped;
      
      if (cards[first].icon === cards[second].icon) {
        // Match
        setTimeout(() => {
          play("correct");
          const matchedCards = [...cards];
          matchedCards[first].isMatched = true;
          matchedCards[second].isMatched = true;
          setCards(matchedCards);
          setFlippedIndices([]);
          setScore(prev => prev + 20);
          
          if (matchedCards.every(c => c.isMatched)) {
            setGameState("gameover");
            play("victory");
            confetti({ particleCount: 150, spread: 70, origin: { y: 0.6 } });
          }
        }, 500);
      } else {
        // No match
        setTimeout(() => {
          play("wrong");
          const resetCards = [...cards];
          resetCards[first].isFlipped = false;
          resetCards[second].isFlipped = false;
          setCards(resetCards);
          setFlippedIndices([]);
        }, 1000);
      }
    }
  };

  return (
    <div className="min-h-screen bg-[#F8F9FE] flex flex-col md:items-center md:justify-center">
      
      {/* Top Bar */}
      <div className="absolute top-0 w-full p-4 flex justify-between items-center z-20">
        <button onClick={() => router.back()} className="p-2 bg-white rounded-full shadow-sm">
          <X className="w-6 h-6 text-gray-600" />
        </button>
      </div>

      <div className="flex-1 flex flex-col w-full max-w-md mx-auto relative pt-16 px-6 pb-6 h-full justify-center">
        
        {gameState === "idle" && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="text-center">
            <div className="w-32 h-32 mx-auto mb-6 bg-purple-100 rounded-full flex items-center justify-center shadow-lg">
              <span className="text-6xl">🎭</span>
            </div>
            <h1 className="text-4xl font-extrabold text-gray-900 mb-2">Memory Match</h1>
            <p className="text-gray-500 mb-8">Flip the cards and find all the matching pairs with the fewest moves!</p>
            <button onClick={initGame} className="w-full h-16 bg-[#8B5CF6] hover:bg-[#7C3AED] text-white rounded-2xl text-2xl font-bold shadow-[0_8px_0_#5B21B6] active:translate-y-2 active:shadow-none transition-all">
              PLAY NOW
            </button>
          </motion.div>
        )}

        {gameState === "playing" && (
          <div className="flex flex-col h-full">
            {/* HUD */}
            <div className="flex justify-between items-center mb-8">
              <div className="bg-white px-4 py-2 rounded-2xl shadow-sm flex items-center gap-2">
                <Trophy className="w-5 h-5 text-yellow-400 fill-yellow-400" />
                <span className="font-bold text-lg">{score}</span>
              </div>
              <div className="bg-white px-4 py-2 rounded-2xl shadow-sm font-bold text-gray-600 text-sm">
                Moves: {moves}
              </div>
              <button onClick={initGame} className="bg-white p-2 rounded-xl shadow-sm text-gray-400 hover:text-gray-800">
                <RefreshCcw className="w-5 h-5" />
              </button>
            </div>

            {/* Board */}
            <div className="grid grid-cols-4 gap-3 w-full max-w-[400px] mx-auto">
              {cards.map((card, i) => (
                <motion.button
                  key={card.id}
                  onClick={() => handleCardClick(i)}
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                  className="aspect-square relative flex items-center justify-center text-4xl"
                  style={{ perspective: 1000 }}
                >
                  <motion.div
                    className="w-full h-full relative"
                    initial={false}
                    animate={{ rotateY: card.isFlipped || card.isMatched ? 180 : 0 }}
                    transition={{ duration: 0.4, type: "spring" }}
                    style={{ transformStyle: "preserve-3d" }}
                  >
                    {/* Front of card (hidden) */}
                    <div 
                      className="absolute w-full h-full bg-white rounded-2xl border-4 border-purple-100 shadow-md flex items-center justify-center backface-hidden"
                      style={{ backfaceVisibility: "hidden" }}
                    >
                      <span className="text-purple-300 font-black">?</span>
                    </div>
                    {/* Back of card (revealed) */}
                    <div 
                      className={`absolute w-full h-full rounded-2xl shadow-inner flex items-center justify-center backface-hidden border-4 ${card.isMatched ? 'bg-green-100 border-green-200' : 'bg-purple-50 border-purple-200'}`}
                      style={{ backfaceVisibility: "hidden", transform: "rotateY(180deg)" }}
                    >
                      {card.icon}
                    </div>
                  </motion.div>
                </motion.button>
              ))}
            </div>
          </div>
        )}

        {gameState === "gameover" && (
          <motion.div initial={{ scale: 0.9, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} className="text-center bg-white p-8 rounded-[3rem] shadow-xl">
            <h2 className="text-4xl font-black text-gray-900 mb-6">You Won!</h2>
            
            <div className="bg-gray-50 rounded-3xl p-6 mb-8 flex flex-col items-center gap-4 border border-gray-100">
              <span className="text-gray-500 font-bold uppercase tracking-widest text-sm">Score</span>
              <span className="text-6xl font-black text-purple-500">{score}</span>
              <span className="text-gray-400 font-bold text-sm">in {moves} moves</span>
              
              <div className="w-full h-px bg-gray-200 my-2"></div>
              
              <div className="flex justify-between w-full font-bold">
                <span className="text-gray-500">Coins Earned</span>
                <span className="text-green-500 flex items-center gap-1"><Coins className="w-4 h-4" /> +{Math.max(10, 50 - moves)}</span>
              </div>
            </div>

            <div className="flex flex-col gap-3">
              <button onClick={initGame} className="w-full h-16 bg-[#8B5CF6] hover:bg-[#7C3AED] text-white rounded-2xl text-xl font-bold shadow-[0_6px_0_#5B21B6] active:translate-y-1 active:shadow-none transition-all">
                PLAY AGAIN
              </button>
              <button onClick={() => router.push("/games")} className="w-full h-16 bg-gray-100 hover:bg-gray-200 text-gray-600 rounded-2xl text-xl font-bold transition-all">
                EXIT
              </button>
            </div>
          </motion.div>
        )}

      </div>
    </div>
  );
}
