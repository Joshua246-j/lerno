"use client";

import { ChevronLeft, Gamepad2, Play } from "lucide-react";
import { useRouter } from "next/navigation";
import Link from "next/link";

const GAMES = [
  { id: "g1", title: "Math Arena", category: "Maths", color: "bg-blue-500", image: "https://api.dicebear.com/7.x/bottts/svg?seed=math&backgroundColor=transparent", route: "/games/math-arena" },
  { id: "g2", title: "Memory Match", category: "Logic", color: "bg-purple-500", image: "https://api.dicebear.com/7.x/bottts/svg?seed=memory&backgroundColor=transparent", route: "/games/memory-match" },
  { id: "g3", title: "Word Puzzle", category: "English", color: "bg-pink-500", image: "https://api.dicebear.com/7.x/bottts/svg?seed=word&backgroundColor=transparent", route: "#" },
  { id: "g4", title: "Science Lab", category: "Science", color: "bg-green-500", image: "https://api.dicebear.com/7.x/bottts/svg?seed=lab&backgroundColor=transparent", route: "#" },
];

export default function GamesPage() {
  const router = useRouter();

  return (
    <div className="min-h-screen bg-[#F8F9FE] flex flex-col pb-24">
      <div className="bg-white p-4 flex items-center gap-4 shadow-sm relative z-10 rounded-b-3xl">
        <button onClick={() => router.back()} className="p-2 bg-gray-50 rounded-full text-gray-600">
          <ChevronLeft className="w-6 h-6" />
        </button>
        <h1 className="text-xl font-bold text-gray-900 flex items-center gap-2">
          <Gamepad2 className="text-blue-500 w-6 h-6" /> Mini Games
        </h1>
      </div>

      <div className="p-6 grid grid-cols-2 gap-4">
        {GAMES.map((game) => (
          <div key={game.id} className={`${game.color} rounded-3xl p-4 flex flex-col items-center justify-between text-white shadow-lg relative overflow-hidden group`}>
            <div className="absolute top-2 right-2 bg-white/20 px-2 py-1 rounded-full text-[10px] font-bold">
              {game.category}
            </div>
            
            <img src={game.image} className="w-20 h-20 mt-4 mb-2 group-hover:scale-110 transition-transform" />
            
            <div className="text-center w-full mt-2 z-10">
              <h3 className="font-bold text-sm mb-3 text-white">{game.title}</h3>
              {game.route !== "#" ? (
                <Link href={game.route} className="w-full bg-white text-gray-900 rounded-xl py-2 text-xs font-bold flex items-center justify-center gap-1 hover:bg-gray-50 transition-colors">
                  <Play className="w-3 h-3 fill-current" /> Play
                </Link>
              ) : (
                <button disabled className="w-full bg-white/50 text-white rounded-xl py-2 text-xs font-bold flex items-center justify-center gap-1 cursor-not-allowed">
                  Coming Soon
                </button>
              )}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
