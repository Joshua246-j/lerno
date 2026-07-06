"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { Home, BookOpen, LineChart, Gamepad2, Store, Users, LogOut } from "lucide-react";
import { cn } from "@/lib/utils";
import { Button } from "@/components/ui/button";
import { useAuth } from "@/features/auth/hooks/useAuth";
import { Logo } from "@/components/ui/Logo";

const NAV_ITEMS = [
  { href: "/home", icon: Home, label: "Home" },
  { href: "/courses", icon: BookOpen, label: "Courses" },
  { href: "/games", icon: Gamepad2, label: "Games" },
  { href: "/store", icon: Store, label: "Store" },
  { href: "/social", icon: Users, label: "Social" },
  { href: "/profile", icon: LineChart, label: "Progress" },
];

export function TopNavBar() {
  const pathname = usePathname();
  const { user, logout } = useAuth();
  
  // Do not show on auth pages or landing page (if we handle that here)
  if (pathname === "/login" || pathname === "/register" || pathname === "/") {
    return null;
  }

  return (
    <div className="hidden md:flex sticky top-0 z-50 w-full bg-white/80 backdrop-blur-md border-b border-gray-100 items-center justify-between px-8 py-4 shadow-sm">
      <div className="flex items-center gap-10">
        <Logo className="scale-75 origin-left" />
        
        <nav className="flex items-center gap-1">
          {NAV_ITEMS.map((item) => {
            const isActive = pathname.startsWith(item.href);
            const Icon = item.icon;

            return (
              <Link
                key={item.href}
                href={item.href}
                className={cn(
                  "flex items-center gap-2 px-4 py-2.5 rounded-xl text-sm font-bold transition-all",
                  isActive 
                    ? "bg-blue-50 text-blue-600" 
                    : "text-gray-500 hover:bg-gray-50 hover:text-gray-900"
                )}
              >
                <Icon className={cn("w-4 h-4", isActive ? "fill-blue-100" : "")} />
                {item.label}
              </Link>
            );
          })}
        </nav>
      </div>

      <div className="flex items-center gap-4">
        {user ? (
          <>
            <div className="flex items-center gap-3">
              <span className="text-sm font-bold text-gray-700">{user.name}</span>
              <img src={`https://api.dicebear.com/7.x/big-ears-neutral/svg?seed=${user.avatarId || 'user'}&backgroundColor=transparent`} className="w-10 h-10 bg-gray-100 rounded-full border border-gray-200" />
            </div>
            <Button variant="ghost" size="icon" onClick={logout} className="text-gray-400 hover:text-red-500 hover:bg-red-50">
              <LogOut className="w-5 h-5" />
            </Button>
          </>
        ) : (
          <>
            <Button asChild variant="ghost" className="font-bold">
              <Link href="/login">Log in</Link>
            </Button>
            <Button asChild className="bg-blue-600 hover:bg-blue-700 rounded-full font-bold">
              <Link href="/register">Sign up</Link>
            </Button>
          </>
        )}
      </div>
    </div>
  );
}
