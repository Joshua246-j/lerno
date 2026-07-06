import { TooltipProvider } from "@/components/ui/tooltip";
import { Toaster } from "@/components/ui/sonner";
import { TopNavBar } from "@/components/navigation/TopNavBar";
import { BottomNavBar } from "@/components/navigation/BottomNavBar";
import { QueryProvider } from "@/providers/QueryProvider";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({ 
  subsets: ["latin"],
  variable: "--font-inter"
});

export const metadata = {
  title: "Lerno | Learn with Fun",
  description: "A gamified kids learning application with battles and mini-games.",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className={inter.variable}>
      <body className="antialiased bg-gray-50 text-gray-900 min-h-screen flex flex-col font-sans">
        <QueryProvider>
          <TooltipProvider>
            <TopNavBar />
            <main className="flex-1 flex flex-col relative w-full h-full max-w-full overflow-x-hidden">
              {children}
            </main>
            <BottomNavBar />
          </TooltipProvider>
          <Toaster />
        </QueryProvider>
      </body>
    </html>
  );
}
