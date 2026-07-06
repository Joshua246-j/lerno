"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { useAudio } from "@/hooks/useAudio";
import { X, Trophy, Timer, Coins, Zap } from "lucide-react";
import confetti from "canvas-confetti";
import { motion, AnimatePresence } from "framer-motion";
import { Button } from "@/components/ui/button";
import Link from "next/link";

const GAME_DURATION = 60; // 60 seconds

function generateQuestion() {
  const operators = ["+", "-", "x"];
  const op = operators[Math.floor(Math.random() * operators.length)];
  let num1, num2, answer;

  if (op === "+") {
    num1 = Math.floor(Math.random() * 20) + 1;
    num2 = Math.floor(Math.random() * 20) + 1;
    answer = num1 + num2;
  } else if (op === "-") {
    num1 = Math.floor(Math.random() * 20) + 10;
    num2 = Math.floor(Math.random() * num1);
    answer = num1 - num2;
  } else {
    num1 = Math.floor(Math.random() * 10) + 1;
    num2 = Math.floor(Math.random() * 10) + 1;
    answer = num1 * num2;
  }

  const options = new Set<number>();
  options.add(answer);
  while (options.size < 4) {
    const offset = Math.floor(Math.random() * 10) - 5;
    if (offset !== 0 && answer + offset >= 0) {
      options.add(answer + offset);
    }
  }

  return {
    question: `${num1} ${op} ${num2}`,
    answer,
    options: Array.from(options).sort(() => Math.random() - 0.5)
  };
}

