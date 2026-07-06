"use client";

import { useState, useEffect } from "react";
import { ChevronLeft, Swords, Trophy, Coins, User } from "lucide-react";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { useAudio } from "@/hooks/useAudio";
import { useAuth } from "@/features/auth/hooks/useAuth";
import { motion, AnimatePresence } from "framer-motion";
import confetti from "canvas-confetti";

type BattleState = "idle" | "matchmaking" | "active" | "results";

const QUESTIONS = [
  { q: "5 x 6 = ?", a: 30, o: [30, 25, 36, 11] },
  { q: "12 + 15 = ?", a: 27, o: [27, 25, 29, 21] },
  { q: "8 x 4 = ?", a: 32, o: [32, 24, 36, 28] },
  { q: "20 - 7 = ?", a: 13, o: [13, 17, 15, 11] },
  { q: "100 / 10 = ?", a: 10, o: [10, 100, 1, 5] },
];

export default function BattlePage() {
  const router = useRouter();
  const { play, stop } = useAudio();
  const { user } = useAuth();
  
  const [gameState, setGameState] = useState<BattleState>("idle");
  const [playerHP, setPlayerHP] = useState(100);
  const [opponentHP, setOpponentHP] = useState(100);
  const [qIndex, setQIndex] = useState(0);
  
  // Start Matchmaking
  const findMatch = () => {
    play("click");
    setGameState("matchmaking");
    setTimeout(() => {
      setGameState("active");
      play("correct"); // found sound
    }, 3000);
  };

  // Bot logic
  useEffect(() => {
    let botTimer: NodeJS.Timeout;
    if (gameState === "active" && playerHP > 0 && opponentHP > 0) {
      // Bot attacks every 3-6 seconds
      const nextAttack = Math.floor(Math.random() * 3000) + 3000;
      botTimer = setTimeout(() => {
        setPlayerHP(prev => Math.max(0, prev - 25));
        play("wrong"); // sound to indicate taking damage
      }, nextAttack);
    }
    return () => clearTimeout(botTimer);
  }, [gameState, opponentHP, playerHP]);

  // Win/Loss Condition
  useEffect(() => {
    if (gameState === "active") {
      if (opponentHP <= 0 || playerHP <= 0) {
        setGameState("results");
        if (opponentHP <= 0) {
          play("victory");
          confetti({ particleCount: 200, spread: 90, origin: { y: 0.6 } });
        } else {
          // loss sound
        }
      }
    }
  }, [playerHP, opponentHP, gameState]);

  const handleAnswer = (selected: number) => {
    const currentQ = QUESTIONS[qIndex % QUESTIONS.length];
    if (selected === currentQ.a) {
      play("correct");
      setOpponentHP(prev => Math.max(0, prev - 25));
    } else {
      play("wrong");
    }
    setQIndex(prev => prev + 1);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-indigo-900 via-purple-900 to-indigo-950 flex flex-col pb-24 text-white overflow-hidden relative">
      
      {/* Dynamic Background */}
      <div className="absolute inset-0 z-0 opacity-20 pointer-events-none">
        <div className="absolute top-1/4 left-1/4 w-96 h-96 bg-blue-500 rounded-full blur-[100px] animate-pulse"></div>
        <div className="absolute bottom-1/4 right-1/4 w-96 h-96 bg-red-500 rounded-full blur-[100px] animate-pulse delay-1000"></div>
      </div>

      <div className="p-4 flex items-center gap-4 relative z-10">
        <button onClick={() => router.back()} className="p-2 bg-white/10 rounded-full text-white hover:bg-white/20 transition-colors">
          <ChevronLeft className="w-6 h-6" />
        </button>
        <h1 className="text-xl font-bold flex items-center gap-2">
          <Swords className="text-yellow-400 w-6 h-6" /> Arena Battle
        </h1>
      </div>

      <div className="flex-1 flex flex-col items-center justify-center px-6 text-center relative z-10 w-full max-w-lg mx-auto mt-[-40px]">
        
        {/* Avatars Top Section (Always visible except results) */}
        {gameState !== "results" && (
          <div className="relative w-full flex items-center justify-between mb-8">
            {/* Player */}
            <div className="flex flex-col items-center w-1/3">
              <div className="w-20 h-20 bg-blue-500 rounded-full border-4 border-white shadow-[0_0_30px_rgba(59,130,246,0.6)] flex items-center justify-center relative">
                 <img src={`https://api.dicebear.com/7.x/bottts/svg?seed=${user?.avatarId || 'player'}&backgroundColor=transparent`} className="w-14 h-14" />
                 {gameState === "active" && (
                   <div className="absolute -bottom-3 w-20 h-4 bg-gray-900 rounded-full overflow-hidden border border-white/50">
                     <motion.div className="h-full bg-green-500" initial={{ width: "100%" }} animate={{ width: `${playerHP}%` }} />
                   </div>
                 )}
              </div>
              <span className="mt-4 font-bold">{user?.name || "You"}</span>
            </div>
            
            <div className="w-1/3 text-4xl font-black text-yellow-400 italic flex justify-center">
              {gameState === "active" ? <Swords className="w-10 h-10 animate-bounce" /> : "VS"}
            </div>

            {/* Opponent */}
            <div className="flex flex-col items-center w-1/3">
              <div className="w-20 h-20 bg-red-500 rounded-full border-4 border-white shadow-[0_0_30px_rgba(239,68,68,0.6)] flex items-center justify-center relative">
                 {gameState === "idle" || gameState === "matchmaking" ? (
                   <span className="text-3xl animate-pulse">?</span>
                 ) : (
                   <img src="https://api.dicebear.com/7.x/bottts/svg?seed=evilbot&backgroundColor=transparent" className="w-14 h-14" />
                 )}
                 {gameState === "active" && (
                   <div className="absolute -bottom-3 w-20 h-4 bg-gray-900 rounded-full overflow-hidden border border-white/50">
                     <motion.div className="h-full bg-red-500" initial={{ width: "100%" }} animate={{ width: `${opponentHP}%` }} />
                   </div>
                 )}
              </div>
              <span className="mt-4 font-bold text-white/80">
                {gameState === "idle" || gameState === "matchmaking" ? "Opponent" : "Bot_99"}
              </span>
            </div>
          </div>
        )}

        {/* State: Idle */}
        {gameState === "idle" && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="bg-white/10 p-6 rounded-3xl backdrop-blur-md border border-white/20 w-full">
            <h2 className="text-xl font-bold mb-2">Ranked Battle</h2>
            <p className="text-sm text-white/70 mb-6">Compete in real-time maths challenges. Win to earn Trophies and climb the leaderboard!</p>
            
            <Button onClick={findMatch} className="w-full h-14 rounded-2xl bg-gradient-to-r from-yellow-400 to-orange-500 hover:from-yellow-500 hover:to-orange-600 text-orange-950 font-black text-xl shadow-[0_0_20px_rgba(250,204,21,0.4)]">
              Find Match
            </Button>
          </motion.div>
        )}

        {/* State: Matchmaking */}
        {gameState === "matchmaking" && (
          <motion.div initial={{ scale: 0.9, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} className="flex flex-col items-center">
            <div className="w-16 h-16 border-4 border-yellow-400 border-t-transparent rounded-full animate-spin mb-4"></div>
            <h2 className="text-2xl font-bold animate-pulse">Searching for opponent...</h2>
            <p className="text-white/50 mt-2">Estimated wait: 0:05</p>
          </motion.div>
        )}

        {/* State: Active */}
        {gameState === "active" && (
          <motion.div initial={{ y: 50, opacity: 0 }} animate={{ y: 0, opacity: 1 }} className="w-full">
            <div className="bg-white text-gray-900 rounded-3xl p-8 mb-6 shadow-2xl flex items-center justify-center min-h-[150px]">
              <h2 className="text-5xl font-black">{QUESTIONS[qIndex % QUESTIONS.length].q}</h2>
            </div>
            
            <div className="grid grid-cols-2 gap-4 w-full">
              {QUESTIONS[qIndex % QUESTIONS.length].o.map((opt, i) => (
                <button
                  key={i}
                  onClick={() => handleAnswer(opt)}
                  className="h-16 bg-white/20 hover:bg-white/30 backdrop-blur-md border-2 border-white/30 rounded-2xl text-2xl font-extrabold shadow-sm active:bg-white/50 transition-colors"
                >
                  {opt}
                </button>
              ))}
            </div>
          </motion.div>
        )}

        {/* State: Results */}
        {gameState === "results" && (
          <motion.div initial={{ scale: 0.8, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} className="bg-white text-gray-900 p-8 rounded-[3rem] w-full shadow-2xl">
            <h2 className="text-4xl font-black mb-2">{opponentHP <= 0 ? "VICTORY!" : "DEFEAT"}</h2>
            <p className="text-gray-500 font-bold mb-6">{opponentHP <= 0 ? "You destroyed the opponent!" : "You ran out of HP."}</p>
            
            <div className="bg-gray-50 rounded-3xl p-6 mb-8 flex flex-col gap-4 border border-gray-100">
              <div className="flex justify-between items-center w-full font-bold text-xl">
                <span className="text-gray-500 flex items-center gap-2"><Trophy className="text-yellow-500 w-6 h-6"/> Trophies</span>
                <span className={opponentHP <= 0 ? "text-green-500" : "text-red-500"}>
                  {opponentHP <= 0 ? "+30" : "-15"}
                </span>
              </div>
              <div className="w-full h-px bg-gray-200"></div>
              <div className="flex justify-between items-center w-full font-bold text-xl">
                <span className="text-gray-500 flex items-center gap-2"><Coins className="text-yellow-500 w-6 h-6"/> Coins</span>
                <span className="text-green-500">
                  {opponentHP <= 0 ? "+50" : "+10"}
                </span>
              </div>
            </div>

            <Button 
              onClick={() => {
                setGameState("idle");
                setPlayerHP(100);
                setOpponentHP(100);
              }} 
              className="w-full h-16 bg-gradient-to-r from-blue-500 to-indigo-600 hover:from-blue-600 hover:to-indigo-700 text-white rounded-2xl text-xl font-bold shadow-lg"
            >
              Play Again
            </Button>
          </motion.div>
        )}

      </div>
    </div>
  );
}
