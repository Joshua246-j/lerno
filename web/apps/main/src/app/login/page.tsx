"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/features/auth/hooks/useAuth";
import { useAudio } from "@/hooks/useAudio";
import { ChevronRight, ArrowLeft } from "lucide-react";
import Link from "next/link";
import { Button } from "@/components/ui/button";

export default function LoginPage() {
  const router = useRouter();
  const { play } = useAudio();
  const { login } = useAuth();
  
  const [phoneNumber, setPhoneNumber] = useState("555-0199");
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    play("correct");
    setIsSubmitting(true);
    
    setTimeout(() => {
      login(phoneNumber)
        .then(() => router.push("/home"))
        .catch(() => router.push("/home")); // Fallback to home for dummy UI
    }, 1000);
  };

  return (
    <div className="min-h-screen bg-[#F4F7FF] font-sans flex items-center justify-center p-6 relative overflow-hidden">
      
      {/* Background Decor */}
      <div className="absolute top-0 right-0 w-[500px] h-[500px] bg-gradient-to-br from-[#8A79F4]/20 to-transparent rounded-full blur-[80px] -z-10 transform translate-x-1/2 -translate-y-1/2 pointer-events-none"></div>
      <div className="absolute bottom-0 left-0 w-[500px] h-[500px] bg-gradient-to-tr from-[#FFD166]/20 to-transparent rounded-full blur-[80px] -z-10 transform -translate-x-1/2 translate-y-1/2 pointer-events-none"></div>

      <div className="w-full max-w-md relative z-10">
        
        {/* Back Button */}
        <Link href="/" className="absolute -top-16 left-0 w-12 h-12 bg-white rounded-full shadow-sm flex items-center justify-center text-gray-500 hover:text-gray-900 transition-colors border border-gray-100">
          <ArrowLeft className="w-6 h-6" />
        </Link>

        <div className="bg-white rounded-[2.5rem] shadow-[0_20px_60px_rgba(0,0,0,0.05)] border border-gray-100 overflow-hidden relative p-8 md:p-10">
          
          <div className="w-16 h-16 bg-yellow-50 text-yellow-500 rounded-2xl flex items-center justify-center mb-6">
            <span className="text-3xl">✨</span>
          </div>
          <h1 className="text-3xl font-black text-gray-900 mb-2 tracking-tight">Welcome back!</h1>
          <p className="text-gray-500 font-medium mb-8">Ready to continue your learning adventure?</p>
          
          <form onSubmit={handleLogin}>
            <input 
              type="tel" 
              placeholder="Enter your phone number..." 
              className="w-full bg-gray-50 border-2 border-gray-100 rounded-2xl px-6 py-5 text-lg font-bold text-gray-900 focus:outline-none focus:border-[#8A79F4] focus:ring-4 focus:ring-[#8A79F4]/20 transition-all mb-8"
              value={phoneNumber}
              onChange={(e) => setPhoneNumber(e.target.value)}
            />
            <Button type="submit" disabled={isSubmitting || !phoneNumber.trim()} className="w-full bg-[#8A79F4] hover:bg-[#7864eb] text-white rounded-2xl py-7 text-lg font-black shadow-lg shadow-[#8A79F4]/20 border-b-4 border-[#6d28d9] active:border-b-0 active:translate-y-1 transition-all disabled:opacity-50">
              {isSubmitting ? "Logging in..." : "Enter Lerno"} <ChevronRight className="w-5 h-5 ml-1 hidden sm:block" />
            </Button>
          </form>

        </div>

        <p className="text-center mt-8 text-sm font-bold text-gray-500">
          New to Lerno? <Link href="/register" className="text-[#8A79F4] hover:underline">Sign up for free</Link>
        </p>

      </div>
    </div>
  );
}
