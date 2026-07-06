import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Mini-Games | Lerno",
  description: "Play engaging educational mini-games like Math Arena and Memory Match to earn coins and trophies.",
};

export default function GamesLayout({ children }: { children: React.ReactNode }) {
  return <>{children}</>;
}
