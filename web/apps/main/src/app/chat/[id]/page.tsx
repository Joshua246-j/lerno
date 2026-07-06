"use client";

import { useState } from "react";
import { Send, ArrowLeft, MoreVertical, Phone, Video, Smile, Paperclip, CheckCheck } from "lucide-react";
import { motion } from "framer-motion";
import Link from "next/link";
import { Button } from "@/components/ui/button";

const MOCK_MESSAGES = [
  { id: 1, text: "Hey! Ready for the Quiz Battle?", sender: "friend", time: "10:30 AM" },
  { id: 2, text: "Almost! Just finishing my Math lesson.", sender: "me", time: "10:31 AM", status: "read" },
  { id: 3, text: "Awesome. I unlocked the Golden Crown today! 👑", sender: "friend", time: "10:33 AM" },
  { id: 4, text: "Whoa, that's so cool! I'm saving up for it.", sender: "me", time: "10:34 AM", status: "read" },
  { id: 5, text: "Let me know when you're ready to play.", sender: "friend", time: "10:35 AM" },
];

export default function ChatPage() {
  const [messages, setMessages] = useState(MOCK_MESSAGES);
  const [input, setInput] = useState("");

  const handleSend = (e: React.FormEvent) => {
    e.preventDefault();
    if (!input.trim()) return;
    
    setMessages([
      ...messages, 
      { 
        id: Date.now(), 
        text: input, 
        sender: "me", 
        time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
        status: "sent"
      }
    ]);
    setInput("");
  };

  return (
    <div className="min-h-screen bg-[#F4F7FF] font-sans flex flex-col max-w-4xl mx-auto md:py-8 h-[100dvh] md:h-screen">
      
      {/* 
        ====================================================
        CHAT HEADER
        ====================================================
      */}
      <header className="bg-white p-4 md:rounded-t-[2.5rem] shadow-sm border-b border-gray-100 flex items-center justify-between z-10 relative">
        <div className="flex items-center gap-4">
          <Link href="/social" className="w-10 h-10 bg-gray-50 hover:bg-gray-100 rounded-full flex items-center justify-center text-gray-500 transition-colors">
            <ArrowLeft className="w-5 h-5" />
          </Link>
          
          <div className="relative">
            <div className="w-12 h-12 bg-blue-100 rounded-2xl overflow-hidden border-2 border-white shadow-sm">
              <img src="https://api.dicebear.com/7.x/micah/svg?seed=sam&backgroundColor=transparent" className="w-full h-full" />
            </div>
            <div className="absolute -bottom-1 -right-1 w-4 h-4 bg-green-500 border-2 border-white rounded-full"></div>
          </div>
          
          <div>
            <h2 className="font-black text-gray-900 leading-tight">Sam The Scholar</h2>
            <p className="text-xs font-bold text-green-500">Online</p>
          </div>
        </div>

        <div className="flex items-center gap-2">
          <button className="w-10 h-10 bg-gray-50 hover:bg-gray-100 rounded-full flex items-center justify-center text-gray-400 transition-colors hidden sm:flex"><Phone className="w-4 h-4" /></button>
          <button className="w-10 h-10 bg-gray-50 hover:bg-gray-100 rounded-full flex items-center justify-center text-gray-400 transition-colors hidden sm:flex"><Video className="w-4 h-4" /></button>
          <button className="w-10 h-10 bg-gray-50 hover:bg-gray-100 rounded-full flex items-center justify-center text-gray-400 transition-colors"><MoreVertical className="w-4 h-4" /></button>
        </div>
      </header>

      {/* 
        ====================================================
        CHAT MESSAGES AREA
        ====================================================
      */}
      <div className="flex-1 overflow-y-auto p-4 md:p-8 md:bg-white md:border-x border-gray-100 flex flex-col gap-4">
        {/* Date Divider */}
        <div className="flex justify-center mb-4">
          <div className="bg-gray-100 text-gray-400 text-xs font-bold px-4 py-1 rounded-full">Today</div>
        </div>

        {messages.map((msg, index) => {
          const isMe = msg.sender === "me";
          return (
            <motion.div 
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.1 }}
              key={msg.id} 
              className={`flex flex-col ${isMe ? 'items-end' : 'items-start'} max-w-[85%] ${isMe ? 'self-end' : 'self-start'}`}
            >
              <div className="flex items-end gap-2">
                {!isMe && (
                  <img src="https://api.dicebear.com/7.x/micah/svg?seed=sam&backgroundColor=transparent" className="w-8 h-8 rounded-full bg-blue-50 border border-white shadow-sm mb-1" />
                )}
                
                <div className={`p-4 shadow-sm ${
                  isMe 
                    ? 'bg-gradient-to-br from-[#8A79F4] to-[#7864eb] text-white rounded-[2rem] rounded-br-md' 
                    : 'bg-white text-gray-800 rounded-[2rem] rounded-bl-md border border-gray-50'
                }`}>
                  <p className="font-medium text-sm leading-relaxed">{msg.text}</p>
                </div>
              </div>
              
              <div className="flex items-center gap-1 mt-1 px-2">
                <span className="text-[10px] font-bold text-gray-400">{msg.time}</span>
                {isMe && msg.status === "read" && <CheckCheck className="w-3 h-3 text-blue-500" />}
                {isMe && msg.status === "sent" && <CheckCheck className="w-3 h-3 text-gray-400" />}
              </div>
            </motion.div>
          );
        })}
      </div>

      {/* 
        ====================================================
        CHAT INPUT AREA
        ====================================================
      */}
      <div className="bg-white p-4 md:rounded-b-[2.5rem] shadow-[0_-10px_40px_rgba(0,0,0,0.02)] border-t border-gray-100 relative z-10 pb-8 md:pb-4">
        <form onSubmit={handleSend} className="flex items-center gap-3">
          <button type="button" className="w-10 h-10 flex-shrink-0 bg-gray-50 hover:bg-gray-100 rounded-full flex items-center justify-center text-gray-400 transition-colors">
            <Paperclip className="w-5 h-5" />
          </button>
          
          <div className="flex-1 bg-gray-50 rounded-full flex items-center pr-2 border border-gray-100 focus-within:border-[#8A79F4] focus-within:ring-2 focus-within:ring-[#8A79F4]/20 transition-all">
            <button type="button" className="w-10 h-10 flex items-center justify-center text-gray-400 hover:text-yellow-500 transition-colors"><Smile className="w-5 h-5" /></button>
            <input 
              type="text" 
              placeholder="Type your message..." 
              className="flex-1 bg-transparent border-none focus:outline-none focus:ring-0 text-sm font-medium py-3"
              value={input}
              onChange={(e) => setInput(e.target.value)}
            />
          </div>

          <Button type="submit" className="w-12 h-12 flex-shrink-0 bg-[#93D94E] hover:bg-[#86ca46] text-green-900 rounded-full shadow-lg shadow-[#93D94E]/30 flex items-center justify-center hover:-translate-y-0.5 transition-transform">
            <Send className="w-5 h-5 ml-1" />
          </Button>
        </form>
      </div>

    </div>
  );
}
