"use client";

import { useCourses } from "@/features/courses/hooks/useCourses";
import { Search, Play } from "lucide-react";
import { Button } from "@/components/ui/button";

export default function CoursesPage() {
  const { data: courses, isLoading, error } = useCourses();

  return (
    <div className="flex flex-col min-h-screen bg-[#F8F9FE] p-6 pb-24">
      {/* Header */}
      <div className="flex items-center justify-between mb-8">
        <h1 className="text-2xl font-bold text-gray-900">My Courses</h1>
        <button className="text-gray-500 hover:text-blue-500 transition-colors">
          <Search className="w-6 h-6" />
        </button>
      </div>

      {/* Courses List */}
      <div className="flex flex-col gap-6">
        {isLoading && <p className="text-gray-500 text-center py-10 animate-pulse">Loading courses...</p>}
        {error && <p className="text-red-500 text-center py-10">Failed to load courses</p>}
        
        {courses?.map((course) => (
          <div 
            key={course.id} 
            className={`relative overflow-hidden rounded-3xl ${course.color} p-6 text-white shadow-[0_8px_30px_rgb(0,0,0,0.12)] hover:scale-[1.02] transition-transform`}
          >
            <div className="relative z-10 w-2/3">
              <h2 className="text-2xl font-extrabold mb-2 leading-tight">{course.title}</h2>
              <p className="text-sm text-white/90 mb-6 font-medium line-clamp-2">{course.description}</p>
              <div className="flex items-center justify-between">
                <Button className="bg-white text-gray-900 hover:bg-gray-50 rounded-full px-6 py-5 font-bold shadow-sm">
                  <Play className="w-4 h-4 mr-2 fill-current" /> Start
                </Button>
                <span className="text-sm font-bold opacity-80">{course.completedLessons}/{course.totalLessons}</span>
              </div>
            </div>
            {/* Asset */}
            <div className="absolute right-[-20px] bottom-[-20px] w-40 h-40 opacity-90 mix-blend-luminosity">
              <img src="https://api.dicebear.com/7.x/bottts/svg?seed=course&backgroundColor=transparent" className="w-full h-full object-contain" alt="" />
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
