import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Lerno - Learn with Fun and Play",
  description: "The ultimate gamified learning platform for kids. Master math, science, and vocabulary through fast-paced mini-games and real-time battles.",
  keywords: "kids learning app, educational games, math games, vocabulary games, quiz battles, edtech",
  openGraph: {
    title: "Lerno - Learn with Fun and Play",
    description: "The ultimate gamified learning platform for kids.",
    type: "website",
  }
};

export default function HomeLayout({ children }: { children: React.ReactNode }) {
  return <>{children}</>;
}
