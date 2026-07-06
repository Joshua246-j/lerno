"use client";

import { useAuth } from "@/features/auth/hooks/useAuth";
import { Trophy, Play, ChevronRight, Gamepad2, Book, Palette, Headphones, MessageCircle, PenTool, Home as HomeIcon, BookOpen, LineChart } from "lucide-react";
import { motion } from "framer-motion";
import Link from "next/link";

export default function HomeDashboard() {
  const { user } = useAuth();

  return (
    <div className="min-h-screen bg-[#F4F7FF] font-sans pb-24 md:pb-12 relative overflow-hidden">
      
      {/* Decorative Background Clouds */}
      <div className="absolute top-[30%] left-[-10%] w-[500px] h-[300px] bg-white rounded-[100px] opacity-40 blur-3xl pointer-events-none"></div>
      <div className="absolute top-[60%] right-[-20%] w-[600px] h-[400px] bg-white rounded-[100px] opacity-60 blur-3xl pointer-events-none"></div>
      
      {/* Background Mountain/Cloud SVG Pattern */}
      <div className="absolute inset-0 pointer-events-none z-0" style={{
        backgroundImage: `url("data:image/svg+xml,%3Csvg width='100%25' height='100%25' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M0,300 Q150,250 300,300 T600,300 T900,300 T1200,300 L1200,1000 L0,1000 Z' fill='%23ffffff' fill-opacity='0.4'/%3E%3C/svg%3E")`,
        backgroundRepeat: 'no-repeat',
        backgroundPosition: 'bottom',
        backgroundSize: 'cover'
      }}></div>

      <div className="max-w-2xl mx-auto px-6 pt-12 relative z-10">
        
        {/* Header */}
        <header className="flex items-center justify-between mb-8">
          <div className="flex items-center gap-4">
            <div className="w-16 h-16 bg-gradient-to-br from-[#FF7A7A] to-[#ff5252] rounded-full p-1 shadow-md relative">
               <img src={`https://api.dicebear.com/7.x/big-ears-neutral/svg?seed=${user?.name || 'edvyin'}&backgroundColor=transparent`} className="w-full h-full bg-[#FFE5E5] rounded-full" />
            </div>
            <div>
              <h1 className="text-xl font-extrabold text-gray-800 tracking-tight leading-tight">Hello {user?.name || "Edvyin"}</h1>
              <p className="text-sm font-bold text-gray-500">Grade 2</p>
            </div>
          </div>
          
          <button className="flex items-center gap-2 bg-white px-4 py-2 rounded-full shadow-sm">
            <Trophy className="w-5 h-5 text-orange-400 fill-orange-400" />
            <span className="font-bold text-gray-700 text-sm">Awards</span>
          </button>
        </header>

        {/* Courses Section */}
        <section className="mb-10">
          <h2 className="text-xl font-extrabold text-gray-800 mb-4">Courses</h2>
          <motion.div whileHover={{ scale: 1.02 }} className="relative bg-[#93D94E] rounded-[2.5rem] p-8 shadow-lg overflow-hidden flex items-center justify-between cursor-pointer">
            
            {/* Background leafy details */}
            <div className="absolute top-0 right-0 w-64 h-64 bg-white opacity-10 rounded-full blur-2xl transform translate-x-1/2 -translate-y-1/2"></div>
            <div className="absolute bottom-0 left-0 w-32 h-32 bg-white opacity-20 rounded-full blur-xl transform -translate-x-1/2 translate-y-1/2"></div>

            <div className="relative z-10 max-w-[60%]">
              <h3 className="text-3xl font-black text-white mb-2 leading-tight">All about<br/>Words</h3>
              <p className="text-green-50 font-bold text-sm mb-6 max-w-[180px] leading-snug">Learn to read and write words</p>
              
              <button className="bg-white text-[#93D94E] rounded-full px-6 py-2.5 flex items-center gap-2 font-black text-sm shadow-md hover:bg-gray-50 transition-colors">
                <Play className="w-4 h-4 fill-current" /> Start
              </button>
            </div>

            {/* Giant Green Mascot */}
            <div className="absolute -bottom-6 -right-6 w-48 h-48 z-10">
              <img src="https://api.dicebear.com/7.x/big-smile/svg?seed=words&backgroundColor=transparent" className="w-full h-full transform -scale-x-100 rotate-12 drop-shadow-xl" />
            </div>
          </motion.div>
        </section>

        {/* Subjects Section */}
        <section className="mb-12">
          <h2 className="text-xl font-extrabold text-gray-800 mb-4">Subjects</h2>
          
          <div className="grid grid-cols-3 gap-4">
            
            {/* Maths Card */}
            <Link href="/games/math-arena">
              <motion.div whileHover={{ y: -5 }} className="bg-gradient-to-t from-[#4AC4FA] to-[#7bd8fb] rounded-[2rem] p-4 flex flex-col items-center justify-end h-44 shadow-lg relative overflow-hidden group cursor-pointer border-b-[6px] border-[#0ea5e9] active:border-b-0 active:translate-y-1">
                <div className="absolute top-2 left-2 text-white/50 font-black text-2xl transform -rotate-12">1+</div>
                <div className="absolute bottom-10 left-4 text-white/50 font-black text-3xl">2</div>
                
                <img src="https://api.dicebear.com/7.x/micah/svg?seed=maths&backgroundColor=transparent" className="w-20 h-20 mb-2 drop-shadow-md group-hover:scale-110 transition-transform" />
                <span className="text-[#0ea5e9] font-black text-sm bg-white px-4 py-1 rounded-full w-full text-center">Maths</span>
              </motion.div>
            </Link>

            {/* Science Card */}
            <Link href="#">
              <motion.div whileHover={{ y: -5 }} className="bg-gradient-to-t from-[#A4E034] to-[#c1f062] rounded-[2rem] p-4 flex flex-col items-center justify-end h-44 shadow-lg relative overflow-hidden group cursor-pointer border-b-[6px] border-[#65a30d] active:border-b-0 active:translate-y-1">
                <div className="absolute top-4 left-4 text-white/60"><span className="text-2xl">🧪</span></div>
                
                <img src="https://api.dicebear.com/7.x/micah/svg?seed=science&backgroundColor=transparent" className="w-20 h-20 mb-2 drop-shadow-md group-hover:scale-110 transition-transform" />
                <span className="text-[#65a30d] font-black text-sm bg-white px-4 py-1 rounded-full w-full text-center">Science</span>
              </motion.div>
            </Link>

            {/* English Card */}
            <Link href="#">
              <motion.div whileHover={{ y: -5 }} className="bg-gradient-to-t from-[#8A79F4] to-[#aca0f7] rounded-[2rem] p-4 flex flex-col items-center justify-end h-44 shadow-lg relative overflow-hidden group cursor-pointer border-b-[6px] border-[#6d28d9] active:border-b-0 active:translate-y-1">
                <div className="absolute top-4 left-4 text-white/50 font-black text-3xl">A</div>
                <div className="absolute bottom-12 left-4 text-white/50 font-black text-3xl">C</div>
                
                <img src="https://api.dicebear.com/7.x/micah/svg?seed=english&backgroundColor=transparent" className="w-20 h-20 mb-2 drop-shadow-md group-hover:scale-110 transition-transform" />
                <span className="text-[#6d28d9] font-black text-sm bg-white px-4 py-1 rounded-full w-full text-center">English</span>
              </motion.div>
            </Link>

          </div>
        </section>

        {/* Activity Section */}
        <section className="mb-12 relative z-20">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-xl font-extrabold text-gray-800">Activity</h2>
            
            {/* Fake Tabs */}
            <div className="flex gap-1 bg-white/50 p-1 rounded-full backdrop-blur-sm">
              <button className="w-10 h-8 bg-white rounded-full flex items-center justify-center shadow-sm text-blue-500"><HomeIcon className="w-4 h-4 fill-blue-100" /></button>
              <button className="w-10 h-8 rounded-full flex items-center justify-center text-gray-400 hover:bg-white/50"><BookOpen className="w-4 h-4" /></button>
              <button className="w-10 h-8 rounded-full flex items-center justify-center text-gray-400 hover:bg-white/50"><LineChart className="w-4 h-4" /></button>
            </div>
          </div>

          <div className="bg-white rounded-[2.5rem] p-8 shadow-[0_8px_30px_rgb(0,0,0,0.04)]">
            <div className="grid grid-cols-3 gap-y-10 gap-x-4">
              
              <Link href="/games" className="flex flex-col items-center gap-3 group">
                <div className="w-14 h-14 bg-blue-50 rounded-[1.2rem] flex items-center justify-center group-hover:scale-110 transition-transform">
                  <Gamepad2 className="w-7 h-7 text-blue-400 fill-blue-400" />
                </div>
                <span className="text-xs font-bold text-gray-600">Games</span>
              </Link>
              
              <Link href="#" className="flex flex-col items-center gap-3 group">
                <div className="w-14 h-14 bg-purple-50 rounded-[1.2rem] flex items-center justify-center group-hover:scale-110 transition-transform">
                  <Book className="w-7 h-7 text-purple-500 fill-purple-500" />
                </div>
                <span className="text-xs font-bold text-gray-600">Dictionary</span>
              </Link>

              <Link href="#" className="flex flex-col items-center gap-3 group">
                <div className="w-14 h-14 bg-orange-50 rounded-[1.2rem] flex items-center justify-center group-hover:scale-110 transition-transform">
                  <Palette className="w-7 h-7 text-orange-500 fill-orange-500" />
                </div>
                <span className="text-xs font-bold text-gray-600">Painting</span>
              </Link>

              <Link href="#" className="flex flex-col items-center gap-3 group">
                <div className="w-14 h-14 bg-pink-50 rounded-[1.2rem] flex items-center justify-center group-hover:scale-110 transition-transform">
                  <Headphones className="w-7 h-7 text-pink-400 fill-pink-400" />
                </div>
                <span className="text-xs font-bold text-gray-600">Listen</span>
              </Link>

              <Link href="/chat/f1" className="flex flex-col items-center gap-3 group">
                <div className="w-14 h-14 bg-green-50 rounded-[1.2rem] flex items-center justify-center group-hover:scale-110 transition-transform">
                  <MessageCircle className="w-7 h-7 text-green-500 fill-green-500" />
                </div>
                <span className="text-xs font-bold text-gray-600">Speak</span>
              </Link>

              <Link href="#" className="flex flex-col items-center gap-3 group">
                <div className="w-14 h-14 bg-yellow-50 rounded-[1.2rem] flex items-center justify-center group-hover:scale-110 transition-transform">
                  <PenTool className="w-7 h-7 text-yellow-500 fill-yellow-500" />
                </div>
                <span className="text-xs font-bold text-gray-600">Write</span>
              </Link>

            </div>
          </div>
        </section>

        {/* Recommended Section */}
        <section className="relative z-20">
          <h2 className="text-xl font-extrabold text-gray-800 mb-4">Recommended</h2>
          
          <motion.div whileHover={{ scale: 1.02 }} className="bg-white rounded-3xl p-4 shadow-[0_4px_20px_rgb(0,0,0,0.03)] flex items-center gap-4 cursor-pointer border border-gray-50">
            <div className="w-24 h-20 bg-blue-100 rounded-2xl overflow-hidden relative flex-shrink-0">
               {/* Mock image content */}
               <div className="absolute inset-0 bg-sky-200"></div>
               <div className="absolute bottom-0 w-full h-8 bg-[#8B5CF6]"></div>
               <div className="absolute top-2 left-2 w-6 h-6 bg-yellow-400 rounded-full flex items-center justify-center text-white text-xs font-black">1</div>
               <div className="absolute top-4 right-2 w-6 h-6 bg-blue-400 rounded-full flex items-center justify-center text-white text-xs font-black">2</div>
            </div>
            
            <div className="flex-1">
              <h3 className="font-extrabold text-gray-900 leading-tight mb-1">Fun with numbers</h3>
              <p className="text-xs font-bold text-gray-400 mb-2">Learn to add, subtract and more...</p>
              <div className="flex gap-1 text-yellow-400">
                <span className="text-[10px]">⭐</span><span className="text-[10px]">⭐</span><span className="text-[10px]">⭐</span>
              </div>
            </div>

            <button className="w-10 h-10 bg-indigo-500 hover:bg-indigo-600 rounded-full flex items-center justify-center shadow-md shadow-indigo-500/20 text-white transition-colors">
              <ChevronRight className="w-5 h-5" />
            </button>
          </motion.div>
        </section>

      </div>
    </div>
  );
}
