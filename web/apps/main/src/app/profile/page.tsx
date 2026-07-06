"use client";

import { useAuth } from "@/features/auth/hooks/useAuth";
import { Trophy, Settings, Shield, Award, Zap, Coins, Clock, BookOpen, Gamepad2, ChevronRight, LogOut, Moon, Volume2, Bell, Star } from "lucide-react";
import { motion } from "framer-motion";
import Link from "next/link";
import { Button } from "@/components/ui/button";

export default function ProfilePage() {
  const { user, logout } = useAuth();

  return (
    <div className="min-h-screen bg-[#F4F7FF] font-sans pb-24 md:pb-12">
      
      {/* 
        ====================================================
        1. PROFILE HEADER (GAMING STYLE)
        ====================================================
      */}
      <header className="bg-white rounded-b-[3rem] p-8 md:p-12 shadow-[0_10px_40px_rgba(0,0,0,0.03)] relative overflow-hidden mb-8">
        <div className="absolute top-0 right-0 w-96 h-96 bg-gradient-to-br from-[#8A79F4]/10 to-transparent rounded-full blur-3xl transform translate-x-1/2 -translate-y-1/2 pointer-events-none"></div>
        
        <div className="max-w-4xl mx-auto flex flex-col md:flex-row items-center md:items-end gap-8 relative z-10">
          
          {/* Avatar Area */}
          <div className="relative">
            <div className="w-40 h-40 md:w-48 md:h-48 bg-gradient-to-br from-[#FF7A7A] to-[#ff5252] rounded-[2.5rem] p-2 shadow-2xl rotate-3">
              <img src={`https://api.dicebear.com/7.x/micah/svg?seed=${user?.name || 'hero'}&backgroundColor=transparent`} className="w-full h-full bg-[#FFE5E5] rounded-[2rem] -rotate-3 border-4 border-white" />
            </div>
            
            {/* Level Badge */}
            <div className="absolute -bottom-4 left-1/2 -translate-x-1/2 bg-[#FFD166] text-yellow-900 px-4 py-1.5 rounded-full font-black text-sm shadow-lg border-2 border-white flex items-center gap-1">
              <Star className="w-4 h-4 fill-current" /> Lvl 12
            </div>
          </div>

          {/* User Info & Stats */}
          <div className="flex-1 text-center md:text-left w-full mt-4 md:mt-0">
            <h1 className="text-4xl font-black text-gray-900 mb-2 tracking-tight">{user?.name || "Alex Explorer"}</h1>
            <p className="text-gray-400 font-bold mb-6 flex items-center justify-center md:justify-start gap-2">
              ID: #LNR-{user?.id?.substring(0,6).toUpperCase() || '84X9B'} <span className="w-1.5 h-1.5 bg-gray-300 rounded-full"></span> Joined Mar 2026
            </p>
            
            {/* Quick Stats Grid */}
            <div className="flex flex-wrap justify-center md:justify-start gap-3">
              <div className="bg-gray-50 px-4 py-3 rounded-2xl flex items-center gap-3">
                <div className="w-10 h-10 bg-yellow-100 rounded-xl flex items-center justify-center text-yellow-600"><Coins className="w-5 h-5 fill-current" /></div>
                <div>
                  <div className="text-xl font-black text-gray-800 leading-none">{user?.coins || 2450}</div>
                  <div className="text-[10px] font-bold text-gray-400 uppercase tracking-wider">Coins</div>
                </div>
              </div>

              <div className="bg-gray-50 px-4 py-3 rounded-2xl flex items-center gap-3">
                <div className="w-10 h-10 bg-purple-100 rounded-xl flex items-center justify-center text-purple-600"><Trophy className="w-5 h-5 fill-current" /></div>
                <div>
                  <div className="text-xl font-black text-gray-800 leading-none">{user?.awards || 850}</div>
                  <div className="text-[10px] font-bold text-gray-400 uppercase tracking-wider">Trophies</div>
                </div>
              </div>

              <div className="bg-gray-50 px-4 py-3 rounded-2xl flex items-center gap-3">
                <div className="w-10 h-10 bg-orange-100 rounded-xl flex items-center justify-center text-orange-600"><Zap className="w-5 h-5 fill-current" /></div>
                <div>
                  <div className="text-xl font-black text-gray-800 leading-none">14</div>
                  <div className="text-[10px] font-bold text-gray-400 uppercase tracking-wider">Day Streak</div>
                </div>
              </div>
            </div>
          </div>
          
        </div>
      </header>

      <div className="max-w-4xl mx-auto px-6 grid grid-cols-1 md:grid-cols-3 gap-6">
        
        {/* 
          ====================================================
          2. MAIN CONTENT (PROGRESS & ACHIEVEMENTS)
          ====================================================
        */}
        <div className="md:col-span-2 space-y-6">
          
          {/* XP Progress Card */}
          <div className="bg-white rounded-[2rem] p-6 shadow-sm border border-gray-100 relative overflow-hidden">
            <h3 className="text-lg font-black text-gray-900 mb-4 flex items-center gap-2"><Award className="w-5 h-5 text-[#93D94E]" /> Current Journey</h3>
            
            <div className="flex justify-between text-sm font-bold text-gray-500 mb-2">
              <span>Level 12</span>
              <span>1,245 / 2,000 XP to Lvl 13</span>
            </div>
            
            <div className="w-full h-4 bg-gray-100 rounded-full overflow-hidden">
              <motion.div 
                initial={{ width: 0 }} 
                animate={{ width: "62%" }} 
                transition={{ duration: 1, ease: "easeOut" }} 
                className="h-full bg-gradient-to-r from-[#93D94E] to-[#65a30d] rounded-full"
              ></motion.div>
            </div>
          </div>

          {/* League Card */}
          <div className="bg-gradient-to-br from-[#8A79F4] to-[#6d28d9] rounded-[2rem] p-8 shadow-xl shadow-[#8A79F4]/20 text-white relative overflow-hidden group">
            <div className="absolute right-0 top-0 w-64 h-64 bg-white/10 rounded-full blur-3xl transform translate-x-1/2 -translate-y-1/2"></div>
            
            <div className="flex items-center gap-6 relative z-10">
              <div className="w-24 h-24 relative">
                <Shield className="w-full h-full text-yellow-300 drop-shadow-[0_10px_20px_rgba(0,0,0,0.2)] fill-yellow-400" />
                <Star className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-10 h-10 text-white fill-current opacity-80" />
              </div>
              <div>
                <h3 className="text-xs font-black uppercase tracking-wider text-purple-200 mb-1">Current League</h3>
                <div className="text-3xl font-black mb-2">Gold League I</div>
                <div className="text-sm font-bold text-purple-100">Top 15% of players this week</div>
              </div>
            </div>
          </div>

          {/* Recent Activity */}
          <div className="bg-white rounded-[2rem] p-6 shadow-sm border border-gray-100">
            <h3 className="text-lg font-black text-gray-900 mb-6">Recent Activity</h3>
            
            <div className="space-y-4">
              <div className="flex items-center justify-between p-4 bg-gray-50 rounded-2xl">
                <div className="flex items-center gap-4">
                  <div className="w-12 h-12 bg-blue-100 text-blue-600 rounded-xl flex items-center justify-center"><Gamepad2 className="w-6 h-6" /></div>
                  <div>
                    <div className="font-bold text-gray-900">Math Arena Victory</div>
                    <div className="text-xs font-bold text-gray-400">2 hours ago</div>
                  </div>
                </div>
                <div className="text-green-500 font-black">+45 XP</div>
              </div>

              <div className="flex items-center justify-between p-4 bg-gray-50 rounded-2xl">
                <div className="flex items-center gap-4">
                  <div className="w-12 h-12 bg-purple-100 text-purple-600 rounded-xl flex items-center justify-center"><BookOpen className="w-6 h-6" /></div>
                  <div>
                    <div className="font-bold text-gray-900">Completed Fractions Lesson</div>
                    <div className="text-xs font-bold text-gray-400">Yesterday</div>
                  </div>
                </div>
                <div className="text-green-500 font-black">+120 XP</div>
              </div>
            </div>
          </div>

        </div>

        {/* 
          ====================================================
          3. SETTINGS & QUICK LINKS (SIDEBAR)
          ====================================================
        */}
        <div className="space-y-6">
          
          {/* Settings Module */}
          <div className="bg-white rounded-[2rem] p-6 shadow-sm border border-gray-100">
            <h3 className="text-lg font-black text-gray-900 mb-6 flex items-center gap-2"><Settings className="w-5 h-5 text-gray-400" /> Preferences</h3>
            
            <div className="space-y-2">
              <button className="w-full flex items-center justify-between p-3 hover:bg-gray-50 rounded-xl transition-colors text-left group">
                <div className="flex items-center gap-3">
                  <Volume2 className="w-5 h-5 text-gray-400 group-hover:text-blue-500 transition-colors" />
                  <span className="font-bold text-gray-700">Sound Effects</span>
                </div>
                <div className="w-10 h-6 bg-blue-500 rounded-full relative shadow-inner"><div className="absolute right-1 top-1 w-4 h-4 bg-white rounded-full shadow-sm"></div></div>
              </button>

              <button className="w-full flex items-center justify-between p-3 hover:bg-gray-50 rounded-xl transition-colors text-left group">
                <div className="flex items-center gap-3">
                  <Moon className="w-5 h-5 text-gray-400 group-hover:text-indigo-500 transition-colors" />
                  <span className="font-bold text-gray-700">Dark Mode</span>
                </div>
                <div className="w-10 h-6 bg-gray-200 rounded-full relative shadow-inner"><div className="absolute left-1 top-1 w-4 h-4 bg-white rounded-full shadow-sm"></div></div>
              </button>

              <button className="w-full flex items-center justify-between p-3 hover:bg-gray-50 rounded-xl transition-colors text-left group">
                <div className="flex items-center gap-3">
                  <Bell className="w-5 h-5 text-gray-400 group-hover:text-orange-500 transition-colors" />
                  <span className="font-bold text-gray-700">Notifications</span>
                </div>
                <div className="w-10 h-6 bg-orange-400 rounded-full relative shadow-inner"><div className="absolute right-1 top-1 w-4 h-4 bg-white rounded-full shadow-sm"></div></div>
              </button>
            </div>

            <div className="mt-6 pt-6 border-t border-gray-100">
              <Button onClick={logout} variant="ghost" className="w-full justify-start text-red-500 hover:text-red-600 hover:bg-red-50 font-bold rounded-xl h-12">
                <LogOut className="w-5 h-5 mr-3" /> Sign Out
              </Button>
            </div>
          </div>

          {/* Help & Support */}
          <div className="bg-gradient-to-br from-[#4AC4FA] to-[#1cb0f0] rounded-[2rem] p-6 text-white text-center shadow-lg relative overflow-hidden">
            <div className="absolute top-0 right-0 w-32 h-32 bg-white/20 rounded-full blur-xl translate-x-1/2 -translate-y-1/2"></div>
            <img src="https://api.dicebear.com/7.x/big-smile/svg?seed=support" className="w-20 h-20 mx-auto mb-4 drop-shadow-lg" />
            <h3 className="font-black text-xl mb-2">Need Help?</h3>
            <p className="text-sm font-bold text-blue-100 mb-6">Contact our support team or read the FAQ.</p>
            <Button asChild className="w-full bg-white text-blue-600 hover:bg-gray-50 rounded-xl font-black">
              <Link href="#">Get Support</Link>
            </Button>
          </div>

        </div>

      </div>
    </div>
  );
}
