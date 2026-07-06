"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { Home, BookOpen, LineChart, Gamepad2, Store, Users } from "lucide-react";
import { cn } from "@/lib/utils";

const NAV_ITEMS = [
  { href: "/home", icon: Home, label: "Home" },
  { href: "/courses", icon: BookOpen, label: "Courses" },
  { href: "/games", icon: Gamepad2, label: "Games" },
  { href: "/social", icon: Users, label: "Social" },
  { href: "/profile", icon: LineChart, label: "Progress" },
];

export function BottomNavBar() {
  const pathname = usePathname();

  // Don't show bottom nav on onboarding or auth pages
  if (pathname === "/" || pathname === "/login" || pathname === "/register") {
    return null;
  }

  return (
    <div className="fixed bottom-0 left-0 right-0 z-50 flex justify-center pb-4 px-4 pointer-events-none md:hidden">
      <nav className="flex items-center justify-around w-full max-w-md bg-white rounded-full shadow-[0_8px_30px_rgb(0,0,0,0.12)] px-6 py-3 pointer-events-auto">
        {NAV_ITEMS.map((item) => {
          const isActive = pathname.startsWith(item.href);
          const Icon = item.icon;

          return (
            <Link
              key={item.href}
              href={item.href}
              className="relative flex flex-col items-center justify-center w-12 h-12"
            >
              {isActive && (
                <div className="absolute inset-0 bg-blue-100 rounded-full scale-110" />
              )}
              <Icon
                className={cn(
                  "w-6 h-6 z-10 transition-colors",
                  isActive ? "text-blue-500" : "text-gray-400"
                )}
                strokeWidth={isActive ? 2.5 : 2}
              />
            </Link>
          );
        })}
      </nav>
    </div>
  );
}
