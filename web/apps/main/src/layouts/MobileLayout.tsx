import { BottomNavBar } from "@/components/navigation/BottomNavBar";

interface MobileLayoutProps {
  children: React.ReactNode;
}

export function MobileLayout({ children }: MobileLayoutProps) {
  return (
    <div className="min-h-screen bg-gray-100 flex flex-col items-center sm:py-8">
      <div className="w-full sm:max-w-[400px] min-h-screen sm:min-h-[850px] sm:h-[850px] bg-white relative sm:shadow-2xl sm:rounded-[2.5rem] sm:border-8 sm:border-gray-900 overflow-hidden flex flex-col">
        {/* Main Content Area */}
        <main className="flex-1 overflow-y-auto pb-24 hide-scrollbar">
          {children}
        </main>
        
        {/* Navigation */}
        <BottomNavBar />
      </div>
    </div>
  );
}
