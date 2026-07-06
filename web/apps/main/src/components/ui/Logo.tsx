import Link from "next/link";
import { cn } from "@/lib/utils";

interface LogoProps {
  className?: string;
  isDark?: boolean;
}

export function Logo({ className, isDark = false }: LogoProps) {
  return (
    <Link href="/" className={cn("flex items-center gap-3 group", className)}>
      <div className="w-10 h-10 md:w-12 md:h-12 bg-gradient-to-br from-[#FFD166] to-[#f59e0b] rounded-full p-1.5 md:p-2 shadow-md group-hover:scale-110 transition-transform shrink-0 flex items-center justify-center">
        <img 
          src="https://cdn.jsdelivr.net/gh/jdecked/twemoji@latest/assets/svg/1f98a.svg" 
          alt="Lerno Mascot"
          className="w-full h-full drop-shadow-sm" 
        />
      </div>
      <span className={cn(
        "text-2xl md:text-3xl font-black tracking-tighter transition-colors",
        isDark ? "text-white" : "text-[#1A1A2E]"
      )}>
        Lerno
      </span>
    </Link>
  );
}
