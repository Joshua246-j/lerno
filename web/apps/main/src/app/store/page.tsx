"use client";

import { ShoppingBag, Coins, Zap, Trophy, Crown, Sparkles, AlertCircle, ShoppingCart } from "lucide-react";
import { useAuth } from "@/features/auth/hooks/useAuth";
import { useAudio } from "@/hooks/useAudio";
import { Button } from "@/components/ui/button";
import { motion } from "framer-motion";
import { toast } from "sonner";
import { useState } from "react";

const ITEMS = [
  { id: '1', name: "Cool Shades Avatar", type: "Avatar", price: 500, seed: "coolguy", color: "from-[#4AC4FA] to-[#1cb0f0]" },
  { id: '2', name: "Genius Glasses", type: "Accessory", price: 300, seed: "nerd", color: "from-[#93D94E] to-[#65a30d]" },
  { id: '3', name: "Golden Crown", type: "Hat", price: 1500, seed: "king", color: "from-[#FFD166] to-[#d9a01c]", premium: true },
  { id: '4', name: "Ninja Mask", type: "Accessory", price: 800, seed: "ninja", color: "from-[#8A79F4] to-[#6d28d9]" },
  { id: '5', name: "Astronaut Helmet", type: "Hat", price: 1200, seed: "space", color: "from-[#FF7A7A] to-[#e04141]", premium: true },
  { id: '6', name: "Cat Ears", type: "Hat", price: 400, seed: "cat", color: "from-[#ff99cc] to-[#d95c99]" },
];

