import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Quiz Battles | Lerno",
  description: "Compete in real-time educational quiz battles against friends or players worldwide.",
};

export default function BattleLayout({ children }: { children: React.ReactNode }) {
  return <>{children}</>;
}
