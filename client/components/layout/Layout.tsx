import Header from "./Header";
import Footer from "./Footer";
import { ReactNode } from "react";

export default function Layout({ children }: { children: ReactNode }) {
  return (
    <div className="min-h-screen flex flex-col bg-gradient-to-b from-indigo-950 via-slate-950 to-black text-foreground">
      <Header />
      <main className="flex-1">{children}</main>
      <Footer />
    </div>
  );
}
