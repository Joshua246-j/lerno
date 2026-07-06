"use client";

import { motion, useScroll, useTransform, Variants } from "framer-motion";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Star, ChevronRight, Gamepad2, Swords, Trophy, CheckCircle2, ShieldCheck, Zap } from "lucide-react";
import { Logo } from "@/components/ui/Logo";

// -- Animation Variants --
const fadeUp: Variants = {
  hidden: { opacity: 0, y: 40 },
  visible: { opacity: 1, y: 0, transition: { type: "spring", stiffness: 70, damping: 20 } }
};

const staggerContainer: Variants = {
  hidden: { opacity: 0 },
  visible: { opacity: 1, transition: { staggerChildren: 0.15, delayChildren: 0.1 } }
};

export default function GamifiedLandingPage() {
  const { scrollYProgress } = useScroll();
  const yFloating1 = useTransform(scrollYProgress, [0, 1], ["0%", "-30%"]);
  const yFloating2 = useTransform(scrollYProgress, [0, 1], ["0%", "-60%"]);

  return (
    <div className="min-h-screen bg-white font-sans text-gray-900 selection:bg-[#93D94E] selection:text-white overflow-x-hidden">
      
      {/* 
        =========================================
        1. TOP NAVIGATION (Simplified)
        =========================================
      */}
      <header className="fixed top-0 left-0 right-0 z-50 bg-white/90 backdrop-blur-md border-b border-gray-100 shadow-[0_4px_30px_rgba(0,0,0,0.02)]">
        <div className="max-w-7xl mx-auto px-6 h-20 flex items-center justify-between">
          <Logo />
          
          <div className="flex items-center gap-4">
            <Button asChild variant="ghost" className="hidden sm:inline-flex font-black text-gray-400 hover:text-gray-900 hover:bg-gray-50 rounded-2xl border-2 border-transparent hover:border-gray-100 text-lg">
              <Link href="/login">LOG IN</Link>
            </Button>
            <Button asChild className="bg-[#93D94E] hover:bg-[#86ca46] text-white rounded-2xl px-8 py-6 shadow-lg shadow-[#93D94E]/30 border-b-4 border-[#65a30d] font-black uppercase tracking-wide text-lg transition-all active:border-b-0 active:translate-y-1">
              <Link href="/register">PLAY FREE</Link>
            </Button>
          </div>
        </div>
      </header>

      {/* 
        =========================================
        2. HERO SECTION
        =========================================
      */}
      <section className="relative pt-32 pb-20 lg:pt-48 lg:pb-32 overflow-hidden max-w-7xl mx-auto px-6 flex flex-col lg:flex-row items-center">
        
        {/* Playful Background Gradients & Floating Animals */}
        <div className="absolute top-0 right-0 w-[800px] h-[800px] bg-gradient-to-br from-[#93D94E]/15 to-[#FFD166]/15 rounded-full blur-[100px] -z-10 pointer-events-none"></div>
        <div className="absolute bottom-0 left-[-200px] w-[600px] h-[600px] bg-gradient-to-tr from-[#4AC4FA]/15 to-transparent rounded-full blur-[100px] -z-10 pointer-events-none"></div>
        
        {/* Floating Twemoji Animals */}
        <motion.img 
          animate={{ y: [-15, 15, -15], rotate: [-5, 5, -5] }} 
          transition={{ repeat: Infinity, duration: 6, ease: "easeInOut" }}
          src="https://cdn.jsdelivr.net/gh/jdecked/twemoji@latest/assets/svg/1f419.svg" 
          className="absolute top-20 left-10 w-24 h-24 opacity-60 -z-10 drop-shadow-2xl" alt="Octopus" 
        />
        <motion.img 
          animate={{ y: [15, -15, 15], rotate: [5, -5, 5] }} 
          transition={{ repeat: Infinity, duration: 7, ease: "easeInOut" }}
          src="https://cdn.jsdelivr.net/gh/jdecked/twemoji@latest/assets/svg/1f993.svg" 
          className="absolute bottom-20 right-10 w-32 h-32 opacity-60 -z-10 drop-shadow-2xl" alt="Zebra" 
        />
        <motion.img 
          animate={{ y: [-10, 10, -10], rotate: [-10, 10, -10] }} 
          transition={{ repeat: Infinity, duration: 5, ease: "easeInOut" }}
          src="https://cdn.jsdelivr.net/gh/jdecked/twemoji@latest/assets/svg/1f981.svg" 
          className="absolute top-40 right-1/2 w-20 h-20 opacity-40 -z-10 drop-shadow-xl" alt="Lion" 
        />

        {/* Hero Text (Left) */}
        <motion.div initial="hidden" animate="visible" variants={staggerContainer} className="w-full lg:w-[45%] flex flex-col items-start text-left z-10 mb-16 lg:mb-0">
          
          <motion.div variants={fadeUp} className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-green-50 border border-green-100 mb-8 text-sm font-black text-green-600 uppercase tracking-wide">
            <Gamepad2 className="w-5 h-5 text-green-500" /> 100% Free Educational Game
          </motion.div>
          
          <motion.h1 variants={fadeUp} className="text-6xl sm:text-7xl lg:text-[6rem] font-black text-[#1A1A2E] leading-[1.05] tracking-tight mb-6">
            Play. Learn.<br/>
            Level <span className="text-[#93D94E]">Up!</span>
          </motion.h1>
          
          <motion.p variants={fadeUp} className="text-xl text-gray-500 mb-10 font-bold leading-relaxed max-w-md">
            The most fun way for kids to master Math, Science, and English! Battle friends, earn coins, and unlock awesome rewards.
          </motion.p>
          
          <motion.div variants={fadeUp} className="flex flex-col sm:flex-row gap-4 w-full sm:w-auto items-center mb-8">
            <Button asChild className="w-full sm:w-auto bg-[#93D94E] hover:bg-[#86ca46] text-white rounded-[2rem] px-12 py-8 text-xl shadow-xl shadow-[#93D94E]/30 border-b-[6px] border-[#65a30d] active:border-b-0 active:translate-y-1.5 transition-all font-black uppercase tracking-wider">
              <Link href="/register">PLAY NOW <ChevronRight className="w-7 h-7 ml-2" /></Link>
            </Button>
          </motion.div>

          <motion.div variants={fadeUp} className="flex flex-wrap items-center gap-6 text-sm font-bold text-gray-400">
            <span className="flex items-center gap-2"><CheckCircle2 className="w-5 h-5 text-[#93D94E]" /> No Ads</span>
            <span className="flex items-center gap-2"><CheckCircle2 className="w-5 h-5 text-[#93D94E]" /> No Credit Card</span>
            <span className="flex items-center gap-2"><ShieldCheck className="w-5 h-5 text-[#93D94E]" /> 100% Kid Safe</span>
          </motion.div>
        </motion.div>

        {/* Hero Visuals (Right - Floating Island & Mockup) */}
        <div className="w-full lg:w-[55%] relative h-[500px] sm:h-[600px] lg:h-[700px] flex items-center justify-center">
          
          {/* Floating 3D Island & Character (Foreground) */}
          <motion.div style={{ y: yFloating1 }} className="absolute bottom-0 left-0 sm:left-10 z-20 w-full sm:w-auto flex flex-col items-center">
            <div className="relative">
              {/* Star Particle */}
              <motion.div animate={{ rotate: 360 }} transition={{ repeat: Infinity, duration: 20, ease: "linear" }} className="absolute -top-10 -left-10 text-yellow-400"><Star className="w-16 h-16 fill-current" /></motion.div>
              
              {/* Massive Floating Octopus Hero */}
              <motion.img 
                animate={{ y: [-15, 15, -15], rotate: [-2, 2, -2] }} 
                transition={{ repeat: Infinity, duration: 6, ease: "easeInOut" }}
                src="https://cdn.jsdelivr.net/gh/jdecked/twemoji@latest/assets/svg/1f419.svg" 
                className="w-[280px] h-[280px] sm:w-[400px] sm:h-[400px] drop-shadow-[0_30px_50px_rgba(147,217,78,0.5)] z-20 relative" alt="Lerno Octopus Hero" 
              />
              
              {/* Floating Game Console Element */}
              <motion.img 
                animate={{ y: [-10, 10, -10], rotate: [-15, 10, -15] }} 
                transition={{ repeat: Infinity, duration: 5, delay: 1, ease: "easeInOut" }}
                src="https://cdn.jsdelivr.net/gh/jdecked/twemoji@latest/assets/svg/1f3ae.svg" 
                className="absolute top-10 -right-16 w-24 h-24 z-30 drop-shadow-2xl" alt="Game Console" 
              />

              {/* Floating Books Element */}
              <motion.img 
                animate={{ y: [10, -10, 10], rotate: [10, -10, 10] }} 
                transition={{ repeat: Infinity, duration: 7, delay: 0.5, ease: "easeInOut" }}
                src="https://cdn.jsdelivr.net/gh/jdecked/twemoji@latest/assets/svg/1f4da.svg" 
                className="absolute top-1/2 -left-20 w-28 h-28 z-30 drop-shadow-2xl" alt="Books" 
              />

              {/* Floating Trophy */}
              <motion.div animate={{ y: [-10, 10, -10] }} transition={{ repeat: Infinity, duration: 4 }} className="absolute bottom-10 -right-12 w-24 h-24 bg-gradient-to-br from-yellow-300 to-yellow-500 rounded-3xl rotate-12 shadow-2xl flex items-center justify-center border-4 border-yellow-200 z-30">
                <Trophy className="w-12 h-12 text-yellow-900" />
              </motion.div>

              {/* The "Island" Base */}
              <div className="absolute -bottom-10 left-1/2 -translate-x-1/2 w-[130%] h-48 bg-gradient-to-b from-[#93D94E] to-[#65a30d] rounded-[100%] shadow-[0_30px_60px_rgba(101,163,13,0.4)] z-10 flex items-center justify-center overflow-hidden border-t-[12px] border-[#a3e635]">
                <div className="absolute w-full h-full opacity-20 bg-[radial-gradient(circle_at_center,_#000_2px,_transparent_2px)] bg-[size:15px_15px]"></div>
              </div>
            </div>
          </motion.div>

        </div>
      </section>

      {/* 
        =========================================
        2.5. TRUST MARQUEE
        =========================================
      */}
      <div className="w-full bg-gray-50 border-y border-gray-100 overflow-hidden py-8 flex items-center relative z-20">
        <div className="absolute left-0 w-32 h-full bg-gradient-to-r from-gray-50 to-transparent z-10"></div>
        <div className="absolute right-0 w-32 h-full bg-gradient-to-l from-gray-50 to-transparent z-10"></div>
        <div className="flex w-max animate-[marquee_20s_linear_infinite] items-center gap-16 px-8">
          {[...Array(2)].map((_, i) => (
            <div key={i} className="flex gap-16 items-center text-gray-400 font-black text-2xl uppercase tracking-widest opacity-40">
              <span>Trusted by Parents</span>
              <span className="w-2 h-2 bg-gray-300 rounded-full"></span>
              <span>Loved by Kids</span>
              <span className="w-2 h-2 bg-gray-300 rounded-full"></span>
              <span>100% Safe</span>
              <span className="w-2 h-2 bg-gray-300 rounded-full"></span>
              <span>Award Winning</span>
              <span className="w-2 h-2 bg-gray-300 rounded-full"></span>
            </div>
          ))}
        </div>
      </div>

      {/* 
        =========================================
        2.75. THE LEADERBOARD PODIUM
        =========================================
      */}
      <section className="py-24 max-w-7xl mx-auto px-6 relative z-20 overflow-hidden">
        
        {/* Floating Coins */}
        <motion.img 
          animate={{ y: [20, -20, 20], rotate: [0, 360, 0] }} 
          transition={{ repeat: Infinity, duration: 8, ease: "linear" }}
          src="https://cdn.jsdelivr.net/gh/jdecked/twemoji@latest/assets/svg/1fa99.svg" 
          className="absolute top-20 left-10 w-16 h-16 opacity-50 z-0" alt="Coin" 
        />
        <motion.img 
          animate={{ y: [-20, 20, -20], rotate: [360, 0, 360] }} 
          transition={{ repeat: Infinity, duration: 10, ease: "linear" }}
          src="https://cdn.jsdelivr.net/gh/jdecked/twemoji@latest/assets/svg/1fa99.svg" 
          className="absolute bottom-40 right-20 w-12 h-12 opacity-40 z-0" alt="Coin" 
        />

        <div className="text-center mb-16 relative z-10">
          <div className="inline-flex items-center gap-2 bg-purple-50 text-purple-600 font-black text-sm px-4 py-2 rounded-full mb-6 border border-purple-100 uppercase tracking-widest">
            <Swords className="w-4 h-4" /> Real-time Battles
          </div>
          <h2 className="text-4xl md:text-5xl font-black text-gray-900 mb-4 tracking-tight">Climb the Leaderboard!</h2>
          <p className="text-gray-500 font-bold text-lg">Challenge your friends and show off your brain power.</p>
        </div>

        <div className="flex flex-col md:flex-row items-end justify-center gap-4 md:gap-8 max-w-4xl mx-auto h-[400px] relative">
          
          {/* Silver - 2nd */}
          <motion.div initial={{ opacity: 0, y: 50 }} whileInView={{ opacity: 1, y: 0 }} transition={{ delay: 0.2 }} className="w-full md:w-1/3 flex flex-col items-center">
            <div className="mb-4 relative">
              <div className="absolute -top-4 -right-2 bg-gray-200 text-gray-700 text-xs font-black px-2 py-1 rounded-full border-2 border-white z-10">2nd</div>
              <img src="https://cdn.jsdelivr.net/gh/jdecked/twemoji@latest/assets/svg/1f435.svg" className="w-20 h-20 drop-shadow-lg relative z-0" alt="Monkey Avatar" />
            </div>
            <div className="w-full h-48 bg-gradient-to-b from-gray-200 to-gray-300 rounded-t-3xl border-t-8 border-gray-100 shadow-[0_20px_40px_rgba(0,0,0,0.1)] flex flex-col items-center justify-start pt-6 relative overflow-hidden">
              <div className="absolute inset-0 opacity-20 bg-[radial-gradient(circle_at_center,_#fff_2px,_transparent_2px)] bg-[size:10px_10px]"></div>
              <span className="text-3xl font-black text-gray-500 mb-1">2,450</span>
              <span className="text-xs font-bold text-gray-400 uppercase">Points</span>
            </div>
          </motion.div>

          {/* Gold - 1st */}
          <motion.div initial={{ opacity: 0, y: 80 }} whileInView={{ opacity: 1, y: 0 }} className="w-full md:w-1/3 flex flex-col items-center z-10">
            <div className="mb-4 relative">
              <div className="absolute -top-6 left-1/2 -translate-x-1/2"><Trophy className="w-8 h-8 text-yellow-400 fill-current drop-shadow-md" /></div>
              <div className="absolute -top-2 -right-4 bg-yellow-400 text-yellow-900 text-xs font-black px-2 py-1 rounded-full border-2 border-white z-10">1st</div>
              <img src="https://cdn.jsdelivr.net/gh/jdecked/twemoji@latest/assets/svg/1f981.svg" className="w-28 h-28 drop-shadow-2xl relative z-0" alt="Lion Avatar" />
            </div>
            <div className="w-full h-64 bg-gradient-to-b from-yellow-300 to-yellow-500 rounded-t-3xl border-t-8 border-yellow-200 shadow-[0_20px_50px_rgba(250,204,21,0.3)] flex flex-col items-center justify-start pt-6 relative overflow-hidden">
              <div className="absolute inset-0 opacity-20 bg-[radial-gradient(circle_at_center,_#fff_2px,_transparent_2px)] bg-[size:10px_10px]"></div>
              <span className="text-4xl font-black text-yellow-900 mb-1">3,120</span>
              <span className="text-sm font-bold text-yellow-700 uppercase">Points</span>
            </div>
          </motion.div>

          {/* Bronze - 3rd */}
          <motion.div initial={{ opacity: 0, y: 30 }} whileInView={{ opacity: 1, y: 0 }} transition={{ delay: 0.4 }} className="w-full md:w-1/3 flex flex-col items-center">
            <div className="mb-4 relative">
              <div className="absolute -top-4 -right-2 bg-orange-300 text-orange-900 text-xs font-black px-2 py-1 rounded-full border-2 border-white z-10">3rd</div>
              <img src="https://cdn.jsdelivr.net/gh/jdecked/twemoji@latest/assets/svg/1f993.svg" className="w-16 h-16 drop-shadow-lg relative z-0" alt="Zebra Avatar" />
            </div>
            <div className="w-full h-32 bg-gradient-to-b from-orange-200 to-orange-300 rounded-t-3xl border-t-8 border-orange-100 shadow-[0_20px_40px_rgba(0,0,0,0.08)] flex flex-col items-center justify-start pt-4 relative overflow-hidden">
              <div className="absolute inset-0 opacity-20 bg-[radial-gradient(circle_at_center,_#fff_2px,_transparent_2px)] bg-[size:10px_10px]"></div>
              <span className="text-2xl font-black text-orange-800 mb-1">1,890</span>
              <span className="text-xs font-bold text-orange-600 uppercase">Points</span>
            </div>
          </motion.div>

        </div>
      </section>

      {/* 
        =========================================
        3. GAME FEATURES
        =========================================
      */}
      <section className="py-24 max-w-7xl mx-auto px-6 relative z-20">
        <div className="text-center mb-20">
          <h2 className="text-5xl md:text-6xl font-black text-gray-900 mb-6 tracking-tight">The Ultimate Learning Game</h2>
          <p className="text-gray-500 font-bold text-xl max-w-2xl mx-auto">Master new subjects through exciting gameplay, collect massive rewards, and dominate the leaderboard!</p>
        </div>

        <motion.div variants={staggerContainer} initial="hidden" whileInView="visible" viewport={{ once: true, amount: 0.1 }} className="grid grid-cols-1 md:grid-cols-3 gap-8">
          
          {/* Card 1 */}
          <motion.div variants={fadeUp} className="bg-[#E8FAEC] rounded-[3rem] p-10 border-[4px] border-[#c0f0a5] flex flex-col items-center text-center hover:-translate-y-4 transition-transform cursor-pointer overflow-hidden relative group shadow-xl shadow-green-100">
            <div className="w-24 h-24 bg-[#93D94E] rounded-3xl flex items-center justify-center text-white mb-8 shadow-inner shadow-white/30 border-b-[6px] border-[#65a30d] rotate-3 group-hover:rotate-12 transition-transform">
              <Gamepad2 className="w-12 h-12" />
            </div>
            <h3 className="text-3xl font-black text-gray-900 mb-4">Epic Mini Games</h3>
            <p className="text-gray-600 text-lg font-bold leading-relaxed">Solve math puzzles, spell words, and clear levels to earn massive XP!</p>
          </motion.div>

          {/* Card 2 */}
          <motion.div variants={fadeUp} className="bg-[#FFF5F5] rounded-[3rem] p-10 border-[4px] border-[#ffc6c6] flex flex-col items-center text-center hover:-translate-y-4 transition-transform cursor-pointer overflow-hidden relative group shadow-xl shadow-red-100">
            <div className="w-24 h-24 bg-[#FF7A7A] rounded-3xl flex items-center justify-center text-white mb-8 shadow-inner shadow-white/30 border-b-[6px] border-[#dc2626] -rotate-3 group-hover:-rotate-12 transition-transform">
              <Swords className="w-12 h-12" />
            </div>
            <h3 className="text-3xl font-black text-gray-900 mb-4">1v1 Battles</h3>
            <p className="text-gray-600 text-lg font-bold leading-relaxed">Challenge your friends in real-time quiz battles. Winner takes the trophies!</p>
          </motion.div>

          {/* Card 3 */}
          <motion.div variants={fadeUp} className="bg-[#FFFAF0] rounded-[3rem] p-10 border-[4px] border-[#ffe8b3] flex flex-col items-center text-center hover:-translate-y-4 transition-transform cursor-pointer overflow-hidden relative group shadow-xl shadow-orange-100">
            <div className="w-24 h-24 bg-[#FFD166] rounded-3xl flex items-center justify-center text-orange-900 mb-8 shadow-inner shadow-white/50 border-b-[6px] border-[#d97706] rotate-3 group-hover:rotate-12 transition-transform">
              <Zap className="w-12 h-12" />
            </div>
            <h3 className="text-3xl font-black text-gray-900 mb-4">Unlock Everything</h3>
            <p className="text-gray-600 text-lg font-bold leading-relaxed">Collect shiny coins to buy rare avatars, stickers, and profile shields!</p>
          </motion.div>

        </motion.div>
      </section>

      {/* 
        =========================================
        3.5. EXPLORE SUBJECTS
        =========================================
      */}
      <section className="py-24 max-w-7xl mx-auto px-6 relative z-20">
        <div className="text-center mb-16">
          <div className="inline-flex items-center gap-2 bg-blue-50 text-blue-600 font-black text-sm px-4 py-2 rounded-full mb-6 border border-blue-100 uppercase tracking-widest">
            📚 Core Curriculum
          </div>
          <h2 className="text-4xl md:text-5xl font-black text-gray-900 mb-4 tracking-tight">Explore the Worlds!</h2>
          <p className="text-gray-500 font-bold text-lg">We make school subjects feel like an epic adventure.</p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {/* Math */}
          <motion.div initial={{ opacity: 0, y: 30 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} className="bg-[#4AC4FA] rounded-[3rem] p-10 flex flex-col items-center text-center shadow-xl shadow-[#4AC4FA]/30 border-b-[8px] border-[#0284c7] hover:-translate-y-2 transition-transform cursor-pointer relative overflow-hidden group">
            <div className="absolute inset-0 opacity-10 bg-[radial-gradient(circle_at_center,_#fff_2px,_transparent_2px)] bg-[size:15px_15px]"></div>
            <motion.img animate={{ y: [-5, 5, -5] }} transition={{ repeat: Infinity, duration: 4 }} src="https://cdn.jsdelivr.net/gh/jdecked/twemoji@latest/assets/svg/1f9ee.svg" className="w-28 h-28 drop-shadow-2xl mb-6 relative z-10 group-hover:scale-110 transition-transform" alt="Abacus" />
            <h3 className="text-3xl font-black text-white mb-2 relative z-10 drop-shadow-md">Maths Magic</h3>
            <p className="text-blue-100 font-bold relative z-10">Fractions, Geometry, and numbers made fun!</p>
          </motion.div>

          {/* Science */}
          <motion.div initial={{ opacity: 0, y: 30 }} whileInView={{ opacity: 1, y: 0 }} transition={{ delay: 0.1 }} viewport={{ once: true }} className="bg-[#93D94E] rounded-[3rem] p-10 flex flex-col items-center text-center shadow-xl shadow-[#93D94E]/30 border-b-[8px] border-[#65a30d] hover:-translate-y-2 transition-transform cursor-pointer relative overflow-hidden group">
            <div className="absolute inset-0 opacity-10 bg-[radial-gradient(circle_at_center,_#fff_2px,_transparent_2px)] bg-[size:15px_15px]"></div>
            <motion.img animate={{ y: [-5, 5, -5], rotate: [-5, 5, -5] }} transition={{ repeat: Infinity, duration: 5 }} src="https://cdn.jsdelivr.net/gh/jdecked/twemoji@latest/assets/svg/1f52c.svg" className="w-28 h-28 drop-shadow-2xl mb-6 relative z-10 group-hover:scale-110 transition-transform" alt="Microscope" />
            <h3 className="text-3xl font-black text-white mb-2 relative z-10 drop-shadow-md">Science Lab</h3>
            <p className="text-green-100 font-bold relative z-10">Explore nature, physics, and the universe!</p>
          </motion.div>

          {/* English */}
          <motion.div initial={{ opacity: 0, y: 30 }} whileInView={{ opacity: 1, y: 0 }} transition={{ delay: 0.2 }} viewport={{ once: true }} className="bg-[#8A79F4] rounded-[3rem] p-10 flex flex-col items-center text-center shadow-xl shadow-[#8A79F4]/30 border-b-[8px] border-[#6d28d9] hover:-translate-y-2 transition-transform cursor-pointer relative overflow-hidden group">
            <div className="absolute inset-0 opacity-10 bg-[radial-gradient(circle_at_center,_#fff_2px,_transparent_2px)] bg-[size:15px_15px]"></div>
            <motion.img animate={{ y: [-5, 5, -5] }} transition={{ repeat: Infinity, duration: 6 }} src="https://cdn.jsdelivr.net/gh/jdecked/twemoji@latest/assets/svg/1f4d6.svg" className="w-28 h-28 drop-shadow-2xl mb-6 relative z-10 group-hover:scale-110 transition-transform" alt="Open Book" />
            <h3 className="text-3xl font-black text-white mb-2 relative z-10 drop-shadow-md">Word Wizard</h3>
            <p className="text-purple-100 font-bold relative z-10">Spelling, grammar, and epic storytelling.</p>
          </motion.div>
        </div>
      </section>

      {/* 
        =========================================
        3.75. HOW IT WORKS
        =========================================
      */}
      <section className="py-24 bg-gray-50 border-y border-gray-100 overflow-hidden">
        <div className="max-w-7xl mx-auto px-6 text-center">
          <h2 className="text-4xl font-black text-gray-900 mb-16 tracking-tight">How the Game Works</h2>
          
          <div className="flex flex-col md:flex-row items-center justify-center gap-12 relative">
            
            {/* Connecting Dashed Line */}
            <div className="hidden md:block absolute top-1/2 left-[20%] right-[20%] h-2 border-t-8 border-dashed border-gray-200 -translate-y-1/2 z-0"></div>

            <motion.div initial={{ opacity: 0, scale: 0.8 }} whileInView={{ opacity: 1, scale: 1 }} className="flex flex-col items-center relative z-10 w-64">
              <div className="w-24 h-24 bg-white rounded-[2rem] border-4 border-blue-400 shadow-xl flex items-center justify-center text-blue-500 mb-6 rotate-3">
                <Gamepad2 className="w-12 h-12" />
              </div>
              <h3 className="text-2xl font-black text-gray-900 mb-2">1. Play</h3>
              <p className="text-gray-500 font-bold">Complete fun mini-games to master concepts.</p>
            </motion.div>

            <motion.div initial={{ opacity: 0, scale: 0.8 }} whileInView={{ opacity: 1, scale: 1 }} transition={{ delay: 0.2 }} className="flex flex-col items-center relative z-10 w-64">
              <div className="w-24 h-24 bg-white rounded-[2rem] border-4 border-yellow-400 shadow-xl flex items-center justify-center text-yellow-500 mb-6 -rotate-3">
                <Star className="w-12 h-12 fill-current" />
              </div>
              <h3 className="text-2xl font-black text-gray-900 mb-2">2. Earn</h3>
              <p className="text-gray-500 font-bold">Collect gold coins and level up your avatar.</p>
            </motion.div>

            <motion.div initial={{ opacity: 0, scale: 0.8 }} whileInView={{ opacity: 1, scale: 1 }} transition={{ delay: 0.4 }} className="flex flex-col items-center relative z-10 w-64">
              <div className="w-24 h-24 bg-white rounded-[2rem] border-4 border-red-400 shadow-xl flex items-center justify-center text-red-500 mb-6 rotate-3">
                <Trophy className="w-12 h-12 fill-current" />
              </div>
              <h3 className="text-2xl font-black text-gray-900 mb-2">3. Win</h3>
              <p className="text-gray-500 font-bold">Battle friends and climb the leaderboard!</p>
            </motion.div>

          </div>
        </div>
      </section>

      {/* 
        =========================================
        4. BOTTOM CTA
        =========================================
      */}
      <section className="py-20 px-6 max-w-5xl mx-auto relative z-20">
        
        {/* Floating Animals near CTA */}
        <motion.img 
          animate={{ y: [-15, 15, -15], rotate: [-15, -5, -15] }} 
          transition={{ repeat: Infinity, duration: 5, ease: "easeInOut" }}
          src="https://cdn.jsdelivr.net/gh/jdecked/twemoji@latest/assets/svg/1f435.svg" 
          className="absolute -top-10 left-0 w-24 h-24 z-30 drop-shadow-2xl" alt="Monkey" 
        />
        <motion.img 
          animate={{ y: [15, -15, 15], rotate: [10, 20, 10] }} 
          transition={{ repeat: Infinity, duration: 6, ease: "easeInOut" }}
          src="https://cdn.jsdelivr.net/gh/jdecked/twemoji@latest/assets/svg/1f42f.svg" 
          className="absolute -bottom-10 right-0 w-28 h-28 z-30 drop-shadow-2xl" alt="Tiger" 
        />

        <motion.div initial={{ opacity: 0, scale: 0.95 }} whileInView={{ opacity: 1, scale: 1 }} className="bg-gradient-to-b from-[#93D94E] to-[#65a30d] rounded-[4rem] p-16 md:p-24 text-center relative shadow-2xl shadow-[#93D94E]/40 border-b-[12px] border-[#4d7c0f] overflow-hidden">
          
          <div className="absolute inset-0 opacity-10 bg-[radial-gradient(circle_at_center,_#fff_3px,_transparent_3px)] bg-[size:30px_30px]"></div>

          <Star className="absolute top-10 right-20 w-12 h-12 text-yellow-300 fill-current opacity-90 rotate-45" />
          <Star className="absolute bottom-20 left-20 w-8 h-8 text-yellow-300 fill-current opacity-70 -rotate-12" />

          <h2 className="text-5xl md:text-7xl font-black text-white mb-6 leading-tight drop-shadow-md relative z-10">Start Playing<br/>Right Now!</h2>
          <p className="text-green-100 font-bold text-2xl mb-12 max-w-2xl mx-auto relative z-10">Join thousands of kids already having fun and getting smarter.</p>
          
          <div className="relative z-10">
            <Button asChild className="bg-[#FFD166] hover:bg-[#f7c03c] text-yellow-950 rounded-[2.5rem] px-16 py-10 text-2xl font-black shadow-2xl hover:-translate-y-2 transition-transform border-b-[8px] border-yellow-600 active:border-b-0 active:translate-y-0 uppercase tracking-widest">
              <Link href="/register">PLAY FOR FREE 🚀</Link>
            </Button>
          </div>
        </motion.div>
      </section>

      {/* 
        =========================================
        5. FOOTER
        =========================================
      */}
      <footer className="bg-gray-50 pt-16 pb-8 text-center mt-20">
        <div className="max-w-7xl mx-auto px-6 flex flex-col items-center">
          <Logo className="mb-6 scale-110 grayscale opacity-40 hover:grayscale-0 hover:opacity-100 transition-all" />
          <p className="text-lg font-bold text-gray-400 mb-8 max-w-md">The #1 Gamified Learning App.</p>
          <div className="flex gap-8 text-sm font-black text-gray-400 uppercase tracking-wider mb-12">
            <Link href="#" className="hover:text-gray-900 transition-colors">Support</Link>
            <Link href="#" className="hover:text-gray-900 transition-colors">Parents</Link>
            <Link href="#" className="hover:text-gray-900 transition-colors">Privacy</Link>
          </div>
          <p className="text-xs font-bold text-gray-300">© 2026 Lerno Education. All rights reserved.</p>
        </div>
      </footer>

    </div>
  );
}
