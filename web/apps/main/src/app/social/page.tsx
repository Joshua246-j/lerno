"use client";

import { Users, Search, MessageCircle, UserPlus, ChevronLeft } from "lucide-react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";

const FRIENDS = [
  { id: "f1", name: "Sarah", grade: "Grade 3", status: "online", avatar: "sarah", score: 1450 },
  { id: "f2", name: "Mike", grade: "Grade 2", status: "offline", avatar: "mike", score: 980 },
  { id: "f3", name: "Leo", grade: "Grade 4", status: "playing", avatar: "leo", score: 2100 },
];

export default function SocialPage() {
  const router = useRouter();

  return (
    <div className="min-h-screen bg-[#F8F9FE] flex flex-col pb-24 md:pb-12">
      
      {/* Header */}
      <div className="bg-white p-4 flex items-center justify-between shadow-sm relative z-10 rounded-b-3xl">
        <div className="flex items-center gap-4">
          <button onClick={() => router.back()} className="p-2 bg-gray-50 rounded-full text-gray-600 hidden md:block">
            <ChevronLeft className="w-6 h-6" />
          </button>
          <h1 className="text-xl font-bold text-gray-900 flex items-center gap-2">
            <Users className="text-blue-500 w-6 h-6" /> Friends
          </h1>
        </div>
        
        <div className="flex gap-2">
          <button className="p-2 bg-gray-50 rounded-full text-gray-600">
            <Search className="w-5 h-5" />
          </button>
          <button className="p-2 bg-blue-50 rounded-full text-blue-600">
            <UserPlus className="w-5 h-5" />
          </button>
        </div>
      </div>

      <div className="flex-1 max-w-3xl w-full mx-auto p-6">
        
        <div className="flex gap-4 mb-6">
          <button className="flex-1 bg-gray-900 text-white rounded-xl py-2 font-bold text-sm shadow-sm">My Friends</button>
          <button className="flex-1 bg-white text-gray-500 rounded-xl py-2 font-bold text-sm shadow-sm">Requests (2)</button>
          <button className="flex-1 bg-white text-gray-500 rounded-xl py-2 font-bold text-sm shadow-sm">Leaderboard</button>
        </div>

        <div className="flex flex-col gap-4">
          {FRIENDS.map((friend) => (
            <div key={friend.id} className="bg-white p-4 rounded-3xl shadow-sm border border-gray-50 flex items-center gap-4 hover:shadow-md transition-shadow">
              
              <div className="relative">
                <div className="w-14 h-14 bg-gray-100 rounded-2xl flex items-center justify-center">
                   <img src={`https://api.dicebear.com/7.x/bottts/svg?seed=${friend.avatar}&backgroundColor=transparent`} className="w-10 h-10" />
                </div>
                {friend.status === "online" && <div className="absolute -bottom-1 -right-1 w-4 h-4 bg-green-500 border-2 border-white rounded-full"></div>}
                {friend.status === "playing" && <div className="absolute -bottom-1 -right-1 w-4 h-4 bg-purple-500 border-2 border-white rounded-full"></div>}
              </div>

              <div className="flex-1">
                <h3 className="font-bold text-gray-900 text-lg leading-none mb-1">{friend.name}</h3>
                <p className="text-gray-500 text-xs font-semibold">{friend.grade} • {friend.score} Trophies</p>
              </div>

              <div className="flex gap-2">
                <Button asChild size="sm" className="bg-blue-50 hover:bg-blue-100 text-blue-600 rounded-xl h-10 px-3 shadow-none">
                  <Link href={`/chat/${friend.id}`}>
                    <MessageCircle className="w-5 h-5" />
                  </Link>
                </Button>
              </div>
            </div>
          ))}
        </div>

      </div>
    </div>
  );
}