export default function MathArenaPage() {
  const router = useRouter();
  const { play, stop } = useAudio();
  
  const [gameState, setGameState] = useState<"idle" | "playing" | "gameover">("idle");
  const [timeLeft, setTimeLeft] = useState(GAME_DURATION);
  const [score, setScore] = useState(0);
  const [currentQ, setCurrentQ] = useState(generateQuestion());
  const [combo, setCombo] = useState(0);

  const startGame = () => {
    setGameState("playing");
    setScore(0);
    setCombo(0);
    setTimeLeft(GAME_DURATION);
    setCurrentQ(generateQuestion());
    play("click");
  };

  const handleAnswer = (selected: number) => {
    if (selected === currentQ.answer) {
      play("correct");
      setScore(prev => prev + 10 + (combo * 2));
      setCombo(prev => prev + 1);
    } else {
      play("wrong");
      setCombo(0);
    }
    setCurrentQ(generateQuestion());
  };

  useEffect(() => {
    let timer: NodeJS.Timeout;
    if (gameState === "playing" && timeLeft > 0) {
      timer = setInterval(() => {
        setTimeLeft(prev => {
          if (prev <= 11 && prev > 1) play("tick");
          return prev - 1;
        });
      }, 1000);
    } else if (gameState === "playing" && timeLeft === 0) {
      setGameState("gameover");
      play("victory");
      confetti({
        particleCount: 150,
        spread: 70,
        origin: { y: 0.6 },
        colors: ['#4AC4FA', '#93D94E', '#FFD166']
      });
    }
    return () => clearInterval(timer);
  }, [gameState, timeLeft, play]);

  return (
    <div className="min-h-screen bg-[#F4F7FF] flex flex-col md:items-center md:justify-center font-sans">
      
      {/* Top Bar */}
      <div className="absolute top-0 w-full p-6 flex justify-between items-center z-20">
        <Link href="/games" className="w-12 h-12 bg-white rounded-2xl shadow-sm flex items-center justify-center border border-gray-100 hover:bg-gray-50 transition-colors">
          <X className="w-6 h-6 text-gray-500" />
        </Link>
      </div>

      <div className="flex-1 flex flex-col w-full max-w-md mx-auto relative pt-24 px-6 pb-6 h-full justify-center">
        
        {/* ======================= IDLE STATE ======================= */}
        {gameState === "idle" && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="text-center bg-white rounded-[3rem] p-10 shadow-xl border border-gray-100 relative overflow-hidden">
            <div className="absolute top-0 right-0 w-64 h-64 bg-blue-50 rounded-full blur-3xl transform translate-x-1/2 -translate-y-1/2"></div>
            
            <div className="w-32 h-32 mx-auto mb-6 bg-gradient-to-br from-[#4AC4FA] to-[#1cb0f0] rounded-[2rem] p-4 shadow-lg rotate-3 relative z-10 border-4 border-white">
              <img src="https://api.dicebear.com/7.x/micah/svg?seed=mathhero&backgroundColor=transparent" className="w-full h-full -rotate-3" />
            </div>
            
            <h1 className="text-4xl font-black text-gray-900 mb-2 relative z-10 tracking-tight">Math Arena</h1>
            <p className="text-gray-500 mb-8 font-medium relative z-10 text-sm">Solve as many equations as you can in 60 seconds. Build your combo for extra XP!</p>
            
            <Button onClick={startGame} className="w-full bg-[#4AC4FA] hover:bg-[#38b5eb] text-white rounded-2xl text-xl font-black shadow-[0_8px_0_#0ea5e9] active:translate-y-2 active:shadow-none transition-all py-8 relative z-10">
              START GAME
            </Button>
          </motion.div>
        )}

        {/* ======================= PLAYING STATE ======================= */}
        {gameState === "playing" && (
          <div className="flex flex-col h-full justify-center -mt-10">
            {/* HUD */}
            <div className="flex justify-between items-center mb-10 w-full px-2">
              <div className="bg-white px-5 py-3 rounded-2xl shadow-sm border border-gray-100 flex items-center gap-3">
                <Trophy className="w-6 h-6 text-yellow-400 fill-yellow-400" />
                <span className="font-black text-2xl text-gray-800 leading-none">{score}</span>
              </div>
              <div className={`px-5 py-3 rounded-2xl shadow-sm border border-gray-100 flex items-center gap-3 font-black text-2xl leading-none transition-colors ${timeLeft <= 10 ? 'bg-red-500 text-white animate-pulse border-red-600' : 'bg-white text-gray-800'}`}>
                <Timer className="w-6 h-6" />
                {timeLeft}s
              </div>
            </div>

            {/* Question Area */}
            <div className="flex-1 flex flex-col items-center justify-center relative w-full mb-10 max-h-[350px]">
              <AnimatePresence mode="wait">
                <motion.div
                  key={currentQ.question}
                  initial={{ scale: 0.8, opacity: 0 }}
                  animate={{ scale: 1, opacity: 1 }}
                  exit={{ scale: 1.2, opacity: 0 }}
                  transition={{ duration: 0.2 }}
                  className="w-full aspect-square bg-gradient-to-br from-white to-blue-50 rounded-[3rem] shadow-[0_20px_60px_rgba(74,196,250,0.15)] flex items-center justify-center border-4 border-white relative overflow-hidden"
                >
                  {/* Decorative Elements */}
                  <div className="absolute top-4 left-4 text-blue-100 font-black text-4xl transform -rotate-12">+</div>
                  <div className="absolute bottom-4 right-4 text-blue-100 font-black text-4xl transform rotate-12">x</div>
                  
                  <span className="text-7xl font-black text-gray-800 tracking-tighter drop-shadow-sm">{currentQ.question}</span>
                  
                  {combo > 2 && (
                    <motion.div initial={{ scale: 0 }} animate={{ scale: 1 }} className="absolute -top-4 -right-4 bg-[#FFD166] text-yellow-900 font-black px-4 py-2 rounded-full shadow-lg transform rotate-12 border-2 border-white flex items-center gap-1 z-10">
                      <Zap className="w-4 h-4 fill-current" /> {combo}x COMBO!
                    </motion.div>
                  )}
                </motion.div>
              </AnimatePresence>
            </div>

            {/* Answers Grid */}
            <div className="grid grid-cols-2 gap-4 w-full px-2">
              {currentQ.options.map((opt, i) => (
                <button
                  key={`${currentQ.question}-${opt}-${i}`}
                  onClick={() => handleAnswer(opt)}
                  className="h-24 bg-white hover:bg-[#F4F7FF] border-b-8 border-gray-200 rounded-[2rem] text-4xl font-black text-[#4AC4FA] shadow-sm active:border-b-0 active:translate-y-2 active:bg-blue-100 transition-all"
                >
                  {opt}
                </button>
              ))}
            </div>
          </div>
        )}

        {/* ======================= GAMEOVER STATE ======================= */}
        {gameState === "gameover" && (
          <motion.div initial={{ scale: 0.9, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} className="text-center bg-white p-10 rounded-[3rem] shadow-2xl border border-gray-100 relative overflow-hidden">
            <div className="absolute top-0 right-0 w-64 h-64 bg-green-50 rounded-full blur-3xl transform translate-x-1/2 -translate-y-1/2"></div>
            
            <h2 className="text-4xl font-black text-gray-900 mb-8 relative z-10">Time's Up!</h2>
            
            <div className="bg-gray-50 rounded-[2rem] p-8 mb-8 flex flex-col items-center gap-4 border border-gray-100 relative z-10 shadow-inner">
              <span className="text-gray-400 font-black uppercase tracking-widest text-xs">Final Score</span>
              <span className="text-7xl font-black text-[#4AC4FA] drop-shadow-sm">{score}</span>
              
              <div className="w-full h-px bg-gray-200 my-4"></div>
              
              <div className="flex justify-between w-full font-black text-lg">
                <span className="text-gray-600">XP Earned</span>
                <span className="text-[#93D94E] flex items-center gap-1"><Zap className="w-5 h-5 fill-current" /> +{score}</span>
              </div>
              <div className="flex justify-between w-full font-black text-lg">
                <span className="text-gray-600">Coins Earned</span>
                <span className="text-[#FFD166] flex items-center gap-1 text-yellow-500"><Coins className="w-5 h-5 fill-current" /> +{Math.floor(score / 10)}</span>
              </div>
            </div>

            <div className="flex flex-col gap-4 relative z-10">
              <Button onClick={startGame} className="w-full bg-[#93D94E] hover:bg-[#86ca46] text-white rounded-2xl text-xl font-black shadow-[0_8px_0_#65a30d] active:translate-y-2 active:shadow-none transition-all py-8">
                PLAY AGAIN
              </Button>
              <Button asChild variant="outline" className="w-full bg-white hover:bg-gray-50 text-gray-600 border-2 border-gray-200 rounded-2xl text-xl font-black transition-all py-8">
                <Link href="/games">EXIT TO GAMES</Link>
              </Button>
            </div>
          </motion.div>
        )}

      </div>
    </div>
  );
}