export default function StorePage() {
  const { user } = useAuth();
  const { play } = useAudio();
  const [activeTab, setActiveTab] = useState("featured");

  const handlePurchase = (item: any) => {
    if ((user?.coins || 0) >= item.price) {
      play("correct");
      toast.success(`Successfully purchased ${item.name}!`, {
        icon: <ShoppingBag className="w-5 h-5 text-green-500" />,
        style: { borderRadius: '20px', padding: '16px', fontWeight: 'bold' }
      });
    } else {
      play("wrong");
      toast.error("Not enough coins!", {
        description: `You need ${item.price - (user?.coins || 0)} more coins.`,
        icon: <AlertCircle className="w-5 h-5 text-red-500" />,
        style: { borderRadius: '20px', padding: '16px', fontWeight: 'bold' }
      });
    }
  };

  return (
    <div className="min-h-screen bg-[#F4F7FF] font-sans pb-24">
      
      {/* 
        ====================================================
        1. STORE HEADER
        ====================================================
      */}
      <header className="bg-white rounded-b-[3rem] p-8 md:p-12 shadow-[0_10px_40px_rgba(0,0,0,0.03)] relative overflow-hidden mb-8">
        <div className="max-w-6xl mx-auto flex flex-col md:flex-row items-center justify-between gap-6 relative z-10">
          <div className="flex items-center gap-4">
            <div className="w-16 h-16 bg-purple-100 rounded-[1.5rem] flex items-center justify-center rotate-3 shadow-sm border-2 border-white">
              <ShoppingCart className="w-8 h-8 text-[#8A79F4] -rotate-3" />
            </div>
            <div>
              <h1 className="text-3xl font-black text-gray-900 tracking-tight">Lerno Store</h1>
              <p className="text-gray-400 font-bold text-sm">Unlock amazing avatars & accessories!</p>
            </div>
          </div>
          
          <div className="bg-[#FFFAF0] border border-orange-100 rounded-2xl p-4 flex items-center gap-6 shadow-sm">
            <div className="flex items-center gap-2">
              <div className="w-10 h-10 bg-yellow-100 rounded-full flex items-center justify-center"><Coins className="w-5 h-5 text-yellow-600 fill-current" /></div>
              <div>
                <div className="text-xs font-bold text-gray-400 uppercase">Balance</div>
                <div className="text-xl font-black text-gray-900 leading-none">{user?.coins || 2450}</div>
              </div>
            </div>
            <div className="w-px h-8 bg-orange-100"></div>
            <div className="flex items-center gap-2">
              <div className="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center"><Zap className="w-5 h-5 text-blue-500 fill-current" /></div>
              <div>
                <div className="text-xs font-bold text-gray-400 uppercase">Gems</div>
                <div className="text-xl font-black text-gray-900 leading-none">120</div>
              </div>
            </div>
          </div>
        </div>
      </header>

      <div className="max-w-6xl mx-auto px-6">
        
        {/* 
          ====================================================
          2. NAVIGATION TABS
          ====================================================
        */}
        <div className="flex overflow-x-auto hide-scrollbar gap-2 mb-8 p-1 bg-gray-100/50 rounded-[2rem] w-max max-w-full">
          {["featured", "avatars", "accessories", "bundles"].map((tab) => (
            <button 
              key={tab}
              onClick={() => setActiveTab(tab)}
              className={`px-6 py-3 rounded-full font-black text-sm capitalize transition-all ${activeTab === tab ? 'bg-white text-[#8A79F4] shadow-sm' : 'text-gray-400 hover:text-gray-600 hover:bg-gray-50'}`}
            >
              {tab}
            </button>
          ))}
        </div>

        {/* 
          ====================================================
          3. FEATURED BUNDLE (HERO CARD)
          ====================================================
        */}
        <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="mb-12">
          <div className="bg-gradient-to-r from-[#FFD166] to-[#f5b318] rounded-[2.5rem] p-8 md:p-10 text-yellow-900 flex flex-col md:flex-row items-center justify-between shadow-xl shadow-yellow-500/20 relative overflow-hidden group">
            <div className="absolute right-0 top-0 w-96 h-96 bg-white/20 rounded-full blur-3xl transform translate-x-1/2 -translate-y-1/2"></div>
            
            <div className="relative z-10 w-full md:w-1/2 mb-8 md:mb-0">
              <div className="inline-flex items-center gap-1 bg-white/30 px-3 py-1 rounded-full text-xs font-black uppercase tracking-wider mb-4 border border-white/40">
                <Crown className="w-3 h-3 fill-current" /> Premium Bundle
              </div>
              <h2 className="text-4xl font-black mb-4">The Royal Scholar Pack</h2>
              <p className="text-yellow-800 font-bold mb-8">Get the exclusive Golden Crown, Royal Robes, and 500 bonus coins!</p>
              
              <Button onClick={() => handlePurchase({ name: "Royal Scholar Pack", price: 2500 })} className="bg-white hover:bg-gray-50 text-yellow-600 rounded-2xl px-8 py-6 shadow-lg hover:-translate-y-1 transition-all border-b-4 border-yellow-200 active:border-b-0 active:translate-y-0 text-lg font-black w-full sm:w-auto">
                Buy for 2,500 <Coins className="w-5 h-5 ml-2 fill-current" />
              </Button>
            </div>

            <div className="relative z-10">
              <img src="https://api.dicebear.com/7.x/micah/svg?seed=king&backgroundColor=transparent" className="w-64 h-64 drop-shadow-[0_20px_30px_rgba(0,0,0,0.15)] group-hover:scale-110 transition-transform duration-500" />
              <Sparkles className="absolute top-0 right-10 w-10 h-10 text-white animate-pulse" />
              <Sparkles className="absolute bottom-10 left-0 w-6 h-6 text-white animate-pulse delay-150" />
            </div>
          </div>
        </motion.div>

        {/* 
          ====================================================
          4. ITEM GRID
          ====================================================
        */}
        <h2 className="text-2xl font-black text-gray-900 mb-6">Daily Offers</h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-3 gap-6">
          {ITEMS.map((item, index) => (
            <motion.div 
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.1 }}
              key={item.id} 
              className="bg-white rounded-[2.5rem] p-4 shadow-sm hover:shadow-xl transition-all border border-gray-100 group flex flex-col"
            >
              <div className={`w-full h-48 bg-gradient-to-t ${item.color} rounded-[2rem] flex items-center justify-center p-6 relative overflow-hidden mb-4 shadow-inner`}>
                {item.premium && (
                  <div className="absolute top-3 right-3 bg-white/20 backdrop-blur-sm px-2 py-1 rounded-full text-white text-[10px] font-black flex items-center gap-1 border border-white/30">
                    <Crown className="w-3 h-3 fill-current" /> VIP
                  </div>
                )}
                <img src={`https://api.dicebear.com/7.x/micah/svg?seed=${item.seed}&backgroundColor=transparent`} className="w-full h-full drop-shadow-xl group-hover:scale-110 transition-transform duration-300" />
              </div>
              
              <div className="px-2 flex-1 flex flex-col">
                <div className="text-xs font-black text-gray-400 uppercase tracking-wider mb-1">{item.type}</div>
                <h3 className="font-black text-lg text-gray-900 mb-4">{item.name}</h3>
                
                <div className="mt-auto pt-4 border-t border-gray-50 flex items-center justify-between">
                  <div className="flex items-center gap-1.5 font-black text-lg text-yellow-600">
                    <Coins className="w-5 h-5 fill-current" /> {item.price}
                  </div>
                  <Button 
                    onClick={() => handlePurchase(item)}
                    className="bg-gray-900 hover:bg-gray-800 text-white rounded-xl font-bold px-6 py-5 shadow-md hover:-translate-y-0.5 transition-transform"
                  >
                    Buy
                  </Button>
                </div>
              </div>
            </motion.div>
          ))}
        </div>

      </div>
    </div>
  );
}
