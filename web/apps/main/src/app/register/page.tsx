"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/features/auth/hooks/useAuth";
import { useAudio } from "@/hooks/useAudio";
import { motion, AnimatePresence } from "framer-motion";
import { ChevronRight, ArrowLeft, CheckCircle2 } from "lucide-react";
import Link from "next/link";
import { Button } from "@/components/ui/button";

const AVATARS = [
  { id: "micah", seed: "hero_boy", color: "bg-[#4AC4FA]" },
  { id: "micah", seed: "hero_girl", color: "bg-[#FF7A7A]" },
  { id: "big-smile", seed: "monster1", color: "bg-[#93D94E]" },
  { id: "big-smile", seed: "monster2", color: "bg-[#FFD166]" },
];

export default function RegisterPage() {
  const router = useRouter();
  const { play } = useAudio();
  const { register } = useAuth();
  
  const [step, setStep] = useState(1);
  const [name, setName] = useState("");
  const [selectedAvatar, setSelectedAvatar] = useState(0);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleNext = (e: React.FormEvent) => {
    e.preventDefault();
    if (name.trim()) {
      play("click");
      setStep(2);
    }
  };

  const handleRegister = async () => {
    play("correct");
    setIsSubmitting(true);
    
    // Simulate network delay for effect
    setTimeout(() => {
      // Use mock auth (it requires phone, we just pass dummy)
      register({ name, phoneNumber: "555-0199", age: 8, avatarId: AVATARS[selectedAvatar].seed })
        .then(() => {
          router.push("/home");
        })
        .catch(() => {
          // If mock fails, just force route anyway for dummy preview
          router.push("/home");
        });
    }, 1000);
  };

  return (
    <div className="min-h-screen bg-[#F4F7FF] font-sans flex items-center justify-center p-6 relative overflow-hidden">
      
      {/* Background Decor */}
      <div className="absolute top-0 right-0 w-[500px] h-[500px] bg-gradient-to-br from-[#8A79F4]/20 to-transparent rounded-full blur-[80px] -z-10 transform translate-x-1/2 -translate-y-1/2 pointer-events-none"></div>
      <div className="absolute bottom-0 left-0 w-[500px] h-[500px] bg-gradient-to-tr from-[#4AC4FA]/20 to-transparent rounded-full blur-[80px] -z-10 transform -translate-x-1/2 translate-y-1/2 pointer-events-none"></div>

      <div className="w-full max-w-md relative z-10">
        
        {/* Back Button */}
        <Link href="/" className="absolute -top-16 left-0 w-12 h-12 bg-white rounded-full shadow-sm flex items-center justify-center text-gray-500 hover:text-gray-900 transition-colors border border-gray-100">
          <ArrowLeft className="w-6 h-6" />
        </Link>

        <div className="bg-white rounded-[2.5rem] shadow-[0_20px_60px_rgba(0,0,0,0.05)] border border-gray-100 overflow-hidden relative">
          
          <div className="h-2 w-full bg-gray-100">
            <div className={`h-full bg-gradient-to-r from-[#4AC4FA] to-[#8A79F4] transition-all duration-500 ${step === 1 ? 'w-1/2' : 'w-full'}`}></div>
          </div>

          <div className="p-8 md:p-10">
            <AnimatePresence mode="wait">
              
              {/* STEP 1: NAME */}
              {step === 1 && (
                <motion.div key="step1" initial={{ opacity: 0, x: -20 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: 20 }} transition={{ duration: 0.2 }}>
                  <div className="w-16 h-16 bg-purple-50 text-[#8A79F4] rounded-2xl flex items-center justify-center mb-6">
                    <span className="text-3xl">👋</span>
                  </div>
                  <h1 className="text-3xl font-black text-gray-900 mb-2 tracking-tight">What's your name?</h1>
                  <p className="text-gray-500 font-medium mb-8">This is how your friends will see you on the leaderboard.</p>
                  
                  <form onSubmit={handleNext}>
                    <input 
                      type="text" 
                      placeholder="Enter your hero name..." 
                      className="w-full bg-gray-50 border-2 border-gray-100 rounded-2xl px-6 py-5 text-lg font-bold text-gray-900 focus:outline-none focus:border-[#8A79F4] focus:ring-4 focus:ring-[#8A79F4]/20 transition-all mb-8"
                      value={name}
                      onChange={(e) => setName(e.target.value)}
                      autoFocus
                    />
                    <Button type="submit" disabled={!name.trim()} className="w-full bg-[#8A79F4] hover:bg-[#7864eb] text-white rounded-2xl py-7 text-lg font-black shadow-lg shadow-[#8A79F4]/20 border-b-4 border-[#6d28d9] active:border-b-0 active:translate-y-1 transition-all disabled:opacity-50 disabled:cursor-not-allowed">
                      Continue <ChevronRight className="w-5 h-5 ml-1" />
                    </Button>
                  </form>
                </motion.div>
              )}

              {/* STEP 2: AVATAR */}
              {step === 2 && (
                <motion.div key="step2" initial={{ opacity: 0, x: -20 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: 20 }} transition={{ duration: 0.2 }}>
                  <div className="w-16 h-16 bg-blue-50 text-[#4AC4FA] rounded-2xl flex items-center justify-center mb-6">
                    <span className="text-3xl">🎨</span>
                  </div>
                  <h1 className="text-3xl font-black text-gray-900 mb-2 tracking-tight">Pick your Avatar!</h1>
                  <p className="text-gray-500 font-medium mb-8">Don't worry, you can change this later in the store.</p>
                  
                  <div className="grid grid-cols-2 gap-4 mb-8">
                    {AVATARS.map((avatar, index) => (
                      <div 
                        key={index} 
                        onClick={() => { play("click"); setSelectedAvatar(index); }}
                        className={`relative cursor-pointer rounded-3xl p-1 transition-all duration-300 ${selectedAvatar === index ? 'bg-[#4AC4FA] scale-105 shadow-xl shadow-blue-500/20' : 'bg-transparent hover:bg-gray-50'}`}
                      >
                        {selectedAvatar === index && <div className="absolute -top-2 -right-2 w-8 h-8 bg-[#93D94E] rounded-full border-2 border-white flex items-center justify-center z-10 shadow-sm"><CheckCircle2 className="w-5 h-5 text-white" /></div>}
                        <div className={`w-full aspect-square ${avatar.color} rounded-[2rem] p-2 flex items-center justify-center overflow-hidden`}>
                          <img src={`https://api.dicebear.com/7.x/${avatar.id}/svg?seed=${avatar.seed}&backgroundColor=transparent`} className="w-full h-full drop-shadow-md" />
                        </div>
                      </div>
                    ))}
                  </div>

                  <Button onClick={handleRegister} disabled={isSubmitting} className="w-full bg-[#93D94E] hover:bg-[#86ca46] text-white rounded-2xl py-7 text-lg font-black shadow-lg shadow-[#93D94E]/30 border-b-4 border-[#65a30d] active:border-b-0 active:translate-y-1 transition-all disabled:opacity-50">
                    {isSubmitting ? "Creating..." : "Start Playing! 🚀"}
                  </Button>
                  
                  <button onClick={() => setStep(1)} className="w-full mt-4 text-gray-400 font-bold text-sm hover:text-gray-600">
                    Wait, go back
                  </button>
                </motion.div>
              )}

            </AnimatePresence>
          </div>
        </div>

        <p className="text-center mt-8 text-sm font-bold text-gray-500">
          Already have an account? <Link href="/login" className="text-[#8A79F4] hover:underline">Log in here</Link>
        </p>

      </div>
    </div>
  );
}
